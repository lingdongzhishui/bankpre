
unit UnitProcessList;

interface

uses
  Windows, Messages, SysUtils, Classes,Forms,Dialogs,IniFiles ,IdFTP, IdFTPCommon,U_OpDB,StdCtrls,strutils,uwork,DateUtils;

const
  IniFileName ='control.ini';

  {FTP�������}
  RunOK       = 0;   {�ɹ�}
  CanNotConn  = -1;  {���Ӳ���}
  OtherErr    = -2;  {��������}
  NoThisFile  = -3;  {û���ҵ��ļ�}

  ConnTimeOut = 60;   {���ӳ�ʱʱ��}

  DateTimeFormat  =   'yyyy-mm-dd hh:nn:ss';
  SDateFormat     =   'yyyy-mm-dd';
  STime = ' 08:00:00';
  ETime = ' 07:59:59';

  Decollator='|';            //�ָ����

type
  {�ļ�ͷ��Ϣ}
  RFilePack=record
    DirectTag:string;       //�������
    FileName:String;        //�ļ�����
    SendBh:string;          //���ͱ��
    ReceiveBh:string;       //���շ����
    Optime:string;          //�����ļ�����ʱ��
    SubPackCout:Integer;    //�Ӱ�����
    Jym:string;             //У����
  end;

  {�Ӱ�ͷ��Ϣ}
  RsubPack=record
    subCode:Integer;        //�Ӱ�����
    tableName:string;       //��Ӧ�ı���
    recCount:Integer;       //��¼��
    opertype:string;        //�������� i ����d ɾ�� u����
    opersql:String;         //����sql���
  end;

  TProcessList = class

  private
    SendCode  : string;
    fIpAddr   : string;
    fFtpPort  : integer;
    fUserName : string;
    fPassWord : string;
    FTPUFolder : string;
    FTPDFolder : string;
    LocalUFolder : string;
    LocalDFolder : string;
    DYearFolder : string;
   FYearFolder :string;
    UYearFolder : string;
    LogYearFolder : string;
    fIDFtp : TIdFTP;

    tmpOpDB:TOpDB;
    DbName : string;
    DbIpAddr : string;
    DbType : integer;
    DbUser : string;
    DbPassword : string;
    FLastUpTime: string;
    FIsLog: Integer;
    procedure CreateFTPCtrl;
    procedure CreateDBCtrl;
    procedure SetConnected(Value: Boolean);

    function  GetConnected: Boolean;

    function  ConverStr(Str:string;Len:integer;AddChar:Char;Flag:integer):string;
    function QueryCardExists(aCardID:string):boolean;
    procedure SetLastUpTime(aLastUpTime: string);

    {�����Ӱ������巵�ؼ�������У�������}

    function  GenSubBodyFile(FileCode:Integer; BankID,WorkDate,filename,tabname:String; var FileStr:String):Boolean;

    {���浥����¼�����ݿ���}

   // function  SaveFileDb(StrtableId:Integer;StrValue:String):boolean;
    function  getDecryptdata (str:string ):string;

  public
    OpDB   : TOpDb;
    ErrorCode : Integer;
    ErrorStr  : string;
    CheckTime : integer;
    OffSetDay : integer;
    StartDate ,
    EndDate   : string;
    txtFile  : TextFile;  //�ļ�
    qs_verifycode:string;
    DownRecordNum:integer;
    procedure CreateYearFolder;
    function  DownLoadFile(DFileName:string) : integer;
    function  UpLoadFile(UFileName:String) : integer;
    function Getfilename:string;
    procedure RollBackLoadFile(UFileName: string);
    {���������ļ�}
    Procedure ProcessDownFile(FileName:string);

    {��ѯ���ݿ��и��ļ��Ƿ񱣴�}
    function  FindBankTransList(FileType:String;BankID:Integer;Date:TDateTime) : Boolean;

    function  ProcessUpFile(BankID,WorkDate,FileType,tabname:String;var FileName,sPath: string) : Boolean;

    Procedure WriteLog(Str:String);
     function  SaveFileDb(StrtableId:Integer;StrValue:String;filename:string):boolean;
    procedure LoadParam;

    Constructor Create;

    Destructor Destroy;override;

    procedure ClearDateTime;

    {���ɽ����ļ�}
    function  GenerationFile(FileType,SendCode,ReceiveCode,WorkDate,tabname:string;var FileName,Spath:String):Boolean;


   Published

    property DbConnected: Boolean read GetConnected write SetConnected;

    property LastUpTime: string read FLastUpTime write SetLastUpTime;
  end;

var
  ProcessList1 : TProcessList;
 function getCupCardKey(cardNoHex:PChar;ipAdr:PChar;outputKey:POutputKey):boolean;  cdecl	;  external 'EtcCom.dll';
 function GetFileEditTime(const FileName: String): TDateTime;
 function GetFileCreationTime(const FileName: String): TDateTime;
implementation

uses dm,u_work;

{ TProcessList }

procedure TProcessList.ClearDateTime;
var
  Inif  : TIniFile;
begin
  Inif:= TIniFile.Create(ExtractFilePath(Application.ExeName)+IniFileName);
  try
    Inif.WriteString('FTP����','��ʼ����','');
    Inif.WriteString('FTP����','��������','');
  finally
    FreeAndNil(Inif);
  end;
end;

{���涨��ʽ�����ַ���,λ�����㲹AddChar��flag=1�󲹣�flag=2�Ҳ�}

function TProcessList.ConverStr(Str: string; Len: integer; AddChar: Char;
  Flag: integer): string;
var
  i,tLen:integer;
begin
  result := Str;
  tLen := Length(Str);
  if tLen = Len then exit;
  if tLen > Len then
  begin
    result := copy(Str,1,Len);
    exit;
  end;
  for i := 1 to Len - tLen do
  begin
    if Flag = 1 then result := AddChar + result;
    if Flag = 2 then result := result + AddChar;
  end;
end;

constructor TProcessList.Create;
begin
//WriteLog('׼�����ز���');
 LoadParam;
             {��ȡ�����ļ�����}
//  WriteLog('��ʼ��ftp') ;
  CreateFTPCtrl;
         {��ʼ��ftp}
 // WriteLog('��ʼ�����ݿ�')  ;
  CreateDBCtrl;            {��ʼ�����ݿ�}
 // WriteLog('�����ϴ������ء���־�ļ���');
  CreateYearFolder;        {�����ϴ������ء���־�ļ���}
 
  ErrorCode:=0;
  ErrorStr:='';
end;

procedure TProcessList.CreateDBCtrl;
begin
  OpDB            := TOpDb.Create(DbType);
  OpDb.DBName     := DbName;
  OpDb.DBIP       := DbIpAddr;
  OpDb.DBUser     := DbUser;
  OpDb.DBPassword := DbPassword;
  tmpOpDB            := TOpDb.Create(DbType);
  tmpOpDB.DBName     := DbName;
  tmpOpDB.DBIP       := DbIpAddr;
  tmpOpDB.DBUser     := DbUser;
  tmpOpDB.DBPassword := DbPassword;

end;

procedure TProcessList.CreateFTPCtrl;
begin
  fIDFtp := TIDFtp.Create(nil);
  fIDFtp.Host     := fIpAddr;
  fIDFtp.Port     := fFtpPort;
  fIDFtp.Username := fUserName;
  fIDFtp.Password := fPassword;
  fIDFtp.Passive  := False;
end;

{�����ϴ������ء���־�ļ���}
procedure TProcessList.CreateYearFolder;
var
  sYear,sMonth,sDay:Word;
  LogPath : string;
begin

  if not DirectoryExists(LocalUFolder) then mkdir(LocalUFolder);

   if not DirectoryExists(LocalDFolder) then mkdir(LocalDFolder);

   DecodeDate(Now,sYear,sMonth,sDay);

   UYearFolder:= LocalUFolder+'\'+InttoStr(sYear);

  // FYearFolder:='download\'+InttoStr(sYear);

   FTPUFolder:= FTPUFolder+'\'+InttoStr(sYear);
   FTPDFolder:= FTPDFolder+'\'+InttoStr(sYear);

   if not  DirectoryExists('ftpdir\'+FTPDFolder) then mkdir('ftpdir\'+FTPDFolder);
   if not  DirectoryExists('ftpdir\'+FTPUFolder) then mkdir('ftpdir\'+FTPUFolder);

   if not DirectoryExists(UYearFolder) then mkdir(UYearFolder);

   DYearFolder:= LocalDFolder+'\'+InttoStr(sYear);

   if not DirectoryExists(DYearFolder) then mkdir(DYearFolder);
   LogPath := ExtractFilePath(Application.ExeName)+ 'Logs';

   if not DirectoryExists(LogPath) then mkdir(LogPath);

   LogYearFolder := LogPath +'\'+inttostr(sYear);
      
   if not DirectoryExists(LogYearFolder) then mkdir(LogYearFolder);
end;



destructor TProcessList.Destroy;
begin
  freeandnil(fIDFtp);
  freeandnil(OpDB);
  freeandnil(tmpOpDB);
  inherited;
end;

function TProcessList.DownLoadFile(DFileName: string): integer;
var
  ListStr,ListStr2 : TStringList;
 // i,j: integer;
  FtpFileName : String;
begin
  result := NoThisFile;
  try
    fIDFtp.Connect(true,ConnTimeOut);
  except on e:exception do
  begin
    result := cannotConn;
     WriteLog(DFileName+'DownLoadFile  BBBB'+e.message);
    exit;
  end;
  end;
  {if not fIDFtp.Connected then
  begin
    result := cannotConn;
    exit;
  end; }
  ListStr := TStringList.Create;
  ListStr2 := TStringList.Create;
  try
    ListStr.Clear;
    WriteLog(FTPDFolder);
  try

    fIdFtp.ChangeDir(FTPDFolder);
    fIdFtp.TransferType := ftASCII;
    
    fIdFtp.Get(DFileName,Tfilename(DYearFolder+'\'+trim(DFileName)),true);
      result := RunOK;
      exit;
    except on e:exception do
    begin
      result := NoThisFile;
      WriteLog(trim(DFileName)+'����ʧ��1!!!'+e.message);
    end;
    end;
  finally
    FIdFtp.Quit;
    freeandnil(ListStr);
    freeandnil(ListStr2);
  end;
end;

{����˵����
   FileType:��CZ,BC,Kj CZ_��ֵ�����ļ�,BC_�󶨿��������ļ���KJ_�󶨿��ۿ����ļ�
   BankID:����ID
}

function TProcessList.FindBankTransList(FileType:String;BankID:Integer;Date:TDateTime):Boolean;
var
  DateStr,SqlStr:String;
begin
  result := false;
  {��ʽ������}
  DateStr := formatdatetime(ShortDateFormat,Date);
  SqlStr  := ' Select * From  Where count>0 and FileType='+quotedStr(FileType)+
    ' and BankId='+IntToStr(BankID)+'and to_char(Dates,''yyyy-mm-dd'') = '''+DateStr+'''';
  if not OpDb.QuerySQL(SqlStr) then
  begin
      WriteLog(sqlstr);
   exit;
  end;
  if OpDb.Query.RecordCount<1 then exit;
  result := true;
end;

function TProcessList.GenerationFile(FileType, SendCode, ReceiveCode,
  WorkDate,tabname:String;Var FileName,Spath:String  ): Boolean;
var
  StrFileName:string;
  StrpacketH :string;//�ļ�ͷ
  StrDirctTag:String;//����
  Decollator :String;//�ָ����
  SubpacketNum :string;//�Ӱ�����
  SubPackStr   :String;
  FilePath:string;
  li:integer;
   tmpbuf:array  of Byte;
  sql:string;
begin
  Result:=False;

  if FileType='BK' then //�󶨿��ۿ��ļ�
  begin
  sql:= 'select ProcDesc  from ETCBindCardCollectDeductMoneyList_OnLine with (nolock) where bankid = '''+mainclass.bankid +''' and spare2= '''+dm.qi_bz+''' and balancedate = '''+dm.qi_balancedate+'''';
    OpDb.QuerySQL(sql);
    if opdb.Query.RecordCount  = 1 then
    begin
       StrFileName:= opdb.Query.fieldbyname('procdesc').AsString
    end;
    if trim(StrFileName)= '' then
     begin
       StrFileName:='BK'+ Sendcode+ReceiveCode+FormatdateTime('YYYYMMDDHHNNSS',Now)+'.TXT' ;
//       sql:= ' update ETCBindCardCollectDeductMoneyList_OnLine set procdesc = '''+strfilename+ '''  where  bankid = '''+mainclass.bankid +'''  and spare2= '''+dm.qi_bz+'''  and balancedate = '''+dm.qi_balancedate+'''';
//       opdb.ExecSQL(sql)  ;
//       mainclass.WriteLog('BK_sql'+sql);
     end;

  end;
  if FileType='TF' then //��ֵ���˷��ļ�
  begin
  sql:= 'select ProcDesc  from pre_cardbackfee with (nolock) where bankid = '''+mainclass.bankid +''' and balancedate = '''+dm.qi_balancedate+'''';
    OpDb.QuerySQL(sql);
    if opdb.Query.RecordCount  = 1 then
    begin
       StrFileName:= opdb.Query.fieldbyname('procdesc').AsString
    end;
    if trim(StrFileName)= '' then
     begin
       StrFileName:='TF'+ Sendcode+ReceiveCode+FormatdateTime('YYYYMMDDHHNNSS',Now)+'.TXT' ;
     end;

  end;
  if FileType='DZ' then //���ۿۿ��ļ�
  begin
  sql:= 'select ProcDesc  from ETCBindCardCollectDeductMoneyList_OnLine where bankid = '''+mainclass.bankid +''' and spare2= '''+dm.qi_bz+''' and balancedate = '''+dm.qi_balancedate+'''';
    OpDb.QuerySQL(sql);
    if opdb.Query.RecordCount  = 1 then
    begin
       StrFileName:= opdb.Query.fieldbyname('procdesc').AsString
    end;
    if trim(StrFileName)= '' then
     begin
       StrFileName:='DZ'+ Sendcode+ReceiveCode+FormatdateTime('YYYYMMDDHHNNSS',Now)+'.TXT' ;
       sql:= ' update ETCBindCardCollectDeductMoneyList_OnLine set procdesc = '''+strfilename+ '''  where  bankid = '''+mainclass.bankid +'''  and spare2= '''+dm.qi_bz+'''  and balancedate = '''+dm.qi_balancedate+'''';
       opdb.ExecSQL(sql)  ;
     end;

  end;
   if FileType='JZ' then //��ֹ���ۿ��ļ�
  begin
  sql:= 'select ProcDesc  from ETCBindCardCollectDeductMoneyList_OnLine where bankid = '''+mainclass.bankid +''' and spare2= '''+dm.qi_bz+'''  and balancedate = '''+dm.qi_balancedate+'''';
    OpDb.QuerySQL(sql);
    if opdb.Query.RecordCount  = 1 then
    begin
       StrFileName:= opdb.Query.fieldbyname('procdesc').AsString
    end;
    if trim(StrFileName)= '' then
     begin
       StrFileName:='JZ'+ Sendcode+ReceiveCode+FormatdateTime('YYYYMMDDHHNNSS',Now)+'.TXT' ;
       sql:= ' update ETCBindCardCollectDeductMoneyList_OnLine set procdesc = '''+strfilename+ '''  where  bankid = '''+mainclass.bankid +'''  and spare2= '''+dm.qi_bz+''' and balancedate = '''+dm.qi_balancedate+'''';
       opdb.ExecSQL(sql)  ;
     end;

  end;
   if FileType='Y2' then //һ����Կ����ļ�
  begin
       if trim(StrFileName)= '' then
       begin
         StrFileName:='Y2'+ Sendcode+ReceiveCode+FormatdateTime('YYYYMMDDHHNNSS',Now)+'.TXT' ;
         sql:= ' update ETCBankCardOneReleaseKeyparent set sendfilename = '''+strfilename+ ''',checkkeyoptime=getdate()  where  bankid = '''+mainclass.bankid +'''  and filename= '''+tabname+'''';
         opdb.ExecSQL(sql)  ;
       end;
  end;
  if FileType='YC' then //�����쳣�ļ�
  begin
       if trim(StrFileName)= '' then
       begin
         StrFileName:='YC'+ Sendcode+ReceiveCode+FormatdateTime('YYYYMMDDHHNNSS',Now)+'.TXT' ;
       end;
  end;
   if FileType='LF' then //��ϵ��ʽ
  begin
       if trim(StrFileName)= '' then
       begin
         StrFileName:='ETCLXFS.TXT' ;
       end;
  end;
  FileName:=StrFileName;
  FilePath:= UYearFolder+'\'+StrFileName;
  Spath:= UYearFolder+'\'+StrFileName;
  try
   AssignFile(txtFile, FilePath);
   Rewrite(txtFile);
   StrDirctTag:='0';  //ETC��Ӫ���� ����������
  // StrDirctTag :='1400000001';
   Decollator :='|';  //�ָ����
    if filetype='Y2' then
       SubpacketNum:='1' //1���Ӱ�
    else

   SubpacketNum:='2'; //�����Ӱ�

   StrpacketH:=StrDirctTag+Decollator+StrFileName+Decollator+SendCode
    +Decollator+ReceiveCode+Decollator+FormatdateTime('YYYYMMDDhhmmss',Now)+Decollator
    +SubpacketNum +Decollator+#13;
   Writeln(txtFile,StrpacketH);

   if FileType='BK' then
   begin
     if not GenSubBodyFile(5001,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
     if  not GenSubBodyFile(5002,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
   end;
   if FileType='TF' then
   begin
     if not GenSubBodyFile(8001,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
     if  not GenSubBodyFile(8002,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
   end;
   if FileType='DZ' then
   begin
     if not GenSubBodyFile(5009,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
     if  not GenSubBodyFile(5010,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
   end;
   if FileType='YC' then   //�����쳣
   begin
     if not GenSubBodyFile(5014,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
   end;
   if FileType='JZ' then
   begin
     if not GenSubBodyFile(6003,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
     if  not GenSubBodyFile(6004,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
   end;
    if FileType='Y2' then
    begin
        if not GenSubBodyFile(7002,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
    end;
    if FileType='LF' then   //��ϵ��ʽ
    begin
     if not GenSubBodyFile(5013,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
    end;
   //д�������
   StrpacketH:=StrpacketH+subPackStr;   //+StrpacketH+subPackStr
   //  Writeln(txtFile,'JYMJYMJYMJYMJYMJYMJYMJYMJYMJYMJYMJYMJYMJYM');
     li:= SizeOf(txtFile);



  finally
   CloseFile(txtFile);

  end;

  Result:=True;
end;

function TProcessList.GenSubBodyFile(FileCode:Integer; BankID,WorkDate,filename,tabname:String; var FileStr:String): Boolean;
var
  sSql:String;
  LsSql:String;
  tempStr:String;
  IntRecNum:Integer;//��¼��
  operType:string;
  ls_balacedate:string;
  key1:array[0..15]of byte;
  cardno:string;

  outputKey: array [0..12] of array [0..32] of char;
  tmpstr:string;
  J:integer;
  TmpoutputKey:string;
begin
  Result:=False;
  operType:='i';
  if fileCode=5001 then //ETC���ۿ�������ݣ�
  begin
        sSql:='select  BalanceDate , bankid  , Totalcount , TotalAmount   '+
        ' FROM ETCBindCardCollectDeductMoneyList_OnLine with (nolock)  where balancedate = '+formatdatetime('yyyymmdd',Now)
        +' and spare2= 0 and  bankid = '''+mainclass.bankid +'''';

       if not OpDb.QuerySQL(sSql) then
       begin
         ErrorCode:=1;
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
       end;
      if OpDb.Query.IsEmpty then
      begin
        ErrorCode:=2;
        ErrorStr:='�ް󶨿��ۿ�������ݣ�';
        WriteLog(ErrorStr);
        Exit;
      end;
      IntRecNum:=OpDb.Query.RecordCount;
      tempStr:=IntToStr(FileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
      Writeln(txtFile,tempStr);
      //��ϸ����
      OpDb.Query.First;

      while not OpDb.Query.eof do
      begin
      ls_balacedate :=OpDb.Query.fieldbyname('BalanceDate').AsString ;
       tempStr  :=     OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalCount').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalAmount').AsString+Decollator+#13;
       Writeln(txtFile,tempStr);//д��ˮ
       OpDb.Query.next;
      end;
  end ;
  if fileCode=8001 then //ETC��ֵ���˷ѻ������ݣ�
  begin
        sSql:='select  BalanceDate , bankid  , Totalcount , TotalAmount   '+
        ' FROM pre_cardbackfee with (nolock)  where balancedate = '+formatdatetime('yyyymmdd',Now)
        +' and resatus= 0 and  bankid = '''+mainclass.bankid +'''';

       if not OpDb.QuerySQL(sSql) then
       begin
         ErrorCode:=1;
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
       end;
      if OpDb.Query.IsEmpty then
      begin
        ErrorCode:=2;
        ErrorStr:='ETC��ֵ���˷ѻ������ݣ�';
        WriteLog(ErrorStr);
        Exit;
      end;
      IntRecNum:=OpDb.Query.RecordCount;
      tempStr:=IntToStr(FileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
      Writeln(txtFile,tempStr);
      //��ϸ����
      OpDb.Query.First;

      while not OpDb.Query.eof do
      begin
//      ls_balacedate :=OpDb.Query.fieldbyname('BalanceDate').AsString ;
       tempStr  :=     OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalCount').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalAmount').AsString+Decollator+#13;
       Writeln(txtFile,tempStr);//д��ˮ
       OpDb.Query.next;
      end;
  end ;
   if fileCode=5009 then //���ۿۿ�������ݣ�
  begin
        sSql:='select  BalanceDate , bankid  , Totalcount , TotalAmount   '+
        ' FROM ETCBindCardCollectDeductMoneyList_OnLine with (nolock)  where balancedate = '+formatdatetime('yyyymmdd',Now)
        +' and spare2= 2 and  bankid = '''+mainclass.bankid +'''';

       if not OpDb.QuerySQL(sSql) then
       begin
         ErrorCode:=1;
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
       end;
      if OpDb.Query.IsEmpty then
      begin
        ErrorCode:=2;
        ErrorStr:='�޴��ۿۿ�������ݣ�';
        WriteLog(ErrorStr);
        Exit;
      end;
      IntRecNum:=OpDb.Query.RecordCount;
      tempStr:=IntToStr(FileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
      Writeln(txtFile,tempStr);
      //��ϸ����
      OpDb.Query.First;

      while not OpDb.Query.eof do
      begin
      ls_balacedate :=OpDb.Query.fieldbyname('BalanceDate').AsString ;
       tempStr  :=     OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalCount').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalAmount').AsString+Decollator+#13;
       Writeln(txtFile,tempStr);//д��ˮ
       OpDb.Query.next;
      end;
  end ;
    if fileCode=6003 then //ETC��JZF�������ݣ�
  begin
        sSql:='select  BalanceDate , bankid  , Totalcount , TotalAmount   '+
        ' FROM ETCBindCardCollectDeductMoneyList_OnLine with (nolock) where balancedate = convert(varchar,getdate(),112)'
        +' and spare2= 1 and  bankid = '''+mainclass.bankid +'''';

       if not OpDb.QuerySQL(sSql) then
       begin
         ErrorCode:=1;
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
       end;
      if OpDb.Query.IsEmpty then
      begin
        ErrorCode:=2;
        ErrorStr:='�ް󶨿��ۿ�������ݣ�';
        WriteLog(ErrorStr);
        Exit;
      end;
      IntRecNum:=OpDb.Query.RecordCount;
      tempStr:=IntToStr(FileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
      Writeln(txtFile,tempStr);
      //��ϸ����
      OpDb.Query.First;

      while not OpDb.Query.eof do
      begin
      ls_balacedate :=OpDb.Query.fieldbyname('BalanceDate').AsString ;
       tempStr  :=     OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalCount').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalAmount').AsString+Decollator+#13;
       Writeln(txtFile,tempStr);//д��ˮ
       OpDb.Query.next;
      end;
  end ;
  if fileCode=5002 then  //ETC�󶨿��ۿ���ϸ���ݣ�
  begin
        sSql:=' select distinct convert(varchar,getdate(),112) BalanceDate,ListNo,CustomerId , usertype ,username,BankCardID ,pCardNo, right(CardID,16) ETCCardID,totaltoll, '+' REPLACE(memos,''|'',''_'') Remarks ,optime  '+
              ' FROM   ETCBoutToBankfile with (nolock) where convert(varchar,createtime,112) <= convert(varchar,getdate()-1,112) and TotalToll >0 and substring(CardID,9,2)=''23'' '
             +' and spare3=0 and ynok=''N''  and bankid = '''+mainclass.bankid +'''';
        //convert(varchar,createtime,120) <= ''2019-08-27 10:00:00.000''
        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='��ѯ�󶨿��ۿ���ϸ����ʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='�ް󶨿��ۿ���ϸ���ݣ�';
         WriteLog(ErrorStr);
         Exit;
       end;
          IntRecNum := OpDb.Query.RecordCount;
       tempStr:=IntToStr(fileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
       writeln(txtFile,tempStr);
       OpDb.Query.first;
       while not OpDb.Query.eof do
       begin
          tempStr:=    OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('listno').AsString+Decollator+
                       OpDb.Query.fieldbyname('CustomerID').AsString+Decollator+
                       OpDb.Query.fieldbyname('UserType').AsString+Decollator+
                       Trim(OpDb.Query.fieldbyname('UserName').AsString)+Decollator+
                       OpDb.Query.fieldbyname('pCardNo').AsString+Decollator+
                       OpDb.Query.fieldbyname('ETCCardID').AsString+Decollator+
                       Trim(OpDb.Query.fieldbyname('BankCardID').AsString)+Decollator+
                       OpDb.Query.fieldbyname('totaltoll').AsString+Decollator+
                       OpDb.Query.fieldbyname('Remarks').AsString+Decollator+
                       OpDb.Query.fieldbyname('optime').AsString+Decollator+#13;;
            writeln(txtFile,tempStr);//д��ˮ
            OpDb.Query.next;
       end;
  end;
  if fileCode=8002 then  //ETC��ֵ���˷���ϸ���ݣ�
  begin
        sSql:=' select convert(varchar,getdate(),112) BalanceDate,RIGHT(wasteno,30) ListNo,CustomerId ,bankcustomername username,bankno,BankCardNO as BankCardID,Linkmantel,'+
        ' cardid as ETCCardID,returnfee as totaltoll,replace(replace(replace(convert(varchar(20),retruntime,120),''-'',''''),'':'',''''),'' '','''') as optime,vehicleplateno,'+
        ' certificateID,NetWorkNO,left(bankdescinfo,2) bankdescinfo from ETCWorknetBusinessReturnMoneyBankInfo_Bank a with (nolock)'+
        ' where convert(varchar,opsystime,112) <= convert(varchar,getdate()-1,112) and returnfee>0 and sendstatus=0 and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='��ѯ��ֵ���˷���ϸ����ʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='�޴�ֵ���˷���ϸ���ݣ�';
         WriteLog(ErrorStr);
         Exit;
       end;
          IntRecNum := OpDb.Query.RecordCount;
       tempStr:=IntToStr(fileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
       writeln(txtFile,tempStr);
       OpDb.Query.first;
       while not OpDb.Query.eof do
       begin
          tempStr:=    OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('listno').AsString+Decollator+
                       OpDb.Query.fieldbyname('CustomerID').AsString+Decollator+
                       Trim(OpDb.Query.fieldbyname('UserName').AsString)+Decollator+
                       Trim(OpDb.Query.fieldbyname('BankNo').AsString)+Decollator+
                       OpDb.Query.fieldbyname('Linkmantel').AsString+Decollator+
                       OpDb.Query.fieldbyname('ETCCardID').AsString+Decollator+
                       Trim(OpDb.Query.fieldbyname('BankCardID').AsString)+Decollator+
                       OpDb.Query.fieldbyname('totaltoll').AsString+Decollator+
                       OpDb.Query.fieldbyname('optime').AsString+Decollator+
                       OpDb.Query.fieldbyname('vehicleplateno').AsString+Decollator+
                       OpDb.Query.fieldbyname('certificateID').AsString+Decollator+
                       OpDb.Query.fieldbyname('NetWorkNO').AsString+Decollator+
                       Trim(OpDb.Query.fieldbyname('bankdescinfo').AsString)+Decollator+#13;;
            writeln(txtFile,tempStr);//д��ˮ
            OpDb.Query.next;
       end;
  end;
  if fileCode=5010 then  //ETC���ۿۿ���ϸ���ݣ�
  begin
        sSql:=' select distinct convert(varchar,getdate(),112) BalanceDate,RIGHT(ListNo,30) ListNo,CustomerId , usertype ,username,BankCardID ,left(ETCCardID,4) cardid, right(ETCCardID,16) ETCCardID,pCardNo,totaltoll, '+' REPLACE(memos,''|'',''_'') Remarks ,optime,vehtype  '+
              ' FROM   ETCBoutToBankfile with (nolock) where convert(varchar,createtime,112) <= convert(varchar,getdate()-1,112)and TotalToll >0 '
              +'  and spare3=2 and ynok=''N'' and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='�޴��ۿۿ���ϸ���ݣ�';
         WriteLog(ErrorStr);
         Exit;
       end;
          IntRecNum := OpDb.Query.RecordCount;
       tempStr:=IntToStr(fileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
       writeln(txtFile,tempStr);
       OpDb.Query.first;
       while not OpDb.Query.eof do
       begin
          tempStr:=    OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('listno').AsString+Decollator+
                       OpDb.Query.fieldbyname('CustomerID').AsString+Decollator+
                       OpDb.Query.fieldbyname('UserType').AsString+Decollator+
                       OpDb.Query.fieldbyname('UserName').AsString+Decollator+
                       OpDb.Query.fieldbyname('cardid').AsString+Decollator+
                       OpDb.Query.fieldbyname('ETCCardID').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankCardID').AsString+Decollator+
                       OpDb.Query.fieldbyname('totaltoll').AsString+Decollator+
                       OpDb.Query.fieldbyname('Remarks').AsString+Decollator+
                       OpDb.Query.fieldbyname('optime').AsString+Decollator+
                       OpDb.Query.fieldbyname('vehtype').AsString+Decollator+#13;;
            writeln(txtFile,tempStr);//д��ˮ
            OpDb.Query.next;
       end;
  end;
    if fileCode=5013 then     //ETC��ϵ�绰
  begin
    sSql:='select a.CardID,b.MobileNo from ETCCardData a with (nolock) left join ETCCustomerInfo b with (nolock) on a.CustomerId=b.CustomerId'+
         ' where a.CardState=1 and b.MobileNo<>'''' and SUBSTRING(a.CardID,9,4)=2399';
    if not OpDb.QuerySQL(sSql) then
        begin
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
    OpDb.Query.first;
       while not OpDb.Query.eof do
       begin
          tempStr:=    OpDb.Query.fieldbyname('cardid').AsString+Decollator+
                       OpDb.Query.fieldbyname('MobileNo').AsString+Decollator+#13;;
            writeln(txtFile,tempStr);//д��ˮ
            OpDb.Query.next;
       end;
  end;
    if fileCode=6004 then  //ETC�󶨿�JZF�ۿ���ϸ���ݣ�
  begin
        sSql:=' select distinct convert(varchar,getdate(),112) BalanceDate,RIGHT(ListNo,30) ListNo,CustomerId , usertype ,UserName,BankCardID ,'
        +'left(ETCCardID,4) cardid, right(ETCCardID,16) ETCCardID,pCardNo,totaltoll, '+' REPLACE(memos,''|'',''_'') Remarks ,optime  '+
              ' FROM   ETCBoutToBankfile with (nolock) where convert(varchar,createtime,112) <= convert(varchar,getdate()-1,112) '
              +'and spare3=1 and ynok=''N'' and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='�ް󶨿�JZF�ۿ���ϸ���ݣ�';
         WriteLog(ErrorStr);
         Exit;
       end;

       IntRecNum := OpDb.Query.RecordCount;
       tempStr:=IntToStr(fileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
       writeln(txtFile,tempStr);
       OpDb.Query.first;
       while not OpDb.Query.eof do
       begin
          tempStr:=    OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('listno').AsString+Decollator+
                       OpDb.Query.fieldbyname('CustomerID').AsString+Decollator+
                       OpDb.Query.fieldbyname('UserType').AsString+Decollator+
                       OpDb.Query.fieldbyname('UserName').AsString+Decollator+
                       OpDb.Query.fieldbyname('cardid').AsString+Decollator+
                       OpDb.Query.fieldbyname('ETCCardID').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankCardID').AsString+Decollator+
                       OpDb.Query.fieldbyname('totaltoll').AsString+Decollator+
                       OpDb.Query.fieldbyname('Remarks').AsString+Decollator+
                       OpDb.Query.fieldbyname('optime').AsString+Decollator+#13;;
            writeln(txtFile,tempStr);//д��ˮ
            OpDb.Query.next;
       end;
  end;
  if fileCode=5014 then  //ETC���η����쳣���ݣ�
  begin
        sSql:=' select OrderNO,BankID,NetWorkID,PCardID,Vehplate,OpDesc,BatchNO from ETCBankCardSecondReleaseResult'+
              'where OpStatus>1 and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='�޶����쳣���ݣ�';
         WriteLog(ErrorStr);
         Exit;
       end;

       IntRecNum := OpDb.Query.RecordCount;
       tempStr:=IntToStr(fileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
       writeln(txtFile,tempStr);
       OpDb.Query.first;
       while not OpDb.Query.eof do
       begin
          tempStr:=    OpDb.Query.fieldbyname('OrderNO').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('NetWorkID').AsString+Decollator+
                       OpDb.Query.fieldbyname('PCardID').AsString+Decollator+
                       OpDb.Query.fieldbyname('Vehplate').AsString+Decollator+
                       OpDb.Query.fieldbyname('OpDesc').AsString+Decollator+
                       OpDb.Query.fieldbyname('BatchNO').AsString+Decollator+#13;;
            writeln(txtFile,tempStr);//д��ˮ
            OpDb.Query.next;
       end;
  end;
  if  fileCode=7002 then
  begin
        sSql:=' select netcardno,cardno FROM   dbo.ETCBankCardOneReleaseKey where filename='''+tabname+''' and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='ִ��SQLʧ��:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='û����Ҫ�������Կ��ϸ';
         WriteLog(ErrorStr);
         Exit;
       end;
       with OpDB.Query do
       begin
           IntRecNum := OpDb.Query.RecordCount;
           tempStr:=IntToStr(fileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
           operType+Decollator+#13;
           writeln(txtFile,tempStr);
          mainclass.strtobyte(key1,mainclass.defaultkey,1);
           First;
           while not eof do
           begin
               tmpStr:='';
                cardno:=fieldbyname('cardno').asstring;
                        TmpStr := mainclass.bankid;
                        //��������
                        TmpStr := TmpStr + Decollator + mainclass.bankname;
                        //��������
                        TmpStr := TmpStr + Decollator + fieldbyname('netcardno').AsString ;
                        //����
                        TmpStr := TmpStr + Decollator + rightstr(cardno,16);

                if QueryCardExists(fieldbyname('netcardno').asstring+cardno) then
                begin
                   // next;
                   // Continue;
                         tmpstr:=tmpstr+Decollator+Decollator+Decollator+Decollator
                         +Decollator+Decollator+Decollator+Decollator
                         +Decollator+Decollator+Decollator+Decollator+Decollator+Decollator+'1';

                end
                else
                begin
               //��ü��ܻ�����Կ
                     if not getcupcardkey(pchar(rightstr(cardno,16)),pchar(mainclass.SJMJSERVERIP), @outputKey) then
                     begin
                         //Application.MessageBox('������Կ����', '��ʾ��Ϣ', MB_OK + MB_ICONINFORMATION);
                         //exit;

                         tmpstr:=tmpstr+Decollator+Decollator+Decollator+Decollator
                         +Decollator+Decollator+Decollator+Decollator
                         +Decollator+Decollator+Decollator+Decollator+Decollator+Decollator+'1';
                     end
                     else
                     begin
                        TmpStr := mainclass.bankid;
                        //��������
                        TmpStr := TmpStr + Decollator + mainclass.bankname;
                        //��������
                        TmpStr := TmpStr + Decollator + fieldbyname('netcardno').AsString ;
                        //����
                        TmpStr := TmpStr + Decollator + rightstr(cardno,16);
                        for j:=0 to 12 do
                        begin

                          TmpoutputKey:=outputKey[j];
                          TmpStr := tmpstr+Decollator + getDecryptdata(TmpoutputKey);
//                          TmpStr := tmpstr+Decollator + TmpoutputKey;
                        end;
                        tmpstr:=tmpstr+Decollator+'313233343536'+Decollator+'0';
                     end;
               end;
               //getDecryptdata(
               writeln(txtFile,tmpStr);//д��ˮ
               next;
           end;
       end;

  end;
  Result:=True;
end;

function TProcessList.GetConnected:Boolean;
begin
  Result := OpDb.Connected;
end;

function TProcessList.Getfilename:string;
var
   r:TsearchRec;
   filelist:Tstringlist;
   filename:string;
   i:integer;
   datestr:string;
   sYear,sMonth,sDay:Word;
begin
    DecodeDate(Now,sYear,sMonth,sDay);
    datestr:=FormatdateTime('yyyymmdd',now);
    Result:='';
//    filelist:=Tstringlist.create;
    if findfirst('D:\bankserver\ftpdir\detail\'+InttoStr(sYear)+'\'+'KJ'+mainclass.bankid+'1400000'+datestr+'*.*',faanyfile,r)=0
     then
//     filelist.add(r.name);
       filename:=r.Name;
      mainclass.WriteLog('��ȡ�ļ�����'+filename);
      mainclass.WriteLog('D:\bankserver\ftpdir\detail\'+InttoStr(sYear)+'\'+'KJ'+mainclass.bankid+'1400000'+datestr+'*.*');

//    while findnext(r)=0 do
//    filelist.add(filename);
    findclose(r);
    //����filelist�оͱ�������������ļ����µ������ļ�����������ʾ��һ��memo�������
  {  for i:=0 to filelist.count-1 do
    begin
      if hoursBetween(GetFileEditTime('D:\bankserver\ftpdir\detail\'+InttoStr(sYear)+'\'+filelist[i]),Now)<15  then
//            deletefile('E:\test\'+filelist[i]); ɾ���ļ�
//       mmo1.lines.Append(memo1.lines.text+filelist[i]+#13);

          mainclass.WriteLog(filelist[i]+'���뵱ǰСʱ����'+Inttostr(hoursBetween(GetFileEditTime('D:\bankserver\ftpdir\detail\'+InttoStr(sYear)+'\'+filelist[i]),Now)));
    end; }

//    filelist.free;
    Result:=filename;

end;


//��ȡ�ļ��Ĵ���ʱ��
function GetFileCreationTime(const FileName: String): TDateTime;
var
  FileTime: TFileTime;
  LocalFileTime: TFileTime;
  hFile: THandle;
  SystemTime: TSystemTime;
begin
  Result := 0;
  FileTime.dwLowDateTime := 0;
  FileTime.dwHighDateTime := 0;
  hFile := FileOpen(FileName, fmShareDenyNone);
  try
    if hFile <> 0 then
    begin
      Windows.GetFileTime(hFile, @FileTime, nil, nil);
      FileTimeToLocalFileTime(FileTime, LocalFileTime);
      FileTime := LocalFileTime;
    end;
  finally
    FileClose(hFile);
  end;
  if FileTimeToSystemTime(FileTime, SystemTime) then
    Result := SystemTimeToDateTime(SystemTime);
end;

//��ȡ�ļ����޸�ʱ��
function GetFileEditTime(const FileName: String): TDateTime;
var
  FileTime: TFileTime;
  LocalFileTime: TFileTime;
  hFile: THandle;
  SystemTime: TSystemTime;
begin
  Result := 0;
  FileTime.dwLowDateTime := 0;
  FileTime.dwHighDateTime := 0;
  hFile := FileOpen(FileName, fmShareDenyNone);
  try
    if hFile <> 0 then
    begin
      Windows.GetFileTime(hFile, nil, nil, @FileTime);
      FileTimeToLocalFileTime(FileTime, LocalFileTime);
      FileTime := LocalFileTime;
    end;
  finally
    FileClose(hFile);
  end;
  if FileTimeToSystemTime(FileTime, SystemTime) then
    Result := SystemTimeToDateTime(SystemTime);
end;

function TProcessList.getDecryptdata(str: string): string;
var
   indata,outdata:array[0..15] of byte;
   Tmpdata:array[0..31] of char;
   key1:array[0..15] of Byte;
begin
    mainclass.strtobyte(key1,mainclass.defaultkey,1);
    strcopy(@Tmpdata,pchar(str));
    hextobin(@Tmpdata,@indata,16);
    mainclass.Encryptbcb(key1,indata,outdata);     //���ܣ� Decryptbcb
    result:=mainclass.BytestoHexString(outdata,16);
end;

procedure TProcessList.LoadParam;
var
  Inif  : TIniFile;
begin
  Inif:= TIniFile.Create(ExtractFilePath(Application.ExeName)+IniFileName);
  try
    fIpAddr       := Inif.ReadString('FTP����','IP��ַ','127.0.0.1');
    fFtpPort      := Inif.ReadInteger('FTP����','�˿�',21);
    fUserName     := inif.ReadString('FTP����','�û���','sxgs');
    fPassWord     := inif.ReadString('FTP����','����','sxgs');
    FTPUFolder    := Inif.ReadString('FTP����','FTP�ϴ�Ŀ¼','upload');
    FTPDFolder    := Inif.ReadString('FTP����','FTP����Ŀ¼','detail');
    LocalUFolder  := ExtractFilePath(Application.ExeName)+Inif.ReadString('FTP����','�����ϴ�Ŀ¼','uploadS');
    LocalDFolder  := ExtractFilePath(Application.ExeName)+Inif.ReadString('FTP����','��������Ŀ¼','download');
    DbType        := Inif.ReadInteger('db','dbtype',2);
    DbIpAddr      := Inif.ReadString('db','dbserverip','10.14.161.2');
    DbName        := Inif.ReadString('db','database','db_center');
    DbUser        := Inif.ReadString('db','username','sa');
    DbPassword    := Inif.ReadString('db','pwd','SXETCqfkj@1612');
    SendCode      :=Inif.ReadString('�ļ�����','���ͷ�����','1400000');
    DateSeparator := '-';
    LongDateFormat:= 'yyyy-mm-dd hh:nn:ss';
    ShortDateFormat := 'yyyy-mm-dd';

  finally
    FreeAndNil(Inif);
  end;
end;


procedure TProcessList.ProcessDownFile(FileName: string);
var
 ResultList:TStringList;//��ȡ��ֽ��
 Str:string;
 TempRFilePack:RFilePack;
 TempRsubPack:RsubPack;
 {�жϰ�ͷ��β����}
 IsHead:Boolean;        //�ж��Ƿ��ǰ�ͷ
 IsSubPack:Boolean;     //�ж��Ƿ���ϸ
 SubPackCout:Integer;   //�Ӱ�����
 TempRecord:Integer;    //�����¼��
 FilePath : String;     //·��
 txtFile  : TextFile;   //���յ��ļ�
 FileJym:String;//
 i:integer;
begin
 //if midstr(filename,1,2) = 'KJ' then  FilePath := '\'+FileName
  //                       else
 FilePath := DYearFolder+'\'+FileName  ;
 try
   ResultList:=TStringList.Create;
   AssignFile(txtFile,FilePath);
  try
    Reset(TxtFile);
    ReadLn(TxtFile,Str);
    //�ļ�ͷ
    ResultList.Delimiter := '|';
    ResultList.DelimitedText := str;
    tempRFilePack.DirectTag:=ResultList[0];
    tempRFilePack.FileName:=ResultList[1];
    tempRFilePack.SendBh:=ResultList[2];
    tempRFilePack.ReceiveBh:=ResultList[3];
    tempRFilePack.Optime:=ResultList[4];
    //�Ӱ�����
    tempRFilePack.SubPackCout:=StrToInt(ResultList[5]);
    isHead:=True;
    isSubPack:=False;
    DownRecordNum:=0;
    While not Eof(TxtFile) do
    begin
      ReadLn(TxtFile,Str);
      if length(Str)>0 then
      begin
        ResultList.Clear;
        ResultList.Delimiter := '|';
        ResultList.DelimitedText := str;
       if isHead then {�����Ӱ���ͷ}
       begin
         tempRsubPack.subCode  :=StrToInt(ResultList[0]);//�Ӱ�����
         tempRsubPack.recCount :=StrToInt(ResultList[1]);//�Ӱ���ˮ����
         DownRecordNum:=tempRsubPack.recCount;
         tempRsubPack.opertype :=ResultList[2];//��������
         isHead:=False;
         tempRecord:=tempRsubPack.recCount;
       end
       else
       if tempRecord>0 then
       begin
         //if not SavefileDb(tempRsubPack.subCode,Str,FileName) then
         //Exit;
         while  not SavefileDb(tempRsubPack.subCode,Str,FileName) do
         begin
           Sleep(30000);
           SavefileDb(tempRsubPack.subCode,Str,FileName);
         end;
         tempRecord:=tempRecord-1;
         if tempRecord=0 then
         begin
          tempRFilePack.SubPackCout:=tempRFilePack.SubPackCout-1;
          if  tempRFilePack.SubPackCout>0 then
          isHead:=True;
         end;
       end;
      end;
   end;
  finally
    CloseFile(txtFile);
  end;
 finally
  FreeAndNil(ResultList);
 end;
end;

function TProcessList.ProcessUpFile(BankID,WorkDate,FileType,tabname:String;var FileName,Spath: String): Boolean;
var
  tmpStr,SqlStr:string;
begin
  result:=False;
  if not GenerationFile(FileType,Sendcode,BankID,WorkDate,tabname,FileName,spath) then
  begin
      result:=False;
      exit;
  end;
  {��Ҫ�ϴ����ļ���
  OpDB.BeginTrans;
  SqlStr := 'Update ' + ExpTransDetailTB + ' Set FileName = '''+FileName + ''' Where FileName=''0''';
  if not OPDb.ExecSQL(SqlStr) then
  begin
    tmpStr := '�ϴ��ļ����裬�������ݿ�ʧ�ܣ�ԭ��'+OpDB.ErrStr;
    WriteLog(tmpStr);
    WriteLog('SQL��䣺'+SqlStr);
    OpDb.RollBack;
    Exit;
  end;}
  Result:=True;
end;

{����ϴ�ʧ�ܣ���ָ�����}
function TProcessList.QueryCardExists(aCardID: string): boolean;

begin
  result := false;
  try

    tmpOpDB.QuerySQL('select * from  etccarddata  with(nolock) where cardstate=1'
      +' and  Cardid='+quotedstr(aCardID));
//    OPDb.Open;
    if tmpOpDB.Query.RecordCount > 0 then
    begin
      result := true;
    end
    else
    begin
      result := false;
    end;
  finally

  end;

end;


procedure TProcessList.RollBackLoadFile(UFileName: string);
var
  SqlStr: string;
begin
  {�����ϴ��ļ��ʱ�ʾ���ܱ���ɾ����ǰ�ļ���Ӧ�Ļ�������}
  SqlStr := 'Delete From ' + ' Where FileName = '''+'''';
  OPDb.ExecSQL(SqlStr);
  {���ļ��ж�Ӧ����ˮ����Ϊδ�ϴ�}
  SqlStr := 'Update '+' Set FileName = ''0'' Where FileName='''+ '''';
  OPDb.ExecSQL(SqlStr);
end;

function TProcessList.SaveFileDb(StrtableId: Integer;
  StrValue: String;filename:string): boolean;
var
  Tempstr:string;
  TableName,
  Opersql,ls_sql:String;
  StrOpetime:String;
  IntPos:Integer;
  temLength:Integer;
  ls_str1,ls_str2:string;
  if_new:string;
begin
  Result:=False;
   ls_str1:= rightstr(strvalue,50);
   ls_str2:=  leftstr(ls_str1,17);
   if  pos('|',ls_str2)=1 then ls_str2:= rightstr(ls_str2,16);
   if  pos('|',ls_str2)=17 then ls_str2:= leftstr(ls_str2,16);
    if strtableid = 4002 then
  begin
     if_new:='X';
  end;
  StrValue:=StringReplace(StrValue,' ','',[rfReplaceAll]);
  if (StrtableId=3003) or (StrtableId=3004) then
  begin
   temLength:=Length(StrValue);
   IntPos:=pos('|',StrValue);
   StrOpetime:=Copy(StrValue,intpos+1,14);
   StrOpetime:=Copy(StrOpetime,1,4)+'-'+Copy(StrOpetime,5,2)+'-'+Copy(StrOpetime,7,2)+' '
               +Copy(StrOpetime,9,2)+':'+Copy(StrOpetime,11,2)+':'+Copy(StrOpetime,13,2);
   StrValue:=Copy(StrValue,1,IntPos)+StrOpetime+Copy(StrValue,IntPos+15,temLength-IntPos+14);
  end;

  TempStr:=''''+StringReplace(StrValue,'|',''',''',[rfReplaceAll])+'''';

  TempStr:=copy(TempStr,1,length(TempStr)-3);

  if    (StrtableId=3001) or (StrtableId=3002)  then
  begin
    StrOpetime:=Copy(TempStr,Length(TempStr)-14,14);
    StrOpetime:=Copy(StrOpetime,1,4)+'-'+Copy(StrOpetime,5,2)+'-'+Copy(StrOpetime,7,2)+' '
               +Copy(StrOpetime,9,2)+':'+Copy(StrOpetime,11,2)+':'+Copy(StrOpetime,13,2);
    TempStr:=Copy(TempStr,1,Length(TempStr)-16)+quotedstr(StrOpetime);
  end;
  if (strtableid=7001) or  (strtableid=7003) then
  begin
      TempStr:=tempstr+','''+filename+''''
  end;
 //  if    (StrtableId=5004) then   // (StrtableId=5004)  or
 // begin
 //   StrOpetime:=Copy(TempStr,Length(TempStr)-14,14);
 //   TempStr:=Copy(TempStr,1,Length(TempStr)-16)+quotedstr(StrOpetime);
 // end;
  case  StrtableId  of
      3001: tableName:='Insert into ETCPreCardRechargeBankCollectlog_bank (WorkDate,BankID,BankName,CZTotalMoney,'+
            'CZMoney, QCMoney,MoneyCZ,BKMoney,TKMoney,DateTime)values('; //�������ܶ��˽������
      3002: tableName:='Insert into ETCPreCardRechargeBankTerminalCollectlog_bank(WorkDate,BankID,BankName,NetWorkID,TerminalID,CZTotalMoney,'+
            'CZMoney,QCMoney,MoneyCZ,BKMoney,TKMoney,DateTime)values('; //����ÿһ���ն˵��ջ������ݣ�
      3003:
       tableName:='Insert into ETCPreCardRechargeBanklog_bank(WasteSN,DateTime,NetWorkID,TerminalID,'+
            'CZType, CustomerID,PCardNetID,PCardID,OnlineSN,OfflineSN,Random,MAC1,MAC2,SysBeforeMoney,CardBeforeMoney,CZTotalMoney'+
            ',CZMoney,QCMoney,MoneyCZ,BKMoney,TKMoney,CardAfterMoney,CZResult,Note)values(';//��ͨ����ֵ��ϸ���ݣ�
      3004:
       tableName:='Insert into ETCPreCardRechargeBanklog_bank(pcardid,WasteSN,DateTime,NetWorkID,TerminalID,'+
            'CZType, CustomerID,CardBeforeMoney,CZTotalMoney,CZMoney,CZResult,Note)values('''',';//�˻���ֵ��ϸ���ݣ�

      4001: tableName:='Insert into PCardBlackList_bankHZ (WorkDate,BankID,BankName,RecordNumber)values('; //�춨���������������ݣ�

      4002: tableName:='Insert into PCardBlackList_bank_middle(ifnew,CustomerID,UserType,UserName,CertificateType,CertificateID,PCardNetID,PCardID,'+
            'BankCardID,TranType,BindingCardBlackCause,BANKID)values('''+if_new+''',';//�춨����������ϸ���ݣ�
      5003:
      tableName:='Insert into ETCBindCardCollectDeductMoneyList_Bank(procdesc,BalanceDate,BankID,TotalCount,TotalAmount,SucceedCount,SucceedAmount,'+
       ' FailCount,FailAmount,TransferDate)values('''+filename+''',';//�󶨿��ۿ����������ݣ�
      5004:
      if (mainclass.bankid='3100000') or (mainclass.bankid='3200000') or (mainclass.bankid='3300000') then
      begin
       tableName:='Insert into ETCBindCardDeductMoneyList_Bank (procdesc,BankID,BalanceDate,ListNo,CustomerID,UserType,UserName,PCardNetID,PCardID,'+
       ' BankCardID,Amount,Result,OpTimes,remarks,discount,integral)values('''+filename+''','''+mainclass.bankid+''',' ;//�󶨿��ۿ�����ϸ����;
      end else
       tableName:='Insert into ETCBindCardDeductMoneyList_Bank (procdesc,BankID,BalanceDate,ListNo,CustomerID,UserType,UserName,PCardNetID,PCardID,'+
       ' BankCardID,Amount,Result,OpTimes,remarks)values('''+filename+''','''+mainclass.bankid+''',' ;//�󶨿��ۿ�����ϸ����;
      5011: tableName:='Insert into ETCBindCardCollectDeductMoneyList_BankDZHZ(FileNameStr,BalanceDate,BankID,TotalCount,TotalAmount,'+
       ' TransferDate)values('''+filename+''',';//���ۿۿ����������ݣ�
      5012:
      tableName:='Insert into ETCBindCardDeductMoneyList_BankDZJG (FileNameStr,bankid,dismonth,BalanceDate,ListNo,CustomerID,UserType,UserName,PCardNetID,PCardID,'+
       ' BankCardID,Amount,DisAmount,OpTime)values('''+filename+''','''+mainclass.bankid+''',CONVERT(varchar(6),GETDATE(),112),' ;//���ۿۿ�����ϸ����;
      5005: tableName:='Insert into ETCBindCardCollectDeductMoneyList_Bank_ZF(procdesc,recordcount,BalanceDate,BankID,TotalCount,TotalAmount,SucceedCount,SucceedAmount,'+
       ' FailCount,FailAmount,TransferDate)values('''+filename+''',2,';//JZF�ۿ����������ݣ�
      5006:tableName:='Insert into ETCBindCardDeductMoneyList_Bank_ZF (procdesc,BankID,BalanceDate,ListNo,CustomerID,UserType,UserName,pcardnetid,PCardID,'+
       ' BankCardID,Amount,Result,OpTime,remarks)values('''+filename+''','''+mainclass.bankid+''',' ;//JZF���ۿ�����ϸ����;
      6001: tableName:='INSERT INTO ETCBankCardBindTab_M (BalanceDate, BankID, TotalCount, SucceedCount, FailCount,hcount, TransferDate) '+
       ' VALUES (';       //�󶨽������
      6002: tableName:='INSERT INTO ETCBankCardBindTab_T (ProcessDate, ProcessTime, NetWorkID, TerminalID, BankID, CustomerID,'+
         ' UserType, UserName, CertificateType, CertificateID, PCardNetID, PCardID,VehplateColor,'+
          ' Vehplate,EntrustVerifyCode,  WasteSN, BankCardType, BCertificateType,'+
         ' BVCertificateID,ActiveDate, BankCardID, BUserName, OperatorName, YN)  VALUES ( ';         //�󶨽����ϸ
      7001: tableName:='INSERT INTO ETCBankCardOneReleaseKey (BankID,BankName,NetCardNO,CardNo,filename) VALUES(' ; //һ����Կ��ϸ������Ϣ
//      7002: tableName:='INSERT INTO ETCBankCardOneReleaseKey (BankID,BankName,NetCardNo,CardNo,MK_MF,DAMK_MF,MK_DF01,AMK_DF01,IK_DF01,UK_DF01,DPK1,DPK2,DLK1,DLK2,DTK,'+
//        ' PIN,DPUK_DF01,DRPK_DF01,CardType) VALUES (';   //һ����Կ�����ϸ������Ϣ
      7003: tableName:='INSERT INTO ETCBankCardSecondReleaseResult (orderno,NetWorkID,TerminalID,BankID,CustomerID,UserType,UserName,CertificateType,CertificateID,Contact,Phone,'+
         ' Mobile,Address,FaxNo,Email,WorkUnit,OfficeAddress,OfficePhone,Vehplate,Vehplatecolor,VehType,VehSeatNum,VehLength,VehWidth,VehHeight,VehEngineNo,VehWheel,VehAxle,'+
         ' VehAxleLen,CarLoad,CarINfo,PCardNetID,PCardID,CardBalance,CardCost,CardMargins,StartDate,EndDate,CardType,BankCardType,BCertificateType,BVCertificateID,ActiveDate,'+
         ' BankCardID,BUserName,OperatorName,OperatorNO,vehcolor,batchno) VALUES (';  //���������ϸ������Ϣ
  else
  begin
    //δ֪�Ӱ�����;
    ErrorCode:=3;
    ErrorStr:='������ļ�����';
    WriteLog(ErrorStr);
    Exit;
  end;
  end;

  IF StrtableId=  4001    THEN
  BEGIN

   //  OPERSQL:=' insert into PCardBlackList_bank_bak  select *,GETDATE() from PCardBlackList_bank  WHERE BANKID = '''+MAINCLASS.bankid+'''';
   //  OPDb.ExecSQL(opersql);
     OPERSQL:= 'DELETE FROM  PCardBlackList_bank_middle WHERE customerid is not null and BANKID = '''+MAINCLASS.bankid+'''';
     OPDb.ExecSQL(opersql);

  END;

  OpDB.BeginTrans;
  OperSql:=tableName+tempStr+')';
  if not OPDb.ExecSQL(opersql) then
  begin
    Tempstr:=OpDB.FSQLError;
    if (Pos('3621',Tempstr)>0) or (Pos('2627',LowerCase(Tempstr))>0) or
           (Pos('Ψһ',Tempstr)>0) or (Pos('unique',LowerCase(Tempstr))>0) or
           (Pos('Լ��',Tempstr)>0) or (Pos('constraint',LowerCase(Tempstr))>0) or
           (Pos('�ظ�',Tempstr)>0) or (Pos('duplicate',LowerCase(Tempstr))>0) or
           (Pos('����',Tempstr)>0) or (Pos('primary',LowerCase(Tempstr))>0) then
    begin
       OpDb.RollBack;
       result:=True;
       exit;
    end
    else
    begin
     Tempstr := '�ϴ��ļ����裬�������ݿ�ʧ�ܣ�ԭ��'+opersql+','+OpDB.FSQLError;
     ErrorCode:=4;
     ErrorStr:=Tempstr;
     WriteLog(Tempstr);
     WriteLog('SQL��䣺'+opersql);
     OpDb.RollBack;
     Exit;
    end;
  end;
  try
      OpDB.Commit;
  except
  end;
  result:=True;
end;


procedure TProcessList.SetConnected(Value: Boolean);
begin
  OpDb.Connected := Value;
 //Opdb.ExecSQL('alter session set nls_date_format=''yyyy-mm-dd hh24:mi:ss''');
  tmpOpDB.Connected:=Value;
end;

{���������ļ����ϴ��ϴ�ʱ��}
procedure TProcessList.SetLastUpTime(aLastUpTime: string);
var
  Inif  : TIniFile;
begin
  Inif:= TIniFile.Create(ExtractFilePath(Application.ExeName)+IniFileName);
  try
    Inif.WriteString('FTP����','��һ���ϴ�ʱ��',aLastUpTime);
  finally
    FreeAndNil(Inif);
  end;
  FLastUpTime := aLastUpTime;
end;

 

function  TProcessList.UpLoadFile(UFileName: String): integer;
var
  FilePath : string;
begin
 WriteLog('SQL��䣺sss');
  result   := nothisfile;
  FilePath := UYearFolder+'\'+UFileName ;
  WriteLog('AAA'+FilePath);
  if not FileExists(FilePath) then exit;
  try
     WriteLog('SQL��䣺ggg');
    fIDFtp.Connect(true,ConnTimeOut);
  except
    result := OtherErr;
   
    {ʧ����ָ�����}
   // RollBackLoadFile(UFileName);
    exit;
  end;
  if not fIDFtp.Connected then
  begin
    result := cannotConn;

    {ʧ����ָ�����}
   // RollBackLoadFile(UFileName);
    exit;
  end;
  try

      try
    fIdFtp.ChangeDir(FTPUFolder);
     if fidftp.Size(UFileName)<> -1 then   fidftp.Delete(UFileName);


      fIdFtp.put(FilePath,UFileName,true);

    except
      result := OtherErr;
      {ʧ����ָ�����}
     // RollBackLoadFile(UFileName);
      Exit;
    end;
    result := RunOk;
  finally
    FIdFtp.Quit;
  end;
end;

procedure TProcessList.WriteLog(Str: String);
var
  TxtFile : TextFile;
  FileName,FilePath,TxtStr : string;
begin
  //if FIsLog=0 then
  //  Exit;
    
  FileName := formatdatetime('yyyymmdd',now);
  FilePath := LogYearFolder+'\'+FileName+'.txt';
  AssignFile(txtFile,FilePath);
  try
    if not FileExists(FilePath) then
      Rewrite(TxtFile)
    else
      Append(TxtFile);

    TxtStr := formatdatetime(DateTimeFormat,now)+ ' '+Str;
    writeln(TxtFile,TxtStr);
  finally
    closefile(txtFile);
  end;
end;


end.