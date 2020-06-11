unit ETCBANK_interface;

interface


uses Classes ,Windows,SysUtils,Variants ;

type
//充值

 TBANKGETCZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PNetCardID:array[0..4] of AnsiChar;
     PCardID:array[0..7] of byte;
     BeforeMoney:array[0..3] of byte;
     CZMoney:array[0..3] of byte;
     OnlineSN:array[0..2] of byte;
     OfflineSN:array[0..2] of byte;
     Random:array[0..3] of byte;
     MAC1:array[0..3] of byte;


 end;
 //充值应答
 PBANKSETCZ=^TBANKSETCZ;
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
     TermDate:array[0..7] of AnsiChar;
     TermTime:array[0..5] of AnsiChar;
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
     VCBindType:ansichar;
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
     TermDate:array[0..7] of AnsiChar;
     TermTime:array[0..5] of AnsiChar;
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
     WriteCardFlag:array[0..0] of ansichar;  //写卡标志
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


 //充值对账请求
  TBANKGETCZDZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     WorkDate:array[0..7] of ansichar;
     BankID:array[0..6] of ansichar;
     FileName:array[0..35] of ansichar;
     RecordNumber:array[0..6] of ansichar;
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
 

implementation
end.
