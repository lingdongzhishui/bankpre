unit UETCCX;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DB, ADODB, Grids, DBGrids, StdCtrls,strutils;

type
  TETCCXFORM = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    DS_ETCLIST: TDataSource;
    ADO_ETCLIST: TADOQuery;
    ADO_ETCLISTListNo: TStringField;
    ADO_ETCLISTYNok: TMemoField;
    ADO_ETCLISTFileName: TStringField;
    ADO_ETCLISTExpInfo: TStringField;
    ADO_ETCLISTSpare1: TIntegerField;
    ADO_ETCLISTspare2: TIntegerField;
    ADO_ETCLISTspare3: TIntegerField;
    ADO_ETCLISTSpare4: TIntegerField;
    ADO_ETCLISTSpare5: TStringField;
    ADO_ETCLISTSpare6: TStringField;
    ADO_ETCLISTCreateTime: TDateTimeField;
    ADO_ETCLISTBalanceDate: TStringField;
    ADO_ETCLISTCustomerID: TStringField;
    ADO_ETCLISTUserType: TIntegerField;
    ADO_ETCLISTUserName: TStringField;
    ADO_ETCLISTBankCardID: TStringField;
    ADO_ETCLISTETCCardID: TStringField;
    ADO_ETCLISTCardID: TStringField;
    ADO_ETCLISTPCardNo: TStringField;
    ADO_ETCLISTTotalToll: TIntegerField;
    ADO_ETCLISToptime: TStringField;
    ADO_ETCLISTbankid: TStringField;
    ETCID: TCheckBox;
    TXT_ETCID: TEdit;
    Btn_etclist: TButton;
    optime: TCheckBox;
    Date_QSRQ: TDateTimePicker;
    Date_ZZRQ: TDateTimePicker;
    Button1: TButton;
    listno: TCheckBox;
    TXT_LISTNO: TEdit;
    bankcardid: TCheckBox;
    TXT_bankcardid: TEdit;
    DBGrid2: TDBGrid;
    Chk_ETCID: TCheckBox;
    Edt_etcid: TEdit;
    CHK_optime: TCheckBox;
    bank_qsrq: TDateTimePicker;
    bank_zzrq: TDateTimePicker;
    chk_listno: TCheckBox;
    edt_listno: TEdit;
    chk_bankcardid: TCheckBox;
    edt_bankcardid: TEdit;
    Button2: TButton;
    ADO_bank: TADOQuery;
    DS_BANK: TDataSource;
    ADO_bankBalanceDate: TIntegerField;
    ADO_bankListNo: TStringField;
    ADO_bankBankID: TIntegerField;
    ADO_bankCustomerID: TStringField;
    ADO_bankUserType: TIntegerField;
    ADO_bankUserName: TStringField;
    ADO_bankPCardNetID: TStringField;
    ADO_bankPCardID: TStringField;
    ADO_bankBankCardID: TStringField;
    ADO_bankAmount: TIntegerField;
    ADO_bankRemarks: TStringField;
    ADO_bankresult: TIntegerField;
    ADO_bankOpTime: TDateTimeField;
    ADO_bankProcRlt: TIntegerField;
    ADO_bankProcOperator: TStringField;
    ADO_bankProcOperatorName: TStringField;
    ADO_bankProcOPTime: TIntegerField;
    ADO_bankProcDesc: TStringField;
    ADO_bankSpare1: TIntegerField;
    ADO_bankSpare2: TStringField;
    TabSheet3: TTabSheet;
    DS_etcblack: TDataSource;
    ADO_etcblack: TADOQuery;
    DBGrid3: TDBGrid;
    ADO_etcblackCustomerID: TStringField;
    ADO_etcblackUserType: TStringField;
    ADO_etcblackUserName: TStringField;
    ADO_etcblackCertificateType: TStringField;
    ADO_etcblackCertificateID: TStringField;
    ADO_etcblackPCardID: TStringField;
    ADO_etcblackBankCardID: TStringField;
    ADO_etcblackTranType: TIntegerField;
    ADO_etcblackBindingCardBlackCause: TIntegerField;
    ADO_etcblackPCardNetID: TStringField;
    ADO_etcblackCREATEDATE: TDateTimeField;
    ADO_etcblackBANKID: TStringField;
    chk_id: TCheckBox;
    edt_id: TEdit;
    chk_edtid: TCheckBox;
    EDT1_etcid: TEdit;
    chk_bankid: TCheckBox;
    edt_bankcardid1: TEdit;
    Button3: TButton;
    TabSheet4: TTabSheet;
    CheckBox2: TCheckBox;
    Edit2: TEdit;
    Button4: TButton;
    DBGrid4: TDBGrid;
    ADO_bankblack: TADOQuery;
    DS_bankblack: TDataSource;
    ADO_bankblackVERNO: TIntegerField;
    ADO_bankblackCARDNO: TStringField;
    ADO_bankblackCARDID: TStringField;
    ADO_bankblackCARDTYPE: TIntegerField;
    ADO_bankblackBLACKTYPE: TIntegerField;
    ADO_bankblackVALIDFLAG: TSmallintField;
    ADO_bankblackSTARTTIME: TDateTimeField;
    ADO_bankblackENDTIME: TDateTimeField;
    ADO_bankblackSTATIONNO: TIntegerField;
    ADO_bankblackREMARK: TStringField;
    ADO_bankblackSPARE1: TIntegerField;
    ADO_bankblackSPARE2: TStringField;
    ADO_bankblackTRANSFERTAG: TIntegerField;
    TabSheet5: TTabSheet;
    DBGrid5: TDBGrid;
    ADO_ectbank: TADOQuery;
    DS_etcbank: TDataSource;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    CheckBox3: TCheckBox;
    Edit3: TEdit;
    Button5: TButton;
    ADO_ectbankwasteNO: TStringField;
    ADO_ectbankProcessDate: TStringField;
    ADO_ectbankProcessTime: TStringField;
    ADO_ectbankNetWorkID: TIntegerField;
    ADO_ectbankTerminalID: TStringField;
    ADO_ectbankBankID: TStringField;
    ADO_ectbankCustomerID: TStringField;
    ADO_ectbankUserType: TIntegerField;
    ADO_ectbankUserName: TStringField;
    ADO_ectbankCertificateType: TIntegerField;
    ADO_ectbankCertificateID: TStringField;
    ADO_ectbankPCardNetID: TStringField;
    ADO_ectbankPCardID: TStringField;
    ADO_ectbankETCCardID: TStringField;
    ADO_ectbankCardType: TIntegerField;
    ADO_ectbankEntrustVerifyCode: TStringField;
    ADO_ectbankVehplate: TStringField;
    ADO_ectbankVehplateColor: TIntegerField;
    ADO_ectbankVehType: TIntegerField;
    ADO_ectbankVehSeatNum: TIntegerField;
    ADO_ectbankWasteSN: TStringField;
    ADO_ectbankOptime: TDateTimeField;
    ADO_ectbankResponseCode: TStringField;
    ADO_ectbankResponseDesc: TStringField;
    ADO_ectbankBankCardType: TIntegerField;
    ADO_ectbankBankCardID: TStringField;
    ADO_ectbankBCertificateType: TIntegerField;
    ADO_ectbankBVCertificateID: TStringField;
    ADO_ectbankBUserName: TStringField;
    ADO_ectbankBindState: TIntegerField;
    ADO_ectbankOperatorNO: TStringField;
    ADO_ectbankOperatorName: TStringField;
    ADO_ectbankActiveDate: TStringField;
    ADO_ectbankBindStartTime: TDateTimeField;
    ADO_ectbankBindEndTime: TDateTimeField;
    ADO_ectbankBindResult: TIntegerField;
    ADO_ectbankSpare1: TIntegerField;
    ADO_ectbankSpare2: TStringField;
    CheckBox4: TCheckBox;
    Edit4: TEdit;
    procedure Btn_etclistClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ETCCXFORM: TETCCXFORM;

implementation

uses dm;

{$R *.dfm}

procedure TETCCXFORM.Btn_etclistClick(Sender: TObject);
var ls_where ,ls_sql: string;
begin
   ls_where:= '';
  if etcid.checked = true then  ls_where := ls_where +' and etccardid = '+ txt_etcid.text;
  if optime.checked = true then ls_where := ls_where + ' and (left(optime,8)>= '''+formatdatetime('yyyymmdd',date_qsrq.date)+''    +
                                                       '  and left(optime,8)<= '''+formatdatetime('yyyymmdd',date_zzrq.date)+'''';
  IF LISTNO.CHECKED = TRUE THEN  ls_where := ls_where +' and LISTNO = '+ txt_LISTNO.text;
  if bankcardid.checked = true then ls_where := ls_where +' and bankcardid = '+ txt_bankcardid.text;
   ls_sql:= ' select * from ETCBoutToBankFile where 1= 1 ';
   with ado_etclist do
   begin
     active:=false;
     sql.text:= ls_sql  + ls_where;
     prepared;
     active:= true;
   end;
end;

procedure TETCCXFORM.Button1Click(Sender: TObject);
begin
 showmessage(formatdatetime('yyyymmdd',now()));
end;

procedure TETCCXFORM.Button2Click(Sender: TObject);
var ls_where ,ls_sql: string;
begin
   ls_where:= '';
  if chk_id.checked = true then  ls_where := ls_where +' and pcardid = '+ edt_id.text;
  if chk_optime.checked = true then ls_where := ls_where + ' and (left(optime,8)>= '''+formatdatetime('yyyymmdd',bank_qsrq.date)+''    +
                                                       '  and left(optime,8)<= '''+formatdatetime('yyyymmdd',bank_zzrq.date)+'''';
  IF chk_LISTNO.CHECKED = TRUE THEN  ls_where := ls_where +' and LISTNO = '+ edt_LISTNO.text;
  if chk_bankcardid.checked = true then ls_where := ls_where +' and bankcardid = '+ edt_bankcardid.text;
   ls_sql:= ' select * from ETCBindCardDeductMoneyList_Bank where 1= 1 ';
   with ado_bank do
   begin
     active:=false;
     sql.text:= ls_sql  + ls_where;
     prepared;
     active:= true;
   end;
end;
procedure TETCCXFORM.Button3Click(Sender: TObject);
var ls_where ,ls_sql: string;
begin
   ls_where:= '';
  if chk_etcid.checked = true then  ls_where := ls_where +' and certificateid = '+ edt_etcid.text;
  IF chk_edtid.CHECKED = TRUE THEN  ls_where := ls_where +' and pcardid = '+ edt1_etcid.text;
  if chk_bankid.checked = true then ls_where := ls_where +' and bankcardid = '+ edt_bankcardid1.text;
   ls_sql:= ' select * from PCardBlackList_bank where 1= 1 ';
   with ado_etcblack do
   begin
     active:=false;
     sql.text:= ls_sql  + ls_where;
     prepared;
     active:= true;
   end;
end;

procedure TETCCXFORM.Button4Click(Sender: TObject);
var ls_where ,ls_sql: string;
begin
   ls_where:= '';
  if checkbox2.checked = true then  ls_where := ls_where +' and cardid = '+ edit2.text;

   ls_sql:= ' select * from PCardBlackList where 1= 1 ';
   with ado_bankblack do
   begin
     active:=false;
     sql.text:= ls_sql  + ls_where;
     prepared;
     active:= true;
   end;
end;

procedure TETCCXFORM.Button5Click(Sender: TObject);
var ls_where ,ls_sql: string;
begin
   ls_where:= '';
  if checkbox1.checked = true then  ls_where := ls_where +' and ETCcardid = '+ edit1.text;
  if checkbox3.checked = true then  ls_where := ls_where +' and BANKCARDID = '+ edit3.text;
  if checkbox4.checked = true then  ls_where := ls_where +' and USENAME = '+ edit4.text;

   ls_sql:= ' select * from ETCBankCardBindTab where 1= 1 ';
   with ado_ECTBANK do
   begin
     active:=false;
     sql.text:= ls_sql  + ls_where;
     prepared;
     active:= true;
   end;
end;

end.
