unit Uwork;

interface
uses
  Windows, Classes, SysUtils, IniFiles,ETCBANK_interface,SyncObjs,IdHashMessageDigest,DCPcrypt2, DCPblockciphers, DCPdes,ADODB;
type
     TOutputKey = record
    Keys: array [0..12] of array [0..32] of char;
   end;
   POutputKey = ^TOutputKey;
   
    TCardInfo = packed record
    ID  :string[30];        //卡ID
  end;
  PCardInfo = ^TCardInfo;

tmainclass = class(TComponent)

public
         LogXHCS :TCriticalSection ;
         bdatabaseconnect:boolean;
         errorlist:tstringlist;
         nodeid:string;
         defaultkey:string;

         NetWorkID:string;
         TerminalID:string;
         bankid:string;
         bankname:string;
         bankserverip:string;
         bankserverport:integer;
         bflagerrorlog,bflagdebuglog,bflagworklog:Boolean;
         SJMJSERVERIP,SJMJPORT:string;
         debug:Integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

function ByteToHex(Src: Byte): String;
function inttobigint(i_value:integer):integer;
procedure WriteLog(Str: String);
procedure WriteerrorLog(Str: String);
function hextodec(value:string):string;
procedure strtobyte(var aa:array of Byte;str:string;itype:Byte);
procedure strdectobyte(var aa:array of Byte;str:string;itype:Byte);overload;


function bytetostr(aa:array of Byte):string;
function randstr(count:byte):string;
function getmd5(strfile:string):string;overload;
function getmd5(strfile:TStream):string;overload;
function getfilemd5(strfile:string):string;
function Encryptbcb(var key:array of byte;InData:array of byte; var OutData:array of byte):Boolean;
function Decryptbcb(var key:array of byte;InData:array of byte; var OutData:array of byte):Boolean;
function dbuftobuf(var indata:array of Byte ;var outdata:array of byte;index:integer):boolean;
function arraytostr(arr:array of byte):string;
function arraytostr1(arr:array of byte):string;
function padl(mystr:string;mycount:integer;mychar:pchar):string;  //左补指定符到指定长度
function padr(mystr:string;mycount:integer;mychar:pchar):string;  //左补指定符到指定长度
function yxsj(str:string):string;
function opendataset(qry:tadoquery;sqlstr:string):Boolean;
function errorname(errorcode:string):string;
function BytestoHexString(ABytes: array of byte; len: Integer): AnsiString;

//定义取密钥函数




end;
var

  mainclass:tmainclass;

implementation
function tmainclass.ByteToHex(Src: Byte): String;

begin
  SetLength(Result, 2);
  asm
    MOV         EDI, [Result]
    MOV         EDI, [EDI]
    MOV         AL, Src
    MOV         AH, AL          // Save to AH
    SHR         AL, 4           // Output High 4 Bits
    ADD         AL, '0'
    CMP         AL, '9'
    JBE         @@OutCharLo
    ADD         AL, 'A'-'9'-1
    @@OutCharLo:
    AND         AH, $f
    ADD         AH, '0'
    CMP         AH, '9'
    JBE         @@OutChar
    ADD         AH, 'A'-'9'-1
    @@OutChar:
    STOSW
  end;
end;
constructor tmainclass.Create(AOwner: TComponent);
begin
    inherited;
    LogXHCS:=TCriticalSection.Create;
    errorlist:=Tstringlist.Create;
end;

destructor tmainclass.Destroy;
begin
   LogXHCS.Free;
   errorlist.Free;
  inherited;
end;

function tmainclass.inttobigint(i_value:Integer):integer;
var
I: Integer;
    str:string;
    tmpstr:string;
begin
    str:=IntToHex(i_value,16);
    str:=Copy(str,9,8);
    for i:=4 downto 1 do
    begin
        tmpstr:=tmpstr+copy(str,i*2-1,2);
    end;
    str:=tmpstr;
    Result:=StrToInt(hextodec(str));

end;
Function tmainclass.HexToDec(Value:string):string;
CONST HEX : ARRAY['A'..'F'] OF INTEGER =
(10,11,12,13,14,15);
VAR
  str:String;
  i,i_value : integer;
BEGIN
  i_value:=0;
  str:=value;
  FOR i := 1 TO Length(str) DO
    IF str[i]<'A' THEN
    i_value:=i_value* 16 + ORD(str[i])-48
  ELSE
    I_value:=i_value * 16 + HEX[str[i]];

  Result := IntToStr(i_value);

end;

procedure tmainclass.WriteerrorLog(Str: String);
var
  tmpStr,
  tmpName: String;
  SystemTime: TSystemTime;
  fsm       : TextFile;
begin
    if not bflagerrorlog then exit;
    LogXHCS.Acquire;
    try
  if Str='' then Exit;
  tmpName := ExtractFilePath(ParamStr(0))+'errlog\';   


   
  if not DirectoryExists(tmpName) then
  begin
    if IOResult = 0 then
      MkDir(tmpName);
  end;

  if DirectoryExists(tmpName) then
  begin
    GetLocalTime(SystemTime);
    with SystemTime do
      tmpName := tmpName + Format('%.4d%.2d%.2d',[wYear,wMonth,wDay]);

    with SystemTime do
      tmpStr := Format('%.2d:%.2d:%.2d_%.3d   ',[wHour, wMinute, wSecond, wMilliSeconds]);
    tmpStr := tmpStr + Str;



    begin
      {$I-}
      AssignFile(fsm, tmpName);
      try
        if FileExists(tmpName) then
          Append(fsm)
        else ReWrite(fsm);
        Writeln(fsm,tmpStr);
      finally
        CloseFile(fsm);
        {$I+}
      end;
    end;
  end;
  finally
       LogXHCS.Release;
  end;
end;
procedure tmainclass.WriteLog(Str: String);
var
  tmpStr,
  tmpName: String;
  SystemTime: TSystemTime;
  fsm       : TextFile;
begin
    if not bflagworklog then exit;
  if Str='' then Exit;
  tmpName := ExtractFilePath(ParamStr(0))+'worklog\';



  if not DirectoryExists(tmpName) then
  begin
    if IOResult = 0 then
      MkDir(tmpName);
  end;

  if DirectoryExists(tmpName) then
  begin
    GetLocalTime(SystemTime);
    with SystemTime do
      tmpName := tmpName + Format('%.4d%.2d%.2d%.2d',[wYear,wMonth,wDay,wHour]);

    with SystemTime do
      tmpStr := Format('%.2d:%.2d:%.2d_%.3d   ',[wHour, wMinute, wSecond, wMilliSeconds]);
    tmpStr := tmpStr + Str;
    begin
      {$I-}
      AssignFile(fsm, tmpName);
      try
        if FileExists(tmpName) then
          Append(fsm)
        else ReWrite(fsm);
        Writeln(fsm,tmpStr);
      finally
        CloseFile(fsm);
        {$I+}
      end;
    end;
  end;
end;

procedure tmainclass.strtobyte(var aa: array of Byte; str: string;itype:byte);
var
    i,icount:integer;
    b1:string;
begin
    icount:=High(aa);
    for i:=0 to icount do
    begin
        b1:=Copy(str,i*itype+1,itype);
        if b1<>'' then
            aa[i]:=StrToInt((b1))
        else
            aa[i]:=0;
    end;
end;

function tmainclass.randstr(count: byte): string;
var
    i,i_list:integer;
begin
    result:='';
    for i:=1 to count do
    begin
        i_list:=1+random(9);
        result:=result+copy(inttostr(i_list),1,1);

    end;
end;

function tmainclass.bytetostr(aa: array of Byte):string;
var
    i,icount:integer;
    b1:string;
begin
    icount:=High(aa);
    for i:=0 to icount do
    begin

        if aa[i]>0 then
            b1:=IntToStr(aa[i])
        else
            b1:='00';
        Result:=result+b1;
    end;
end;
///AAAAAAA///
function tmainclass.getmd5(strfile: string): string;
var
    filemd5:TIdHashMessageDigest5;

begin
    filemd5:=TIdHashMessageDigest5.Create; //必须先初始化
    result:=filemd5.AsHex(filemd5.HashValue(strfile));
    filemd5.Free;
end;


function tmainclass.Encryptbcb(var key:array of byte;InData:array of byte; var OutData:array of byte): Boolean;
var
  Cipher: TDCP_3des;
  Block: array[0..7] of byte;
  Block1: array[0..7] of byte;
  aratmp:array[0..7]  of byte;
  i,j:integer;
begin
  //  result:=false;
    try
    Cipher:= TDCP_3des.Create(nil);
    try
    Cipher.Init(Key,Sizeof(Key)*8,nil);
    aratmp[1]:=$0;
    aratmp[2]:=$0;
    aratmp[3]:=$0;
    aratmp[4]:=$0;
    aratmp[5]:=$0;
    aratmp[6]:=$0;
    aratmp[7]:=$0;
    aratmp[0]:=$0;
    Cipher.SetIV(aratmp);
    FillChar(OutData,SizeOf(outdata),0);
  //  i:=High(indata) mod 8;
  //  if i=0 then i:=8;

    for j:=0 to length(indata) div 8 do
    begin
      // 判断最后一组
        if j=Length(InData) div 8 then
        begin
            i:=length(indata) mod 8;

            Move(indata[j*8],Block1,i);

//                Move(indata[j*8]+i,Block1,8-i);
            FillChar(Block1[i],8-i,Byte(8-i));


        end
        else
           Move(indata[j*8],Block1,8);
      if j>0 then
          XorBlock(Block1,Block,8)
      else
          XorBlock(Block1,aratmp,8);
      Cipher.Encryptecb(Block1,Block);

      Move(Block,OutData[j*8],8);
    end;
    finally
    Cipher.Free;
    end;

    except

    end;
    result:=true;
end;

function tmainclass.Decryptbcb(var key:array of byte; InData: array of byte;
  var OutData: array of byte): Boolean;
var
  Cipher: TDCP_3des;
  Block: array[0..7] of byte;
  Block1: array[0..7] of byte;
  aratmp:array[0..7] of byte;
  j:integer;
begin

  //  result:=false;
    try

    Cipher:= TDCP_3des.Create(nil);
    try
    Cipher.Init(Key,Sizeof(Key)*8,nil);
    aratmp[1]:=$0;
    aratmp[2]:=$0;
    aratmp[3]:=$0;
    aratmp[4]:=$0;
    aratmp[5]:=$0;
    aratmp[6]:=$0;
    aratmp[7]:=$0;
    aratmp[0]:=$0;
    Cipher.SetIV(aratmp);
    FillChar(OutData,length(OutData),0);
    for j:=0 to Length(indata) div 8-1 do
    begin
      Move(InData[j*8],Block1,8);
      Cipher.Decryptecb(Block1,Block);
      if j>0 then
          XorBlock(Block,indata[(j-1)*8],8)              
      else
          XorBlock(Block,aratmp,8);



           Move(Block,outdata[j*8],8);
//      Move(Block1,outdata[j*8],8);

    end;
//    i:=Length(outdata)-outdata[High(outdata)];


    finally
    Cipher.Free;
    end;
//    setlength(OutData,80);
    except

    end;
    result:=true;
end;

function tmainclass.dbuftobuf(var indata:array of byte; var outdata:array of byte;index:integer): boolean;
var
    i:integer;
begin
    for i:=0 to Length(indata)-1 do
    begin
        outdata[index+i]:=indata[i];
    end;
    result:=true;
end;

function tmainclass.arraytostr(arr: array of byte): string;
var i:integer;
begin
    result:='';
    for i:=0 to High(arr) do
    begin
        result:=result+inttohex(arr[i],2);
    end;
end;

function tmainclass.padl(mystr: string; mycount: integer;
  mychar: pchar): string;
var
    padl_i:integer;
    str_tmp:string;
begin
     if length(mystr)<mycount then
     str_tmp:='';
     begin
         for padl_i:=0 to mycount-length(mystr)-1 do
         begin
             str_tmp:=str_tmp+mychar;
         end;
     end;
     result:=str_tmp+mystr;
end;

function tmainclass.yxsj(str: string): string;
begin
    if str='' then

        Result:='0'
    else
        result:=trim(str);
end;

function tmainclass.opendataset(qry:tadoquery;sqlstr: string): Boolean;
begin
    with qry do
    begin
        close;
        sql.text:=sqlstr;
        try
            open;
        except
            self.WriteerrorLog(sqlstr);
        end;
    end;
    result:=true;
end;

function tmainclass.errorname(errorcode: string): string;
var
    i_error:integer;

begin
    i_error:=StrToInt(errorcode);
    case i_error of
        00:result:='成功';
        01:result:='图片上传失败';
        02:result:='用户登录校验失败';
        08:Result:='分配金额大于账户余额';
        09:result:='三方前置机失败';
        10:result:='快通卡查询错误';
        11:result:='快通卡已列入黑名单';
        12:result:='快通卡已挂失';
        13:result:='快通卡已注销';
        14:result:='密码不符';
        15:result:='该卡不需要延期';
        16:result:='快通卡不可用';
        17:result:='余额不足';
        18:result:='车牌号不存在';
        19:result:='车牌号查询错误';
        20:result:='银行账户不存在';
        21:result:='签约关系已存在';
        22:result:='签约关系不存在';
        23:result:='停止代理';
        24:result:='银行账户状态有误';
        25:result:='流水号重复';
        26:result:='金额不符';
        27:result:='记录数不符';
        28:result:='报文格式有误';
        29:result:='解约失败';
        30:result:='密钥申请失败';
        31:result:='银行发行失败';
        32:result:='流水号不存在';
        33:result:='发票打印失败';
        34:result:='发票重打印失败';
        35:result:='发票号重复';
        36:result:='充值发票重打印票号重复';
        37:result:='终端不存在';
        38:result:='终端不可用';
        39:result:='终端未签到';
        40:result:='不满足一车一卡';
        41:result:='快通卡已发行';
        42:result:='快通卡加入黑名单失败';
        43:result:='用户证件不符';
        44:result:='被补卡的原卡号不存在';
        45:result:='联名卡补发失败';
        46:result:='MD5校验不通过';
        47:result:='解密错误';
        48:result:='未找到指定文件';
        49:result:='此流水已经打印，请使用重打功能';
        50:result:='没有需要打印的数据';
        51:result:='时间不对,不能打印';
        52:result:= '设备不存在';
        53:result:='修改密码失败';
        54:result:='密码不符';
        55:result:='用户号不存在';
        56:result:='账户余额查询失败';
        57:result:='账户查询失败';
        58:result:='此用户没有快通卡';
        59:result:='账户余额错误';
        60:result:='数据库错误 ';
        61 :result:='本时段不允许做该交易';
        62 :result:='已签约 ';
        63 :result:='输入银行账号非卡介质';
        64 :result:='输入银行账号和选择账号类型不符';
        65 :result:='该银行卡是信用卡黑名单数据,不允许签约';
        66 :result:='银行账户状态检查失败  ';
        67 :result:='卡状态不正常 ';
        68 :result:='账户状态不正常';
        69 :result:='挂失状态不正常 ';
        70 :result:='冻结状态不正常';
        71 :result:='输入证件号码和银行记录不符';
        72 :result:='输入有效期错误 ';
        73 :result:='与签约时登记信息不符 ';
        74 :result:='签约状态不正常';
        75 :result:='已解约';
        76 :result:='银行卡与ETC卡客户姓名不符';
        77 :result:='银行卡与ETC卡客户证件号码不符';
        78 :Result:='银行卡客户姓名与银行登记信息不符';
        79 :Result:='银行卡客户证件号码与银行登记信息不符';
        80 :Result:='该银行卡暂不支持办理ETC业务';
        81 :result:='银行账户黑名单';
        82 :Result:='该银行卡存在核销账户，不允许办理ETC业务';
        83 :Result:='银行卡状态异常';
        84 :Result:='银行卡授信额度较低';
        85 :Result:='可用额度低于3000元，请还款后办理';
      // 97 :result:='	已添加黑名单';
      //  98 :result:='	该卡号为非黑名单数据 ';
        89:result:='获取银行加密因子失败';
        90:result:='签到失败';
        91:result:='充值失败';
        92:result:='对账文件解析失败';
        93:result:='冲正失败';
        94:result:='未获取加密因子';
        95:result:='MAC1校验错误';
        96:result:='MAC计算失败!!';
        97:result:='设备校验失败';
        98:result:='账户充值失败';
        99:result:='其它错误';



     end;
     errorcode:=result;
end;

function tmainclass.padr(mystr: string; mycount: integer;
  mychar: pchar): string;
var
    padl_i:integer;
    str_tmp:string;
begin
     if length(mystr)<mycount then
     str_tmp:='';
     begin
         for padl_i:=0 to mycount-length(mystr)-1 do
         begin
             str_tmp:=str_tmp+mychar;
         end;
     end;
     result:=mystr+str_tmp;
end;


function tmainclass.BytestoHexString(ABytes: array of byte;
  len: Integer): AnsiString;
begin
  SetLength(Result, len*2);
  BinToHex(@ABytes[0], PAnsiChar(Result), len);
end;
function tmainclass.getmd5(strfile: TStream): string;
var
    filemd5:TIdHashMessageDigest5;

begin
    filemd5:=TIdHashMessageDigest5.Create; //必须先初始化
    result:=filemd5.AsHex(filemd5.HashValue(strfile));
    filemd5.Free;
end;

function tmainclass.getfilemd5(strfile:string): string;
var
    filestream:TStream;
begin
    filestream:=TfileStream.Create(strfile,fmOpenRead);
    result:=getmd5(filestream);

end;

function tmainclass.arraytostr1(arr: array of byte): string;
var i:integer;
begin
    result:='';
    for i:=0 to High(arr) do
    begin
        result:=result+char(arr[i]);
    end;
end;

procedure tmainclass.strdectobyte(var aa: array of Byte; str: string;
  itype: Byte);
var
    i,icount:integer;
    b1:string;
begin
    icount:=High(aa);
    for i:=0 to icount do
    begin
        b1:=Copy(str,i*itype+1,itype);
        if b1<>'' then
            aa[i]:=StrToInt('0x'+b1)
        else
            aa[i]:=0;
    end;
end;



initialization
    mainclass:=tmainclass.Create(nil);
finalization
    mainclass.Free;

end.
