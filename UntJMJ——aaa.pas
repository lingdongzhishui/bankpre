unit UntJMJ;

interface


uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ScktComp;

const
  CARDPAY_BALACETYPE = '2';     //ѡ��Ǯ������� 2-Ǯ��
  CARDPAY_LOADTYPE   = $32;     //Ȧ�潻������
  CARDPAY_KEYID      = $31; 	  //Ȧ����Կ����
  CARDPUR_KEYID      = $31; 	  //������Կ����
  CARDPUR_LOADTYPE   = $33;     //���ѽ�������
  CARDPUR_ISSUERID   = 'C9BDCEF7C9BDCEF7';

  READTIMEOUT = 1;

  FIRSTISSUEDLLNAME  = 'ISSUE_CPU.dll';
  ISAMISSUEDLLNAME   = 'ISSUE_ISAM.dll';
  SECONDISSUEDLLNAME = 'UPDATE_CPU.dll';
  READ0019DLLNAME = 'CPU_READ0019.dll';
  READ0015DLLNAME = 'CPU_READ0015.dll';
type
   TCharAry1 = array [0..255] of char;
  //Ȧ�����
  TCardLoadPara = record
    CardId: string;       //���� 16λ
    Balance: array [0..7] of char;          //��Ƭԭ�н��   8
    CardPayMoney: array [0..7] of char;     //��ֵ���       8
    TransNumber: array [0..3] of char;      //�����������   4
    KeyVersion: array [0..1] of char;       //Ȧ����Կ�汾   2
    KeyAlgorithm: array [0..1] of char;     //Ȧ���㷨��ʶ   2
    Rand: array [0..7] of char;             //�����         8
    MAC1: array [0..7] of char;             //               8
    TerminalNo: string;                     //�ն˱��       12
  end;

  //����
  TCardLoadPara11 = record
    CardId: string;       //���� 16λ
    Balance: array [0..7] of char;          //��Ƭԭ�н��   8
    Cash: array [0..7] of char;             // ���׽��       8
    TransNumber: array [0..3] of char;      //�����������   4
    KeyVersion: array [0..1] of char;       //Ȧ����Կ�汾   2
    KeyAlgorithm: array [0..1] of char;     //Ȧ���㷨��ʶ   2
    Rand: array [0..7] of char;             //�����         8
    MAC1: array [0..7] of char;             //               8
    TerminalChargeSerial: array [0..7] of char;                     //�ն˽������к�
    TerminalNo: array [0..11] of char;
    //TerminalNo: String;
    CashDate:  string;        //�ն˽�������
    CashTime:  string;        //�ն˽���ʱ��
  end;
  function CalPurMAC1(CardLoadPara: TCardLoadPara11; EncrypIP, EncrypPort: string;var MAC:array of byte;  var ErrorStr: string): boolean;  // ����mac1
  function CheckMAC1(CardLoadPara: TCardLoadPara; EncrypIP, EncrypPort: string; var ErrorStr: string): boolean; //
  function CalMAC2(CardLoadPara: TCardLoadPara; EncrypIP, EncrypPort: string;  //����mac2
      var MAC2: array of byte; var ErrorStr: string): boolean;
 


implementation
//��16�����ַ���תΪChar�洢
procedure HexStringtoChar(HexStr: string; var ResCharAry: TCharAry1);
var
  i: integer;
  TemStr: string;
  CharLen: integer;
begin
  CharLen := Round(Length(HexStr) div 2);
  FillChar(ResCharAry, SizeOf(ResCharAry), 0);
  SetLength(TemStr, 3);

  for i := 0 to CharLen - 1 do
  begin
    TemStr[1] := '$';
    TemStr[2] := HexStr[i * 2 + 1];
    TemStr[3] := HexStr[i * 2 + 2];
    ResCharAry[i] := Char(StrToInt(TemStr));
  end;
end;

//У��MAC1
function CheckMAC1(CardLoadPara: TCardLoadPara; EncrypIP, EncrypPort: string; var ErrorStr: string): boolean;
var
  ClientSocket: TClientSocket;
  CheckMac1Command: array [0..57] of char;  //У��ָ��
    CheckMac1CommandStr: array [0..315] of char;  //У��ָ��str
  CharAry1: TCharAry1;
  ResAry: array [0..255] of byte;
  i: integer;
  ReadBuf: boolean;
begin
  Result := false;

  ClientSocket := TClientSocket.Create(nil);
  try
    ClientSocket.Address := EncrypIP;
    ClientSocket.Port := StrToInt(EncrypPort);
    ClientSocket.ClientType := ctBlocking;
    try
      ClientSocket.Open;
    except
      ErrorStr := '���Ӽ��ܻ�ʧ��';
      exit;
    end;

    { �������ܻ�MA1У��ָ�� }
    FillChar(CheckMac1Command, SizeOf(CheckMac1Command), 0);
    //����(58���ֽ�)
    CheckMac1Command[0] := char($00);
    CheckMac1Command[1] := char($38);
    //�������
    CheckMac1Command[2] := char($4D);
    CheckMac1Command[3] := char($56);
    //������
    CheckMac1Command[4] := char($00);
    //��Կ����
    CheckMac1Command[5] := char($00);
    //TVI
    CheckMac1Command[6] := char($20);
    CheckMac1Command[7] := char($00);
    CheckMac1Command[8] := char($05);
    //��䷽ʽ
    CheckMac1Command[9] := char($01);
    //MAC�㷨
    CheckMac1Command[10] := char($04);
    //��ɢ����
    CheckMac1Command[11] := char($01);
    //��ɢ����
    HexStringtoChar(PChar(CardLoadPara.CardId), CharAry1);
    CopyMemory(@CheckMac1Command[12], @CharAry1, 8);
    //�����
    HexStringtoChar(PChar(@(CardLoadPara.Rand)), CharAry1);
    CopyMemory(@CheckMac1Command[20], @CharAry1, 4);
    //�����������
    HexStringtoChar(PChar(@(CardLoadPara.TransNumber)), CharAry1);
    CopyMemory(@CheckMac1Command[24], @CharAry1, 2);
    //8000
    CheckMac1Command[26] := Char($80);
    CheckMac1Command[27] := Char($00);
    //MAC����
    CheckMac1Command[28] := Char($04);
    //MACֵ
    HexStringtoChar(PChar(@(CardLoadPara.MAC1)), CharAry1);
    CopyMemory(@CheckMac1Command[29], @CharAry1, 4);
    //���ݳ��� ��IV��MAC���ݣ��ĳ���
    CheckMac1Command[33] := Char($00);
    CheckMac1Command[34] := Char($17);
    //IV
    CheckMac1Command[35] := Char($00);
    CheckMac1Command[36] := Char($00);
    CheckMac1Command[37] := Char($00);
    CheckMac1Command[38] := Char($00);
    CheckMac1Command[39] := Char($00);
    CheckMac1Command[40] := Char($00);
    CheckMac1Command[41] := Char($00);
    CheckMac1Command[42] := Char($00);
    //�ϴο����
    HexStringtoChar(PChar(@(CardLoadPara.Balance)), CharAry1);
    CopyMemory(@CheckMac1Command[43], @CharAry1, 4);
    //��ֵ���
    HexStringtoChar(PChar(@(CardLoadPara.CardPayMoney)), CharAry1);
    CopyMemory(@CheckMac1Command[47], @CharAry1, 4);
    //����Ǯ��Ȧ�� ��������
    CheckMac1Command[51] := Char($02);
    //�ն˱��
    HexStringtoChar(PChar(CardLoadPara.TerminalNo), CharAry1);
    CopyMemory(@CheckMac1Command[52], @CharAry1, 6);
     bintohex(CheckMac1Command,CheckMac1CommandStr,sizeof(CheckMac1Command));

    {����ָ��}
    try
      ClientSocket.Socket.SendBuf(CheckMac1Command, SizeOf(CheckMac1Command));
    except
      ErrorStr := '����ܻ�����ָ��ʧ��';
      exit;
    end;

    //��ȡ���
    ReadBuf := false;
    FillChar(ResAry, SizeOf(ResAry), 0);
    for i := 0 to READTIMEOUT * 10000000 do
    begin
      Application.ProcessMessages;
      if ClientSocket.Socket.ReceiveBuf(ResAry, SizeOf(ResAry)) > -1 then
      begin
        ReadBuf := true;
        break;
      end;
    end;

    if not ReadBuf then
    begin
      ErrorStr := 'У��MAC1ʱû���յ����ܻ�������Ϣ';
      exit;
    end;

    //У������
    if not ((ResAry[4] = 48) and (ResAry[5] = 48)) then
    begin
      ErrorStr := 'У��MAC1����';
      exit;
    end;

    Result := true;

  finally
    if ClientSocket.Active then ClientSocket.Close;
    ClientSocket.Free;
  end;

end;

//MAC2
function CalMAC2(CardLoadPara: TCardLoadPara; EncrypIP, EncrypPort: string;
  var MAC2: array of byte; var ErrorStr: string): boolean;
var
  ClientSocket: TClientSocket;
  CheckMac2Command: array [0..56] of char;  //У��ָ��
  CharAry1: TCharAry1;
  ResAry: array [0..255] of byte;
  i: integer;
  ReadBuf: boolean;
  DateStr, TimeStr: string;
  TemStr: string;
  TemResTac: array [0..8] of byte;
  ResErrorStr: array [0..255] of byte;
  
begin
  Result := false;

  ClientSocket := TClientSocket.Create(nil);
  try
    ClientSocket.Address := EncrypIP;
    ClientSocket.Port := StrToInt(EncrypPort);
    ClientSocket.ClientType := ctBlocking;
    try
      ClientSocket.Open;
    except
      ErrorStr := '���Ӽ��ܻ�ʧ��';
      exit;
    end;

    { �������ܻ�MA1У��ָ�� }
    FillChar(CheckMac2Command, SizeOf(CheckMac2Command), 0);
    //����(58���ֽ�)
    CheckMac2Command[0] := char($00);
    CheckMac2Command[1] := char($37);
    //�������
    CheckMac2Command[2] := char($4D);
    CheckMac2Command[3] := char($47);
    //������
    CheckMac2Command[4] := char($00);
    //��Կ����
    CheckMac2Command[5] := char($00);
    //TVI
    CheckMac2Command[6] := char($20);
    CheckMac2Command[7] := char($00);
    CheckMac2Command[8] := char($05);
    //��䷽ʽ
    CheckMac2Command[9] := char($01);
    //MAC�㷨
    CheckMac2Command[10] := char($04);
    //����MAC����
    CheckMac2Command[11] := char($04);
    //��ɢ����
    CheckMac2Command[12] := char($01);
    //��ɢ����
    HexStringtoChar(PChar(CardLoadPara.CardId), CharAry1);
    CopyMemory(@CheckMac2Command[13], @CharAry1, 8);
    //�����
    HexStringtoChar(PChar(@(CardLoadPara.Rand)), CharAry1);
    CopyMemory(@CheckMac2Command[21], @CharAry1, 4);
    //�����������
    HexStringtoChar(PChar(@(CardLoadPara.TransNumber)), CharAry1);
    CopyMemory(@CheckMac2Command[25], @CharAry1, 2);
    //8000
    CheckMac2Command[27] := Char($80);
    CheckMac2Command[28] := Char($00);

    //���ݳ��� ��IV��MAC���ݣ��ĳ���
    CheckMac2Command[29] := Char($00);
    CheckMac2Command[30] := Char($1A);
    //IV
    CheckMac2Command[31] := Char($00);
    CheckMac2Command[32] := Char($00);
    CheckMac2Command[33] := Char($00);
    CheckMac2Command[34] := Char($00);
    CheckMac2Command[35] := Char($00);
    CheckMac2Command[36] := Char($00);
    CheckMac2Command[37] := Char($00);
    CheckMac2Command[38] := Char($00);
    //��ֵ���
    HexStringtoChar(PChar(@(CardLoadPara.CardPayMoney)), CharAry1);
    CopyMemory(@CheckMac2Command[39], @CharAry1, 4);
    //����Ǯ��Ȧ�� ��������
    CheckMac2Command[43] := Char($02);
    //�ն˱��
    HexStringtoChar(PChar(CardLoadPara.TerminalNo), CharAry1);
    CopyMemory(@CheckMac2Command[44], @CharAry1, 6);
    //����
    DateStr := FormatDateTime('yyyymmdd', Now);
    HexStringtoChar(PChar(DateStr), CharAry1);
    CopyMemory(@CheckMac2Command[50], @CharAry1, 4);
    //ʱ��
    TimeStr := FormatDateTime('hhmmss', Now);
    HexStringtoChar(PChar(TimeStr), CharAry1);
    CopyMemory(@CheckMac2Command[54], @CharAry1, 3);

    {����ָ��}
    try
      ClientSocket.Socket.SendBuf(CheckMac2Command, SizeOf(CheckMac2Command));
    except
      ErrorStr := '����ܻ�����ָ��ʧ��';
      exit;
    end;

    //��ȡ���
    ReadBuf := false;
    FillChar(ResAry, SizeOf(ResAry), 0);
    for i := 0 to READTIMEOUT * 10000000 do
    begin
      Application.ProcessMessages;
      if ClientSocket.Socket.ReceiveBuf(ResAry, SizeOf(ResAry)) > -1 then
      begin
        ReadBuf := true;
        break;
      end;
    end;

    if not ReadBuf then
    begin
      ErrorStr := '����MAC2ʱû���յ����ܻ�������Ϣ';
      exit;
    end;

    //��������
    if not ((ResAry[4] = 48) and (ResAry[5] = 48)) then
    begin
      ErrorStr := '����MAC2ʧ��';
      exit;
    end;

    //У��MAC2
    FillChar(MAC2, SizeOf(MAC2), 0);
    CopyMemory(@MAC2, @ResAry[6], 4);


    Result := true;
  finally
    if ClientSocket.Active then ClientSocket.Close;
    ClientSocket.Free;
  end;
end;

//����ͣ���1
 function CalPurMAC1(CardLoadPara: TCardLoadPara11; EncrypIP, EncrypPort: string;var MAC:array of byte;  var ErrorStr: string): boolean;
var
  ClientSocket: TClientSocket;
  CheckMac1Command: array [0..157] of char;  //У��ָ��
  CheckMac1CommandStr: array [0..315] of char;  //У��ָ��str
  CharAry1: TCharAry1;
  ResAry: array [0..255] of byte;
  i: integer;
  ReadBuf: boolean;
  ResArychar: array [0..512] of char;
  ResAryStr:string;

  FJMJOBU_MACTmp:array [0..7] of char;

  TmpRand,TmpTransNumber,TmpTerminalChargeSerial,TmpTerminalNo,Tmpcashdate,Tmpcashtime:string;
begin
  Result := false;

  ClientSocket := TClientSocket.Create(nil);
  try
    ClientSocket.Address :=EncrypIP;
    ClientSocket.Port := StrToInt(EncrypPort);
    ClientSocket.ClientType := ctBlocking;
    try
      ClientSocket.Open;
    except
      ErrorStr := '���Ӽ��ܻ�ʧ��';
      exit;
    end;


    { �������ܻ�MA1У��ָ�� }
    FillChar(CheckMac1Command, SizeOf(CheckMac1Command), 0);
    //����(58���ֽ�)
    CheckMac1Command[0] := char($00);
    CheckMac1Command[1] := char($37);
    //�������
    CheckMac1Command[2] := char($4D);
    CheckMac1Command[3] := char($47);
    //������
    CheckMac1Command[4] := char($00);
    //��Կ����
    CheckMac1Command[5] := char($00);
    //TVI
    CheckMac1Command[6] := char($A1);
    CheckMac1Command[7] := char($00);
    CheckMac1Command[8] := char($08);
    //��䷽ʽ
    CheckMac1Command[9] := char($01);
    //MAC�㷨
    CheckMac1Command[10] := char($04);
    //MAC����
    CheckMac1Command[11] := Char($04);
    //��ɢ����
    CheckMac1Command[12] := char($01);
    //��ɢ����
    HexStringtoChar(PChar(CardLoadPara.CardId), CharAry1);
    CopyMemory(@CheckMac1Command[13], @CharAry1, 8);
    //�����
    HexStringtoChar(PChar(@(CardLoadPara.Rand)), CharAry1);
    CopyMemory(@CheckMac1Command[21], @CharAry1, 4);
    //�����������
    HexStringtoChar(PChar(@(CardLoadPara.TransNumber)), CharAry1);
    CopyMemory(@CheckMac1Command[25], @CharAry1, 2);
    //�ն˽������к�
    HexStringtoChar(PChar(@(CardLoadPara.TerminalChargeSerial)), CharAry1);
    CopyMemory(@CheckMac1Command[27], @CharAry1[2], 2);

    //���ݳ��� ��IV��MAC���ݣ��ĳ���
    CheckMac1Command[29] := Char($00);
    CheckMac1Command[30] := Char($1A);
    //IV
    CheckMac1Command[31] := Char($00);
    CheckMac1Command[32] := Char($00);
    CheckMac1Command[33] := Char($00);
    CheckMac1Command[34] := Char($00);
    CheckMac1Command[35] := Char($00);
    CheckMac1Command[36] := Char($00);
    CheckMac1Command[37] := Char($00);
    CheckMac1Command[38] := Char($00);




   //�������    4
    HexStringtoChar(PChar(@(CardLoadPara.cash)), CharAry1);
    CopyMemory(@CheckMac1Command[39], @CharAry1, 4);
    //�������ͱ�ʶ    1
    CheckMac1Command[43] := Char($09);
    //�ն˱��         6
    HexStringtoChar(PChar(@(CardLoadPara.TerminalNo)), CharAry1);
    CopyMemory(@CheckMac1Command[44], @CharAry1, 6);
     //�ն˽�������      4
    HexStringtoChar(PChar(CardLoadPara.cashdate), CharAry1);
    CopyMemory(@CheckMac1Command[50], @CharAry1, 4);

    //�ն˽���ʱ��      3
    HexStringtoChar(PChar(CardLoadPara.cashtime), CharAry1);
    CopyMemory(@CheckMac1Command[54], @CharAry1, 3);

     bintohex(CheckMac1Command,CheckMac1CommandStr,sizeof(CheckMac1Command));

     bintohex(CheckMac1Command,CheckMac1CommandStr,sizeof(CheckMac1Command));

    {����ָ��}
    try
      ClientSocket.Socket.SendBuf(CheckMac1Command, SizeOf(CheckMac1Command));
    except
      ErrorStr := '����ܻ�����ָʧ��';
      exit;
    end;

    //��ȡ���
    ReadBuf := false;
    FillChar(ResAry, SizeOf(ResAry), 0);
    for i := 0 to READTIMEOUT * 10000000 do
    begin
      Application.ProcessMessages;
      if ClientSocket.Socket.ReceiveBuf(ResAry, SizeOf(ResAry)) > -1 then
      begin
        ReadBuf := true;
        break;
      end;
    end;

    if not ReadBuf then
    begin
      ErrorStr := 'У��MAC1ʱû���յ����ܻ�������Ϣ';
      exit;
    end;


     FillChar(ResArychar, SizeOf(ResArychar), 0);
    CopyMemory(@ResArychar, @ResAry, sizeof(ResAry));
    ResAryStr:=ResArychar;
    //У������
    if not ((ResAry[4] = 48) and (ResAry[5] = 48)) then
    begin
      ErrorStr := '����MAC1����';

      exit;
    end
    else
    begin
          FillChar(MAC, SizeOf(MAC), 0);
          CopyMemory(@MAC, @ResAry[6], 4);
    end;

    Result := true;
  finally
    if ClientSocket.Active then ClientSocket.Close;
    ClientSocket.Free;
  end;

end;

end.
 