unit Unit1;

interface
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}   // Unit 'FileCtrl' is specific to a platform(说明程序不能运行在非windows的平台)
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer,StrUtils,ETCBANK_interface,u_work,
  ExtCtrls, IdTCPConnection, IdTCPClient,IniFiles,UntJMJ,FileCtrl, ComCtrls,SQLADOPoolUnit,
  GridsEh, DBGridEh;
  type
 TSimpleClient = Record
   id: longint;            //系统编号
   utype: string;          //gprs, emp, unknow
   Name: string;           //手机号,登录操作员名称
   IP: string;             //IP
   Port: integer;          //端口
   Status: string;         //NULL  登录中  操作中
   LastTime: integer;      //登录时间
   UpdateTime: Integer;    //更新时间
   HardWare: String;       //硬件类型
   DataBackTime: Integer;  //监控时间, 超时则断开
 end;

 PClient = ^TSimpleClient;

type



  TForm1 = class(TForm)
    idtcpsrvr1: TIdTCPServer;
    IdTCPClient1: TIdTCPClient;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel2: TPanel;
    mmo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button8: TButton;
    Button3: TButton;
    Button7: TButton;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Panel4: TPanel;
    DBGridEh1: TDBGridEh;
    Button9: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure idtcpsrvr1Connect(AThread: TIdPeerThread);
    procedure idtcpsrvr1Exception(AThread: TIdPeerThread;
      AException: Exception);
    procedure idtcpsrvr1Execute(AThread: TIdPeerThread);
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure idtcpsrvr1Disconnect(AThread: TIdPeerThread);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FList: TList;
    flogentry:string;
    freceived:string;
    sendservice:tsendservice;
    procedure addlogentry;
    procedure displaydata;
    procedure test(var aa:array of byte;bb:pchar);
    function getfile(var FileList:Tstringlist;filepath:string;filetype:string):boolean;
  public
   AETCthread:TETCPeerThread;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
     uwork, dm,adodb, UnitProcessList, UETCCX;
//将16进制字符串转为Char存储
procedure HexStringtoChar(HexStr: string; var ResCharAry: array of char);
var
  i: integer;
  TemStr: string;
  CharLen: integer;
begin
  CharLen := Round(Length(HexStr) div 2);
  FillChar(ResCharAry, SizeOf(ResCharAry), 0);
  SetLength(TemStr, 3);

  for i := 0 to CharLen - 1 do
  begin
    TemStr[1] := '$';
    TemStr[2] := HexStr[i * 2 + 1];
    TemStr[3] := HexStr[i * 2 + 2];
    ResCharAry[i] := Char(StrToInt(TemStr));
  end;
end;
procedure TForm1.addlogentry;
begin
    self.mmo1.Lines.Append(flogentry);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    try
        dmform.adocn.Connected:=true;
        mainclass.bdatabaseconnect:=true;
    except
        mainclass.WriteerrorLog('数据库连接失败！');
        application.Terminate;
    end;
    //服务端
    {idtcpsrvr1.ThreadClass := TETCPeerThread    ;
    self.idtcpsrvr1.Active:=True;
    Self.Button1.Enabled:=false;
    self.Button2.Enabled:=true; }
     //客户端
     sendservice:=tsendservice.Create(false);
     self.mmo1.Lines.Append(DateTimeToStr(now)+'ABV服务器已成功启动!');
     sendservice.Start;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin

    Button1.Enabled:=true;
    self.Button2.Enabled:=false;
    sendservice.Stop;

      //idtcpsrvr1.Active:=False;
   //endservice.Free;

    self.mmo1.Lines.Append(DateTimeToStr(now)+'服务器已成功停止');
end;

procedure TForm1.displaydata;
begin
    self.mmo1.Lines.Append(DateTimeToStr(now)+'接收内容'+freceived);
end;

procedure TForm1.idtcpsrvr1Connect(AThread: TIdPeerThread);
//连接时控制
begin
    self.mmo1.Lines.Append(DateTimeToStr(now)+'当前连接数：'+inttostr(FList.Count));
    self.mmo1.Lines.Append(DateTimeToStr(now)+'连接池数量：'+inttostr(ADOPool.ConnectionCount));
    FLIst.Add(AThread);
end;

procedure TForm1.idtcpsrvr1Exception(AThread: TIdPeerThread;
  AException: Exception);
//  var
//     scommand:string;
begin
{      with AThread.Connection do
      begin
          scommand:=ReadLn();
          flogentry:=scommand+'来自于主机'+socket.Binding.PeerIP;
          AThread.Synchronize(addlogentry);
          if leftstr(scommand,4)='DATA' then
          begin
              freceived:=rightstr(scommand,length(scommand)-5);
              WriteLn('200:数据接收成功');
              AThread.Synchronize(displaydata);
          end
          else
          begin
              if SameText(scommand,'QUIT') then
              begin
                  flogentry:='断开同主机' +athread.Connection.Socket.Binding.PeerIP+'的连接!';
                  AThread.Synchronize(addlogentry);
                  Disconnect;
              end
              else
              begin
                  WriteLn('500:无法识别的命令!');
                  flogentry:='无法识别的命令!'+scommand;
                  AThread.Synchronize(addlogentry);
              end;
          end;
        //1337229400000844
      end;
}
//      FList.Remove(AThread);
end;

procedure TForm1.idtcpsrvr1Execute(AThread: TIdPeerThread);
var
//    AETCthread:TETCPeerThread;
    ilength:integer;
begin
    try
    AETCthread :=  TETCPeerThread(AThread);
    with AETCthread do
      begin
          FillChar(bufhead,SizeOf(bufhead),0);
          try
             Connection.ReadBuffer(bufhead,SizeOf(ppackheadReceiver));
             CopyMemory(@ppackheadReceiver,@bufhead,SizeOf(ppackheadReceiver));
             networkid:=ppackheadReceiver.senderid;
            // WriteLog(DateTimeToStr(now)+'报头:'+bufhead);
            // WriteLog(DateTimeToStr(now)+'报头:'+mainclass.arraytostr1(bufhead));

             self.mmo1.Lines.Append(DateTimeToStr(now)+'来自主机'+athread.Connection.Socket.Binding.PeerIP+'发送id为'+ppackheadReceiver.SenderID+'报文类型'+ppackheadReceiver.MessageType+'连接请求已经被接纳'+inttostr(Self.mmo1.Lines.Count));
             if(Self.mmo1.Lines.Count>1000)then
                 Self.mmo1.Lines.Clear;
             ProcessBuf;
             if errorid<0 then
             begin
                self.mmo1.Lines.Append(errormsg);
             end;
             if ResponseCode<>'00' then
             begin
                 self.mmo1.Lines.Append(DateTimeToStr(now)+Connection.Socket.Binding.PeerIP+mainclass.errorname(ResponseCode));
             end;
           
             FList.Remove(AThread);
             if ppackheadReceiver.MessageType>'1003' then
             begin
               AThread.FreeOnTerminate:=True;
             end;

          except on e:exception do
          begin
               responsecode:= '09';
//               mainclass.WriteerrorLog('idtcpsrvr1Execute:'+e.Message );
          end;
          end;
      end;
    except
      FList.Remove(AThread);
//      AETCthread.Free ;
    end;
   //
end;

{ TETCPeerThread }


procedure TForm1.FormShow(Sender: TObject);
var
    ini:tinifile;
    strpath:string;


begin
    strpath:=ExtractFilePath(ParamStr(0));
    ini:=TIniFile.Create(strpath+'\control.ini');
    mainclass.defaultkey    :=ini.ReadString('NodeInformation','defaultkey','1211');
    mainclass.TerminalID    :=ini.ReadString('NodeInformation','TerminalID','');
    mainclass.NetWorkID     :=ini.ReadString('NodeInformation','NetWorkID','1400000');
    mainclass.nodeid        :=ini.ReadString('NodeInformation','NetWorkID','1400000');
    mainclass.bflagworklog  := ini.ReadBool ('NodeInformation','开启工作日志',true);
    mainclass.bflagdebuglog :=ini.ReadBool  ('NodeInformation','开启调试日志',true);
    mainclass.bflagerrorlog :=ini.ReadBool  ('NodeInformation','开启错误日志',true);
    mainclass.SJMJSERVERIP  :=ini.ReadString('JMJ','serverip','10.14.161.11');
    mainclass.SJMJPORT      :=ini.ReadString('JMJ','port','8');
    mainclass.bankid        :=ini.readstring(' NodeInformation','bankid','');
    mainclass.bankname        :=ini.readstring(' NodeInformation','bankname','');    
    mainclass.bankserverip  := ini.ReadString('NodeInformation','bankserverip','127.0.0.1');
    mainclass.bankserverport:= ini.ReadInteger('NodeInformation','bankserverport',4001);
    idtcpsrvr1.defaultport  :=ini.ReadInteger('NodeInformation','port',6001);
    mmo1.Lines.Add( mainclass.defaultkey) ;
   { try
      dmform.adocn.Connected:=true;
        mainclass.bdatabaseconnect:=true;
    except
        mainclass.bdatabaseconnect:=false;
        application.MessageBox('数据库连接失败,请检查网络后再试','系统操作向导',mb_ok+MB_ICONASTERISK);
        application.Terminate;
    end; }

//    mainclass.bdatabaseconnect:=false;
    self.Button1.Click;
    FList:= TList.Create;
//********************************************

 {   begin
        ini:=TIniFile.create(ExtractFilePath(ParamStr(0))+'etcbank.ini');

        //TerminalID:=ini.ReadString('info','TerminalID','');
        ///networkid:=ini.ReadString('info','networkID','');
        self.IdTCPClient1.Host:=ini.ReadString('info','serverip','127.0.0.1');
        self.IdTCPClient1.Port:=ini.Readinteger('info','port',6001);
       //  mainclass.defaultkey:=ini.Readstring('NodeInformation','defaultkey','1122334444332211');
      //  mainclass.defaultkey:='1122334444332211';
        ini.Free;
    end;  }
    //ini文件后缀更名为LXH，方便远程安全下载更新
  ADOConfig := TADOConfig.Create(ExtractFilePath(ParamStr(0))+'control.ini');
  ADOPool := TADOPool.Create(1500);

end;


procedure TForm1.Button4Click(Sender: TObject);
const
//      indatatmp:array[0..31] of byte=(50, 48, 49, 51, 48, 56, 49, 57, 49, 49, 50, 50, 49, 53, 57, 57, 57, 0, 0, 0, 0, 48, 48, 48, 48, 48, 48, 0, 0, 0, 0,10);
//indatatmp:array[0..55] of byte=($56,$B0,$7F,$4B,$7C,$05,$43,$4A,$2E,$1D,$DB,$F5,$11,$4D,$2A,$20,$BE,$56,$19,$51,$E4,$A4,$A1,$CC,$25
//                          ,$1F,$C2,$D2,$BC,$89,$C3,$31,$8C,$51,$48,$32,$66,$6F,$6D,$22,$94,$A9,$B5,$A1,$FE,$91,$30,$BD,$6F,$6A,
//                          $0E,$5E,$91,$1B,$63,$52) ;
indatatmp:array[0..15] of byte=($60,$45,$33,$57,$7D,$5F,$90,$A8,$6E,$DC,$A2,$14,$02,$BA,$76,$51);
var

    indata,outdata:array of byte;
     key1:array[0..15] of Byte;
    btsize:integer;
    btsendsize:integer;
begin
    btsize:=16;
    btsendsize:=(btsize div 8+1)*8;
    SetLength(indata,btsize);

    SetLength(outdata,btsendsize);
//    mainclass.strtobyte(key1,'04070601070706060804060101060409',2);
    mainclass.strtobyte(key1,mainclass.defaultkey ,1);
    mainclass.Encryptbcb(key1,indatatmp,outdata);
    mainclass.WriteerrorLog(mainclass.arraytostr(outdata));
    showmessage('银行接收明码为:'+mainclass.arraytostr(outdata));
    showmessage('银行接收密码为:'+mainclass.arraytostr(indatatmp));

end;

procedure TForm1.Button5Click(Sender: TObject);
const
{indatatmp:array[0..55] of byte=($56,$B0,$7F,$4B,$7C,$05,$43,$4A,$2E,$1D,$DB,$F5,$11,$4D,$2A,$20,$BE,$56,$19,$51,$E4,$A4,$A1,$CC,$25
                          ,$1F,$C2,$D2,$BC,$89,$C3,$31,$8C,$51,$48,$32,$66,$6F,$6D,$22,$94,$A9,$B5,$A1,$FE,$91,$30,$BD,$6F,$6A,
                          $0E,$5E,$91,$1B,$63,$52) ;
}

indatatmp:array[0..15] of byte=($60,$45,$33,$57,$7D,$5F,$90,$A8,$6E,$DC,$A2,$14,$02,$BA,$76,$51);
var

    outdata:array of byte;
     key1:array[0..15] of Byte;
    btsize:integer;
    btsendsize:integer;
begin
    btsize:=16;
   // SetLength(indata,btsize);
  //  mainclass.strtobyte(indata,'604533577D5F90A86EDCA21402BA7651',2);
    btsendsize:=(btsize div 8+1)*8;

    SetLength(outdata,btsendsize);
//    mainclass.strtobyte(key1,'04070601070706060804060101060409',2);
    mainclass.strtobyte(key1,mainclass.defaultkey ,1);
    mainclass.Decryptbcb(key1,indatatmp,outdata);
//      SetLength(indata,btsize);
       btsendsize:=(btsize div 8+1)*8;
       SetLength(outdata,btsendsize);
      //Move(buf,indata[0],btsize);
       showmessage('银行接收密码为:'+mainclass.arraytostr(indatatmp));
//       mainclass.Decryptbcb(key1,indatatmp,outdata);
       showmessage('银行接收明码为:'+mainclass.arraytostr1(outdata));
       showmessage('银行加密因子:'+mainclass.arraytostr(key1));
       setlength(outdata,length(outdata)-outdata[high(outdata)]);
      // mainclass.dbuftobuf(outdata,buf,0);
end;

procedure TForm1.Button6Click(Sender: TObject);


  var
    aa:string;
    i:integer;
    arra:array[0..255] of Char;
    //ProcessList1.DownLoadFile(FileName);
    processlist1:TProcessList;
    opendlg:TOpenDialog;
    filename:string;
    AFileList :tstringlist ;
begin
    processlist1:=TProcessList.Create;
    ProcessList1.WriteLog('连接数据库');
    ProcessList1.DbConnected := True;
    if not ProcessList1.DbConnected then Exit;
    ProcessList1.WriteLog('连接数据库成功');
    {1.获取配置文件参数}
    ProcessList1.LoadParam;
    {创建上传、下载、日志文件夹}
    ProcessList1.CreateYearFolder;

            OpenDialog1.InitialDir:=ExtractFilePath(ParamStr(0))+'ftpdir\detail\' ;
             if OpenDialog1.Execute then
             begin
                filename:=ExtractFileName(OpenDialog1.FileName);
                try
                    ProcessList1.DownLoadFile(filename);
                    ProcessList1.ProcessDownFile(filename);
                    ShowMessage('文件解析成功！');
                except
                    ShowMessage('文件解析失败！');
                end;
               // Sleep(500);
             end;
     processlist1.Free;

end;

procedure TForm1.test(var aa: array of byte;bb:pchar);
var
  strtmp: array [0..255] of byte;
  i:integer;
//  buf array [0..4] of byte;
str:string;
begin
    strtmp[0]:=65;
    strtmp[1]:=65;
    strtmp[2]:=65;
    strtmp[3]:=65;
    strtmp[4]:=65;
    strtmp[5]:=65;
    strtmp[6]:=65;
    strtmp[7]:=65;
    strtmp[8]:=65;
//    CopyMemory(@aa,@strtmp,5);
    i:=123;
   bintohex(@strtmp,PChar(str),2);
   caption:=bb;
end;

function TForm1.GetFile(var FileList:TStringList;filepath:string;filetype:string):Boolean;
var
 aPath,s:String;
 FileInfo: TSearchRec;
 res: Integer;
begin
  Result:=False;
  if DirectoryExists(filepath) then
  begin
    s := filepath+'\'+filetype;
    res := FindFirst(s, sysUtils.faArchive, FileInfo);
    try
      if res = 0 then
      begin
        repeat
          { exclude normal files if ftNormal not set }
          s := aPath + '\' + FileInfo.Name;
          FileList.add(s);
        until FindNext(FileInfo) <> 0;
      end;
    finally
      FindClose(FileInfo);
    end;
 end;
 result:=True;
end;




procedure TForm1.Button8Click(Sender: TObject);
begin
   Application.CreateForm(TETCCXFORM, ETCCXFORM);
   ETCCXFORM.Show;
end;

procedure TForm1.Button3Click(Sender: TObject);
  var
    aa:string;
    i:integer;
    arra:array[0..255] of Char;
    //ProcessList1.DownLoadFile(FileName);
    processlist1:TProcessList;
    opendlg:TOpenDialog;
    filename:string;
    AFileList :tstringlist ;

begin
   { aa:='ABCD';
    caption:=mainclass.hextodec(aa);

    i:=mainclass.inttobigint(74);
    i:=mainclass.inttobigint(i);
    caption:=IntToStr(i);
    HexToBin(PChar('B3E802D0'),arra,4);
    caption:=string(arra);
    }
    processlist1:=TProcessList.Create;
    ProcessList1.WriteLog('连接数据库');
    ProcessList1.DbConnected := True;
    if not ProcessList1.DbConnected then Exit;
    ProcessList1.WriteLog('连接数据库成功');
    {1.获取配置文件参数}
    ProcessList1.LoadParam;
    {创建上传、下载、日志文件夹}
    ProcessList1.CreateYearFolder;
{    opendlg:=TOpenDialog.Create(self);
    opendlg.Filter:='*.txt|*.txt';
    opendlg.InitialDir:=ExtractFilePath(Application.ExeName);
    if not opendlg.Execute then exit;
}
    afilelist:=tstringlist.create;
  // AFileList:= TDirectory.getfile //(FCachePath,'*.WJ1',self.FileCountFilter) ;
   //ProcessList1.SaveFileDb(5004,'20140516|1401501830023020150402161948|00159545|5|AAAA|1449|1449239500007195|6221881600041726677|0|9|20150402161948|该用户未签约!|');
 //  ProcessList1.SaveFileDb(5004,'20140516|1401501830023020150402161948|00159545|5|AAAA|1401|1202230100002743|6228110000000091|0|9|20150402161948||','123');



end;

procedure TForm1.Button7Click(Sender: TObject);
var
    aa:string;
    i:integer;
    arra:array[0..255] of Char;
    //ProcessList1.DownLoadFile(FileName);
    processlist1:TProcessList;
    opendlg:TOpenDialog;
    filename:string;
    AFileList :tstringlist ;
    streamfile:Tfilestream;
    strtmp:string;
    sYear,sMonth,sDay:Word;
begin
{
    processlist1:=TProcessList.Create;
    ProcessList1.WriteLog('连接数据库');
    ProcessList1.DbConnected := True;
    if not ProcessList1.DbConnected then Exit;
    ProcessList1.WriteLog('连接数据库成功');
    {1.获取配置文件参数}
{    ProcessList1.LoadParam;
    {创建上传、下载、日志文件夹}
{    ProcessList1.CreateYearFolder;
    afilelist:=tstringlist.create;

    if selectDirectory('请选择','' ,filename) then
    begin
        if getfile(AFileList,filename,'*.TXT') then
        begin
                 for i:=0 to AFileList.Count-1 do
            begin
                filename:=trim(ExtractFileName(AFileList.Strings[i]));
                try                                                
                 //  ProcessList1.DownLoadFile(filename);
                    ProcessList1.ProcessDownFile(filename);
               except
                end;
                Sleep(500);
            end;
            ShowMessage('对账文件处理完成');
        end;
    end;

}
            DecodeDate(Now,sYear,sMonth,sDay);
            strtmp:=ExtractFilePath(ParamStr(0))+'download\'+InttoStr(sYear)+'\'+trim(string('y36000000140000020151103010101.TXT'));

            streamfile:=TfileStream.Create(strtmp,fmOpenRead	);
  //          streamfile:=TfileStream.Create(ExtractFilePath(Application.ExeName)+'download\'+InttoStr(sYear)+'\'+'y36000000140000020151103010101.TXT',fmOpenRead	);
            strtmp:=mainclass.getmd5(TStream(streamfile));
            showmessage(strtmp);
            streamfile.Free;

end;

procedure TForm1.idtcpsrvr1Disconnect(AThread: TIdPeerThread);
var Client: PClient;
begin
  AETCthread.Stop;
  AETCthread.Terminate;
  FList.Remove(AThread);
end;



procedure TForm1.FormDestroy(Sender: TObject);
begin
  FList.Free;
  if Assigned(ADOPool) then ADOPool.Free;
  if Assigned(ADOConfig) then ADOConfig.Free;
end;

end.

