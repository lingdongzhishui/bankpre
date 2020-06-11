(*******************************************************************************
  ADOConnection���ӳ�
   ����������� ����ADO���� ��̬����
   ϵͳĬ�ϳ����� һ��Сʱ����δ�õ� ADOConnection ���� ϵͳ�Զ��ͷ�
   ʹ������
   ��Uses SQLADOPoolUnit ��Ԫ
   �ڳ����ʼ��ʱ(initialization)�������ӳ���
   ADOConfig := TADOConfig.Create('SERVERDB.LXH');
   ADOXPool := TADOPool.Create(15);
   �ڳ���ر�ʱ(finalization)�ͷ����ӳ���
   ADOPool.Free;
   ADOConfig.Free;
   ��������
  try
    ADOQuery.Connecttion:= ADOPool.GetCon(ADOConfig);
    ADOQueryt.Open;
  finally
    ADOPool.PutCon(ADOQuery.Connecttion);
  end;
����:��Ӧ��(QQ:306446305)
  2012-10
�����Ż� �봫����һ�� ��лл��
********************************************************************************)
 
unit SQLADOPoolUnit;
 
interface
 
uses
  Windows,SqlExpr,SysUtils, Classes,ExtCtrls, DateUtils,DB, ADODB,IniFiles,
  Messages, Provider;
 
type// ���ݿ�����
  TDBType=(Access,SqlServer,Oracle);
 
//���ݿ�����   ADO
type
  TADOConfig = class
    //���ݿ�����
    ConnectionName :string;//������������
    ProviderName :string;//ͨ������
    DBServer:string;  //����Դ --���ݿ������IP
    DataBase :string; //���ݿ�����  //sql server����ʱ��Ҫ���ݿ�������--���ݿ�ʵ������
    OSAuthentication:Boolean;  //�Ƿ���windows��֤
    UserName :string; //���ݿ��û�
    PassWord :string; //����
    AccessPassWord:string;  //Access������Ҫ���ݿ�����
    Port:integer;//���ݿ�˿�
    //
    DriverName :string;//����
    HostName :string;//�����ַ
    //�˿�����
    TCPPort:Integer; //TCP�˿�
    HttpPort:Integer; //http �˿�
    LoginSrvUser:string;//��֤�м������¼�û�
    LoginSrvPassword:string;//��֤��¼ģ������
  public
    constructor Create(iniFile :String);overload;
    destructor Destroy; override;
  end;
 
type
  TADOCon = class
  private
    FConnObj:TADOConnection;  //���ݿ����Ӷ���
    FAStart: TDateTime;        //���һ�λʱ��
 
    function GetUseFlag: Boolean;
    procedure SetUseFlag(value: Boolean);
  public
    constructor Create(ADOConfig :TADOConfig);overload;
    destructor Destroy;override;
    //��ǰ�����Ƿ�ʹ��
    property UseFlag :boolean read GetUseFlag write SetUseFlag ;
    property ConnObj :TADOConnection read FConnObj;
    property AStart :TDateTime read FAStart write FAStart;
  end;
 
type
  TADOPool = class
    procedure OnMyTimer(Sender: TObject);//����ѯ��
  private
    FSection :TRTLCriticalSection;
    FPoolNumber :Integer;     //�ش�С
    FPollingInterval :Integer;//��ѯʱ�� �� �� Ϊ��λ
    FADOCon :TADOCon;
    FList :TList;             //������������TADOCobbler
    FTime :TTimer;            //��Ҫ����ѯ
    procedure Enter;
    procedure Leave;
    function SameConfig(const Source:TADOConfig; Target:TADOCon):Boolean;
    function GetConnectionCount: Integer;
  public
    constructor Create(const MaxNumBer:Integer;FreeMinutes :Integer= 60;TimerTime:Integer = 5000);overload;
    destructor Destroy;override;
    //�ӳ���ȡ�����õ����ӡ�
    function GetCon(const tmpConfig :TADOConfig):TADOConnection;
    //����������ӷŻ����ӳء�
    procedure PutCon(const ADOConnection :TADOConnection);
    //�ͷų������δ�õ����ӣ��ɶ�ʱ������ɨ��ִ��
    procedure FreeConnection;
    //��ǰ����������.
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
      raise Exception.Create('���ݿ�����ʧ��');
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
  //False��ʾ���ã�True��ʾ��ʹ�á�
  if not value then
    FConnObj.Tag := 0
  else
    begin
    if FConnObj.Tag = 0 then FConnObj.Tag := 1;  //����Ϊʹ�ñ�ʶ��
    FAStart := now;                              //��������ʱ�� ��
    end;
end;
 
Function TADOCon.GetUseFlag :Boolean;
begin
  Result := (FConnObj.Tag>0);  //Tag=0��ʾ���ã�Tag>0��ʾ��ʹ�á�
end;
 
 
{ TADOPool }
constructor TADOPool.Create(const MaxNumBer:Integer;FreeMinutes :Integer= 60;TimerTime:Integer = 5000);
begin
  InitializeCriticalSection(FSection);
  FPOOLNUMBER := MaxNumBer; //���óش�С
  FPollingInterval := FreeMinutes;// ���ӳ���  FPollingInterval ����û�õ� �Զ��������ӳ�
  FList := TList.Create;
  FTime := TTimer.Create(nil);
  FTime.Enabled := False;
  FTime.Interval := TimerTime;//5����һ��
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
//  mainclass.WriteLog('�������ӳء�������');
  EnterCriticalSection(FSection);
end;
 
procedure TADOPool.Leave;
begin
//  mainclass.WriteLog('�ͷ����ӳء�������');
  LeaveCriticalSection(FSection);
end;
 
//�����ַ������Ӳ��� ȡ����ǰ���ӳؿ����õ�TADOConnection
function TADOPool.GetCon(const tmpConfig :TADOConfig):TADOConnection;
var
  i:Integer;
  IsResult :Boolean; //��ʶ
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
      if not FADOCon.UseFlag then //����
        if SameConfig(tmpConfig,FADOCon) then  //�ҵ�
        begin
          FADOCon.UseFlag := True; //����Ѿ���������
          Result :=  FADOCon.ConnObj;
          IsResult := True;
          Break;//�˳�ѭ��
        end;
    end; // end for
  finally
    Leave;
  end;
  if IsResult then Exit;
  //��δ�� �½�һ��
  Enter;
  mainclass.WriteLog('��ǰ���ӳ�������������'+inttostr(FList.Count));
  try
    if FList.Count < FPOOLNUMBER then //��δ��
    begin
      FADOCon := TADOCon.Create(tmpConfig);
      FADOCon.UseFlag := True;
      Result :=  FADOCon.ConnObj;
      IsResult := True;
      FList.Add(FADOCon);//����������
    end;
  finally
    Leave;
  end;
  if IsResult then Exit;
  //���� �ȴ� �Ⱥ��ͷ�
  while True do
  begin
    Enter;
    try
      for I := 0 to FList.Count - 1 do
      begin
        FADOCon := TADOCon(FList.Items[i]);
        if SameConfig(tmpConfig,FADOCon) then  //�ҵ�
          if not FADOCon.UseFlag then //����
          begin
            FADOCon.UseFlag := True; //����Ѿ���������
            Result :=  FADOCon.ConnObj;
            IsResult := True;
            Break;//�˳�ѭ��
          end;
      end; // end for
      if IsResult then Break; //�ҵ��˳�
    finally
      Leave;
    end;
    //��������������ַ����ĳ��� �� һֱ�ȵ���ʱ
    if CurOutTime >= 5000 * 6 then  //1����
    begin
      raise Exception.Create('���ӳ�ʱ!');
      Break;
    end;
    Sleep(500);//0.5����
    CurOutTime := CurOutTime + 500; //��ʱ���ó�60��
  end;//end while
end;
 
procedure TADOPool.PutCon(const ADOConnection :TADOConnection);
var i :Integer;
begin
  {
  if not Assigned(ADOConnection) then Exit;
  try
    Enter;
    ADOConnection.Tag := 0;  //���Ӧ��Ҳ���� ��δ����...
  finally
    Leave;
  end;
  }
  Enter;  //��������
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
      if MyMinutesBetween(Now,FADOCon.AStart) >= FPollingInterval then //�ͷų�����ò��õ�ADO
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
//���ǵ�֧�ֶ����ݿ����ӣ���Ҫ�����������µ�Ч�����ж�.����ǵ�һ���ݿ⣬�ɺ��Ա����̡�
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
//��ʼ��ʱ��������
{initialization
  //ini�ļ���׺����ΪLXH������Զ�̰�ȫ���ظ���
  ADOConfig := TADOConfig.Create(ExtractFilePath(ParamStr(0))+'control.ini');
  ADOPool := TADOPool.Create(150);
finalization
  if Assigned(ADOPool) then ADOPool.Free;
  if Assigned(ADOConfig) then ADOConfig.Free;  }
 
end.
 