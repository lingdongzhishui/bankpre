
unit UnitProcessList;

interface

uses
  Windows, Messages, SysUtils, Classes,Forms,Dialogs,IniFiles ,IdFTP, IdFTPCommon,U_OpDB,StdCtrls,strutils,uwork,DateUtils;

const
  IniFileName ='control.ini';

  {FTP操作结果}
  RunOK       = 0;   {成功}
  CanNotConn  = -1;  {连接不上}
  OtherErr    = -2;  {其它错误}
  NoThisFile  = -3;  {没有找到文件}

  ConnTimeOut = 60;   {连接超时时间}

  DateTimeFormat  =   'yyyy-mm-dd hh:nn:ss';
  SDateFormat     =   'yyyy-mm-dd';
  STime = ' 08:00:00';
  ETime = ' 07:59:59';

  Decollator='|';            //分割符号

type
  {文件头信息}
  RFilePack=record
    DirectTag:string;       //方向控制
    FileName:String;        //文件名称
    SendBh:string;          //发送编号
    ReceiveBh:string;       //接收方编号
    Optime:string;          //接收文件日期时间
    SubPackCout:Integer;    //子包个数
    Jym:string;             //校验码
  end;

  {子包头信息}
  RsubPack=record
    subCode:Integer;        //子包代码
    tableName:string;       //对应的表名
    recCount:Integer;       //记录数
    opertype:string;        //操作类型 i 新增d 删除 u更新
    opersql:String;         //生成sql语句
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

    {生成子包数据体返回加密留待校验编码用}

    function  GenSubBodyFile(FileCode:Integer; BankID,WorkDate,filename,tabname:String; var FileStr:String):Boolean;

    {保存单条记录到数据库中}

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
    txtFile  : TextFile;  //文件
    qs_verifycode:string;
    DownRecordNum:integer;
    procedure CreateYearFolder;
    function  DownLoadFile(DFileName:string) : integer;
    function  UpLoadFile(UFileName:String) : integer;
    function Getfilename:string;
    procedure RollBackLoadFile(UFileName: string);
    {处理下载文件}
    Procedure ProcessDownFile(FileName:string);

    {查询数据库中该文件是否保存}
    function  FindBankTransList(FileType:String;BankID:Integer;Date:TDateTime) : Boolean;

    function  ProcessUpFile(BankID,WorkDate,FileType,tabname:String;var FileName,sPath: string) : Boolean;

    Procedure WriteLog(Str:String);
     function  SaveFileDb(StrtableId:Integer;StrValue:String;filename:string):boolean;
    procedure LoadParam;

    Constructor Create;

    Destructor Destroy;override;

    procedure ClearDateTime;

    {生成交换文件}
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
    Inif.WriteString('FTP设置','起始日期','');
    Inif.WriteString('FTP设置','结束日期','');
  finally
    FreeAndNil(Inif);
  end;
end;

{按规定格式生成字符串,位数不足补AddChar，flag=1左补，flag=2右补}

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
//WriteLog('准备加载参数');
 LoadParam;
             {获取配置文件参数}
//  WriteLog('初始化ftp') ;
  CreateFTPCtrl;
         {初始化ftp}
 // WriteLog('初始化数据库')  ;
  CreateDBCtrl;            {初始化数据库}
 // WriteLog('创建上传、下载、日志文件夹');
  CreateYearFolder;        {创建上传、下载、日志文件夹}
 
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

{创建上传、下载、日志文件夹}
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
      WriteLog(trim(DFileName)+'下载失败1!!!'+e.message);
    end;
    end;
  finally
    FIdFtp.Quit;
    freeandnil(ListStr);
    freeandnil(ListStr2);
  end;
end;

{参数说明：
   FileType:传CZ,BC,Kj CZ_充值对账文件,BC_绑定卡黑名单文件，KJ_绑定卡扣款结果文件
   BankID:银行ID
}

function TProcessList.FindBankTransList(FileType:String;BankID:Integer;Date:TDateTime):Boolean;
var
  DateStr,SqlStr:String;
begin
  result := false;
  {格式化日期}
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
  StrpacketH :string;//文件头
  StrDirctTag:String;//方向
  Decollator :String;//分割符号
  SubpacketNum :string;//子包个数
  SubPackStr   :String;
  FilePath:string;
  li:integer;
   tmpbuf:array  of Byte;
  sql:string;
begin
  Result:=False;

  if FileType='BK' then //绑定卡扣款文件
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
  if FileType='TF' then //储值卡退费文件
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
  if FileType='DZ' then //打折扣款文件
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
   if FileType='JZ' then //截止付扣款文件
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
   if FileType='Y2' then //一发密钥结果文件
  begin
       if trim(StrFileName)= '' then
       begin
         StrFileName:='Y2'+ Sendcode+ReceiveCode+FormatdateTime('YYYYMMDDHHNNSS',Now)+'.TXT' ;
         sql:= ' update ETCBankCardOneReleaseKeyparent set sendfilename = '''+strfilename+ ''',checkkeyoptime=getdate()  where  bankid = '''+mainclass.bankid +'''  and filename= '''+tabname+'''';
         opdb.ExecSQL(sql)  ;
       end;
  end;
  if FileType='YC' then //二发异常文件
  begin
       if trim(StrFileName)= '' then
       begin
         StrFileName:='YC'+ Sendcode+ReceiveCode+FormatdateTime('YYYYMMDDHHNNSS',Now)+'.TXT' ;
       end;
  end;
   if FileType='LF' then //联系方式
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
   StrDirctTag:='0';  //ETC运营中心 代理机构；
  // StrDirctTag :='1400000001';
   Decollator :='|';  //分割符号
    if filetype='Y2' then
       SubpacketNum:='1' //1个子包
    else

   SubpacketNum:='2'; //两个子包

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
   if FileType='YC' then   //二发异常
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
    if FileType='LF' then   //联系方式
    begin
     if not GenSubBodyFile(5013,ReceiveCode,WorkDate,StrFileName,tabname,subPackStr) then Exit;
    end;
   //写检验编码
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
  IntRecNum:Integer;//记录数
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
  if fileCode=5001 then //ETC卡扣款汇总数据；
  begin
        sSql:='select  BalanceDate , bankid  , Totalcount , TotalAmount   '+
        ' FROM ETCBindCardCollectDeductMoneyList_OnLine with (nolock)  where balancedate = '+formatdatetime('yyyymmdd',Now)
        +' and spare2= 0 and  bankid = '''+mainclass.bankid +'''';

       if not OpDb.QuerySQL(sSql) then
       begin
         ErrorCode:=1;
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
       end;
      if OpDb.Query.IsEmpty then
      begin
        ErrorCode:=2;
        ErrorStr:='无绑定卡扣款汇总数据！';
        WriteLog(ErrorStr);
        Exit;
      end;
      IntRecNum:=OpDb.Query.RecordCount;
      tempStr:=IntToStr(FileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
      Writeln(txtFile,tempStr);
      //明细数据
      OpDb.Query.First;

      while not OpDb.Query.eof do
      begin
      ls_balacedate :=OpDb.Query.fieldbyname('BalanceDate').AsString ;
       tempStr  :=     OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalCount').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalAmount').AsString+Decollator+#13;
       Writeln(txtFile,tempStr);//写流水
       OpDb.Query.next;
      end;
  end ;
  if fileCode=8001 then //ETC储值卡退费汇总数据；
  begin
        sSql:='select  BalanceDate , bankid  , Totalcount , TotalAmount   '+
        ' FROM pre_cardbackfee with (nolock)  where balancedate = '+formatdatetime('yyyymmdd',Now)
        +' and resatus= 0 and  bankid = '''+mainclass.bankid +'''';

       if not OpDb.QuerySQL(sSql) then
       begin
         ErrorCode:=1;
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
       end;
      if OpDb.Query.IsEmpty then
      begin
        ErrorCode:=2;
        ErrorStr:='ETC储值卡退费汇总数据！';
        WriteLog(ErrorStr);
        Exit;
      end;
      IntRecNum:=OpDb.Query.RecordCount;
      tempStr:=IntToStr(FileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
      Writeln(txtFile,tempStr);
      //明细数据
      OpDb.Query.First;

      while not OpDb.Query.eof do
      begin
//      ls_balacedate :=OpDb.Query.fieldbyname('BalanceDate').AsString ;
       tempStr  :=     OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalCount').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalAmount').AsString+Decollator+#13;
       Writeln(txtFile,tempStr);//写流水
       OpDb.Query.next;
      end;
  end ;
   if fileCode=5009 then //打折扣款汇总数据；
  begin
        sSql:='select  BalanceDate , bankid  , Totalcount , TotalAmount   '+
        ' FROM ETCBindCardCollectDeductMoneyList_OnLine with (nolock)  where balancedate = '+formatdatetime('yyyymmdd',Now)
        +' and spare2= 2 and  bankid = '''+mainclass.bankid +'''';

       if not OpDb.QuerySQL(sSql) then
       begin
         ErrorCode:=1;
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
       end;
      if OpDb.Query.IsEmpty then
      begin
        ErrorCode:=2;
        ErrorStr:='无打折扣款汇总数据！';
        WriteLog(ErrorStr);
        Exit;
      end;
      IntRecNum:=OpDb.Query.RecordCount;
      tempStr:=IntToStr(FileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
      Writeln(txtFile,tempStr);
      //明细数据
      OpDb.Query.First;

      while not OpDb.Query.eof do
      begin
      ls_balacedate :=OpDb.Query.fieldbyname('BalanceDate').AsString ;
       tempStr  :=     OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalCount').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalAmount').AsString+Decollator+#13;
       Writeln(txtFile,tempStr);//写流水
       OpDb.Query.next;
      end;
  end ;
    if fileCode=6003 then //ETC卡JZF汇总数据；
  begin
        sSql:='select  BalanceDate , bankid  , Totalcount , TotalAmount   '+
        ' FROM ETCBindCardCollectDeductMoneyList_OnLine with (nolock) where balancedate = convert(varchar,getdate(),112)'
        +' and spare2= 1 and  bankid = '''+mainclass.bankid +'''';

       if not OpDb.QuerySQL(sSql) then
       begin
         ErrorCode:=1;
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
       end;
      if OpDb.Query.IsEmpty then
      begin
        ErrorCode:=2;
        ErrorStr:='无绑定卡扣款汇总数据！';
        WriteLog(ErrorStr);
        Exit;
      end;
      IntRecNum:=OpDb.Query.RecordCount;
      tempStr:=IntToStr(FileCode)+Decollator+IntToStr(IntRecNum)+Decollator+
       operType+Decollator+#13;
      Writeln(txtFile,tempStr);
      //明细数据
      OpDb.Query.First;

      while not OpDb.Query.eof do
      begin
      ls_balacedate :=OpDb.Query.fieldbyname('BalanceDate').AsString ;
       tempStr  :=     OpDb.Query.fieldbyname('BalanceDate').AsString+Decollator+
                       OpDb.Query.fieldbyname('BankID').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalCount').AsString+Decollator+
                       OpDb.Query.fieldbyname('TotalAmount').AsString+Decollator+#13;
       Writeln(txtFile,tempStr);//写流水
       OpDb.Query.next;
      end;
  end ;
  if fileCode=5002 then  //ETC绑定卡扣款明细数据；
  begin
        sSql:=' select distinct convert(varchar,getdate(),112) BalanceDate,ListNo,CustomerId , usertype ,username,BankCardID ,pCardNo, right(CardID,16) ETCCardID,totaltoll, '+' REPLACE(memos,''|'',''_'') Remarks ,optime  '+
              ' FROM   ETCBoutToBankfile with (nolock) where convert(varchar,createtime,112) <= convert(varchar,getdate()-1,112) and TotalToll >0 and substring(CardID,9,2)=''23'' '
             +' and spare3=0 and ynok=''N''  and bankid = '''+mainclass.bankid +'''';
        //convert(varchar,createtime,120) <= ''2019-08-27 10:00:00.000''
        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='查询绑定卡扣款明细数据失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='无绑定卡扣款明细数据！';
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
            writeln(txtFile,tempStr);//写流水
            OpDb.Query.next;
       end;
  end;
  if fileCode=8002 then  //ETC储值卡退费明细数据；
  begin
        sSql:=' select convert(varchar,getdate(),112) BalanceDate,RIGHT(wasteno,30) ListNo,CustomerId ,bankcustomername username,bankno,BankCardNO as BankCardID,Linkmantel,'+
        ' cardid as ETCCardID,returnfee as totaltoll,replace(replace(replace(convert(varchar(20),retruntime,120),''-'',''''),'':'',''''),'' '','''') as optime,vehicleplateno,'+
        ' certificateID,NetWorkNO,left(bankdescinfo,2) bankdescinfo from ETCWorknetBusinessReturnMoneyBankInfo_Bank a with (nolock)'+
        ' where convert(varchar,opsystime,112) <= convert(varchar,getdate()-1,112) and returnfee>0 and sendstatus=0 and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='查询储值卡退费明细数据失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='无储值卡退费明细数据！';
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
            writeln(txtFile,tempStr);//写流水
            OpDb.Query.next;
       end;
  end;
  if fileCode=5010 then  //ETC打折扣款明细数据；
  begin
        sSql:=' select distinct convert(varchar,getdate(),112) BalanceDate,RIGHT(ListNo,30) ListNo,CustomerId , usertype ,username,BankCardID ,left(ETCCardID,4) cardid, right(ETCCardID,16) ETCCardID,pCardNo,totaltoll, '+' REPLACE(memos,''|'',''_'') Remarks ,optime,vehtype  '+
              ' FROM   ETCBoutToBankfile with (nolock) where convert(varchar,createtime,112) <= convert(varchar,getdate()-1,112)and TotalToll >0 '
              +'  and spare3=2 and ynok=''N'' and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='无打折扣款明细数据！';
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
            writeln(txtFile,tempStr);//写流水
            OpDb.Query.next;
       end;
  end;
    if fileCode=5013 then     //ETC联系电话
  begin
    sSql:='select a.CardID,b.MobileNo from ETCCardData a with (nolock) left join ETCCustomerInfo b with (nolock) on a.CustomerId=b.CustomerId'+
         ' where a.CardState=1 and b.MobileNo<>'''' and SUBSTRING(a.CardID,9,4)=2399';
    if not OpDb.QuerySQL(sSql) then
        begin
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
    OpDb.Query.first;
       while not OpDb.Query.eof do
       begin
          tempStr:=    OpDb.Query.fieldbyname('cardid').AsString+Decollator+
                       OpDb.Query.fieldbyname('MobileNo').AsString+Decollator+#13;;
            writeln(txtFile,tempStr);//写流水
            OpDb.Query.next;
       end;
  end;
    if fileCode=6004 then  //ETC绑定卡JZF扣款明细数据；
  begin
        sSql:=' select distinct convert(varchar,getdate(),112) BalanceDate,RIGHT(ListNo,30) ListNo,CustomerId , usertype ,UserName,BankCardID ,'
        +'left(ETCCardID,4) cardid, right(ETCCardID,16) ETCCardID,pCardNo,totaltoll, '+' REPLACE(memos,''|'',''_'') Remarks ,optime  '+
              ' FROM   ETCBoutToBankfile with (nolock) where convert(varchar,createtime,112) <= convert(varchar,getdate()-1,112) '
              +'and spare3=1 and ynok=''N'' and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='无绑定卡JZF扣款明细数据！';
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
            writeln(txtFile,tempStr);//写流水
            OpDb.Query.next;
       end;
  end;
  if fileCode=5014 then  //ETC二次发行异常数据；
  begin
        sSql:=' select OrderNO,BankID,NetWorkID,PCardID,Vehplate,OpDesc,BatchNO from ETCBankCardSecondReleaseResult'+
              'where OpStatus>1 and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='无二发异常数据！';
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
            writeln(txtFile,tempStr);//写流水
            OpDb.Query.next;
       end;
  end;
  if  fileCode=7002 then
  begin
        sSql:=' select netcardno,cardno FROM   dbo.ETCBankCardOneReleaseKey where filename='''+tabname+''' and bankid = '''+mainclass.bankid +'''';

        if not OpDb.QuerySQL(sSql) then
        begin
         ErrorCode:=1;
         ErrorStr :='执行SQL失败:'+sSql;
         WriteLog(ErrorStr);
         Exit;
        end;
        if OpDb.Query.IsEmpty then
        begin
         ErrorCode:=2;
         ErrorStr:='没有需要申请的密钥明细';
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
                        //银行名称
                        TmpStr := TmpStr + Decollator + mainclass.bankname;
                        //卡网络编号
                        TmpStr := TmpStr + Decollator + fieldbyname('netcardno').AsString ;
                        //卡号
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
               //获得加密机的密钥
                     if not getcupcardkey(pchar(rightstr(cardno,16)),pchar(mainclass.SJMJSERVERIP), @outputKey) then
                     begin
                         //Application.MessageBox('生成密钥错误！', '提示信息', MB_OK + MB_ICONINFORMATION);
                         //exit;

                         tmpstr:=tmpstr+Decollator+Decollator+Decollator+Decollator
                         +Decollator+Decollator+Decollator+Decollator
                         +Decollator+Decollator+Decollator+Decollator+Decollator+Decollator+'1';
                     end
                     else
                     begin
                        TmpStr := mainclass.bankid;
                        //银行名称
                        TmpStr := TmpStr + Decollator + mainclass.bankname;
                        //卡网络编号
                        TmpStr := TmpStr + Decollator + fieldbyname('netcardno').AsString ;
                        //卡号
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
               writeln(txtFile,tmpStr);//写流水
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
      mainclass.WriteLog('获取文件名：'+filename);
      mainclass.WriteLog('D:\bankserver\ftpdir\detail\'+InttoStr(sYear)+'\'+'KJ'+mainclass.bankid+'1400000'+datestr+'*.*');

//    while findnext(r)=0 do
//    filelist.add(filename);
    findclose(r);
    //这样filelist中就保存了你输入的文件夹下的所有文件，我下面显示在一个memo组件中了
  {  for i:=0 to filelist.count-1 do
    begin
      if hoursBetween(GetFileEditTime('D:\bankserver\ftpdir\detail\'+InttoStr(sYear)+'\'+filelist[i]),Now)<15  then
//            deletefile('E:\test\'+filelist[i]); 删除文件
//       mmo1.lines.Append(memo1.lines.text+filelist[i]+#13);

          mainclass.WriteLog(filelist[i]+'距离当前小时数：'+Inttostr(hoursBetween(GetFileEditTime('D:\bankserver\ftpdir\detail\'+InttoStr(sYear)+'\'+filelist[i]),Now)));
    end; }

//    filelist.free;
    Result:=filename;

end;


//获取文件的创建时间
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

//获取文件的修改时间
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
    mainclass.Encryptbcb(key1,indata,outdata);     //解密： Decryptbcb
    result:=mainclass.BytestoHexString(outdata,16);
end;

procedure TProcessList.LoadParam;
var
  Inif  : TIniFile;
begin
  Inif:= TIniFile.Create(ExtractFilePath(Application.ExeName)+IniFileName);
  try
    fIpAddr       := Inif.ReadString('FTP设置','IP地址','127.0.0.1');
    fFtpPort      := Inif.ReadInteger('FTP设置','端口',21);
    fUserName     := inif.ReadString('FTP设置','用户名','sxgs');
    fPassWord     := inif.ReadString('FTP设置','密码','sxgs');
    FTPUFolder    := Inif.ReadString('FTP设置','FTP上传目录','upload');
    FTPDFolder    := Inif.ReadString('FTP设置','FTP下载目录','detail');
    LocalUFolder  := ExtractFilePath(Application.ExeName)+Inif.ReadString('FTP设置','本地上传目录','uploadS');
    LocalDFolder  := ExtractFilePath(Application.ExeName)+Inif.ReadString('FTP设置','本地下载目录','download');
    DbType        := Inif.ReadInteger('db','dbtype',2);
    DbIpAddr      := Inif.ReadString('db','dbserverip','10.14.161.2');
    DbName        := Inif.ReadString('db','database','db_center');
    DbUser        := Inif.ReadString('db','username','sa');
    DbPassword    := Inif.ReadString('db','pwd','SXETCqfkj@1612');
    SendCode      :=Inif.ReadString('文件设置','发送方编码','1400000');
    DateSeparator := '-';
    LongDateFormat:= 'yyyy-mm-dd hh:nn:ss';
    ShortDateFormat := 'yyyy-mm-dd';

  finally
    FreeAndNil(Inif);
  end;
end;


procedure TProcessList.ProcessDownFile(FileName: string);
var
 ResultList:TStringList;//读取拆分结果
 Str:string;
 TempRFilePack:RFilePack;
 TempRsubPack:RsubPack;
 {判断包头包尾变量}
 IsHead:Boolean;        //判断是否是包头
 IsSubPack:Boolean;     //判断是否明细
 SubPackCout:Integer;   //子包个数
 TempRecord:Integer;    //包体记录数
 FilePath : String;     //路径
 txtFile  : TextFile;   //接收的文件
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
    //文件头
    ResultList.Delimiter := '|';
    ResultList.DelimitedText := str;
    tempRFilePack.DirectTag:=ResultList[0];
    tempRFilePack.FileName:=ResultList[1];
    tempRFilePack.SendBh:=ResultList[2];
    tempRFilePack.ReceiveBh:=ResultList[3];
    tempRFilePack.Optime:=ResultList[4];
    //子包数量
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
       if isHead then {处理子包包头}
       begin
         tempRsubPack.subCode  :=StrToInt(ResultList[0]);//子包代码
         tempRsubPack.recCount :=StrToInt(ResultList[1]);//子包流水数量
         DownRecordNum:=tempRsubPack.recCount;
         tempRsubPack.opertype :=ResultList[2];//操作类型
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
  {需要上传的文件名
  OpDB.BeginTrans;
  SqlStr := 'Update ' + ExpTransDetailTB + ' Set FileName = '''+FileName + ''' Where FileName=''0''';
  if not OPDb.ExecSQL(SqlStr) then
  begin
    tmpStr := '上传文件步骤，更新数据库失败，原因：'+OpDB.ErrStr;
    WriteLog(tmpStr);
    WriteLog('SQL语句：'+SqlStr);
    OpDb.RollBack;
    Exit;
  end;}
  Result:=True;
end;

{如果上传失败，则恢复数据}
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
  {从已上传的记帐标示汇总表中删除当前文件对应的汇总数据}
  SqlStr := 'Delete From ' + ' Where FileName = '''+'''';
  OPDb.ExecSQL(SqlStr);
  {将文件中对应的流水设置为未上传}
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
            'CZMoney, QCMoney,MoneyCZ,BKMoney,TKMoney,DateTime)values('; //银行日总对账结果数据
      3002: tableName:='Insert into ETCPreCardRechargeBankTerminalCollectlog_bank(WorkDate,BankID,BankName,NetWorkID,TerminalID,CZTotalMoney,'+
            'CZMoney,QCMoney,MoneyCZ,BKMoney,TKMoney,DateTime)values('; //银行每一个终端的日汇总数据；
      3003:
       tableName:='Insert into ETCPreCardRechargeBanklog_bank(WasteSN,DateTime,NetWorkID,TerminalID,'+
            'CZType, CustomerID,PCardNetID,PCardID,OnlineSN,OfflineSN,Random,MAC1,MAC2,SysBeforeMoney,CardBeforeMoney,CZTotalMoney'+
            ',CZMoney,QCMoney,MoneyCZ,BKMoney,TKMoney,CardAfterMoney,CZResult,Note)values(';//快通卡充值明细数据；
      3004:
       tableName:='Insert into ETCPreCardRechargeBanklog_bank(pcardid,WasteSN,DateTime,NetWorkID,TerminalID,'+
            'CZType, CustomerID,CardBeforeMoney,CZTotalMoney,CZMoney,CZResult,Note)values('''',';//账户充值明细数据；

      4001: tableName:='Insert into PCardBlackList_bankHZ (WorkDate,BankID,BankName,RecordNumber)values('; //快定卡黑名单汇总数据；

      4002: tableName:='Insert into PCardBlackList_bank_middle(ifnew,CustomerID,UserType,UserName,CertificateType,CertificateID,PCardNetID,PCardID,'+
            'BankCardID,TranType,BindingCardBlackCause,BANKID)values('''+if_new+''',';//快定卡黑名单明细数据；
      5003:
      tableName:='Insert into ETCBindCardCollectDeductMoneyList_Bank(procdesc,BalanceDate,BankID,TotalCount,TotalAmount,SucceedCount,SucceedAmount,'+
       ' FailCount,FailAmount,TransferDate)values('''+filename+''',';//绑定卡扣款结果汇总数据；
      5004:
      if (mainclass.bankid='3100000') or (mainclass.bankid='3200000') or (mainclass.bankid='3300000') then
      begin
       tableName:='Insert into ETCBindCardDeductMoneyList_Bank (procdesc,BankID,BalanceDate,ListNo,CustomerID,UserType,UserName,PCardNetID,PCardID,'+
       ' BankCardID,Amount,Result,OpTimes,remarks,discount,integral)values('''+filename+''','''+mainclass.bankid+''',' ;//绑定卡扣款结果明细数据;
      end else
       tableName:='Insert into ETCBindCardDeductMoneyList_Bank (procdesc,BankID,BalanceDate,ListNo,CustomerID,UserType,UserName,PCardNetID,PCardID,'+
       ' BankCardID,Amount,Result,OpTimes,remarks)values('''+filename+''','''+mainclass.bankid+''',' ;//绑定卡扣款结果明细数据;
      5011: tableName:='Insert into ETCBindCardCollectDeductMoneyList_BankDZHZ(FileNameStr,BalanceDate,BankID,TotalCount,TotalAmount,'+
       ' TransferDate)values('''+filename+''',';//打折扣款结果汇总数据；
      5012:
      tableName:='Insert into ETCBindCardDeductMoneyList_BankDZJG (FileNameStr,bankid,dismonth,BalanceDate,ListNo,CustomerID,UserType,UserName,PCardNetID,PCardID,'+
       ' BankCardID,Amount,DisAmount,OpTime)values('''+filename+''','''+mainclass.bankid+''',CONVERT(varchar(6),GETDATE(),112),' ;//打折扣款结果明细数据;
      5005: tableName:='Insert into ETCBindCardCollectDeductMoneyList_Bank_ZF(procdesc,recordcount,BalanceDate,BankID,TotalCount,TotalAmount,SucceedCount,SucceedAmount,'+
       ' FailCount,FailAmount,TransferDate)values('''+filename+''',2,';//JZF扣款结果汇总数据；
      5006:tableName:='Insert into ETCBindCardDeductMoneyList_Bank_ZF (procdesc,BankID,BalanceDate,ListNo,CustomerID,UserType,UserName,pcardnetid,PCardID,'+
       ' BankCardID,Amount,Result,OpTime,remarks)values('''+filename+''','''+mainclass.bankid+''',' ;//JZF卡扣款结果明细数据;
      6001: tableName:='INSERT INTO ETCBankCardBindTab_M (BalanceDate, BankID, TotalCount, SucceedCount, FailCount,hcount, TransferDate) '+
       ' VALUES (';       //绑定结果汇总
      6002: tableName:='INSERT INTO ETCBankCardBindTab_T (ProcessDate, ProcessTime, NetWorkID, TerminalID, BankID, CustomerID,'+
         ' UserType, UserName, CertificateType, CertificateID, PCardNetID, PCardID,VehplateColor,'+
          ' Vehplate,EntrustVerifyCode,  WasteSN, BankCardType, BCertificateType,'+
         ' BVCertificateID,ActiveDate, BankCardID, BUserName, OperatorName, YN)  VALUES ( ';         //绑定结果明细
      7001: tableName:='INSERT INTO ETCBankCardOneReleaseKey (BankID,BankName,NetCardNO,CardNo,filename) VALUES(' ; //一发密钥明细数据信息
//      7002: tableName:='INSERT INTO ETCBankCardOneReleaseKey (BankID,BankName,NetCardNo,CardNo,MK_MF,DAMK_MF,MK_DF01,AMK_DF01,IK_DF01,UK_DF01,DPK1,DPK2,DLK1,DLK2,DTK,'+
//        ' PIN,DPUK_DF01,DRPK_DF01,CardType) VALUES (';   //一发密钥结果明细数据信息
      7003: tableName:='INSERT INTO ETCBankCardSecondReleaseResult (orderno,NetWorkID,TerminalID,BankID,CustomerID,UserType,UserName,CertificateType,CertificateID,Contact,Phone,'+
         ' Mobile,Address,FaxNo,Email,WorkUnit,OfficeAddress,OfficePhone,Vehplate,Vehplatecolor,VehType,VehSeatNum,VehLength,VehWidth,VehHeight,VehEngineNo,VehWheel,VehAxle,'+
         ' VehAxleLen,CarLoad,CarINfo,PCardNetID,PCardID,CardBalance,CardCost,CardMargins,StartDate,EndDate,CardType,BankCardType,BCertificateType,BVCertificateID,ActiveDate,'+
         ' BankCardID,BUserName,OperatorName,OperatorNO,vehcolor,batchno) VALUES (';  //二发结果明细数据信息
  else
  begin
    //未知子包代码;
    ErrorCode:=3;
    ErrorStr:='错误的文件代码';
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
           (Pos('唯一',Tempstr)>0) or (Pos('unique',LowerCase(Tempstr))>0) or
           (Pos('约束',Tempstr)>0) or (Pos('constraint',LowerCase(Tempstr))>0) or
           (Pos('重复',Tempstr)>0) or (Pos('duplicate',LowerCase(Tempstr))>0) or
           (Pos('主键',Tempstr)>0) or (Pos('primary',LowerCase(Tempstr))>0) then
    begin
       OpDb.RollBack;
       result:=True;
       exit;
    end
    else
    begin
     Tempstr := '上传文件步骤，更新数据库失败，原因：'+opersql+','+OpDB.FSQLError;
     ErrorCode:=4;
     ErrorStr:=Tempstr;
     WriteLog(Tempstr);
     WriteLog('SQL语句：'+opersql);
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

{更新配置文件中上次上传时间}
procedure TProcessList.SetLastUpTime(aLastUpTime: string);
var
  Inif  : TIniFile;
begin
  Inif:= TIniFile.Create(ExtractFilePath(Application.ExeName)+IniFileName);
  try
    Inif.WriteString('FTP设置','上一次上传时间',aLastUpTime);
  finally
    FreeAndNil(Inif);
  end;
  FLastUpTime := aLastUpTime;
end;

 

function  TProcessList.UpLoadFile(UFileName: String): integer;
var
  FilePath : string;
begin
 WriteLog('SQL语句：sss');
  result   := nothisfile;
  FilePath := UYearFolder+'\'+UFileName ;
  WriteLog('AAA'+FilePath);
  if not FileExists(FilePath) then exit;
  try
     WriteLog('SQL语句：ggg');
    fIDFtp.Connect(true,ConnTimeOut);
  except
    result := OtherErr;
   
    {失败则恢复数据}
   // RollBackLoadFile(UFileName);
    exit;
  end;
  if not fIDFtp.Connected then
  begin
    result := cannotConn;

    {失败则恢复数据}
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
      {失败则恢复数据}
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
