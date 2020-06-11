unit U_OpDB;

interface

uses
  SysUtils, Classes, DB, ADODB, ActiveX, DBTables, SqlExpr, DBClient, DBXpress, Provider,SQLADOPoolUnit;

const
  dtDB2 = 1;
  dtOracle = 2;
  dtMSSQL = 3;
  dtParadox = 4;
  dtFireBird = 5;

type
  TBaseDB = class
  private
    FErrStr: string;
    FDBIP: string;
    FDBName: string;
    FDBUser: string;
    FDBPassword: string;
    function GetDataSet: TDataSet; virtual;
    procedure SetConnected(Value: Boolean); virtual;
    function GetConnected: Boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function QuerySQL(aSql: string): Boolean; virtual;
    function ExecSQL(aSql: string): Boolean; virtual;
    function BeginTrans: Boolean; virtual;
    function RollBack: Boolean; virtual;
    function Commit: Boolean; virtual;
    function GetPKeys(aTbName: string; var aPKList: TStringList): Boolean; virtual;
  published
    property Query: TDataSet read GetDataSet;
    property DBName: string read FDBName write FDBName;
    property DBIP: string read FDBIP write FDBIP;

    property DBUser: string read FDBUser write FDBUser;
    property DBPassword: string read FDBPassword write FDBPassword;

    property Connected: Boolean read GetConnected write SetConnected;
    property ErrStr: string read FErrStr write FErrStr;
  end;

  TOleDB = class(TBaseDB)
  private
    FConn: TAdoConnection;
    FQuery: TAdoQuery;
    FExec: TAdoQuery;
    FDBType: Integer;
    function GetDataSet: TDataSet; override;
    procedure SetConnected(Value: Boolean); override;
    function GetConnected: Boolean; override;
  public
    constructor Create;
    destructor Destroy; override;
    function QuerySQL(aSql: string): Boolean; override;
    function ExecSQL(aSql: string): Boolean; override;
    function BeginTrans: Boolean; override;
    function RollBack: Boolean; override;
    function Commit: Boolean; override;
    function GetPKeys(aTbName: string; var aPKList: TStringList): Boolean; override;
  published
    property DBType: Integer read FDBType write FDBType;
  end;

  TBdeDB = class(TBaseDB)
  private
    FConn: TDataBase;
    FQuery: TQuery;
    FExec: TQuery;
    FDBPath: string;
    function GetDataSet: TDataSet; override;
    procedure SetConnected(Value: Boolean); override;
    function GetConnected: Boolean; override;
    procedure Buildbdeconn;
  public
    constructor Create;
    destructor Destroy; override;
    function QuerySQL(aSql: string): Boolean; override;
    function ExecSQL(aSql: string): Boolean; override;
    function BeginTrans: Boolean; override;
    function RollBack: Boolean; override;
    function Commit: Boolean; override;
    function GetPKeys(aTbName: string; var aPKList: TStringList): Boolean; override;
  published
    property DBPath: string  read FDBPath write FDBPath;
  end;

  TExprDB = class(TBaseDB)
  private
    FTD: TTransactionDesc;
    FConn: TSQLConnection;
    FClientQuery: TClientDataSet;
    FQuery: TSQLQuery;
    FProvider: TDataSetProvider;
    FExec: TSQLDataSet;
    function GetDataSet: TDataSet; override;
    procedure SetConnected(Value: Boolean); override;
    function GetConnected: Boolean; override;
  public
    constructor Create;
    destructor Destroy; override;
    function QuerySQL(aSql: string): Boolean; override;
    function ExecSQL(aSql: string): Boolean; override;
    function BeginTrans: Boolean; override;
    function RollBack: Boolean; override;
    function Commit: Boolean; override;
    function GetPKeys(aTbName: string; var aPKList: TStringList): Boolean; override;
  published
  end;

type
  TOpDB = class
  private
    FDBObj: TBaseDB;
    FDBType: Integer;
    FDBPath: string;

    function GetConnected: Boolean;
    procedure SetConnected(Value: Boolean);
    function GetQueryObj: TDataSet;
    function GetErrStr: string;
    procedure SetDBName(Value: string);
    procedure SetDBIp(Value: string);

    procedure SetDBUser(Value: string);
    procedure SetDBPassword(Value: string);
    
  public
    FSQLError:String;
    constructor Create(aDBType: Integer);
    destructor Destroy; override;
    function QuerySQL(aSql: string): Boolean;
    function ExecSQL(aSql: string): Boolean;
    function BeginTrans: Boolean;
    function RollBack: Boolean;
    function Commit: Boolean;
    function GetPKeys(aTbName: string; var aPKList: TStringList): Boolean;
  published
    property Query: TDataSet read GetQueryObj;
    property Connected: Boolean read GetConnected write SetConnected;
    property ErrStr: string read GetErrStr;
    property DBName: string write SetDBName;
    property DBIP: string write SetDBIP;

    property DBUser: string write SetDBUser;
    property DBPassword: string write SetDBPassword;

    property DBPath: string  read FDBPath write FDBPath;
  end;

implementation

{ TOpDB }

function TOpDB.BeginTrans: Boolean;
begin
  Result := FDBObj.BeginTrans;
end;

function TOpDB.Commit: Boolean;
begin
  Result := FDBObj.Commit;
end;

constructor TOpDB.Create(aDBType: Integer);      
begin
  CoInitialize(nil);
  FDBType := aDBType;
  case aDBType of
    dtDB2,dtOracle,dtMSSQL:
      FDBObj := TOleDB.Create;
    dtParadox:
      FDBObj := TBDEDB.Create;
    dtFireBird:
      FDBObj := TExprDB.Create;
  else
    FDBObj := nil;
  end;
end;

destructor TOpDB.Destroy;
begin
  if Assigned(FDBObj) then
    FDBObj.Free;
  CoUnInitialize;
  inherited;
end;

function TOpDB.ExecSQL(aSql: string): Boolean;
var
  s:String;
begin
  Result := False;
  if not Assigned(FDBObj) then
    Exit;

  if not FDBObj.Connected then
    FDBobj.Connected := True;

  if not FDBObj.Connected then
    Exit;

 {
  try
    FDBObj.ExecSQL(aSql);
    Result := True;
  except
    on E: Exception do
    begin
     FDBObj.FErrStr:=E.Message;
     FDBobj.Connected := False;
     Result := False;
    end;
  end;
  }
 if FDBObj.ExecSQL(aSql) then
  begin
     Result := True;
   end else
   begin
     FSQLError:=FDBObj.FErrStr ;
     FDBobj.Connected := False;
     Result := False;
   end;
end;

function TOpDB.GetConnected: Boolean;
begin
  Result := FDBObj.Connected;
end;

function TOpDB.GetErrStr: string;
begin
  if not Assigned(FDBObj) then
    Result := '数据库设置错误!'
  else
    Result := FDBObj.ErrStr;
end;

function TOpDB.GetPKeys(aTbName: string;
  var aPKList: TStringList): Boolean;
begin
  Result := FDBObj.GetPKeys(aTbName, aPKList);
end;

function TOpDB.GetQueryObj: TDataSet;
begin
  Result := nil;
  if not Assigned(FDBObj) then
    Exit;
  Result := FDBObj.GetDataSet;
end;

function TOpDB.QuerySQL(aSql: string): Boolean;
begin
  Result := False;
  if not Assigned(FDBObj) then
    Exit;

  if not FDBObj.Connected then
    FDBobj.Connected := True;
  if not FDBObj.Connected then
    Exit;

  if FDBObj.QuerySQL(aSql) then
  begin
    Result := True;
  end else
  begin
    Result := False;
    FDBobj.Connected := False;
  end;
end;

function TOpDB.RollBack: Boolean;
begin
  Result := False;
  if not Assigned(FDBObj) then
    Exit;
  Result := FDBObj.RollBack;
end;

procedure TOpDB.SetConnected(Value: Boolean);
begin
  if not Assigned(FDBObj) then
    Exit;
  case FDBType of
    dtDB2,dtOracle,dtMSSql:
      TOleDB(FDBObj).DBType := FDBType;
    dtParadox:
      TBDEDB(FDBObj).DBPath := FDBPath;
  else
  end;
  
  FDBObj.Connected := Value;
end;

procedure TOpDB.SetDBIp(Value: string);
begin
  if not Assigned(FDBObj) then
    Exit;
  FDBObj.DBIP := Value;
end;

procedure TOpDB.SetDBName(Value: string);
begin
  if not Assigned(FDBObj) then
    Exit;
  FDBObj.DBName := Value;
end;


procedure TOpDB.SetDBUser(Value: string);
begin
  if not Assigned(FDBObj) then
    Exit;
  FDBObj.DBUser := Value;
end;


procedure TOpDB.SetDBPassword(Value: string);
begin
  if not Assigned(FDBObj) then
    Exit;
  FDBObj.DBPassword := Value;
end;


{ TBaseDB }

function TBaseDB.BeginTrans: Boolean;
begin
  Result := True;
end;

function TBaseDB.Commit: Boolean;
begin
  Result := True;

end;

constructor TBaseDB.Create;
begin

end;

destructor TBaseDB.Destroy;
begin
end;

function TBaseDB.ExecSQL(aSql: string): Boolean;
begin
  Result := True;

end;

function TBaseDB.GetConnected: Boolean;
begin
  Result := True;

end;

function TBaseDB.GetDataSet: TDataSet;
begin
    Result := Nil;
end;

function TBaseDB.GetPKeys(aTbName: string;
  var aPKList: TStringList): Boolean;
begin
  Result := True;
end;

function TBaseDB.QuerySQL(aSql: string): Boolean;
begin
  Result := True;
end;

function TBaseDB.RollBack: Boolean;
begin
  Result := True;
end;

procedure TBaseDB.SetConnected(Value: Boolean);
begin

end;

{ TOleDB }

function TOleDB.BeginTrans: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.BeginTrans
  else
    Result := False;
end;

function TOleDB.Commit: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.CommitTrans
  else
    Result := False;
end;

constructor TOleDB.Create;
begin
  CoInitialize(nil);
  FConn := TAdoConnection.Create(nil);
  FConn.LoginPrompt := False;
  //服务端
{  try
    FConn:= ADOPool.GetCon(ADOConfig);
    FConn.Open;
  finally
    ADOPool.PutCon(FConn);
  end;}

  FQuery := TAdoQuery.Create(nil);
  FQuery.CommandTimeout:=60;
  FQuery.Connection := FConn;
  FExec := TAdoQuery.Create(nil);
  FExec.Connection := FConn;
end;

destructor TOleDB.Destroy;
begin
  FQuery.Active := False;
  FExec.Active := False;
  SetConnected(False) ;
  FQuery.Free;
  FExec.Free;
  FConn.Free;
  CoUnInitialize;
end;

function TOleDB.ExecSQL(aSql: string): Boolean;
begin
  FErrStr := '';
  Result := False;
  if not GetConnected then
    SetConnected(True);
  if not GetConnected then
    Exit;
  FExec.Active := False;
  FExec.Sql.Clear;
  FExec.Sql.Add(aSql);
  try
    FExec.ExecSQL;
    Result := True;
  except
    on E: Exception do
      ErrStr := E.Message;
  end;
end;

function TOleDB.GetConnected: Boolean;
begin
  Result := FConn.Connected;
end;

function TOleDB.GetDataSet: TDataSet;
begin
  Result := FQuery;
end;

function TOleDB.GetPKeys(aTbName: string;
  var aPKList: TStringList): Boolean;
var
  s: string;
begin
  Result := False;
  aPKList.Clear;
  case FDBType of
    dtDB2 : begin
      s := 'select COLNAME as COLUMN_NAME from syscat.keycoluse where tabschema=''JUSTDOIT'' and tabname=''%s''';
      s := Format(s, [aTBName]);
    end;
    dtOracle : begin
      s := 'select distinct a.r_constraint_name,b.table_name,b.column_name as COLUMN_NAME from user_constraints a, user_cons_columns b'
          +' WHERE a.constraint_type=''R'' and a.r_constraint_name=b.constraint_name and b.table_name=''%s''';
      s := Format(s, [aTBName]);
    end;
    dtMSSQL : begin
      s := 'sp_pkeys %s';
      s := Format(s, [aTBName]);
    end;
  else
    exit;
  end;

  if QuerySQL(s) then
  begin
    while not FQuery.Eof do
    begin
      aPKList.Add(Trim(FQuery.FieldByName('COLUMN_NAME').AsString));
      FQuery.Next;
    end;
  end else
    Exit;
  Result := True;
end;

function TOleDB.QuerySQL(aSql: string): Boolean;
begin
  FErrStr := '';
  Result := False;
  if not GetConnected then
    SetConnected(True);
  if not GetConnected then
    Exit;
  FQuery.Active := False;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(aSql);
  try
    FQuery.Active := true;
    Result := True;
  except
    on E: Exception do
      ErrStr := E.Message;
  end;
end;

function TOleDB.RollBack: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.CommitTrans
  else
    Result := False;
end;

procedure TOleDB.SetConnected(Value: Boolean);
var
  s: string;
begin
  FErrStr := '';
  if Value then
  begin
    FConn.Connected := False;
    case FDBType of
      dtDB2 :
      begin
        s := 'Provider=SQLOLEDB.1;Password=iloveyou;Persist Security Info=True;User ID=justdoit;Initial Catalog=%s;Data Source=%s';
        s := Format(s, [DBName, DBIP]);
      end;
      dtOracle :
      begin
        {根据配置文件生成连接字符串}
        s := 'Provider=MSDAORA.1;Password='+DBPassword+';Persist Security Info=True;User ID='
          + DBUser+';Data Source='+ DBName;
      end;
      dtMSSQL :
      begin
        s := 'Provider=SQLOLEDB.1;Password='+DBPassword+';Persist Security Info=True;User ID='+ DBUser+';Initial Catalog=%s;Data Source=%s'+';Application Name=GGG';
        s := Format(s, [DBName, DBIP]);
      end;
    else
    end;
    FConn.ConnectionString := s;
    try
      FConn.Connected := True;
    except
      on e: Exception do
        FErrStr := e.Message;
    end;
  end else
  begin
    FConn.Connected := False;
  end;
end;

{ TBdeDB }

function TBdeDB.BeginTrans: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.StartTransaction
  else
    Result := False;
end;

procedure TBdeDB.Buildbdeconn;
var
   ap:TStringList;   {数据库别名列表}
   Session: TSession;
begin
  Session := TSession.Create(nil);
  ap:=TStringlist.Create;
  try
    Session.GetAliasNames(ap);    
    if (ap.IndexOf('Paramg')=-1) then    
    begin
      Session.AddStandardAlias (FDBName,FDBPath,'Paradox');
      Session.SaveConfigFile ;     
    end else
    begin
      ap.Clear;
      ap.Add('PATH=' +FDBPath);
      Session.ModifyAlias(DBName,ap);
      Session.SaveConfigFile;
    end;
    ap.Clear;
  finally
    ap.free;
    Session.Free;
  end;
end;

function TBdeDB.Commit: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.Commit
  else
    Result := False;
end;

constructor TBdeDB.Create;
begin
  FConn := TDataBase.Create(nil);
  FConn.DatabaseName := 'BDEDB';
  FConn.LoginPrompt := False;
  FQuery := TQuery.Create(nil);
  FQuery.DatabaseName := 'BDEDB';
  FExec := TQuery.Create(nil);
  FExec.DatabaseName := 'BDEDB';
end;

destructor TBdeDB.Destroy;
begin
  FQuery.Active := False;
  FExec.Active := False;
  SetConnected(False) ;
  FQuery.Free;
  FExec.Free;
  FConn.Free;
end;

function TBdeDB.ExecSQL(aSql: string): Boolean;
begin
  ErrStr := '';
  Result := False;
  if not FConn.Connected then
    SetConnected(True);
  if not FConn.Connected then
    Exit;

  FExec.Active := False;
  FExec.SQL.Text := aSql;
  try
    FExec.ExecSQL;
    Result := True;
  except
    on E: Exception do
      ErrStr := E.Message;
  end;
end;

function TBdeDB.GetConnected: Boolean;
begin
  Result := FConn.Connected;
end;

function TBdeDB.GetDataSet: TDataSet;
begin
  Result := FQuery;
end;

function TBdeDB.GetPKeys(aTbName: string;
  var aPKList: TStringList): Boolean;
var
  aTable: TTable;
  s,s1: string;
  i, len: Integer;
begin
  Result := False;
  aPKList.Clear;

  aTable := TTable.Create(nil);
  aTable.DatabaseName := 'BDEDB';
  aTable.TableName := aTbName;
  try
    aTable.Active := True;
  except
    on E: Exception do
    begin
      FErrStr := Trim(E.Message);
      aTable.Free;
      Exit;
    end;
  end;

  if aTable.IndexDefs.Count>0 then
  begin
    s := aTable.IndexDefs.Items[0].Fields;
    s1 := '';
    len := Length(s);
    for i:=1 to len do
    begin
      if s[i] = ';' then
      begin
        aPKList.Add(s1);
        s1 := '';
      end else
        s1 := s1 + s[i];
    end;
  end;
  aTable.Active := False;
  aTable.Free;
  Result := True;
end;

function TBdeDB.QuerySQL(aSql: string): Boolean;
begin
  ErrStr := '';
  Result := False;
  if not FConn.Connected then
    SetConnected(True);
  if not FConn.Connected then
    Exit;

  FQuery.Active := False;
  FQuery.SQL.Text := aSql;
  try
    FQuery.Open;
    Result := True;
  except
    on E: Exception do
      ErrStr := E.Message;
  end;
end;

function TBdeDB.RollBack: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.Rollback
  else
    Result := False;
end;

procedure TBdeDB.SetConnected(Value: Boolean);
begin
  ErrStr := '';
  if Value then
  begin
    Buildbdeconn;
    FConn.Connected := False;
    FConn.AliasName := DBName;
    try
      FConn.Connected := True;
    except
      on e: Exception do
        FErrStr := e.Message;
    end;
  end else
    FConn.Connected := False;
end;

{ TExprDB }

function TExprDB.BeginTrans: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.StartTransaction(FTD)
  else
    Result := False;
end;

function TExprDB.Commit: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.Commit(FTD)
  else
    Result := False;
end;

constructor TExprDB.Create;
begin
  FTD.TransactionID := 1;
  FTD.IsolationLevel := xilREADCOMMITTED;
  FConn := TSQLConnection.Create(nil);
  FConn.LoginPrompt := False;
  FConn.ConnectionName := 'FBConnection';
  FConn.LibraryName := 'dbexpint.dll';
  FConn.VendorLib := 'fbclient.dll';
  FConn.GetDriverFunc := 'getSQLDriverINTERBASE';
  FConn.DriverName := 'FIREBIRD';
  FExec := TSQLDataSet.Create(nil);
  FExec.SQLConnection := FConn;
  FQuery := TSQLQuery.Create(nil);
  FQuery.SQLConnection := FConn;
  FProvider := TDataSetProvider.Create(nil);
  FProvider.Name := 'pd';
  FProvider.DataSet := FQuery;
  FClientQuery := TClientDataSet.Create(nil);
  FClientQuery.ProviderName := FProvider.Name;
end;

destructor TExprDB.Destroy;
begin
  FQuery.Active := False;
  FExec.Active := False;
  FClientQuery.Active := False;
  FConn.Connected := False;
  FClientQuery.Free;
  FProvider.Free;
  FQuery.Free;
  FExec.Free;
  FConn.Free;
  inherited;
end;

function TExprDB.ExecSQL(aSql: string): Boolean;
begin
  Result := False;
  if not FConn.Connected then
    SetConnected(True);
  if FConn.Connected then
  begin
    FExec.CommandText := UpperCase(aSql);
    try
      FExec.ExecSQL();
      Result := True;
    except
      on E: Exception do
        ErrStr := E.Message;
    end;
  end;
end;

function TExprDB.GetConnected: Boolean;
begin
  Result := FConn.Connected;
end;

function TExprDB.GetDataSet: TDataSet;
begin
  Result := FClientQuery;
 
end;

function TExprDB.GetPKeys(aTbName: string;
  var aPKList: TStringList): Boolean;
var
  s: string;
begin
  Result := False;
  aPKList.Clear;
  s := 'select A.RDB$FIELD_NAME AS COLUMN_NAME FROM RDB$INDEX_SEGMENTS A, RDB$RELATION_CONSTRAINTS B'
      +' WHERE B.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'''
      +' AND B.RDB$RELATION_NAME = '''+ UpperCase(aTbName)+''''
      +' AND A.RDB$INDEX_NAME = B.RDB$INDEX_NAME'
      +' ORDER BY A.RDB$FIELD_POSITION';
  if QuerySQL(s) then
  begin
    while not FQuery.Eof do
    begin
      aPKList.Add(Trim(FQuery.FieldByName('COLUMN_NAME').AsString));
      FQuery.Next;
    end;
  end else
    Exit;
  Result := True;
end;

function TExprDB.QuerySQL(aSql: string): Boolean;
begin
  Result := False;
  FQuery.Active := False;
  FClientQuery.Active := False;
  if not FConn.Connected then
    SetConnected(True);
  if FConn.Connected then
  begin
    FQuery.SQL.Text := UpperCase(aSql);
    try
      FQuery.Open;
      FClientQuery.SetProvider(FProvider);
      FClientQuery.Active := True;
      Result := True;
    except
      on E: Exception do
        ErrStr := E.Message;
    end;
  end;
end;

function TExprDB.RollBack: Boolean;
begin
  Result := True;
  if FConn.Connected then
    FConn.Rollback(FTD)
  else
    Result := False;
end;

procedure TExprDB.SetConnected(Value: Boolean);
begin
  inherited;
  ErrStr := '';
  if Value then
  begin
    FConn.Connected := False;
    FConn.Params.Clear;
    FConn.Params.Add('Database='+ DBIP + ':' + DBName);
    FConn.Params.Add('RoleName=RoleName');
    FConn.Params.Add('User_Name=SYSDBA');
    FConn.Params.Add('Password=hyits');
    FConn.Params.Add('ServerCharSet=GB2312');
    FConn.Params.Add('SQLDialect=3');
    FConn.Params.Add('LocaleCode=0000');
    FConn.Params.Add('BlobSize=-1');
    FConn.Params.Add('CommitRetain=false');
    FConn.Params.Add('WaitOnLocks=true');
    FConn.Params.Add('Interbase TransIsolation=ReadCommited');
    FConn.Params.Add('Trim Char=false');
    try
      FConn.Connected := True;
    except
      on e: Exception do
        FErrStr := e.Message;
    end;
  end else
  begin
    FConn.Connected := False;
  end;
end;

end.

