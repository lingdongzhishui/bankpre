unit ETCBANK_interface;

interface


uses Classes ,Windows,SysUtils,Variants ;

type
 //1007

 TCKFILEGETCZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     Networkid:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     FileDate:array[0..7] of ansichar;
     FileName:array[0..49] of ansichar;
     Memo :array[0..9] of ansichar;
 end;
 //1008
  TCKFILESETCZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     Networkid:array[0..6] of ansichar;
       TerminalID:array[0..9] of ansichar;
     FileCode:array[0..10] of ansichar;
     Result:array[0..0] of AnsiChar;
     FileDesc:array[0..199] of AnsiChar;
     Memos:array[0..9] of byte;
 end;
     //手持机用户登录请求报文 1011
  TOPERATORLOGINBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     OperatorNo:array[0..9] of ansichar;            //5、登录工号
     OperatorPassword:array[0..19] of ansichar;              //6、 登录密码
 end;
 //手持机用户登录请求应答报文 1012
  TOPERATORLOGINYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     OperatorNo:array[0..9] of ansichar;            //5、登录工号

 end;

//充值

 TBANKGETCZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PNetCardID:array[0..3] of AnsiChar;
     PCardID:array[0..7] of byte;
     BeforeMoney:array[0..3] of byte;
     CZMoney:array[0..3] of byte;
     OnlineSN:array[0..2] of byte;
     OfflineSN:array[0..2] of byte;
     Random:array[0..3] of byte;
     MAC1:array[0..3] of byte;


 end;
 //充值应答
 TBANKSETCZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     MAC2:array[0..3] of byte;
 end;

//消费
 TBANKGETXF = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardID:array[0..7] of byte;
     XFMoney:array[0..4] of byte;
     TermOnlineSN:array[0..3] of byte;
     Random:array[0..3] of byte;
     MAC1:array[0..3] of byte;
     CardSeq:array[0..2] of byte;
     KeyIndex:array[0..1] of byte;
     KeyId:array[0..1] of byte;


 end;
 //消费应答
 TBANKSETXF = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardID:array[0..7] of byte;
     MAC1:array[0..3] of byte;
     TermOnlineSN:array[0..3] of byte;
 end;
 //消费确认
 TBANKXFQR = packed record
     MAC2:array[0..3] of byte;
     TAC:array[0..3] of byte;
 end;
 //卡发行报文
 TBANKGETCARDFX = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     Random:array[0..5] of ansichar;
     cardinfo15:array[0..22] of ansichar;
     cardfile2:array[0..54] of ansichar;
     cardinfo16:array[0..9] of ansichar;


 end;
 //发行应答
 TBANKSETCARDFX = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     CardInfo15:array[0..22] of ansichar;
     MAC15:array[0..3] of ansichar;
     CARDInfo16:array[0..54] of ansichar;
     MAC16:array[0..3] of ansichar;
 end;


 //报文头



 TETCBANKHEAD = packed record
     MessageLength:integer;

     ReceiverID:array[0..6] of ansichar;
     SenderID:array[0..6] of ansichar;
     MessageType:array[0..3] of ansichar;
     MessageID:integer;
     VerifyCode:array[0..31] of ansichar;
 end;
 //获取加密因子报文
 TGETPASSWORDKEY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
 end;
 //加密因子应答
 TSETPASSWORDKEY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     KEY1:array[0..7] of byte;
     KEY2:array[0..7] of byte;

 end;
 //签到报文
  TBANKGETQD = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;   
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;

 end;
 //签到应答
  TBANKSETQD = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PStoreLimit:array[0..9] of ansichar;
     PSingleUpLimit:array[0..9] of ansichar;
     PSingleDownLimit:array[0..9] of ansichar;


 end;

    //手持机激活车辆图片上传报文 1009
  THANDSETUPIMAGEBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     VehPlate:array[0..9] of ansichar;            //5、车牌号
     Vehtype:array[0..1] of ansichar;              //6、 车型
     ImageName:array[0..37] of ansichar;              //7、上传图片名称
     OperatorNo:array[0..9] of ansichar;            //8、操作员工号
 end;
 //手持机激活车辆图片上传应答报文 1010
  THANDSETUPIMAGEYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;     //5、终端编号

 end;
 //客户账户请求报文（2021）
  TCUSTOMERREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     networkID:array[0..6] of ansichar;      //3、网点编号
     TerminalID:array[0..9] of ansichar;     //4、终端编号
     CustomerID:array[0..19] of ansichar;
     userName:array[0..99] of ansichar;
     userType:array[0..3] of ansichar;
     address:array[0..199] of ansichar;
     tel:array[0..19] of ansichar;
     userIdNum:array[0..19] of ansichar;
     userIdType:array[0..3] of ansichar;

     agentName:array[0..9] of ansichar;
     agentIdType:array[0..3] of ansichar;     //13、指定经办人证件类型（单位用户必填）
     agentIdNum:array[0..19] of ansichar;     //14、指定经办人证件号（单位用户必填）
     department:array[0..19] of ansichar;
     password:array[0..19] of AnsiChar;
     OperatorID:array[0..7] of ansichar;
     operation:array[0..3] of ansichar;
  end;
  //客户账户应答报文（2022）
  TCUSTOMERRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     userName:array[0..99] of ansichar;
     userType:array[0..3] of ansichar;
     address:array[0..199] of ansichar;
     tel:array[0..19] of ansichar;
     userIdNum:array[0..19] of ansichar;
     userIdType:array[0..3] of ansichar;       //12、用户证件类型
     agentName:array[0..9] of ansichar;        //13、指定经办人姓名
     agentIdType:array[0..3] of ansichar;      //14、指定经办人证件类型（单位用户必填）
     agentIdNum:array[0..19] of ansichar;     //15、指定经办人证件号（单位用户必填）
     department:array[0..19] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
  //客户车辆请求报文（2023）
  TVEHICLEREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     VehTypeNo:array[0..3] of ansichar;
     VehplateColor:array[0..9] of ansichar;
     VehplateColorno:array[0..1] of ansichar;
     VehEngineNo:array[0..49] of ansichar;
     approvedCount:array[0..3] of ansichar;
     totalMass:array[0..3] of ansichar;
     CarINfo:array[0..49] of ansichar;
     VehColor:array[0..9] of ansichar;
     VIN:array[0..49] of ansichar;
     contact:array[0..9] of ansichar;
     useCharacter:array[0..3] of ansichar;
     OperatorID:array[0..7] of ansichar;
     operation:array[0..3] of ansichar;
     vehlicenseIssueDate:array[0..9] of ansichar;
     vehlicenseRegisterDate:array[0..9] of ansichar;
     vehWheel:array[0..3] of ansichar;
     vehAxle:array[0..3] of ansichar;
     vehLength:array[0..3] of ansichar;
     vehWidth:array[0..3] of ansichar;
     vehHeight:array[0..3] of ansichar;
     vehLicenseName:array[0..99] of ansichar;
     maintenanceMass:array[0..3] of ansichar;
     UpdCarload:array[0..3] of ansichar;
     vehicleType:array[0..19] of ansichar;
     SPG_Container:array[0..3] of ansichar;
     remark:array[0..49] of ansichar;

  end;
  //客户车辆应答报文（2024）
  TVEHICLERESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     VehTypeNo:array[0..3] of ansichar;
     VehplateColor:array[0..9] of ansichar;
     VehEngineNo:array[0..49] of ansichar;
     approvedCount:array[0..3] of ansichar;
     totalMass:array[0..3] of ansichar;
     CarINfo:array[0..49] of ansichar;
     VehColor:array[0..9] of ansichar;
     VIN:array[0..49] of ansichar;
     contact:array[0..9] of ansichar;
     useCharacter:array[0..3] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
   //电子标签(OBU)请求报文（2025）
  TOBUREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     OBUNo:array[0..19] of ansichar;
     OBUFactoryID:array[0..1] of ansichar;
     OBUTollType:array[0..3] of ansichar;
     OBUPrice:array[0..3] of ansichar;
     StartUseTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     fileVersion:array[0..9] of ansichar;
     OperatorID:array[0..7] of ansichar;
     operation:array[0..3] of ansichar;
  end;
  //电子标签(OBU)应答报文（2026）
  TOBURESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     OBUNo:array[0..19] of ansichar;
     OBUState:array[0..3] of ansichar;
     StartUseTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
  //储值卡请求报文（2027）
  TPRECARDREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     CardID:array[0..19] of ansichar;
     StartUseTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     fileVersion:array[0..9] of ansichar;
     OperatorID:array[0..7] of ansichar;
     operation:array[0..3] of ansichar;
  end;
  //储值卡应答报文（2028）
  TPRECARDRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     CardID:array[0..19] of ansichar;
     CardState:array[0..3] of ansichar;
     IssueTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
  //记账卡请求报文（2029）
  TCHARGECARDREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     CardID:array[0..19] of ansichar;
     StartUseTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     BankID:array[0..7] of AnsiChar;
     BankCardType:array[0..3] of AnsiChar;
     BankCardID:array[0..19] of AnsiChar;
     BCertificateType:array[0..3] of AnsiChar;
     BVCertificateID:array[0..19] of AnsiChar;
     BUserName:array[0..9] of AnsiChar;
     fileVersion:array[0..9] of ansichar;
     OperatorID:array[0..7] of ansichar;
     operation:array[0..3] of ansichar;
  end;
  //记账卡应答报文（2030）
  TCHARGECARDRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     CardID:array[0..19] of ansichar;
     CardState:array[0..3] of ansichar;
     IssueTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
   //银行订单请求报文（2041）
  TORDERREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     BankID:array[0..7] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     VehplateColor:array[0..1] of ansichar;
     VehType:array[0..1] of ansichar;
     VehSeatNum:array[0..1] of ansichar;
     BankCardType:array[0..1] of ansichar;
     BCertificateType:array[0..1] of AnsiChar;
     BVCertificateID:array[0..29] of AnsiChar;
     ActiveDate:array[0..7] of AnsiChar;
     BankCardID:array[0..29] of AnsiChar;
     BUserName:array[0..19] of AnsiChar;
     OrderID:array[0..29] of AnsiChar;
     mobile:array[0..19] of ansichar;
     addr:array[0..199] of ansichar;
  end;
  //银行订单应答报文（2042）
  TORDERRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;
     OrderID:array[0..29] of AnsiChar;
  end;
 //在线充值查询
  TBANKGETCZQUERY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
 end;
 //在线充值查询应答
  TBANKSETCZQUERY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserType:array[0..1] of ansichar;
     UserName:array[0..99] of ansichar;
     CertificateType:array[0..1] of ansichar;
     CertificateID:array[0..59] of ansichar;
     Contact:array[0..9] of ansichar;
     Phone:array[0..11] of ansichar;
     Mobile:array[0..11] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     PExpireTime:array[0..7] of ansichar;
     VCBindType:array [0..0] of ansichar;
     Vehplate:array[0..11] of ansichar;
     vehplatecolor:array[0..1] of AnsiChar;
     VehType:array[0..1] of ansichar;
     VehSeatNum:array[0..2] of ansichar;
     SysBeforeMoney:array[0..11] of ansichar;
     QCMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;

 end;
//在线充值查询
  TBANKGETZHCZQUERY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     userpassword:array[0..19] of ansichar;
     CardID:array[0..19] of ansichar;
 end;
 //在线充值查询应答
  TBANKSETZHCZQUERY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserType:array[0..1] of ansichar;
     UserName:array[0..99] of ansichar;
     CertificateType:array[0..1] of ansichar;
     CertificateID:array[0..59] of ansichar;
//     userpassword:array[0..19] of ansichar;
     SysBeforeMoney:array[0..11] of ansichar;
     KQCMoney:array[0..19] of AnsiChar;

 end;

//在线充值查询
  TBANKGETusermodypassword = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     password:array[0..19] of ansichar;
     newpassword:array[0..19] of ansichar;
 end;
 //在线充值查询应答
  TBANKSETusermodypassword = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;


 end;


 //在线充值请求
  TBANKGETCZQQ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     VCBindType:array[0..0] of ansichar;
     Vehplate:array[0..11] of ansichar;
     PCardID:array[0..15] of ansichar;
     SysBeforeMoney:array[0..11] of ansichar;
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;
     OnlineSN:array[0..3] of ansichar;
     OfflineSN:array[0..3] of ansichar;
     Random:array[0..7] of ansichar;
     MAC1:array[0..7] of ansichar;
     TermNo:array[0..11] of AnsiChar;
     termdate:array[0..7] of AnsiChar;
     termtime:array[0..5] of AnsiChar;     
     OperatorID:array[0..7] of AnsiChar;

 end;
 //在线充值请求应答
  TBANKSETCZQQ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserName:array[0..99] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;
     MAC2:array[0..7] of ansichar;


 end;

 //在线充值成功
  TBANKGETCZCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceType:array[0..1] of ansichar;  //票据类型
     InvoiceBatch:array[0..3] of ansichar;   //票据批次
     InvoiceID:array[0..7] of ansichar;   //票据号
     AfterMoney:array[0..11] of ansichar;    //充值后卡内余额
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;    //交易流水号
     OnlineSN:array[0..3] of ansichar;  //联机交易序列号
     OfflineSN:array[0..3] of ansichar;   //脱机交易序列号
     WriteCardFlag:array[0..0] of ansichar;  //写卡标志
 end;

 //在线充值成功应答
  TBANKSETCZCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;    //交易流水号
 end;

 //在线圈存请求
  TBANKGETQC = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     VCBindType:array[0..0] of ansichar;
     Vehplate:array[0..11] of ansichar;
     SysBeforeMoney:array[0..11] of ansichar;
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;
     OnlineSN:array[0..3] of ansichar;
     OfflineSN:array[0..3] of ansichar;
     Random:array[0..7] of ansichar;
     MAC1:array[0..7] of ansichar;
     TermNo:array[0..11] of AnsiChar;
     OperatorID:array[0..7] of AnsiChar;


 end;
 //在线圈存应答
  TBANKSETQC = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserName:array[0..99] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;
     MAC2:array[0..7] of ansichar;
 end;
  //在线圈存成功
  TBANKGETQCCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceType:array[0..1] of ansichar;  //票据类型
     InvoiceBatch:array[0..3] of ansichar;   //票据批次
     InvoiceID:array[0..7] of ansichar;   //票据号
     AfterMoney:array[0..11] of ansichar;    //充值后卡内余额
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;    //交易流水号
     OnlineSN:array[0..3] of ansichar;  //联机交易序列号
     OfflineSN:array[0..3] of ansichar;   //脱机交易序列号
     WriteCardFlag:array [0..0] of ansichar;  //写卡标志
 end;
 //在线圈存成功应答
  TBANKSETQCCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;    //交易流水号
 end;

  TBANKZHFPQQ=packed record   //账户分配请求报文（2035）
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserType:array[0..1] of ansichar;
     UserName:array[0..99] of ansichar;
     FPMONEY:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;
  end;

  TBANKZHFPYD=packed record     //账户分配确认应答报文（2036）
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserType:array[0..1] of ansichar;
     UserName:array[0..99] of ansichar;
     fpmoney:array[0..11] of AnsiChar;
     SysBeforeMoney: array[0..11] of AnsiChar;
     WasteSN: array[0..29] of AnsiChar;

  end;

  tbankgetfxmx =packed record
     vehplate:array[0..9] of AnsiChar;
     pnetcardid:array[0..3] of ansichar;
     pcardid:array[0..15] of AnsiChar;
     fpmoney:array[0..9] of AnsiChar;
  end;

  //票据打印请求
  TBANKGETCZPJDY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceType:array[0..1] of ansichar;  //票据类型
     InvoiceBatch:array[0..3] of ansichar;   //票据批次
     InvoiceID:array[0..7] of ansichar;   //票据号
     WasteSN:array[0..29] of ansichar;    //交易流水号
     operatorID:array[0..7] of ansichar;  //操作员
 end;
 //票据打印应答

  TBANKSETCZPJDY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserName:array[0..99] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceID:array[0..7] of ansichar;   //票据号
     AfterMoney:array[0..11] of ansichar;    //充值后卡内余额
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;    //交易流水号
     OnlineSN:array[0..3] of ansichar;  //联机交易序列号
     OfflineSN:array[0..3] of ansichar;   //脱机交易序列号
     vehplate:array[0..15] of ansichar;  //写卡标志
 end;
  //票据重打请求
  TBANKGETCZPJCD = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;    //交易流水号
     oldInvoiceType:array[0..1] of ansichar;  //票据类型
     oldInvoiceBatch:array[0..3] of ansichar;   //票据批次
     oldInvoiceID:array[0..7] of ansichar;   //票据号
     newInvoiceType:array[0..1] of ansichar;  //票据类型
     newInvoiceBatch:array[0..3] of ansichar;   //票据批次
     newInvoiceID:array[0..7] of ansichar;   //票据号

     operatorID:array[0..7] of ansichar;  //操作员
 end;


 //在线冲正请求
  TBANKGETCZHENGQQ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     BeforeMoney:array[0..11] of ansichar;
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;
     CZWasteSN:array[0..29] of ansichar;

     OnlineSN:array[0..3] of ansichar;
     OfflineSN:array[0..3] of ansichar;
     Random:array[0..7] of ansichar;
     CardSeq:array[0..3] of ansichar;   //交易序列号
     KeyIndex:array[0..1] of ansichar;  //密钥版本号
     KeyID:array[0..1] of ansichar;     //算法标识
     TermNo:array[0..11] of AnsiChar;
     TermDate:array[0..7] of AnsiChar;
     TermTime:array[0..5] of AnsiChar;
     OperatorID:array[0..7] of AnsiChar;

 end;
 //在线冲正应答
  TBANKSETCZHENGQQ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserName:array[0..99] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;
     CZWasteSN:array[0..29] of ansichar;
     MAC1:array[0..7] of ansichar;
     OnlineSN:array[0..7] of AnsiChar;
 end;

 //在线冲正成功
  TBANKGETCZHENGCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     AfterMoney:array[0..11] of ansichar;    //充值后卡内余额
     CZMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;    //交易流水号
     OnlineSN:array[0..7] of ansichar;  //联机交易序列号
     OfflineSN:array[0..3] of ansichar;  //联机交易序列号
     MAC2:array[0..7] of ansichar;
     TAC:array[0..7] of ansichar;
     WriteCardFlag:array[0..0] of ansichar;
 end;

 //在线冲正成功应答
  TBANKSETCZhengCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     WasteSN:array[0..29] of ansichar;    //交易流水号     
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;

 end;

 //挂失请求
  TBANKGETGS = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     PCardPassword:array[0..15] of ansichar;    //密码
     OperatorID:array[0..7] of ansichar;

 end;

 //挂失应答
  TBANKSETGS = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     OperatorID:array[0..7] of ansichar;

 end;
 //解挂请求
  TBANKGETJG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     PCardPassword:array[0..15] of ansichar;    //密码
     OperatorID:array[0..7] of ansichar;

 end;

 //解挂应答
  TBANKSETJG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     OperatorID:array[0..7] of ansichar;

 end;

//修改密码请求
  TBANKGETmodipassword = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     PCardPassword:array[0..15] of ansichar;    //密码
     PCardnewPassword:array[0..15] of ansichar;    //密码
     OperatorID:array[0..7] of ansichar;

 end;
 //修改密码应答
  TBANKSETmodipassword = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     OperatorID:array[0..7] of ansichar;

 end;

//对账请求
  TBANKGETDZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     WorkDate:array[0..7] of ansichar;
     BankID:array[0..6] of ansichar;
     FileName:array[0..36] of ansichar;
     RecordNumber:array[0..5] of ansichar;
     VerifyCode:array[0..31] of ansichar;

 end;
 //对账应答
  TBANKSETDZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     WorkDate:array[0..7] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     BankID:array[0..6] of ansichar;
 end;
//农信社修改电话请求报文
   TBANKGETPHONE = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            //2、处理时间
     BankID:array[0..6] of ansichar;                //3、银行编号
     networkID:array[0..6] of ansichar;              //4、网点编号
     CustomerID:array[0..19] of ansichar;            //5、快通卡用户号
     PCardNetID:array[0..3] of ansichar;             //6、快通卡卡网络编号，山西：1401
     PCardID:array[0..15] of ansichar;               //7、快通卡卡号
     CertificateType:array[0..1] of ansichar;        //8、证件类型
     CertificateID:array[0..59] of ansichar;         //9、证件号码
     BankCardID:array[0..31] of ansichar;            //10、银行卡卡号
     EntrustVerifyCode:array[0..15] of ansichar;     //11、委托校验码
     OperatorID:array[0..19] of AnsiChar;             //12 操作员
     NewPhoneNO:array[0..10] of ansichar;            //13 新电话
  end;

 //农信社修改电话应答报文
  TBANKSETPHONE = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
 end;
  //绑定卡开户请求报文  4001
  TBANKGETBDCARDKH = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     BankID:array[0..6] of ansichar;                 //5、银行编号
     CustomerID:array[0..19] of ansichar;            //6、快通卡用户号
     UserType:array[0..1] of ansichar;               //7、用户类型
     UserName:array[0..99] of ansichar;              //8、 快通卡用户名
     CertificateType:array[0..1] of ansichar;        //9、证件类型
     CertificateID:array[0..59] of ansichar;         //10、证件号码
     PCardNetID:array[0..3] of ansichar;             //11、快通卡卡网络编号，山西：1401
     PCardID:array[0..15] of ansichar;               //12、快通卡卡号
     EntrustVerifyCode:array[0..15] of ansichar;     //13、委托校验码
     Vehplate:array[0..11] of ansichar;              //14、车牌号
     VehplateColor:array[0..1] of ansichar;           //15、车牌颜色
     VehType:array[0..1] of ansichar;        //16、车辆车型
     VehSeatNum:array[0..1] of ansichar;     //17、车辆座位数
     WasteSN:array[0..29] of ansichar;       //18、流水序列号
     //以下为新增
     BankCardType:array[0..1] of ansichar;       //19、银行卡类型
     BCertificateType:array [0..1] of ansichar;  //20、银行卡证件类型
     BVCertificateID: array[0..59] of ansichar;  //21、银行卡证件号码
     ActiveDate:array [0..7]  of ansichar;       //22、银行卡有效日期
     BankCardID:array[0..31] of ansichar;        //23、银行卡卡号

     BUserName:array[0..19] of ansichar;         //24、银行卡姓名
     OperatorName:array[0..19] of ansichar;      //25、经办人员
     BankCustomerID:array[0..11] of ansichar;    //26、银行客户ID
     Remark:array[0..49] of ansichar;        //27、备用字段   新增字段
 end;
 //绑定卡开户应答报文 4002
  TBANKSETBDCARDKH = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;     //5、终端编号
     BankID:array[0..6] of ansichar;         //6、银行编号
     CustomerID:array[0..19] of ansichar;    //7、快通卡用户号
     PCardNetID:array[0..3] of ansichar;     //8、快通卡卡网络编号，山西：1401
     PCardID:array[0..15] of ansichar;       //9、快通卡卡号
     Vehplate:array[0..11] of ansichar;      //10、车牌号
     VehplateColor:array[0..1] of ansichar;  //11、车牌颜色

     //以下为新增
     WasteSN:array [0..29] of ansichar;          //12、流水序列号
     BankCardType:array[0..1] of ansichar;       //13、银行卡类型
     BCertificateType:array[0..1] of ansichar;   //14、银行卡证件
     BVCertificateID :array[0..59] of ansichar;  //15、银行卡证件号码
     ActiveDate:array[0..7] of ansichar;         //16、银行卡有效日期
     BankCardID:array[0..31] of ansichar;       //17、银行卡卡号
     BUserName :array[0..19] of ansichar;        //18、银行卡姓名
     OperatorName:array[ 0..19] of ansichar;     //19、经办人员
 end;

  //绑定卡重绑开户请求报文  4003
  TBANKGETCBCARDKH = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     BankID:array[0..6] of ansichar;                 //5、银行编号
     CustomerID:array[0..19] of ansichar;            //6、快通卡用户号
     UserType:array[0..1] of ansichar;               //7、用户类型
     UserName:array[0..99] of ansichar;              //8、 快通卡用户名

     CertificateType:array[0..1] of ansichar;        //9、证件类型
     CertificateID:array[0..59] of ansichar;         //10、证件号码


     PCardNetID:array[0..3] of ansichar;             //11、快通卡卡网络编号，山西：1401
     PCardID:array[0..15] of ansichar;               //12、快通卡卡号

     EntrustVerifyCode:array[0..15] of ansichar;     //13、委托校验码
     Vehplate:array[0..11] of ansichar;              //14、车牌号
     VehplateColor:array[0..1] of ansichar;           //15、车牌颜色


     VehType:array[0..1] of ansichar;        //16、车辆车型
     VehSeatNum:array[0..1] of ansichar;     //17、车辆座位数
     WasteSN:array[0..29] of ansichar;       //18、流水序列号

     //以下为新增
     BankCardType:array[0..1] of ansichar;       //19、银行卡类型
     BCertificateType:array [0..1] of ansichar;  //20、银行卡证件类型
     BVCertificateID: array[0..59] of ansichar;  //21、银行卡证件号码
     ActiveDate:array [0..7]  of ansichar;       //22、银行卡有效日期
     BankCardID:array[0..31] of ansichar;        //23、银行卡卡号

     BUserName:array[0..19] of ansichar;         //24、银行卡姓名
      BankCardTypeNew:array[0..1] of ansichar;       //19、银行卡类型
     BCertificateTypeNew:array [0..1] of ansichar;  //20、银行卡证件类型
     BVCertificateIDNew: array[0..59] of ansichar;  //21、银行卡证件号码
     ActiveDateNew:array [0..7]  of ansichar;       //22、银行卡有效日期
     BankCardIDNew:array[0..31] of ansichar;        //23、银行卡卡号

     BUserNameNew:array[0..19] of ansichar;         //24、银行卡姓名
     OperatorName:array[0..19] of ansichar;      //25、经办人员
 end;
 //绑定卡重绑开户应答报文 4004
  TBANKSETCBCARDKH = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;     //5、终端编号
     BankID:array[0..6] of ansichar;         //6、银行编号
     CustomerID:array[0..19] of ansichar;    //7、快通卡用户号
     PCardNetID:array[0..3] of ansichar;     //8、快通卡卡网络编号，山西：1401
     PCardID:array[0..15] of ansichar;       //9、快通卡卡号
     Vehplate:array[0..11] of ansichar;      //10、车牌号
     VehplateColor:array[0..1] of ansichar;  //11、车牌颜色

     //以下为新增
     WasteSN:array [0..29] of ansichar;          //12、流水序列号
     BankCardType:array[0..1] of ansichar;       //13、银行卡类型
     BCertificateType:array[0..1] of ansichar;   //14、银行卡证件
     BVCertificateID :array[0..59] of ansichar;  //15、银行卡证件号码
     ActiveDate:array[0..7] of ansichar;         //16、银行卡有效日期
      BankCardID:array[0..31] of ansichar;       //17、银行卡卡号
     BUserName :array[0..19] of ansichar;        //18、银行卡姓名
     OperatorName:array[ 0..19] of ansichar;     //19、经办人员
 end;

//一次发行发送通知报文 5001
  TBANKGETYCFXTZBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     BankID:array[0..6] of ansichar;                 //5、银行编号
     FileName:array[0..35] of ansichar;            //6、记录数
     RecordNumber:array[0..5] of ansichar;               //7、用户类型
     CardnoBegin:array[0..19] of ansichar;              //8、 卡号描述信息
     CardnoEnd:array[0..19] of ansichar;              //8、 卡号描述信息     
     Remark:array[0..99] of ansichar;        //9、备用字段
     VerifyCode:array[0..31] of ansichar;         //10、MD5码

 end;
 //一次发行接收应答报文 5002
  TBANKSETYCFXTZBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;     //5、终端编号
     BankID:array[0..6] of ansichar;         //6、银行编号
     
 end;

 //一次发行密钥文件发送通知报文 5003
  TBANKGETYCFXMYTZBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     BankID:array[0..6] of ansichar;                 //5、银行编号
     FileName:array[0..35] of ansichar;            //6、记录数
     RecordNumber:array[0..5] of ansichar;               //7、用户类型
     Cardnobegin:array[0..19] of ansichar;              //8、 卡号描述信息
     Cardnoend:array[0..19] of ansichar;              //8、 卡号描述信息     

     Remark:array[0..99] of ansichar;        //9、备用字段
     VerifyCode:array[0..31] of ansichar;         //10、MD5码

 end;
 //一次发行密钥文件接收应答报文 5004
  TBANKSETYCFXMYYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;     //5、终端编号
     BankID:array[0..6] of ansichar;         //6、银行编号

 end;

  //二次发行结果文件发送通知报文 5005
  TBANKGETECFXJGWJFSTZBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     BankID:array[0..6] of ansichar;                 //5、银行编号
     FileName:array[0..35] of ansichar;            //6、记录数
     RecordNumber:array[0..5] of ansichar;               //7、用户类型
     CardnoMark:array[0..19] of ansichar;              //8、 卡号描述信息

     Remark:array[0..99] of ansichar;        //9、备用字段
     VerifyCode:array[0..31] of ansichar;         //10、MD5码

 end;
 //二次发行结果文件发送接收应答报文 5006
  TBANKGETECFXJGWJJSYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;     //5、终端编号
     BankID:array[0..6] of ansichar;         //6、银行编号

 end;

  //车辆信息查询报文 5007
  TBANKGETCLXXCXBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     VehPlate:array[0..9] of ansichar;            //5、车牌号
     VehPlateColor:array[0..1] of ansichar;              //6、 车牌颜色

 end;
 //车辆信息查询应答报文 5008
  TBANKGETCLXXCXYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1、处理日期
     ProcessTime:array[0..5] of ansichar;    //2、 处理时间
     ResponseCode:array[0..1] of ansichar;   //3、应答码
     networkID:array[0..6] of ansichar;      //4、网点编号
     TerminalID:array[0..9] of ansichar;     //5、终端编号
     CarStatus:array[0..0] of ansichar;         //6、车辆状态

 end;
  //二次发行异常结果文件发送通知报文 5009
  TBANKGETECFXYCTZBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     BankID:array[0..6] of ansichar;                 //5、银行编号
     FileName:array[0..35] of ansichar;              //6、采用FTP方式交换文件
     RecordNumber:array[0..5] of ansichar;           //7、记录条数
     remark:array[0..99] of AnsiChar;                //8、备用说明
     VerifyCode:array[0..31] of ansichar;            //9、Md5码
  end;
  //二次发行异常结果文件接收应答报文 5010
  TBANKSETECFXYCYDBW = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     BankID:array[0..6] of ansichar;
   end;
 //绑定卡销户请求报文  4011
  TBANKGETBDCARDXH = packed record

      ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     networkID:array[0..6] of ansichar;              //3、网点编号
     TerminalID:array[0..9] of ansichar;             //4、 终端编号
     BankID:array[0..6] of ansichar;                 //5、银行编号
     CustomerID:array[0..19] of ansichar;            //6、快通卡用户号
     UserType:array[0..1] of ansichar;               //7、用户类型
     UserName:array[0..99] of ansichar;              //8、 快通卡用户名

     CertificateType:array[0..1] of ansichar;        //9、证件类型
     CertificateID:array[0..59] of ansichar;         //10、证件号码


     PCardNetID:array[0..3] of ansichar;             //11、快通卡卡网络编号，山西：1401
     PCardID:array[0..15] of ansichar;               //12、快通卡卡号

     EntrustVerifyCode:array[0..15] of ansichar;     //13、委托校验码
     Vehplate:array[0..11] of ansichar;              //14、车牌号
     VehplateColor:array[0..1] of ansichar;           //15、车牌颜色

     WasteSN:array[0..29] of ansichar;           //16、流水序列号
     BankCardType:array[0..1] of ansichar;       //17、银行卡类型

     BCertificateType:array [0..1] of ansichar;  //18、银行卡证件类型
     BVCertificateID: array[0..59] of ansichar;  //19、银行卡证件号码
     ActiveDate:array [0..7]  of ansichar;       //20、银行卡有效日期
     BankCardID:array[0..31] of ansichar;        //21、银行卡卡号

     BUserName:array[0..19] of ansichar;         //22、银行卡姓名
     OperatorName:array[0..19] of ansichar;      //23、经办人员
 end;
 //绑定卡销户应答报文   4012
  TBANKSETBDCARDXH = packed record

     ProcessDate:array[0..7] of ansichar;            //1、处理日期
     ProcessTime:array[0..5] of ansichar;            // 2、处理时间
     ResponseCode:array[0..1] of ansichar;           //3、应答码
     networkID:array[0..6] of ansichar;              //4、网点编号
     TerminalID:array[0..9] of ansichar;             //5、 终端编号
     BankID:array[0..6] of ansichar;                 //6、银行编号
     CustomerID:array[0..19] of ansichar;            //7、快通卡用户号

     PCardNetID:array[0..3] of ansichar;             //8、快通卡卡网络编号，山西：1401
     PCardID:array[0..15] of ansichar;               //9、快通卡卡号


     Vehplate:array[0..11] of ansichar;              //10、车牌号
     VehplateColor:array[0..1] of ansichar;           //11、车牌颜色

     WasteSN:array[0..29] of ansichar;           //12、流水序列号
     BankCardType:array[0..1] of ansichar;       //13、银行卡类型

     BCertificateType:array [0..1] of ansichar;  //14、银行卡证件类型
     BVCertificateID: array[0..59] of ansichar;  //15、银行卡证件号码
     ActiveDate:array [0..7]  of ansichar;       //16、银行卡有效日期

     BankCardID:array[0..31] of ansichar;        //17、银行卡卡号
     BUserName:array[0..19] of ansichar;         //18、银行卡姓名
     OperatorName:array[0..19] of ansichar;      //19、经办人员

 end;
 //充值对账请求
  TBANKGETCZDZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     WorkDate:array[0..7] of ansichar;
     BankID:array[0..6] of ansichar;
     FileName:array[0..35] of ansichar;
     RecordNumber:array[0..5] of ansichar;
     VerifyCode:array[0..31] of ansichar;
 end;
 //充值对账应答
  TBANKSETCZDZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     WorkDate:array[0..7] of ansichar;
     BankID:array[0..6] of ansichar;

 end;
 //绑定卡扣款文件发送通知报文（4041）
  TBANKGETBDKK = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     networkID:array[0..6] of ansichar;    //3、网点编号
     TerminalID:array[0..9] of ansichar;   //4、终端编号
     balanceDate:array[0..7] of ansichar;  //5、结算日期
     BankID:array[0..6] of ansichar;       //6、银行编号
     FileName:array[0..35] of ansichar;    //7、采用FTP方式交换的文件
     RecordNumber:array[0..5] of ansichar; //8、记录条数
     totalcount:array[0..5] of AnsiChar;   //9、扣款总笔数
     totalAmount:array[0..11] of AnsiChar;  //10 扣款总金额、
     VerifyCode:array[0..31] of ansichar;  //11、Md5码

 end;

 //用户订单发货请求报文（2043）
  TBANKORDERSEND = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     networkID:array[0..6] of ansichar;    //3、网点编号
     TerminalID:array[0..9] of ansichar;   //4、终端编号
     CustomerID:array[0..19] of ansichar;  //5、用户号
     Vehplate:array[0..9] of ansichar;       //6、车牌号
     VehplateColor:array[0..1] of ansichar;    //7、
     OrderID:array[0..29] of ansichar; //8、
     EtccardID:array[0..19] of AnsiChar;   //9、
     obuno:array[0..19] of AnsiChar;  //10
     expressid:array[0..29] of ansichar;  //11、运单号

 end;
  //用户订单发货请求报文（2044）
  TBANKORDERSENDRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     ResponseCode:array[0..1] of ansichar; //3、应答码

 end;
 //打折消费明细文件发送通知报文（4043）
  TBANKGETDZXFTZBW = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     networkID:array[0..6] of ansichar;    //3、网点编号
     TerminalID:array[0..9] of ansichar;   //4、终端编号
     BankID:array[0..6] of ansichar;       //5、银行编号
     FileName:array[0..35] of ansichar;    //6、采用FTP方式交换的文件
     RecordNumber:array[0..5] of ansichar; //7、记录条数
     remark:array[0..99] of AnsiChar;   //8、备用说明
     VerifyCode:array[0..31] of ansichar;  //9、Md5码

 end;
 //JZ扣款文件发送通知报文（5041）
  TBANKGETJZFKK = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     networkID:array[0..6] of ansichar;    //3、网点编号
     TerminalID:array[0..9] of ansichar;   //4、终端编号
     balanceDate:array[0..7] of ansichar;  //5、结算日期
     BankID:array[0..6] of ansichar;       //6、银行编号
     FileName:array[0..35] of ansichar;    //7、采用FTP方式交换的文件
     RecordNumber:array[0..5] of ansichar; //8、记录条数
     totalcount:array[0..5] of AnsiChar;   //9、扣款总笔数
     totalAmount:array[0..11] of AnsiChar;  //10 扣款总金额、
     VerifyCode:array[0..31] of ansichar;  //11、Md5码

 end;
 //绑定卡扣款文件接收应答报文（4042）
  TBANKSETBDKK = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     ResponseCode:array[0..1] of ansichar; //3、应答码
     networkID:array[0..6] of ansichar;    //4、网点编号
     TerminalID:array[0..9] of ansichar;   //5、终端编号
     BankID:array[0..6] of ansichar;       //6、银行编号
     BalanceDate:array[0..7] of AnsiChar;  //7、结算日期

 end;
 //打折消费明细文件接收应答报文（4044）
  TBANKGETDZXFYDBW = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     ResponseCode:array[0..1] of ansichar; //3、应答码
     networkID:array[0..6] of ansichar;    //4、网点编号
     TerminalID:array[0..9] of ansichar;   //5、终端编号
     BankID:array[0..6] of ansichar;       //6、银行编号

 end;
 //JZF扣款文件接收应答报文（5042）
  TBANKSETJZFKK = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     ResponseCode:array[0..1] of ansichar; //3、应答码
     networkID:array[0..6] of ansichar;    //4、网点编号
     TerminalID:array[0..9] of ansichar;   //5、终端编号
     BankID:array[0..6] of ansichar;       //6、银行编号
     BalanceDate:array[0..7] of AnsiChar;  //7、结算日期

 end;
 //绑定卡扣款结果文件发送通知报文 (4051)
  TBANKGETBDKKRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1处理日期，指业务处理时的当前日期。格式：YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2处理时间，指业务处理时的当前时间。格式：hhmmss
     networkID:array[0..6] of ansichar;   //3网点编号，编号规则与机构标识码相同。
     TerminalID:array[0..9] of ansichar;   //4终端编号，编号规则：在NetWorkID后面加3位十进制数字
     balanceDate:array[0..7] of ansichar;  //5结算日期，格式：YYYYMMDD
     BankID:array[0..6] of ansichar;     //6银行编号，编号规则与机构标识码相同。
     FileName:array[0..35] of ansichar;  //7采用FTP方式交换的文件，如充值对账文件、扣款文件等
     RecordNumber:array[0..5] of ansichar;//8记录条数，指充值对账文件、黑名单文件、扣款文件细目的条数
     totalcount:array[0..5] of AnsiChar;  //9扣款总笔数
     totalAmount:array[0..11] of AnsiChar; //10 扣款总金额
     SucceedCount:array[0..5] of AnsiChar; //11扣款成功笔数
     SucceedAmount:array[0..11] of AnsiChar;  //12 扣款成功金额
     FailCount:array[0..5] of AnsiChar;    //13扣款失败笔数
     FailAmount:array[0..11] of AnsiChar;   //14扣款失败金额
     VerifyCode:array[0..31] of ansichar;   //15Md5码

 end;
  //打折结果明细文件发送通知报文 (4053)
  TBANKGETDZJGMXFSTZBW = packed record
     ProcessDate:array[0..7] of ansichar;   //1处理日期，指业务处理时的当前日期。格式：YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2处理时间，指业务处理时的当前时间。格式：hhmmss
     networkID:array[0..6] of ansichar;   //3网点编号，编号规则与机构标识码相同。
     TerminalID:array[0..9] of ansichar;   //4终端编号，编号规则：在NetWorkID后面加3位十进制数字
     BankID:array[0..6] of ansichar;     //5银行编号，编号规则与机构标识码相同。
     FileName:array[0..35] of ansichar;  //6采用FTP方式交换的文件，如充值对账文件、扣款文件等
     RecordNumber:array[0..5] of ansichar;//7记录条数，指充值对账文件、黑名单文件、扣款文件细目的条数
     remark:array[0..99] of AnsiChar;   //8备用说明
     VerifyCode:array[0..31] of ansichar;   //9 Md5码

 end;
 //JZF扣款结果文件发送通知报文 (5051)
  TBANKGETBDJZFRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1处理日期，指业务处理时的当前日期。格式：YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2处理时间，指业务处理时的当前时间。格式：hhmmss
     networkID:array[0..6] of ansichar;   //3网点编号，编号规则与机构标识码相同。
     TerminalID:array[0..9] of ansichar;   //4终端编号，编号规则：在NetWorkID后面加3位十进制数字
     balanceDate:array[0..7] of ansichar;  //5结算日期，格式：YYYYMMDD
     BankID:array[0..6] of ansichar;     //6银行编号，编号规则与机构标识码相同。
     FileName:array[0..35] of ansichar;  //7采用FTP方式交换的文件，如充值对账文件、扣款文件等
     RecordNumber:array[0..5] of ansichar;//8记录条数，指充值对账文件、黑名单文件、扣款文件细目的条数
     totalcount:array[0..5] of AnsiChar;  //9扣款总笔数
     totalAmount:array[0..11] of AnsiChar; //10 扣款总金额
     SucceedCount:array[0..5] of AnsiChar; //11扣款成功笔数
     SucceedAmount:array[0..11] of AnsiChar;  //12 扣款成功金额
     FailCount:array[0..5] of AnsiChar;    //13扣款失败笔数
     FailAmount:array[0..11] of AnsiChar;   //14扣款失败金额
     VerifyCode:array[0..31] of ansichar;   //15Md5码

 end;
 //绑定卡扣款结果文件应答通知报文 (4052)
  TBANKSETBDKKRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1处理日期，指业务处理时的当前日期。格式：YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2处理时间，指业务处理时的当前时间。格式：hhmmss
     ResponseCode:array[0..1] of ansichar; //3、应答码
     networkID:array[0..6] of ansichar;   //4网点编号，编号规则与机构标识码相同。
     TerminalID:array[0..9] of ansichar;   //5终端编号，编号规则：在NetWorkID后面加3位十进制数字
     BankID:array[0..6] of ansichar;     //7银行编号，编号规则与机构标识码相同。
     balanceDate:array[0..7] of ansichar;  //6结算日期，格式：YYYYMMDD

 end;
 //打折结果明细文件接收应答报文 (4054)
  TBANKSETDZJGMXJSYDBW = packed record
     ProcessDate:array[0..7] of ansichar;   //1处理日期，指业务处理时的当前日期。格式：YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2处理时间，指业务处理时的当前时间。格式：hhmmss
     ResponseCode:array[0..1] of ansichar; //3、应答码
     networkID:array[0..6] of ansichar;   //4网点编号，编号规则与机构标识码相同。
     TerminalID:array[0..9] of ansichar;   //5终端编号，编号规则：在NetWorkID后面加3位十进制数字
     BankID:array[0..6] of ansichar;     //6银行编号，编号规则与机构标识码相同。

 end;
 //JZF扣款结果文件应答通知报文 (5052)
  TBANKSETBDJZFRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1处理日期，指业务处理时的当前日期。格式：YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2处理时间，指业务处理时的当前时间。格式：hhmmss
     ResponseCode:array[0..1] of ansichar; //3、应答码
     networkID:array[0..6] of ansichar;   //4网点编号，编号规则与机构标识码相同。
     TerminalID:array[0..9] of ansichar;   //5终端编号，编号规则：在NetWorkID后面加3位十进制数字
     BankID:array[0..6] of ansichar;     //7银行编号，编号规则与机构标识码相同。
     balanceDate:array[0..7] of ansichar;  //6结算日期，格式：YYYYMMDD

 end;
  //绑定卡签约通知报文 (4071)
  TBANKGETBDKBDRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1处理日期，指业务处理时的当前日期。格式：YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2处理时间，指业务处理时的当前时间。格式：hhmmss
     networkID:array[0..6] of ansichar;   //3网点编号，编号规则与机构标识码相同。
     TerminalID:array[0..9] of ansichar;   //4终端编号，编号规则：在NetWorkID后面加3位十进制数字
     balanceDate:array[0..7] of ansichar;  //5结算日期，格式：YYYYMMDD
     BankID:array[0..6] of ansichar;     //6银行编号，编号规则与机构标识码相同。
     FileName:array[0..35] of ansichar;  //7采用FTP方式交换的文件，如充值对账文件、扣款文件等
     RecordNumber:array[0..5] of ansichar;//8记录条数，指充值对账文件、黑名单文件、扣款文件细目的条数
     VerifyCode:array[0..31] of ansichar;   //9Md5码

 end;
 //绑定卡绑定结果文件应答通知报文 (4072)
  TBANKSETBDKBDRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1处理日期，指业务处理时的当前日期。格式：YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2处理时间，指业务处理时的当前时间。格式：hhmmss
     ResponseCode:array[0..1] of ansichar; //3、应答码
     networkID:array[0..6] of ansichar;   //4网点编号，编号规则与机构标识码相同。
     TerminalID:array[0..9] of ansichar;   //5终端编号，编号规则：在NetWorkID后面加3位十进制数字
     BankID:array[0..6] of ansichar;     //7银行编号，编号规则与机构标识码相同。
     balanceDate:array[0..7] of ansichar;  //6结算日期，格式：YYYYMMDD

 end;
 //黑名单通知报文  4021
  TBANKGETBLACKCARD = packed record
     ProcessDate:array[0..7] of ansichar; //1、处理日期
     ProcessTime:array[0..5] of ansichar; //2、 处理时间
     networkID:array[0..6] of ansichar;   //3、网点编号
     TerminalID:array[0..9] of ansichar;   //4、终端编号
     BankID:array[0..6] of ansichar;       //5、银行编号
     CostomerID:array[0..19] of ansichar;  //6、快通卡用户号
     UserType:array[0..1] of ansichar;     //7、用户类型
     UserName:array[0..99] of AnsiChar;     //8、快通卡用户名
     CertificateType:array[0..1] of AnsiChar; //9、证件类型
     CertificateID:array[0..59] of ansichar;  //10、证件号码
     PCardNetID:array[0..3] of ansichar;  //11、快通卡卡网络编号
     PCardID:array[0..15] of ansichar;  //12、快通卡卡号
     BankCardID:array[0..31] of AnsiChar; //13、银行卡卡号
     BankWasteSN:array[0..29] of AnsiChar; //14、银行交易流水号
     TranType:array[0..1] of AnsiChar;     //15、增加绑定卡黑名单22-撤销绑定卡黑名单

     BindingCardBlackCause:array[0..0] of AnsiChar;//16、绑定卡黑名单产生原因
 end;
 //黑名单应答报文4022
  TBANKSETBLACKCARD = packed record
     ProcessDate:array[0..7] of ansichar;   //1、处理日期
     ProcessTime:array[0..5] of ansichar;   //2、处理时间
     ResponseCode:array[0..1] of ansichar;  //3、应答码
     networkID:array[0..6] of ansichar;     //4、网点编号
     TerminalID:array[0..9] of ansichar;    //5、终端编号
     BankID:array[0..6] of ansichar;        //6、银行编号
     CustomerID:array[0..19] of AnsiChar;   //7、快通卡用户号
     UserName:array[0..99] of ansichar;     //8、快通卡用户名
     PCardNetID:array[0..3] of AnsiChar;    //9、快通卡卡网络编号
     PCardID:array[0..15] of ansichar;      //10、快通卡卡号
     BankCardID:array[0..31] of AnsiChar;   //11、银行卡卡号
 end;
 //黑名单文件发送通知报文（4031）
   TBANKGETBLACKFILE = packed record
     ProcessDate:array[0..7] of ansichar;  //1、处理日期
     ProcessTime:array[0..5] of ansichar;  //2、处理时间
     networkID:array[0..6] of ansichar;    //3、网点编号
     TerminalID:array[0..9] of ansichar;   //4、终端编号
     WorkDate:array[0..7] of ansichar;     //5、工作日期
     BankID:array[0..6] of ansichar;       //6、银行编号
     filename:array[0..35] of ansichar;    //7、采用FTP方式交换的文件，如充值对账文件、扣款文件等
     RecordNumber:array[0..5] of AnsiChar; //8、记录条数
     VerifyCode:array[0..31] of AnsiChar;  //9、Md5码

   end;
   //黑名单文件接收应答报文（4032）
    TBANKSETBLACKFILE = packed record
     ProcessDate:array[0..7] of ansichar; //1、处理日期
     ProcessTime:array[0..5] of ansichar; //2、 处理时间
     ResponseCode:array[0..1] of ansichar;//3、应答码
     networkID:array[0..6] of ansichar;   //3、网点编号
     TerminalID:array[0..9] of ansichar;   //4、终端编号
     BankID:array[0..6] of ansichar;  //5、银行编号
     WorkDate:array[0..7] of ansichar;       //6、工作日期


   end;

  TBANKGETBDPJDY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of AnsiChar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceBatch:array[0..3] of ansichar;   //票据批次
     InvoiceID:array[0..7] of ansichar;   //票据号
     begindate:array[0..7] of ansichar;    //交易流水号
     enddate:array[0..7] of ansichar;    //交易流水号
     InvoiceType:array[0..1] of ansichar;  //票据类型
     operatorID:array[0..7] of ansichar;  //操作员
 end;
 //票据打印应答

  TBANKSETBDPJDY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserName:array[0..99] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     XFMoney:array[0..11] of ansichar;    //充值后卡内余额
     FreeMoney:array[0..11] of ansichar;
     BeginDate:array[0..7] of ansichar;
     EndDate:array[0..7] of ansichar;
     InvoiceBatch:array[0..3] of ansichar;   //票据批次
     InvoiceID:array[0..7] of ansichar;   //票据号
     vehplate:array[0..15] of ansichar;  //写卡标志
     InvoiceType:array[0..1] of ansichar;  //票据类型


 end;
  TBANKsetmac = packed record
     ResponseCode:array[0..1] of ansichar;
     MAC:array[0..3] of byte;
 end;
 TBANKGETZHCZ=packed record                  //2031
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserType:array[0..1] of ansichar;
     UserName:array[0..99] of ansichar;
     SysBeforeMoney:array[0..11] of ansichar;
     CZMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;
   //  OperatorID:array[0..7] of AnsiChar;
 end;
 TBANKSETZHCZ=packed record                 //2032
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserType:array[0..1] of ansichar;
     UserName:array[0..99] of ansichar;
     WasteSN:array[0..29] of ansichar;
 end;
 TBANKGETZHCZCZ=packed record                  //2033
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserType:array[0..1] of ansichar;
     UserName:array[0..99] of ansichar;
     SysBeforeMoney:array[0..11] of ansichar;
     CZMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;
     CZWasteSN:array[0..29] of ansichar;
 end;
 TBANKSETZHCZCZ=packed record                 //2034
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     UserType:array[0..1] of ansichar;
     UserName:array[0..99] of ansichar;
     WasteSN:array[0..29] of ansichar;
 end;
 TBANKGETDEVICEJY=packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     Deviceid:array[0..49] of AnsiChar;
 end;
 TBANKSETDEVICEJY=packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;     
     Deviceid:array[0..49] of AnsiChar;
     PStoreLimit:array[0..9] of ansichar;
     PSingleUpLimit:array[0..9] of ansichar;
     PSingleDownLimit:array[0..9] of ansichar;
 end;
  //系统信息结构(字节38)
  TSysInfoType =  record
    contractProvider:  array [0..15] of char;     //发行商代码  字符串格式
    contractType:  array [0..1] of  char;              //合同类型
    contractVersion: array [0..1] of char;            //合同版本
    contractSerialNumber: array [0..15] of char;  //发行序列号  BCD码格式
    contractSignedDate: array [0..7] of char;    //启用日期    BCD码格式
    contractExpiredDate: array [0..7] of char;   //到期日期    BCD格式
    //26
    Reserved: array [0..1] of char;             //27, 防拆位
    //vehicleLicencePlateNumber: array [0..11] of char;       //车牌号码     字符串格式
  end;
  PSysInfoType = ^TSysInfoType;
    //二次发行内容参数(输入、返回)
  TOBUVehicleInfo = packed record
    VehPlate: array [0..11] of char;     //车牌编号
    CarIDcolor: array [0..2] of char;    //车牌颜色
    VehType: integer;                    //车型
    UserType: integer;                  //用户类型
    CarLen: integer;                    //车长
    CarWidth: integer;                  //车宽
    CarHight: integer;                  //车高
    Wheel: integer;                     //车轮数
    Axle: integer;                      //车轴数
    AxleLen: integer;                   //轴距
    CarLoad: integer;                   //车辆载荷
    CarInfo: array [0..15] of char;      //车辆描述
    VehEngineNo: array [0..15] of char;  //发送机号

    DismantleCount: integer;            //拆卸次数
    BecomeDueDate: array [0..7] of char; //到期日期  20100802
    SignDate: array [0..7] of char;      //签署日期
  end;
  POBUVehicleInfo = ^TOBUVehicleInfo;
  //当前用户参数
  TUserInfo = packed record
    UserID: string[20];                   //用户工号
    UserName: array [0..31] of char;      //用户姓名
    ShiftId: integer;                     //班次ID
    UserPassword: array [0..31] of char;  //用户密码
    RolList: array [0..2047] of char;      //用户权限功能列表
    NodeId: integer;                      //当前程序运行位置所属节点ID
    NodeName: array [0..100] of char;     //当前程序运行位置所属节点名称
    OrganType: integer;                   //节点所属机构类别 1:结算中心 2：片区中心 3：路段中心 4：收费站 5：营运中心 6：服务网点
    WorkDate: TDateTime;                  //工作日期
    Function_Id: integer;                 //功能ID
    RoleNo: integer;                      //用户角色表  
  end;
  //系统运行参数接口
  TRunParameter = packed record
    UserInfo: TUserInfo;       //用户信息
  end;
  PRunParameter = ^TRunParameter;


implementation
end.
