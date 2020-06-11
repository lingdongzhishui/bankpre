(*******************************************************************************
  ADOConnection连接池
   池满的情况下 池子ADO连接 动态创建
   系统默认池子中 一个小时以上未用的 ADOConnection 连接 系统自动释放
   使用如下
   先Uses SQLADOPoolUnit 单元
   在程序初始化时(initialization)创建连接池类
   ADOConfig := TADOConfig.Create('SERVERDB.LXH');
   ADOXPool := TADOPool.Create(15);
   在程序关闭时(finalization)释放连接池类
   ADOPool.Free;
   ADOConfig.Free;
   调用如下
  try
    ADOQuery.Connecttion:= ADOPool.GetCon(ADOConfig);
    ADOQueryt.Open;
  finally
    ADOPool.PutCon(ADOQuery.Connecttion);
  end;
作者:何应祖(QQ:306446305)
  2012-10
如有优化 请传作者一份 。谢谢！
********************************************************************************)
 
unit SQLADOPoolUnit;
 
interface
 
uses
  Windows,SqlExpr,SysUtils, Classes,ExtCtrls, DateUtils,DB, ADODB,IniFiles,
  Messages, Provider;
 
type// 数据库类型
  TDBType=(Access,SqlServer,Oracle);
 
//数据库配置   ADO
type
  TADOConfig = class
    //数据库配置
    ConnectionName :string;//连接驱动名字
    ProviderName :string;//通用驱动
    DBServer:string;  //数据源 --数据库服务器IP
    DataBase :string; //数据库名字  //sql server连接时需要数据库名参数--数据库实例名称
    OSAuthentication:Boolean;  //是否是windows验证
    UserName :string; //数据库用户
    PassWord :string; //密码
    AccessPassWord:string;  //Access可能需要数据库密码
    Port:integer;//数据库端口
    //
    DriverName :string;//驱动
    HostName :string;//服务地址
    //端口配置
    TCPPort:Integer; //TCP端口
    HttpPort:Integer; //http 端口
    LoginSrvUser:string;//验证中间层服务登录用户
    LoginSrvPassword:string;//验证登录模块密码
  public
    constructor Create(iniFile :String);overload;
    destructor Destroy; override;
  end;
 
type
  TADOCon = class
  private
    FConnObj:TADOConnection;  //数据库连接对象
    FAStart: TDateTime;        //最后一次活动时间
 
    function GetUseFlag: Boolean;
    procedure SetUseFlag(value: Boolean);
  public
    constructor Create(ADOConfig :TADOConfig);overload;
    destructor Destroy;override;
    //当前对象是否被使用
    property UseFlag :boolean read GetUseFlag write SetUseFlag ;
    property ConnObj :TADOConnection read FConnObj;
    property AStart :TDateTime read FAStart write FAStart;
  end;
 
type
  TADOPool = class
    procedure OnMyTimer(Sender: TObject);//做轮询用
  private
    FSection :TRTLCriticalSection;
    FPoolNumber :Integer;     //池大小
    FPollingInterval :Integer;//轮询时间 以 分 为单位
    FADOCon :TADOCon;
    FList :TList;             //用来管理连接TADOCobbler
    FTime :TTimer;            //主要做轮询
    procedure Enter;
    procedure Leave;
    function SameConfig(const Source:TADOConfig; Target:TADOCon):Boolean;
    function GetConnectionCount: Integer;
  public
    constructor Create(const MaxNumBer:Integer;FreeMinutes :Integer= 60;TimerTime:Integer = 5000);overload;
    destructor Destroy;override;
    //从池中取出可用的连接。
    function GetCon(const tmpConfig :TADOConfig):TADOConnection;
    //把用完的连接放回连接池。
    procedure PutCon(const ADOConnection :TADOConnection);
    //释放池中许久未用的连接，由定时器定期扫描执行
    procedure FreeConnection;
    //当前池中连接数.
    property ConnectionCount: Integer read GetConnectionCount;
  end;
 
var
  ADOPool: TADOPool;
  ADOConfig: TADOConfig;
implementation
   uses
     Uwork;
{ TADOConfig }
constructor TADOConfig.Create(iniFile :String);
var
  DBIniFile: TIniFile;
begin
  try
    DBIniFile := TIniFile.Create(iniFile);
    ConnectionName := DBIniFile.ReadString('db','ConnectionName', 'SQLConnection');
    DriverName := DBIniFile.ReadString('db','DriverName', 'MSDASQL');
    ProviderName := DBIniFile.ReadString('db','ProviderName', 'MSDASQL');
    DBServer:= DBIniFile.ReadString('db','dbserverip', '127.0.0.1');
    HostName := DBIniFile.ReadString('db','HostName', '127.0.0.1');
    DataBase := DBIniFile.ReadString('db','DataBase', 'db_center');
    Port:=DBIniFile.ReadInteger('db','Port', 1433);
    UserName := DBIniFile.ReadString('db','UserName', 'Sa');
    PassWord := DBIniFile.ReadString('db','pwd', 'Sa');
    LoginSrvUser := DBIniFile.ReadString('db','LoginSrvUser', 'hyz');
    LoginSrvPassword := DBIniFile.ReadString('db','LoginSrvPassword', 'hyz');
    TCPPort := DBIniFile.ReadInteger('db','TCPPort', 211);
    HttpPort := DBIniFile.ReadInteger('db','HttpPort', 2110);
    OSAuthentication := DBIniFile.ReadBool('db','OSAuthentication', False);
 
    if Not FileExists(iniFile) then
    begin
      If Not DirectoryExists(ExtractFilePath(iniFile)) Then ForceDirectories(ExtractFilePath(iniFile));
      DBIniFile.WriteString('Connection','ConnectionName', ConnectionName);
      DBIniFile.WriteString('Connection','DriverName', DriverName);
      DBIniFile.WriteString('Connection','HostName', HostName);
      DBIniFile.WriteString('Connection','DBServer', HostName);
      DBIniFile.WriteString('Connection','DataBase', DataBase);
 //     DBIniFile.WriteString('Connection','Port',Port);
      DBIniFile.WriteString('Connection','UserName', UserName);
      DBIniFile.WriteString('Connection','PassWord', PassWord);
      DBIniFile.WriteString('Connection','LoginSrvUser', LoginSrvUser);
      DBIniFile.WriteString('Connection','LoginSrvPassword', LoginSrvPassword);
      DBIniFile.WriteInteger('Connection','TCPPort', TCPPort);
      DBIniFile.WriteInteger('Connection','HttpPort', HttpPort);
      DBIniFile.WriteBool('Connection','OSAuthentication', OSAuthentication);
    end;
  finally
    FreeAndNil(DBIniFile);
  end;
end;
 
destructor TADOConfig.Destroy;
begin
  inherited;
end;
 
{ TADOCon }
constructor TADOCon.Create(ADOConfig: TADOConfig);
var
  str:string;
begin
  str:='Provider=SQLOLEDB.1;Password=SXETCqfkj@10141612;Persist Security Info=True;User ID=sa;Initial Catalog=db_center;Data Source=10.14.161.2';
//  str:='Provider=SQLOLEDB.1;Password=thunis;Persist Security Info=True;User ID=sa;Initial Catalog=db_center;Data Source=192.168.1.122';
  FConnObj:=TADOConnection.Create(nil);
  with FConnObj do
  begin
    LoginPrompt:=False;
    Tag:=GetTickCount;
    ConnectionTimeout:=18000;
    Provider:=ADOConfig.ProviderName;
    {Properties['Data Source'].Value:=ADOConfig.DBServer;
    Properties['User ID'].Value:=ADOConfig.UserName;
    Properties['Password'].Value:=ADOConfig.PassWord;
    Properties['Initial Catalog'].Value:=ADOConfig.DataBase;
     }
    ConnectionString:=str;
    try
      Connected:=True;
    except
      raise Exception.Create('数据库连接失败');
    end;
  end;
end;
 
destructor TADOCon.Destroy;
begin
  FAStart := 0;
  if Assigned(FConnObj) then
  BEGIN
    if FConnObj.Connected then FConnObj.Close;
    FreeAndnil(FConnObj);
  END;
  inherited;
end;
 
 
procedure TADOCon.SetUseFlag(value :Boolean);
begin
  //False表示闲置，True表示在使用。
  if not value then
    FConnObj.Tag := 0
  else
    begin
    if FConnObj.Tag = 0 then FConnObj.Tag := 1;  //设置为使用标识。
    FAStart := now;                              //设置启用时间 。
    end;
end;
 
Function TADOCon.GetUseFlag :Boolean;
begin
  Result := (FConnObj.Tag>0);  //Tag=0表示闲置，Tag>0表示在使用。
end;
 
 
{ TADOPool }
constructor TADOPool.Create(const MaxNumBer:Integer;FreeMinutes :Integer= 60;TimerTime:Integer = 5000);
begin
  InitializeCriticalSection(FSection);
  FPOOLNUMBER := MaxNumBer; //设置池大小
  FPollingInterval := FreeMinutes;// 连接池中  FPollingInterval 以上没用的 自动回收连接池
  FList := TList.Create;
  FTime := TTimer.Create(nil);
  FTime.Enabled := False;
  FTime.Interval := TimerTime;//5秒检查一次
  FTime.OnTimer := OnMyTimer;
  FTime.Enabled := True;
end;
 
destructor TADOPool.Destroy;
var
  i:integer;
begin
  FTime.OnTimer := nil;
  FTime.Free;
  for i := FList.Count - 1 downto 0  do
  begin
    try
      FADOCon := TADOCon(FList.Items[i]);
      if Assigned(FADOCon) then
         FreeAndNil(FADOCon);
      FList.Delete(i);
    except
    end;
  end;
  FList.Free;
  DeleteCriticalSection(FSection);
  inherited;
end;
 
procedure TADOPool.Enter;
begin
//  mainclass.WriteLog('进入连接池。。。。');
  EnterCriticalSection(FSection);
end;
 
procedure TADOPool.Leave;
begin
//  mainclass.WriteLog('释放连接池。。。。');
  LeaveCriticalSection(FSection);
end;
 
//根据字符串连接参数 取出当前连接池可以用的TADOConnection
function TADOPool.GetCon(const tmpConfig :TADOConfig):TADOConnection;
var
  i:Integer;
  IsResult :Boolean; //标识
  CurOutTime:Integer;
begin
  Result := nil;
  IsResult := False;
  CurOutTime := 0;
  Enter;
  try
    for I := 0 to FList.Count - 1 do
    begin
      FADOCon := TADOCon(FList.Items[i]);
      if not FADOCon.UseFlag then //可用
        if SameConfig(tmpConfig,FADOCon) then  //找到
        begin
          FADOCon.UseFlag := True; //标记已经分配用了
          Result :=  FADOCon.ConnObj;
          IsResult := True;
          Break;//退出循环
        end;
    end; // end for
  finally
    Leave;
  end;
  if IsResult then Exit;
  //池未满 新建一个
  Enter;
  mainclass.WriteLog('当前连接池中连接数量：'+inttostr(FList.Count));
  try
    if FList.Count < FPOOLNUMBER then //池未满
    begin
      FADOCon := TADOCon.Create(tmpConfig);
      FADOCon.UseFlag := True;
      Result :=  FADOCon.ConnObj;
      IsResult := True;
      FList.Add(FADOCon);//加入管理队列
    end;
  finally
    Leave;
  end;
  if IsResult then Exit;
  //池满 等待 等候释放
  while True do
  begin
    Enter;
    try
      for I := 0 to FList.Count - 1 do
      begin
        FADOCon := TADOCon(FList.Items[i]);
        if SameConfig(tmpConfig,FADOCon) then  //找到
          if not FADOCon.UseFlag then //可用
          begin
            FADOCon.UseFlag := True; //标记已经分配用了
            Result :=  FADOCon.ConnObj;
            IsResult := True;
            Break;//退出循环
          end;
      end; // end for
      if IsResult then Break; //找到退出
    finally
      Leave;
    end;
    //如果不存在这种字符串的池子 则 一直等到超时
    if CurOutTime >= 5000 * 6 then  //1分钟
    begin
      raise Exception.Create('连接超时!');
      Break;
    end;
    Sleep(500);//0.5秒钟
    CurOutTime := CurOutTime + 500; //超时设置成60秒
  end;//end while
end;
 
procedure TADOPool.PutCon(const ADOConnection :TADOConnection);
var i :Integer;
begin
  {
  if not Assigned(ADOConnection) then Exit;
  try
    Enter;
    ADOConnection.Tag := 0;  //如此应该也可以 ，未测试...
  finally
    Leave;
  end;
  }
  Enter;  //并发控制
  try
    for I := FList.Count - 1 downto 0 do
    begin
      FADOCon := TADOCon(FList.Items[i]);
      if FADOCon.ConnObj=ADOConnection then
      begin
        FADOCon.UseFlag := False;
        Break;
      end;
    end;
  finally
    Leave;
  end;
end;
 
procedure TADOPool.FreeConnection;
var
  i:Integer;
  function MyMinutesBetween(const ANow, AThen: TDateTime): Integer;
  begin
    Result := Round(MinuteSpan(ANow, AThen));
  end;
begin
  Enter;
  try
    for I := FList.Count - 1 downto 0 do
    begin
      FADOCon := TADOCon(FList.Items[i]);
      if MyMinutesBetween(Now,FADOCon.AStart) >= FPollingInterval then //释放池子许久不用的ADO
      begin
        FreeAndNil(FADOCon);
        FList.Delete(I);
      end;
    end;
  finally
    Leave;
  end;
end;
 
procedure TADOPool.OnMyTimer(Sender: TObject);
begin
  FreeConnection;
end;
 
function TADOPool.SameConfig(const Source:TADOConfig;Target:TADOCon): Boolean;
begin
//考虑到支持多数据库连接，需要本方法做如下等效连接判断.如果是单一数据库，可忽略本过程。
{  Result := False;
  if not Assigned(Source) then Exit;
  if not Assigned(Target) then Exit;
  Result := SameStr(LowerCase(Source.ConnectionName),LowerCase(Target.ConnObj.Name));
  Result := Result and SameStr(LowerCase(Source.DriverName),LowerCase(Target.ConnObj.Provider));
  Result := Result and SameStr(LowerCase(Source.HostName),LowerCase(Target.ConnObj.Properties['Data Source'].Value));
  Result := Result and SameStr(LowerCase(Source.DataBase),LowerCase(Target.ConnObj.Properties['Initial Catalog'].Value));
  Result := Result and SameStr(LowerCase(Source.UserName),LowerCase(Target.ConnObj.Properties['User ID'].Value));
  Result := Result and SameStr(LowerCase(Source.PassWord),LowerCase(Target.ConnObj.Properties['Password'].Value));
  //Result := Result and (Source.OSAuthentication = Target.ConnObj.OSAuthentication);
  }
  Result := True;
end;
 
Function TADOPool.GetConnectionCount :Integer;
begin
  Result := FList.Count;
end;
//初始化时创建对象
{initialization
  //ini文件后缀更名为LXH，方便远程安全下载更新
  ADOConfig := TADOConfig.Create(ExtractFilePath(ParamStr(0))+'control.ini');
  ADOPool := TADOPool.Create(150);
finalization
  if Assigned(ADOPool) then ADOPool.Free;
  if Assigned(ADOConfig) then ADOConfig.Free;  }
 
end.
 