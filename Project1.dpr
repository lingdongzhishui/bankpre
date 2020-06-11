program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ETCBANK_interface in 'ETCBANK_interface.pas',
  Uwork in 'Uwork.pas',
  u_work in 'u_work.pas',
  dm in 'dm.pas' {dmform: TDataModule},
  UnitProcessList in 'UnitProcessList.pas',
  U_OpDB in 'U_OpDB.pas',
  UntJMJ in 'UntJMJ.pas',
  UETCCX in 'UETCCX.pas' {ETCCXFORM},
  CryptUnit in 'CryptUnit.pas',
  SQLADOPoolUnit in 'SQLADOPoolUnit.pas';

{$R *.res}

begin
  Application.Initialize;

   Application.CreateForm(Tdmform, dmform);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
