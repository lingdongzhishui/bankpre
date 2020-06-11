unit u_work;

interface
uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,CryptUnit,U_OpDB,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer,StrUtils,ETCBANK_interface,dm,db,adodb,
  activex,UnitProcessList,IdThread,IdTCPClient,inifiles,Untjmj;
  type
       tsendservice=class(TIdThread)
  public
        OpDB   : TOpDb;
       adoqry:TADOQuery;
       qrytmp:TADOQuery;
       adoconn:TADOConnection;
       adosp:TADOStoredProc;
       headbuf:array [0..512] of Byte;
       Amessagetype:integer;
       ppackheadsend:TETCBANKHEAD;
       ppackheadReceiver:TETCBANKHEAD;
       pbankordersend:TBANKORDERSEND;   //用户订单发货请求报文（2043）
       pbankordersendresponse:TBANKORDERSENDRESPONSE;   //用户订单发货应答报文2044
       pbankgetbdkk:TBANKGETBDKK;    //绑定卡扣款文件发送通知报文 (4041)
       pBANKSETBDKK:TBANKSETBDKK;    //绑定卡扣款文件接收应答报文（4042）
       pbankgetDZKKFSTZ:TBANKGETDZXFTZBW;    //打折消费明细文件发送通知报文 (4043)
       pbanksetDZKKFSTZ:TBANKGETDZXFYDBW;    //打折消费明细文件接收应答报文（4044）
       pBANKGETONERELEASEKEY:TBANKGETYCFXMYTZBW; //一次发行密钥文件发送通知报文 5003
       pBANKSETONERELEASERESULT:TBANKSETYCFXMYYDBW; //一次发行密钥文件接收应答报文 5004
       pBANKGETSECONDRELEASEERRORKEY:TBANKGETECFXYCTZBW; //二次发行异常结果文件发送通知报文 5009
       pBANKSETSECONDRELEASEERRORRESULT:TBANKSETECFXYCYDBW; //二次发行异常结果文件接收应答报文 5010
       pBANKGETBDJZF:TBANKGETJZFKK;
       pBANKSETBDJZF:TBANKSETJZFKK;
       pbankgetbdcardkh:TBANKGETBDCARDKH;  //绑定卡开户请求报文
       pbanksetbdcardkh:TBANKSETBDCARDKH;  // 绑定卡开户应答报文
       pbankgetbdcardxh:TBANKGETBDCARDxH;  //绑定卡销户请求报文 4011
       pbanksetbdcardxh:TBANKSETBDCARDXH; //绑定卡销户应答报文 4012
        buf:array [0..512] of Byte;
        bufhead:array [0..512] of Byte;
        bufsize,btsize,btsendsize:integer;
        tmpbuf:array [0..512] of Byte;
        Key1:array[0..15] of Byte;
        indata,outdata:array of byte;
        IdTCPClient1:Tidtcpclient;
//        idcbank:TIdTCPClient;
        terminalok:Byte ;
        termianlpasskeyok:byte;
        Keybank:array[0..15] of Byte;
        networkid:string;
        TerminalID:string;
        strtmp:string;
        ResponseCode:string;
    constructor Create(ACreateSuspended: Boolean); override;
    destructor Destroy; override;
    procedure execute; override;
    function sendbody(abyte:array of byte;strmsglx:string;isize:integer;bankid:string):boolean;
    function packset(invarray:array of byte;strmsglx:string;readbuf:boolean;isize:integer):Boolean;
    procedure headset(var ppackhead:TETCBANKHEAD;bsize:integer;strmsg:string;strmd5code:string);
    procedure readbuf();
    procedure readbufbank();
    procedure readbufbody;
    function upfile(bankid,filetype,workdate,tabname:string;var filename,sPath:string):boolean;
    function sendbodybank(abyte: array of byte;strmsglx: string; isize: integer): boolean;
    procedure proc1001(bankid:string);
    procedure proc1003(bankid:string);
    procedure proc4041(bankid,balancedate,filename,Recordnumber,tollcount,tollamount,tabname,sPath:string);
    procedure proc4045(bankid,balancedate,filename,tollcount,tollamount,tabname,sPath:string);
    procedure proc2043(CustomerID,Vehplate,VehplateColor,OrderID,EtccardID,obuno,expressid:string);
    procedure proc4043(bankid,balancedate,Recordnumber,tabname:string);
    procedure proc5009(bankid,balancedate,Recordnumber,tabname: string);
    procedure proc5003(tabname:string;bankid:string;ProcessDate:string;Recordnumber:string;cardnobegin,cardnoend:string);
    procedure proc5041(bankid,balancedate,Recordnumber,tollcount,tollamount,tabname:string);
    procedure proc4001(pcardid:string);  //绑定卡开户请求报文
    procedure proc4011(pcardid,bankid:string);  //绑定卡销户请求报文
 //   function  getDecryptdata (str:string ):string;
 //   procedure proc_autostopetccardbd();

  end;

  type

 TETCPeerThread = class(TIdPeerThread)

  public
    terminalok:Byte ;
    termianlpasskeyok:byte;
    ResponseCode:string;
    AMessageType:integer;
    networkid:string;
    ppackheadReceiver:TETCBANKHEAD;
    ppackheadsend:TETCBANKHEAD;
    pbankgetkey:TGETPASSWORDKEY;
    pbanksetkey:TSETPASSWORDKEY;
    pbankgetqd:TBANKGETQD;
    pbanksetqd:TBANKSETQD;
    phandgetVehimage:THANDSETUPIMAGEBW;
    phandsetVehimageYD:THANDSETUPIMAGEYDBW;
    poperatorlogin:TOPERATORLOGINBW;
    poperatorloginYD:TOPERATORLOGINYDBW;
    pbankgetdevicejy:TBANKGETDEVICEJY;
    pbanksetdevicejy:TBANKSETDEVICEJY;

    pbankCZquery:TBANKGETCZQUERY;
    pbankCZQQ:TBANKGETCZQQ;
    pbankgetczquery:TBANKGETCZQUERY;
    pbanksetczquery:TBANKSETCZQUERY;
    pbankgetzhczquery:TBANKGETzhCZQUERY;
    pbanksetzhczquery:TBANKSETzhCZQUERY;
    pbankgetczqQ:TBANKGETCZQQ;
    pbanksetczQQ:TBANKSETCZQQ;
    pcustomerinfoRequest:TCUSTOMERREQUEST;//2021 客户信息入库
    pcustomerinfoResponse:TCUSTOMERRESPONSE; //2022客户信息应答
    pvehicleRequest:TVEHICLEREQUEST;//2023 车辆信息入库
    pvehicleResponse:TVEHICLERESPONSE; //2024车辆信息应答
    pobuRequest:TOBUREQUEST;  //2025 OBU信息入库
    pobuResponse:TOBURESPONSE;  //2026 OBU信息应答
    pprecardRequest:TPRECARDREQUEST;   //2027储值卡信息入库
    pprecardResponse:TPRECARDRESPONSE;  //2028储值卡信息应答
    pchargecardRequest:TCHARGECARDREQUEST;   //2029储值卡信息入库
    pchargecardResponse:TCHARGECARDRESPONSE;  //2030储值卡信息应答
    porderRequest:TORDERREQUEST;   //2041储值卡信息入库
    porderResponse:TORDERRESPONSE;  //2042储值卡信息应答
    pbankgetzhcz:TBANKGETZHCZ; //2031
    pbanksetzhcz:TBANKSETZHCZ; //2032
    pbankgetzhczcz:TBANKGETZHCZCZ; //2033
    pbanksetzhczcz:TBANKSETZHCZCZ; //2034
    pBankZHFPQQ: TBANKZHFPQQ;//2035
    pBankZHFPYD: TBANKZHFPYD; //2036
    pbankgetphone: TBANKGETPHONE;    //农信社修改电话请求报文
    pbanksetphone: TBANKSETPHONE;    //农信社修改电话应答报文
    pbankgetbdcardkh:TBANKGETBDCARDKH;  //绑定卡开户请求报文  4001
    pbanksetbdcardkh:TBANKSETBDCARDKH;  // 绑定卡开户应答报文

    pbankgetCBcardkh:TBANKGETCBCARDKH;  //绑定卡重绑开户请求报文
    pbanksetCBcardkh:TBANKSETCBCARDKH;  // 绑定卡重绑开户应答报文
    pbankgetbdcardxh:TBANKGETBDCARDXH; //绑定卡销户请求报文 4011
    pbanksetbdcardxh:TBANKSETBDCARDXH; //绑定卡销户应答报文 4012

    pbankgetblackcard:TBANKGETBLACKCARD ; //黑名单通知报文  4021
    pbanksetblackcard:TBANKSETBLACKCARD ; //黑名单应答报文  4021
    pbankgetblackfile:TBANKGETBLACKFILE;//黑名单文件发送通知报文 4031
    pbanksetblackfile:TBANKSETBLACKFILE ;//黑名单文件接收应答报文（4032）
    pbankgetOneReleasefile:TBANKGETYCFXTZBW;//一次发行文件发送通知报文 5001
    pbanksetOneReleasefile:TBANKSETYCFXTZBW;//一次发行文件接收应答报文 5002
    pbankgetSecondReleasefile:TBANKGETECFXJGWJFSTZBW;//二次发行结果文件发送通知报文 5005
    pbanksetSecondReleaseResultfile:TBANKGETECFXJGWJJSYDBW;//二次发行结果文件发送接收应答报文 5006
    pbankgetVehinfoQuery:TBANKGETCLXXCXBW; //车辆信息查询报文 5007
    pbanksetVehinfoQuery:TBANKGETCLXXCXYDBW;  //车辆信息查询应答报文  5008
    PBANKGETCZDZ:TBANKGETCZDZ;    //充值对账请求
    PBANKSETCZDZ:TBANKSETCZDZ;    //充值对账应答
    pBANKGETBDKKRESULT:TBANKGETBDKKresult;//4051绑定卡扣款结果文件发送通知报文
    pBANKSETBDKKRESULT:TBANKSETBDKKresult;//4052绑定卡扣款结果文件应答通知报文
    pBANKGETDZJGMXFSTZBW:TBANKGETDZJGMXFSTZBW;  //打折结果明细文件发送通知报文 (4053)
    pBANKSETDZJGMXFSTZBW:TBANKSETDZJGMXJSYDBW; // 打折结果明细文件接收应答报文 (4054)
    pBANKGETBDJZFRESULT:TBANKGETBDKKresult;//5051JZF扣款结果文件发送通知报文
    pBANKSETBDJZFRESULT:TBANKSETBDKKresult;//5052JZF扣款结果文件应答通知报文
    pBANKGETBDKBDRESULT:TBANKGETBDKBDresult;//4071绑定卡绑定结果文件发送通知报文
    pBANKSETBDKBDRESULT:TBANKSETBDKBDresult;//4072绑定卡绑定结果文件应答通知报文
    pBANKSETBDKK:TBANKSETBDKK;


    PBANKGETBDPJDY:TBANKGETBDPJDY;
    PBANKSETBDPJDY:TBANKSETBDPJDY;
    PCKFILEGETCZ:TCKFILEGETCZ;
    PCKFILESETCZ:TCKFILESETCZ;
    pbankgetcz:TBANKGETCZ;

    pbankgetxf:TBANKGETXF;
    pbanksetxf:TBANKsETXF;
    pbanksetcz:TBANKSETCZ;
    pbankxfqr:TBANKXFQR;
    pbankgetczcg:TBANKGETCZCG;
    pbanksetczcg:TBANKsETCZCG;
    pbankgetczhengQQ:TBANKGETCZHENGQQ;
    pbanksetczhengQQ:TBANKsETCZHENGQQ;
    pbankgetczhengcg:TBANKGETCZHENGCG;
    pbanksetczhengcg:TBANKsETCZHENGCG;
    pbankgetczpjcd:TBANKGETCZPJCD;
    pbankSetczpjcd:TBANKsETCZPJDY;
    pbankgetusermodypassword:TBANKGETusermodypassword;
    pbanksetusermodypassword:TBANKsETusermodypassword;
//    pCardLoadPara_mac:TCardLoadPara_mac;
    pCardLoadPara:TCardLoadPara;
    pCardLoadPara11:TCardLoadPara11;
    pbankgetczpjdy:TBANKGETCZPJDY;
    pbanksetczpjdy:TBANKsETCZPJDY;
    pbankgetbdkk:TBANKGETBDKK;

    pbankgetDZKKFSTZ:TBANKGETDZXFTZBW;
    OBUFX:TOBUFX2;
    pbanksetmac:tbanksetmac;
//    pbankSetbdkk:TBANKSETBDKK;
//    pbankgetczhengqq:TBANKGETCZhengQQ;
    buf:array [0..512] of Byte;
    bufhead:array [0..512] of Byte;
    bufsize,btsize,btsendsize:integer;
    tmpbuf:array [0..512] of Byte;
    Key1:array[0..15] of Byte;
    indata,outdata:array of byte;
    strtmp:string;
    adoconn:TADOConnection;
    adoqry:TADOQuery;
    adosp:TADOStoredProc;
    errorid:integer;
    errormsg:string;
    recivelength:Integer;
    i_:integer;
     idcbank:TIdTCPClient;
     //*********************************
       Keybank:array[0..15] of Byte;
     //*********************************
   constructor Create(ACreateSuspended: Boolean); override;
   destructor Destroy; override;
    procedure proc1001; //加密因子请求报文
    procedure proc1003;  //终端签到请求报文
    procedure proc1005;  //终端签到请求报文
    procedure proc1007;
    procedure proc1009;  //手持机上传图片
    procedure proc1011;  //手持机用户登录
    procedure proc2001;  //快通卡信息查询请求报文
    procedure proc2035;  //账户充值分配请求报文
    procedure proc2037;  //快通卡信息查询请求报文
    procedure proc2039;  //快通卡信息查询请求报文
    procedure proc2003;  //充值请求报文
    procedure proc2031;  //账户充值请求报文
    procedure proc2033;  //账户充值冲正请求报文
    procedure proc2005;  //充值成功通知报文
    procedure proc2011;  //充值票据打印请求报文
    procedure proc2013;  //充值票据重打请求报文
    procedure proc2015;  //冲正请求报文
    procedure proc2017;  //冲正成功通知报文
    procedure proc2021;  //客户账户请求报文
    procedure proc2023;  //客户车辆信息请求报文
    procedure proc2025;   //OBU信息请求报文
    procedure proc2027;   //储值卡信息请求报文
    procedure proc2029;   //记账卡信息请求报文
    procedure proc2041;   //银行订单信息请求报文
    procedure proc2051; //充值对账文件发送通知报文
    procedure proc3999;   //农信社修改电话
    procedure proc4001;  //绑定卡开户请求报文
    procedure proc4003;
    procedure proc4011;  //绑定卡解邦请求报文
    procedure proc4021;  //黑名单通知报文
    procedure proc4031;  //黑名单文件发送通知报文
    procedure proc5001;  //一次发行文件发送通知报文
    procedure proc5005;  //二次发行结果文件发送通知报文
    procedure proc5007;  //车辆信息查询报文
    procedure proc9001;
    procedure proc9011;
    procedure proc9021;

    procedure proc4051; //绑定卡扣款结果文件发送通知报文
    procedure proc4053; //打折扣款结果文件发送通知报文
    procedure proc5051; //绑定卡扣款结果文件发送通知报文
    procedure proc4061; //绑定卡票据打印请求报文
    procedure proc4071; //绑定卡签约文件发送通知报文
    procedure getmaccz; //绑定卡扣款结果文件发送通知报文
    procedure getmacxf; //绑定卡票据打印请求报文
    procedure getmac;  //终端签到请求报文
    function  dowloadfile(recount:integer;filename:string):Boolean;
    procedure headset(var ppackhead:TETCBANKHEAD;bsize:integer;strmsg:string;strmd5code:string);
    function  sendbody(abyte:array of byte;strmsglx:string;isize:integer):boolean;
    procedure ProcessBuf;
    procedure WritedebugLog(Str: String);
    procedure WriteerrorLog(Str: String);
    procedure WriteLog(Str: String);
    function procbank1001:Boolean;
    function probank1001(bankey:String):Boolean;
    function procbank1003:boolean;
    //校验用户名密码
    function CheckOperNamePass(OperId: integer; OperPass: string;NetWorkNO:string): boolean;
    function sendbodybank(abyte: array of byte;
    strmsglx: string; isize: integer): boolean;
    function sedbodybank(abyte: array of byte;
    strmsglx: string; isize: integer;bankey:string): boolean;
     procedure readbufbank();
     procedure readbufbak(bankey:string);

 end;
implementation
uses
      Uwork,SQLADOPoolUnit;

constructor TETCPeerThread.Create(ACreateSuspended: Boolean);
begin
  inherited
  Create(ACreateSuspended);
  CoInitialize(nil);  // 在线程中创建Ado连接需要初始化Ado的COM接口
  Self.terminalok := 0 ;
  self.termianlpasskeyok:=0;
  try
    adoconn:= ADOPool.GetCon(ADOConfig);
    adoconn.Open;
    ADOPool.PutCon(adoconn);
    except on e:exception do
    begin
      mainclass.WriteerrorLog('连接池异常：'+e.Message);
    end;
//  finally

  end;
//  adoconn:=TADOConnection.Create(nil);
  adoqry:= TADOQuery.Create(nil);
  adoqry.Connection:=adoconn;
  adoqry.CommandTimeout:=60;
  adosp:=TADOStoredProc.Create(nil);
  adosp.Connection:=adoconn;
  adosp.CommandTimeout:=60;
//  adoconn.ConnectionString:=dmform.adocn.ConnectionString;
//  adoconn.LoginPrompt :=false;
  i_:=1;
    {idcbank:=TIdTCPClient.Create(nil);
    idcbank.ReadTimeout:=30000;
    ProcessList1 := TProcessList.Create;
    ProcessList1.DbConnected := True;
    if not ProcessList1.DbConnected then Exit; }
end;

//校验用户名密码
function TETCPeerThread.CheckOperNamePass(OperId: integer; OperPass: string;NetWorkNO:string): boolean;
var
  ADOQ: TADOQuery;
  SqlStr: string;
  orgstr:string;
  OrganNo, OperName,OperatorNo: string;
  DecryptUserPassword: string;
  begin
    Result := false;

    ADOQ := TADOQuery.Create(nil);
    try
      try
        if(LeftStr(NetWorkNO,2)='14')then
          orgstr:= ' LEFT(a.OrganNo,4)+RIGHT(a.OrganNo,3)= '
        else
         orgstr:= ' a.OrganNo= ' ;
        ADOQ.Connection := adoconn;
        SqlStr := 'select a.*,b.RoleNO,b.Password from POperator a with(nolock) ,PoperatorRolePassword b with(nolock) ' +
                  'where a.OrganNo=b.OrganNo and a.OperatorNo=b.OperatorNo and a.Operatorno=' +
                  IntToStr(OperId) + ' and a.Active=1 and '+orgstr+NetWorkNO;
//        mainclass.WriteerrorLog(SqlStr);
        ADOQ.SQL.Add(SqlStr);
        ADOQ.Open;
        if ADOQ.RecordCount > 0 then
        begin
          DecryptStr(ADOQ.FieldByName('Password').AsString, DecryptUserPassword);
//          mainclass.WriteerrorLog('数据库的密码：'+DecryptUserPassword+'接收到的密码：'+OperPass);
          if (DecryptUserPassword = OperPass) or (OperPass=formatdatetime('MMDDYY',now)+'123456') then
          begin
            Result := true;

            //赋值
            OperName := ADOQ.FieldByName('OperatorName').AsString;
            OperatorNo := ADOQ.FieldByName('OperatorNo').AsString;
            OrganNo := ADOQ.FieldByName('OrganNo').AsString;
          end;
        end;
      except
        //on e: Exception do
         //showmessage(ADOQ.Connection.Errors.Item[0].Get_Description);
         //showmessage('errors');
        raise;
      end;
    finally
      ADOQ.Free;
    end;

  end;

procedure TETCPeerThread.ProcessBuf;
var ilength:Integer;
    indata,outdata:array of Byte;
    btsize,btsendsize:integer;
    strmd5code:string;
    li_len,li_len1,li_len2:integer;
begin
     try
        // Finalize(outdata);
        outdata:=nil;
//        btsize:=0;
//        ilength:=0;
         if ppackheadReceiver.MessageType='' then
             AMessageType:=0
         else

         AMessageType := StrToInt(ppackheadReceiver.MessageType) ;

         ilength:=mainclass.inttobigint(ppackheadReceiver.MessageLength);
         WritedebugLog('接收到来1自'+Connection.Socket.Binding.PeerIP+'报文类型:'+inttostr(AMessageType)+'发送包长度为:'+inttostr(ppackheadReceiver.MessageLength)+'转换后为:'+inttostr(ilength));
          try
           Connection.ReadBuffer(buf,ilength-SizeOf(ppackheadReceiver));
           except on e:exception do
               // responsercode:= '09';
                mainclass.WriteerrorLog('TETCPeerThread.ProcessBuf'+e.Message );
            end;
         WritedebugLog('接收到1:'+Connection.Socket.Binding.PeerIP+'报文类型:'+IntToStr(AMessageType)+'接收字节数'+IntToStr(ilength));
      btsize:=ilength-sizeof(ppackheadReceiver);
      if btsize>0 then
         SetLength(indata,btsize);
      CopyMemory(@indata[0],@buf,btsize);

      //**************************************

//******************************************需要解密的报体*********************************
        if AMessageType=1001 then
        begin
           responsecode:='00';
            mainclass.strtobyte(key1,mainclass.defaultkey,1);
        end;

             try

          //   btsendsize:=(btsize div 8+1)*8;
             btsendsize:=btsize;
             SetLength(outdata,btsendsize);
//             WritedebugLog(inttostr(btsendsize)+'解密前码为:'+mainclass.arraytostr(indata));
             mainclass.Decryptbcb(key1,indata,outdata);
             STRTMP:='解密后码为outdata:'+MAINCLASS.arraytostr1(outdata)+'解密因子为:'+MAINCLASS.arraytostr(Key1)+'';

             WritedebugLog(STRTMP);
             li_len:= length(outdata)-outdata[high(outdata)];
             li_len1:=  length(outdata);
             li_len2:=outdata[high(outdata)];
              STRTMP:='解密后码为li_len:'+inttostr(li_len)+'        li_len1:' +inttostr(li_len1)+'        li_len2:'+inttostr(li_len2);

             WritedebugLog(STRTMP);
             setlength(outdata,li_len);
             recivelength:=Length(outdata);
//***********************校验MD5值*****************************************************
             try
                 strmd5code:=mainclass.getmd5(string(outdata));

                 if UpperCase(string(ppackheadReceiver.VerifyCode))<>strmd5code then
                 begin
                   writedebuglog('中心生成md5:  '+strmd5code+'银行对账md5:  '+ppackheadReceiver.VerifyCode);
                   ResponseCode:='46';
                 end;

             except
                     writedebuglog('46');
                     ResponseCode:='46';
             end;
//******************************************************************************************

             mainclass.dbuftobuf(outdata,buf,0);
             except
               writedebuglog('47');
                  ResponseCode:='47';
             end;
             if AMessageType>1003 then
                 if (terminalok<>1)  then
                 begin
                     ResponseCode:='39';
                 end;
             if amessagetype>1001 then
             if (termianlpasskeyok<>1)  then
             begin
                 ResponseCode:='94';
             end;
      writedebuglog('解密完成，进入过程处理'+inttostr(amessagetype));
//*******************************************解密内容***************************************
       case AMessageType of
         1001:
         begin
             self.proc1001;
         end;
         1003:
         begin
             self.proc1003;

         end;
         1005:
         begin
            self.proc1005;
         end;
            1007:
         begin
            self.proc1007;
         end;
         1009:
         begin
            self.proc1009;
         end;
         1011:
         begin
            self.proc1011;
         end;
         2001:
         begin

             self.proc2001;
         end;
         2003:
         begin
             self.proc2003;
         end;
         2005:
         begin
             self.proc2005;
         end;
         2007:
         begin
             self.proc2003;
         end;
         2009:
         begin
             self.proc2005;
         end;
         2011:
         begin
             self.proc2011;
         end;
         2013:
         begin
             self.proc2013;
         end;
         2015,2019:
         begin
             self.proc2015;
         end;
         2017:
         begin
             self.proc2017;
         end;
         2021:
         begin
             self.proc2021;
         end;
         2023:
         begin
             self.proc2023;
         end;
         2025:
         begin
             self.proc2025;
         end;
         2027:
         begin
             self.proc2027;
         end;
         2029:
         begin
             self.proc2029;
         end;
         2041:
         begin
             self.proc2041;
         end;
         2031:
         begin
             self.proc2031;
         end;
         2033:
         begin
             self.proc2033;
         end;
         2035:
         begin
             self.proc2035;
         end;
         2037:
         begin
             self.proc2037;
         end;
         2039:
         begin
             self.proc2039;
         end;
         2051:
         begin
             self.proc2051;
         end;
         3999:
         begin
             self.proc3999;
         end;
         4001:
         begin
             self.proc4001;
         end;
          4003:
         begin
             self.proc4003;
         end;
         4011:
         begin
             self.proc4011;
         end;
         4021:
         begin
             self.proc4021;
         end;
          4031:
         begin
             self.proc4031;
         end;
          5001:
         begin
             self.proc5001;
         end;
          5005:
         begin
             Self.proc5005;
         end;
          5007:
         begin
             Self.proc5007;
         end;
         4051:
         begin
             self.proc4051;
         end;
         4053:
         begin
             self.proc4053;
         end;
         4061:
         begin
             self.proc4061;
         end;
          4071:
         begin
             self.proc4071;
         end;
          5051:
         begin
             self.proc5051;

         end;
         9001:
         begin
             self.proc9001;
         end;
         9011:
         begin
             self.proc9011;
         end;
         9021:
         begin
             self.proc9021;
         end;
         9901,9902,9903,9904:
         begin
             CopyMemory(@OBUFX,@buf,ilength-SizeOf(ppackheadReceiver));
             getmac;
         end;
         9991:
         begin
             getmaccz;
         end;
         9992:
         begin
            getmacxf;
         end;

       end;
     except
         writeerrorlog(Connection.Socket.Binding.PeerIP+'数据发送有误packhead+'+mainclass.arraytostr(bufhead)+'包体为:'+mainclass.arraytostr(buf));
     end;
      
end;

procedure TETCPeerThread.proc1001;
var
    strtmp:string;

begin
         try
            CopyMemory(@pbankgetkey,@buf,SizeOf(pbankgetkey));
            FillChar(pbanksetkey,SizeOf(pbanksetkey),0);
            if ResponseCode='00' then
            begin
                strtmp:=FormatDateTime('yyyymmdd',now);
                CopyMemory(@pbanksetkey.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pbanksetkey.ProcessDate),'0')),SizeOf(pbanksetkey.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                CopyMemory(@pbanksetkey.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pbanksetkey.Processtime),'0')),SizeOf(pbanksetkey.Processtime));
                STRTMP:=mainclass.randstr(8);
                mainclass.strtobyte(pbanksetkey.KEY1,STRTMP,1);    // 得到KEY1
                STRTMP:=mainclass.randstr(8);
                mainclass.strtobyte(pbanksetkey.KEY2,STRTMP,1);    // 得到KEY1
                bufsize:=SizeOf(ppackheadReceiver)+SizeOf(pbanksetkey);
                fillchar(buf,sizeof(buf),0);
            end;
         except
             ResponseCode:='30'
         end;
//***********************************************************************************************
            copymemory(@pbanksetkey.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetkey.ResponseCode));
//            Move(ppackhead,buf,SizeOf(ppackhead));
//            Move(pbanksetkey,buf[SizeOf(ppackhead)],SizeOf(pbanksetkey));
           FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetkey,SizeOf(pbanksetkey));
    
           self.sendbody(tmpbuf,'1002',SizeOf(pbanksetkey));


            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'请求加密因子发送成功'+mainclass.bytetostr(pbanksetkey.KEY1)+'|'+mainclass.bytetostr(pbanksetkey.KEY2));
                  if ResponseCode='00' then
                  begin
                          CopyMemory(@key1,@pbanksetkey.key1,8);
                          CopyMemory(@key1[8],@pbanksetkey.key2,8);
                          termianlpasskeyok:=1;
                  end;
//                  Connection.FlushWriteBuffer(bufsize);
              except
                  WriteerrorLog('发送加密因子失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.WritedebugLog(Str: String);
var
  tmpStr,
  tmpName: String;
  SystemTime: TSystemTime;
  fsm       : TextFile;
begin
    if not mainclass.bflagdebuglog then exit;
  if Str='' then Exit;
  tmpName := ExtractFilePath(ParamStr(0))+'debuglog\';



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
end;


procedure TETCPeerThread.WriteerrorLog(Str: String);
begin
    mainclass.WriteerrorLog(str);
end;

procedure TETCPeerThread.proc1003;
var
    strtmp:string;
    i:integer;
begin
//*****************************赋值报体内容**************************************************

      try
            CopyMemory(@pbankgetqd,@buf,SizeOf(pbankgetqd));
            FillChar(pbanksetqd,SizeOf(pbanksetqd),0);

           if mainclass.bankid='9000000' then
           begin
               adoqry.Active :=false;
              adoqry.SQL.text:='select 1 from dbo.ETCHandClientRecord a  with (nolock) where networkid='''+string(pbankgetqd.networkID)+''''
              +' and terminalID='''+mainclass.bankid+''' ';
  //            adoqry.Active :=true;
                adoqry.Open;           //断网后自动重连
              if adoqry.RecordCount>0 then
               begin
                 responsecode:='37';
                 mainclass.writeerrorlog('终端校验失败：'+adoqry.SQL.text);
               end;
            end;
        if ResponseCode='00' then
        begin
            copymemory(@pbanksetqd.networkID,@pbankgetqd.networkID,SizeOf(pbankgetqd.networkID));
            copymemory(@pbanksetqd.TerminalID,@pbankgetqd.TerminalID,SizeOf(pbankgetqd.TerminalID));
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetqd.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pbanksetqd.ProcessDate),'0')),SizeOf(pbanksetqd.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetqd.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pbanksetqd.Processtime),'0')),SizeOf(pbanksetqd.Processtime));
        end;
     except
         responsecode:='90'; //签到失败!!!
     end;

   copymemory(@pbanksetqd.ResponseCode,PChar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetqd,SizeOf(pbanksetqd));
    self.sendbody(tmpbuf,'1004',SizeOf(pbanksetqd));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'请求签到发送成功'+pbanksetqd.ResponseCode);
          if ResponseCode='00' then
              terminalok:=1;

      except
          WriteerrorLog('发送签到应答失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.proc1011;
var
    strtmp:string;
    OperPass: string;
    OperId: integer;
    NetWorkNO:string;
begin
//*****************************赋值报体内容**************************************************

      try
          CopyMemory(@poperatorlogin,@buf,SizeOf(poperatorlogin));
          OperId := StrToInt(Trim(string(poperatorlogin.OperatorNo)));
          OperPass := Trim(string(poperatorlogin.OperatorPassword));
          NetWorkNO:=Trim(string(poperatorlogin.networkID));
         if not CheckOperNamePass(OperId, OperPass,NetWorkNO) then
           ResponseCode:='02';
          FillChar(poperatorloginYD,SizeOf(poperatorloginYD),0);
          copymemory(@poperatorloginYD.OperatorNo,@poperatorlogin.OperatorNo,SizeOf(poperatorlogin.OperatorNo));
          strtmp:=FormatDateTime('yyyymmdd',now);
          copymemory(@poperatorloginYD.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(poperatorloginYD.ProcessDate),'0')),SizeOf(poperatorloginYD.ProcessDate));
          strtmp:=FormatDateTime('hhmmss',now);
          copymemory(@poperatorloginYD.Processtime,PChar(mainclass.padl(strtmp,SizeOf(poperatorloginYD.Processtime),'0')),SizeOf(poperatorloginYD.Processtime));

     except
         responsecode:='90'; //签到失败!!!
     end;

   copymemory(@poperatorloginYD.ResponseCode,PChar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@poperatorloginYD,SizeOf(poperatorloginYD));
    self.sendbody(tmpbuf,'1012',SizeOf(poperatorloginYD));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'用户登录请求发送成功'+poperatorloginYD.ResponseCode);
          if ResponseCode='00' then
              terminalok:=1;

      except
          WriteerrorLog('发送用户登录请求应答失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.proc1009;
var
    strtmp:string;
    ls_sql:string;

begin
  CopyMemory(@phandgetVehimage,@buf,SizeOf(phandgetVehimage));
   { try
      ProcessList1 := TProcessList.Create;
    except on e:exception do
      begin
        responsecode:= '09';
        WriteerrorLog('TProcessList.Create 创建错误'+e.Message  );
      end;
    end;
    ProcessList1.DbConnected := True;
    if not ProcessList1.DbConnected then Exit;
//    1.获取配置文件参数
    ProcessList1.LoadParam;
//    创建上传、下载、日志文件夹
    ProcessList1.CreateYearFolder; }


       begin

          {将文件插入数据库中}
               try
                  ls_sql:=' INSERT INTO dbo.HandUpImage( '+
                                                    'ProcessDate,'+
                                                    'ProcessTime,'+
                                                    'networkID,'+
                                                    'TerminalID,'+
                                                    'VehPlate,'+
                                                    'Vehtype,'+
                                                    'ImageName,'+
                                                    'OperatorNo'+
                                                    ' 	)                     '+
                                                    '  VALUES                 '+
                                                      ' ( '''+phandgetVehimage.ProcessDate +
                                                    ''','''+phandgetVehimage.ProcessTime +
                                                    ''','''+phandgetVehimage.networkID +
                                                    ''','''+phandgetVehimage.TerminalID +
                                                    ''','''+phandgetVehimage.VehPlate +
                                                    ''','''+phandgetVehimage.Vehtype +
                                                    ''','''+phandgetVehimage.ImageName +
                                                    ''','''+phandgetVehimage.OperatorNo +''')';


                   with  adoqry do
                   begin
                     adoqry.Active :=false;
                     sql.text:= ls_sql;
                     prepared;
                     ExecSQL ;
                   end;

               except on e:exception do
                 begin
                    responsecode:= '01';
                    writedebuglog('proc1009 SQl='+ls_sql+e.Message );
                 end;
               end;
       end;

        if ResponseCode='00' then
        begin
            FillChar(phandsetVehimageYD,SizeOf(phandsetVehimageYD),0);
            copymemory(@phandsetVehimageYD.networkID,@phandgetVehimage.networkID,SizeOf(phandgetVehimage.networkID));
            copymemory(@phandsetVehimageYD.TerminalID,@phandgetVehimage.TerminalID,SizeOf(phandgetVehimage.TerminalID));
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@phandsetVehimageYD.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(phandsetVehimageYD.ProcessDate),'0')),SizeOf(phandsetVehimageYD.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@phandsetVehimageYD.Processtime,PChar(mainclass.padl(strtmp,SizeOf(phandsetVehimageYD.Processtime),'0')),SizeOf(phandsetVehimageYD.Processtime));
        end;

   copymemory(@phandsetVehimageYD.ResponseCode,PChar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@phandsetVehimageYD,SizeOf(phandsetVehimageYD));
    self.sendbody(tmpbuf,'1010',SizeOf(phandsetVehimageYD));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'请求图片上传发送成功'+phandsetVehimageYD.ResponseCode);
       except
          WriteerrorLog('发送图片上传应答失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断1010');

end;

Function TETCPeerThread.procbank1003:boolean;
var
    pbankgetqd:TBANKGETQD;
    pbanksetqd:TBANKSETQD;
    strtmp:string;
begin
     writedebuglog('procbank1003准备签到');
     try

//********************报体赋值********************************
    strtmp:=formatdatetime('yyyymmdd',now);
    FillChar(pbankgetqd, sizeof(pbankgetqd), 0);
    copymemory(@pbankgetqd.ProcessDate,PChar(strtmp),8);
    strtmp:=formatdatetime('hhmmss',now);
    copymemory(@pbankgetqd.ProcessTime,PChar(strtmp),6);
    copymemory(@pbankgetqd.TerminalID,PChar('1400001001'),10);

    copymemory(@pbankgetqd.networkID,PChar('1400001'),7);
    FillChar(buf,SizeOf(buf),0);
//**************************发报收报处理******************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbankgetqd,SizeOf(pbankgetqd));
    self.sendbodybank(tmpbuf,'1003',SizeOf(pbankgetqd));
{    if not packset(tmpbuf,'1001',true,SizeOf(pbankgetkey)) then
    begin
        self.Memo1.Lines.Append('数据包处理失败!!!');
        exit;
    end;

//***********************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetqc,SizeOf(pbanksetqc));
    self.sendbody(tmpbuf,'2008',SizeOf(pbanksetqc));
}
   except on e:exception do
   begin
       responsecode:= '09';
      writedebuglog('procbank1003  处理失败'+e.Message);
   end;
   end;
            // try
             //if not idcbank.Connected then
             //    idcbank.Connect(10000) ;
             //except
             //  writedebuglog('procbank1003 联接银行失败');
             //end;
            if idcbank.Connected then
            begin
              try
                  idcbank.WriteBuffer(buf,bufsize);
                  self.readbufbank;
                  writedebuglog('procbank1003来自'+ppackheadReceiver.SenderID+'银行终端签到请求发送成功');
              except
                  WriteerrorLog('procbank1003银行充值请求发送失败!!');
              end;
            end
            else
                WriteerrorLog('procbank1003客户端请求中断');

    if (AMessageType=1004) then
    begin
            FillChar(pbanksetqd,SizeOf(pbanksetqd),0);
            CopyMemory(@pbanksetqd,@buf,SizeOf(pbanksetqd));
            if pbanksetqd.ResponseCode='00' then
            begin
//                writelog('procbank1003银行终端签到成功:');

                result:=True;
            end
            else
            begin
                result:=false;
                WriteLog(mainclass.errorname(string(pbanksetqd.ResponseCode)));
            end;
    end
    else
    begin
          result:=False
    end;
end;




procedure TETCPeerThread.proc9001;
var
    strtmp:string;

begin
//****************************处理发送包文件**************************
 FillChar(pbanksetcz,SizeOf(pbanksetcz),0);
            CopyMemory(@pbanksetcz,@buf,SizeOf(pbankgetcz));
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetcz.ProcessDate,PChar(strtmp),SizeOf(pbanksetcz.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetcz.Processtime,PChar(strtmp),SizeOf(pbanksetcz.Processtime));

            STRTMP:=INTToStr(Round(Random*10000000));
            bufsize:=SizeOf(ppackheadReceiver)+SizeOf(pbanksetcz);
            pbanksetkey.ResponseCode:='00';
              copymemory(@pbanksetcz.responsecode,PChar('00'),SizeOf(pbanksetcz.Processtime));
//********************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetcz,SizeOf(pbanksetcz));
            self.sendbody(tmpbuf,'9002',SizeOf(pbanksetcz));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'请求充值发送成功'+pbanksetkey.ResponseCode);
              except
                  WriteerrorLog('发送充值请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc9011;
var
    strtmp:string;

begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetxf,@buf,SizeOf(pbankgetxf));
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetxf.ProcessDate,PChar(strtmp),SizeOf(pbanksetxf.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetxf.Processtime,PChar(strtmp),SizeOf(pbanksetxf.Processtime));
            FillChar(pbanksetxf,SizeOf(pbanksetxf),0);
            STRTMP:=INTToStr(Round(Random*10000000));
            fillchar(buf,sizeof(buf),0);
            copymemory(@pbanksetxf.TerminalID,@pbankgetxf.TerminalID,SizeOf(pbanksetxf.TerminalID));
            copymemory(@pbanksetxf.TerminalID,@pbankgetxf.TerminalID,SizeOf(pbanksetxf.TerminalID));
            CopyMemory(@pbanksetxf.PCardID,@pbankgetxf.PCardID,sizeof(pbanksetxf.PCardID)) ;
            CopyMemory(@pbanksetxf.TermOnlineSN,@pbankgetxf.TermOnlineSN,sizeof(pbanksetxf.TermOnlineSN)) ;
            mainclass.strtobyte(pbanksetxf.MAC1,'102030',2);
//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetxf,SizeOf(pbanksetxf));
            self.sendbody(tmpbuf,'9012',SizeOf(pbanksetxf));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'消费发送成功');
              except
                  WriteerrorLog('消费失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc9021;
begin
    CopyMemory(@pbankgetxf,@buf,SizeOf(pbankxfqr));
    WriteerrorLog('收到来自'+ppackheadReceiver.SenderID+'消费确认报文');
end;

procedure TETCPeerThread.headset(var ppackhead: TETCBANKHEAD;
  bsize: integer; strmsg: string;strmd5code:string);
begin
    bufsize:=SizeOf(ppackhead)+bsize;
    ppackhead.MessageLength:=mainclass.inttobigint(bufsize);
   writedebuglog( 'long '+strmsg+':'+inttostr(ppackhead.MessageLength));
      writedebuglog( 'long '+strmsg+':'+inttostr(bufsize));
    CopyMemory(@ppackhead.MessageType,PChar(strmsg),4);

    CopyMemory(@ppackhead.ReceiverID,@ppackheadReceiver.SenderID,7);
    CopyMemory(@ppackhead.VerifyCode,PChar(strmd5code),32);
    CopyMemory(@ppackhead.SenderID,PChar(mainclass.nodeid),7);


    bufsize:=SizeOf(ppackhead)+btsendsize;
end;



function TETCPeerThread.sendbody(abyte:array of byte;strmsglx:string;isize:integer): boolean;
begin
//****************加密相报体******************************
  try
    if strmsglx='1002' then
        mainclass.strtobyte(key1,mainclass.defaultkey,1);
    btsize:=isize;
    SetLength(indata,btsize);
    CopyMemory(@indata[0],@abyte,btsize);
    btsendsize:=(btsize div 8+1)*8;
    SetLength(outdata,btsendsize);
//    writedebuglog('发送'+strmsglx+'的明码为'+mainclass.arraytostr(indata));
     writedebuglog('发送'+strmsglx+'的明码为'+mainclass.arraytostr1(indata));

    mainclass.Encryptbcb(key1,indata,outdata);
    bufsize:=SizeOf(ppackheadsend)+btsendsize;
    writedebuglog('发送'+strmsglx+'的密码为'+mainclass.arraytostr(outdata));
    writedebuglog('发送'+strmsglx+'的加密因子'+mainclass.arraytostr(key1));
//****************加密相报体******************************


//*******************************包头赋值
    strtmp:=mainclass.getmd5(string(indata));
    self.headset(ppackheadsend,btsendsize,strmsglx,strtmp);
//*********************************************************


//*****************拼报文内容*******************************
    fillchar(buf,sizeof(buf),0);
    CopyMemory(@buf,@ppackheadsend,SizeOf(ppackheadsend));
    mainclass.dbuftobuf(outdata,buf,SizeOf(ppackheadsend));
//************************************************************
  except on e:exception  do
    begin
     responsecode:= '09';
     mainclass.WriteerrorLog('sendbody处理消息'+strmsglx+'时失败，原因：'+e.Message ) ;
    end;
   end;
    result:=true;
end;


function TETCPeerThread.sendbodybank(abyte: array of byte;
  strmsglx: string; isize: integer): boolean;
begin
//****************加密相报体******************************
    if strmsglx<='1002' then
        mainclass.strtobyte(keybank,mainclass.defaultkey,1);
    btsize:=isize;
    SetLength(indata,btsize);
    CopyMemory(@indata[0],@abyte,btsize);
    btsendsize:=(btsize div 8+1)*8;
    SetLength(outdata,btsendsize);
    writedebuglog('sendbodybank向银行发送'+strmsglx+'明码为'+mainclass.arraytostr1(indata));
    mainclass.Encryptbcb(keybank,indata,outdata);
 //   writedebuglog('sendbodybank向银行发送'+strmsglx+'密码为'+mainclass.arraytostr(outdata));
    writedebuglog('sendbodybank使用加密因子'+mainclass.arraytostr(keybank));
//****************加密相报体******************************
    try
    bufsize:=SizeOf(ppackheadsend)+btsendsize;
//*******************************包头赋值
    strtmp:=mainclass.getmd5(string(indata));
    self.headset(ppackheadsend,btsendsize,strmsglx,strtmp);
//*********************************************************

//*****************拼报文内容*******************************
    fillchar(buf,sizeof(buf),0);
    CopyMemory(@buf,@ppackheadsend,SizeOf(ppackheadsend));
// CopyMemory(@buf[SizeOf(ppackheadsend)],@outdata,btsendsize);
    mainclass.dbuftobuf(outdata,buf,SizeOf(ppackheadsend));
//************************************************************
    except on e:Exception do
    begin
      responsecode:='09';
      writedebuglog('sendbodybank运行失败');
      mainclass.WriteerrorLog('sendbodybank向银行发送'+strmsglx+'时失败，原因：'+e.Message);
    end;
    end;
      result:=true;
end;

function TETCPeerThread.sedbodybank(abyte: array of byte;
  strmsglx: string; isize: integer;bankey:string): boolean;
begin
//****************加密相报体******************************
    if strmsglx<='1002' then
        mainclass.strtobyte(keybank,bankey,1);
    btsize:=isize;
    SetLength(indata,btsize);
    CopyMemory(@indata[0],@abyte,btsize);
    btsendsize:=(btsize div 8+1)*8;
    SetLength(outdata,btsendsize);
    writedebuglog('sendbodybank向银行发送'+strmsglx+'明码为'+mainclass.arraytostr1(indata));
    mainclass.Encryptbcb(keybank,indata,outdata);
 //   writedebuglog('sendbodybank向银行发送'+strmsglx+'密码为'+mainclass.arraytostr(outdata));
    writedebuglog('sendbodybank使用加密因子'+mainclass.arraytostr(keybank));
//****************加密相报体******************************
    try
    bufsize:=SizeOf(ppackheadsend)+btsendsize;
//*******************************包头赋值
    strtmp:=mainclass.getmd5(string(indata));
    self.headset(ppackheadsend,btsendsize,strmsglx,strtmp);
//*********************************************************

//*****************拼报文内容*******************************
    fillchar(buf,sizeof(buf),0);
    CopyMemory(@buf,@ppackheadsend,SizeOf(ppackheadsend));
// CopyMemory(@buf[SizeOf(ppackheadsend)],@outdata,btsendsize);
    mainclass.dbuftobuf(outdata,buf,SizeOf(ppackheadsend));
//************************************************************
    except on e:Exception do
    begin
      responsecode:='09';
      writedebuglog('sedbodybank运行失败');
      mainclass.WriteerrorLog('sedbodybank向银行发送'+strmsglx+'时失败，原因：'+e.Message);
    end;
    end;
      result:=true;
end;

function Tsendservice.sendbodybank(abyte: array of byte;
  strmsglx: string; isize: integer): boolean;
begin
//****************加密相报体******************************
    if strmsglx<='1002' then
        mainclass.strtobyte(keybank,mainclass.defaultkey,1);
    btsize:=isize;
    SetLength(indata,btsize);
    CopyMemory(@indata[0],@abyte,btsize);
    btsendsize:=(btsize div 8+1)*8;
    SetLength(outdata,btsendsize);
    mainclass.WriteLog('sendbodybank向银行发送'+strmsglx+'明码为'+mainclass.arraytostr1(indata));
    mainclass.Encryptbcb(keybank,indata,outdata);
    //mainclass.WriteLog('sendbodybank向银行发送'+strmsglx+'密码为'+mainclass.arraytostr(outdata));
    //mainclass.WriteLog('sendbodybank使用加密因子'+mainclass.arraytostr(keybank));
//****************加密相报体******************************
    try
    bufsize:=SizeOf(ppackheadsend)+btsendsize;
//*******************************包头赋值
    strtmp:=mainclass.getmd5(string(indata));
    self.headset(ppackheadsend,btsendsize,strmsglx,strtmp);
//*********************************************************

//*****************拼报文内容*******************************
    fillchar(buf,sizeof(buf),0);
    CopyMemory(@buf,@ppackheadsend,SizeOf(ppackheadsend));
// CopyMemory(@buf[SizeOf(ppackheadsend)],@outdata,btsendsize);
    mainclass.dbuftobuf(outdata,buf,SizeOf(ppackheadsend));
//************************************************************
    except on e:Exception do
    begin
      responsecode:='09';
      mainclass.WriteerrorLog('sendbodybank运行失败');
      mainclass.WriteerrorLog('sendbodybank向银行发送'+strmsglx+'时失败，原因：'+e.Message);
    end;
    end;
      result:=true;
end;

procedure TETCPeerThread.readbufbank;

var ilength:integer;
  //  li_length:integer;
begin
    ilength:=0;
    try
            FillChar(buf,SizeOf(buf),0);
         //   li_length:=SizeOf(ppackheadReceiver);
            idcbank.ReadBuffer(bufhead,SizeOf(ppackheadReceiver));
            FillChar(ppackheadReceiver,SizeOf(ppackheadReceiver),0);
            CopyMemory(@ppackheadReceiver,@bufhead,SizeOf(ppackheadReceiver));
            try
                 AMessageType := StrToInt(ppackheadReceiver.MessageType) ;
            except
                 AMessageType:=0;
            end;
         ilength:=mainclass.inttobigint(ppackheadReceiver.MessageLength);
         idcbank.ReadBuffer(buf,ilength-SizeOf(ppackheadReceiver));
          writedebuglog('MessageLength-- '+inttostr(ilength)+'  ppackheadReceiver-- '+inttostr(SizeOf(ppackheadReceiver)));
      except on e:exception do
      begin
         responsecode:='09';
         writedebuglog('readbufbank接受银行'+inttostr(AMessageType)+'时异常'+e.Message );
         mainclass.WriteerrorLog('readbufbank接受银行'+inttostr(AMessageType)+'时异常'+e.Message );

      end;
      end;
//****************************************解密报体内容*********************************************************
//       writedebuglog('使用加密因子'+mainclass.arraytostr(keybank)+inttostr(AMessageType));

       if AMessageType=1002 then
       begin

           mainclass.strtobyte(keybank,mainclass.defaultkey,1);
       end;
       btsize:=ilength-sizeof(ppackheadReceiver);
       SetLength(indata,btsize);
       btsendsize:=(btsize div 8+1)*8;
       SetLength(outdata,btsendsize);
       Move(buf,indata[0],btsize);
    //   writedebuglog('接收银行数据'+inttostr(AMessageType)+'的密码为'+mainclass.arraytostr(indata));
       mainclass.Decryptbcb(keybank,indata,outdata);
       writedebuglog('接收银行数据'+inttostr(AMessageType)+'的明码为'+mainclass.arraytostr1(outdata));
       writedebuglog('使用加密因子'+mainclass.arraytostr(keybank));
       setlength(outdata,length(outdata)-outdata[high(outdata)]);
       mainclass.dbuftobuf(outdata,buf,0);

end;

procedure TETCPeerThread.readbufbak(bankey:string);

var ilength:integer;
  //  li_length:integer;
begin
    ilength:=0;
    try
            FillChar(buf,SizeOf(buf),0);
         //   li_length:=SizeOf(ppackheadReceiver);
            idcbank.ReadBuffer(bufhead,SizeOf(ppackheadReceiver));
            FillChar(ppackheadReceiver,SizeOf(ppackheadReceiver),0);
            CopyMemory(@ppackheadReceiver,@bufhead,SizeOf(ppackheadReceiver));
            try
                 AMessageType := StrToInt(ppackheadReceiver.MessageType) ;
            except
                 AMessageType:=0;
            end;
         ilength:=mainclass.inttobigint(ppackheadReceiver.MessageLength);
         idcbank.ReadBuffer(buf,ilength-SizeOf(ppackheadReceiver));
          writedebuglog('MessageLength-- '+inttostr(ilength)+'  ppackheadReceiver-- '+inttostr(SizeOf(ppackheadReceiver)));
      except on e:exception do
      begin
         responsecode:='09';
         writedebuglog('readbufbank接受银行'+inttostr(AMessageType)+'时异常'+e.Message );
         mainclass.WriteerrorLog('readbufbak接受银行'+inttostr(AMessageType)+'时异常'+e.Message );

      end;
      end;
//****************************************解密报体内容*********************************************************
//       writedebuglog('使用加密因子-----'+mainclass.arraytostr(keybank)+inttostr(AMessageType));
//       WritedebugLog('+++++++++'+ppackheadReceiver.MessageType);
       if AMessageType=1002 then
       begin
//           writedebuglog('=============='+bankey);
           mainclass.strtobyte(keybank,bankey,1);
       end;
       btsize:=ilength-sizeof(ppackheadReceiver);
       SetLength(indata,btsize);
       btsendsize:=(btsize div 8+1)*8;
       SetLength(outdata,btsendsize);
       Move(buf,indata[0],btsize);
    //   writedebuglog('接收银行数据'+inttostr(AMessageType)+'的密码为'+mainclass.arraytostr(indata));
       mainclass.Decryptbcb(keybank,indata,outdata);
       writedebuglog('接收银行数据'+inttostr(AMessageType)+'的明码为'+mainclass.arraytostr1(outdata));
       writedebuglog('使用加密因子'+mainclass.arraytostr(keybank));
       setlength(outdata,length(outdata)-outdata[high(outdata)]);
       mainclass.dbuftobuf(outdata,buf,0);

end;

procedure TETCPeerThread.proc2001;
var
    strtmp:string;

    i:integer;

begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetczquery,@buf,SizeOf(pbankgetczquery));
            FillChar(pbanksetczquery,SizeOf(pbanksetczquery),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetczquery.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pbanksetczquery.ProcessDate),'0')),SizeOf(pbanksetczquery.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetczquery.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pbanksetczquery.Processtime),'0')),SizeOf(pbanksetczquery.Processtime));
            copymemory(@pbanksetczquery.NetWorkID,@pbankgetczquery.NetWorkID,SizeOf(pbanksetczquery.NetWorkID));
            copymemory(@pbanksetczquery.TerminalID,@pbankgetczquery.TerminalID,SizeOf(pbanksetczquery.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin
              //  writelog('卡号:'+pbankgetczquery.PCardID+'网络编号:'+pbankgetczquery.PCardNetID+'查询请求');
                with adosp do
                begin
                    close;
                  errorid:=-1;
                  if mainclass.bankid='9000000' then
                  begin
                    ProcedureName:='Usp_ExpOBUActive';
                  end
                  else
                  ProcedureName:='Usp_ExpCardInfoQuery';
                  Parameters.Clear;
                  Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,string(pbankgetczquery.ProcessDate));
                  Parameters.CreateParameter('@ProcessTime',ftstring,pdInput,6,string(pbankgetczquery.ProcessTime));
                  Parameters.CreateParameter('@NetWorkID',ftstring,pdInput,7,string(pbankgetczquery.networkid));
                  Parameters.CreateParameter('@TerminalID',ftstring,pdInput,10,string(pbankgetczquery.TerminalID));
                  Parameters.CreateParameter('@PCardNetID',ftString,pdInput,4,string(pbankgetczquery.PCardNetID));
                  Parameters.CreateParameter('@PCardID',ftString,pdInput,16,string(pbankgetczquery.PCardID));
                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);
                  Parameters.CreateParameter('@errorid',ftinteger,pdoutput,4,errorid);
                  Parameters.CreateParameter('@ErrorMsg',ftstring,pdoutput,50,ErrorMsg);
                      try
        //               errorid1:=0;
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                     //     mainclass.writeerrorlog(' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));

                          open;
                          errorid:=parameters.ParamByName('@errorid').Value;
                          ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                        if errorid<0 then
                          Errormsg:=parameters.ParamByName('@errormsg').Value+'卡号'+pbankgetczquery.PCardID;
                          if RecordCount=0 then
                          begin
                              ResponseCode:='16'; //此卡不在存
                              mainclass.WriteerrorLog('此卡不存在'+pbankgetczquery.PCardID+'网络编号'+pbankgetczquery.PCardNetID);
                          end;
                          if ResponseCode='00' then
                              begin

                                  copymemory(@pbanksetczquery.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(pbanksetczquery.CustomerID),' ')),SizeOf(pbanksetczquery.CustomerID));
                                  copymemory(@pbanksetczquery.UserType,PChar(mainclass.padl(fieldbyname('UserType').AsString,SizeOf(pbanksetczquery.UserType),'0')),SizeOf(pbanksetczquery.UserType));
                                  copymemory(@pbanksetczquery.UserName,PChar(mainclass.padr(fieldbyname('UserName').AsString,SizeOf(pbanksetczquery.UserName),' ')),SizeOf(pbanksetczquery.UserName));
                                  copymemory(@pbanksetczquery.CertificateType,PChar(mainclass.padl(fieldbyname('CertificateType').AsString,SizeOf(pbanksetczquery.CertificateType),'0')),SizeOf(pbanksetczquery.CertificateType));
                                  copymemory(@pbanksetczquery.CertificateID,PChar(mainclass.padr(fieldbyname('CertificateID').AsString,SizeOf(pbanksetczquery.CertificateID),' ')),SizeOf(pbanksetczquery.CertificateID));
                                  copymemory(@pbanksetczquery.Contact,PChar(mainclass.padr(fieldbyname('Contact').AsString,SizeOf(pbanksetczquery.Contact),' ')),SizeOf(pbanksetczquery.Contact));
                                  copymemory(@pbanksetczquery.Phone,PChar(mainclass.padl(fieldbyname('Phone').AsString,SizeOf(pbanksetczquery.Phone),'0')),SizeOf(pbanksetczquery.Phone));
                                  copymemory(@pbanksetczquery.Mobile,PChar(mainclass.padl(fieldbyname('Mobile').AsString,SizeOf(pbanksetczquery.Mobile),'0')),SizeOf(pbanksetczquery.Mobile));
                                  copymemory(@pbanksetczquery.PExpireTime,PChar(mainclass.padl(formatdatetime('YYYYMMDD',fieldbyname('PExpireTime').asdatetime),SizeOf(pbanksetczquery.PExpireTime),'0')),SizeOf(pbanksetczquery.PExpireTime));
                                  copymemory(@pbanksetczquery.VCBindType,PChar(mainclass.padl(fieldbyname('VCBindType').AsString,SizeOf(pbanksetczquery.VCBindType),'0')),SizeOf(pbanksetczquery.VCBindType));
                                  copymemory(@pbanksetczquery.Vehplate,PChar(mainclass.padr(fieldbyname('Vehplate').AsString,SizeOf(pbanksetczquery.Vehplate),' ')),SizeOf(pbanksetczquery.Vehplate));
                                  copymemory(@pbanksetczquery.Vehplatecolor,PChar(mainclass.padr(fieldbyname('Vehplatecolor').AsString,SizeOf(pbanksetczquery.vehplatecolor),' ')),SizeOf(pbanksetczquery.vehplatecolor));

                                  copymemory(@pbanksetczquery.VehType,PChar(mainclass.padl(fieldbyname('VehType').AsString,SizeOf(pbanksetczquery.VehType),'0')),SizeOf(pbanksetczquery.VehType));
                                  copymemory(@pbanksetczquery.VehSeatNum,PChar(mainclass.padl(fieldbyname('VehSeatNum').AsString,SizeOf(pbanksetczquery.VehSeatNum),'0')),SizeOf(pbanksetczquery.VehSeatNum));
                                  copymemory(@pbanksetczquery.SysBeforeMoney,PChar(mainclass.padl(fieldbyname('SysBeforeMoney').AsString,12,'0')),SizeOf(pbanksetczquery.SysBeforeMoney));
                                  copymemory(@pbanksetczquery.QCMoney,PChar(mainclass.padl(fieldbyname('QCMoney').AsString,12,'0')),SizeOf(pbanksetczquery.QCMoney));
                                  copymemory(@pbanksetczquery.BKMoney,PChar(mainclass.padl(fieldbyname('BKMoney').AsString,12,'0')),SizeOf(pbanksetczquery.BKMoney));
                                  copymemory(@pbanksetczquery.TKMoney,PChar(mainclass.padl(fieldbyname('TKMoney').AsString,12,'0')),SizeOf(pbanksetczquery.TKMoney));
                              end;
                      except on e:exception do
                      begin
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog('充值2001查询失败原因:'+e.message);
                          ResponseCode:='10';  //快通卡查询错误
                      end;
                  end;


                end;
        end;

            copymemory(@pbanksetczquery.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetczquery.ResponseCode));
            copymemory(@pbanksetczquery.PCardNetID,@pbankgetczquery.PCardNetID,SizeOf(pbanksetczquery.PCardNetID));

            copymemory(@pbanksetczquery.PCardID,@pbankgetczquery.PCardID,sizeof(pbanksetczquery.PCardID)) ;


//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetczquery,SizeOf(pbanksetczquery));
            self.sendbody(tmpbuf,'2002',SizeOf(pbanksetczquery));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                //  writelog('来自'+ppackheadReceiver.SenderID+'卡号'+pbanksetczquery.PCardID+'充值查询发送成功');
              except
                  WriteerrorLog('充值查询失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;


procedure TETCPeerThread.proc2003;
var
    strtmp,strtmp1:string;

    i:integer;
    mac1:array[0..3] of byte;
    strmsg:string;
    imoney:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetczqq,@buf,SizeOf(pbankgetczqq));
            // 读取数据库
//      if i_ mod 2 =0 then
      i:=0;
      if  copy(pbankgetczqq.PCardID,5,2)='22' then
      begin
          if mainclass.bdatabaseconnect then
           begin
                with adosp do
                begin
                  close;
                    try
                  errorid:=-1;
                  ProcedureName:='Usp_ETCPreCardRechargeBanklog_Local';
                  Parameters.Clear;
                  Parameters.CreateParameter('ProcessDate',ftString,pdInput,31,Trim(string(pbankgetczqq.ProcessDate)));
                  Parameters.CreateParameter('ProcessTime',ftString,pdInput,20,mainclass.padl(Trim(string(pbankgetczqq.ProcessTime)),6,'0'));
                  Parameters.CreateParameter('termdate',ftString,pdInput,31,Trim(string(pbankgetczqq.termdate)));
                  Parameters.CreateParameter('termtime',ftString,pdInput,20,mainclass.padl(Trim(string(pbankgetczqq.termtime)),6,'0'));
                  Parameters.CreateParameter('NetWorkID',ftString,pdInput,20,Trim(string(pbankgetczqq.networkid)));
                  Parameters.CreateParameter('TerminalID',ftString,pdInput,20,Trim(string(pbankgetczqq.TerminalID)));
                  Parameters.CreateParameter('CustomerID',ftString,pdInput,20,Trim(string(pbankgetczqq.CustomerID)));
                  Parameters.CreateParameter('PCardNetID',ftString,pdInput,20,Trim(string(pbankgetczqq.PCardNetID)));
                  Parameters.CreateParameter('VCBindType',ftinteger,pdInput,4,mainclass.yxsj(string(pbankgetczqq.VCBindType)));
                  Parameters.CreateParameter('vehplate',ftString,pdInput,20,Trim(string(pbankgetczqq.vehplate)));
                  Parameters.CreateParameter('PCardID',ftString,pdInput,20,Trim(string(pbankgetczqq.PCardID)));
                  Parameters.CreateParameter('CardBeforeMoney',ftInteger,pdInput,20,mainclass.yxsj(string(pbankgetczqq.SysBeforeMoney)));
                  Parameters.CreateParameter('CZMoney',ftinteger,pdInput,20,mainclass.yxsj(string(pbankgetczqq.CZMoney)));
                  strtmp:=copy(string(pbankgetczqq.BKMoney),pos('-',string(pbankgetczqq.BKMoney)),12);
                  Parameters.CreateParameter('BKMoney',ftinteger,pdInput,20,mainclass.yxsj(strtmp));
                  Parameters.CreateParameter('TKMoney',ftinteger,pdInput,20,mainclass.yxsj(string(pbankgetczqq.TKMoney)));//mainclass.yxsj(string(pbankgetczqq.TKMoney))
                  Parameters.CreateParameter('WasteSN',ftString,pdInput,30,Trim(string(pbankgetczqq.WasteSN)));
                  Parameters.CreateParameter('OnlineSN',ftString,pdInput,10,Trim(string(pbankgetczqq.OnlineSN)));
                  Parameters.CreateParameter('OfflineSN ',ftString,pdInput,10,Trim(string(pbankgetczqq.OfflineSN)));
                  Parameters.CreateParameter('Random ',ftString,pdInput,20,Trim(string(pbankgetczqq.Random)));
                  Parameters.CreateParameter('MAC1 ',ftString,pdInput,20,Trim(string(pbankgetczqq.MAC1)));
                  Parameters.CreateParameter('MAC2 ',ftString,pdInput,20,string('0'));
                  IF AMessageType=2003 then I:=11;
                  IF AMessageType=2007 then I:=12;
                  Parameters.CreateParameter('CZType',ftinteger,pdInput,4,I);
                  Parameters.CreateParameter('OperatorID',ftString,pdInput,8,Trim(string(pbankgetczqq.OperatorID)));
                  Parameters.CreateParameter('CZWasteSn',ftString,pdInput,4,string(''));
                  Parameters.CreateParameter('termno',ftString,pdInput,12,string(pbankgetczqq.TermNo));
                  Parameters.CreateParameter('CardSeq',ftString,pdInput,4,string(''));
                  Parameters.CreateParameter('KeyIndex',ftString,pdInput,2,string(''));
                  Parameters.CreateParameter('KeyId',ftString,pdInput,2,string(''));

                  Parameters.CreateParameter('ResponseCode',ftstring,pdoutput,4,'');
                  Parameters.CreateParameter('Errorid',ftinteger,pdoutput,4,errorid);
                  Parameters.CreateParameter('ErrorMsg',ftString,pdoutput,50,ErrorMsg);

    //               errorid1:=0;
                      ExecProc;

                      errorid:=parameters.ParamByName('errorid').Value;
                      ResponseCode:=parameters.ParamByName('ResponseCode').Value;

                      //*************************************************调用加密机的函数
                      CopyMemory(@pCardLoadPara.CardId,@pbankgetczqq.PCardID,SizeOf(pCardLoadPara.CardId));
                      imoney:=strtoint(mainclass.yxsj(pbankgetczqq.SysBeforeMoney));
                      CopyMemory(@pCardLoadPara.Balance,PChar(IntToHex(imoney,8)),8);
                      //充值金额
                      strtmp:=copy(string(pbankgetczqq.BKMoney),pos('-',string(pbankgetczqq.BKMoney)),12);
                      imoney:=strtoint(mainclass.yxsj((pbankgetczqq.czmoney)))+strtoint(mainclass.yxsj(strtmp))+strtoint(mainclass.yxsj((pbankgetczqq.TKMoney)));
                      CopyMemory(@pCardLoadPara.CardPayMoney,PChar(IntToHex(imoney,8)),8);
                      CopyMemory(@pCardLoadPara.TransNumber,@pbankgetczqq.OnlineSN,4);
                      CopyMemory(@pCardLoadPara.Rand,@pbankgetczqq.Random,8);
                      CopyMemory(@pCardLoadPara.MAC1,@pbankgetczqq.MAC1,8);
                      CopyMemory(@pCardLoadPara.DateStr,@pbankgetczqq.TermDate,SizeOf(pCardLoadPara.DateStr));
                      CopyMemory(@pCardLoadPara.timeStr,@pbankgetczqq.TermTime,SizeOf(pCardLoadPara.timeStr));
                      CopyMemory(@pCardLoadPara.TerminalNo,@pbankgetczqq.TermNo,SizeOf(pCardLoadPara.TerminalNo));
                      //SetLength(mac1,8);
      //                 CalMAC2(pcardloadpara,mainclass.SJMJSERVERIP,mainclass.SJMJPORT,mac1,strmsg);

                      if CheckMAC1(pcardloadpara,mainclass.SJMJSERVERIP,mainclass.SJMJPORT,strmsg) then
                           CalMAC2(pcardloadpara,mainclass.SJMJSERVERIP,mainclass.SJMJPORT,mac1,strmsg)
                      else
                      begin
                          ResponseCode:='95';
                          writeerrorlog('充值为:'+mainclass.yxsj((pbankgetczqq.czmoney))
                                        +'补扣'+mainclass.yxsj((pbankgetczqq.BKMoney))+'退款'+mainclass.yxsj((pbankgetczqq.TKMoney))
                                        +'加密金额'+inttostr(imoney)+'交易序列号'+pCardLoadPara.TransNumber+'随机数'
                                        +pCardLoadPara.Rand+'终端号'+pCardLoadPara.TerminalNo+'时间'
                                        +pCardLoadPara.DateStr+pCardLoadPara.TimeStr+'MAC1:'+pCardLoadPara.MAC1
                                        +'卡前余额:'+pCardLoadPara.Balance+'错误信息'+strmsg);
                      end;

                      strtmp:=mainclass.BytestoHexString(mac1,SizeOf(mac1));

                  except on e:exception do
                  begin
                      for i:=0 to Parameters.count-1 do
                      begin
                          strtmp1:=strtmp1+string(Parameters[i].Value)+''',''';
                          mainclass.WriteerrorLog('strtmp1:'+strtmp1);
                      end;

                      mainclass.WriteerrorLog('2003流水号为：'+string(pbankgetczqq.WasteSN)+'的流水写入数据库失败,失败原因为'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                      ResponseCode:='91';
                  end;
                  end;
                 end;

           end
           else
           begin
               ResponseCode:='99';
               WriteerrorLog('2003数据库连接失败!');
           end;
      end;
      FillChar(pbanksetczqq,SizeOf(pbankgetczqq),0);

      CopyMemory(@pbanksetczqq.mac2,PChar(strtmp),SizeOf(pbanksetczqq.mac2));
      strtmp:=FormatDateTime('yyyymmdd',now);
      copymemory(@pbanksetczqq.ProcessDate,PChar(strtmp),SizeOf(pbanksetczqq.ProcessDate));
      strtmp:=FormatDateTime('hhmmss',now);
      copymemory(@pbanksetczqq.Processtime,PChar(strtmp),SizeOf(pbanksetczqq.Processtime));
      copymemory(@pbanksetczqq.NetWorkID,@pbankgetczqq.NetWorkID,SizeOf(pbankgetczqq.NetWorkID));
      copymemory(@pbanksetczqq.username,@pbanksetczquery.username,SizeOf(pbanksetczqq.username));
      copymemory(@pbanksetczqq.TerminalID,@pbankgetczqq.TerminalID,SizeOf(pbankgetczqq.TerminalID));
      copymemory(@pbanksetczqq.CustomerID,@pbankgetczqq.CustomerID,SizeOf(pbanksetczqq.CustomerID));

      copymemory(@pbanksetczqq.PCardNetID,@pbankgetczqq.PCardNetID,SizeOf(pbanksetczqq.PCardNetID));
      CopyMemory(@pbanksetczqq.PCardID,@pbankgetczqq.PCardID,sizeof(pbankgetczqq.PCardID)) ;            ;

      copymemory(@pbanksetczqq.wastesn,@pbankgetczqq.wastesn,SizeOf(pbanksetczqq.wastesn));
      copymemory(@pbanksetczqq.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetczqq.ResponseCode));
     writelog('PCardID:'+ pbanksetczqq.PCardID+'czmoney:'+mainclass.yxsj(pbankgetczqq.czmoney));
//***********************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetczqq,SizeOf(pbanksetczqq));
            if AMessageType=2003 then
            begin
               self.sendbody(tmpbuf,'2004',SizeOf(pbanksetczqq));
            end;
            if AMessageType=2007 then
            begin
               self.sendbody(tmpbuf,'2008',SizeOf(pbanksetczqq));
            end;

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writelog('卡号'+pbanksetczqq.pcardid+'充值请求发送成功，充值金额为'+mainclass.yxsj((pbankgetczqq.czmoney)));
              except
                  WriteerrorLog('充值请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2005;
var
    strtmp:string;

    i:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetczcg,@buf,SizeOf(pbankgetczcg));
            if mainclass.bdatabaseconnect then
            begin
            with adosp do
            begin
                try
              close;
              errorid:=-1;
              ProcedureName:='Usp_ETCPreCardRechargeBanklog_Localreply';
              Parameters.Clear;
              Parameters.CreateParameter('ProcessDate',ftString,pdInput,31,mainclass.yxsj(string(pbankgetczcg.ProcessDate)));
              Parameters.CreateParameter('ProcessTime',ftString,pdInput,20,mainclass.yxsj(string(pbankgetczcg.ProcessTime)));
              Parameters.CreateParameter('NetWorkID',ftString,pdInput,20,Trim(string(pbankgetczcg.networkid)));
              Parameters.CreateParameter('TerminalID',ftString,pdInput,20,Trim(string(pbankgetczcg.TerminalID)));
              Parameters.CreateParameter('PCardNetID',ftString,pdInput,20,Trim(string(pbankgetczcg.PCardNetID)));
              Parameters.CreateParameter('PCardID',ftString,pdInput,20,Trim(string(pbankgetczcg.PCardID)));
              Parameters.CreateParameter('@InvoiceClass',ftString,pdInput,2,Trim(string(pbankgetczcg.InvoiceType)));
              Parameters.CreateParameter('@InvoiceBatch',ftString,pdInput,4,Trim(string(pbankgetczcg.InvoiceBatch)));
              Parameters.CreateParameter('@InvoiceID',ftString,pdInput,8,Trim(string(pbankgetczcg.InvoiceID)));
              Parameters.CreateParameter('AfterMoney',ftInteger,pdInput,20,mainclass.yxsj(string(pbankgetczcg.AfterMoney)));
              Parameters.CreateParameter('CZMoney',ftinteger,pdInput,20,mainclass.yxsj(string(pbankgetczcg.CZMoney)));
              strtmp:=copy(string(pbankgetczqq.BKMoney),pos('-',string(pbankgetczqq.BKMoney)),12);

              Parameters.CreateParameter('BKMoney',ftinteger,pdInput,20,mainclass.yxsj(strtmp));
              Parameters.CreateParameter('TKMoney',ftinteger,pdInput,20,mainclass.yxsj(string(pbankgetczcg.TKMoney)));//mainclass.yxsj(string(pbankgetczqq.TKMoney))
              Parameters.CreateParameter('WasteSN',ftString,pdInput,30,Trim(string(pbankgetczcg.WasteSN)));
              Parameters.CreateParameter('OnlineSN',ftString,pdInput,10,Trim(string(pbankgetczcg.OnlineSN)));
              Parameters.CreateParameter('OfflineSN ',ftString,pdInput,10,Trim(string(pbankgetczcg.OfflineSN)));
              Parameters.CreateParameter('writecardFlag',ftString,pdInput,20,Trim(string(pbankgetczcg.WriteCardFlag)));
              strtmp:=string(pbanksetczqq.MAC2);
              Parameters.CreateParameter('MAC2',ftString,pdInput,10,Trim(strtmp));
              strtmp:='';
              Parameters.CreateParameter('TAC',ftString,pdInput,10,Trim(strtmp));
              Parameters.CreateParameter('ResponseCode',ftstring,pdInputOutput,2,'00');
              Parameters.CreateParameter('Errorid',ftinteger,pdInputOutput,4,-1);
              Parameters.CreateParameter('ErrorMsg',ftString,pdoutput,50,ErrorMsg);

//               errorid1:=0;
                  ExecProc;
                  errorid:=parameters.ParamByName('errorid').Value;
                  ResponseCode:=parameters.ParamByName('ResponseCode').Value;
                  if errorid<0 then
                      Errormsg:=parameters.ParamByName('errormsg').Value;
//                  ResponseCode:='26';
                  if responsecode<>'00' then
                  begin
                      writelog('流水号为：'+string(pbankgetczcg.WasteSN)+'的充值失败'+mainclass.errorname(responsecode)+'金额为:'+pbankgetczcg.AfterMoney+'分');
                  end;

              except on e:exception do
              begin
                  strtmp:='';
                  for i:=0 to Parameters.count-1 do
                  begin
                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                  end;
                  mainclass.WriteerrorLog('2005流水号为：'+string(pbankgetczcg.WasteSN)+'的流水写入数据库失败,失败原因为'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                  ResponseCode:='91';
              end;
              end;
                   if (pbankgetczcg.InvoiceID<>'00000000') and (pbankgetczcg.InvoiceID<>'') then
                   begin
                        close;
                        errorid:=-1;
                        ProcedureName:='Usp_ETCPreCardRechargeBanklog_LocalBillNO';
                        Parameters.Clear;
                        Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,Trim(string(pbankgetczcg.ProcessDate)));
                        Parameters.CreateParameter('@ProcessTime',ftString,pdInput,6,Trim(string(pbankgetczcg.ProcessTime)));
                        Parameters.CreateParameter('@NetWorkID',ftString,pdInput,12,Trim(string(pbankgetczcg.networkid)));
                        Parameters.CreateParameter('@TerminalID',ftString,pdInput,12,Trim(string(pbankgetczcg.TerminalID)));
                        Parameters.CreateParameter('@PCardNetID',ftString,pdInput,4,Trim(string(pbankgetczcg.PCardNetID)));
                        Parameters.CreateParameter('@PCardID',ftString,pdInput,16,Trim(string(pbankgetczcg.PCardID)));
                        Parameters.CreateParameter('@InvoiceClass',ftString,pdInput,2,Trim(string(pbankgetczcg.Invoicetype)));
                        Parameters.CreateParameter('@InvoiceBatch',ftString,pdInput,4,Trim(string(pbankgetczcg.InvoiceBatch)));
                        Parameters.CreateParameter('@InvoiceID',ftString,pdInput,8,Trim(string(pbankgetczcg.InvoiceID)));
                        Parameters.CreateParameter('@WasteSN',ftString,pdInput,30,Trim(string(pbankgetczcg.WasteSN)));
                        Parameters.CreateParameter('@OperatorID',ftString,pdInput,8,Trim(string(pbankgetczqq.OperatorID)));
                        Parameters.CreateParameter('@ResponseCode',ftString,pdInputOutput,8,0);
                        Parameters.CreateParameter('@errorid',ftinteger,pdInputOutput,4,-1);
                        Parameters.CreateParameter('@ErrorMsg',ftstring,pdInputOutput,50,'');

                        try
                            open;
                            errorid:=parameters.ParamByName('@errorid').Value;
                            if errorid<0 then
                            Errormsg:=parameters.ParamByName('@errormsg').Value;
                            ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                        except on e:exception do
                        begin
                            strtmp:='';
                            for i:=0 to Parameters.count-1 do
                            begin
                                strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                            end;
                             mainclass.writeerrorlog(e.message+' 123 bexec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                            ResponseCode:='33';
                        end;
                      end;
                   end;
              
             end;
            end;

            FillChar(pbanksetczcg,SizeOf(pbanksetczcg),0);
            if ResponseCode='00' then
            begin
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetczcg.ProcessDate,PChar(strtmp),SizeOf(pbanksetczcg.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pbanksetczcg.Processtime,PChar(strtmp),SizeOf(pbanksetczcg.Processtime));
                copymemory(@pbanksetczcg.NetWorkID,@pbankgetczcg.NetWorkID,SizeOf(pbankgetczcg.NetWorkID));
                copymemory(@pbanksetczcg.TerminalID,@pbankgetczcg.TerminalID,SizeOf(pbankgetczcg.TerminalID));
                copymemory(@pbanksetczcg.wastesn,@pbankgetczcg.wastesn,SizeOf(pbanksetczcg.wastesn));
                copymemory(@pbanksetczcg.PCardNetID,@pbankgetczcg.PCardNetID,SizeOf(pbankgetczcg.PCardNetID));
                copymemory(@pbanksetczcg.PCardID,@pbankgetczcg.PCardID,sizeof(pbankgetczcg.PCardID)) ;
            end;
        

            copymemory(@pbanksetczcg.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetczcg.ResponseCode));

//**********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetczcg,SizeOf(pbanksetczcg));
           if AMessageType=2005 then
                self.sendbody(tmpbuf,'2006',SizeOf(pbanksetczcg));
           if AMessageType=2009 then
                self.sendbody(tmpbuf,'2010',SizeOf(pbanksetczcg));
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.senderid+'充值确认发送成功'+pbanksetczcg.PCardID);
              except
                  WriteerrorLog('充值成功发送失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2011;
var
    strtmp:string;

    i:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetczpjdy,@buf,SizeOf(pbankgetczpjdy));
            FillChar(pbanksetczpjdy,SizeOf(pbanksetczpjdy),0);
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetczpjdy.ProcessDate,PChar(strtmp),SizeOf(pbanksetczpjdy.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetczpjdy.Processtime,PChar(strtmp),SizeOf(pbanksetczpjdy.Processtime));
            copymemory(@pbanksetczpjdy.NetWorkID,@pbankgetczpjdy.NetWorkID,SizeOf(pbankgetczpjdy.NetWorkID));
            copymemory(@pbanksetczpjdy.TerminalID,@pbankgetczpjdy.TerminalID,SizeOf(pbankgetczpjdy.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin
                    with adosp do
                    begin
                              try
                        close;
                              errorid:=-1;
                              ProcedureName:='Usp_ETCPreCardRechargeBanklog_LocalBillNO';
                              Parameters.Clear;
                              Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,Trim(string(pbankgetczpjdy.ProcessDate)));
                              Parameters.CreateParameter('@ProcessTime',ftString,pdInput,6,Trim(string(pbankgetczpjdy.ProcessTime)));
                              Parameters.CreateParameter('@NetWorkID',ftString,pdInput,12,Trim(string(pbankgetczpjdy.networkid)));
                              Parameters.CreateParameter('@TerminalID',ftString,pdInput,12,Trim(string(pbankgetczpjdy.TerminalID)));
                              Parameters.CreateParameter('@PCardNetID',ftString,pdInput,4,Trim(string(pbankgetczpjdy.PCardNetID)));
                              Parameters.CreateParameter('@PCardID',ftString,pdInput,16,Trim(string(pbankgetczpjdy.PCardID)));
                              Parameters.CreateParameter('@InvoiceClass',ftString,pdInput,2,Trim(string(pbankgetczpjdy.InvoiceType)));
                              Parameters.CreateParameter('@InvoiceBatch',ftString,pdInput,4,Trim(string(pbankgetczpjdy.InvoiceBatch)));
                              Parameters.CreateParameter('@InvoiceID',ftString,pdInput,8,Trim(string(pbankgetczpjdy.InvoiceID)));
                              Parameters.CreateParameter('@WasteSN',ftString,pdInput,30,Trim(string(pbankgetczpjdy.WasteSN)));
                              Parameters.CreateParameter('@OperatorID',ftString,pdInput,8,Trim(string(pbankgetczpjdy.OperatorID)));
                              Parameters.CreateParameter('@ResponseCode',ftString,pdInputOutput,8,0);
                              Parameters.CreateParameter('@errorid',ftinteger,pdInputOutput,4,-1);
                              Parameters.CreateParameter('@ErrorMsg',ftstring,pdInputOutput,50,'');


                                  open;
                                  errorid:=parameters.ParamByName('@errorid').Value;
                                  if errorid<0 then
                                  Errormsg:=parameters.ParamByName('@errormsg').Value;
                                  ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                              except on e:exception do
                              begin
                                  strtmp:='';
                                  for i:=0 to Parameters.count-1 do
                                  begin
                                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                                  end;
                                   mainclass.writeerrorlog(e.message+' 2005exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                                  ResponseCode:='33';
                              end;
                            end;
                        if ResponseCode='00' then
                        begin
                            copymemory(@pbanksetczpjdy.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(pbanksetczpjdy.CustomerID),' ')),SizeOf(pbanksetczpjdy.CustomerID));
                            copymemory(@pbanksetczpjdy.UserName,PChar(mainclass.padr(fieldbyname('UserName').AsString,SizeOf(pbanksetczpjdy.UserName),' ')),SizeOf(pbanksetczpjdy.UserName));
                            copymemory(@pbanksetczpjdy.InvoiceID,@pbankgetczpjdy.InvoiceID,SizeOf(pbanksetczpjdy.InvoiceID));
                            copymemory(@pbanksetczpjdy.AfterMoney,PChar(mainclass.padl(fieldbyname('cardAfterMoney').AsString,12,'0')),SizeOf(pbanksetczpjdy.AfterMoney));
                            copymemory(@pbanksetczpjdy.CZMoney,PChar(mainclass.padl(fieldbyname('CZMoney').AsString,12,'0')),SizeOf(pbanksetczpjdy.CZMoney));
                            copymemory(@pbanksetczpjdy.BKMoney,PChar(mainclass.padl(fieldbyname('BKMoney').AsString,12,'0')),SizeOf(pbanksetczpjdy.BKMoney));
                            copymemory(@pbanksetczpjdy.TKMoney,PChar(mainclass.padl(fieldbyname('TKMoney').AsString,12,'0')),SizeOf(pbanksetczpjdy.TKMoney));
                            copymemory(@pbanksetczpjdy.WasteSN,@pbankgetczpjdy.WasteSN,SizeOf(pbanksetczpjdy.WasteSN));
                            copymemory(@pbanksetczpjdy.OnlineSN,PChar(mainclass.padr(fieldbyname('OnlineSN').AsString,SizeOf(pbanksetczpjdy.OnlineSN),' ')),SizeOf(pbanksetczpjdy.OnlineSN));
                            copymemory(@pbanksetczpjdy.OfflineSN,PChar(mainclass.padr(fieldbyname('OfflineSN').AsString,SizeOf(pbanksetczpjdy.OfflineSN),' ')),SizeOf(pbanksetczpjdy.OfflineSN));
                            copymemory(@pbanksetczpjdy.Vehplate,PChar(mainclass.padr(fieldbyname('Vehplate').AsString,SizeOf(pbanksetczpjdy.Vehplate),' ')),SizeOf(pbanksetczpjdy.Vehplate));
                        end;
                    end;
            end;
            copymemory(@pbanksetczpjdy.PCardNetID,@pbankgetczpjdy.PCardNetID,SizeOf(pbankgetczpjdy.PCardNetID));
            CopyMemory(@pbanksetczpjdy.PCardID,@pbankgetczpjdy.PCardID,sizeof(pbanksetczpjdy.PCardID)) ;
            CopyMemory(@pbanksetczpjdy.ResponseCode,PChar(ResponseCode),sizeof(pbanksetczpjdy.PCardID)) ;
//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetczpjdy,SizeOf(pbanksetczpjdy));
            self.sendbody(tmpbuf,'2012',SizeOf(pbanksetczpjdy));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'票据打印发送成功');
              except
                  WriteerrorLog('票据打印请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;


destructor TETCPeerThread.Destroy;
begin
   { try
      adoqry.Active :=false;
      adoqry.Close;
    except
    end;
    try
       adosp.Active :=false;
       adosp.Close;
    except
    end;
    try
       adoconn.Connected:=false;
       adoconn.Close;
    except
    end;

    adoqry.free;
    adosp.Free;
    adoconn.Free;}
  CoUnInitialize;  // 在线程中创建Ado连接需要初始化Ado的COM接口
  inherited;

end;

procedure TETCPeerThread.proc2013;
var
    strtmp:string;


    i:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetczpjcd,@buf,SizeOf(pbankgetczpjcd));
            FillChar(pbanksetczpjcd,SizeOf(pbanksetczpjcd),0);
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetczpjcd.ProcessDate,PChar(strtmp),SizeOf(pbanksetczpjcd.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetczpjcd.Processtime,PChar(strtmp),SizeOf(pbanksetczpjcd.Processtime));
            copymemory(@pbanksetczpjcd.NetWorkID,@pbankgetczpjcd.networkid,SizeOf(pbankgetczpjcd.NetWorkID));
            copymemory(@pbanksetczpjcd.TerminalID,@pbankgetczpjcd.TerminalID,SizeOf(pbankgetczpjcd.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin
            with adosp do
            begin
              try
              close;
              errorid:=-1;
              ProcedureName:='Usp_ETCPreCardRechargeBanklog_LocalBillNORepeat';
              Parameters.Clear;
              Parameters.CreateParameter('ProcessDate',ftString,pdInput,8,string(pbankgetczpjcd.ProcessDate));
              Parameters.CreateParameter('ProcessTime',ftString,pdInput,6,string(pbankgetczpjcd.ProcessTime));
              Parameters.CreateParameter('NetWorkID',ftString,pdInput,12,string(pbankgetczpjcd.networkid));
              Parameters.CreateParameter('TerminalID',ftString,pdInput,12,string(pbankgetczpjcd.TerminalID));
              Parameters.CreateParameter('PCardNetID',ftString,pdInput,4,string(pbankgetczpjcd.PCardNetID));
              Parameters.CreateParameter('PCardID',ftString,pdInput,16,Trim(string(pbankgetczpjcd.PCardID)));
              Parameters.CreateParameter('oldInvoiceClass',ftString,pdInput,2,Trim(string(pbankgetczpjcd.oldInvoiceType)));
              Parameters.CreateParameter('oldInvoiceBatch',ftString,pdInput,4,Trim(string(pbankgetczpjcd.oldInvoiceBatch)));
              Parameters.CreateParameter('oldInvoiceID',ftString,pdInput,8,Trim(string(pbankgetczpjcd.oldInvoiceID)));
              Parameters.CreateParameter('newInvoiceClass',ftString,pdInput,2,Trim(string(pbankgetczpjcd.newInvoiceType)));
              Parameters.CreateParameter('newInvoiceBatch',ftString,pdInput,4,Trim(string(pbankgetczpjcd.newInvoiceBatch)));
              Parameters.CreateParameter('newInvoiceID',ftString,pdInput,8,Trim(string(pbankgetczpjcd.newInvoiceID)));
              strtmp:=Trim(string(pbankgetczpjcd.WasteSN));
              Parameters.CreateParameter('WasteSN',ftString,pdInput,30,strtmp);
              Parameters.CreateParameter('OperatorID',ftString,pdInput,8,Trim(string(pbankgetczpjcd.OperatorID)));
              Parameters.CreateParameter('ResponseCode',ftstring,pdoutput,4,ResponseCode);
              Parameters.CreateParameter('errorid',ftinteger,pdoutput,4,errorid);
              Parameters.CreateParameter('ErrorMsg',ftstring,pdoutput,50,ErrorMsg);

//               errorid1:=0;

                  open;
                  errorid:=parameters.ParamByName('errorid').Value;
                   ResponseCode:=parameters.ParamByName('ResponseCode').Value;
                  if errorid<0 then
                  begin
                      strtmp:='';
                      for i:=0 to Parameters.count-1 do
                      begin
                          strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                      end;
                      mainclass.writeerrorlog('exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                      ResponseCode:='34';
                      Errormsg:=parameters.ParamByName('errormsg').Value;                      
                  end;




              except on e:exception do
              begin
                  strtmp:='';
                  for i:=0 to Parameters.count-1 do
                  begin
                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                  end;
                  mainclass.writeerrorlog(e.message+'exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                 responsecode:= '09';
              end;
              end;
                if recordcount>0 then
                begin
                    if ResponseCode='00' then
                    begin
                        copymemory(@pbanksetczpjcd.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(pbanksetczpjcd.CustomerID),' ')),SizeOf(pbanksetczpjcd.CustomerID));
                        copymemory(@pbanksetczpjcd.UserName,PChar(mainclass.padr(fieldbyname('UserName').AsString,SizeOf(pbanksetczpjcd.UserName),' ')),SizeOf(pbanksetczpjcd.UserName));
                        copymemory(@pbanksetczpjcd.InvoiceID,PChar(mainclass.padr(fieldbyname('InvoiceID').AsString,SizeOf(pbanksetczpjcd.InvoiceID),' ')),SizeOf(pbanksetczpjcd.InvoiceID));
                        copymemory(@pbanksetczpjcd.AfterMoney,PChar(mainclass.padl(fieldbyname('cardAfterMoney').AsString,12,'0')),SizeOf(pbanksetczpjcd.AfterMoney));
                        copymemory(@pbanksetczpjcd.CZMoney,PChar(mainclass.padl(fieldbyname('CZMoney').AsString,12,'0')),SizeOf(pbanksetczpjcd.CZMoney));
                        copymemory(@pbanksetczpjcd.BKMoney,PChar(mainclass.padl(fieldbyname('BKMoney').AsString,12,'0')),SizeOf(pbanksetczpjcd.BKMoney));
                        copymemory(@pbanksetczpjcd.TKMoney,PChar(mainclass.padl(fieldbyname('TKMoney').AsString,12,'0')),SizeOf(pbanksetczpjcd.TKMoney));
                        copymemory(@pbanksetczpjcd.WasteSN,PChar(mainclass.padr(fieldbyname('WasteSN').AsString,SizeOf(pbanksetczpjcd.WasteSN),' ')),SizeOf(pbanksetczpjcd.WasteSN));
                        copymemory(@pbanksetczpjcd.OnlineSN,PChar(mainclass.padr(fieldbyname('OnlineSN').AsString,SizeOf(pbanksetczpjcd.OnlineSN),' ')),SizeOf(pbanksetczpjcd.OnlineSN));
                        copymemory(@pbanksetczpjcd.OfflineSN,PChar(mainclass.padr(fieldbyname('OfflineSN').AsString,SizeOf(pbanksetczpjcd.OfflineSN),' ')),SizeOf(pbanksetczpjcd.OfflineSN));
                        copymemory(@pbanksetczpjcd.Vehplate,PChar(mainclass.padr(fieldbyname('Vehplate').AsString,SizeOf(pbanksetczpjcd.Vehplate),' ')),SizeOf(pbanksetczpjcd.Vehplate));
                    end;
                end;
            end;
            end;
            copymemory(@pbanksetczpjcd.PCardNetID,@pbankgetczpjcd.PCardNetID,SizeOf(pbanksetczpjcd.PCardNetID));
            CopyMemory(@pbanksetczpjcd.PCardID,@pbankgetczpjcd.PCardID,sizeof(pbanksetczpjcd.PCardID)) ;
            CopyMemory(@pbanksetczpjcd.ResponseCode,pchar(ResponseCode),sizeof(pbanksetczpjcd.PCardID)) ;
//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetczpjcd,SizeOf(pbanksetczpjcd));
            self.sendbody(tmpbuf,'2014',SizeOf(pbanksetczpjcd));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'票据打印发送成功');
              except
                  WriteerrorLog('票据打印请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;



procedure TETCPeerThread.proc2015;
var
    strtmp:string;

    i:integer;
    mac1:array[0..3] of byte;
    strmsg:string;
    imoney:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetczhengqq,@buf,SizeOf(pbankgetczhengqq));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin
            with adosp do
            begin
              close;
              try              
              errorid:=-1;
              ProcedureName:='Usp_ETCPreCardRechargeBanklog_Local';
              Parameters.Clear;
              Parameters.CreateParameter('ProcessDate',ftString,pdInput,31,Trim(string(pbankgetczhengqq.ProcessDate)));
              Parameters.CreateParameter('ProcessTime',ftString,pdInput,20,Trim(string(pbankgetczhengqq.ProcessTime)));
              Parameters.CreateParameter('termdate',ftString,pdInput,31,Trim(string(pbankgetczhengqq.termdate)));
              Parameters.CreateParameter('termtime',ftString,pdInput,20,mainclass.padl(Trim(string(pbankgetczhengqq.termtime)),6,'0'));

              Parameters.CreateParameter('NetWorkID',ftString,pdInput,20,Trim(string(pbankgetczhengqq.networkid)));
              Parameters.CreateParameter('TerminalID',ftString,pdInput,20,Trim(string(pbankgetczhengqq.TerminalID)));
              Parameters.CreateParameter('CustomerID',ftString,pdInput,20,Trim(string(pbankgetczhengqq.CustomerID)));
              Parameters.CreateParameter('PCardNetID',ftString,pdInput,20,Trim(string(pbankgetczhengqq.PCardNetID)));
              Parameters.CreateParameter('VCBindType',ftinteger,pdInput,20,0);
              Parameters.CreateParameter('vehplate',ftString,pdInput,20,'');
              Parameters.CreateParameter('PCardID',ftString,pdInput,20,Trim(string(pbankgetczhengqq.PCardID)));
              Parameters.CreateParameter('CardBeforeMoney',ftInteger,pdInput,20,mainclass.yxsj(string(pbankgetczhengqq.BeforeMoney)));
              Parameters.CreateParameter('CZMoney',ftinteger,pdInput,20,mainclass.yxsj(string(pbankgetczhengqq.CZMoney)));
              strtmp:=copy(string(pbankgetczhengqq.BKMoney),pos('-',string(pbankgetczhengqq.BKMoney)),12);

              Parameters.CreateParameter('BKMoney',ftinteger,pdInput,20,mainclass.yxsj(strtmp));
              Parameters.CreateParameter('TKMoney',ftinteger,pdInput,20,mainclass.yxsj(string(pbankgetczhengqq.TKMoney)));//mainclass.yxsj(string(pbankgetczqq.TKMoney))
              Parameters.CreateParameter('WasteSN',ftString,pdInput,30,Trim(string(pbankgetczhengqq.WasteSN)));
              Parameters.CreateParameter('OnlineSN',ftString,pdInput,10,Trim(string(pbankgetczhengqq.OnlineSN)));
              Parameters.CreateParameter('OfflineSN ',ftString,pdInput,10,Trim(string(pbankgetczhengqq.offlineSN))); //
              Parameters.CreateParameter('Random ',ftString,pdInput,20,Trim(string(pbankgetczhengqq.Random)));
//              strtmp:='mac1';
              Parameters.CreateParameter('MAC1 ',ftString,pdInput,20,'');
              Parameters.CreateParameter('MAC2 ',ftString,pdInput,20,string('0'));
              if Amessagetype=2015 then
                  Parameters.CreateParameter('CZType',ftinteger,pdInput,4,21)
              else
                  Parameters.CreateParameter('CZType',ftinteger,pdInput,4,22);

              Parameters.CreateParameter('OperatorID',ftString,pdInput,8,Trim(string(pbankgetczhengqq.OperatorID)));
              Parameters.CreateParameter('CZWasteSn',ftString,pdInput,30,Trim(string(pbankgetczhengqq.CZWasteSn)));
              Parameters.CreateParameter('termno',ftString,pdInput,12,Trim(string(pbankgetczhengqq.termno)));
              Parameters.CreateParameter('CardSeq',ftString,pdInput,4,Trim(string(pbankgetczhengqq.CardSeq)));
              Parameters.CreateParameter('KeyIndex',ftString,pdInput,2,Trim(string(pbankgetczhengqq.KeyIndex)));
              Parameters.CreateParameter('KeyId',ftString,pdInput,2,Trim(string(pbankgetczhengqq.KeyId)));
              Parameters.CreateParameter('ResponseCode',ftString,pdoutput,4,errorid);
              Parameters.CreateParameter('Errorid',ftinteger,pdoutput,4,errorid);
              Parameters.CreateParameter('ErrorMsg',ftString,pdoutput,50,ErrorMsg);

//               errorid1:=0;
                  strtmp:='';
                  for i:=0 to Parameters.count-1 do
                  begin
                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                  end;
                  ResponseCode:='93';
                  mainclass.WriteerrorLog('2015 sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));

                     ExecProc;

                  errorid:=parameters.ParamByName('errorid').Value;


                  Errormsg:=parameters.ParamByName('errormsg').Value;
                  ResponseCode:=parameters.ParamByName('ResponseCode').Value;
                //  ResponseCode:='00';
              except on e:exception do
              begin
                  strtmp:='';
                  for i:=0 to Parameters.count-1 do
                  begin
                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                  end;
                  ResponseCode:='93';
                  mainclass.WriteerrorLog('流水号为2015：'+string(pbankgetczhengqq.WasteSN)+'的流水写入数据库失败,失败原因为'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));

              end;
              end;
             end;
            end;

            FillChar(pbanksetczhengqq,SizeOf(pbankgetczqq),0);
            if ResponseCode='00' then
             begin
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetczhengqq.ProcessDate,PChar(strtmp),SizeOf(pbanksetczhengqq.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pbanksetczhengqq.Processtime,PChar(strtmp),SizeOf(pbanksetczhengqq.Processtime));
                copymemory(@pbanksetczhengqq.NetWorkID,@pbankgetczhengqq.NetWorkID,SizeOf(pbanksetczhengqq.NetWorkID));
                copymemory(@pbanksetczhengqq.TerminalID,@pbankgetczhengqq.TerminalID,SizeOf(pbanksetczhengqq.TerminalID));

                copymemory(@pbanksetczhengqq.CustomerID,@pbanksetczquery.CustomerID,SizeOf(pbanksetczhengqq.CustomerID));

                copymemory(@pbanksetczhengqq.PCardNetID,@pbankgetczhengqq.PCardNetID,SizeOf(pbanksetczhengqq.PCardNetID));
                CopyMemory(@pbanksetczhengqq.PCardID,@pbankgetczhengqq.PCardID,sizeof(pbanksetczhengqq.PCardID)) ;            ;
                copymemory(@pbanksetczhengqq.UserName,@pbanksetczquery.UserName,SizeOf(pbanksetczhengqq.UserName));

                copymemory(@pbanksetczhengqq.wastesn,@pbankgetczhengqq.wastesn,SizeOf(pbanksetczhengqq.wastesn));
                copymemory(@pbanksetczhengqq.czwastesn,@pbankgetczhengqq.czwastesn,SizeOf(pbanksetczhengqq.czwastesn));
                copymemory(@pbanksetczhengqq.OnlineSN,@pbankgetczhengqq.OnlineSN,SizeOf(pbanksetczhengqq.OnlineSN));
                //*************************************************调用加密机的函数
                CopyMemory(@pCardLoadPara11.CardId,@pbankgetczhengqq.PCardID,sizeof(pbankgetczhengqq.PCardID));
                imoney:=strtoint(mainclass.yxsj(pbankgetczqq.SysBeforeMoney));
                CopyMemory(@pCardLoadPara11.Balance,PChar(IntToHex(imoney,8)),8);
                //充值金额
              strtmp:=copy(string(pbankgetczhengqq.BKMoney),pos('-',string(pbankgetczhengqq.BKMoney)),12);

                imoney:=strtoint(mainclass.yxsj((pbankgetczhengqq.czmoney)))+strtoint(mainclass.yxsj(strtmp))+strtoint(mainclass.yxsj((pbankgetczhengqq.TKMoney)));

                CopyMemory(@pCardLoadPara11.Cash,PChar(IntToHex(imoney,8)),8);
                CopyMemory(@pCardLoadPara11.TransNumber,@pbankgetczhengqq.CardSeq,4);
                CopyMemory(@pCardLoadPara11.Rand,@pbankgetczhengqq.Random,8);
                CopyMemory(@pCardLoadPara11.KeyVersion,@pbankgetczhengqq.KeyIndex,2);
                CopyMemory(@pCardLoadPara11.KeyAlgorithm,@pbankgetczhengqq.KeyID,2);
                CopyMemory(@pCardLoadPara11.TerminalChargeSerial,@pbankgetczhengqq.OnlineSN,4);
                CopyMemory(@pCardLoadPara11.TerminalNo,@pbankgetczhengqq.TermNo,12);
                CopyMemory(@pCardLoadPara11.CashDate,@pbankgetczhengqq.TermDate,sizeof(pCardLoadPara11.CashDate));
                CopyMemory(@pCardLoadPara11.CashTime,@pbankgetczhengqq.TermTime,SizeOf(pCardLoadPara11.CashTime));
                CalPurMAC1(pcardloadpara11,mainclass.SJMJSERVERIP,mainclass.SJMJPORT,mac1,strmsg);
                strtmp:=mainclass.BytestoHexString(mac1,SizeOf(mac1));
                copymemory(@pbanksetczhengqq.MAC1,PChar(strtmp),SizeOf(pbanksetczhengqq.MAC1));
                //********************************************************************************
             end;
            copymemory(@pbanksetczhengqq.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetczhengqq.ResponseCode));

//***********************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetczhengqq,SizeOf(pbanksetczhengqq));
    if amessagetype=2015 then
        self.sendbody(tmpbuf,'2016',SizeOf(pbanksetczhengqq))
    else
        self.sendbody(tmpbuf,'2020',SizeOf(pbanksetczhengqq));



            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'冲正请求发送成功');
              except
                  WriteerrorLog('冲正请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2017;
var
    strtmp:string;

    i:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetczHENGcg,@buf,SizeOf(pbankgetczHENGcg));
            if mainclass.bdatabaseconnect then
            begin
            with adosp do
            begin
                try
              close;
              errorid:=-1;
              ProcedureName:='Usp_ETCPreCardRechargeBanklog_Localreply';
              Parameters.Clear;
              Parameters.CreateParameter('ProcessDate',ftString,pdInput,8,Trim(string(pbankgetczHENGcg.ProcessDate)));
              Parameters.CreateParameter('ProcessTime',ftstring,pdInput,6,trim(string(pbankgetczHENGcg.ProcessTime)));
              Parameters.CreateParameter('NetWorkID',ftString,pdInput,20,Trim(string(pbankgetczHENGcg.networkid)));
              Parameters.CreateParameter('TerminalID',ftString,pdInput,20,Trim(string(pbankgetczHENGcg.TerminalID)));
              Parameters.CreateParameter('PCardNetID',ftString,pdInput,20,Trim(string(pbankgetczHENGcg.PCardNetID)));
              Parameters.CreateParameter('PCardID',ftString,pdInput,20,Trim(string(pbankgetczHENGcg.PCardID)));
              Parameters.CreateParameter('@InvoiceClass',ftString,pdInput,2,string('0'));
              Parameters.CreateParameter('@InvoiceBatch',ftString,pdInput,4,string('0'));
              Parameters.CreateParameter('@InvoiceID',ftString,pdInput,8,string('1'));
              Parameters.CreateParameter('AfterMoney',ftinteger,pdInput,9,mainclass.yxsj(string(pbankgetczHENGcg.AfterMoney)));
              Parameters.CreateParameter('CZMoney',ftinteger,pdInput,4,mainclass.yxsj(string(pbankgetczHENGcg.CZMoney)));

              Parameters.CreateParameter('BKMoney',ftinteger,pdInput,4,mainclass.yxsj(string('0')));
              Parameters.CreateParameter('TKMoney',ftinteger,pdInput,4,mainclass.yxsj(string('0')));//mainclass.yxsj(string(pbankgetczqq.TKMoney))
              Parameters.CreateParameter('WasteSN',ftString,pdInput,30,Trim(string(pbankgetczHENGcg.WasteSN)));

              Parameters.CreateParameter('OnlineSN',ftString,pdInput,10,Trim(string(pbankgetczHENGcg.OnlineSN)));
              Parameters.CreateParameter('OfflineSN ',ftString,pdInput,10,Trim(string(pbankgetczHENGcg.OfflineSN)));
              Parameters.CreateParameter('writecardFlag',ftinteger,pdInput,1,mainclass.yxsj(string(pbankgetczHENGcg.WriteCardFlag)));
              Parameters.CreateParameter('MAC2',ftString,pdInput,10,Trim(string(pbankgetczHENGcg.MAC2)));
              Parameters.CreateParameter('TAC ',ftString,pdInput,10,Trim(string(pbankgetczHENGcg.TAC)));
              Parameters.CreateParameter('ResponseCode',ftstring,pdInputOutput,2,'00');
              Parameters.CreateParameter('Errorid',ftinteger,pdInputOutput,4,-2);
              Parameters.CreateParameter('ErrorMsg',ftString,pdoutput,50,ErrorMsg);

//               errorid1:=0;
                  ExecProc;

                  errorid:=parameters.ParamByName('errorid').Value;
                  ResponseCode:=parameters.ParamByName('ResponseCode').Value;
              if errorid<0 then
                  Errormsg:=parameters.ParamByName('errormsg').Value;
                  if responsecode<>'00' then
                  begin
                      writelog('流水号为：'+string(pbankgetczHENGcg.WasteSN)+'的充值不正确'+mainclass.errorname(responsecode)+'金额为:'+pbankgetczcg.AfterMoney+'分');
                  end


              except on e:exception do
              begin
                  strtmp:='';
                  for i:=0 to Parameters.count-1 do
                  begin
                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                  end;
                  WriteerrorLog('流水号为：'+string(pbankgetczHENGcg.WasteSN)+'的流水写入数据库失败,失败原因为'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                  ResponseCode:='93';
              end;
              end;
             end;
            end;

            FillChar(pbanksetczHENGcg,SizeOf(pbanksetczHENGcg),0);
            if ResponseCode='00' then
            begin
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetczHENGcg.ProcessDate,pchar(strtmp),SizeOf(pbanksetczHENGcg.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pbanksetczHENGcg.Processtime,pchar(strtmp),SizeOf(pbanksetczHENGcg.Processtime));
                copymemory(@pbanksetczHENGcg.NetWorkID,@pbankgetczHENGcg.NetWorkID,SizeOf(pbanksetczHENGcg.NetWorkID));
                copymemory(@pbanksetczHENGcg.TerminalID,@pbankgetczHENGcg.TerminalID,SizeOf(pbanksetczHENGcg.TerminalID));
                copymemory(@pbanksetczHENGcg.wastesn,@pbankgetczHENGcg.wastesn,SizeOf(pbanksetczHENGcg.wastesn));
                copymemory(@pbanksetczHENGcg.PCardNetID,@pbankgetczHENGcg.PCardNetID,SizeOf(pbanksetczHENGcg.PCardNetID));
                copymemory(@pbanksetczHENGcg.PCardID,@pbankgetczHENGcg.PCardID,sizeof(pbanksetczHENGcg.PCardID)) ;
            end;

            copymemory(@pbanksetczHENGcg.ResponseCode,pchar(ResponseCode),SizeOf(pbanksetczHENGcg.ResponseCode));

//**********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetczHENGcg,SizeOf(pbanksetczHENGcg));
            self.sendbody(tmpbuf,'2018',SizeOf(pbanksetczHENGcg));
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'冲正确认发送成功'+pbanksetczHENGcg.PCardID);
              except
                  WriteerrorLog('冲正成功发送失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;


procedure TETCPeerThread.proc2021;
var
    strtmp:string;
    oper:string;
    i:integer;
    customerid_temp:string;

begin
//**********************************************处理报文**************************************************
            CopyMemory(@pcustomerinfoRequest,@buf,SizeOf(pcustomerinfoRequest));
            FillChar(pcustomerinfoResponse,SizeOf(pcustomerinfoResponse),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pcustomerinfoResponse.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pcustomerinfoResponse.ProcessDate),'0')),SizeOf(pcustomerinfoResponse.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pcustomerinfoResponse.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pcustomerinfoResponse.Processtime),'0')),SizeOf(pcustomerinfoResponse.Processtime));
            copymemory(@pcustomerinfoResponse.NetWorkID,@pcustomerinfoRequest.NetWorkID,SizeOf(pcustomerinfoResponse.NetWorkID));
            copymemory(@pcustomerinfoResponse.TerminalID,@pcustomerinfoRequest.TerminalID,SizeOf(pcustomerinfoResponse.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin

                with adosp do
                begin
                    close;
                  errorid:=-1;

                  ProcedureName:='base_customerinfo';

                  Parameters.Clear;
                  Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,string(pcustomerinfoRequest.ProcessDate));
                  Parameters.CreateParameter('@ProcessTime',ftstring,pdInput,6,string(pcustomerinfoRequest.ProcessTime));
                  Parameters.CreateParameter('@NetWorkID',ftstring,pdInput,7,Trim(string(pcustomerinfoRequest.networkid)));
                  Parameters.CreateParameter('@TerminalID',ftstring,pdInput,10,Trim(string(pcustomerinfoRequest.TerminalID)));
                  Parameters.CreateParameter('@CustomerID',ftString,pdInput,20,Trim(string(pcustomerinfoRequest.CustomerID)));
                  Parameters.CreateParameter('@FullName',ftString,pdInput,100,Trim(string(pcustomerinfoRequest.userName)));
                  Parameters.CreateParameter('@CustomerType',ftString,pdInput,4,Trim(string(pcustomerinfoRequest.userType)));
                  Parameters.CreateParameter('@Address',ftString,pdInput,200,Trim(string(pcustomerinfoRequest.address)));
                  Parameters.CreateParameter('@MobileNo',ftString,pdInput,15,Trim(string(pcustomerinfoRequest.tel)));
                  Parameters.CreateParameter('@Certificate',ftString,pdInput,30,Trim(string(pcustomerinfoRequest.userIdNum)));
                  Parameters.CreateParameter('@CertificateType',ftString,pdInput,4,Trim(string(pcustomerinfoRequest.userIdType)));
                  Parameters.CreateParameter('@LinkMan',ftString,pdInput,10,Trim(string(pcustomerinfoRequest.agentName)));
                  Parameters.CreateParameter('@linkNameCertificateType',ftString,pdInput,4,Trim(string(pcustomerinfoRequest.agentIdType)));
                  Parameters.CreateParameter('@linkNameCertificate',ftString,pdInput,30,Trim(string(pcustomerinfoRequest.agentIdNum)));
                  Parameters.CreateParameter('@department',ftString,pdInput,20,Trim(string(pcustomerinfoRequest.department)));
                  Parameters.CreateParameter('@password',ftString,pdInput,20,Trim(string(pcustomerinfoRequest.password)));
                  Parameters.CreateParameter('@OperatorNo',ftString,pdInput,8,Trim(string(pcustomerinfoRequest.OperatorID)));
                  Parameters.CreateParameter('@operation',ftString,pdInput,4,Trim(string(pcustomerinfoRequest.operation)));
                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);
                  Parameters.CreateParameter('@customerid_temp',ftstring,pdoutput,20,customerid_temp);
                  Parameters.CreateParameter('@errorid',ftinteger,pdoutput,4,errorid);
                  Parameters.CreateParameter('@ErrorMsg',ftstring,pdoutput,50,ErrorMsg);
                  try

                          oper:=parameters.ParamByName('@operation').Value;
                          if oper = '3' then
                          begin
                            open;
                            errorid:=parameters.ParamByName('@errorid').Value;
                            if errorid<0 then
                            Errormsg:=parameters.ParamByName('@errormsg').Value+'客户ID：'+pcustomerinfoRequest.CustomerID;
                            if adosp.RecordCount=0 then
                            begin
                                ResponseCode:='55'; //此用户号不存在
                                mainclass.WriteerrorLog('此用户号不存在'+pcustomerinfoRequest.CustomerID+'网络编号');
                            end;
                            if ResponseCode='00' then
                              begin

                                  copymemory(@pcustomerinfoResponse.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(pcustomerinfoResponse.CustomerID),' ')),SizeOf(pcustomerinfoResponse.CustomerID));
                                  copymemory(@pcustomerinfoResponse.userName,PChar(mainclass.padl(fieldbyname('FullName').AsString,SizeOf(pcustomerinfoResponse.userName),' ')),SizeOf(pcustomerinfoResponse.userName));
                                  copymemory(@pcustomerinfoResponse.userType,PChar(mainclass.padr(fieldbyname('CustomerType').AsString,SizeOf(pcustomerinfoResponse.userType),' ')),SizeOf(pcustomerinfoResponse.userType));
                                  copymemory(@pcustomerinfoResponse.address,PChar(mainclass.padl(fieldbyname('Address').AsString,SizeOf(pcustomerinfoResponse.address),' ')),SizeOf(pcustomerinfoResponse.address));
                                  copymemory(@pcustomerinfoResponse.tel,PChar(mainclass.padr(fieldbyname('MobileNo').AsString,SizeOf(pcustomerinfoResponse.tel),' ')),SizeOf(pcustomerinfoResponse.tel));
                                  copymemory(@pcustomerinfoResponse.userIdType,PChar(mainclass.padr(fieldbyname('CertificateType').AsString,SizeOf(pcustomerinfoResponse.userIdType),' ')),SizeOf(pcustomerinfoResponse.userIdType));
                                  copymemory(@pcustomerinfoResponse.userIdNum,PChar(mainclass.padl(fieldbyname('Certificate').AsString,SizeOf(pcustomerinfoResponse.userIdNum),' ')),SizeOf(pcustomerinfoResponse.userIdNum));


                                  copymemory(@pcustomerinfoResponse.agentName,PChar(mainclass.padr(fieldbyname('LinkMan').AsString,SizeOf(pcustomerinfoResponse.agentName),' ')),SizeOf(pcustomerinfoResponse.agentName));
                                  copymemory(@pcustomerinfoResponse.agentIdType,PChar(mainclass.padr(fieldbyname('linkNameCertificateType').AsString,SizeOf(pcustomerinfoResponse.agentIdType),' ')),SizeOf(pcustomerinfoResponse.agentIdType));

                                  copymemory(@pcustomerinfoResponse.agentIdNum,PChar(mainclass.padl(fieldbyname('linkNameCertificate').AsString,SizeOf(pcustomerinfoResponse.agentIdNum),' ')),SizeOf(pcustomerinfoResponse.agentIdNum));
                                  copymemory(@pcustomerinfoResponse.department,PChar(mainclass.padl(fieldbyname('department').AsString,SizeOf(pcustomerinfoResponse.department),' ')),SizeOf(pcustomerinfoResponse.department));
                                  copymemory(@pcustomerinfoResponse.OperatorID,PChar(mainclass.padl(fieldbyname('OperatorNo').AsString,SizeOf(pcustomerinfoResponse.OperatorID),' ')),SizeOf(pcustomerinfoResponse.OperatorID));
                              end;
                          end
                          else
                           begin
                             ExecProc;
                             ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                             customerid_temp:=parameters.ParamByName('@customerid_temp').Value;
                             copymemory(@pcustomerinfoResponse.customerid,PChar(mainclass.padr(customerid_temp,SizeOf(pcustomerinfoResponse.CustomerID),' ')),SizeOf(pcustomerinfoResponse.customerid));
                           end;



                  except on e:exception do
                      begin

                          mainclass.writeerrorlog('客户信息2021查询失败原因:'+e.message);
                          strtmp:='';
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog(' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                          ResponseCode:='10';  //查询错误
                      end;
                  end;


                end;
        end;

            copymemory(@pcustomerinfoResponse.ResponseCode,PChar(ResponseCode),SizeOf(pcustomerinfoResponse.ResponseCode));


//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pcustomerinfoResponse,SizeOf(pcustomerinfoResponse));
            self.sendbody(tmpbuf,'2022',SizeOf(pcustomerinfoResponse));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
//                  writelog('来自'+ppackheadReceiver.SenderID+'客户ID:'+pbanksetczquery.PCardID+'查询发送成功');
              except
                  WriteerrorLog('客户ID查询失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2023;
var
    strtmp:string;
    oper:string;
    i:integer;

begin
//**********************************************处理报文**************************************************
            CopyMemory(@pvehicleRequest,@buf,SizeOf(pvehicleRequest));
            FillChar(pvehicleResponse,SizeOf(pvehicleResponse),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pvehicleResponse.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pvehicleResponse.ProcessDate),'0')),SizeOf(pvehicleResponse.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pvehicleResponse.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pvehicleResponse.Processtime),'0')),SizeOf(pvehicleResponse.Processtime));
            copymemory(@pvehicleResponse.NetWorkID,@pvehicleRequest.NetWorkID,SizeOf(pvehicleResponse.NetWorkID));
            copymemory(@pvehicleResponse.TerminalID,@pvehicleRequest.TerminalID,SizeOf(pvehicleResponse.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin

                with adosp do
                begin
                    close;
                  errorid:=-1;

                    ProcedureName:='base_vehplate_truck';

                  Parameters.Clear;
                  Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,string(pvehicleRequest.ProcessDate));
                  Parameters.CreateParameter('@ProcessTime',ftstring,pdInput,6,string(pvehicleRequest.ProcessTime));
                  Parameters.CreateParameter('@NetWorkID',ftstring,pdInput,7,Trim(string(pvehicleRequest.networkid)));
                  Parameters.CreateParameter('@TerminalID',ftstring,pdInput,10,Trim(string(pvehicleRequest.TerminalID)));
                  Parameters.CreateParameter('@CustomerID',ftString,pdInput,20,Trim(string(pvehicleRequest.CustomerID)));
                  Parameters.CreateParameter('@VehiclePlateNo',ftString,pdInput,10,Trim(string(pvehicleRequest.VehiclePlateNo)));
                  Parameters.CreateParameter('@VehTypeNo',ftString,pdInput,4,Trim(string(pvehicleRequest.VehTypeNo)));
                  Parameters.CreateParameter('@VehplateColor',ftString,pdInput,10,Trim(string(pvehicleRequest.VehplateColor)));
                  Parameters.CreateParameter('@VehplateColorno',ftString,pdInput,2,Trim(string(pvehicleRequest.VehplateColorno)));
                  Parameters.CreateParameter('@VehEngineNo',ftString,pdInput,50,Trim(string(pvehicleRequest.VehEngineNo)));
                  Parameters.CreateParameter('@vehaxlelen',ftString,pdInput,4,Trim(string(pvehicleRequest.approvedCount)));
                  Parameters.CreateParameter('@carload',ftString,pdInput,4,Trim(string(pvehicleRequest.totalMass)));
                  Parameters.CreateParameter('@CarINfo',ftString,pdInput,50,Trim(string(pvehicleRequest.CarINfo)));
                  Parameters.CreateParameter('@VehColor',ftString,pdInput,10,Trim(string(pvehicleRequest.VehColor)));
                  Parameters.CreateParameter('@VIN',ftString,pdInput,50,Trim(string(pvehicleRequest.VIN)));
                  Parameters.CreateParameter('@contact',ftString,pdInput,10,Trim(string(pvehicleRequest.contact)));
                  Parameters.CreateParameter('@useCharacter',ftString,pdInput,4,Trim(string(pvehicleRequest.useCharacter)));
                  Parameters.CreateParameter('@OperatorNo',ftString,pdInput,8,Trim(string(pvehicleRequest.OperatorID)));
                  Parameters.CreateParameter('@operation',ftString,pdInput,4,Trim(string(pvehicleRequest.operation)));
                  Parameters.CreateParameter('@vehlicenseIssueDate',ftString,pdInput,10,Trim(string(pvehicleRequest.vehlicenseIssueDate)));
                  Parameters.CreateParameter('@vehlicenseRegisterDate',ftString,pdInput,10,Trim(string(pvehicleRequest.vehlicenseRegisterDate)));
                  Parameters.CreateParameter('@vehWheel',ftString,pdInput,4,Trim(string(pvehicleRequest.vehWheel)));
                  Parameters.CreateParameter('@vehAxle',ftString,pdInput,4,Trim(string(pvehicleRequest.vehAxle)));
                  Parameters.CreateParameter('@vehLength',ftString,pdInput,4,Trim(string(pvehicleRequest.vehLength)));
                  Parameters.CreateParameter('@vehWidth',ftString,pdInput,4,Trim(string(pvehicleRequest.vehWidth)));
                  Parameters.CreateParameter('@vehHeight',ftString,pdInput,4,Trim(string(pvehicleRequest.vehHeight)));
                  Parameters.CreateParameter('@vehLicenseName',ftString,pdInput,100,Trim(string(pvehicleRequest.vehLicenseName)));
                  Parameters.CreateParameter('@maintenanceMass',ftString,pdInput,4,Trim(string(pvehicleRequest.maintenanceMass)));
                  Parameters.CreateParameter('@UpdCarload',ftString,pdInput,4,Trim(string(pvehicleRequest.UpdCarload)));
                  Parameters.CreateParameter('@vehicleType',ftString,pdInput,20,Trim(string(pvehicleRequest.vehicleType)));
                  Parameters.CreateParameter('@SPG_Container',ftString,pdInput,4,Trim(string(pvehicleRequest.SPG_Container)));
                  Parameters.CreateParameter('@remark',ftString,pdInput,50,Trim(string(pvehicleRequest.remark)));
                  Parameters.CreateParameter('@orderid',ftString,pdInput,50,'');
                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);
                  Parameters.CreateParameter('@errorid',ftinteger,pdoutput,4,errorid);
                  Parameters.CreateParameter('@ErrorMsg',ftstring,pdoutput,50,ErrorMsg);
                  try

                          oper:=parameters.ParamByName('@operation').Value;
                          if oper = '3' then
                          begin
                            open;
                            errorid:=parameters.ParamByName('@errorid').Value;
                            if errorid<0 then
                            Errormsg:=parameters.ParamByName('@errormsg').Value+'客户ID：'+pvehicleRequest.CustomerID;
                            if RecordCount=0 then
                            begin
                                ResponseCode:='18'; //此车牌号不存在
                                mainclass.WriteerrorLog('此车牌号不存在'+pvehicleRequest.VehiclePlateNo);
                            end;
                            if ResponseCode='00' then
                              begin

                                  copymemory(@pvehicleResponse.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(pvehicleResponse.CustomerID),' ')),SizeOf(pvehicleResponse.CustomerID));
                                  copymemory(@pvehicleResponse.VehiclePlateNo,PChar(mainclass.padr(fieldbyname('VehiclePlateNo').AsString,SizeOf(pvehicleResponse.VehiclePlateNo),' ')),SizeOf(pvehicleResponse.VehiclePlateNo));
                                  copymemory(@pvehicleResponse.VehTypeNo,PChar(mainclass.padl(fieldbyname('VehTypeNo').AsString,SizeOf(pvehicleResponse.VehTypeNo),' ')),SizeOf(pvehicleResponse.VehTypeNo));
                                  copymemory(@pvehicleResponse.VehplateColor,PChar(mainclass.padr(fieldbyname('VehplateColor').AsString,SizeOf(pvehicleResponse.VehplateColor),' ')),SizeOf(pvehicleResponse.VehplateColor));

                                  copymemory(@pvehicleResponse.VehEngineNo,PChar(mainclass.padr(fieldbyname('VehEngineNo').AsString,SizeOf(pvehicleResponse.VehEngineNo),' ')),SizeOf(pvehicleResponse.VehEngineNo));
                                  copymemory(@pvehicleResponse.approvedCount,PChar(mainclass.padr(fieldbyname('vehaxlelen').AsString,SizeOf(pvehicleResponse.approvedCount),' ')),SizeOf(pvehicleResponse.approvedCount));
                                  copymemory(@pvehicleResponse.totalMass,PChar(mainclass.padl(fieldbyname('carload').AsString,SizeOf(pvehicleResponse.totalMass),' ')),SizeOf(pvehicleResponse.totalMass));


                                  copymemory(@pvehicleResponse.CarINfo,PChar(mainclass.padr(fieldbyname('CarINfo').AsString,SizeOf(pvehicleResponse.CarINfo),' ')),SizeOf(pvehicleResponse.CarINfo));
                                  copymemory(@pvehicleResponse.VehColor,PChar(mainclass.padr(fieldbyname('VehColor').AsString,SizeOf(pvehicleResponse.VehColor),' ')),SizeOf(pvehicleResponse.VehColor));

                                  copymemory(@pvehicleResponse.VIN,PChar(mainclass.padl(fieldbyname('VIN').AsString,SizeOf(pvehicleResponse.VIN),' ')),SizeOf(pvehicleResponse.VIN));
                                  copymemory(@pvehicleResponse.contact,PChar(mainclass.padl(fieldbyname('contact').AsString,SizeOf(pvehicleResponse.contact),' ')),SizeOf(pvehicleResponse.contact));
                                  copymemory(@pvehicleResponse.useCharacter,PChar(mainclass.padl(fieldbyname('useCharacter').AsString,SizeOf(pvehicleResponse.useCharacter),' ')),SizeOf(pvehicleResponse.useCharacter));
                                  copymemory(@pvehicleResponse.OperatorID,PChar(mainclass.padl(fieldbyname('OperatorNo').AsString,SizeOf(pvehicleResponse.OperatorID),' ')),SizeOf(pvehicleResponse.OperatorID));
                              end;
                          end
                          else
                          begin
                            ExecProc;
                            ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                          end;

                  except on e:exception do
                      begin

                          mainclass.writeerrorlog('车辆信息2023查询失败原因:'+e.message);
                           strtmp:='';
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog(' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                          ResponseCode:='10';  //查询错误
                      end;
                  end;


                end;
        end;

            copymemory(@pvehicleResponse.ResponseCode,PChar(ResponseCode),SizeOf(pvehicleResponse.ResponseCode));
//            copymemory(@pvehicleResponse.VehiclePlateNo,@pvehicleRequest.VehiclePlateNo,SizeOf(pvehicleResponse.VehiclePlateNo));

//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pvehicleResponse,SizeOf(pvehicleResponse));
            self.sendbody(tmpbuf,'2024',SizeOf(pvehicleResponse));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
//                  writelog('来自'+ppackheadReceiver.SenderID+'客户ID:'+pbanksetczquery.PCardID+'查询发送成功');
              except
                  WriteerrorLog('车辆信息操作失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2025;
var
    strtmp:string;
    oper:string;
    i:integer;
    obuno:string;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pobuRequest,@buf,SizeOf(pobuRequest));
            FillChar(pobuResponse,SizeOf(pobuResponse),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pobuResponse.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pobuResponse.ProcessDate),'0')),SizeOf(pobuResponse.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pobuResponse.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pobuResponse.Processtime),'0')),SizeOf(pobuResponse.Processtime));
            copymemory(@pobuResponse.NetWorkID,@pobuRequest.NetWorkID,SizeOf(pobuResponse.NetWorkID));
            copymemory(@pobuResponse.TerminalID,@pobuRequest.TerminalID,SizeOf(pobuResponse.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin

                with adosp do
                begin
                    close;
                  errorid:=-1;

                    ProcedureName:='base_OBUinfo';

                  Parameters.Clear;
                  Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,string(pobuRequest.ProcessDate));
                  Parameters.CreateParameter('@ProcessTime',ftstring,pdInput,6,string(pobuRequest.ProcessTime));
                  Parameters.CreateParameter('@NetWorkID',ftstring,pdInput,7,Trim(string(pobuRequest.networkid)));
                  Parameters.CreateParameter('@TerminalID',ftstring,pdInput,10,Trim(string(pobuRequest.TerminalID)));
                  Parameters.CreateParameter('@CustomerID',ftString,pdInput,20,Trim(string(pobuRequest.CustomerID)));
                  Parameters.CreateParameter('@VehiclePlateNo',ftString,pdInput,10,Trim(string(pobuRequest.VehiclePlateNo)));
                  Parameters.CreateParameter('@OBUNO',ftString,pdInput,20,Trim(string(pobuRequest.OBUNo)));
                  Parameters.CreateParameter('@OBUFactoryID',ftString,pdInput,2,Trim(string(pobuRequest.OBUFactoryID)));
                  Parameters.CreateParameter('@OBUTollType',ftString,pdInput,4,Trim(string(pobuRequest.OBUTollType)));
                  Parameters.CreateParameter('@OBUPrice',ftString,pdInput,4,Trim(string(pobuRequest.OBUPrice)));
                  Parameters.CreateParameter('@StartUseTime',ftString,pdInput,20,Trim(string(pobuRequest.StartUseTime)));
                  Parameters.CreateParameter('@InvalidTime',ftString,pdInput,20,Trim(string(pobuRequest.InvalidTime)));
                  Parameters.CreateParameter('@fileVersion',ftString,pdInput,10,Trim(string(pobuRequest.fileVersion)));
                  Parameters.CreateParameter('@OperatorNo',ftString,pdInput,8,Trim(string(pobuRequest.OperatorID)));
                  Parameters.CreateParameter('@operation',ftString,pdInput,4,Trim(string(pobuRequest.operation)));
                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);
                  Parameters.CreateParameter('@errorid',ftinteger,pdoutput,4,errorid);
                  Parameters.CreateParameter('@ErrorMsg',ftstring,pdoutput,50,ErrorMsg);
                  try

                          oper:=parameters.ParamByName('@operation').Value;
                          if oper = '3' then
                          begin
                            open;
                            errorid:=parameters.ParamByName('@errorid').Value;
                            if errorid<0 then
                            Errormsg:=parameters.ParamByName('@errormsg').Value+'客户ID：'+pobuRequest.CustomerID;
                            if RecordCount=0 then
                            begin
                                ResponseCode:='06'; //此OBU不存在
                                mainclass.WriteerrorLog('此OBU号不存在'+pobuRequest.VehiclePlateNo);
                            end;
                            if ResponseCode='00' then
                              begin

                                  copymemory(@pobuResponse.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(pobuResponse.CustomerID),' ')),SizeOf(pobuResponse.CustomerID));
                                  copymemory(@pobuResponse.VehiclePlateNo,PChar(mainclass.padr(fieldbyname('VehiclePlateNo').AsString,SizeOf(pobuResponse.VehiclePlateNo),' ')),SizeOf(pobuResponse.VehiclePlateNo));
                                  copymemory(@pobuResponse.OBUNO,PChar(mainclass.padl(fieldbyname('OBUNO').AsString,SizeOf(pobuResponse.OBUNO),' ')),SizeOf(pobuResponse.OBUNO));
                                  copymemory(@pobuResponse.OBUState,PChar(mainclass.padr(fieldbyname('OBUState').AsString,SizeOf(pobuResponse.OBUState),' ')),SizeOf(pobuResponse.OBUState));
                                  copymemory(@pobuResponse.StartUseTime,PChar(mainclass.padl(fieldbyname('StartUseTime').AsString,SizeOf(pobuResponse.StartUseTime),' ')),SizeOf(pobuResponse.StartUseTime));
                                  copymemory(@pobuResponse.InvalidTime,PChar(mainclass.padr(fieldbyname('InvalidTime').AsString,SizeOf(pobuResponse.InvalidTime),' ')),SizeOf(pobuResponse.InvalidTime));
                                  copymemory(@pobuResponse.OperatorID,PChar(mainclass.padl(fieldbyname('OperatorNo').AsString,SizeOf(pobuResponse.OperatorID),' ')),SizeOf(pobuResponse.OperatorID));
                              end;
                          end
                          else
                          begin
                            ExecProc;
                            ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                            obuno:=parameters.ParamByName('@ErrorMsg').Value;
                            copymemory(@pobuResponse.obuno,PChar(mainclass.padl(obuno,SizeOf(pobuResponse.OBUNO),' ')),SizeOf(pobuResponse.OBUNO));
                          end;



                  except on e:exception do
                      begin

                          mainclass.writeerrorlog('OBU信息2025查询失败原因:'+e.message);
                           strtmp:='';
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog(' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                          ResponseCode:='10';  //查询错误
                      end;
                  end;


                end;

        end;

            copymemory(@pobuResponse.ResponseCode,PChar(ResponseCode),SizeOf(pobuResponse.ResponseCode));


//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pobuResponse,SizeOf(pobuResponse));
            self.sendbody(tmpbuf,'2026',SizeOf(pobuResponse));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
//                  writelog('来自'+ppackheadReceiver.SenderID+'客户ID:'+pbanksetczquery.PCardID+'查询发送成功');
              except
                  WriteerrorLog('车辆信息操作失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2027;
var
    strtmp:string;
    oper:string;
    i:integer;

begin
//**********************************************处理报文**************************************************
            CopyMemory(@pprecardRequest,@buf,SizeOf(pprecardRequest));
            FillChar(pprecardResponse,SizeOf(pprecardResponse),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pprecardResponse.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pprecardResponse.ProcessDate),'0')),SizeOf(pprecardResponse.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pprecardResponse.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pprecardResponse.Processtime),'0')),SizeOf(pprecardResponse.Processtime));
            copymemory(@pprecardResponse.NetWorkID,@pprecardRequest.NetWorkID,SizeOf(pprecardResponse.NetWorkID));
            copymemory(@pprecardResponse.TerminalID,@pprecardRequest.TerminalID,SizeOf(pprecardResponse.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin

                with adosp do
                begin
                    close;
                  errorid:=-1;

                    ProcedureName:='base_Prepaycardinfo';

                  Parameters.Clear;
                  Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,string(pprecardRequest.ProcessDate));
                  Parameters.CreateParameter('@ProcessTime',ftstring,pdInput,6,string(pprecardRequest.ProcessTime));
                  Parameters.CreateParameter('@NetWorkID',ftstring,pdInput,7,Trim(string(pprecardRequest.networkid)));
                  Parameters.CreateParameter('@TerminalID',ftstring,pdInput,10,Trim(string(pprecardRequest.TerminalID)));
                  Parameters.CreateParameter('@CustomerID',ftString,pdInput,20,Trim(string(pprecardRequest.CustomerID)));
                  Parameters.CreateParameter('@VehiclePlateNo',ftString,pdInput,10,Trim(string(pprecardRequest.VehiclePlateNo)));
                  Parameters.CreateParameter('@CardID',ftString,pdInput,20,Trim(string(pprecardRequest.CardID)));
                  Parameters.CreateParameter('@StartDate',ftString,pdInput,20,Trim(string(pprecardRequest.StartUseTime)));
                  Parameters.CreateParameter('@EndDate',ftString,pdInput,20,Trim(string(pprecardRequest.InvalidTime)));
                  Parameters.CreateParameter('@fileVersion',ftString,pdInput,10,Trim(string(pprecardRequest.fileVersion)));
                  Parameters.CreateParameter('@OperatorNo',ftString,pdInput,8,Trim(string(pprecardRequest.OperatorID)));
                  Parameters.CreateParameter('@operation',ftString,pdInput,4,Trim(string(pprecardRequest.operation)));
                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);
                  Parameters.CreateParameter('@errorid',ftinteger,pdoutput,4,errorid);
                  Parameters.CreateParameter('@ErrorMsg',ftstring,pdoutput,50,ErrorMsg);
                  try
                         strtmp:='';
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
//                          mainclass.writeerrorlog(' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                          oper:=parameters.ParamByName('@operation').Value;
                          if oper = '3' then
                          begin
                            open;
                            errorid:=parameters.ParamByName('@errorid').Value;
                            if errorid<0 then
                            Errormsg:=parameters.ParamByName('@errormsg').Value+'客户ID：'+pprecardRequest.CustomerID;
                            if RecordCount=0 then
                            begin
                                ResponseCode:='86'; //此卡片信息不存在
                                mainclass.WriteerrorLog('此卡片信息不存在'+pprecardRequest.VehiclePlateNo);
                            end;
                            if ResponseCode='00' then
                              begin

                                  copymemory(@pprecardResponse.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(pprecardResponse.CustomerID),' ')),SizeOf(pprecardResponse.CustomerID));
                                  copymemory(@pprecardResponse.VehiclePlateNo,PChar(mainclass.padr(fieldbyname('VehiclePlateNo').AsString,SizeOf(pprecardResponse.VehiclePlateNo),' ')),SizeOf(pprecardResponse.VehiclePlateNo));
                                  copymemory(@pprecardResponse.CardID,PChar(mainclass.padl(fieldbyname('CardID').AsString,SizeOf(pprecardResponse.CardID),' ')),SizeOf(pprecardResponse.CardID));
                                  copymemory(@pprecardResponse.CardState,PChar(mainclass.padl(fieldbyname('CardState').AsString,SizeOf(pprecardResponse.CardState),' ')),SizeOf(pprecardResponse.CardState));
                                  copymemory(@pprecardResponse.IssueTime,PChar(mainclass.padr(fieldbyname('IssueTime').AsString,SizeOf(pprecardResponse.IssueTime),' ')),SizeOf(pprecardResponse.IssueTime));
                                  copymemory(@pprecardResponse.InvalidTime,PChar(mainclass.padr(fieldbyname('invalidate').AsString,SizeOf(pprecardResponse.InvalidTime),' ')),SizeOf(pprecardResponse.InvalidTime));
                                  copymemory(@pprecardResponse.networkID,PChar(mainclass.padr(fieldbyname('NetworkNo').AsString,SizeOf(pprecardResponse.networkID),' ')),SizeOf(pprecardResponse.networkID));
                                  copymemory(@pprecardResponse.OperatorID,PChar(mainclass.padl(fieldbyname('CardOperatorNO').AsString,SizeOf(pprecardResponse.OperatorID),' ')),SizeOf(pprecardResponse.OperatorID));
                              end;
                          end
                          else
                          begin
                            ExecProc;
                            ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                          end;
                  except on e:exception do
                      begin

                          mainclass.writeerrorlog('储值卡信息2027查询失败原因:'+e.message);
                          ResponseCode:='10';  //查询错误
                      end;
                  end;
                end;

        end;

            copymemory(@pprecardResponse.ResponseCode,PChar(ResponseCode),SizeOf(pprecardResponse.ResponseCode));

//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pprecardResponse,SizeOf(pprecardResponse));
            self.sendbody(tmpbuf,'2028',SizeOf(pprecardResponse));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
//                  writelog('来自'+ppackheadReceiver.SenderID+'客户ID:'+pbanksetczquery.PCardID+'查询发送成功');
              except
                  WriteerrorLog('储值卡信息操作失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2029;
var
    strtmp:string;
    oper:string;
    i:integer;

begin
//**********************************************处理报文**************************************************
            CopyMemory(@pchargecardRequest,@buf,SizeOf(pchargecardRequest));
            FillChar(pchargecardResponse,SizeOf(pchargecardResponse),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pchargecardResponse.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pchargecardResponse.ProcessDate),'0')),SizeOf(pchargecardResponse.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pchargecardResponse.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pchargecardResponse.Processtime),'0')),SizeOf(pchargecardResponse.Processtime));
            copymemory(@pchargecardResponse.NetWorkID,@pchargecardRequest.NetWorkID,SizeOf(pchargecardResponse.NetWorkID));
            copymemory(@pchargecardResponse.TerminalID,@pchargecardRequest.TerminalID,SizeOf(pchargecardResponse.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin

                with adosp do
                begin
                    close;
                  errorid:=-1;

                    ProcedureName:='base_chargecardinfo';

                  Parameters.Clear;
                  Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,string(pchargecardRequest.ProcessDate));
                  Parameters.CreateParameter('@ProcessTime',ftstring,pdInput,6,string(pchargecardRequest.ProcessTime));
                  Parameters.CreateParameter('@NetWorkID',ftstring,pdInput,7,Trim(string(pchargecardRequest.networkid)));
                  Parameters.CreateParameter('@TerminalID',ftstring,pdInput,10,Trim(string(pchargecardRequest.TerminalID)));
                  Parameters.CreateParameter('@CustomerID',ftString,pdInput,20,Trim(string(pchargecardRequest.CustomerID)));
                  Parameters.CreateParameter('@VehiclePlateNo',ftString,pdInput,10,Trim(string(pchargecardRequest.VehiclePlateNo)));
                  Parameters.CreateParameter('@CardID',ftString,pdInput,20,Trim(string(pchargecardRequest.CardID)));
                  Parameters.CreateParameter('@StartDate',ftString,pdInput,20,Trim(string(pchargecardRequest.StartUseTime)));
                  Parameters.CreateParameter('@EndDate',ftString,pdInput,20,Trim(string(pchargecardRequest.InvalidTime)));
                  Parameters.CreateParameter('@BankID',ftString,pdInput,8,Trim(string(pchargecardRequest.BankID)));
                  Parameters.CreateParameter('@BankCardType',ftString,pdInput,4,Trim(string(pchargecardRequest.BankCardType)));
                  Parameters.CreateParameter('@BankCardID',ftString,pdInput,30,Trim(string(pchargecardRequest.BankCardID)));
                  Parameters.CreateParameter('@BCertificateType',ftString,pdInput,4,Trim(string(pchargecardRequest.BCertificateType)));
                  Parameters.CreateParameter('@BVCertificateID',ftString,pdInput,30,Trim(string(pchargecardRequest.BVCertificateID)));
                  Parameters.CreateParameter('@BUserName',ftString,pdInput,10,Trim(string(pchargecardRequest.BUserName)));
                  Parameters.CreateParameter('@fileVersion',ftString,pdInput,10,Trim(string(pchargecardRequest.fileVersion)));
                  Parameters.CreateParameter('@OperatorNo',ftString,pdInput,8,Trim(string(pchargecardRequest.OperatorID)));
                  Parameters.CreateParameter('@operation',ftString,pdInput,4,Trim(string(pchargecardRequest.operation)));
                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);
                  Parameters.CreateParameter('@errorid',ftinteger,pdoutput,4,errorid);
                  Parameters.CreateParameter('@ErrorMsg',ftstring,pdoutput,50,ErrorMsg);
                  try

                          oper:=parameters.ParamByName('@operation').Value;
                          if oper = '3' then
                          begin
                            open;
                            errorid:=parameters.ParamByName('@errorid').Value;
                            if errorid<0 then
                            Errormsg:=parameters.ParamByName('@errormsg').Value+'客户ID：'+pchargecardRequest.CustomerID;
                            if RecordCount=0 then
                            begin
                                ResponseCode:='86'; //此卡片信息不存在
                                mainclass.WriteerrorLog('此卡片信息不存在'+pchargecardRequest.VehiclePlateNo);
                            end;
                            if ResponseCode='00' then
                              begin

                                  copymemory(@pchargecardResponse.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(pchargecardResponse.CustomerID),' ')),SizeOf(pchargecardResponse.CustomerID));
                                  copymemory(@pchargecardResponse.VehiclePlateNo,PChar(mainclass.padr(fieldbyname('VehiclePlateNo').AsString,SizeOf(pchargecardResponse.VehiclePlateNo),' ')),SizeOf(pchargecardResponse.VehiclePlateNo));
                                  copymemory(@pchargecardResponse.CardID,PChar(mainclass.padl(fieldbyname('CardID').AsString,SizeOf(pchargecardResponse.CardID),' ')),SizeOf(pchargecardResponse.CardID));
                                  copymemory(@pchargecardResponse.CardState,PChar(mainclass.padl(fieldbyname('CardState').AsString,SizeOf(pchargecardResponse.CardState),' ')),SizeOf(pchargecardResponse.CardState));
                                  copymemory(@pchargecardResponse.IssueTime,PChar(mainclass.padr(fieldbyname('IssueTime').AsString,SizeOf(pchargecardResponse.IssueTime),' ')),SizeOf(pchargecardResponse.IssueTime));
                                  copymemory(@pchargecardResponse.InvalidTime,PChar(mainclass.padr(fieldbyname('invalidate').AsString,SizeOf(pchargecardResponse.InvalidTime),' ')),SizeOf(pchargecardResponse.InvalidTime));
                                  copymemory(@pchargecardResponse.networkID,PChar(mainclass.padr(fieldbyname('NetworkNo').AsString,SizeOf(pchargecardResponse.networkID),' ')),SizeOf(pchargecardResponse.networkID));
                                  copymemory(@pchargecardResponse.OperatorID,PChar(mainclass.padl(fieldbyname('CardOperatorNO').AsString,SizeOf(pchargecardResponse.OperatorID),' ')),SizeOf(pchargecardResponse.OperatorID));
                              end;
                          end
                          else
                          begin
                            ExecProc;
                            ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                          end;
                  except on e:exception do
                      begin

                          mainclass.writeerrorlog('记账卡信息2029查询失败原因:'+e.message);
                               strtmp:='';
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog(' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                          ResponseCode:='10';  //查询错误
                      end;
                  end;
                end;

        end;

            copymemory(@pchargecardResponse.ResponseCode,PChar(ResponseCode),SizeOf(pchargecardResponse.ResponseCode));

//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pchargecardResponse,SizeOf(pchargecardResponse));
            self.sendbody(tmpbuf,'2030',SizeOf(pchargecardResponse));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
//                  writelog('来自'+ppackheadReceiver.SenderID+'客户ID:'+pbanksetczquery.PCardID+'查询发送成功');
              except
                  WriteerrorLog('记账卡信息操作失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2041;
var
    strtmp:string;
    carcount:integer;
    ordercount:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@porderRequest,@buf,SizeOf(porderRequest));
            FillChar(porderResponse,SizeOf(porderResponse),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@porderResponse.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(porderResponse.ProcessDate),'0')),SizeOf(porderResponse.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@porderResponse.Processtime,PChar(mainclass.padl(strtmp,SizeOf(porderResponse.Processtime),'0')),SizeOf(porderResponse.Processtime));
            copymemory(@porderResponse.NetWorkID,@porderRequest.NetWorkID,SizeOf(porderResponse.NetWorkID));
            copymemory(@porderResponse.TerminalID,@porderRequest.TerminalID,SizeOf(porderResponse.TerminalID));
            copymemory(@porderResponse.OrderID,@porderRequest.OrderID,SizeOf(porderResponse.OrderID));
            carcount:= -1;

            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin
               adoqry.Close;
               adoqry.SQL.Clear;
               adoqry.SQL.Text:='select 1 from etccarinfo with (nolock) where customerid='''+trim(porderRequest.CustomerID)+''' and right(VehiclePlateNo,7)=right('''+trim(porderRequest.VehiclePlateNo)+''',7)';
//               WriteLog('query:'+adoqry.SQL.Text);
               adoqry.Open;
               carcount:=adoqry.RecordCount;
            end;
            begin
               adoqry.Close;
               adoqry.SQL.Clear;
               adoqry.SQL.Text:='select 1 from bankorder with (nolock) where vehplate='''+trim(porderRequest.VehiclePlateNo)+'''';
//               WriteLog('query:'+adoqry.SQL.Text);
               adoqry.Open;
               ordercount:=adoqry.RecordCount;
            end;

            if carcount = 0 then
              begin
                 ResponseCode:='18';           //车牌号不存在
              end
            else
            if ordercount = 1 then
            begin
               ResponseCode:='87';           //该订单已存在
            end
            else
            begin
               adoqry.Close;
               adoqry.SQL.Clear;
               adoqry.SQL.Text:='insert into  bankorder (ProcessDate,ProcessTime,NetWorkID,TerminalID,CustomerID,BankID,Vehplate,VehplateColor,VehType,VehSeatNum,BankCardType,'
               +' BCertificateType,BVCertificateID,ActiveDate,BankCardID,BUserName,OrderID,mobile,addr) values ('+trim(porderRequest.ProcessDate)+','+trim(porderRequest.ProcessTime)+','
               +''+trim(porderRequest.networkID)+','+trim(porderRequest.TerminalID)+','''+trim(porderRequest.CustomerID)+''','+trim(mainclass.bankid)+','''+trim(porderRequest.VehiclePlateNo)+''','+trim(porderRequest.VehplateColor)+','
               +''+trim(porderRequest.VehType)+','+trim(porderRequest.VehSeatNum)+','+trim(porderRequest.BankCardType)+','+trim(porderRequest.BCertificateType)+','''+trim(porderRequest.BVCertificateID)+''','''+trim(porderRequest.ActiveDate)+''','
               +''''+trim(porderRequest.BankCardID)+''','''+trim(porderRequest.BUserName)+''','''+trim(porderRequest.OrderID)+''','''+trim(porderRequest.mobile)+''','''+trim(porderRequest.addr)+''')';
//               WriteLog('execquery:'+adoqry.SQL.Text);
               adoqry.ExecSQL;
            end;

            copymemory(@porderResponse.ResponseCode,PChar(ResponseCode),SizeOf(porderResponse.ResponseCode));

//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@porderResponse,SizeOf(porderResponse));
            self.sendbody(tmpbuf,'2042',SizeOf(porderResponse));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
              except
                  WriteerrorLog('银行订单操作失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc3999;
var
    strtmp:string;
   tmp_sendsize1:integer;
   bankey:string;
begin
//**********************************************处理报文**************************************************

                 CopyMemory(@pbankgetphone,@buf,SizeOf(pbankgetphone)) ;
                 idcbank:=TIdTCPClient.Create(nil);
                  idcbank.ReadTimeout:=30000;
                    idcbank.Host:=mainclass.bankserverip;
                    idcbank.Port:=mainclass.bankserverport;

                 if LeftStr(pbankgetphone.BankID,2)='30' then           //农行
                    begin
                      idcbank.Host:='192.168.207.185';
//                      idcbank.Host:='192.168.207.220'; //测试
                      idcbank.Port:=10011;
                      bankey:='5566778888776655';
                    end   else
                 if LeftStr(pbankgetphone.BankID,2)='31' then           //华夏
                    begin
                      idcbank.Host:='10.1.1.43';
//                      idcbank.Host:='10.1.1.41';       //测试
                      idcbank.Port:=16111;
                      bankey:='3276548315682459';
                    end   else
                if LeftStr(pbankgetphone.BankID,2)='32' then           //光大
                    begin
                      idcbank.Host:='24.28.0.60';
                      idcbank.Port:=6002;
                      bankey:='4312657898124545';
                    end   else
                if LeftStr(pbankgetphone.BankID,2)='33' then           //中行
                    begin
                      idcbank.Host:='26.28.251.1';
//                      idcbank.Host:='26.28.251.10';  //测试
                      idcbank.Port:=9323;
                      bankey:='1122334444332211';
                    end   else
                if LeftStr(pbankgetphone.BankID,2)='40' then           //邮储
                    begin
                      idcbank.Host:='132.132.132.4';
                      idcbank.Port:=4001;
                      bankey:='1122334444332211';
                    end   else
                if LeftStr(pbankgetphone.BankID,2)='60' then           //工行
                    begin
                      idcbank.Host:='88.2.114.2';
//                      idcbank.Host:='88.6.93.128';                 //测试
                      idcbank.Port:=8358;
                      bankey:='5678976543562178';
                    end   else
                if LeftStr(pbankgetphone.BankID,2)='80' then           //建行
                    begin
                      idcbank.Host:='15.5.193.127';
//                      idcbank.Host:='15.18.6.61';      //测试
                      idcbank.Port:=16063;
                      bankey:='3322441111442233';
                    end;
                 if LeftStr(pbankgetphone.BankID,2)='70' then           //交行
                    begin
                      idcbank.Host:='15.18.6.161';
//                      idcbank.Host:='193.59.158.99';       //测试
                      idcbank.Port:=25011;
                      bankey:='1122334444332211';
                    end;
                    if LeftStr(pbankgetphone.BankID,2)='39' then           //浦发
                    begin
                      idcbank.Host:='144.172.64.113';
//                      idcbank.Host:='11.23.0.99';       //测试
                      idcbank.Port:=6001;
                      bankey:='1122334444332211';
                    end;
                   if LeftStr(pbankgetphone.BankID,2)='35' then           //农信社
                    begin
                      idcbank.Host:='172.31.251.10';
//                      idcbank.Host:='172.28.4.147';      //测试
                      idcbank.Port:=11031;
                      bankey:='1122334444332211';
                    end;
                  try
                    idcbank.Disconnect ;
                    idcbank.Connect(5000);
                    writedebuglog('发自IP为:'+idcbank.Host+'端口号为:'+inttostr(idcbank.Port)+'');
                   except on e:exception do
                   begin
                     responsecode:='09';
                     writedebuglog('发自IP为:'+idcbank.Host+'端口号为:'+inttostr(idcbank.Port)+'连接银行失败'+e.Message);
                   end;

                   end;
                    if idcbank.Connected  then
                    begin

                        if self.probank1001(bankey) then
                        begin
                            if self.procbank1003 then
                            begin
                               FillChar(tmpbuf,SizeOf(tmpbuf),0);

                               CopyMemory(@tmpbuf,@pbankgetphone,SizeOf(pbankgetphone));
                                    try
                                     tmp_sendsize1:=SizeOf(pbankgetphone);
//
                                     self.sendbodybank(tmpbuf,'3999', tmp_sendsize1);
                                        writedebuglog('银行发送3999 223');
                                     idcbank.WriteBuffer(buf,bufsize);
                                        writedebuglog('银行发送WriteBuffer3999');
                                      readbufbak(bankey);
                                      idcbank.Disconnect;
                                      if (AMessageType=4000) then
                                     begin
                                         FillChar(pbanksetphone,SizeOf(pbanksetphone),0);
                                         CopyMemory(@pbanksetphone,@buf,SizeOf(pbanksetphone));
                                         responsecode:=pbanksetphone.ResponseCode;
                                          writedebuglog('proc3999---1银行RESPONSECODE：='+pbanksetphone.ResponseCode );
                                     end
                                     else
                                     begin
                                         writedebuglog('09向银行发起修改返回失败'+ppackheadReceiver.SenderID+'修改失败');
                                         responsecode:= '09';
                                     end;
                                     except  on e:Exception  do
                                     begin
                                        responsecode:= '28';
                                        writedebuglog('proc4001发送3银行失败'+e.Message);
                                     end;
                                   end;

                             end
                             else
                             begin
                                 writedebuglog('向银行发起修改失败'+ppackheadReceiver.SenderID+'签到失败');
                                 responsecode:= '09';
                             end;

                        end
                        else
                        begin
                            writedebuglog('09来自'+ppackheadReceiver.SenderID+'获取加密因子失败');
                            responsecode:= '09';
                        end;
                    end;

//********************

           // FillChar(pbanksetbdcardkh,SizeOf(pbanksetbdcardkh),0);
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetphone.ProcessDate,pchar(strtmp),SizeOf(pbanksetphone.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetphone.Processtime,pchar(strtmp),SizeOf(pbanksetphone.Processtime));

            if AMessageType=4000 then
            begin
                if ResponseCode<>'00' then
                begin
                    mainclass.WriteerrorLog(pbankgetphone.BankCardID+'绑定卡修改手机号失败');
                end;
            end;
                copymemory(@pbanksetphone.ResponseCode,pchar(ResponseCode),SizeOf(pbanksetphone.ResponseCode));
                FillChar(tmpbuf,SizeOf(tmpbuf),0);
                CopyMemory(@tmpbuf,@pbanksetphone,SizeOf(pbanksetphone));
                self.sendbody(tmpbuf,'4000',SizeOf(pbanksetphone));
            //end ;
               writedebuglog('proc4000---2银行RESPONSECODE：='+pbanksetphone.ResponseCode );
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('proc3999---结束来自'+ppackheadReceiver.SenderID+'绑定卡修改手机号成功'+pbankgetphone.NewPhoneNO);
              except
              begin
                  WriteerrorLog('绑定卡修改手机号失败!!');
                   responsecode:= '09';
              end;
              end;
            end
            else
             begin
                WriteerrorLog('客户端请求中断');
                 responsecode:= '09';
             end;


end;

procedure TETCPeerThread.proc4001;
var
    strtmp:string;
  //  i:integer;
  // ls_sql:string;
   tmp_sendsize1:integer;
   bankey:string;
begin
//**********************************************处理报文**************************************************

                 CopyMemory(@pbankgetbdcardkh,@buf,SizeOf(pbankgetbdcardkh)) ;
                 idcbank:=TIdTCPClient.Create(nil);
                  idcbank.ReadTimeout:=30000;
                    idcbank.Host:=mainclass.bankserverip;
                    idcbank.Port:=mainclass.bankserverport;

                 if LeftStr(pbankgetbdcardkh.BankID,2)='30' then           //农行
                    begin
                      idcbank.Host:='192.168.207.185';
//                      idcbank.Host:='192.168.207.220'; //测试
                      idcbank.Port:=10011;
                      bankey:='5566778888776655';
                    end   else
                 if LeftStr(pbankgetbdcardkh.BankID,2)='31' then           //华夏
                    begin
                      idcbank.Host:='10.1.1.43';
//                      idcbank.Host:='10.1.1.41';       //测试
                      idcbank.Port:=16111;
                      bankey:='3276548315682459';
                    end   else
                if LeftStr(pbankgetbdcardkh.BankID,2)='32' then           //光大
                    begin
                      idcbank.Host:='24.28.0.60';
                      idcbank.Port:=6002;
                      bankey:='4312657898124545';
                    end   else
                if LeftStr(pbankgetbdcardkh.BankID,2)='33' then           //中行
                    begin
                      idcbank.Host:='26.28.251.1';
                      idcbank.Port:=9323;
                      bankey:='1122334444332211';
                    end   else
                if LeftStr(pbankgetbdcardkh.BankID,2)='40' then           //邮储
                    begin
                      idcbank.Host:='132.132.132.4';
                      idcbank.Port:=4001;
                      bankey:='1122334444332211';
                    end   else
                if LeftStr(pbankgetbdcardkh.BankID,2)='60' then           //工行
                    begin
                      idcbank.Host:='88.2.114.2';
//                      idcbank.Host:='88.6.93.128';                 //测试
                      idcbank.Port:=8358;
                      bankey:='5678976543562178';
                    end   else
                if LeftStr(pbankgetbdcardkh.BankID,2)='80' then           //建行
                    begin
                      idcbank.Host:='15.5.193.127';
//                      idcbank.Host:='15.18.6.61';      //测试
                      idcbank.Port:=16063;
                      bankey:='3322441111442233';
                    end;
                 if LeftStr(pbankgetbdcardkh.BankID,2)='70' then           //交行
                    begin
                      idcbank.Host:='15.18.6.161';
//                      idcbank.Host:='193.59.158.99';       //测试
                      idcbank.Port:=25011;
                      bankey:='1122334444332211';
                    end;
                    if LeftStr(pbankgetbdcardkh.BankID,2)='39' then           //浦发
                    begin
                      idcbank.Host:='144.172.64.113';
//                      idcbank.Host:='11.23.0.99';       //测试
                      idcbank.Port:=6001;
                      bankey:='1122334444332211';
                    end;
                   if LeftStr(pbankgetbdcardkh.BankID,2)='35' then           //农信社
                    begin
                      idcbank.Host:='172.31.251.10';
//                      idcbank.Host:='172.28.4.147';      //测试
                      idcbank.Port:=11031;
                      bankey:='1122334444332211';
                    end;
                  try
                    idcbank.Disconnect ;
                    idcbank.Connect(5000);
                    writedebuglog('发自IP为:'+idcbank.Host+'端口号为:'+inttostr(idcbank.Port)+'');
                   except on e:exception do
                   begin
                     responsecode:='09';
                     writedebuglog('发自IP为:'+idcbank.Host+'端口号为:'+inttostr(idcbank.Port)+'连接银行失败'+e.Message);
                   end;

                   end;
                    if idcbank.Connected  then
                    begin

                        if self.probank1001(bankey) then
                        begin
                            if self.procbank1003 then
                            begin
                               FillChar(tmpbuf,SizeOf(tmpbuf),0);
                            //  添加转发时变更信息
                          // copymemory(@pbanksetczqq.wastesn,PChar(mainclass.padr(strwastesn,SizeOf(pbanksetczqq.wastesn),' ')),SizeOf(pbanksetczqq.wastesn));
                              try
                               if  (pbankgetbdcardkh.UserType='05') then
                               begin
                                 copymemory(@pbankgetbdcardkh.UserType,PChar('00'),2);
                               end;
                               if  (pbankgetbdcardkh.UserType='02') then
                               begin
                                 copymemory(@pbankgetbdcardkh.UserType,PChar('04'),2);
                               end;
                               if  (pbankgetbdcardkh.UserType='03') then
                               begin
                                 copymemory(@pbankgetbdcardkh.UserType,PChar('05'),2);
                               end;
                               if  (pbankgetbdcardkh.UserType='04') then
                               begin
                                 copymemory(@pbankgetbdcardkh.UserType,PChar('10'),2);
                               end ;
                              except
                                 copymemory(@pbankgetbdcardkh.UserType,PChar('01'),2);
                              end;

                           //  copymemory(@pbankgetbdcardkh.UserType,PChar('04'),2);
                               CopyMemory(@tmpbuf,@pbankgetbdcardkh,SizeOf(pbankgetbdcardkh));
                                    try
      //                                pbankgetbdcardkh.UserType:='0';

                                    tmp_sendsize1:=SizeOf(pbankgetbdcardkh);
//                                    if (Copy(string(pbankgetbdcardkh.networkID),1,2)='31') or (Copy(string(pbankgetbdcardkh.networkID),1,2)='40')
//                                     or (Copy(string(pbankgetbdcardkh.networkID),1,2)='80')  then
//                                        tmp_sendsize1:=tmp_sendsize1-50;
                                     self.sendbodybank(tmpbuf,'4001', tmp_sendsize1);
                                        writedebuglog('银行发送4001 223');
                                     idcbank.WriteBuffer(buf,bufsize);
                                        writedebuglog('银行发送WriteBuffer4001');
                                      readbufbak(bankey);
                                      idcbank.Disconnect;
                                      if (AMessageType=4002) then
                                     begin
                                         FillChar(pbanksetbdcardkh,SizeOf(pbanksetbdcardkh),0);
                                         CopyMemory(@pbanksetbdcardkh,@buf,SizeOf(pbanksetbdcardkh));
                                         responsecode:=pbanksetbdcardkh.ResponseCode;
                                          writedebuglog('proc4001---1银行RESPONSECODE：='+pbanksetbdcardkh.ResponseCode );
                                     end
                                     else
                                     begin
                                         writedebuglog('09向银行发起签约返回失败'+ppackheadReceiver.SenderID+'签到失败');
                                         responsecode:= '09';
                                     end;
                                     except  on e:Exception  do
                                     begin
                                        responsecode:= '28';
                                        writedebuglog('proc4001发送3银行失败'+e.Message);
                                     end;
                                   end;

                             end
                             else
                             begin
                                 writedebuglog('向银行发起签到失败'+ppackheadReceiver.SenderID+'签到失败');
                                 responsecode:= '09';
                             end;

                        end
                        else
                        begin
                            writedebuglog('09来自'+ppackheadReceiver.SenderID+'获取加密因子失败');
                            responsecode:= '09';
                        end;
                    end;

//********************

           // FillChar(pbanksetbdcardkh,SizeOf(pbanksetbdcardkh),0);
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetbdcardkh.ProcessDate,pchar(strtmp),SizeOf(pbanksetbdcardkh.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetbdcardkh.Processtime,pchar(strtmp),SizeOf(pbanksetbdcardkh.Processtime));

            if AMessageType=4002 then
            begin
                if ResponseCode<>'00' then
                begin
                    mainclass.WriteerrorLog(pbankgetbdcardkh.BankCardID+'绑定卡开户失败');
                end;
            end;
                copymemory(@pbanksetbdcardkh.ResponseCode,pchar(ResponseCode),SizeOf(pbanksetbdcardkh.ResponseCode));
                FillChar(tmpbuf,SizeOf(tmpbuf),0);
                CopyMemory(@tmpbuf,@pbanksetbdcardkh,SizeOf(pbanksetbdcardkh));
                self.sendbody(tmpbuf,'4002',SizeOf(pbanksetbdcardkh));
            //end ;
               writedebuglog('proc4001---2银行RESPONSECODE：='+pbanksetbdcardkh.ResponseCode );
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('proc4001---结束来自'+ppackheadReceiver.SenderID+'绑定卡开户成功'+pbanksetbdcardkh.PCardID);
              except
              begin
                  WriteerrorLog('绑定卡开户失败!!');
                   responsecode:= '09';
              end;
              end;
            end
            else
             begin
                WriteerrorLog('客户端请求中断');
                 responsecode:= '09';
             end;
            //更新绑定状态
          {  with adoqry do
            begin
              active:=false;
              sql.Clear;
              sql.text:='update ETCBankCardBindTab set bindstate = ''1'',bankcustomerid='''+pbanksetbdcardkh.BUserName+''',carinfo='''+pbanksetbdcardkh.BVCertificateID+''',mobileno='''+pbanksetbdcardkh.ActiveDate+''',remark='''+pbanksetbdcardkh.BankCardID+''',ResponseCode='''+pbanksetbdcardkh.ResponseCode+''',bindendtime=getdate() where  pcardid = '''+pbanksetbdcardkh.pcardid+'''';
//              mainclass.WriteLog(sql.text);
              prepared;
              ExecSQL;
            end; }

end;

 procedure TETCPeerThread.proc4003;
var
    strtmp:string;
   // strtmpid:string;
   // i:integer;
   ls_sql:string;
begin
//**********************************************处理报文**************************************************

                 CopyMemory(@pbankgetcbcardkh,@buf,SizeOf(pbankgetcbcardkh)) ;
                    ls_sql:=' INSERT INTO dbo.ETCBankCarBindTab_All( '+
	                                            'NetWorkID,'+
	                                            'TerminalID,'+
	                                            'BankID,'+
	                                            'CustomerID,'+
	                                            'UserType,'+
	                                            'UserName,'+
	                                            'CertificateType,'+
	                                            'CertificateID,'+
	                                            'PCardNetID,'+
	                                            'PCardID,'+
	                                            'ETCCardID,'+
	                                            'EntrustVerifyCode,'+
	                                            'Vehplate,'+
	                                            'VehplateColor,'+
	                                            'VehType,'+
	                                            'VehSeatNum,'+
	                                            'WasteSN,'+
	                                            'BankCardID,'+
	                                            'BCertificateType,'+
	                                            'BVCertificateID,'+
	                                            'BUserName,'+
	                                            'OperatorName,'+
	                                            'ActiveDate,'+


	                                            'ProcessDate,'+
	                                            'ProcessTime'+

 	                                            ' 	)                     '+
	                                            '  VALUES                 '+
		                                            ' ( '''+pbankgetcbcardkh.NetWorkID +
	                                            ''','''+pbankgetcbcardkh.TerminalID +
	                                            ''','''+pbankgetcbcardkh.BankID +
	                                            ''','''+pbankgetcbcardkh.CustomerID +
	                                            ''','''+pbankgetcbcardkh.UserType +
	                                            ''','''+pbankgetcbcardkh.UserName +
	                                            ''','''+pbankgetcbcardkh.CertificateType +
	                                            ''','''+pbankgetcbcardkh.CertificateID +
	                                            ''','''+pbankgetcbcardkh.PCardNetID +
	                                            ''','''+pbankgetcbcardkh.PCardID +
	                                            ''','''+pbankgetcbcardkh.PCardNetID+pbankgetcbcardkh.PCardID +
	                                            ''','''+pbankgetcbcardkh.EntrustVerifyCode +
	                                            ''','''+pbankgetcbcardkh.Vehplate +
	                                            ''','''+pbankgetcbcardkh.VehplateColor +
	                                            ''','''+pbankgetcbcardkh.VehType +
	                                            ''','''+pbankgetcbcardkh.VehSeatNum +
	                                            ''','''+pbankgetcbcardkh.WasteSN +
	                                            ''','''+pbankgetcbcardkh.BankCardIDnew +
	                                            ''','''+pbankgetcbcardkh.BCertificateTypenew +
	                                            ''','''+pbankgetcbcardkh.BVCertificateIDnew +
	                                            ''','''+pbankgetcbcardkh.BUserNamenew +

	                                            ''','''+pbankgetcbcardkh.OperatorName +
	                                            ''','''+pbankgetcbcardkh.ActiveDatenew +


	                                            ''','''+pbankgetcbcardkh.ProcessDate +
	                                            ''','''+pbankgetcbcardkh.ProcessTime +''')';

                               try
                                     with  adoqry do
                                     begin
                                       adoqry.Active :=false;
                                       sql.text:= ls_sql;
                                       prepared;
                                  //     ExecSQL ;
                                     end;
                                 except on e:exception do
                                 begin
                                    responsecode:= '09';
                                    writedebuglog('proc4003 SQl='+ls_sql+e.Message );
                                 end;
                                 end;
                    idcbank.Host:=mainclass.bankserverip;
                    idcbank.Port:=mainclass.bankserverport;
                   try
                    idcbank.Disconnect ;
                    idcbank.Connect(10000);
                   except on e:exception do
                   begin
                           responsecode:='09';
                           writedebuglog('发自IP为:'+idcbank.Host+'端口号为:'+inttostr(idcbank.Port)+'连接银行失败'+e.Message);
                   end;

                   end;
                   { if idcbank.Connected  then
                    begin

                        if self.procbank1001 then
                        begin
                            if self.procbank1003 then
                            begin
                               FillChar(tmpbuf,SizeOf(tmpbuf),0);
                            CopyMemory(@tmpbuf,@pbankgetcbcardkh,SizeOf(pbankgetcbcardkh));
                              try
                               self.sendbodybank(tmpbuf,'4003',  sizeOf(pbankgetcbcardkh));
                                  writedebuglog('银行发送4003 223');
                               idcbank.WriteBuffer(buf,bufsize);
                                  writedebuglog('银行发送WriteBuffer4003');
                                readbufbank();
                               except  on e:Exception  do
                               begin
                               responsecode:= '09';
                                  writedebuglog('proc4003发送3银行失败'+e.Message);
                               end;
                               end;
                                 if (AMessageType=4004) then
                                 begin
                                     FillChar(pbanksetcbcardkh,SizeOf(pbanksetcbcardkh),0);
                                     CopyMemory(@pbanksetcbcardkh,@buf,SizeOf(pbanksetcbcardkh));
                                     responsecode:=pbanksetcbcardkh.ResponseCode;
                                      writedebuglog('proc4001---1银行RESPONSECODE：='+pbanksetcbcardkh.ResponseCode );
                                 end
                                 else
                              begin
                                writedebuglog('09向银行发起签约返回失败'+ppackheadReceiver.SenderID+'签到失败'+mainclass.errorname(ResponseCode));
                               responsecode:= '09';
                               end;
                             end
                              else
                              begin
                                writedebuglog('09向银行发起签到失败'+ppackheadReceiver.SenderID+'签到失败'+mainclass.errorname(ResponseCode));
                               responsecode:= '09';
                               end;

                        end
                        else
                        begin
                            writedebuglog('09来自'+ppackheadReceiver.SenderID+'获取加密因子失败'+mainclass.errorname(ResponseCode));
                            responsecode:= '09';
                        end;
                    end;  }

//********************
             responsecode:='00';
            FillChar(pbanksetcbcardkh,SizeOf(pbanksetcbcardkh),0);
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetcbcardkh.ProcessDate,pchar(strtmp),SizeOf(pbanksetcbcardkh.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetcbcardkh.Processtime,pchar(strtmp),SizeOf(pbanksetcbcardkh.Processtime));

            if AMessageType=4004 then
            begin
                if ResponseCode='00' then
                begin
                    mainclass.WriteerrorLog(pbankgetcbcardkh.BankCardID );
                end;
                 // if responsecode='00' then
                    //               begin

            end;
                copymemory(@pbanksetcbcardkh.ResponseCode,pchar(ResponseCode),SizeOf(pbanksetcbcardkh.ResponseCode));
                FillChar(tmpbuf,SizeOf(tmpbuf),0);
                CopyMemory(@tmpbuf,@pbanksetcbcardkh,SizeOf(pbanksetcbcardkh));
                self.sendbody(tmpbuf,'4004',SizeOf(pbanksetcbcardkh));
            //end ;
               writedebuglog('proc4003---2银行RESPONSECODE：='+pbanksetcbcardkh.ResponseCode );
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('proc4003---结束来自'+ppackheadReceiver.SenderID+'绑定卡开户成功'+pbanksetbdcardkh.PCardID);
              except
              begin
                  WriteerrorLog('绑定卡开户失败!!');
                   responsecode:= '09';
              end;
              end;
            end
            else
             begin
                WriteerrorLog('客户端请求中断');
                 responsecode:= '09';
             end;

end;

procedure TETCPeerThread.proc4011;
var
    strtmp:string;
   // strtmpid:string;
   // i:integer;
begin
//**********************************************处理报文**************************************************
                  CopyMemory(@pbankgetbdcardxh,@buf,SizeOf(pbankgetbdcardxh));
                  idcbank:=TIdTCPClient.Create(nil);
                  idcbank.ReadTimeout:=30000;
                    idcbank.Host:=mainclass.bankserverip;
                    idcbank.Port:=mainclass.bankserverport;
//                    idcbank.Disconnect;
                    WritedebugLog('4011银行端IP--->'+mainclass.bankserverip);
                    idcbank.Connect(10000);

                    try
                      WritedebugLog('4011银行端口--->'+inttostr(mainclass.bankserverport));
                     if idcbank.Connected  then
                      begin
                        if self.procbank1001 then
                        begin
                            if self.procbank1003 then
                            begin
                              FillChar(tmpbuf,SizeOf(tmpbuf),0);
                              CopyMemory(@tmpbuf,@pbankgetbdcardxh,SizeOf(pbankgetbdcardxh));
                              self.sendbodybank(tmpbuf,'4011',  sizeOf(pbankgetbdcardxh));
                              idcbank.WriteBuffer(buf,bufsize);
                              WritedebugLog('发送到银行');
                              readbufbank();
                              WritedebugLog('读取银行4011数据.。。');
                               if (AMessageType=4012) then
                               begin
                                 FillChar(pbanksetbdcardxh,SizeOf(pbanksetbdcardxh),0);
                                 CopyMemory(@pbanksetbdcardxh,@buf,SizeOf(pbanksetbdcardxh));
                                 responsecode:=pbanksetbdcardxh.ResponseCode;
                                 writedebuglog('4011 responsecode:= '+responsecode);
                               end
                               else
                               begin
                                 ResponseCode:='42'
                                end;
                            end
                            else
                            begin
                               writedebuglog('4011的1003销户失败');
                              ResponseCode:='09'
                            end;

                        end
                        else
                        begin
                             writedebuglog('4011的1001销户失败');
                            ResponseCode:='42'
                        end;
                     end
                    except on e:exception do
                     begin
                              writedebuglog('4011的销户失败');
                              ResponseCode:='09'
                     end;
                    end;
             try

            FillChar(pbanksetbdcardxh,SizeOf(pbanksetbdcardxh),0);
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetbdcardxh.ProcessDate,pchar(strtmp),SizeOf(pbanksetbdcardxh.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetbdcardxh.Processtime,pchar(strtmp),SizeOf(pbanksetbdcardxh.Processtime));
            copymemory(@pbanksetbdcardxh.ResponseCode,pchar(ResponseCode),SizeOf(pbanksetbdcardxh.ResponseCode));

            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetbdcardxh,SizeOf(pbanksetbdcardxh));
            self.sendbody(tmpbuf,'4012',SizeOf(pbanksetbdcardxh));
            except on e:exception do
            begin
                              writedebuglog('销户异常'+e.Message );
                              ResponseCode:='09'
            end;
            end ;
//**********************************************************************************************************
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'绑定卡解绑成功'+pbanksetbdcardxh.PCardID);
              except
                  WriteerrorLog('绑定卡解绑失败!!');
                    ResponseCode:='09'
              end;
            end
            else
            begin
                  WriteerrorLog('客户端请求中断');
                  ResponseCode:='09'
            end;

end;


procedure TETCPeerThread.proc2051;
var
    strtmp:string;
   // strtmpid:string;
   // streamfile:tfilestream;
   // sYear,sMonth,sDay:Word;
begin
//*****************************赋值报体内容**************************************************

      try
            CopyMemory(@PBANKGETCZDZ,@buf,SizeOf(PBANKGETCZDZ));
           {
            if not dowloadfile(StrToIntDef(trim(string(PBANKGETCZDZ.RecordNumber)),0),Trim(string(PBANKGETCZDZ.FileName))) then
            begin
                ResponseCode:='99';
            end;    }
            try
              ProcessList1 := TProcessList.Create;
              ProcessList1.DbConnected := True;
              if not ProcessList1.DbConnected then Exit;
              {1.获取配置文件参数}
              ProcessList1.LoadParam;
              {创建上传、下载、日志文件夹}
              ProcessList1.CreateYearFolder;
              ProcessList1.DownLoadFile(Trim(PBANKGETCZDZ.filename));
            except on e:exception do
              begin
                responsecode:= '48';
                WriteerrorLog('下载文件失败'+e.Message  );
              end;
              end;
           { DecodeDate(Now,sYear,sMonth,sDay);
            streamfile:=TfileStream.Create(ExtractFilePath(ParamStr(0))+'download\'+InttoStr(sYear)+'\'+trim(string(PBANKGETCZDZ.FileName)),fmOpenRead	);
            strtmp:=mainclass.getmd5(TStream(streamfile));
            WritedebugLog(PBANKGETCZDZ.FileName);
            writedebuglog('中心生成md5'+strtmp+'银行对账md5'+pbankgetczdz.VerifyCode);
            if strtmp<>pbankgetczdz.VerifyCode then
            begin
                responsecode:='46';
            end;   }
     except
         responsecode:='48'; //对账文件解析失败!!!
     end;
     if ResponseCode='00' then
     begin
         try
            FillChar(PBANKSETCZDZ,SizeOf(PBANKSETCZDZ),0);
            copymemory(@PBANKSETCZDZ.WorkDate,@PBANKGETCZDZ.WorkDate,SizeOf(PBANKSETCZDZ.WorkDate));
            copymemory(@PBANKSETCZDZ.BankID,@PBANKGETCZDZ.BankID,SizeOf(PBANKSETCZDZ.BankID));
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@PBANKSETCZDZ.ProcessDate,pchar(strtmp),SizeOf(pbanksetbdcardkh.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@PBANKSETCZDZ.Processtime,pchar(strtmp),SizeOf(PBANKSETCZDZ.Processtime));
         except
              responsecode:='48';
         end;
     end;
     copymemory(@PBANKSETCZDZ.ResponseCode,pchar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@PBANKSETCZDZ,SizeOf(PBANKSETCZDZ));
    self.sendbody(tmpbuf,'2052',SizeOf(PBANKSETCZDZ));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'请求对账发送成功'+PBANKSETCZDZ.ResponseCode);
          terminalok:=1;
          ProcessList1.ProcessDownFile(trim(PBANKGETCZDZ.filename));  //入库
      except
          WriteerrorLog('发送对账应答发送失败或文件入库失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

function TETCPeerThread.dowloadfile(recount:integer;filename:string):boolean;
var
  ret : integer;
  //i:Integer;
begin
  try
    result:=False;
    try
    ProcessList1 := TProcessList.Create;
    except on e:exception do
    begin
      responsecode:= '09';
      WriteerrorLog('TProcessList.Create 创建错误'+e.Message  );
    end;
    end;
    ProcessList1.DbConnected := True;
    if not ProcessList1.DbConnected then Exit;
    {1.获取配置文件参数}
    ProcessList1.LoadParam;
    {创建上传、下载、日志文件夹}
    ProcessList1.CreateYearFolder;
    {下载}
   // FileName:='BC0103000140000020130701102001.TXT';
    WriteLog(FileName+':开始下载');
     {FTP下载文件}
     try
     ret := ProcessList1.DownLoadFile(trim(FileName));
     {记录日志}
     case ret of
      NoThisFile :
      begin
          WriteerrorLog('FTP上需要下载的文件不存在');
          ResponseCode:='48';
      end;
      cannotConn :
      begin
          WriteerrorLog('不能连接FTP');
          ResponseCode:='99';
      end;
      OtherErr   :
      begin
         WriteerrorLog('连接FTP其他错误');
          ResponseCode:='99';
      end;
      RunOK :
       begin
         WriteLog('下载'+FileName+'文件成功');
          {将文件插入数据库中}
          ProcessList1.ProcessDownFile(trim(FileName));       //入点

          if (ProcessList1.ErrorCode =3) or (ProcessList1.ErrorCode =4)  then
              ResponseCode:='92';

        //  if ProcessList1.DownRecordNum<>recount then
         //     ResponseCode:='27';
          result:=true;

       end;
     end;
     except on e:exception do
     begin
       responsecode:= '09';
        WriteerrorLog('AAAAAAAAAA'+e.message);
     end;
     end;
  finally
    errormsg:=ProcessList1.ErrorStr;
    errorid:=ProcessList1.ErrorCode;

    ProcessList1.DbConnected := false;
    freeandnil(ProcessList1);
  end;
end;

procedure TETCPeerThread.proc4031;
var
    strtmp:string;
   // strtmpid:string;
begin
//*****************************赋值报体内容**************************************************

      try
            CopyMemory(@pbankgetblackfile,@buf,SizeOf(pbankgetblackfile));
            try
              ProcessList1 := TProcessList.Create;
              ProcessList1.DbConnected := True;
              if not ProcessList1.DbConnected then Exit;
              {1.获取配置文件参数}
              ProcessList1.LoadParam;
              {创建上传、下载、日志文件夹}
              ProcessList1.CreateYearFolder;
              ProcessList1.DownLoadFile(Trim(pbankgetblackfile.filename));
            except on e:exception do
              begin
                responsecode:= '48';
                WriteerrorLog('下载文件失败'+e.Message  );
              end;
              end;
            FillChar(pbanksetblackfile,SizeOf(pbanksetblackfile),0);
            if ResponseCode='00' then
            begin
                copymemory(@pbanksetblackfile.WorkDate,@pbankgetblackfile.WorkDate,SizeOf(pbanksetblackfile.WorkDate));
                copymemory(@pbanksetblackfile.BankID,@pbankgetblackfile.BankID,SizeOf(pbanksetblackfile.BankID));
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetblackfile.ProcessDate,pchar(strtmp),SizeOf(pbanksetblackfile.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pbanksetblackfile.Processtime,pchar(strtmp),SizeOf(pbanksetblackfile.Processtime));
            end;
     except  on e:exception  do
     begin
         responsecode:='28'; //签到失败!!!
         WriteerrorLog('4031签到失败'+e.message);
     end;
     end;
     copymemory(@pbanksetblackfile.ResponseCode,pchar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetblackfile,SizeOf(pbanksetblackfile));
    self.sendbody(tmpbuf,'4032',SizeOf(pbanksetblackfile));

    if (ProcessList1.ErrorCode =3) or (ProcessList1.ErrorCode =4)  then
      WriteerrorLog('黑名单入库失败！');
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'proc4031黑名单发送成功'+pbanksetblackfile.ResponseCode);
          terminalok:=1;
          ProcessList1.ProcessDownFile(trim(pbankgetblackfile.filename));  //入库
      except on e:exception do
      begin
           responsecode:= '09';
          WriteerrorLog('4031发送黑名单文件应答发送或文件入库失败!!'+e.message);
      end;
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.proc5001;
var
    strtmp:string;
   // strtmpid:string;
    streamfile:TfileStream;
    sYear,sMonth,sDay:Word;
begin
//*****************************赋值报体内容**************************************************

      try
            CopyMemory(@pbankgetOneReleasefile,@buf,SizeOf(pbankgetOneReleasefile));
            if not dowloadfile(StrToInt(trim(pbankgetOneReleasefile.RecordNumber)),trim(string(pbankgetOneReleasefile.FileName))) then
            begin
                ResponseCode:='99';
            end;
//*********************************************************校验MD5值****************************************
            DecodeDate(Now,sYear,sMonth,sDay);
            streamfile:=TfileStream.Create(ExtractFilePath(ParamStr(0))+'download\'+InttoStr(sYear)+'\'+trim(string(pbankgetOneReleasefile.FileName)),fmOpenRead	);
            strtmp:=mainclass.getmd5(TStream(streamfile));

            WritedebugLog(pbankgetOneReleasefile.FileName);
            writedebuglog('中心生成md5'+strtmp+'银行对账md5'+pbankgetOneReleasefile.VerifyCode);
            streamfile.Free;
            if strtmp<>pbankgetOneReleasefile.VerifyCode then
            begin
                responsecode:='46';
            end;
//**************************************************************************************************************
            strtmp:='insert into ETCBankCardOneReleaseKeyparent ([status],[remark]'
      +',[filename],[optime],[bankid],[cardnostart],[cardnoend],[recordnum])'
      +'values (0,'''','''+trim(string(pbankgetOneReleasefile.filename))+''',getdate(),'''+pbankgetOneReleasefile.BankID
      +''','''+pbankgetOneReleasefile.CardnoBegin
      +''','''+pbankgetOneReleasefile.CardnoEnd
      +''','+mainclass.yxsj(string(pbankgetOneReleasefile.RecordNumber))+')';
             with self.adoqry do
             begin
                 close;
                 sql.text:=strtmp;
                 try
                     ExecSQL;
                 except on e:exception do
                     begin
                         mainclass.WriteerrorLog('保存一发密钥申请记录失败!!'+e.Message+strtmp);
                     end;
                 end;
             end;
            FillChar(pbanksetOneReleasefile,SizeOf(pbanksetOneReleasefile),0);
            if ResponseCode='00' then
            begin
                copymemory(@pbanksetOneReleasefile.ProcessDate,@pbankgetOneReleasefile.ProcessDate,SizeOf(pbanksetOneReleasefile.ProcessDate));
                copymemory(@pbanksetOneReleasefile.ProcessTime,@pbankgetOneReleasefile.ProcessTime,SizeOf(pbanksetOneReleasefile.ProcessTime));
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetOneReleasefile.networkID,pchar(strtmp),SizeOf(pbanksetOneReleasefile.networkID));
                copymemory(@pbanksetOneReleasefile.TerminalID,pchar(strtmp),SizeOf(pbanksetOneReleasefile.TerminalID));
                copymemory(@pbanksetOneReleasefile.BankID,pchar(strtmp),SizeOf(pbanksetOneReleasefile.BankID));
            end;
     except  on e:exception  do
     begin
         responsecode:='99'; //签到失败!!!
         WriteerrorLog('5001签到失败'+e.message);
     end;
     end;
     copymemory(@pbanksetOneReleasefile.ResponseCode,pchar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetOneReleasefile,SizeOf(pbanksetOneReleasefile));
    self.sendbody(tmpbuf,'5002',SizeOf(pbanksetOneReleasefile));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'proc5001一次发行报文接收成功'+pbanksetOneReleasefile.ResponseCode);
          terminalok:=1;

      except on e:exception do
        begin
           responsecode:= '99';
          WriteerrorLog('5001发送一次发行报文应答失败!!'+e.message);
        end;
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;


procedure TETCPeerThread.proc5005;
var
    strtmp:string;
   // strtmpid:string;
begin
//*****************************赋值报体内容**************************************************

      try
              WriteerrorLog('5005----1');
            CopyMemory(@pbankgetSecondReleasefile,@buf,SizeOf(pbankgetSecondReleasefile));
              WriteerrorLog('5005----2');
            if not dowloadfile(StrToInt(pbankgetSecondReleasefile.RecordNumber),string(pbankgetSecondReleasefile.FileName)) then
            begin
              WriteerrorLog('5005----3');
                ResponseCode:='99';
            end;
              WriteerrorLog('5005----4');
            FillChar(pbanksetSecondReleaseResultfile,SizeOf(pbanksetSecondReleaseResultfile),0);
              WriteerrorLog('5005----5');
            if ResponseCode='00' then
            begin
              WriteerrorLog('5005----6');
                copymemory(@pbanksetSecondReleaseResultfile.ProcessDate,@pbankgetSecondReleasefile.ProcessDate,SizeOf(pbanksetSecondReleaseResultfile.ProcessDate));
                   WriteerrorLog('5005----7');
                copymemory(@pbanksetSecondReleaseResultfile.ProcessTime,@pbankgetSecondReleasefile.ProcessTime,SizeOf(pbanksetSecondReleaseResultfile.ProcessTime));
                   WriteerrorLog('5005----8');
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetSecondReleaseResultfile.networkID,pchar(strtmp),SizeOf(pbanksetSecondReleaseResultfile.networkID));
                   WriteerrorLog('5005----9');
                copymemory(@pbanksetSecondReleaseResultfile.TerminalID,pchar(strtmp),SizeOf(pbanksetSecondReleaseResultfile.TerminalID));
                   WriteerrorLog('5005----10');
                copymemory(@pbanksetSecondReleaseResultfile.BankID,pchar(strtmp),SizeOf(pbanksetSecondReleaseResultfile.BankID));
                   WriteerrorLog('5005----11');
            end;
     except  on e:exception  do
     begin
         responsecode:='90'; //签到失败!!!
         WriteerrorLog('5005签到失败'+e.message);
     end;
     end;
     copymemory(@pbanksetSecondReleaseResultfile.ResponseCode,pchar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetSecondReleaseResultfile,SizeOf(pbanksetSecondReleaseResultfile));
    self.sendbody(tmpbuf,'5006',SizeOf(pbanksetSecondReleaseResultfile));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'proc5005二次发行报文发送成功'+pbanksetSecondReleaseResultfile.ResponseCode);
          terminalok:=1;

      except on e:exception do
      begin
           responsecode:= '09';
          WriteerrorLog('5005发送二次发行报文应答失败!!'+e.message);
      end;
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.proc5007;
var
    strtmp:string;
     LS_ERRID:Integer;
    i:integer;

begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetVehinfoQuery,@buf,SizeOf(pbankgetVehinfoQuery));
             FillChar(pbanksetVehinfoQuery,SizeOf(pbankgetVehinfoQuery),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetVehinfoQuery.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pbanksetVehinfoQuery.ProcessDate),'0')),SizeOf(pbanksetVehinfoQuery.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetVehinfoQuery.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pbanksetVehinfoQuery.Processtime),'0')),SizeOf(pbanksetVehinfoQuery.Processtime));
            copymemory(@pbanksetVehinfoQuery.NetWorkID,@pbankgetVehinfoQuery.NetWorkID,SizeOf(pbankgetVehinfoQuery.NetWorkID));
            copymemory(@pbanksetVehinfoQuery.TerminalID,@pbankgetVehinfoQuery.TerminalID,SizeOf(pbankgetVehinfoQuery.TerminalID));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin
                writelog('车牌号:'+pbankgetVehinfoQuery.VehPlate+'车牌颜色:'+pbankgetVehinfoQuery.VehPlateColor+'查询请求');
                with adosp do
                begin
                    close;
                  LS_ERRID:=5;
                  ProcedureName:='Usp_ExpCarInfoQuery';
                  Parameters.Clear;
                  Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,string(pbankgetVehinfoQuery.ProcessDate));
                  Parameters.CreateParameter('@ProcessTime',ftstring,pdInput,6,string(pbankgetVehinfoQuery.ProcessTime));
                  Parameters.CreateParameter('@NetWorkID',ftstring,pdInput,7,string(pbankgetVehinfoQuery.networkid));
                  Parameters.CreateParameter('@TerminalID',ftstring,pdInput,10,string(pbankgetVehinfoQuery.TerminalID));
                  Parameters.CreateParameter('@Vehplate',ftstring,pdInput,12,trim(string(pbankgetVehinfoQuery.VehPlate)));
                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);
                  Parameters.CreateParameter('@errorid',ftinteger,pdoutput,1,LS_ERRID);
                  Parameters.CreateParameter('@ErrorMsg',ftstring,pdoutput,50,ErrorMsg);
                      try
        //               errorid1:=0;
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog(' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));

                            ExecProc;

                          LS_ERRID:=parameters.ParamByName('@errorid').Value;
                          ResponseCode:=parameters.ParamByName('@ResponseCode').Value;


                          if ResponseCode='00' then
                              begin
                                IF LS_ERRID=0 THEN
                                pbanksetVehinfoQuery.CarStatus:='0'
                                else
                                pbanksetVehinfoQuery.CarStatus:='1' ;
                              end;
                      except on e:exception do
                      begin
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog('车牌号查询失败原因:'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                          ResponseCode:='19';  //车牌号查询错误
                      end;
                  end;


                end;

        end;
            copymemory(@pbanksetVehinfoQuery.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetVehinfoQuery.ResponseCode));

//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetVehinfoQuery,SizeOf(pbanksetVehinfoQuery));
            self.sendbody(tmpbuf,'5008',SizeOf(pbanksetVehinfoQuery));

           if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  Connection.Disconnect;
                  writelog('来自'+ppackheadReceiver.SenderID+'车牌号'+pbankgetVehinfoQuery.VehPlate+'查询发送成功');
              except
                  WriteerrorLog('车辆查询失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;
{ tservice }

constructor tsendservice.Create(ACreateSuspended: Boolean);
begin
  inherited
  Create(ACreateSuspended);
  CoInitialize(nil);  // 在线程中创建Ado连接需要初始化Ado的COM接口
  adoconn:=TADOConnection.Create(nil);
  adoqry:= TADOQuery.Create(nil);
  qrytmp:=TADOQuery.Create(nil);
  qrytmp.Connection:=adoconn;
  adoqry.Connection:=adoconn;
  adosp:=TADOStoredProc.Create(nil);
  adosp.Connection:=adoconn;
  adoconn.ConnectionString:=dmform.adocn.ConnectionString;
  adoconn.LoginPrompt :=false;
  IdTCPClient1:=TIdTCPClient.Create(nil);
  idtcpclient1.ReadTimeout:=600000;
//  idcbank:=TIdTCPClient.Create(nil);
//  idcbank.ReadTimeout:=10000;
end;

destructor tsendservice.Destroy;
begin
    try
       adoqry.Active :=false;
       adoqry.Close;
    except
    end;
    try
       adosp.Active :=false;
       adosp.Close;
    except
    end;
    try
       adoconn.Connected:=false;
       adoconn.Close;
    except
    end;

  CoUnInitialize;  // 在线程中创建Ado连接需要初始化Ado的COM接口
  inherited;
end;

procedure tsendservice.execute;
var
    tabname:string;
    balancedate:string;
    nowdate:string;
    filename:string;
    sPath: string ;
    i:Integer;
begin
    while True do
   begin

      
//       mainclass.WriteLog('循环进行中。。。');
      {
        try
//*******************************判断有没有一次密钥申请记录****************
          //   mainclass.writelog('execute-1.5');
            adoqry.Active :=false;
            adoqry.SQL.text:='select top 1 * from dbo.ETCBankCardOneReleaseKeyparent a left join '
                            +' keyapplytab b on a.cardnostart=b.applycodebegin and a.cardnoend=b.applycodeend where b.checkstatus=1'
            +' and a.status=0 and bankid='''+mainclass.bankid+''' ';
//            adoqry.Active :=true;
              adoqry.Open;           //断网后自动重连
            if adoqry.RecordCount>0 then
            begin
               // ini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'control.ini');
                IdTCPClient1.Host:=mainclass.bankserverip;
                IdTCPClient1.Port:=mainclass.bankserverport;
                try
                 IdTCPClient1.Disconnect ;
                if not IdTCPClient1.Connected then
                   IdTCPClient1.Connect(10000);

                self.proc1001(adoqry.fieldbyname('bankid').AsString);
                if termianlpasskeyok<>1 then
                begin
                    mainclass.WriteLog('发送密钥文件时向银行取加密因子失败');
                    Continue;
                end;
                    self.proc1003(adoqry.fieldbyname('bankid').AsString);

                if terminalok<>1 then
                begin
                    mainclass.WriteLog('发送密钥文件时向银行签到失败');
                    Continue;
                end;
                except

                end;

                    self.proc5003(Trim(adoqry.fieldbyname('filename').AsString),
                                  Trim(adoqry.fieldbyname('bankid').AsString),
                                  FormatDateTime('yyyymmdd',now),adoqry.fieldbyname('recordnum').AsString
                                 ,adoqry.fieldbyname('cardnostart').AsString,adoqry.fieldbyname('cardnoend').AsString);

                 Sleep(10000);
            end;
         except on e:exception do
         begin
            dmform.adocn.Connected:=true;
            mainclass.WriteerrorLog('上传一次发行密钥文件'+e.Message );
         end;
         end;
         }
//*************************************************************************************

          try
//**************************超过45天卡表状态非正常的邮储银行绑定卡自动解绑****************
//            if ((mainclass.bankid='3000000') or (mainclass.bankid='3100000') or (mainclass.bankid='8000000') ) then
            begin
               try
                  adoqry.SQL.text:='select top 1 PCardID,bankid from ETCBankCardBindTab with (nolock) where spare2=''待解'' and bankid='+mainclass.bankid;
                  adoqry.Active :=true;

                except
                  on e:exception do
                end;

  //            adoqry.Open;           //断网后自动重连
                if adoqry.RecordCount>0 then
                begin
                  //  ini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'control.ini');
                    IdTCPClient1.Host:=mainclass.bankserverip;
                    IdTCPClient1.Port:=mainclass.bankserverport;
                    try
                     IdTCPClient1.Disconnect ;
                    if not IdTCPClient1.Connected then
                       IdTCPClient1.Connect(10000);

                    self.proc1001(adoqry.fieldbyname('bankid').AsString);
                    if termianlpasskeyok<>1 then
                    begin
                        mainclass.WriteerrorLog('发送解绑报文时向银行取加密因子失败');
                        Continue;
                    end;
                        self.proc1003(adoqry.fieldbyname('bankid').AsString);

                    if terminalok<>1 then
                    begin
                        mainclass.WriteerrorLog('发送解绑报文时时向银行签到失败');
                        Continue;
                    end;
                    except   on e:exception do
                       begin
                          mainclass.WriteerrorLog('发送解绑报文1'+e.Message );
                       end;

                    end;

                    self.proc4011(Trim(adoqry.fieldbyname('PCardID').AsString),adoqry.fieldbyname('bankID').AsString);
                     Sleep(10000);
                end;
            end;
          except  on e:exception do
           begin
              mainclass.WriteerrorLog('发送解绑报文'+e.Message );
           end;
          end;

         try
//**************************发送银行订单信息****************
          if ((mainclass.NetWorkID='6502005') or (mainclass.NetWorkID='8410008') or (mainclass.NetWorkID='3900000'))  then
             begin

                try
                  adoqry.SQL.text:='select top 1 BankID,CustomerID,Vehplate,VehplateColor,OrderID,EtccardID,obuno,expressid from bankorder with (nolock) where responsecode=''-1'' and len(expressid)>1 and networkid='+mainclass.NetWorkID;
                  adoqry.Active :=true;

                except
                  on e:exception do
                end;

                 i:= adoqry.RecordCount;

                  if (i > 0) then
                  begin
                      IdTCPClient1.Host:=mainclass.bankserverip;
                      IdTCPClient1.Port:=mainclass.bankserverport;
                      try
                       IdTCPClient1.Disconnect ;
                      if not IdTCPClient1.Connected then
                         IdTCPClient1.Connect(10000);

                      self.proc1001(adoqry.fieldbyname('bankid').AsString);
                      if termianlpasskeyok<>1 then
                      begin
                          mainclass.WriteerrorLog('发送银行订单时向银行取加密因子失败');
                          Continue;
                      end;
                          self.proc1003(adoqry.fieldbyname('bankid').AsString);

                      except   on e:exception do
                         begin
                            mainclass.WriteerrorLog('发送银行订单报文'+e.Message );
                         end;

                      end;

                      self.proc2043(Trim(adoqry.fieldbyname('CustomerID').AsString),adoqry.fieldbyname('Vehplate').AsString,adoqry.fieldbyname('VehplateColor').AsString,
                      adoqry.fieldbyname('OrderID').AsString,adoqry.fieldbyname('EtccardID').AsString,adoqry.fieldbyname('obuno').AsString,adoqry.fieldbyname('expressid').AsString);

                  end;
             
             end;
          except  on e:exception do
           begin
              mainclass.WriteerrorLog('发送银行订单报文'+e.Message );
           end;
          end;

          try
            nowdate:=FormatDateTime('hhmmss',Now());
          if (Copy(nowdate,1,2)>'07') and (Copy(nowdate,1,2)<'20') then
          begin
              balancedate:=formatdatetime('yyyymmdd',now);
              try

                adoqry.SQL.Text:='select top 1 * from pre_cardbackfee with (nolock)'
                    +' where resatus=0 and bankid='''+mainclass.bankid+''' and BalanceDate='''+balancedate+''' and networkid='''+mainclass.NetWorkID+'''';
                adoqry.Active :=true;

              except
                  on e:exception do
              end;

              if adoqry.RecordCount >=1  then
              begin

                       try
                          dm.qi_balancedate := adoqry.fieldbyname('BalanceDate').AsString;
                          upfile(mainclass.bankid,'TF',balancedate,tabname,filename,sPath);    //先生成文件后发送报文
                           IdTCPClient1.Host:=mainclass.bankserverip;
                        IdTCPClient1.Port:=mainclass.bankserverport;
                           IdTCPClient1.Disconnect ;
                        if not IdTCPClient1.Connected then
                           IdTCPClient1.Connect(10000);

                        mainclass.WriteLog('filename:'+filename);
                        self.proc1001(adoqry.fieldbyname('bankid').AsString);
                        if termianlpasskeyok<>1 then
                        begin
                            mainclass.WriteerrorLog('发送储值卡退费时向银行取加密因子失败');
                            Continue;
                        end;
                            self.proc1003(adoqry.fieldbyname('bankid').AsString);
                         qrytmp.Close;
                         qrytmp.SQL.Text:='update  pre_cardbackfee set resatus=1,procdesc = '''+filename+ ''',optime='''+formatdatetime('yyyy-mm-dd hh:nn:ss',now)+'''  where BalanceDate='''+adoqry.fieldbyname('BalanceDate').AsString+''' and bankid='+adoqry.fieldbyname('bankid').AsString;
                         qrytmp.ExecSQL;
                         begin
                            self.proc4045(adoqry.fieldbyname('bankid').AsString,adoqry.fieldbyname('balancedate').asstring
                            ,filename,adoqry.fieldbyname('totalcount').asstring
                            ,adoqry.fieldbyname('totalamount').asstring
                            ,tabname,sPath);


                         end ;
                          except on e:exception do
                          begin
                            mainclass.WriteerrorLog('上传储值卡退费异常-2'+e.Message );
                          end;
                         end;

              end;
          end;
//          Sleep(30*1000);
           except on e:exception do
           begin
             dmform.adocn.Connected:=true;
//              mainclass.WriteerrorLog('数据库连接异常储值卡退费'+e.Message );
           end;

         end;

      try
          nowdate:=FormatDateTime('hhmmss',Now());
          if (Copy(nowdate,1,2)>'06') and (Copy(nowdate,1,2)<'20') then
          begin
              balancedate:=formatdatetime('yyyymmdd',now);
                adoqry.SQL.Text:='select top 1 * from ETCBindCardCollectDeductMoneyList_OnLine'
                    +' where (spare1<3 or Spare1 is null) and bankid='''+mainclass.bankid+''' and BalanceDate='''+balancedate+''' and networkid='''+mainclass.NetWorkID+'''';
                adoqry.Active :=true;


               if adoqry.RecordCount >=1  then
              begin

                       try
                         dm.qi_balancedate := adoqry.fieldbyname('BalanceDate').AsString;
                          if mainclass.bankid='3100000' then upfile('3100000','LF',balancedate,tabname,filename,sPath);      //etc联系方式（华夏银行）
                          upfile(mainclass.bankid,'BK',balancedate,tabname,filename,sPath);    //先生成文件后发送报文
                           IdTCPClient1.Host:=mainclass.bankserverip;
                        IdTCPClient1.Port:=mainclass.bankserverport;
                           IdTCPClient1.Disconnect ;
                        if not IdTCPClient1.Connected then
                           IdTCPClient1.Connect(10000);

                        mainclass.WriteLog('filename:'+filename);
                        self.proc1001(adoqry.fieldbyname('bankid').AsString);
                        if termianlpasskeyok<>1 then
                        begin
                            mainclass.WriteerrorLog('发送银行扣费流水时向银行取加密因子失败');
                            Continue;
                        end;
                            self.proc1003(adoqry.fieldbyname('bankid').AsString);

                        if terminalok<>1 then
                        begin
                            mainclass.WriteerrorLog('发送银行扣费流水时向银行签到失败');
                            Continue;
                        end;


                         dm.qi_bz  := adoqry.fieldbyname('spare2').AsString;
                         qrytmp.Close;
                         qrytmp.SQL.Text:='update  ETCBindCardCollectDeductMoneyList_OnLine set spare1=3,procdesc = '''+filename+ ''',optime='''+formatdatetime('yyyy-mm-dd hh:nn:ss',now)+'''  where BalanceDate='''+adoqry.fieldbyname('BalanceDate').AsString+''' and spare2 = '+dm.qi_bz +'and bankid='+adoqry.fieldbyname('bankid').AsString;
                         qrytmp.ExecSQL;

                         if dm.qi_bz = '0' then
                             begin
                                    self.proc4041(adoqry.fieldbyname('bankid').AsString,adoqry.fieldbyname('balancedate').asstring
                                    ,filename,adoqry.fieldbyname('recordcount').asstring
                                    ,adoqry.fieldbyname('totalcount').asstring
                                    ,adoqry.fieldbyname('totalamount').asstring
                                    ,tabname,sPath);
                                     if self.Amessagetype=4042 then
                                     begin
                                        mainclass.writelog('上传扣费流水成功');
                                     end;

                             end
                             else if  dm.qi_bz = '2' then
                             begin
                                    self.proc4043(adoqry.fieldbyname('bankid').AsString
                                    ,adoqry.fieldbyname('balancedate').AsString
                                    ,adoqry.fieldbyname('recordcount').asstring
                                    ,tabname);
                                   qrytmp.Close;
                                   qrytmp.SQL.Clear;
                                   qrytmp.SQL.Text:='update  ETCBoutToBankfile set spare3=3,ynok=''Y'',balancedate=convert(varchar(8),getdate(),112) where convert(varchar(8),createtime,112) <= convert(varchar(8),getdate()-1,112)and TotalToll >0 '
                                    +'  and spare3=2 and ynok=''N'' and bankid = '''+mainclass.bankid +'''';
                                   qrytmp.ExecSQL;
                                     if self.Amessagetype=4044 then
                                     begin
                                        mainclass.writelog('上传打折扣费流水成功');
                                     end;
                             end
                             else if dm.qi_bz='1' then
                             begin
                                   self.proc5041(adoqry.fieldbyname('bankid').AsString,adoqry.fieldbyname('balancedate').asstring
                                  ,adoqry.fieldbyname('recordcount').asstring
                                  ,adoqry.fieldbyname('totalcount').asstring
                                  ,adoqry.fieldbyname('totalamount').asstring
                                 ,tabname);

                                 if self.Amessagetype=5042 then
                                 begin
                                    mainclass.writelog('上传JZF流水成功');
                                 end;
                             end;

                          except on e:exception do
                          begin
                              mainclass.WriteerrorLog('上传扣费流水异常-2'+e.Message );
                          end;
                         end;

              end;

          end;
           //自动解析扣款文件(每天下午五点解析十小时之内的文件)
              nowdate:=FormatDateTime('hhmmss',Now());
              if (Copy(nowdate,1,2)='17') or (Copy(nowdate,1,2)='23') then
              begin
                processlist1:=TProcessList.Create;
                ProcessList1.DbConnected := True;
                if not ProcessList1.DbConnected then Exit;
                ProcessList1.WriteLog('自动解析扣款文件连接数据库成功');
                //1.获取配置文件参数
                ProcessList1.LoadParam;
                //创建上传、下载、日志文件夹
                ProcessList1.CreateYearFolder;
                    try
                        filename:=ProcessList1.Getfilename;
                        ProcessList1.DownLoadFile(filename);
                        ProcessList1.ProcessDownFile(filename);
                        mainclass.WriteLog('文件解析成功！'+filename);
                    except
                        mainclass.WriteLog('文件解析失败！'+filename);
                    end;
                 processlist1.Free;

              end;
      except on e:exception do
           begin
             dmform.adocn.Connected:=true;
//              mainclass.WriteerrorLog('数据库连接send异常--1'+e.Message );
//              Continue;         //数据库断开后自动进入下一轮
           end;

          
      end;

          Sleep(1000*60*1);
    end;
end;



procedure tsendservice.proc1001(bankid:string);
var
    pbankgetkey:TGETPASSWORDKEY;
    pbanksetkey:TsETPASSWORDKEY;
    strtmp:string;
begin

//************************赋值报体内容********************************
    strtmp:=formatdatetime('yyyymmdd',now);
    FillChar(pbankgetkey, sizeof(pbankgetkey), 0);
    copymemory(@pbankgetkey.ProcessDate,pchar(strtmp),8);
    strtmp:=formatdatetime('hhmmss',now);
    copymemory(@pbankgetkey.ProcessTime,pchar(strtmp),6);

//*******************************************************************

    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbankgetkey,SizeOf(pbankgetkey));
    self.sendbody(tmpbuf,'1001',SizeOf(pbankgetkey),bankid);
    if IdTCPClient1.Connected then
    begin
      try
          IdTCPClient1.WriteBuffer(buf,bufsize);
        if IdTCPClient1.Connected then
         begin
          self.readbuf;
         end;
          if (AMessageType=1002) then
          begin
                  FillChar(pbanksetkey,SizeOf(pbanksetkey),0);
                  CopyMemory(@pbanksetkey,@buf,SizeOf(pbanksetkey));
                  if pbanksetkey.ResponseCode='00' then
                  begin
                      mainclass.writelog('获得加密因子的key1:'+mainclass.bytetostr(pbanksetkey.KEY1)+#13+'key2:'+mainclass.bytetostr(pbanksetkey.KEY2));
                      CopyMemory(@Self.key1,@pbanksetkey.key1,8);
                      CopyMemory(@self.key1[8],@pbanksetkey.key2,8);
                      termianlpasskeyok:=1;
                  end
                  else
                      mainclass.writelog(mainclass.errorname(string(pbanksetkey.ResponseCode)));
          end;
      except on e:exception do
          begin
           mainclass.WriteerrorLog('proc1001(bankid:string)获取加密因子失败!!'+e.Message );
           raise;
          end;
         end;
    end
    else
    begin
        mainclass.WriteerrorLog('银行前置机连接失败!!');
    end;



end;


procedure tsendservice.proc1003(bankid: string);
var
    pbankgetqd:TBANKGETQD;
    pbanksetqd:TBANKSETQD;
    strtmp:string;
begin
//********************报体赋值********************************
    strtmp:=formatdatetime('yyyymmdd',now);
    FillChar(pbankgetqd, sizeof(pbankgetqd), 0);
    copymemory(@pbankgetqd.ProcessDate,pchar(strtmp),8);
    strtmp:=formatdatetime('hhmmss',now);
    copymemory(@pbankgetqd.ProcessTime,pchar(strtmp),6);
    copymemory(@pbankgetqd.TerminalID,PChar(mainclass.TerminalID),10);
    copymemory(@pbankgetqd.networkID,PChar(mainclass.NetWorkID),7);
    FillChar(buf,SizeOf(buf),0);
//**************************发报收报处理******************

    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbankgetqd,SizeOf(pbankgetqd));
    self.sendbody(tmpbuf,'1003',SizeOf(pbankgetqd),bankid);
    if IdTCPClient1.Connected then
    begin
      try
          IdTCPClient1.WriteBuffer(buf,bufsize);
          self.readbuf;
          if (AMessageType=1004) then
          begin
                  FillChar(pbanksetqd,SizeOf(pbanksetqd),0);
                  CopyMemory(@pbanksetqd,@buf,SizeOf(pbanksetqd));
                  if pbanksetqd.ResponseCode='00' then
                  begin
                      mainclass.writelog('连接银行'+bankid+'签到成功');
                      terminalok:=1;
                  end
                  else
                      mainclass.writelog(mainclass.errorname(string(pbanksetqd.ResponseCode)));
          end;
      except on e:exception do
          begin
          mainclass.WriteerrorLog('proc1003(bankid: string) 终端签到失败!!');
          raise ;
          end;
      end;
    end
    else
    begin
        mainclass.WriteerrorLog('银行前置机连接失败!!');
    end;

//**********************************************************

end;

procedure Tsendservice.proc4001;
var
      //strtmp:string;
      Ls_processdate,
      Ls_processtime,
      Ls_networkid,
      Ls_TerminalID,
      Ls_BankID,
      Ls_CustomerID,
      Ls_UserType,
      Ls_UserName,
      Ls_CertificateType,
      Ls_CertificateID,
      Ls_PCardNetID,
      Ls_PCardID,
      Ls_EntrustVerifyCode,
      Ls_Vehplate,
      Ls_VehplateColor,
      Ls_VehType,
      Ls_VehSeatNum,
      Ls_WasteSN,
      Ls_BankCardType,
      Ls_BCertificateType,
      Ls_BVCertificateID,
      Ls_ActiveDate,
      Ls_BankCardID,
      Ls_BUserName,
      Ls_OperatorName,
      ls_etc :string;
      tmp_sendsize:integer;
begin
//********************报体赋值********************************
  // ls_etc:=Edit2.Text;    //1449239500002360 
   with adoqry do
   begin
     active:= false;
     sql.text:='select processdate,processtime,networkid, TerminalID,BankID,CustomerID,UserType,UserName,CertificateType,CertificateID,'+
    ' PCardNetID,PCardID,EntrustVerifyCode,Vehplate,VehplateColor,VehType,VehSeatNum,WasteSN,BankCardType,BCertificateType,BVCertificateID,'+
    ' ActiveDate,BankCardID,BUserName,OperatorName  '+
    ' from ETCBankCardBindTab with (nolock) where pcardid = '''+ls_etc+''' and bindstate = ''1'' and optime=select max(optime) from '+
    ' ETCBankCardBindTab with (nolock) where pcardid = '''+ls_etc+'''';
    prepared;
    active:= true;
   end;
  // showmessage(inttostr(adoqry.RecordCount));
   if adoqry.RecordCount = 1 then
   begin
      Ls_processdate:=adoqry.fieldbyname('processdate').AsString ;
      Ls_processtime:=adoqry.fieldbyname('processtime').AsString ;
      Ls_networkid  :=adoqry.fieldbyname('networkid').AsString ;
      Ls_TerminalID :=adoqry.fieldbyname('TerminalID').AsString ;
      Ls_BankID     :=adoqry.fieldbyname('BankID').AsString ;
      Ls_CustomerID :=adoqry.fieldbyname('CustomerID').AsString ;
      Ls_UserType   :=adoqry.fieldbyname('UserType').AsString ;
      Ls_UserName   :=adoqry.fieldbyname('UserName').AsString ;
      Ls_CertificateType:=adoqry.fieldbyname('CertificateType').AsString ;
      Ls_CertificateID  :=adoqry.fieldbyname('CertificateID').AsString ;
      Ls_PCardNetID     :=adoqry.fieldbyname('PCardNetID').AsString ;
      Ls_PCardID        :=adoqry.fieldbyname('PCardID').AsString ;
      Ls_EntrustVerifyCode :=adoqry.fieldbyname('EntrustVerifyCode').AsString ;
      Ls_Vehplate          :=adoqry.fieldbyname('Vehplate').AsString ;
      Ls_VehplateColor     :=adoqry.fieldbyname('VehplateColor').AsString ;
      Ls_VehType           :=adoqry.fieldbyname('VehType').AsString ;
      Ls_VehSeatNum        :=adoqry.fieldbyname('VehSeatNum').AsString ;
      Ls_WasteSN           :=adoqry.fieldbyname('WasteSN').AsString ;
      // ls_wastesn  :='4002251422511220150203143346';
      Ls_BankCardType      :=adoqry.fieldbyname('BankCardType').AsString ;
      Ls_BCertificateType  :=adoqry.fieldbyname('BCertificateType').AsString ;
      Ls_BVCertificateID   :=adoqry.fieldbyname('BVCertificateID').AsString ;
      Ls_ActiveDate        :=adoqry.fieldbyname('ActiveDate').AsString ;
      Ls_BankCardID        :=adoqry.fieldbyname('BankCardID').AsString ;
      Ls_BUserName         :=adoqry.fieldbyname('BUserName').AsString ;
      Ls_OperatorName      :=adoqry.fieldbyname('OperatorName').AsString ;
   end
   else exit;
    FillChar(pbankgetbdcardkh, sizeof(pbankgetbdcardkh), 0);


    copymemory(@pbankgetbdcardkh.ProcessDate,PChar(Ls_processdate),length(Ls_processdate));
    copymemory(@pbankgetbdcardkh.processtime,PChar(Ls_processtime),length(Ls_processtime));
    copymemory(@pbankgetbdcardkh.networkID,PChar(Ls_networkID),length(Ls_networkID));
    copymemory(@pbankgetbdcardkh.TerminalID,PChar(Ls_TerminalID),length(Ls_TerminalID));
    copymemory(@pbankgetbdcardkh.Bankid,PChar(Ls_Bankid),length(Ls_Bankid));
     copymemory(@pbankgetbdcardkh.CustomerID,PChar(Ls_CustomerID),length(Ls_CustomerID));
     copymemory(@pbankgetbdcardkh.UserType,PChar(Ls_UserType),length(Ls_UserType));
     copymemory(@pbankgetbdcardkh.UserName,PChar(Ls_UserName),length(Ls_UserName));
     copymemory(@pbankgetbdcardkh.CertificateType,PChar(Ls_CertificateType),length(Ls_CertificateType));
     copymemory(@pbankgetbdcardkh.CertificateID,PChar(Ls_CertificateID),length(Ls_CertificateID));
    copymemory(@pbankgetbdcardkh.PCardNetID,PChar(Ls_PCardNetID),length(Ls_PCardNetID));
    copymemory(@pbankgetbdcardkh.PCardID,PChar(Ls_PCardID),length(Ls_PCardID));
    copymemory(@pbankgetbdcardkh.EntrustVerifyCode,PChar(Ls_EntrustVerifyCode),length(Ls_EntrustVerifyCode));
    copymemory(@pbankgetbdcardkh.Vehplate,PChar(Ls_Vehplate),length(Ls_Vehplate));
    copymemory(@pbankgetbdcardkh.VehplateColor,PChar(Ls_VehplateColor),length(Ls_VehplateColor));
  //  copymemory(@pbankgetbdcardkh.VehplateColor,PChar(mainclass.padl(Ls_VehplateColor,3,' '),length(Ls_VehplateColor)); 空格填充
     copymemory(@pbankgetbdcardkh.VehType,PChar(Ls_VehType),length(Ls_VehType));
     copymemory(@pbankgetbdcardkh.VehSeatNum,PChar(Ls_VehSeatNum),length(Ls_VehSeatNum));
     copymemory(@pbankgetbdcardkh.WasteSN,PChar(Ls_WasteSN),length(Ls_WasteSN));
     copymemory(@pbankgetbdcardkh.BankCardType,PChar(Ls_BankCardType),length(Ls_BankCardType));
     copymemory(@pbankgetbdcardkh.BCertificateType,PChar(Ls_BCertificateType),length(Ls_BCertificateType));
    copymemory(@pbankgetbdcardkh.BVCertificateID ,PChar(Ls_BVCertificateID ),length(Ls_BVCertificateID));
    copymemory(@pbankgetbdcardkh.ActiveDate ,PChar(Ls_ActiveDate ),length(Ls_ActiveDate));
    copymemory(@pbankgetbdcardkh.BankCardID ,PChar(Ls_BankCardID ),length(Ls_BankCardID));
    copymemory(@pbankgetbdcardkh.BUserName ,PChar(Ls_BUserName ),length(Ls_BUserName));
    copymemory(@pbankgetbdcardkh.OperatorName,PChar(Ls_OperatorName),length(Ls_OperatorName));



//**************************发报收报处理******************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);

    tmp_sendsize:=SizeOf(pbankgetbdcardkh);
    if (Copy(string(pbankgetbdcardkh.networkID),1,2)='31') or (Copy(string(pbankgetbdcardkh.networkID),1,2)='40')
     or (Copy(string(pbankgetbdcardkh.networkID),1,2)='80')  then
        tmp_sendsize:=tmp_sendsize-50;
    CopyMemory(@tmpbuf,@pbankgetbdcardkh,tmp_sendsize);
    if not packset(tmpbuf,'4001',true,tmp_sendsize) then
    begin
        mainclass.WriteerrorLog('数据包处理失败15!!!');
        exit;
    end;
//**********************************************************
    if (AMessageType=4002)then
    begin
        CopyMemory(@pbanksetbdcardkh,@buf,SizeOf(pbanksetbdcardkh));
        mainclass.WriteLog('收到:'+ppackheadreceiver.SenderID+'返回的卡号:'+pbanksetbdcardkh.PCardID+'绑定开户成功:'+pbanksetbdcardkh.ResponseCode );
    end;

end;

procedure TSendservice.proc4011(pcardid,bankid:string);
var
      Ls_processdate,
      Ls_processtime,
      Ls_networkid,
      Ls_TerminalID,
      Ls_BankID,
      Ls_CustomerID,
      Ls_UserType,
      Ls_UserName,
      Ls_CertificateType,
      Ls_CertificateID,
      Ls_PCardNetID,
      Ls_PCardID,
      Ls_EntrustVerifyCode,
      Ls_Vehplate,
      Ls_VehplateColor,
      Ls_VehType,
      Ls_VehSeatNum,
      Ls_WasteSN,
      Ls_BankCardType,
      Ls_BCertificateType,
      Ls_BVCertificateID,
      Ls_ActiveDate,
      Ls_BankCardID,
      Ls_BUserName,
      Ls_OperatorName:string;

begin
//********************报体赋值********************************
  //  ls_etc:=Edit2.Text;    //1449239500002360  //1449239500009617 1449239500009615
   with adoqry do
   begin
     active:= false;
     sql.text:='select top 1 a.processdate,a.processtime,a.networkid, a.TerminalID,a.BankID,a.CustomerID,a.UserType,'+
      ' a.UserName,a.CertificateType,a.CertificateID,'+
      ' a.PCardNetID,a.PCardID,a.EntrustVerifyCode,a.Vehplate,a.VehplateColor,a.VehType,'+
      ' a.VehSeatNum,a.WasteSN,a.BankCardType,a.BCertificateType,a.BVCertificateID,'+
      ' a.ActiveDate,a.BankCardID,a.BUserName,a.OperatorName  '+
      ' from ETCBankCardBindTab a with (nolock)'+
      ' where a.pcardid = '''+pcardid+''' and a.bankid='''+bankid+''' and a.spare2=''待解''';
    prepared;
    active:= true;
   end;
   if adoqry.RecordCount = 1 then
   begin
      Ls_processdate:=adoqry.fieldbyname('processdate').AsString ;
      Ls_processtime:=adoqry.fieldbyname('processtime').AsString ;
      Ls_networkid  :=adoqry.fieldbyname('networkid').AsString ;
      Ls_TerminalID :=adoqry.fieldbyname('TerminalID').AsString ;
      Ls_BankID     :=adoqry.fieldbyname('BankID').AsString ;
      Ls_CustomerID :=adoqry.fieldbyname('CustomerID').AsString ;
      Ls_UserType   :=adoqry.fieldbyname('UserType').AsString ;
      Ls_UserName   :=adoqry.fieldbyname('UserName').AsString ;
      Ls_CertificateType:=adoqry.fieldbyname('CertificateType').AsString ;
      Ls_CertificateID  :=adoqry.fieldbyname('CertificateID').AsString ;
      Ls_PCardNetID     :=adoqry.fieldbyname('PCardNetID').AsString ;
      Ls_PCardID        :=adoqry.fieldbyname('PCardID').AsString ;
      Ls_EntrustVerifyCode :=adoqry.fieldbyname('EntrustVerifyCode').AsString ;
      Ls_Vehplate          :=adoqry.fieldbyname('Vehplate').AsString ;
      Ls_VehplateColor     :=adoqry.fieldbyname('VehplateColor').AsString ;
      Ls_VehType           :=adoqry.fieldbyname('VehType').AsString ;
      Ls_VehSeatNum        :=adoqry.fieldbyname('VehSeatNum').AsString ;
      Ls_WasteSN           :=self.TerminalID+formatdatetime('yyyymmddhhmmss',Now)+'001';
     // ls_wastesn  :='4002503425031220150113093644';
      Ls_BankCardType      :=adoqry.fieldbyname('BankCardType').AsString ;
      Ls_BCertificateType  :=adoqry.fieldbyname('BCertificateType').AsString ;
      Ls_BVCertificateID   :=adoqry.fieldbyname('BVCertificateID').AsString ;
      Ls_ActiveDate        :=adoqry.fieldbyname('ActiveDate').AsString ;
      Ls_BankCardID        :=adoqry.fieldbyname('BankCardID').AsString ;
      Ls_BUserName         :=adoqry.fieldbyname('BUserName').AsString ;
      Ls_OperatorName      :=adoqry.fieldbyname('OperatorName').AsString ;

   end;
   FillChar(pbankgetbdcardxh, sizeof(pbankgetbdcardxh), 0);


    copymemory(@pbankgetbdcardxh.ProcessDate,PChar(mainclass.padr(Ls_processdate,8,' ')),8);
    copymemory(@pbankgetbdcardxh.processtime,PChar(mainclass.padr(Ls_processtime,6,' ')),6);
    copymemory(@pbankgetbdcardxh.networkID,PChar(mainclass.padr(Ls_networkID,7,' ')),7);
    copymemory(@pbankgetbdcardxh.TerminalID,PChar(mainclass.padr(Ls_TerminalID,10,' ')),10);
    copymemory(@pbankgetbdcardxh.Bankid,PChar(mainclass.padr(Ls_Bankid,7,' ')),7);
     copymemory(@pbankgetbdcardxh.CustomerID,PChar(mainclass.padr(Ls_CustomerID,20,' ')),20);
     copymemory(@pbankgetbdcardxh.UserType,PChar(mainclass.padr(Ls_UserType,2,' ')),2);
     copymemory(@pbankgetbdcardxh.UserName,PChar(mainclass.padr(Ls_UserName,100,' ')),100);
     copymemory(@pbankgetbdcardxh.CertificateType,PChar(mainclass.padr(Ls_CertificateType,2,' ')),2);
     copymemory(@pbankgetbdcardxh.CertificateID,PChar(mainclass.padr(Ls_CertificateID,60,' ')),60);
    copymemory(@pbankgetbdcardxh.PCardNetID,PChar(mainclass.padr(Ls_PCardNetID,4,' ')),4);
    copymemory(@pbankgetbdcardxh.PCardID,PChar(mainclass.padr(Ls_PCardID,16,' ')),16);
    copymemory(@pbankgetbdcardxh.EntrustVerifyCode,PChar(mainclass.padr(Ls_EntrustVerifyCode,16,' ')),16);
    copymemory(@pbankgetbdcardxh.Vehplate,PChar(mainclass.padr(Ls_Vehplate,12,' ')),12);
    copymemory(@pbankgetbdcardxh.VehplateColor,PChar(mainclass.padr(Ls_VehplateColor,2,' ')),2);
  //   copymemory(@pbankgetbdcardxh.VehType,PChar(Ls_VehType),SizeOf(pbankgetbdcardxh.VehType));
   //  copymemory(@pbankgetbdcardxh.VehSeatNum,PChar(Ls_VehSeatNum),SizeOf(pbankgetbdcardxh.VehSeatNum));
     copymemory(@pbankgetbdcardxh.WasteSN,PChar(mainclass.padr(Ls_WasteSN,30,' ')),30);
     copymemory(@pbankgetbdcardxh.BankCardType,PChar(mainclass.padr(Ls_BankCardType,2,' ')),2);
     copymemory(@pbankgetbdcardxh.BCertificateType,PChar(mainclass.padr(Ls_BCertificateType,2,' ')),2);
    copymemory(@pbankgetbdcardxh.BVCertificateID ,PChar(mainclass.padr(Ls_BVCertificateID,60,' ')),60);
    copymemory(@pbankgetbdcardxh.ActiveDate ,PChar(mainclass.padr(Ls_ActiveDate,8,' ')),8);
    copymemory(@pbankgetbdcardxh.BankCardID ,PChar(mainclass.padr(Ls_BankCardID,32,' ')),32);
    copymemory(@pbankgetbdcardxh.BUserName ,PChar(mainclass.padr(Ls_BUserName,20,' ')),20);
    copymemory(@pbankgetbdcardxh.OperatorName,PChar(mainclass.padr(Ls_OperatorName,20,' ')),20);

    if IdTCPClient1.Connected then
      begin
        FillChar(tmpbuf,SizeOf(tmpbuf),0);
        CopyMemory(@tmpbuf,@pbankgetbdcardxh,SizeOf(pbankgetbdcardxh));
        self.sendbody(tmpbuf,'4011',sizeOf(pbankgetbdcardxh),mainclass.bankid);
        mainclass.writelog('4011-5');
        try
            IdTCPClient1.WriteBuffer(buf,bufsize);
            readbuf;
            mainclass.writelog('报文类型：'+inttostr(AMessageType));
           if Amessagetype=4012 then
           begin
             FillChar(pbanksetbdcardxh,SizeOf(pbanksetbdcardxh),0);
             CopyMemory(@pbanksetbdcardxh,@buf,SizeOf(pbanksetbdcardxh));
             mainclass.writelog('解绑应答码：'+string(pbanksetbdcardxh.ResponseCode));

            if (Trim(string(pbanksetbdcardxh.ResponseCode))='00' ) then
              begin
                   begin
                    with adoqry do
                    begin
                      sql.Clear;
                      sql.text:='update a set bindstate = ''2'',spare1=17,spare2=''自动销户成功1'', bindendtime=getdate() from ETCBankCardBindTab a '+
                        ' left join ETCCardData b on a.ETCCardID=b.CardID and right(a.Vehplate,6)=right(b.VehiclePlateNo,6) and a.CustomerID=b.CustomerId where b.CardState<>1 and a.spare2=''待解''  and pcardid = '''+pcardid+'''';
                      prepared;
                      ExecSQL;
                      mainclass.WriteLog('更新表ETCBankCardBindTab状态成功');
                    end;
                    {with adoqry do
                    begin
                      sql.Clear;
                      sql.text:='update b set spare1=100,statusoptime=getdate() from ETCBankCardBindTab a '+
                        ' left join ETCCardData b on a.ETCCardID=b.CardID and a.Vehplate=b.VehiclePlateNo and a.CustomerID=b.CustomerId where b.CardState<>1 and a.spare2=''待解'' and pcardid = '''+pcardid+'''';
                      prepared;
                      ExecSQL;
                      mainclass.WriteLog('更新表ETCCardData状态成功');
                    end;  }

                   end;
              end
              else
              begin
                mainclass.WriteerrorLog('卡号:'+pbankgetbdcardxh.PCardID+'绑定销户失败 ：'+string(pbanksetbdcardxh.ResponseCode));
                with adoqry do
                begin
                  active:=false;
                  sql.Clear;
                  sql.text:='update ETCBankCardBindTab set bindstate = ''2'',ResponseCode='''+pbanksetbdcardxh.ResponseCode+''',spare2 = ''已处理1'',spare1=17,bindendtime=getdate() where  pcardid = '''+pcardid+''' and spare2=''待解''';
                  prepared;
                  ExecSQL;
                end;
              end;

           end;
        finally
          { begin
              with adoqry do
              begin
                sql.Clear;
                sql.text:='delete from dbo.PCardBlackList_bank_middle where pcardid='''+pcardid+'''';
                prepared;
                ExecSQL;
              end;
           end; }
        end;
      end
      else
          mainclass.WriteerrorLog('proc4011bank银行前置机连接失败!!');
      IdTCPClient1.Disconnect;
end;

procedure tsendservice.proc4041(bankid,balancedate,filename,Recordnumber,tollcount,tollamount,tabname,sPath: string);
var
    strtmp,strtmp1:string;
    verifycode :string;
//    filename:string;
    ts:TFileStream;
//    sPath: string ;
begin
//*****************************赋值报体内容**************************************************
    try

          FillChar(pbankgetbdkk,SizeOf(pbankgetbdkk),0);
          copymemory(@pbankgetbdkk.networkID,pchar(mainclass.NetWorkID),SizeOf(pbankgetbdkk.networkID));
          copymemory(@pbankgetbdkk.TerminalID,pchar(mainclass.TerminalID),SizeOf(pbankgetbdkk.TerminalID));
          strtmp:=FormatDateTime('yyyymmdd',now);
          copymemory(@pbankgetbdkk.ProcessDate,pchar(strtmp),SizeOf(pbankgetbdkk.ProcessDate));
          copymemory(@pbankgetbdkk.BalanceDate,pchar(strtmp),SizeOf(pbankgetbdkk.BalanceDate));
          copymemory(@pbankgetbdkk.bankid,pchar(bankid),SizeOf(pbankgetbdkk.bankid));

          strtmp1:=FormatDateTime('hhmmss',now);
          copymemory(@pbankgetbdkk.Processtime,pchar(strtmp1),SizeOf(pbankgetbdkk.Processtime));
//          if mainclass.bankid='3100000' then upfile(bankid,'LF',balancedate,tabname,filename,sPath);      //etc联系方式（华夏银行）
//          if upfile(bankid,'BK',balancedate,tabname,filename,sPath) then
//          begin
              ts:=TFileStream.Create( spath,0);
              copymemory(@pbankgetbdkk.filename,pchar(mainclass.padr(filename,SizeOf(pbankgetbdkk.filename),' ')),SizeOf(pbankgetbdkk.filename));
              copymemory(@pbankgetbdkk.RecordNumber,pchar(mainclass.padl(Recordnumber,SizeOf(pbankgetbdkk.RecordNumber),'0')),SizeOf(pbankgetbdkk.RecordNumber));
              copymemory(@pbankgetbdkk.totalcount,pchar(mainclass.padl(tollcount,SizeOf(pbankgetbdkk.totalcount),'0')),SizeOf(pbankgetbdkk.totalcount));
              copymemory(@pbankgetbdkk.totalamount,pchar(mainclass.padl(tollamount,SizeOf(pbankgetbdkk.totalamount),'0')),SizeOf(pbankgetbdkk.totalamount));
              verifycode:= mainclass.getmd5(tstream(ts));
              ts.Destroy ;
              copymemory(@pbankgetbdkk.VerifyCode,pchar(verifycode),SizeOf(pbankgetbdkk.VerifyCode));
//          end;
   except on e:exception do
   begin
       //responsecode:= '09';
        mainclass.WriteerrorLog('proc4041 发送扣款文件报文失败1!!'+e.Message );
        raise;
   end;
   end;

//***************************************************************************************************
      FillChar(tmpbuf,SizeOf(tmpbuf),0);
      mainclass.writelog('4041-2');
      CopyMemory(@tmpbuf,@pbankgetbdkk,SizeOf(pbankgetbdkk));

      self.sendbody(tmpbuf,'4041',SizeOf(pbankgetbdkk),bankid);

      if IdTCPClient1.Connected then
      begin
        try
            IdTCPClient1.WriteBuffer(buf,bufsize);
            mainclass.writelog('4041-3');
            self.readbuf;
            mainclass.writelog('4041-4');
            if Amessagetype=4042 then
            begin
                    CopyMemory(@pBANKSETBDKK,@buf,SizeOf(pBANKSETBDKK));
                    mainclass.writelog('发送4042'+ppackheadReceiver.SenderID+'扣款文件应答码：'+string(pBANKSETBDKK.ResponseCode));
            end;

           // IdTCPClient1.Disconnect;
        except  on e:exception do
           begin
         //  responsecode:= '09';
            mainclass.WriteerrorLog('proc4041 发送扣款文件报文失败!!'+e.Message );
            raise;
           end;
        end;
      end
      else
          mainclass.WriteerrorLog('proc4041bank银行前置机连接失败!!');

end;

procedure tsendservice.proc4045(bankid,balancedate,filename,tollcount,tollamount,tabname,sPath: string);
var
    strtmp,strtmp1:string;
    verifycode :string;
    ts:TFileStream;
begin
//*****************************赋值报体内容**************************************************
    try

          FillChar(pbankgetbdkk,SizeOf(pbankgetbdkk),0);
          copymemory(@pbankgetbdkk.networkID,pchar(mainclass.NetWorkID),SizeOf(pbankgetbdkk.networkID));
          copymemory(@pbankgetbdkk.TerminalID,pchar(mainclass.TerminalID),SizeOf(pbankgetbdkk.TerminalID));
          strtmp:=FormatDateTime('yyyymmdd',now);
          copymemory(@pbankgetbdkk.ProcessDate,pchar(strtmp),SizeOf(pbankgetbdkk.ProcessDate));
          copymemory(@pbankgetbdkk.BalanceDate,pchar(strtmp),SizeOf(pbankgetbdkk.BalanceDate));
          copymemory(@pbankgetbdkk.bankid,pchar(bankid),SizeOf(pbankgetbdkk.bankid));

          strtmp1:=FormatDateTime('hhmmss',now);
          copymemory(@pbankgetbdkk.Processtime,pchar(strtmp1),SizeOf(pbankgetbdkk.Processtime));

          ts:=TFileStream.Create( spath,0);
          copymemory(@pbankgetbdkk.filename,pchar(mainclass.padr(filename,SizeOf(pbankgetbdkk.filename),' ')),SizeOf(pbankgetbdkk.filename));
          copymemory(@pbankgetbdkk.totalcount,pchar(mainclass.padl(tollcount,SizeOf(pbankgetbdkk.totalcount),'0')),SizeOf(pbankgetbdkk.totalcount));
          copymemory(@pbankgetbdkk.totalamount,pchar(mainclass.padl(tollamount,SizeOf(pbankgetbdkk.totalamount),'0')),SizeOf(pbankgetbdkk.totalamount));
          verifycode:= mainclass.getmd5(tstream(ts));
          ts.Destroy ;
          copymemory(@pbankgetbdkk.VerifyCode,pchar(verifycode),SizeOf(pbankgetbdkk.VerifyCode));
   except on e:exception do
   begin
        mainclass.WriteerrorLog('proc4045 发送储值卡退费文件报文失败1!!'+e.Message );
        raise;
   end;
   end;

//***************************************************************************************************
      FillChar(tmpbuf,SizeOf(tmpbuf),0);
      mainclass.writelog('4045-2');
      CopyMemory(@tmpbuf,@pbankgetbdkk,SizeOf(pbankgetbdkk));

      self.sendbody(tmpbuf,'4045',SizeOf(pbankgetbdkk),bankid);

      if IdTCPClient1.Connected then
      begin
        try
            IdTCPClient1.WriteBuffer(buf,bufsize);
            mainclass.writelog('4045-3');
            self.readbuf;
            mainclass.writelog('4045-4');
            if Amessagetype=4046 then
            begin
              CopyMemory(@pBANKSETBDKK,@buf,SizeOf(pBANKSETBDKK));
              mainclass.writelog('发送4046'+ppackheadReceiver.SenderID+'储值卡退费文件应答码：'+string(pBANKSETBDKK.ResponseCode));
              if pBANKSETBDKK.ResponseCode='00' then
               begin
                  qrytmp.Close;
                   qrytmp.SQL.Text:='update a set sendstatus=1,sendtime='''+formatdatetime('yyyy-mm-dd hh:nn:ss',now)+''' from ETCWorknetBusinessReturnMoneyBankInfo_Bank a with (nolock) where convert(varchar,opsystime,112) <= convert(varchar,getdate()-1,112) and returnfee>0 and sendstatus=0 and bankid = '''+mainclass.bankid +'''';
                   qrytmp.ExecSQL;
                  mainclass.writelog('上传储值卡退费流水成功');
               end;
            end;

        except  on e:exception do
           begin
            mainclass.WriteerrorLog('proc4045 发送储值卡退费文件报文失败!!'+e.Message );
            raise;
           end;
        end;
      end
      else
          mainclass.WriteerrorLog('proc4045bank银行前置机连接失败!!');

end;

procedure tsendservice.proc2043(CustomerID,Vehplate,VehplateColor,OrderID,EtccardID,obuno,expressid:string);
var
    strtmp,strtmp1:string;
begin
//*****************************赋值报体内容**************************************************
    try

        FillChar(pbankordersend,SizeOf(pbankordersend),0);
        copymemory(@pbankordersend.networkID,pchar(mainclass.NetWorkID),SizeOf(pbankordersend.networkID));
        copymemory(@pbankordersend.TerminalID,pchar(mainclass.TerminalID),SizeOf(pbankordersend.TerminalID));
        strtmp:=FormatDateTime('yyyymmdd',now);
        copymemory(@pbankordersend.ProcessDate,pchar(strtmp),SizeOf(pbankordersend.ProcessDate));
        strtmp1:=FormatDateTime('hhmmss',now);
        copymemory(@pbankordersend.Processtime,pchar(strtmp1),SizeOf(pbankordersend.Processtime));
        copymemory(@pbankordersend.CustomerID,pchar(mainclass.padr(CustomerID,SizeOf(pbankordersend.CustomerID),' ')),SizeOf(pbankordersend.CustomerID));
        copymemory(@pbankordersend.Vehplate,pchar(mainclass.padr(Vehplate,SizeOf(pbankordersend.Vehplate),' ')),SizeOf(pbankordersend.Vehplate));
        copymemory(@pbankordersend.VehplateColor,pchar(mainclass.padr(VehplateColor,SizeOf(pbankordersend.VehplateColor),' ')),SizeOf(pbankordersend.VehplateColor));
        copymemory(@pbankordersend.OrderID,pchar(mainclass.padr(OrderID,SizeOf(pbankordersend.OrderID),' ')),SizeOf(pbankordersend.OrderID));
        copymemory(@pbankordersend.EtccardID,pchar(mainclass.padr(EtccardID,SizeOf(pbankordersend.EtccardID),' ')),SizeOf(pbankordersend.EtccardID));
        copymemory(@pbankordersend.obuno,pchar(mainclass.padr(obuno,SizeOf(pbankordersend.obuno),' ')),SizeOf(pbankordersend.obuno));
        copymemory(@pbankordersend.expressid,pchar(mainclass.padr(expressid,SizeOf(pbankordersend.expressid),' ')),SizeOf(pbankordersend.expressid));
   except on e:exception do
   begin
       //responsecode:= '09';
        mainclass.WriteerrorLog('proc2043 发送银行订单报文失败1!!'+e.Message );
        raise;
   end;
   end;

//***************************************************************************************************
      FillChar(tmpbuf,SizeOf(tmpbuf),0);
      CopyMemory(@tmpbuf,@pbankordersend,SizeOf(pbankordersend));
      self.sendbody(tmpbuf,'2043',SizeOf(pbankordersend),adoqry.fieldbyname('bankid').asstring);

      if IdTCPClient1.Connected then
      begin
        try
            IdTCPClient1.WriteBuffer(buf,bufsize);

            self.readbuf;

            if Amessagetype=2044 then
            begin
              CopyMemory(@pbankordersendresponse,@buf,SizeOf(pbankordersendresponse));
              qrytmp.Close;
               qrytmp.SQL.Clear;
               qrytmp.SQL.Text:='update  bankorder set responseCode='''+string(pbankordersendresponse.ResponseCode)+''' where orderid='''+pchar(OrderID)+''' and networkid = '''+mainclass.NetWorkID +'''';
               mainclass.WriteLog(qrytmp.SQL.Text);
               qrytmp.ExecSQL;
                 if self.Amessagetype=2044 then
                 begin
                    mainclass.writelog('上传银行订单成功');
                 end;
              mainclass.writelog('发送2043'+ppackheadReceiver.SenderID+'用户订单发货请求报文应答码：'+string(pbankordersendresponse.ResponseCode));
            end;

        except  on e:exception do
           begin
         //  responsecode:= '09';
            mainclass.WriteerrorLog('proc2043 发送用户订单发货请求报文失败!!'+e.Message );
            raise;
           end;
        end;
      end
      else
          mainclass.WriteerrorLog('proc2043bank银行前置机连接失败!!');

end;

procedure tsendservice.proc4043(bankid,balancedate,Recordnumber,tabname: string);
var
    strtmp,strtmp1:string;
    verifycode :string;
    filename:string;
    remark:string;
    ts:TFileStream;
    // sYear,sMonth,sDay:Word;
    sPath: string ;
begin
//*****************************赋值报体内容**************************************************
    try

          FillChar(pbankgetDZKKFSTZ,SizeOf(pbankgetDZKKFSTZ),0);
          copymemory(@pbankgetDZKKFSTZ.networkID,pchar(mainclass.NetWorkID),SizeOf(pbankgetDZKKFSTZ.networkID));
          copymemory(@pbankgetDZKKFSTZ.TerminalID,pchar(mainclass.TerminalID),SizeOf(pbankgetDZKKFSTZ.TerminalID));
          strtmp:=FormatDateTime('yyyymmdd',now);
          copymemory(@pbankgetDZKKFSTZ.ProcessDate,pchar(strtmp),SizeOf(pbankgetDZKKFSTZ.ProcessDate));
          copymemory(@pbankgetDZKKFSTZ.bankid,pchar(bankid),SizeOf(pbankgetDZKKFSTZ.bankid));

          strtmp1:=FormatDateTime('hhmmss',now);
          copymemory(@pbankgetDZKKFSTZ.Processtime,pchar(strtmp1),SizeOf(pbankgetDZKKFSTZ.Processtime));
          if upfile(bankid,'DZ',balancedate,tabname,filename,sPath) then
          begin
              ts:=TFileStream.Create( spath,0);
              copymemory(@pbankgetDZKKFSTZ.filename,pchar(mainclass.padr(filename,SizeOf(pbankgetDZKKFSTZ.filename),' ')),SizeOf(pbankgetDZKKFSTZ.filename));
              copymemory(@pbankgetDZKKFSTZ.remark,pchar(mainclass.padr(remark,SizeOf(pbankgetDZKKFSTZ.remark),' ')),SizeOf(pbankgetDZKKFSTZ.remark));
              copymemory(@pbankgetDZKKFSTZ.RecordNumber,pchar(mainclass.padl(Recordnumber,SizeOf(pbankgetDZKKFSTZ.RecordNumber),'0')),SizeOf(pbankgetDZKKFSTZ.RecordNumber));
              verifycode:= mainclass.getmd5(tstream(ts));
              ts.Destroy ;
              copymemory(@pbankgetDZKKFSTZ.VerifyCode,pchar(verifycode),SizeOf(pbankgetDZKKFSTZ.VerifyCode));
          end;
   except on e:exception do
   begin
       //responsecode:= '09';
        mainclass.WriteerrorLog('proc4043 发送打折扣款文件报文失败1!!'+e.Message );
        raise;
   end;
   end;

//***************************************************************************************************
      FillChar(tmpbuf,SizeOf(tmpbuf),0);
      CopyMemory(@tmpbuf,@pbankgetDZKKFSTZ,SizeOf(pbankgetDZKKFSTZ));
      self.sendbody(tmpbuf,'4043',SizeOf(pbankgetDZKKFSTZ),adoqry.fieldbyname('bankid').asstring);
      if IdTCPClient1.Connected then
      begin
        try
            IdTCPClient1.WriteBuffer(buf,bufsize);

            if IdTCPClient1.Connected then
            begin
              self.readbuf;
            end;

            if Amessagetype=4044 then
            begin
                    CopyMemory(@pbanksetDZKKFSTZ,@buf,SizeOf(pbanksetDZKKFSTZ));
                    mainclass.writelog('发送4043'+ppackheadReceiver.SenderID+'打折扣款文件应答码：'+string(pbanksetDZKKFSTZ.ResponseCode));
            end;

           // IdTCPClient1.Disconnect;
        except  on e:exception do
           begin
         //  responsecode:= '09';
            mainclass.WriteerrorLog('proc4043 发送打折扣款文件报文失败!!'+e.Message );
            raise;
           end;
        end;
      end
      else
          mainclass.WriteerrorLog('proc4043bank银行前置机连接失败!!');

end;

procedure tsendservice.proc5009(bankid,balancedate,Recordnumber,tabname: string);
var
    strtmp,strtmp1:string;
    verifycode :string;
    filename:string;
    remark:string;
    ts:TFileStream;
    // sYear,sMonth,sDay:Word;
    sPath: string ;
begin
//*****************************赋值报体内容**************************************************
    try

          FillChar(pBANKGETSECONDRELEASEERRORKEY,SizeOf(pBANKGETSECONDRELEASEERRORKEY),0);
          copymemory(@pBANKGETSECONDRELEASEERRORKEY.networkID,pchar(mainclass.NetWorkID),SizeOf(pBANKGETSECONDRELEASEERRORKEY.networkID));
          copymemory(@pBANKGETSECONDRELEASEERRORKEY.TerminalID,pchar(mainclass.TerminalID),SizeOf(pBANKGETSECONDRELEASEERRORKEY.TerminalID));
          strtmp:=FormatDateTime('yyyymmdd',now);
          copymemory(@pBANKGETSECONDRELEASEERRORKEY.ProcessDate,pchar(strtmp),SizeOf(pBANKGETSECONDRELEASEERRORKEY.ProcessDate));
          copymemory(@pBANKGETSECONDRELEASEERRORKEY.bankid,pchar(bankid),SizeOf(pBANKGETSECONDRELEASEERRORKEY.bankid));

          strtmp1:=FormatDateTime('hhmmss',now);
          copymemory(@pBANKGETSECONDRELEASEERRORKEY.Processtime,pchar(strtmp1),SizeOf(pBANKGETSECONDRELEASEERRORKEY.Processtime));
          if upfile(bankid,'YC',balancedate,tabname,filename,sPath) then
          begin
              ts:=TFileStream.Create( spath,0);
              copymemory(@pBANKGETSECONDRELEASEERRORKEY.filename,pchar(mainclass.padr(filename,SizeOf(pBANKGETSECONDRELEASEERRORKEY.filename),' ')),SizeOf(pBANKGETSECONDRELEASEERRORKEY.filename));
              copymemory(@pBANKGETSECONDRELEASEERRORKEY.remark,pchar(mainclass.padr(remark,SizeOf(pBANKGETSECONDRELEASEERRORKEY.remark),' ')),SizeOf(pBANKGETSECONDRELEASEERRORKEY.remark));
              copymemory(@pBANKGETSECONDRELEASEERRORKEY.RecordNumber,pchar(mainclass.padl(Recordnumber,SizeOf(pBANKGETSECONDRELEASEERRORKEY.RecordNumber),'0')),SizeOf(pBANKGETSECONDRELEASEERRORKEY.RecordNumber));
              verifycode:= mainclass.getmd5(tstream(ts));
              ts.Destroy ;
              copymemory(@pBANKGETSECONDRELEASEERRORKEY.VerifyCode,pchar(verifycode),SizeOf(pBANKGETSECONDRELEASEERRORKEY.VerifyCode));
          end;
   except on e:exception do
   begin
       //responsecode:= '09';
        mainclass.WriteerrorLog('proc5009 发送二发异常文件报文失败1!!'+e.Message );
        raise;
   end;
   end;

//***************************************************************************************************
      FillChar(tmpbuf,SizeOf(tmpbuf),0);
      CopyMemory(@tmpbuf,@pBANKGETSECONDRELEASEERRORKEY,SizeOf(pBANKGETSECONDRELEASEERRORKEY));
      self.sendbody(tmpbuf,'5009',SizeOf(pBANKGETSECONDRELEASEERRORKEY),adoqry.fieldbyname('bankid').asstring);
      if IdTCPClient1.Connected then
      begin
        try
            IdTCPClient1.WriteBuffer(buf,bufsize);
             mainclass.writelog('5009-5');

            self.readbuf;
             mainclass.writelog('5009-6');
            if Amessagetype=5010 then
            begin
                    CopyMemory(@pBANKSETSECONDRELEASEERRORRESULT,@buf,SizeOf(pBANKSETSECONDRELEASEERRORRESULT));
                    mainclass.writelog('bank5009发送到'+ppackheadReceiver.SenderID+'二发异常文件报文发送成功');
            end;

           // IdTCPClient1.Disconnect;
        except  on e:exception do
           begin
         //  responsecode:= '09';
            mainclass.WriteerrorLog('proc5009 发送二发异常文件报文失败!!'+e.Message );
            raise;
           end;
        end;
      end
      else
          mainclass.WriteerrorLog('proc5009bank银行前置机连接失败!!');

end;


procedure tsendservice.proc5003(tabname:string;bankid:string;ProcessDate:string;Recordnumber:string;cardnobegin,cardnoend:string);
var
    cardno,strtmp,strtmp1:string;
    verifycode :string;

    ts:TFileStream;
    sPath: string ;
    filename:string;
    remark:string;
   // ini:tinifile;
begin
//*****************************赋值报体内容**************************************************
    try


          FillChar(pBANKGETONERELEASEKEY,SizeOf(pBANKGETONERELEASEKEY),0);
          copymemory(@pBANKGETONERELEASEKEY.NetWorkID,pchar(mainclass.NetWorkID),SizeOf(pBANKGETONERELEASEKEY.networkID));
          copymemory(@pBANKGETONERELEASEKEY.TerminalID,pchar(mainclass.TerminalID),SizeOf(pBANKGETONERELEASEKEY.TerminalID));
          strtmp:=FormatDateTime('yyyymmdd',now);
          copymemory(@pBANKGETONERELEASEKEY.ProcessDate,pchar(strtmp),SizeOf(pBANKGETONERELEASEKEY.ProcessDate));
          copymemory(@pBANKGETONERELEASEKEY.bankid,pchar(bankid),SizeOf(pBANKGETONERELEASEKEY.bankid));

          strtmp1:=FormatDateTime('hhmmss',now);
          copymemory(@pBANKGETONERELEASEKEY.Processtime,pchar(strtmp1),SizeOf(pBANKGETONERELEASEKEY.Processtime));
           mainclass.writelog('5003-1');

          if upfile(bankid,'Y2',ProcessDate,tabname,filename,sPath) then     //y2 一发密钥结果文件
      begin
         if dmform.adocn.Connected = true then
         begin
           adoqry.Active:=False;
           adoqry.SQL.Text:=' select bankid,cardno FROM   dbo.ETCBankCardOneReleaseKey where filename='''+tabname+''' and bankid = '''+mainclass.bankid +'''';
           adoqry.Active:=True;
           with adoqry do
           begin
               First;
               while not eof do
               begin
                cardno:='1401'+fieldbyname('cardno').asstring;
                if mainclass.bdatabaseconnect then
                    begin
                        with adosp do
                        begin
                          close;
                          ProcedureName:='USP_CalKeyOperateStock';
                          Parameters.Clear;
                          Parameters.CreateParameter('@OperatorNO',ftstring,pdInput,50,string('123456'));
                          Parameters.CreateParameter('@NetWorkNO',ftString,pdInput,7,string(pBANKGETONERELEASEKEY.BankID));
                          Parameters.CreateParameter('@CardNO',ftString,pdInput,50,string(CardNO));
                          Parameters.CreateParameter('@bankID',ftString,pdInput,7,string(pBANKGETONERELEASEKEY.BankID));
                          Parameters.CreateParameter('@ErrorID',ftstring,pdoutput,2,-2);
                          Parameters.CreateParameter('@Errormsg',ftstring,pdoutput,100,-100);
                          ExecProc;
                     end;
                  end;
                Next;
                end;
           end;
         end;
       end;
      mainclass.writelog('5003-2');
      ts:=TFileStream.Create( spath,0);
      copymemory(@pBANKGETONERELEASEKEY.filename,pchar(mainclass.padr(filename,SizeOf(pBANKGETONERELEASEKEY.filename),' ')),SizeOf(pBANKGETONERELEASEKEY.filename));
      copymemory(@pBANKGETONERELEASEKEY.RecordNumber,pchar(mainclass.padl(Recordnumber,SizeOf(pBANKGETONERELEASEKEY.RecordNumber),'0')),SizeOf(pBANKGETONERELEASEKEY.RecordNumber));
      copymemory(@pBANKGETONERELEASEKEY.Cardnobegin,pchar(mainclass.padl(cardNobegin,SizeOf(pBANKGETONERELEASEKEY.Cardnobegin),'0')),SizeOf(pBANKGETONERELEASEKEY.Cardnobegin));
      copymemory(@pBANKGETONERELEASEKEY.Cardnoend,pchar(mainclass.padl(cardnoend,SizeOf(pBANKGETONERELEASEKEY.cardnoend),'0')),SizeOf(pBANKGETONERELEASEKEY.cardnoend));
      copymemory(@pBANKGETONERELEASEKEY.remark,pchar(mainclass.padl(remark,SizeOf(pBANKGETONERELEASEKEY.remark),'11111')),SizeOf(pBANKGETONERELEASEKEY.remark));
      verifycode:= mainclass.getmd5(tstream(ts));
      ts.Destroy ;
      copymemory(@pBANKGETONERELEASEKEY.VerifyCode,pchar(verifycode),SizeOf(pBANKGETONERELEASEKEY.VerifyCode));
//***************************************************************************************************
      FillChar(tmpbuf,SizeOf(tmpbuf),0);
      CopyMemory(@tmpbuf,@pBANKGETONERELEASEKEY,SizeOf(pBANKGETONERELEASEKEY));
      self.sendbody(tmpbuf,'5003',SizeOf(pBANKGETONERELEASEKEY),adoqry.fieldbyname('bankid').asstring);
          mainclass.writelog('5003-3');

        try
         // ini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'control.ini');
            IdTCPClient1.Host:=mainclass.bankserverip;
            IdTCPClient1.Port:=mainclass.bankserverport;
//               IdTCPClient1.Disconnect ;
            if not IdTCPClient1.Connected then
               IdTCPClient1.Connect(10000);
              if IdTCPClient1.Connected then
              begin
                    IdTCPClient1.WriteBuffer(buf,bufsize);
                     mainclass.writelog('5003-5');
                 if IdTCPClient1.Connected then
                   begin
                    self.readbuf;
                   end;
                     mainclass.writelog('5003-6');
                    if Amessagetype=5004 then
                    begin
                            CopyMemory(@pBANKSETONERELEASERESULT,@buf,SizeOf(pBANKSETONERELEASERESULT));
                            mainclass.writelog('bank5004发送到'+ppackheadReceiver.SenderID+'一发密钥文件报文发送成功');
                            self.adoqry.Close;
                            self.adoqry.SQL.Text:='update dbo.ETCBankCardOneReleaseKeyparent set status=1 where ltrim(filename)='''+tabname+'''';
                            self.adoqry.ExecSQL;
                            strtmp:='update keyapplytab set revtime=getdate(),revstatus=1 where applycodebegin='''
                            +pBANKGETONERELEASEKEY.Cardnobegin
                            +''' and applycodeend='''+pBANKGETONERELEASEKEY.CardnoEnd+''' and ApplyUnit='''+mainclass.bankid+'''';
                            with self.adoqry do
                               begin
                                   close;
                                   sql.text:=strtmp;
                                   ExecSQL;
                               end;
                    end;
              end
              else
                  mainclass.WriteerrorLog('proc5003bank银行前置机连接失败!!');

           // IdTCPClient1.Disconnect;
        except  on e:exception do
           begin
         //  responsecode:= '09';
             strtmp:='update keyapplytab set revtime=getdate(),revstatus=2 where applycodebegin='''
             +pBANKGETONERELEASEKEY.CardnoBegin
             +''' and applycodeend='''+pBANKGETONERELEASEKEY.CardnoEnd+''' and ApplyUnit='''+mainclass.bankid+'''';
            with self.adoqry do
             begin
                 close;
                 sql.text:=strtmp;
                 ExecSQL;
             end;
            mainclass.WriteerrorLog('proc5003 发送一发密钥文件报文失败!!'+e.Message );
            raise;
           end;
        end;
      except on e:exception do
     begin
         //responsecode:= '09';
          mainclass.WriteerrorLog('proc5003 发送一发密钥文件报文失败1!!'+e.Message );
          raise;
     end;
   end;

end;

 procedure tsendservice.proc5041(bankid,balancedate,Recordnumber,tollcount,tollamount,tabname: string);
var
    strtmp,strtmp1:string;
    verifycode :string;
    filename:string;
    ts:TFileStream;
   //  sYear,sMonth,sDay:Word;
    sPath: string ;
begin
//*****************************赋值报体内容**************************************************
    try

          FillChar(pbankgetbdJZF,SizeOf(pbankgetbdJZF),0);
          copymemory(@pbankgetbdJZF.networkID,pchar(mainclass.NetWorkID),SizeOf(pbankgetbdJZF.networkID));
          copymemory(@pbankgetbdJZF.TerminalID,pchar(mainclass.TerminalID),SizeOf(pbankgetbdJZF.TerminalID));
          strtmp:=FormatDateTime('yyyymmdd',now);
          copymemory(@pbankgetbdJZF.ProcessDate,pchar(strtmp),SizeOf(pbankgetbdJZF.ProcessDate));
          copymemory(@pbankgetbdJZF.BalanceDate,pchar(strtmp),SizeOf(pbankgetbdJZF.BalanceDate));
          copymemory(@pbankgetbdJZF.bankid,pchar(bankid),SizeOf(pbankgetbdJZF.bankid));

          strtmp1:=FormatDateTime('hhmmss',now);
          copymemory(@pbankgetbdJZF.Processtime,pchar(strtmp1),SizeOf(pbankgetbdJZF.Processtime));
           mainclass.writelog('5041-1');
          if upfile(bankid,'JZ',balancedate,tabname,filename,sPath) then
          begin
           mainclass.writelog('5041-2');
              ts:=TFileStream.Create( spath,0);
              copymemory(@pbankgetbdJZF.filename,pchar(mainclass.padr(filename,SizeOf(pbankgetbdJZF.filename),' ')),SizeOf(pbankgetbdJZF.filename));
              copymemory(@pbankgetbdJZF.RecordNumber,pchar(mainclass.padl(Recordnumber,SizeOf(pbankgetbdJZF.RecordNumber),'0')),SizeOf(pbankgetbdJZF.RecordNumber));
              copymemory(@pbankgetbdJZF.totalcount,pchar(mainclass.padl(tollcount,SizeOf(pbankgetbdJZF.totalcount),'0')),SizeOf(pbankgetbdJZF.totalcount));
              copymemory(@pbankgetbdJZF.totalamount,pchar(mainclass.padl(tollamount,SizeOf(pbankgetbdJZF.totalamount),'0')),SizeOf(pbankgetbdJZF.totalamount));
              verifycode:= mainclass.getmd5(tstream(ts));
              ts.Destroy ;
              copymemory(@pbankgetbdJZF.VerifyCode,pchar(verifycode),SizeOf(pbankgetbdJZF.VerifyCode));
          end;
   except on e:exception do
   begin
       //responsecode:= '09';
        mainclass.WriteerrorLog('proc5041 发送JZF扣款文件报文失败1!!'+e.Message );
        raise;
   end;
   end;

//***************************************************************************************************
      FillChar(tmpbuf,SizeOf(tmpbuf),0);
      CopyMemory(@tmpbuf,@pbankgetbdJZF,SizeOf(pbankgetbdJZF));
      self.sendbody(tmpbuf,'5041',SizeOf(pbankgetbdJZF),adoqry.fieldbyname('bankid').asstring);
          mainclass.writelog('5041-3');
      if IdTCPClient1.Connected then
      begin
        try
            IdTCPClient1.WriteBuffer(buf,bufsize);
             mainclass.writelog('5041-5');

            self.readbuf;
             mainclass.writelog('5041-6');
            if Amessagetype=5042 then
            begin
                    CopyMemory(@pbanksetbdJZF,@buf,SizeOf(pbanksetbdJZF));
                    mainclass.writelog('bank5042发送到'+ppackheadReceiver.SenderID+'JZF扣款文件报文发送成功');
            end;

           // IdTCPClient1.Disconnect;
        except  on e:exception do
           begin
         //  responsecode:= '09';
            mainclass.WriteerrorLog('proc5041 发送JZF扣款文件报文失败!!'+e.Message );
            raise;
           end;
        end;
      end
      else
          mainclass.WriteerrorLog('proc5041bank银行前置机连接失败!!');

end;

procedure tsendservice.readbuf;
var ilength:integer;
//li_len:integer;
begin
            FillChar(buf,SizeOf(buf),0);
            try
            self.IdTCPClient1.ReadBuffer(headbuf,SizeOf(ppackheadReceiver));
            except on e:exception do
                begin
              //  responsecode:= '09';
                mainclass.WriteerrorLog('tsendservice.readbuf'+e.Message );
                raise;
                end;
            end;
              FillChar(ppackheadReceiver,SizeOf(ppackheadReceiver),0);
              CopyMemory(@ppackheadReceiver,@headbuf,SizeOf(ppackheadReceiver));
            try
                 AMessageType := StrToInt(ppackheadReceiver.MessageType) ;
            except
                 AMessageType:=0;
            end;
         ilength:=mainclass.inttobigint(ppackheadReceiver.MessageLength);
         if  (AMessageType<>4044)  then
         try
          self.IdTCPClient1.ReadBuffer(buf,ilength-SizeOf(ppackheadReceiver));
          except on e:exception do
                begin
               // responsecode:= '09';
                mainclass.WriteerrorLog('tsendservice.readbuf 2'+e.Message );
                raise;
                end;
            end;

//****************************************解密报体内容*********************************************************
       if AMessageType=1002 then
       begin

           mainclass.strtobyte(key1,mainclass.defaultkey,1);
       end;
       btsize:=ilength-sizeof(ppackheadReceiver);
       SetLength(indata,btsize);
       btsendsize:=(btsize div 8+1)*8;
       SetLength(outdata,btsendsize);
       Move(buf,indata[0],btsize);
       mainclass.Decryptbcb(key1,indata,outdata);
       mainclass.WriteLog('接收到消息类型'+IntToStr(AMessageType)+'的密码为：'+mainclass.arraytostr(outdata));
       mainclass.WriteLog('加密因子为:'+mainclass.arraytostr(key1));
       mainclass.WriteLog('接收到消息类型'+IntToStr(AMessageType)+'的明码为：'+mainclass.arraytostr1(outdata));

       setlength(outdata,length(outdata)-outdata[high(outdata)]);
       mainclass.dbuftobuf(outdata,buf,0);

{             mainclass.Decryptbcb(key1,indata,outdata);
             STRTMP:='解密后码为outdata:'+MAINCLASS.arraytostr1(outdata)+'解密因子为:'+MAINCLASS.arraytostr(Key1)+'';

             mainclass.WriteLog(STRTMP);
             li_len:= length(outdata)-outdata[high(outdata)];


//             li_len1:=  length(outdata);
//             li_len2:=outdata[high(outdata)];
//              STRTMP:='解密后码为li_len:'+inttostr(li_len)+'        li_len1:' +inttostr(li_len1)+'        li_len2:'+inttostr(li_len2);

             mainclass.WriteLog(STRTMP);
             setlength(outdata,li_len);
//             recivelength:=Length(outdata);
}
end;

procedure tsendservice.readbufbody;
var ilength:integer;
   // li_length:integer;
begin
    ilength:=0;
    try
            FillChar(buf,SizeOf(buf),0);
          //  li_length:=SizeOf(ppackheadReceiver);
            IdTCPClient1.ReadBuffer(bufhead,SizeOf(ppackheadReceiver));
            FillChar(ppackheadReceiver,SizeOf(ppackheadReceiver),0);
            CopyMemory(@ppackheadReceiver,@bufhead,SizeOf(ppackheadReceiver));
            try
                 AMessageType := StrToInt(ppackheadReceiver.MessageType) ;
            except
                 AMessageType:=0;
            end;
         ilength:=mainclass.inttobigint(ppackheadReceiver.MessageLength);
         IdTCPClient1.ReadBuffer(buf,ilength-SizeOf(ppackheadReceiver));
//          writedebuglog('ilength-- '+inttostr(ilength)+'ppackheadReceiver-- '+inttostr(SizeOf(ppackheadReceiver)));
      except on e:exception do
      begin
         responsecode:='09';
         mainclass.WriteerrorLog('readbufbank接受银行'+inttostr(AMessageType)+'时异常'+e.Message );
         mainclass.WriteerrorLog('readbufbank接受银行'+inttostr(AMessageType)+'时异常'+e.Message );

      end;
      end;
//****************************************解密报体内容*********************************************************
//       writedebuglog('使用加密因子'+mainclass.arraytostr(keybank)+inttostr(AMessageType));

       if AMessageType=1002 then
       begin

           mainclass.strtobyte(keybank,mainclass.defaultkey,1);
       end;
       btsize:=ilength-sizeof(ppackheadReceiver);
       SetLength(indata,btsize);
       btsendsize:=(btsize div 8+1)*8;
       SetLength(outdata,btsendsize);
       Move(buf,indata[0],btsize);
       //mainclass.WriteLog('接收银行数据'+inttostr(AMessageType)+'的密码为'+mainclass.arraytostr(indata));
       mainclass.Decryptbcb(keybank,indata,outdata);
       mainclass.WriteLog('接收银行数据'+inttostr(AMessageType)+'的明码为'+mainclass.arraytostr1(outdata));
       mainclass.WriteLog('使用加密因子'+mainclass.arraytostr(keybank));
       setlength(outdata,length(outdata)-outdata[high(outdata)]);
       mainclass.dbuftobuf(outdata,buf,0);

end;


function tsendservice.sendbody(abyte: array of byte; strmsglx: string;
  isize: integer;bankid:string): boolean;
var
    strtmp:string;
begin
  try
  if strmsglx='1001' then
    mainclass.strtobyte(key1,mainclass.defaultkey,1);
//****************加密相报体******************************
    btsize:=isize;
    SetLength(indata,btsize);
    CopyMemory(@indata[0],@abyte,btsize);
    btsendsize:=(btsize div 8+1)*8;
    SetLength(outdata,btsendsize);
    mainclass.Encryptbcb(key1,indata,outdata);
    bufsize:=SizeOf(ppackheadsend)+btsendsize;
//****************加密相报体******************************

//*******************************报文头赋值
    strtmp:=mainclass.getmd5(string(indata));
        mainclass.writelog('消息类型'+strmsglx+' tsendservice.sendbody明码为'+mainclass.arraytostr1(indata));
//    bufsize:=SizeOf(ppackhead)+bsize;
    ppackheadsend.MessageLength:=mainclass.inttobigint(bufsize);
    copymemory(@ppackheadsend.MessageType,pchar(strmsglx),4);
//    strtmpid:=ppackhead.ReceiverID;
    copymemory(@ppackheadsend.SenderID,pchar(mainclass.nodeid),7);
    copymemory(@ppackheadsend.VerifyCode,pchar(strtmp),Length(strtmp));
    copymemory(@ppackheadsend.ReceiverID,pchar(bankid),7);
    bufsize:=SizeOf(ppackheadsend)+btsendsize;
//*********************************************************
        mainclass.writelog('消息类型'+strmsglx+' tsendservice.sendbody加密因子'+mainclass.arraytostr(key1));

//*****************拼报文内容*******************************
    fillchar(buf,sizeof(buf),0);
    CopyMemory(@buf,@ppackheadsend,SizeOf(ppackheadsend));
    //  mainclass.writelog('消息类型'+strmsglx+' 包头为'+mainclass.arraytostr(buf));
    mainclass.writelog('消息类型'+strmsglx);
    mainclass.dbuftobuf(outdata,buf,SizeOf(ppackheadsend));
    //  mainclass.writelog('消息类型'+strmsglx+' tsendservice.sendbody密码为'+mainclass.arraytostr(outdata));

      except  on e:exception    do
     // responsecode:= '09';
           mainclass.writelog('消息类型'+strmsglx+' tsendservice.sendbody发送异常:'+e.Message );
      end;
    Result:=True;
end;

 function TSendservice.packset( invarray:array of byte;strmsglx:string;readbuf:boolean;isize:integer): Boolean;
var
    strtmp:string;
begin
    result:=false;
    FillChar(buf,SizeOf(buf),0);
    AMessageType:=StrToInt(strmsglx);
//****************加密报体******************************
if AMessageType=1001 then
begin
    mainclass.strtobyte(key1,mainclass.defaultkey,1);
end;
    btsize:=isize;
    SetLength(indata,btsize);
    CopyMemory(@indata[0],@invarray,btsize);
    btsendsize:=(btsize div 8+1)*8;
    SetLength(outdata,btsendsize);
    mainclass.Encryptbcb(key1,indata,outdata);

//****************加密报体******************************
    mainclass.writelog('发送类型：'+inttostr(AMessageType)+'明码为:'+MAINCLASS.arraytostr1(indata)) ;
    //mainclass.writelog('发送类型：'+inttostr(AMessageType)+'密码为：:'+MAINCLASS.arraytostr(indata));
    mainclass.writelog('加密因子：'+MAINCLASS.arraytostr1(key1)+'加密因子:'+MAINCLASS.arraytostr(key1));
//*******************************包头赋值
    self.headset(ppackheadsend,btsendsize,strmsglx,mainclass.getmd5(string(indata)));
//*********************************************************


//*****************拼报文内容*******************************
    CopyMemory(@buf,@ppackheadsend,SizeOf(ppackheadsend));
    mainclass.dbuftobuf(outdata,buf,SizeOf(ppackheadsend));
//************************************************************
    bufsize:=SizeOf(ppackheadsend)+btsendsize;
    try
    begin
        if not IdTCPClient1.Connected then
        // showmessage(IdTCPClient1.Host );
           IdTCPClient1.Connect(5000);
           strtmp:=mainclass.arraytostr1(buf);
        //   mainclass.WriteLog(strtmp);
           self.IdTCPClient1.WriteBuffer(buf,bufsize,true);
           self.readbuf;
           result:=True;
    end;
    except on e:EXCEPTION do
         mainclass.WriteLog('包处理失败!!!'+e.Message);
    end;

end;

procedure TSendservice.headset(var ppackhead:Tetcbankhead;bsize:integer;strmsg:string;strmd5code:string);
var
    bufsize:integer;

begin
    FillChar(ppackhead, sizeof(ppackhead), 0);
    bufsize:=sizeof(ppackhead)+bsize;
    ppackhead.MessageLength:=mainclass.inttobigint(bufsize);
{    copymemory(ppackhead.ReceiverID,'1400000',7);
    copymemory(ppackhead.SenderID,networkid,7);
    copymemory(ppackhead.MessageType,strmsg,4);
//    copymemory(ppackhead.MessageType,strmsg,4);
    copymemory(ppackhead.VerifyCode,strmd5code,32);
}
    CopyMemory(@ppackhead.MessageType,PChar(strmsg),4);
    CopyMemory(@ppackhead.ReceiverID,PChar('1400000'),7);
    CopyMemory(@ppackhead.SenderID,PChar(networkid),7);

//    copymemory(ppackhead.MessageType,strmsg,4);
    CopyMemory(@ppackhead.VerifyCode,PChar(strmd5code),32);
    AMessageType:=StrToInt(strmsg);
end;

procedure TETCPeerThread.WriteLog(Str: String);
var
  tmpStr,
  tmpName: String;
  SystemTime: TSystemTime;
  fsm       : TextFile;
begin
    if not mainclass.bflagworklog then exit;
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
      tmpName := tmpName + Format('%.4d%.2d%.2d%.2d',[wYear,wMonth,wDay,wHour])+copy(networkid,1,4);

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


procedure TETCPeerThread.proc4051;
var
    strtmp:string;
    //strtmpid:string;
begin
//*****************************赋值报体内容**************************************************

      try
            CopyMemory(@PBANKGETBDKKRESULT,@buf,SizeOf(PBANKGETBDKKRESULT));
          {  if not dowloadfile(StrToInt(Trim(PBANKGETBDKKRESULT.RecordNumber)),string(PBANKGETBDKKRESULT.FileName)) then
            begin
                ResponseCode:='48';
            end;  }
            try
              ProcessList1 := TProcessList.Create;
              ProcessList1.DbConnected := True;
              if not ProcessList1.DbConnected then Exit;
              {1.获取配置文件参数}
              ProcessList1.LoadParam;
              {创建上传、下载、日志文件夹}
              ProcessList1.CreateYearFolder;
              ProcessList1.DownLoadFile(Trim(PBANKGETBDKKRESULT.filename));
            except on e:exception do
              begin
                responsecode:= '48';
                WriteerrorLog('下载文件失败'+e.Message  );
              end;
              end;

            FillChar(PBANKSETBDKKRESULT,SizeOf(PBANKSETBDKKRESULT),0);
            if ResponseCode='00' then
            begin
                copymemory(@PBANKSETBDKKRESULT.BalanceDate,@PBANKGETBDKKRESULT.BalanceDate,SizeOf(PBANKSETBDKKRESULT.BalanceDate));
                copymemory(@PBANKSETBDKKRESULT.BankID,@PBANKGETBDKKRESULT.BankID,SizeOf(PBANKSETBDKKRESULT.BankID));
                copymemory(@PBANKSETBDKKRESULT.TerminalID ,@PBANKGETBDKKRESULT.TerminalID,SizeOf(PBANKSETBDKKRESULT.TerminalID));
                copymemory(@PBANKSETBDKKRESULT.NetWorkID ,@PBANKGETBDKKRESULT.NetWorkID,SizeOf(PBANKSETBDKKRESULT.NetWorkID));
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@PBANKSETBDKKRESULT.ProcessDate,pchar(strtmp),SizeOf(PBANKSETBDKKRESULT.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@PBANKSETBDKKRESULT.Processtime,pchar(strtmp),SizeOf(PBANKSETBDKKRESULT.Processtime));
           end;
     except
         responsecode:='48';
     end;
     copymemory(@PBANKSETBDKKRESULT.ResponseCode,pchar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@PBANKSETBDKKRESULT,SizeOf(PBANKSETBDKKRESULT));
    self.sendbody(tmpbuf,'4052',SizeOf(PBANKSETBDKKRESULT));

    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'扣款结果文件接收应答发送成功'+PBANKSETBDKK.ResponseCode);
          terminalok:=1;
          ProcessList1.ProcessDownFile(trim(PBANKGETBDKKRESULT.filename));  //入库
      except
          WriteerrorLog('扣款结果应答发送失败或文件入库失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.proc4053;
var
    strtmp:string;
   // strtmpid:string;
   // i:integer;
begin
//*****************************赋值报体内容**************************************************

      try
            CopyMemory(@pBANKGETDZJGMXFSTZBW,@buf,SizeOf(pBANKGETDZJGMXFSTZBW));
            if not dowloadfile(StrToInt(trim(pBANKGETDZJGMXFSTZBW.RecordNumber)),string(pBANKGETDZJGMXFSTZBW.FileName)) then
            begin
                ResponseCode:='99';
            end;
            FillChar(pBANKSETDZJGMXFSTZBW,SizeOf(pBANKSETDZJGMXFSTZBW),0);
            if ResponseCode='00' then
            begin
                copymemory(@pBANKSETDZJGMXFSTZBW.BankID,@pBANKGETDZJGMXFSTZBW.BankID,SizeOf(pBANKSETDZJGMXFSTZBW.BankID));
                copymemory(@pBANKSETDZJGMXFSTZBW.TerminalID ,@pBANKGETDZJGMXFSTZBW.TerminalID,SizeOf(pBANKSETDZJGMXFSTZBW.TerminalID));
                copymemory(@pBANKSETDZJGMXFSTZBW.NetWorkID ,@pBANKGETDZJGMXFSTZBW.NetWorkID,SizeOf(pBANKSETDZJGMXFSTZBW.NetWorkID));
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pBANKSETDZJGMXFSTZBW.ProcessDate,pchar(strtmp),SizeOf(pBANKSETDZJGMXFSTZBW.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pBANKSETDZJGMXFSTZBW.Processtime,pchar(strtmp),SizeOf(pBANKSETDZJGMXFSTZBW.Processtime));
           end;
     except
         responsecode:='99'; //报文格式有误!!!
     end;
     copymemory(@pBANKSETDZJGMXFSTZBW.ResponseCode,pchar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pBANKSETDZJGMXFSTZBW,SizeOf(pBANKSETDZJGMXFSTZBW));
    self.sendbody(tmpbuf,'4054',SizeOf(pBANKSETDZJGMXFSTZBW));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'打折扣款结果文件接收应答发送成功'+PBANKSETBDKK.ResponseCode);
          terminalok:=1;

      except
          WriteerrorLog('发送打折扣款结果文件接收应答失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.proc5051;
var
    strtmp:string;
  //  strtmpid:string;
begin
//*****************************赋值报体内容**************************************************

      try
            //  CopyMemory(@PBANKGETBDKKRESULT,@buf,SizeOf(PBANKGETBDKKRESULT));
              CopyMemory(@pBANKGETBDJZFRESULT,@buf,SizeOf(pBANKGETBDJZFRESULT));
            if not dowloadfile(StrToInt(pBANKGETBDJZFRESULT.RecordNumber),string(pBANKGETBDJZFRESULT.FileName)) then
            begin
                ResponseCode:='99';
            end;
            FillChar(pBANKSETBDJZFRESULT,SizeOf(pBANKSETBDJZFRESULT),0);
            if ResponseCode='00' then
            begin
                copymemory(@pBANKSETBDJZFRESULT.BalanceDate,@pBANKGETBDJZFRESULT.BalanceDate,SizeOf(pBANKSETBDJZFRESULT.BalanceDate));
                copymemory(@pBANKSETBDJZFRESULT.BankID,@pBANKGETBDJZFRESULT.BankID,SizeOf(pBANKSETBDJZFRESULT.BankID));
                copymemory(@pBANKSETBDJZFRESULT.TerminalID ,@pBANKGETBDJZFRESULT.TerminalID,SizeOf(pBANKSETBDJZFRESULT.TerminalID));
                copymemory(@pBANKSETBDJZFRESULT.NetWorkID ,@pBANKGETBDJZFRESULT.NetWorkID,SizeOf(pBANKSETBDJZFRESULT.NetWorkID));
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pBANKSETBDJZFRESULT.ProcessDate,pchar(strtmp),SizeOf(pBANKSETBDJZFRESULT.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pBANKSETBDJZFRESULT.Processtime,pchar(strtmp),SizeOf(pBANKSETBDJZFRESULT.Processtime));
           end;
     except
         responsecode:='90'; //签到失败!!!
     end;
     copymemory(@pBANKSETBDJZFRESULT.ResponseCode,pchar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pBANKSETBDJZFRESULT,SizeOf(pBANKSETBDJZFRESULT));
    self.sendbody(tmpbuf,'5052',SizeOf(PBANKSETBDKKRESULT));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'JZF结果文件接收应答发送成功'+pBANKSETBDJZFRESULT.ResponseCode);
          terminalok:=1;

      except
          WriteerrorLog('发送JZF结果文件接收应答失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.proc4071;
var
    strtmp:string;
   // strtmpid:string;
begin
//*****************************赋值报体内容**************************************************

      try
            CopyMemory(@PBANKGETBDKBDRESULT,@buf,SizeOf(PBANKGETBDKBDRESULT));
           { if not dowloadfile(StrToInt(trim(PBANKGETBDKBDRESULT.RecordNumber)),string(PBANKGETBDKBDRESULT.FileName)) then
            begin
                ResponseCode:='99';
            end;  }
            try
              ProcessList1 := TProcessList.Create;
              WriteerrorLog('连接数据库');
              ProcessList1.DbConnected := True;
              if not ProcessList1.DbConnected then Exit;
              WriteerrorLog('连接数据库成功');
              {1.获取配置文件参数}
              ProcessList1.LoadParam;
              {创建上传、下载、日志文件夹}
              ProcessList1.CreateYearFolder;
              ProcessList1.DownLoadFile(Trim(PBANKGETBDKBDRESULT.filename));
            except on e:exception do
              begin
                responsecode:= '48';
                WriteerrorLog('下载文件失败'+e.Message  );
              end;
            end;
            FillChar(PBANKSETBDKKRESULT,SizeOf(PBANKSETBDKKRESULT),0);
            if ResponseCode='00' then
            begin
                copymemory(@PBANKSETBDKBDRESULT.BalanceDate,@PBANKGETBDKBDRESULT.BalanceDate,SizeOf(PBANKSETBDKBDRESULT.BalanceDate));
                copymemory(@PBANKSETBDKBDRESULT.BankID,@PBANKGETBDKBDRESULT.BankID,SizeOf(PBANKSETBDKBDRESULT.BankID));
                copymemory(@PBANKSETBDKBDRESULT.TerminalID ,@PBANKGETBDKBDRESULT.TerminalID,SizeOf(PBANKSETBDKBDRESULT.TerminalID));
                copymemory(@PBANKSETBDKBDRESULT.NetWorkID ,@PBANKGETBDKBDRESULT.NetWorkID,SizeOf(PBANKSETBDKBDRESULT.NetWorkID));
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@PBANKSETBDKBDRESULT.ProcessDate,pchar(strtmp),SizeOf(PBANKSETBDKBDRESULT.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@PBANKSETBDKBDRESULT.Processtime,pchar(strtmp),SizeOf(PBANKSETBDKBDRESULT.Processtime));
           end;
     except
         responsecode:='99'; //签到失败!!!
     end;
     copymemory(@PBANKSETBDKBDRESULT.ResponseCode,pchar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@PBANKSETBDKBDRESULT,SizeOf(PBANKSETBDKBDRESULT));
    self.sendbody(tmpbuf,'4072',SizeOf(PBANKSETBDKBDRESULT));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'绑定结果文件接收应答发送成功'+PBANKSETBDKBDRESULT.ResponseCode);
          terminalok:=1;
          ProcessList1.ProcessDownFile(trim(PBANKGETBDKBDRESULT.filename));  //入库
      except
          WriteerrorLog('发送绑定结果文件接收应答失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断');
end;

procedure TETCPeerThread.proc4021;
var
    strtmp:string;
   // strtmpid:string;
    i:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetblackcard,@buf,SizeOf(pbankgetblackcard));

            if mainclass.bdatabaseconnect then
            begin
            with adosp do
            begin
                try
              close;
              errorid:=-1;
              ProcedureName:='Usp_ETCBankCardToPCardBlackList_bank';
              Parameters.Clear;

              Parameters.CreateParameter('CustomerID',ftString,pdInput,20,Trim(string(pbankgetblackcard.CostomerID)));
              Parameters.CreateParameter('UserType',ftString,pdInput,20,Trim(string(pbankgetblackcard.UserType)));
              Parameters.CreateParameter('UserName',ftString,pdInput,100,Trim(string(pbankgetblackcard.UserName)));
              Parameters.CreateParameter('CertificateType',ftString,pdInput,2,Trim(string(pbankgetblackcard.CertificateType)));
              Parameters.CreateParameter('CertificateID',ftString,pdInput,60,Trim(string(pbankgetblackcard.CertificateID)));
              Parameters.CreateParameter('PCardNetID',ftString,pdInput,20,Trim(string(pbankgetblackcard.PCardNetID)));
              Parameters.CreateParameter('PCardID',ftString,pdInput,20,Trim(string(pbankgetblackcard.PCardID)));
              Parameters.CreateParameter('BankCardID',ftString,pdInput,32,mainclass.yxsj(string(pbankgetblackcard.BankCardID)));
              Parameters.CreateParameter('TranType',ftString,pdInput,2,string(pbankgetblackcard.TranType));
              Parameters.CreateParameter('BindingCardBlackCause',ftString,pdInput,1,Trim(string(pbankgetblackcard.BindingCardBlackCause)));//mainclass.yxsj(string(pbankgetczqq.TKMoney))
              Parameters.CreateParameter('Errorid',ftinteger,pdoutput,4,errorid);
              Parameters.CreateParameter('ErrorMsg',ftString,pdoutput,50,ErrorMsg);
              Parameters.CreateParameter('ResponseCode',ftString,pdoutput,2,ResponseCode);
//               errorid1:=0;
                  ExecProc;
                  errorid:=parameters.ParamByName('errorid').Value;
              if errorid<0 then
                  errormsg:=parameters.ParamByName('errormsg').Value;
                  ResponseCode:=parameters.ParamByName('ResponseCode').Value;
              except on e:exception do
              begin
                  strtmp:='';
                  for i:=0 to Parameters.count-1 do
                  begin
                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                  end;
                  mainclass.WriteerrorLog('快通卡卡号为：'+string(pbankgetblackcard.PCardID)+'的黑名单写入数据库失败,失败原因为'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                  ResponseCode:='93';
              end;
              end;
             end;
            end;

            FillChar(pbanksetblackcard,SizeOf(pbanksetblackcard),0);
            if ResponseCode='00' then
            begin
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetblackcard.ProcessDate,pchar(strtmp),SizeOf(pbanksetblackcard.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pbanksetblackcard.Processtime,pchar(strtmp),SizeOf(pbanksetblackcard.Processtime));

                copymemory(@pbanksetblackcard.NetWorkID,@pbankgetblackcard.NetWorkID,SizeOf(pbanksetblackcard.NetWorkID));
                copymemory(@pbanksetblackcard.TerminalID,@pbankgetblackcard.TerminalID,SizeOf(pbanksetblackcard.TerminalID));
                copymemory(@pbanksetblackcard.BankID,@pbankgetblackcard.BankID,SizeOf(pbanksetblackcard.BankID));
                copymemory(@pbanksetblackcard.CustomerID,@pbankgetblackcard.CostomerID,SizeOf(pbanksetblackcard.CustomerID));
                copymemory(@pbanksetblackcard.PCardNetID,@pbankgetblackcard.PCardNetID,sizeof(pbanksetblackcard.PCardNetID)) ;
                copymemory(@pbanksetblackcard.PCardID,@pbankgetblackcard.PCardID,sizeof(pbanksetblackcard.PCardID)) ;
                copymemory(@pbanksetblackcard.username,@pbankgetblackcard.username,sizeof(pbanksetblackcard.username)) ;
                copymemory(@pbanksetblackcard.BankCardID,@pbankgetblackcard.BankCardID,sizeof(pbanksetblackcard.BankCardID)) ;

            end;
                copymemory(@pbanksetblackcard.ResponseCode,pchar(ResponseCode),SizeOf(pbanksetblackcard.ResponseCode));

    //**********************************************************************************************************
                FillChar(tmpbuf,SizeOf(tmpbuf),0);
                CopyMemory(@tmpbuf,@pbanksetblackcard,SizeOf(pbanksetblackcard));
                self.sendbody(tmpbuf,'4022',SizeOf(pbanksetblackcard));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'黑名单接收成功'+pbanksetblackcard.PCardID);
              except
                  WriteerrorLog('黑名单接收失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;
function TETCPeerThread.procbank1001:Boolean;
var
    pbankgetkey:TGETPASSWORDKEY;
    pbanksetkey:TsETPASSWORDKEY;
    strtmp:string;
begin

//************************赋值报体内容********************************
    strtmp:=formatdatetime('yyyymmdd',now);
    FillChar(pbankgetkey, sizeof(pbankgetkey), 0);
    copymemory(@pbankgetkey.ProcessDate,PChar(strtmp),8);
    strtmp:=formatdatetime('hhmmss',now);
    copymemory(@pbankgetkey.ProcessTime,PChar(strtmp),6);
   // copymemory(@pbankgetkey.TerminalID,PChar(mainclass.TerminalID),10);

//*******************************************************************

    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbankgetkey,SizeOf(pbankgetkey));
    self.sendbodybank(tmpbuf,'1001',SizeOf(pbankgetkey));
{    if not packset(tmpbuf,'1001',true,SizeOf(pbankgetkey)) then
    begin
        self.Memo1.Lines.Append('数据包处理失败!!!');
        exit;
    end;

//***********************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetqc,SizeOf(pbanksetqc));
    self.sendbody(tmpbuf,'2008',SizeOf(pbanksetqc));
}

            if idcbank.Connected then
            begin
              try
                  idcbank.WriteBuffer(buf,bufsize);
                  self.readbufbank;
                  writedebuglog('procbank1001来自'+ppackheadReceiver.SenderID+'银行加密因子请求发送成功');
              except
                  WriteerrorLog('银行充值请求发送失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

    if (AMessageType=1002) then
    begin
            FillChar(pbanksetkey,SizeOf(pbanksetkey),0);
            CopyMemory(@pbanksetkey,@buf,SizeOf(pbanksetkey));
            if pbanksetkey.ResponseCode='00' then
            begin
//                writelog('获得加密因子的key1:'+mainclass.bytetostr(pbanksetkey.KEY1)+#13+'key2:'+mainclass.bytetostr(pbanksetkey.KEY2));

                CopyMemory(@keybank,@pbanksetkey.key1,8);
                CopyMemory(@keybank[8],@pbanksetkey.key2,8);
                WritedebugLog(mainclass.arraytostr(pbanksetkey.key1)+mainclass.arraytostr(pbanksetkey.key2));
                WritedebugLog(mainclass.arraytostr(keybank));
                result:=True;
            end
            else
            begin
                result:=false;
                WriteLog(mainclass.errorname(string(pbanksetkey.ResponseCode)));
            end;
    end
    else
    begin
          result:=False
    end;

end;

function TETCPeerThread.probank1001(bankey:string):Boolean;
var
    pbankgetkey:TGETPASSWORDKEY;
    pbanksetkey:TsETPASSWORDKEY;
    strtmp:string;
begin

//************************赋值报体内容********************************
    strtmp:=formatdatetime('yyyymmdd',now);
    FillChar(pbankgetkey, sizeof(pbankgetkey), 0);
    copymemory(@pbankgetkey.ProcessDate,PChar(strtmp),8);
    strtmp:=formatdatetime('hhmmss',now);
    copymemory(@pbankgetkey.ProcessTime,PChar(strtmp),6);
   // copymemory(@pbankgetkey.TerminalID,PChar(mainclass.TerminalID),10);

//*******************************************************************

    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbankgetkey,SizeOf(pbankgetkey));
    self.sedbodybank(tmpbuf,'1001',SizeOf(pbankgetkey),bankey);
{    if not packset(tmpbuf,'1001',true,SizeOf(pbankgetkey)) then
    begin
        self.Memo1.Lines.Append('数据包处理失败!!!');
        exit;
    end;

//***********************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetqc,SizeOf(pbanksetqc));
    self.sendbody(tmpbuf,'2008',SizeOf(pbanksetqc));
}

            if idcbank.Connected then
            begin
              try
                  idcbank.WriteBuffer(buf,bufsize);
                  self.readbufbak(bankey);
                  writedebuglog('procbank1001来自'+ppackheadReceiver.SenderID+'银行加密因子请求发送成功');
              except
                  WriteerrorLog('银行充值请求发送失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

    if (AMessageType=1002) then
    begin
            FillChar(pbanksetkey,SizeOf(pbanksetkey),0);
            CopyMemory(@pbanksetkey,@buf,SizeOf(pbanksetkey));
            if pbanksetkey.ResponseCode='00' then
            begin
//                writelog('获得加密因子的key1:'+mainclass.bytetostr(pbanksetkey.KEY1)+#13+'key2:'+mainclass.bytetostr(pbanksetkey.KEY2));

                CopyMemory(@keybank,@pbanksetkey.key1,8);
                CopyMemory(@keybank[8],@pbanksetkey.key2,8);
                WritedebugLog(mainclass.arraytostr(pbanksetkey.key1)+mainclass.arraytostr(pbanksetkey.key2));
                WritedebugLog(mainclass.arraytostr(keybank));
                result:=True;
            end
            else
            begin
                result:=false;
                WriteLog(mainclass.errorname(string(pbanksetkey.ResponseCode)));
            end;
    end
    else
    begin
          result:=False
    end;

end;
procedure TETCPeerThread.proc4061;
var
    strtmp:string;
   // strtmpid:string;
    i:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@PBANKGETBDPJDY,@buf,SizeOf(PBANKGETBDPJDY));
            FillChar(PBANKSETBDPJDY,SizeOf(PBANKSETBDPJDY),0);
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin
                    with adosp do
                    begin
                      try
                        close;
                        errorid:=-1;
                        ProcedureName:='Usp_ETCBankBindCardBillNoPNT';
                        Parameters.Clear;
                        Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,Trim(string(PBANKGETBDPJDY.ProcessDate)));
                        Parameters.CreateParameter('@ProcessTime',ftString,pdInput,6,Trim(string(PBANKGETBDPJDY.ProcessTime)));
                        Parameters.CreateParameter('@NetWorkID',ftString,pdInput,12,Trim(string(PBANKGETBDPJDY.networkid)));
                        Parameters.CreateParameter('@TerminalID',ftString,pdInput,12,Trim(string(PBANKGETBDPJDY.TerminalID)));
                        Parameters.CreateParameter('@CustomerID',ftString,pdInput,20,Trim(string(PBANKGETBDPJDY.CustomerID)));
                        Parameters.CreateParameter('@PCardNetID',ftString,pdInput,4,Trim(string(PBANKGETBDPJDY.PCardNetID)));
                        Parameters.CreateParameter('@PCardID',ftString,pdInput,16,Trim(string(PBANKGETBDPJDY.PCardID)));
                        Parameters.CreateParameter('@InvoiceClass',ftString,pdInput,2,Trim(string(PBANKGETBDPJDY.InvoiceType)));
                        Parameters.CreateParameter('@InvoiceBatch',ftString,pdInput,4,Trim(string(PBANKGETBDPJDY.InvoiceBatch)));
                        Parameters.CreateParameter('@InvoiceID',ftString,pdInput,8,Trim(string(PBANKGETBDPJDY.InvoiceID)));
                        Parameters.CreateParameter('@begindate',ftString,pdInput,30,Trim(string(PBANKGETBDPJDY.begindate)));
                        Parameters.CreateParameter('@enddate',ftString,pdInput,8,Trim(string(PBANKGETBDPJDY.enddate)));
                        Parameters.CreateParameter('@OperatorID',ftString,pdInput,10,Trim(string(PBANKGETBDPJDY.OperatorID)));
                        Parameters.CreateParameter('@ResponseCode',ftString,pdInputOutput,8,0);
                        Parameters.CreateParameter('@errorid',ftinteger,pdInputOutput,4,-1);
                        Parameters.CreateParameter('@ErrorMsg',ftstring,pdInputOutput,50,'');


                            open;
                            errorid:=parameters.ParamByName('@errorid').Value;
                        if errorid<0 then
                            Errormsg:=parameters.ParamByName('@errormsg').Value;
                            ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                        except on e:exception do
                        begin
                            strtmp:='';
                            for i:=0 to Parameters.count-1 do
                            begin
                                strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                            end;
                             mainclass.writeerrorlog(e.message+'exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                            ResponseCode:='33';
                        end;
                      end;
                      if ResponseCode='00' then
                      begin
                          strtmp:=FormatDateTime('yyyymmdd',now);
                          copymemory(@PBANKSETBDPJDY.ProcessDate,PChar(strtmp),SizeOf(PBANKSETBDPJDY.ProcessDate));
                          strtmp:=FormatDateTime('hhmmss',now);
                          copymemory(@PBANKSETBDPJDY.Processtime,PChar(strtmp),SizeOf(PBANKSETBDPJDY.Processtime));
                          copymemory(@PBANKSETBDPJDY.NetWorkID,@PBANKGETBDPJDY.NetWorkID,SizeOf(PBANKSETBDPJDY.NetWorkID));
                          copymemory(@PBANKSETBDPJDY.TerminalID,@PBANKGETBDPJDY.TerminalID,SizeOf(PBANKSETBDPJDY.TerminalID));
                          copymemory(@PBANKSETBDPJDY.CustomerID,PChar(mainclass.padr(fieldbyname('CustomerID').AsString,SizeOf(PBANKSETBDPJDY.CustomerID),' ')),SizeOf(PBANKSETBDPJDY.CustomerID));
                          copymemory(@PBANKSETBDPJDY.UserName,PChar(mainclass.padr(fieldbyname('UserName').AsString,SizeOf(PBANKSETBDPJDY.UserName),' ')),SizeOf(PBANKSETBDPJDY.UserName));
                          copymemory(@PBANKSETBDPJDY.PCardNetID,@PBANKGETBDPJDY.PCardNetID,SizeOf(PBANKSETBDPJDY.PCardNetID));
                          CopyMemory(@PBANKSETBDPJDY.PCardID,@PBANKGETBDPJDY.PCardID,sizeof(PBANKSETBDPJDY.PCardID)) ;

                          copymemory(@PBANKSETBDPJDY.InvoiceID,@PBANKGETBDPJDY.InvoiceID,SizeOf(PBANKSETBDPJDY.InvoiceID));
                          copymemory(@PBANKSETBDPJDY.XFMoney,PChar(mainclass.padl(fieldbyname('Amount').AsString,12,'0')),SizeOf(PBANKSETBDPJDY.XFMoney));
                          copymemory(@PBANKSETBDPJDY.FreeMoney,PChar(mainclass.padl(fieldbyname('FreeMoney').AsString,12,'0')),SizeOf(PBANKSETBDPJDY.FreeMoney));
                          copymemory(@PBANKSETBDPJDY.BeginDate,@PBANKGETBDPJDY.begindate,SizeOf(PBANKSETBDPJDY.BeginDate));
                          copymemory(@PBANKSETBDPJDY.enddate,@PBANKGETBDPJDY.enddate,SizeOf(PBANKSETBDPJDY.enddate));
                          copymemory(@PBANKSETBDPJDY.InvoiceBatch,@PBANKGETBDPJDY.InvoiceBatch,SizeOf(PBANKSETBDPJDY.InvoiceBatch));
                          copymemory(@PBANKSETBDPJDY.Invoicetype,@PBANKGETBDPJDY.Invoicetype,SizeOf(PBANKSETBDPJDY.InvoiceType));
                          copymemory(@PBANKSETBDPJDY.Vehplate,PChar(mainclass.padr(fieldbyname('Vehplate').AsString,SizeOf(PBANKSETBDPJDY.Vehplate),' ')),SizeOf(PBANKSETBDPJDY.Vehplate));
                      end;
                      //查询车牌相应的信息.....
                      errorid:=-1;
                      Close;
                      ProcedureName:='Usp_ExpCardInfoQuery';
                      Parameters.Clear;
                      Parameters.CreateParameter('@ProcessDate',ftString,pdInput,8,Trim(string(PBANKGETBDPJDY.ProcessDate)));
                      Parameters.CreateParameter('@ProcessTime',ftString,pdInput,6,Trim(string(PBANKGETBDPJDY.ProcessTime)));
                      Parameters.CreateParameter('@NetWorkID',ftString,pdInput,12,Trim(string(PBANKGETBDPJDY.networkid)));
                      Parameters.CreateParameter('@TerminalID',ftString,pdInput,12,Trim(string(PBANKGETBDPJDY.TerminalID)));
                      Parameters.CreateParameter('@PCardNetID',ftString,pdInput,4,Trim(string(PBANKGETBDPJDY.PCardNetID)));
                      Parameters.CreateParameter('@PCardID',ftString,pdInput,16,Trim(string(PBANKGETBDPJDY.PCardID)));
                      Parameters.CreateParameter('@errorid',ftinteger,pdoutput,4,errorid);
                      Parameters.CreateParameter('@ErrorMsg',ftstring,pdoutput,50,ErrorMsg);
                          try
            //               errorid1:=0;

                              open;
                              errorid:=parameters.ParamByName('@errorid').Value;
                            if errorid<0 then
                              Errormsg:=parameters.ParamByName('@errormsg').Value;
                              if RecordCount=0 then
                                  ResponseCode:='16'; //此卡不在存
                              if ResponseCode='00' then
                                  begin
                                      copymemory(@PBANKSETBDPJDY.UserName,PChar(mainclass.padr(fieldbyname('UserName').AsString,SizeOf(PBANKSETBDPJDY.UserName),' ')),SizeOf(PBANKSETBDPJDY.UserName));
                                      copymemory(@PBANKSETBDPJDY.Vehplate,PChar(mainclass.padr(fieldbyname('Vehplate').AsString,SizeOf(PBANKSETBDPJDY.Vehplate),' ')),SizeOf(PBANKSETBDPJDY.Vehplate));
                                  end;
                          except on e:exception do
                          begin
                              mainclass.writeerrorlog('查询请求失败原因:'+e.message);
                              ResponseCode:='10';  //快通卡查询错误
                          end;
                      end;


                 end;
            end;

            CopyMemory(@PBANKSETBDPJDY.ResponseCode,PChar(ResponseCode),2);
//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@PBANKSETBDPJDY,SizeOf(PBANKSETBDPJDY));
            self.sendbody(tmpbuf,'4062',SizeOf(PBANKSETBDPJDY));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自'+ppackheadReceiver.SenderID+'车辆查询请求发送成功');
              except
                  WriteerrorLog('车辆查询请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

function tsendservice.upfile(bankid,filetype,workdate,tabname:string;var filename,sPath:string):boolean;
var
    ret:integer;
begin
  Result:=False;
  try
    mainclass.WriteLog('TProcessList.Create');
    ProcessList1 := TProcessList.Create;
    ProcessList1.DbConnected := True;
    if not ProcessList1.DbConnected then Exit;
    {1.获取配置文件参数}
    ProcessList1.LoadParam;
    {创建上传、下载、日志文件夹}
    ProcessList1.CreateYearFolder;
    {下载}
   mainclass.WriteLog('开始生成上传银行文件');
   if mainclass.bdatabaseconnect then
      begin
       if ProcessList1.ProcessUpFile(BankID,WorkDate,FileType,tabname,FileName,sPath) then
        begin
          mainclass.WriteLog('生成上传银行文件成功');
          {上传文件}
          ret := ProcessList1.UpLoadFile(FileName);
         // ret:=0;
          {记录日志}
          Case ret of
            NoThisFile : mainclass.WriteLog('本地没有该文件上传');
            CanNotConn : mainclass.WriteLog('不能连接FTP');
           OtherErr   : mainclass.WriteLog('连接FTP其他错误');
            RunOK      :
            begin
                result:=true;
                mainclass.WriteLog('上传银行文件成功');
            end;
          end;
        end;
      end;
  finally
    ProcessList1.DbConnected := false;
    freeandnil(ProcessList1);
  end;
end;

procedure tsendservice.readbufbank;

var ilength:integer;
   // li_length:integer;
begin
    ilength:=0;
    try
            FillChar(buf,SizeOf(buf),0);
          //  li_length:=SizeOf(ppackheadReceiver);
            IdTCPClient1.ReadBuffer(bufhead,SizeOf(ppackheadReceiver));
            FillChar(ppackheadReceiver,SizeOf(ppackheadReceiver),0);
            CopyMemory(@ppackheadReceiver,@bufhead,SizeOf(ppackheadReceiver));
            try
                 AMessageType := StrToInt(ppackheadReceiver.MessageType) ;
            except
                 AMessageType:=0;
            end;
         ilength:=mainclass.inttobigint(ppackheadReceiver.MessageLength);
         IdTCPClient1.ReadBuffer(buf,ilength-SizeOf(ppackheadReceiver));
//          writedebuglog('ilength-- '+inttostr(ilength)+'ppackheadReceiver-- '+inttostr(SizeOf(ppackheadReceiver)));
      except on e:exception do
      begin
        // responsecode:='09';
         mainclass.WriteLog('readbufbank接受银行'+inttostr(AMessageType)+'时异常'+e.Message );
         mainclass.WriteLog('readbufbank接受银行'+inttostr(AMessageType)+'时异常'+e.Message );

      end;
      end;
//****************************************解密报体内容*********************************************************
//       writedebuglog('使用加密因子'+mainclass.arraytostr(keybank)+inttostr(AMessageType));

       btsize:=ilength-sizeof(ppackheadReceiver);
       SetLength(indata,btsize);
       btsendsize:=(btsize div 8+1)*8;
       SetLength(outdata,btsendsize);
       Move(buf,indata[0],btsize);
    //   mainclass.WriteLog('接收银行数据'+inttostr(AMessageType)+'的密码为'+mainclass.arraytostr(indata));
       mainclass.Decryptbcb(keybank,indata,outdata);
       mainclass.WriteLog('接收银行数据'+inttostr(AMessageType)+'的明码为'+mainclass.arraytostr1(outdata));
       mainclass.WriteLog('使用加密因子'+mainclass.arraytostr(keybank));
       setlength(outdata,length(outdata)-outdata[high(outdata)]);
       mainclass.dbuftobuf(outdata,buf,0);
end;

procedure TETCPeerThread.getmac;
var
    mac1:array[0..3] of byte;
    errormsg:string;
  //  i:integer;
    strtmp:string;

begin
//**********************************************处理报文**************************************************
//
          try
            FillChar(pbanksetmac,SizeOf(pbanksetmac),0);
//            mainclass.WriteLog('OBUFX信息:'+mainclass.arraytostr(OBUFX.hth)+mainclass.arraytostr(OBUFX.rand)+mainclass.arraytostr(OBUFX.clxx));
             if OBUFX2(OBUFX,mainclass.SJMJSERVERIP,mainclass.SJMJPORT,mac1,errormsg,amessagetype-9900) then
            // 读取数据库
            begin
                strtmp:=mainclass.BytestoHexString(mac1,SizeOf(mac1));
                copymemory(@pbanksetmac.mac,@mac1,4);
//                mainclass.WriteLog('加密机获取MAC:'+strtmp);
//                mainclass.WriteerrorLog('加密机错误消息：'+errormsg);
            end;
//            copymemory(@pbanksetczquery.PCardID,@pbankgetczquery.PCardID,sizeof(pbanksetczquery.PCardID)) ;
                copymemory(@pbanksetmac.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetmac.ResponseCode));

//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
              CopyMemory(@tmpbuf,@pbanksetmac,SizeOf(pbanksetmac));

            self.sendbody(tmpbuf,'9999',SizeOf(pbanksetmac));
             except on e:exception do
             begin                  
                WriteerrorLog('充值9903失败!!');
                responsecode:= '09';
             end;
             end;
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
               //   writelog('来自'+ppackheadReceiver.SenderID+'请求MAC返回成功'+strtmp);
              except
                  WriteerrorLog('充值查询失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.getmaccz;
var
    strtmp:string;
    strmsg:string;
    mac1:array [0..3] of byte;
begin
          try
            CopyMemory(@pcardloadpara,@buf,SizeOf(pCardLoadPara));

                writedebuglog(' getmaccz 9991  start');
                if CheckMAC1(pcardloadpara,mainclass.SJMJSERVERIP,mainclass.SJMJPORT,strmsg) then
                     CalMAC2(pcardloadpara,mainclass.SJMJSERVERIP,mainclass.SJMJPORT,mac1,strmsg)
                else
                begin
                    ResponseCode:='95';
                    writedebuglog('信息为:'+'cardid:'+pcardloadpara.CardId
                    +'Balance:'+pcardloadpara.Balance
                    +'CardPayMoney:'+pcardloadpara.CardPayMoney
                    +'TransNumber:'+pcardloadpara.TransNumber
                    +'KeyVersion:'+pcardloadpara.KeyVersion
                    +'KeyAlgorithm:'+pcardloadpara.KeyAlgorithm
                    +'Rand:'+pcardloadpara.Rand
                    +'MAC1:'+pcardloadpara.MAC1
                    +'TerminalNo:'+pcardloadpara.TerminalNo
                    +'DateStr:'+pcardloadpara.DateStr
                    +'timeStr:'+pcardloadpara.timeStr
                    +'请求MAC失败!!'+strmsg);
                end;
          except on e:exception do
          begin
             writeerrorlog('9991充值异常');
             responsecode:= '09';
          end;
          end;

                strtmp:=mainclass.BytestoHexString(mac1,SizeOf(mac1));
                //********************************************************************************
                 writedebuglog(' getmaccz 9991  2');
                 try
            FillChar(pbanksetmac,SizeOf(pbanksetmac),0);
            if ResponseCode='00' then
            begin
                copymemory(@pbanksetmac.mac,@mac1,sizeof(pbanksetmac.mac));
            end;
            copymemory(@pbanksetmac.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetmac.ResponseCode));

//***********************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetmac,SizeOf(pbanksetmac));
    except on e:exception  do
    begin
      responsecode:= '09';
       writedebuglog( 'TETCPeerThread.getmaccz'+e.Message );
      end;
    end;
            self.sendbody(tmpbuf,'9999',SizeOf(pbanksetmac));

            writedebuglog('self.sendbody9991 end');
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writedebuglog('来自9991'+ppackheadReceiver.SenderID+'充值MAC请求发送成功');
              except
                  writedebuglog('9991充值请求失败!!');
              end;
            end
            else
                writedebuglog('9991客户端请求中断');

end;

procedure TETCPeerThread.getmacxf;
var
    strtmp:string;
    strmsg:string;
    mac1:array [0..3] of byte;
begin
            CopyMemory(@pcardloadpara11,@buf,SizeOf(pcardloadpara11));
                CalPurMAC1(pcardloadpara11,mainclass.SJMJSERVERIP,mainclass.SJMJPORT,mac1,strmsg);
                if strmsg<>'' then
                begin
                    ResponseCode:='95';
                    writeerrorlog('信息为:'+'cardid:'+pcardloadpara11.CardId
                    +'Balance:'+pcardloadpara11.Balance
                    +'Cash:'+pcardloadpara11.Cash
                    +'TransNumber:'+pcardloadpara11.TransNumber
                    +'KeyVersion:'+pcardloadpara11.KeyVersion
                    +'KeyAlgorithm:'+pcardloadpara11.KeyAlgorithm
                    +'Rand:'+pcardloadpara11.Rand
                    +'MAC1:'+pcardloadpara11.MAC1
                    +'TerminalNo:'+pcardloadpara11.TerminalNo
                    +'CashDate:'+pcardloadpara11.CashDate
                    +'CashTime:'+pcardloadpara11.CashTime
                    +'请求MAC失败!!'+strmsg);
                end;

                strtmp:=mainclass.BytestoHexString(mac1,SizeOf(mac1));
                //********************************************************************************
            FillChar(pbanksetmac,SizeOf(pbanksetmac),0);
            if ResponseCode='00' then
            begin
                copymemory(@pbanksetmac.mac,@mac1,sizeof(pbanksetmac.mac));
            end;
            copymemory(@pbanksetmac.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetmac.ResponseCode));

//***********************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetmac,SizeOf(pbanksetmac));

            self.sendbody(tmpbuf,'9999',SizeOf(pbanksetmac));


            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
//                  writelog('来自'+ppackheadReceiver.SenderID+'充值MAC请求发送成功');
              except
                  WriteerrorLog('充值请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc1005;
var
    strtmp:string;
   // strtmpid:string;
    i:integer;
begin
//*****************************赋值报体内容**************************************************

      try
            CopyMemory(@pbankgetdevicejy,@buf,SizeOf(pbankgetdevicejy));
            FillChar(pbanksetdevicejy,SizeOf(pbanksetdevicejy),0);
         //验证终端是否有效

//        mainclass.opendataset(adoqry,'select spare1 from dbo.ETCWorknetClientRecord where networkno='''+string(pbankgetqd.networkID)+''' and clientid like ''%'+string(pbankgetqd.TerminalID)+'%''');
           if mainclass.bdatabaseconnect then
            begin
                with adosp do
                begin
                    close;
                  errorid:=-1;
                  ProcedureName:='usp_bankDeviceID';
                  Parameters.Clear;
                  Parameters.CreateParameter('@clientid',ftstring,pdInput,50,string(pbankgetdevicejy.Deviceid));
                  Parameters.CreateParameter('@responsecode',ftstring,pdoutput,2,responsecode);
                      try
        //               errorid1:=0;

                          ExecProc;
                          responsecode:=parameters.ParamByName('@responsecode').Value;

                      except on e:exception do
                      begin
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;

                          mainclass.writeerrorlog('终端设备失败原因:'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                          ResponseCode:='97';  //终端设备校验失败
                      end;
                  end;


                end;
            end;

        if ResponseCode='00' then
        begin

            copymemory(@pbanksetdevicejy.networkID,@pbankgetdevicejy.networkID,SizeOf(pbankgetdevicejy.networkID));
            copymemory(@pbanksetdevicejy.TerminalID,@pbankgetdevicejy.TerminalID,SizeOf(pbankgetdevicejy.TerminalID));
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetdevicejy.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pbanksetdevicejy.ProcessDate),'0')),SizeOf(pbanksetdevicejy.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetdevicejy.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pbanksetdevicejy.Processtime),'0')),SizeOf(pbanksetdevicejy.Processtime));
        end;
     except
         responsecode:='97'; //签到失败!!!
     end;



            copymemory(@pbankSetdevicejy.ResponseCode,PChar(responsecode),2);
//***************************************************************************************************
    FillChar(tmpbuf,SizeOf(tmpbuf),0);
    CopyMemory(@tmpbuf,@pbanksetdevicejy,SizeOf(pbanksetdevicejy));
    self.sendbody(tmpbuf,'1006',SizeOf(pbanksetdevicejy));
    if Connection.Connected then
    begin
      try
          Connection.WriteBuffer(buf,bufsize);
          writedebuglog('来自'+ppackheadReceiver.SenderID+'请求设备校验发送成功'+pbankSetdevicejy.ResponseCode);
          if ResponseCode='00' then
              terminalok:=1;

      except
          WriteerrorLog('发送设备校验应答失败!!');
      end;
    end
    else
        WriteerrorLog('客户端请求中断');




end;

procedure TETCPeerThread.proc1007;
var
    strtmp:string;
   // strtmpid:string;
   // i:integer;
  // ls_sql:string;
begin
//**********************************************处理报文**************************************************
                 writedebuglog('1007');
                   FillChar(PCKFILEGETCZ,SizeOf(PCKFILEGETCZ),0);
                 CopyMemory(@PCKFILEGETCZ,@buf,SizeOf(PCKFILEGETCZ)) ;

                    idcbank.Host:=mainclass.bankserverip;
                    idcbank.Port:=mainclass.bankserverport;
                   try
                   idcbank.Disconnect ;
                   if not idcbank.connected then
                    idcbank.Connect(10000);
                   except on e:exception do
                   begin
                           responsecode:='09';
                           writedebuglog('发自IP为:'+idcbank.Host+'端口号为:'+inttostr(idcbank.Port)+'连接银行失败'+e.Message);
                   end;
                   end;
                    if idcbank.Connected  then
                    begin
                        if self.procbank1001 then
                        begin
                            if self.procbank1003 then
                            begin
                               FillChar(tmpbuf,SizeOf(tmpbuf),0);
                               CopyMemory(@tmpbuf,@PCKFILEGETCZ,SizeOf(PCKFILEGETCZ));
                              try
                               self.sendbodybank(tmpbuf,'1007',  sizeOf(PCKFILEGETCZ));
                               idcbank.WriteBuffer(buf,bufsize);
                                readbufbank();
                               except  on e:Exception  do
                               begin
                                  responsecode:= '09';
                                  writedebuglog('proc1007发送3银行失败'+e.Message);
                               end;
                               end;
                                    FillChar(PCKFILESETCZ,SizeOf(PCKFILESETCZ),0);
                                     CopyMemory(@PCKFILESETCZ,@buf,SizeOf(PCKFILESETCZ));
                                     responsecode:=PCKFILESETCZ.ResponseCode;
                              end
                              else
                              begin
                               responsecode:= '09';
                               end;

                        end
                        else
                        begin
                            writedebuglog('09来自'+ppackheadReceiver.SenderID+'获取加密因子失败');
                            responsecode:= '09';
                        end;
                    end;

//********************

            //FillChar(PCKFILESETCZ,SizeOf(PCKFILESETCZ),0);
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@PCKFILESETCZ.ProcessDate,pchar(strtmp),SizeOf(PCKFILESETCZ.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@PCKFILESETCZ.Processtime,pchar(strtmp),SizeOf(PCKFILESETCZ.Processtime));
            copymemory(@PCKFILESETCZ.ResponseCode,pchar(ResponseCode),SizeOf(PCKFILESETCZ.ResponseCode));
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@PCKFILESETCZ,SizeOf(PCKFILESETCZ));
            self.sendbody(tmpbuf,'1008',SizeOf(pbanksetbdcardkh));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
              except
              begin
                  responsecode:= '09';
              end;
              end;
            end
            else
             begin
               responsecode:= '09';
             end;

end;

procedure TETCPeerThread.proc2031;
var
    strtmp:string;
   // strtmpid:string;
    i:integer;
   // mac1:array[0..3] of byte;
   // strmsg:string;
   // imoney:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetzhcz,@buf,SizeOf(pbankgetzhcz));
            // 读取数据库
//      if i_ mod 2 =0 then
//      begin

      if mainclass.bdatabaseconnect then
       begin
            with adosp do
            begin
              close;
                try
              errorid:=-1;
              ProcedureName:='Usp_ETCPreCardRechargeBanklog_Local';
              Parameters.Clear;
              Parameters.CreateParameter('ProcessDate',ftString,pdInput,31,Trim(string(pbankgetzhcz.ProcessDate)));
              Parameters.CreateParameter('ProcessTime',ftString,pdInput,20,mainclass.padl(Trim(string(pbankgetzhcz.ProcessTime)),6,'0'));
              Parameters.CreateParameter('termdate',ftString,pdInput,31,Trim(string(pbankgetzhcz.ProcessDate)));
              Parameters.CreateParameter('termtime',ftString,pdInput,20,mainclass.padl(Trim(string(pbankgetzhcz.Processtime)),6,'0'));
              Parameters.CreateParameter('NetWorkID',ftString,pdInput,20,Trim(string(pbankgetzhcz.networkid)));
              Parameters.CreateParameter('TerminalID',ftString,pdInput,20,Trim(string(pbankgetzhcz.TerminalID)));
              Parameters.CreateParameter('CustomerID',ftString,pdInput,20,Trim(string(pbankgetzhcz.CustomerID)));
              Parameters.CreateParameter('PCardNetID',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('VCBindType',ftinteger,pdInput,4,mainclass.yxsj(string('')));
              Parameters.CreateParameter('vehplate',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('PCardID',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('CardBeforeMoney',ftInteger,pdInput,20,mainclass.yxsj(string(pbankgetzhcz.SysBeforeMoney)));
              Parameters.CreateParameter('CZMoney',ftinteger,pdInput,20,mainclass.yxsj(string(pbankgetzhcz.CZMoney)));
//              strtmp:=copy(string(pbankgetzhcz.BKMoney),pos('-',string(pbankgetzhcz.BKMoney)),12);
              Parameters.CreateParameter('BKMoney',ftinteger,pdInput,20,mainclass.yxsj('0'));
              Parameters.CreateParameter('TKMoney',ftinteger,pdInput,20,mainclass.yxsj(string('0')));//mainclass.yxsj(string(pbankgetczqq.TKMoney))
              Parameters.CreateParameter('WasteSN',ftString,pdInput,30,Trim(string(pbankgetzhcz.WasteSN)));
              Parameters.CreateParameter('OnlineSN',ftString,pdInput,10,Trim(string('')));
              Parameters.CreateParameter('OfflineSN ',ftString,pdInput,10,Trim(string('')));
              Parameters.CreateParameter('Random ',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('MAC1 ',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('MAC2 ',ftString,pdInput,20,string('0'));
              Parameters.CreateParameter('CZType',ftinteger,pdInput,4,13);
              Parameters.CreateParameter('OperatorID',ftString,pdInput,8,Trim(string('')));
              Parameters.CreateParameter('CZWasteSn',ftString,pdInput,4,string(''));
              Parameters.CreateParameter('termno',ftString,pdInput,12,string(''));
              Parameters.CreateParameter('CardSeq',ftString,pdInput,4,string(''));
              Parameters.CreateParameter('KeyIndex',ftString,pdInput,2,string(''));
              Parameters.CreateParameter('KeyId',ftString,pdInput,2,string(''));
              Parameters.CreateParameter('ResponseCode',ftstring,pdoutput,4,'');
              Parameters.CreateParameter('Errorid',ftinteger,pdoutput,4,errorid);
              Parameters.CreateParameter('ErrorMsg',ftString,pdoutput,50,ErrorMsg);


//               errorid1:=0;
                  ExecProc;

                  errorid:=parameters.ParamByName('errorid').Value;
                  ResponseCode:=parameters.ParamByName('ResponseCode').Value;
                  if errorid<0 then
                  begin
                      Errormsg:=parameters.ParamByName('errormsg').Value;
                    //  ResponseCode:='98';
                  end;

              except on e:exception do
              begin
                  for i:=0 to Parameters.count-1 do
                  begin
                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                  end;
                  mainclass.WriteerrorLog('2031流水号为：'+string(pbankgetczqq.WasteSN)+'的流水写入数据库失败,失败原因为'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                  ResponseCode:='98';
              end;
              end;
             end;
       end;
{       end
       else
       begin
           ResponseCode:='98'
       end;
       i_:=i_+1;
}
            FillChar(pbanksetzhcz,SizeOf(pbanksetzhcz),0);

                //********************************************************************************
            if ResponseCode='00' then
            begin
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetzhcz.ProcessDate,PChar(strtmp),SizeOf(pbanksetzhcz.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pbanksetzhcz.Processtime,PChar(strtmp),SizeOf(pbanksetzhcz.Processtime));
                copymemory(@pbanksetzhcz.NetWorkID,@pbankgetzhcz.NetWorkID,SizeOf(pbanksetzhcz.NetWorkID));
                copymemory(@pbanksetzhcz.usertype,@pbankgetzhcz.usertype,SizeOf(pbanksetzhcz.UserType));
                copymemory(@pbanksetzhcz.username,@pbankgetzhcz.username,SizeOf(pbanksetzhcz.username));
                copymemory(@pbanksetzhcz.TerminalID,@pbankgetzhcz.TerminalID,SizeOf(pbanksetzhcz.TerminalID));
                copymemory(@pbanksetzhcz.CustomerID,@pbankgetzhcz.CustomerID,SizeOf(pbanksetzhcz.CustomerID));
                copymemory(@pbanksetzhcz.wastesn,@pbankgetzhcz.wastesn,SizeOf(pbanksetzhcz.wastesn));
            end;
            copymemory(@pbanksetzhcz.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetzhcz.ResponseCode));

//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetzhcz,SizeOf(pbanksetzhcz));
            self.sendbody(tmpbuf,'2032',SizeOf(pbanksetzhcz));
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writelog('用户号：'+pbanksetzhcz.CustomerID+'账户充值请求发送成功，充值金额为'+mainclass.yxsj(string(pbankgetzhcz.CZMoney)));
              except
                  WriteerrorLog('充值请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2033;
var
    strtmp:string;
  //  strtmpid:string;
    i:integer;
  //  mac1:array[0..3] of byte;
  //  strmsg:string;
   // imoney:integer;
begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetzhcz,@buf,SizeOf(pbankgetzhcz));
            // 读取数据库
//      if i_ mod 2 =0 then
//      begin

      if mainclass.bdatabaseconnect then
       begin
            with adosp do
            begin
              close;
                try
              errorid:=-1;
              ProcedureName:='Usp_ETCPreCardRechargeBanklog_Local';
              Parameters.Clear;
              Parameters.CreateParameter('ProcessDate',ftString,pdInput,31,Trim(string(pbankgetzhcz.ProcessDate)));
              Parameters.CreateParameter('ProcessTime',ftString,pdInput,20,mainclass.padl(Trim(string(pbankgetzhcz.ProcessTime)),6,'0'));
              Parameters.CreateParameter('termdate',ftString,pdInput,31,Trim(string(pbankgetzhcz.ProcessDate)));
              Parameters.CreateParameter('termtime',ftString,pdInput,20,mainclass.padl(Trim(string(pbankgetzhcz.Processtime)),6,'0'));
              Parameters.CreateParameter('NetWorkID',ftString,pdInput,20,Trim(string(pbankgetzhcz.networkid)));
              Parameters.CreateParameter('TerminalID',ftString,pdInput,20,Trim(string(pbankgetzhcz.TerminalID)));
              Parameters.CreateParameter('CustomerID',ftString,pdInput,20,Trim(string(pbankgetzhcz.CustomerID)));
              Parameters.CreateParameter('PCardNetID',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('VCBindType',ftinteger,pdInput,4,mainclass.yxsj(string('')));
              Parameters.CreateParameter('vehplate',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('PCardID',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('CardBeforeMoney',ftInteger,pdInput,20,mainclass.yxsj(string(pbankgetzhcz.SysBeforeMoney)));
              Parameters.CreateParameter('CZMoney',ftinteger,pdInput,20,mainclass.yxsj(string(pbankgetzhcz.CZMoney)));
//              strtmp:=copy(string(pbankgetzhcz.BKMoney),pos('-',string(pbankgetzhcz.BKMoney)),12);
              Parameters.CreateParameter('BKMoney',ftinteger,pdInput,20,mainclass.yxsj('0'));
              Parameters.CreateParameter('TKMoney',ftinteger,pdInput,20,mainclass.yxsj(string('0')));//mainclass.yxsj(string(pbankgetczqq.TKMoney))
              Parameters.CreateParameter('WasteSN',ftString,pdInput,30,Trim(string(pbankgetzhcz.WasteSN)));
              Parameters.CreateParameter('OnlineSN',ftString,pdInput,10,Trim(string('')));
              Parameters.CreateParameter('OfflineSN ',ftString,pdInput,10,Trim(string('')));
              Parameters.CreateParameter('Random ',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('MAC1 ',ftString,pdInput,20,Trim(string('')));
              Parameters.CreateParameter('MAC2 ',ftString,pdInput,20,string('0'));
              Parameters.CreateParameter('CZType',ftinteger,pdInput,4,23);
              Parameters.CreateParameter('OperatorID',ftString,pdInput,8,Trim(string('')));
              Parameters.CreateParameter('CZWasteSn',ftString,pdInput,4,string(''));
              Parameters.CreateParameter('termno',ftString,pdInput,12,string(''));
              Parameters.CreateParameter('CardSeq',ftString,pdInput,4,string(''));
              Parameters.CreateParameter('KeyIndex',ftString,pdInput,2,string(''));
              Parameters.CreateParameter('KeyId',ftString,pdInput,2,string(''));
              Parameters.CreateParameter('ResponseCode',ftstring,pdoutput,4,'');
              Parameters.CreateParameter('Errorid',ftinteger,pdoutput,4,errorid);
              Parameters.CreateParameter('ErrorMsg',ftString,pdoutput,50,ErrorMsg);


//               errorid1:=0;
                  ExecProc;

                  errorid:=parameters.ParamByName('errorid').Value;
                  ResponseCode:=parameters.ParamByName('ResponseCode').Value;
                  if errorid<0 then
                  begin
                      Errormsg:=parameters.ParamByName('errormsg').Value;
                      ResponseCode:='98';
                  end;

              except on e:exception do
              begin
                  for i:=0 to Parameters.count-1 do
                  begin
                      strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                  end;
                  mainclass.WriteerrorLog('2033流水号为：'+string(pbankgetczqq.WasteSN)+'的流水写入数据库失败,失败原因为'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                  ResponseCode:='98';
              end;
              end;
             end;
       end;
{       end
       else
       begin
           ResponseCode:='98'
       end;
       i_:=i_+1;
}
            FillChar(pbanksetczqq,SizeOf(pbankgetczqq),0);

                //********************************************************************************
            if ResponseCode='00' then
            begin
                strtmp:=FormatDateTime('yyyymmdd',now);
                copymemory(@pbanksetczqq.ProcessDate,PChar(strtmp),SizeOf(pbanksetzhcz.ProcessDate));
                strtmp:=FormatDateTime('hhmmss',now);
                copymemory(@pbanksetzhcz.Processtime,PChar(strtmp),SizeOf(pbanksetzhcz.Processtime));
                copymemory(@pbanksetzhcz.NetWorkID,@pbankgetzhcz.NetWorkID,SizeOf(pbanksetzhcz.NetWorkID));
                copymemory(@pbanksetzhcz.username,@pbankgetzhcz.username,SizeOf(pbanksetzhcz.username));
                copymemory(@pbanksetzhcz.TerminalID,@pbankgetzhcz.TerminalID,SizeOf(pbanksetzhcz.TerminalID));
                copymemory(@pbanksetzhcz.CustomerID,@pbankgetzhcz.CustomerID,SizeOf(pbanksetzhcz.CustomerID));
                copymemory(@pbanksetzhcz.wastesn,@pbankgetzhcz.wastesn,SizeOf(pbanksetzhcz.wastesn));
            end;
            copymemory(@pbanksetzhcz.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetzhcz.ResponseCode));

//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetzhcz,SizeOf(pbanksetzhcz));
            self.sendbody(tmpbuf,'2034',SizeOf(pbanksetzhcz));
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writelog('来自'+ppackheadReceiver.SenderID+'用户号：'+pbanksetzhcz.CustomerID+'账户充值冲正请求发送成功');
              except
                  WriteerrorLog('充值请求失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;

procedure TETCPeerThread.proc2035;
var
    strtmp:string;
    i:integer;
    arr_bankgetfxmx:array of tbankgetfxmx;
    i_fpmxcount:integer;
    sss,mmm: string;

begin
//**********************************************处理报文**************************************************
          mainclass.writeerrorlog('0');
          FillChar(pBankZHFPQQ,SizeOf(pBankZHFPQQ),0);
            CopyMemory(@pBankZHFPQQ,@buf,SizeOf(pBankZHFPQQ));
                mainclass.writeerrorlog('1');
        if mainclass.bdatabaseconnect then
        begin
                with adosp do
                begin
                    close;
                  errorid:=-1;
                  ProcedureName:='USP_CheckCustomerQuanCun';
                  Parameters.Clear;
                  Parameters.CreateParameter('@CustomerID',ftString,pdInput,50,trim(string(pBankZHFPQQ.CustomerID)));
                  Parameters.CreateParameter('@SelDate',ftInteger,pdInput,4,strtoint(Trim(string(pBankZHFPQQ.ProcessDate))));

                  Parameters.CreateParameter('@QuanCunMoney',ftInteger,pdInput,4,0);
                  Parameters.CreateParameter('@Mode',ftinteger,pdInput,4,0);

                  Parameters.CreateParameter('@AfterCustomerLeftMoney',ftinteger,pdoutput,4,0);
                  Parameters.CreateParameter('@AfterQuanCunWaitMoney',ftinteger,pdoutput,4,0);
                  mainclass.writeerrorlog('7');
                  try
        //               errorid1:=0;
                          ExecProc;
                          mainclass.writeerrorlog('8');
                          mmm:=parameters.ParamByName('@AfterCustomerLeftMoney').Value;

                      //  copymemory(@pBankZHFPYD.SysBeforeMoney,PChar(mainclass.padl(sss,SizeOf(pBankZHFPYD.SysBeforeMoney),' ')),SizeOf(pBankZHFPYD.SysBeforeMoney));
                      except on e:exception do
                      begin
                          mainclass.writeerrorlog('2035原因:'+e.message+' sql:exec '+ProcedureName);
                          ResponseCode:='58';  //快通卡查询错误
                      end;
                  end;


                end;

        end;
           if StrToInt(mmm)>=StrToInt(pBankZHFPQQ.FPMONEY) then                //分配前对比账户余额是否够本次分配
           begin
              i_fpmxcount:= Round((recivelength-SizeOf(pBankZHFPQQ))/40);
              mainclass.writeerrorlog('count:' + IntToStr(i_fpmxcount));
              SetLength(arr_bankgetfxmx,i_fpmxcount);
             if mainclass.bdatabaseconnect and (i_fpmxcount >0) then
             begin
//                adoconn.BeginTrans;
                try
                  mainclass.writeerrorlog('3');

                  for i:=0 to i_fpmxcount - 1 do
                  begin
                   CopyMemory(@arr_bankgetfxmx[i],@buf[SizeOf(pBankZHFPQQ)+i*40],40);
                   mainclass.writeerrorlog('31');
                    with adosp do
                    begin
                      close;
                      errorid:=-1;
                      ProcedureName:='proc_ETCQuanrechargelog';
                      Parameters.Clear;
                      Parameters.CreateParameter('@CustomerID',ftString,pdInput,20,trim(string(pBankZHFPQQ.CustomerID)));
                      Parameters.CreateParameter('@Vehplate',ftString,pdInput,10,Trim(string(arr_bankgetfxmx[i].vehplate)));

                      Parameters.CreateParameter('@PCardNetID',ftString,pdInput,4,Trim(string(arr_bankgetfxmx[i].pnetcardid)));
                      Parameters.CreateParameter('@PCardID',ftString,pdInput,16,Trim(string(arr_bankgetfxmx[i].pcardid)));

                      Parameters.CreateParameter('@KQCMoney',ftInteger,pdInput,4,strtoint(Trim(arr_bankgetfxmx[i].fpmoney)));

                       mainclass.writeerrorlog('loop'+adosp.ProcedureName);
                      ExecProc;
                      mainclass.writeerrorlog('loop'+IntToStr(I));
                    end;

                  end;
                  mainclass.writeerrorlog('4');
 //                 adoconn.CommitTrans;

                  except on e:exception do
                  begin
 //                     adoconn.RollbackTrans;
                      mainclass.writeerrorlog('账户分配失败原因:'+e.message+' sql:exec '+adosp.ProcedureName);
                      ResponseCode:='57';  //
                  end;
                  end;
             end;
           end
           else
           begin
             ResponseCode:='08';
             mainclass.writeerrorlog('账户'+pbankzhfpqq.CustomerID+'账户余额'+mmm+'<分配金额，不能进行分配业务！');
           end;

            mainclass.writeerrorlog('5');
            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pBankZHFPYD.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pBankZHFPYD.ProcessDate),'0')),SizeOf(pBankZHFPYD.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pBankZHFPYD.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pBankZHFPYD.Processtime),'0')),SizeOf(pBankZHFPYD.Processtime));
            copymemory(@pBankZHFPYD.ResponseCode,pchar(responsecode),2);
            copymemory(@pBankZHFPYD.NetWorkID,@pBankZHFPQQ.NetWorkID,SizeOf(pBankZHFPYD.NetWorkID));
            copymemory(@pBankZHFPYD.TerminalID,@pBankZHFPQQ.TerminalID,SizeOf(pBankZHFPYD.TerminalID));
            copymemory(@pBankZHFPYD.CustomerID,@pBankZHFPQQ.CustomerID,SizeOf(pBankZHFPYD.CustomerID));

            copymemory(@pBankZHFPYD.UserType,@pBankZHFPQQ.UserType,SizeOf(pBankZHFPYD.UserType));
            copymemory(@pBankZHFPYD.UserName,@pBankZHFPQQ.UserName,SizeOf(pBankZHFPYD.UserName));
            copymemory(@pBankZHFPYD.FPMoney,PChar(mainclass.padl(pBankZHFPQQ.FPMoney,12,'0')),SizeOf(pBankZHFPYD.FPMoney));

             copymemory(@pBankZHFPYD.WasteSN,PChar(mainclass.padl(pBankZHFPQQ.WasteSN, 12, '0')),SizeOf(pBankZHFPYD.WasteSN));
            mainclass.writeerrorlog('6');

     // -------返回账户余额--------------
            // 读取数据库
            if mainclass.bdatabaseconnect then
        begin
                with adosp do
                begin
                    close;
                  errorid:=-1;
                  ProcedureName:='USP_CheckCustomerQuanCun';
                  Parameters.Clear;
                  Parameters.CreateParameter('@CustomerID',ftString,pdInput,50,trim(string(pBankZHFPQQ.CustomerID)));
                  Parameters.CreateParameter('@SelDate',ftInteger,pdInput,4,strtoint(Trim(string(pBankZHFPQQ.ProcessDate))));

                  Parameters.CreateParameter('@QuanCunMoney',ftInteger,pdInput,4,0);
                  Parameters.CreateParameter('@Mode',ftinteger,pdInput,4,0);

                  Parameters.CreateParameter('@AfterCustomerLeftMoney',ftinteger,pdoutput,4,0);
                  Parameters.CreateParameter('@AfterQuanCunWaitMoney',ftinteger,pdoutput,4,0);
                  mainclass.writeerrorlog('7');
                      try
        //               errorid1:=0;
                          ExecProc;
                          mainclass.writeerrorlog('8');
                          sss:=parameters.ParamByName('@AfterCustomerLeftMoney').Value;

                        copymemory(@pBankZHFPYD.SysBeforeMoney,PChar(mainclass.padl(sss,SizeOf(pBankZHFPYD.SysBeforeMoney),' ')),SizeOf(pBankZHFPYD.SysBeforeMoney));
                      except on e:exception do
                      begin
                          mainclass.writeerrorlog('2035原因:'+e.message+' sql:exec '+ProcedureName);
                          ResponseCode:='58';  //快通卡查询错误
                      end;
                  end;


                end;

        end;
           mainclass.writeerrorlog('9');
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pBankZHFPYD,SizeOf(pBankZHFPYD));
            self.sendbody(tmpbuf,'2036',SizeOf(pBankZHFPYD));
            mainclass.writeerrorlog('10');
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writelog('来自'+ppackheadReceiver.SenderID+'卡号'+pbanksetzhczquery.CertificateID+'账户查询发送成功');
              except
                  WriteerrorLog('账户查询失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;


procedure TETCPeerThread.proc2037;
var
    strtmp:string;
   // strtmpid:string;
    i:integer;
    TempBuf: array[0..8216] of Byte;
    tsize:integer;

  procedure CombineData(var ds: TDataSet);
  var                     //pBankDKHCLXX
    I: Integer;
    Temp: array[0..7999] of AnsiChar;
  begin
    WriteerrorLog('c1');
    FillChar(Temp, sizeof(Temp), 0);
    ds.First;
    for I := 0 to ds.RecordCount - 1 do
    begin
      copymemory(@Temp[I * 40],PChar(ds.FieldByName('vehicleplateno').asstring),10);
      copymemory(@Temp[I * 40 + 10],PChar(ds.FieldByName('netcardid').asstring),4);
      copymemory(@Temp[I * 40 + 14],PChar(ds.FieldByName('cardid').asstring),16);
      copymemory(@Temp[I * 40 + 30],PChar(mainclass.padl(ds.FieldByName('kqcmoney').asstring,10,'0')),10);
      ds.Next;
    end;
    WriteerrorLog('c4');
    I:=ds.RecordCount;
    copymemory(@TempBuf[241],@Temp,40*I);
    tsize := 241 +  40*I;
   // WriteerrorLog('c5');
  end;

begin
//**********************************************处理报文**************************************************
         try
            CopyMemory(@pbankgetzhczquery,@buf,SizeOf(pbankgetzhczquery));
            FillChar(pbanksetzhczquery,SizeOf(pbanksetzhczquery),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetzhczquery.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pbanksetzhczquery.ProcessDate),'0')),SizeOf(pbanksetzhczquery.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetzhczquery.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pbanksetzhczquery.Processtime),'0')),SizeOf(pbanksetzhczquery.Processtime));
            copymemory(@pbanksetzhczquery.NetWorkID,@pbankgetzhczquery.NetWorkID,SizeOf(pbankgetzhczquery.NetWorkID));
            copymemory(@pbanksetzhczquery.TerminalID,@pbankgetzhczquery.TerminalID,SizeOf(pbankgetzhczquery.TerminalID));
//            copymemory(@pbanksetzhczquery.CustomerID,@pbankgetzhczquery.CustomerID,SizeOf(pbankgetzhczquery.CustomerID));
//            copymemory(@pbanksetzhczquery.userpassword,@pbankgetzhczquery.userpassword,SizeOf(pbankgetzhczquery.userpassword));
            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin


                with adosp do
                begin
                  close;
                  errorid:=-1;
                  ProcedureName:='Usp_ExpcustomInfoQuery';
                  Parameters.Clear;
                  Parameters.CreateParameter('@CustomerID',ftString,pdInput,20,trim(string(pbankgetzhczquery.CustomerID)));
                  Parameters.CreateParameter('@userpassword',ftString,pdInput,20,Trim(string(pbankgetzhczquery.userpassword)));

                  Parameters.CreateParameter('@AfterCustomerLeftMoney',ftLargeint,pdoutput,4,0);
                  Parameters.CreateParameter('@AfterQuanCunWaitMoney',ftLargeint,pdoutput,4,0);

                  Parameters.CreateParameter('@usertype',ftinteger,pdoutput,4,0);
                  Parameters.CreateParameter('@username',ftstring,pdoutput,100,'');
                  Parameters.CreateParameter('@CertificateType',ftinteger,pdoutput,4,0);
                  Parameters.CreateParameter('@CertificateID',ftstring,pdoutput,60,'');

                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);
                  try
        //               errorid1:=0;
                          ExecProc;

                          ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
                          if ResponseCode='00' then
                              begin
//                                  copymemory(@pbanksetzhczquery.CustomerID,PChar(mainclass.padr(parameters.ParamByName('CustomerID').AsString,SizeOf(pbanksetzhczquery.CustomerID),' ')),SizeOf(pbanksetzhczquery.CustomerID));
                                  copymemory(@pbanksetzhczquery.UserType,PChar(mainclass.padl(IntToStr(parameters.ParamByName('@usertype').Value),SizeOf(pbanksetzhczquery.UserType),'0')),SizeOf(pbanksetzhczquery.UserType));
                                  copymemory(@pbanksetzhczquery.UserName,PChar(mainclass.padr(parameters.ParamByName('@username').Value,SizeOf(pbanksetzhczquery.UserName),' ')),SizeOf(pbanksetzhczquery.UserName));
                                  copymemory(@pbanksetzhczquery.CertificateType,PChar(mainclass.padl(IntToStr(parameters.ParamByName('@CertificateType').Value),SizeOf(pbanksetzhczquery.CertificateType),'0')),SizeOf(pbanksetzhczquery.CertificateType));
                                  copymemory(@pbanksetzhczquery.CertificateID,PChar(mainclass.padr(parameters.ParamByName('@CertificateID').Value,SizeOf(pbanksetzhczquery.CertificateID),' ')),SizeOf(pbanksetzhczquery.CertificateID));
                                  copymemory(@pbanksetzhczquery.SysBeforeMoney,PChar(mainclass.padl(IntToStr(parameters.ParamByName('@AfterCustomerLeftMoney').Value),12,'0')),SizeOf(pbanksetzhczquery.SysBeforeMoney));
                                  copymemory(@pbanksetzhczquery.kqcmoney,PChar(mainclass.padl(IntToStr(parameters.ParamByName('@AfterQuanCunWaitMoney').Value),12,'0')),SizeOf(pbanksetzhczquery.kqcmoney));
                              end;
                  except on e:exception do
                      begin
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog('充值查询失败原因:'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                          ResponseCode:='56';  //快通卡查询错误
                      end;
                  end;


                end;

            end;

//***********************************************************************************************************
           if ResponseCode='00' then
           begin
           if mainclass.bdatabaseconnect then
            begin
               with self.adoqry do
                begin
                    Close;
                    SQL.Text:='exec proc_qrycurstomcarinfo '''+trim(string(pbankgetzhczquery.CustomerID))+''','''+trim(string(pbankgetzhczquery.CardID))+'''';
                  //  SQL.Text:='exec proc_qrycurstomcarinfo '''+trim(string(pbankgetzhczquery.CustomerID))+'''';
                    WriteerrorLog(SQL.Text);
                    Open;
                    if RecordCount<1 then ResponseCode:='58';
                end;
            end;
            end;
            copymemory(@pbanksetzhczquery.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetzhcz.ResponseCode));
            FillChar(TempBuf,SizeOf(TempBuf),0);
            CopyMemory(@TempBuf,@pbanksetzhczquery,SizeOf(pbanksetzhczquery));

            if ResponseCode='00' then
               begin
                CombineData(tdataset(adoqry));
               end
            else
              tsize := 241;

            self.sendbody(TempBuf,'2038',tsize);
            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
                  writelog('来自'+ppackheadReceiver.SenderID+'卡号'+pbanksetzhczquery.CertificateID+'账户查询发送成功');
              except
                  WriteerrorLog('账户查询失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');
         except on e:exception do
                  begin
                    writeerrorlog('账户信息查询失败:'+e.message);
                    ResponseCode:='97';
                  end;
         end;
end;

procedure TETCPeerThread.proc2039;
var
    strtmp:string;
   // strtmpid:string;
    i:integer;

begin
//**********************************************处理报文**************************************************
            CopyMemory(@pbankgetusermodypassword,@buf,SizeOf(pbankgetusermodypassword));
            FillChar(pbanksetusermodypassword,SizeOf(pbanksetusermodypassword),0);

            strtmp:=FormatDateTime('yyyymmdd',now);
            copymemory(@pbanksetusermodypassword.ProcessDate,PChar(mainclass.padl(strtmp,SizeOf(pbanksetusermodypassword.ProcessDate),'0')),SizeOf(pbanksetusermodypassword.ProcessDate));
            strtmp:=FormatDateTime('hhmmss',now);
            copymemory(@pbanksetusermodypassword.Processtime,PChar(mainclass.padl(strtmp,SizeOf(pbankgetusermodypassword.Processtime),'0')),SizeOf(pbanksetusermodypassword.Processtime));
            copymemory(@pbanksetusermodypassword.NetWorkID,@pbankgetusermodypassword.NetWorkID,SizeOf(pbanksetusermodypassword.NetWorkID));
            copymemory(@pbanksetusermodypassword.TerminalID,@pbankgetusermodypassword.TerminalID,SizeOf(pbanksetusermodypassword.TerminalID));

            // 读取数据库
            if mainclass.bdatabaseconnect then
            begin
                with adosp do
                begin
                    close;
                  errorid:=-1;
                  ProcedureName:='Usp_modiypassword';
                  Parameters.Clear;
                  Parameters.CreateParameter('@CustomerID',ftstring,pdInput,20,string(pbankgetusermodypassword.CustomerID));
                  Parameters.CreateParameter('@password',ftString,pdInput,20,string(pbankgetusermodypassword.password));
                  Parameters.CreateParameter('@newpassword',ftString,pdInput,20,string(pbankgetusermodypassword.newpassword));
                  Parameters.CreateParameter('@ResponseCode',ftstring,pdoutput,2,ResponseCode);

                      try
        //               errorid1:=0;
                          ExecProc;
                          ResponseCode:=parameters.ParamByName('@ResponseCode').Value;
{                          if RecordCount=0 then
                          begin
                              ResponseCode:='53'; //修改密码失败
                          end;
}

                      except on e:exception do
                      begin
                          for i:=0 to Parameters.count-1 do
                          begin
                              strtmp:=strtmp+string(Parameters[i].Value)+''',''';
                          end;
                          mainclass.writeerrorlog('修改密码失败原因:'+e.message+' sql:exec '+ProcedureName+''''+copy(strtmp,1,Length(strtmp)-2));
                         ResponseCode:='53'; //修改密码失败
                      end;
                  end;


                end;

        end;

            copymemory(@pbanksetusermodypassword.ResponseCode,PChar(ResponseCode),SizeOf(pbanksetusermodypassword.ResponseCode));


//***********************************************************************************************************
            FillChar(tmpbuf,SizeOf(tmpbuf),0);
            CopyMemory(@tmpbuf,@pbanksetusermodypassword,SizeOf(pbanksetusermodypassword));
            self.sendbody(tmpbuf,'2040',SizeOf(pbanksetusermodypassword));

            if Connection.Connected then
            begin
              try
                  Connection.WriteBuffer(buf,bufsize);
              except
                  WriteerrorLog('修改密码失败!!');
              end;
            end
            else
                WriteerrorLog('客户端请求中断');

end;


end.
