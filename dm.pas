unit dm;

interface

uses
  SysUtils, Classes, DB, ADODB,IniFiles,forms,ComObj;

type
  Tdmform = class(TDataModule)
    adocn: TADOConnection;
    adoinsert: TADOQuery;
    adosp: TADOStoredProc;
    adoqry1: TADOQuery;
    ADOQry: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmform: Tdmform;
  qi_balancedate:string;
  qi_bz:string;

implementation

{$R *.dfm}

procedure Tdmform.DataModuleCreate(Sender: TObject);
var
    tmp_ini:Tinifile;
    dbserverip,UserName,pwd,database:string;
    bkid:string;
begin

    tmp_ini:=TiniFile.Create(ExtractFilePath(ParamStr(0)) + 'control.ini');
    dbserverip:=tmp_ini.ReadString('DB','dbserverip','10.14.0.134');
    database:=tmp_ini.ReadString('DB','database','zgwtfk');
    username:=tmp_ini.ReadString('DB','username','sa');
    pwd:=tmp_ini.ReadString('DB','pwd','thunis');
    bkid:=tmp_ini.ReadString('NodeInformation','bankid','');
    adocn.connected:=false;
    adocn.LoginPrompt :=false;
    adocn.ConnectionString:= 'Provider=SQLOLEDB.1;Password='+pwd+';Persist Security Info=True;User ID='+username
                           +';Initial Catalog='+database+';Data Source='+dbserverip+';Application Name=yh'+bkid ;
   //  adocn.Connected:=true;
   tmp_ini.Free;


end;

end.
