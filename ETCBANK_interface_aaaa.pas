unit ETCBANK_interface;

interface


uses Classes ,Windows,SysUtils,Variants ;

type
//��ֵ

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
 //��ֵӦ��
 PBANKSETCZ=^TBANKSETCZ;
 TBANKSETCZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     MAC2:array[0..3] of byte;
 end;

//����
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
 //����Ӧ��
 TBANKSETXF = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardID:array[0..7] of byte;
     MAC1:array[0..3] of byte;
     TermOnlineSN:array[0..3] of byte;
 end;
 //����ȷ��
 TBANKXFQR = packed record
     MAC2:array[0..3] of byte;
     TAC:array[0..3] of byte;
 end;
 //�����б���
 TBANKGETCARDFX = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     Random:array[0..5] of ansichar;
     cardinfo15:array[0..22] of ansichar;
     cardfile2:array[0..54] of ansichar;
     cardinfo16:array[0..9] of ansichar;


 end;
 //����Ӧ��
 TBANKSETCARDFX = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     CardInfo15:array[0..22] of ansichar;
     MAC15:array[0..3] of ansichar;
     CARDInfo16:array[0..54] of ansichar;
     MAC16:array[0..3] of ansichar;
 end;


 //����ͷ



 TETCBANKHEAD = packed record
     MessageLength:integer;

     ReceiverID:array[0..6] of ansichar;
     SenderID:array[0..6] of ansichar;
     MessageType:array[0..3] of ansichar;
     MessageID:integer;
     VerifyCode:array[0..31] of ansichar;
 end;
 //��ȡ�������ӱ���
 TGETPASSWORDKEY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
 end;
 //��������Ӧ��
 TSETPASSWORDKEY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     KEY1:array[0..7] of byte;
     KEY2:array[0..7] of byte;

 end;
 //ǩ������
  TBANKGETQD = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;   
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;

 end;
 //ǩ��Ӧ��
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
 //���߳�ֵ��ѯ
  TBANKGETCZQUERY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
 end;
 //���߳�ֵ��ѯӦ��
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
 //���߳�ֵ����
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
 //���߳�ֵ����Ӧ��
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

 //���߳�ֵ�ɹ�
  TBANKGETCZCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceType:array[0..1] of ansichar;  //Ʊ������
     InvoiceBatch:array[0..3] of ansichar;   //Ʊ������
     InvoiceID:array[0..7] of ansichar;   //Ʊ�ݺ�
     AfterMoney:array[0..11] of ansichar;    //��ֵ�������
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;    //������ˮ��
     OnlineSN:array[0..3] of ansichar;  //�����������к�
     OfflineSN:array[0..3] of ansichar;   //�ѻ��������к�
     WriteCardFlag:array[0..0] of ansichar;  //д����־
 end;

 //���߳�ֵ�ɹ�Ӧ��
  TBANKSETCZCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;    //������ˮ��
 end;

 //����Ȧ������
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
 //����Ȧ��Ӧ��
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
  //����Ȧ��ɹ�
  TBANKGETQCCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceType:array[0..1] of ansichar;  //Ʊ������
     InvoiceBatch:array[0..3] of ansichar;   //Ʊ������
     InvoiceID:array[0..7] of ansichar;   //Ʊ�ݺ�
     AfterMoney:array[0..11] of ansichar;    //��ֵ�������
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;    //������ˮ��
     OnlineSN:array[0..3] of ansichar;  //�����������к�
     OfflineSN:array[0..3] of ansichar;   //�ѻ��������к�
     WriteCardFlag:array[0..0] of ansichar;  //д����־
 end;
 //����Ȧ��ɹ�Ӧ��
  TBANKSETQCCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;    //������ˮ��
 end;

  //Ʊ�ݴ�ӡ����
  TBANKGETCZPJDY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceType:array[0..1] of ansichar;  //Ʊ������
     InvoiceBatch:array[0..3] of ansichar;   //Ʊ������
     InvoiceID:array[0..7] of ansichar;   //Ʊ�ݺ�
     WasteSN:array[0..29] of ansichar;    //������ˮ��
     operatorID:array[0..7] of ansichar;  //����Ա
 end;
 //Ʊ�ݴ�ӡӦ��

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
     InvoiceID:array[0..7] of ansichar;   //Ʊ�ݺ�
     AfterMoney:array[0..11] of ansichar;    //��ֵ�������
     CZMoney:array[0..11] of ansichar;
     BKMoney:array[0..11] of ansichar;
     TKMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;    //������ˮ��
     OnlineSN:array[0..3] of ansichar;  //�����������к�
     OfflineSN:array[0..3] of ansichar;   //�ѻ��������к�
     vehplate:array[0..15] of ansichar;  //д����־
 end;
  //Ʊ���ش�����
  TBANKGETCZPJCD = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     WasteSN:array[0..29] of ansichar;    //������ˮ��
     oldInvoiceType:array[0..1] of ansichar;  //Ʊ������
     oldInvoiceBatch:array[0..3] of ansichar;   //Ʊ������
     oldInvoiceID:array[0..7] of ansichar;   //Ʊ�ݺ�
     newInvoiceType:array[0..1] of ansichar;  //Ʊ������
     newInvoiceBatch:array[0..3] of ansichar;   //Ʊ������
     newInvoiceID:array[0..7] of ansichar;   //Ʊ�ݺ�

     operatorID:array[0..7] of ansichar;  //����Ա
 end;


 //��ֵ��������
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
 //��ֵ����Ӧ��
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
