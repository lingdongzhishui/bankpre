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
     //�ֳֻ��û���¼������ 1011
  TOPERATORLOGINBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     OperatorNo:array[0..9] of ansichar;            //5����¼����
     OperatorPassword:array[0..19] of ansichar;              //6�� ��¼����
 end;
 //�ֳֻ��û���¼����Ӧ���� 1012
  TOPERATORLOGINYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     OperatorNo:array[0..9] of ansichar;            //5����¼����

 end;

//��ֵ

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
 //��ֵӦ��
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

    //�ֳֻ������ͼƬ�ϴ����� 1009
  THANDSETUPIMAGEBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     VehPlate:array[0..9] of ansichar;            //5�����ƺ�
     Vehtype:array[0..1] of ansichar;              //6�� ����
     ImageName:array[0..37] of ansichar;              //7���ϴ�ͼƬ����
     OperatorNo:array[0..9] of ansichar;            //8������Ա����
 end;
 //�ֳֻ������ͼƬ�ϴ�Ӧ���� 1010
  THANDSETUPIMAGEYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;     //5���ն˱��

 end;
 //�ͻ��˻������ģ�2021��
  TCUSTOMERREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     networkID:array[0..6] of ansichar;      //3��������
     TerminalID:array[0..9] of ansichar;     //4���ն˱��
     CustomerID:array[0..19] of ansichar;
     userName:array[0..99] of ansichar;
     userType:array[0..3] of ansichar;
     address:array[0..199] of ansichar;
     tel:array[0..19] of ansichar;
     userIdNum:array[0..19] of ansichar;
     userIdType:array[0..3] of ansichar;

     agentName:array[0..9] of ansichar;
     agentIdType:array[0..3] of ansichar;     //13��ָ��������֤�����ͣ���λ�û����
     agentIdNum:array[0..19] of ansichar;     //14��ָ��������֤���ţ���λ�û����
     department:array[0..19] of ansichar;
     password:array[0..19] of AnsiChar;
     OperatorID:array[0..7] of ansichar;
     operation:array[0..3] of ansichar;
  end;
  //�ͻ��˻�Ӧ���ģ�2022��
  TCUSTOMERRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     userName:array[0..99] of ansichar;
     userType:array[0..3] of ansichar;
     address:array[0..199] of ansichar;
     tel:array[0..19] of ansichar;
     userIdNum:array[0..19] of ansichar;
     userIdType:array[0..3] of ansichar;       //12���û�֤������
     agentName:array[0..9] of ansichar;        //13��ָ������������
     agentIdType:array[0..3] of ansichar;      //14��ָ��������֤�����ͣ���λ�û����
     agentIdNum:array[0..19] of ansichar;     //15��ָ��������֤���ţ���λ�û����
     department:array[0..19] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
  //�ͻ����������ģ�2023��
  TVEHICLEREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     networkID:array[0..6] of ansichar;      //4��������
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
  //�ͻ�����Ӧ���ģ�2024��
  TVEHICLERESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4��������
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
   //���ӱ�ǩ(OBU)�����ģ�2025��
  TOBUREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     networkID:array[0..6] of ansichar;      //4��������
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
  //���ӱ�ǩ(OBU)Ӧ���ģ�2026��
  TOBURESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     OBUNo:array[0..19] of ansichar;
     OBUState:array[0..3] of ansichar;
     StartUseTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
  //��ֵ�������ģ�2027��
  TPRECARDREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     networkID:array[0..6] of ansichar;      //4��������
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
  //��ֵ��Ӧ���ģ�2028��
  TPRECARDRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     CardID:array[0..19] of ansichar;
     CardState:array[0..3] of ansichar;
     IssueTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
  //���˿������ģ�2029��
  TCHARGECARDREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     networkID:array[0..6] of ansichar;      //4��������
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
  //���˿�Ӧ���ģ�2030��
  TCHARGECARDRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     VehiclePlateNo:array[0..9] of ansichar;
     CardID:array[0..19] of ansichar;
     CardState:array[0..3] of ansichar;
     IssueTime:array[0..19] of ansichar;
     InvalidTime:array[0..19] of ansichar;
     OperatorID:array[0..7] of ansichar;
  end;
   //���ж��������ģ�2041��
  TORDERREQUEST = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     networkID:array[0..6] of ansichar;      //4��������
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
  //���ж���Ӧ���ģ�2042��
  TORDERRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;
     OrderID:array[0..29] of AnsiChar;
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
//���߳�ֵ��ѯ
  TBANKGETZHCZQUERY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     userpassword:array[0..19] of ansichar;
     CardID:array[0..19] of ansichar;
 end;
 //���߳�ֵ��ѯӦ��
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

//���߳�ֵ��ѯ
  TBANKGETusermodypassword = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of ansichar;
     password:array[0..19] of ansichar;
     newpassword:array[0..19] of ansichar;
 end;
 //���߳�ֵ��ѯӦ��
  TBANKSETusermodypassword = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;


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
     termdate:array[0..7] of AnsiChar;
     termtime:array[0..5] of AnsiChar;     
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
     WriteCardFlag:array [0..0] of ansichar;  //д����־
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

  TBANKZHFPQQ=packed record   //�˻����������ģ�2035��
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

  TBANKZHFPYD=packed record     //�˻�����ȷ��Ӧ���ģ�2036��
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


 //���߳�������
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
     CardSeq:array[0..3] of ansichar;   //�������к�
     KeyIndex:array[0..1] of ansichar;  //��Կ�汾��
     KeyID:array[0..1] of ansichar;     //�㷨��ʶ
     TermNo:array[0..11] of AnsiChar;
     TermDate:array[0..7] of AnsiChar;
     TermTime:array[0..5] of AnsiChar;
     OperatorID:array[0..7] of AnsiChar;

 end;
 //���߳���Ӧ��
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

 //���߳����ɹ�
  TBANKGETCZHENGCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     AfterMoney:array[0..11] of ansichar;    //��ֵ�������
     CZMoney:array[0..11] of ansichar;
     WasteSN:array[0..29] of ansichar;    //������ˮ��
     OnlineSN:array[0..7] of ansichar;  //�����������к�
     OfflineSN:array[0..3] of ansichar;  //�����������к�
     MAC2:array[0..7] of ansichar;
     TAC:array[0..7] of ansichar;
     WriteCardFlag:array[0..0] of ansichar;
 end;

 //���߳����ɹ�Ӧ��
  TBANKSETCZhengCG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     WasteSN:array[0..29] of ansichar;    //������ˮ��     
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;

 end;

 //��ʧ����
  TBANKGETGS = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     PCardPassword:array[0..15] of ansichar;    //����
     OperatorID:array[0..7] of ansichar;

 end;

 //��ʧӦ��
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
 //�������
  TBANKGETJG = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     PCardPassword:array[0..15] of ansichar;    //����
     OperatorID:array[0..7] of ansichar;

 end;

 //���Ӧ��
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

//�޸���������
  TBANKGETmodipassword = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     PCardPassword:array[0..15] of ansichar;    //����
     PCardnewPassword:array[0..15] of ansichar;    //����
     OperatorID:array[0..7] of ansichar;

 end;
 //�޸�����Ӧ��
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

//��������
  TBANKGETDZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     WorkDate:array[0..7] of ansichar;
     BankID:array[0..6] of ansichar;
     FileName:array[0..36] of ansichar;
     RecordNumber:array[0..5] of ansichar;
     VerifyCode:array[0..31] of ansichar;

 end;
 //����Ӧ��
  TBANKSETDZ = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     WorkDate:array[0..7] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     BankID:array[0..6] of ansichar;
 end;
//ũ�����޸ĵ绰������
   TBANKGETPHONE = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            //2������ʱ��
     BankID:array[0..6] of ansichar;                //3�����б��
     networkID:array[0..6] of ansichar;              //4��������
     CustomerID:array[0..19] of ansichar;            //5����ͨ���û���
     PCardNetID:array[0..3] of ansichar;             //6����ͨ���������ţ�ɽ����1401
     PCardID:array[0..15] of ansichar;               //7����ͨ������
     CertificateType:array[0..1] of ansichar;        //8��֤������
     CertificateID:array[0..59] of ansichar;         //9��֤������
     BankCardID:array[0..31] of ansichar;            //10�����п�����
     EntrustVerifyCode:array[0..15] of ansichar;     //11��ί��У����
     OperatorID:array[0..19] of AnsiChar;             //12 ����Ա
     NewPhoneNO:array[0..10] of ansichar;            //13 �µ绰
  end;

 //ũ�����޸ĵ绰Ӧ����
  TBANKSETPHONE = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
 end;
  //�󶨿�����������  4001
  TBANKGETBDCARDKH = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     BankID:array[0..6] of ansichar;                 //5�����б��
     CustomerID:array[0..19] of ansichar;            //6����ͨ���û���
     UserType:array[0..1] of ansichar;               //7���û�����
     UserName:array[0..99] of ansichar;              //8�� ��ͨ���û���
     CertificateType:array[0..1] of ansichar;        //9��֤������
     CertificateID:array[0..59] of ansichar;         //10��֤������
     PCardNetID:array[0..3] of ansichar;             //11����ͨ���������ţ�ɽ����1401
     PCardID:array[0..15] of ansichar;               //12����ͨ������
     EntrustVerifyCode:array[0..15] of ansichar;     //13��ί��У����
     Vehplate:array[0..11] of ansichar;              //14�����ƺ�
     VehplateColor:array[0..1] of ansichar;           //15��������ɫ
     VehType:array[0..1] of ansichar;        //16����������
     VehSeatNum:array[0..1] of ansichar;     //17��������λ��
     WasteSN:array[0..29] of ansichar;       //18����ˮ���к�
     //����Ϊ����
     BankCardType:array[0..1] of ansichar;       //19�����п�����
     BCertificateType:array [0..1] of ansichar;  //20�����п�֤������
     BVCertificateID: array[0..59] of ansichar;  //21�����п�֤������
     ActiveDate:array [0..7]  of ansichar;       //22�����п���Ч����
     BankCardID:array[0..31] of ansichar;        //23�����п�����

     BUserName:array[0..19] of ansichar;         //24�����п�����
     OperatorName:array[0..19] of ansichar;      //25��������Ա
     BankCustomerID:array[0..11] of ansichar;    //26�����пͻ�ID
     Remark:array[0..49] of ansichar;        //27�������ֶ�   �����ֶ�
 end;
 //�󶨿�����Ӧ���� 4002
  TBANKSETBDCARDKH = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;     //5���ն˱��
     BankID:array[0..6] of ansichar;         //6�����б��
     CustomerID:array[0..19] of ansichar;    //7����ͨ���û���
     PCardNetID:array[0..3] of ansichar;     //8����ͨ���������ţ�ɽ����1401
     PCardID:array[0..15] of ansichar;       //9����ͨ������
     Vehplate:array[0..11] of ansichar;      //10�����ƺ�
     VehplateColor:array[0..1] of ansichar;  //11��������ɫ

     //����Ϊ����
     WasteSN:array [0..29] of ansichar;          //12����ˮ���к�
     BankCardType:array[0..1] of ansichar;       //13�����п�����
     BCertificateType:array[0..1] of ansichar;   //14�����п�֤��
     BVCertificateID :array[0..59] of ansichar;  //15�����п�֤������
     ActiveDate:array[0..7] of ansichar;         //16�����п���Ч����
     BankCardID:array[0..31] of ansichar;       //17�����п�����
     BUserName :array[0..19] of ansichar;        //18�����п�����
     OperatorName:array[ 0..19] of ansichar;     //19��������Ա
 end;

  //�󶨿��ذ󿪻�������  4003
  TBANKGETCBCARDKH = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     BankID:array[0..6] of ansichar;                 //5�����б��
     CustomerID:array[0..19] of ansichar;            //6����ͨ���û���
     UserType:array[0..1] of ansichar;               //7���û�����
     UserName:array[0..99] of ansichar;              //8�� ��ͨ���û���

     CertificateType:array[0..1] of ansichar;        //9��֤������
     CertificateID:array[0..59] of ansichar;         //10��֤������


     PCardNetID:array[0..3] of ansichar;             //11����ͨ���������ţ�ɽ����1401
     PCardID:array[0..15] of ansichar;               //12����ͨ������

     EntrustVerifyCode:array[0..15] of ansichar;     //13��ί��У����
     Vehplate:array[0..11] of ansichar;              //14�����ƺ�
     VehplateColor:array[0..1] of ansichar;           //15��������ɫ


     VehType:array[0..1] of ansichar;        //16����������
     VehSeatNum:array[0..1] of ansichar;     //17��������λ��
     WasteSN:array[0..29] of ansichar;       //18����ˮ���к�

     //����Ϊ����
     BankCardType:array[0..1] of ansichar;       //19�����п�����
     BCertificateType:array [0..1] of ansichar;  //20�����п�֤������
     BVCertificateID: array[0..59] of ansichar;  //21�����п�֤������
     ActiveDate:array [0..7]  of ansichar;       //22�����п���Ч����
     BankCardID:array[0..31] of ansichar;        //23�����п�����

     BUserName:array[0..19] of ansichar;         //24�����п�����
      BankCardTypeNew:array[0..1] of ansichar;       //19�����п�����
     BCertificateTypeNew:array [0..1] of ansichar;  //20�����п�֤������
     BVCertificateIDNew: array[0..59] of ansichar;  //21�����п�֤������
     ActiveDateNew:array [0..7]  of ansichar;       //22�����п���Ч����
     BankCardIDNew:array[0..31] of ansichar;        //23�����п�����

     BUserNameNew:array[0..19] of ansichar;         //24�����п�����
     OperatorName:array[0..19] of ansichar;      //25��������Ա
 end;
 //�󶨿��ذ󿪻�Ӧ���� 4004
  TBANKSETCBCARDKH = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;     //5���ն˱��
     BankID:array[0..6] of ansichar;         //6�����б��
     CustomerID:array[0..19] of ansichar;    //7����ͨ���û���
     PCardNetID:array[0..3] of ansichar;     //8����ͨ���������ţ�ɽ����1401
     PCardID:array[0..15] of ansichar;       //9����ͨ������
     Vehplate:array[0..11] of ansichar;      //10�����ƺ�
     VehplateColor:array[0..1] of ansichar;  //11��������ɫ

     //����Ϊ����
     WasteSN:array [0..29] of ansichar;          //12����ˮ���к�
     BankCardType:array[0..1] of ansichar;       //13�����п�����
     BCertificateType:array[0..1] of ansichar;   //14�����п�֤��
     BVCertificateID :array[0..59] of ansichar;  //15�����п�֤������
     ActiveDate:array[0..7] of ansichar;         //16�����п���Ч����
      BankCardID:array[0..31] of ansichar;       //17�����п�����
     BUserName :array[0..19] of ansichar;        //18�����п�����
     OperatorName:array[ 0..19] of ansichar;     //19��������Ա
 end;

//һ�η��з���֪ͨ���� 5001
  TBANKGETYCFXTZBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     BankID:array[0..6] of ansichar;                 //5�����б��
     FileName:array[0..35] of ansichar;            //6����¼��
     RecordNumber:array[0..5] of ansichar;               //7���û�����
     CardnoBegin:array[0..19] of ansichar;              //8�� ����������Ϣ
     CardnoEnd:array[0..19] of ansichar;              //8�� ����������Ϣ     
     Remark:array[0..99] of ansichar;        //9�������ֶ�
     VerifyCode:array[0..31] of ansichar;         //10��MD5��

 end;
 //һ�η��н���Ӧ���� 5002
  TBANKSETYCFXTZBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;     //5���ն˱��
     BankID:array[0..6] of ansichar;         //6�����б��
     
 end;

 //һ�η�����Կ�ļ�����֪ͨ���� 5003
  TBANKGETYCFXMYTZBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     BankID:array[0..6] of ansichar;                 //5�����б��
     FileName:array[0..35] of ansichar;            //6����¼��
     RecordNumber:array[0..5] of ansichar;               //7���û�����
     Cardnobegin:array[0..19] of ansichar;              //8�� ����������Ϣ
     Cardnoend:array[0..19] of ansichar;              //8�� ����������Ϣ     

     Remark:array[0..99] of ansichar;        //9�������ֶ�
     VerifyCode:array[0..31] of ansichar;         //10��MD5��

 end;
 //һ�η�����Կ�ļ�����Ӧ���� 5004
  TBANKSETYCFXMYYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;     //5���ն˱��
     BankID:array[0..6] of ansichar;         //6�����б��

 end;

  //���η��н���ļ�����֪ͨ���� 5005
  TBANKGETECFXJGWJFSTZBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     BankID:array[0..6] of ansichar;                 //5�����б��
     FileName:array[0..35] of ansichar;            //6����¼��
     RecordNumber:array[0..5] of ansichar;               //7���û�����
     CardnoMark:array[0..19] of ansichar;              //8�� ����������Ϣ

     Remark:array[0..99] of ansichar;        //9�������ֶ�
     VerifyCode:array[0..31] of ansichar;         //10��MD5��

 end;
 //���η��н���ļ����ͽ���Ӧ���� 5006
  TBANKGETECFXJGWJJSYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;     //5���ն˱��
     BankID:array[0..6] of ansichar;         //6�����б��

 end;

  //������Ϣ��ѯ���� 5007
  TBANKGETCLXXCXBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     VehPlate:array[0..9] of ansichar;            //5�����ƺ�
     VehPlateColor:array[0..1] of ansichar;              //6�� ������ɫ

 end;
 //������Ϣ��ѯӦ���� 5008
  TBANKGETCLXXCXYDBW = packed record
     ProcessDate:array[0..7] of ansichar;    //1����������
     ProcessTime:array[0..5] of ansichar;    //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;   //3��Ӧ����
     networkID:array[0..6] of ansichar;      //4��������
     TerminalID:array[0..9] of ansichar;     //5���ն˱��
     CarStatus:array[0..0] of ansichar;         //6������״̬

 end;
  //���η����쳣����ļ�����֪ͨ���� 5009
  TBANKGETECFXYCTZBW = packed record
     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     BankID:array[0..6] of ansichar;                 //5�����б��
     FileName:array[0..35] of ansichar;              //6������FTP��ʽ�����ļ�
     RecordNumber:array[0..5] of ansichar;           //7����¼����
     remark:array[0..99] of AnsiChar;                //8������˵��
     VerifyCode:array[0..31] of ansichar;            //9��Md5��
  end;
  //���η����쳣����ļ�����Ӧ���� 5010
  TBANKSETECFXYCYDBW = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     ResponseCode:array[0..1] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     BankID:array[0..6] of ansichar;
   end;
 //�󶨿�����������  4011
  TBANKGETBDCARDXH = packed record

      ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     networkID:array[0..6] of ansichar;              //3��������
     TerminalID:array[0..9] of ansichar;             //4�� �ն˱��
     BankID:array[0..6] of ansichar;                 //5�����б��
     CustomerID:array[0..19] of ansichar;            //6����ͨ���û���
     UserType:array[0..1] of ansichar;               //7���û�����
     UserName:array[0..99] of ansichar;              //8�� ��ͨ���û���

     CertificateType:array[0..1] of ansichar;        //9��֤������
     CertificateID:array[0..59] of ansichar;         //10��֤������


     PCardNetID:array[0..3] of ansichar;             //11����ͨ���������ţ�ɽ����1401
     PCardID:array[0..15] of ansichar;               //12����ͨ������

     EntrustVerifyCode:array[0..15] of ansichar;     //13��ί��У����
     Vehplate:array[0..11] of ansichar;              //14�����ƺ�
     VehplateColor:array[0..1] of ansichar;           //15��������ɫ

     WasteSN:array[0..29] of ansichar;           //16����ˮ���к�
     BankCardType:array[0..1] of ansichar;       //17�����п�����

     BCertificateType:array [0..1] of ansichar;  //18�����п�֤������
     BVCertificateID: array[0..59] of ansichar;  //19�����п�֤������
     ActiveDate:array [0..7]  of ansichar;       //20�����п���Ч����
     BankCardID:array[0..31] of ansichar;        //21�����п�����

     BUserName:array[0..19] of ansichar;         //22�����п�����
     OperatorName:array[0..19] of ansichar;      //23��������Ա
 end;
 //�󶨿�����Ӧ����   4012
  TBANKSETBDCARDXH = packed record

     ProcessDate:array[0..7] of ansichar;            //1����������
     ProcessTime:array[0..5] of ansichar;            // 2������ʱ��
     ResponseCode:array[0..1] of ansichar;           //3��Ӧ����
     networkID:array[0..6] of ansichar;              //4��������
     TerminalID:array[0..9] of ansichar;             //5�� �ն˱��
     BankID:array[0..6] of ansichar;                 //6�����б��
     CustomerID:array[0..19] of ansichar;            //7����ͨ���û���

     PCardNetID:array[0..3] of ansichar;             //8����ͨ���������ţ�ɽ����1401
     PCardID:array[0..15] of ansichar;               //9����ͨ������


     Vehplate:array[0..11] of ansichar;              //10�����ƺ�
     VehplateColor:array[0..1] of ansichar;           //11��������ɫ

     WasteSN:array[0..29] of ansichar;           //12����ˮ���к�
     BankCardType:array[0..1] of ansichar;       //13�����п�����

     BCertificateType:array [0..1] of ansichar;  //14�����п�֤������
     BVCertificateID: array[0..59] of ansichar;  //15�����п�֤������
     ActiveDate:array [0..7]  of ansichar;       //16�����п���Ч����

     BankCardID:array[0..31] of ansichar;        //17�����п�����
     BUserName:array[0..19] of ansichar;         //18�����п�����
     OperatorName:array[0..19] of ansichar;      //19��������Ա

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
     RecordNumber:array[0..5] of ansichar;
     VerifyCode:array[0..31] of ansichar;
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
 //�󶨿��ۿ��ļ�����֪ͨ���ģ�4041��
  TBANKGETBDKK = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     networkID:array[0..6] of ansichar;    //3��������
     TerminalID:array[0..9] of ansichar;   //4���ն˱��
     balanceDate:array[0..7] of ansichar;  //5����������
     BankID:array[0..6] of ansichar;       //6�����б��
     FileName:array[0..35] of ansichar;    //7������FTP��ʽ�������ļ�
     RecordNumber:array[0..5] of ansichar; //8����¼����
     totalcount:array[0..5] of AnsiChar;   //9���ۿ��ܱ���
     totalAmount:array[0..11] of AnsiChar;  //10 �ۿ��ܽ�
     VerifyCode:array[0..31] of ansichar;  //11��Md5��

 end;

 //�û��������������ģ�2043��
  TBANKORDERSEND = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     networkID:array[0..6] of ansichar;    //3��������
     TerminalID:array[0..9] of ansichar;   //4���ն˱��
     CustomerID:array[0..19] of ansichar;  //5���û���
     Vehplate:array[0..9] of ansichar;       //6�����ƺ�
     VehplateColor:array[0..1] of ansichar;    //7��
     OrderID:array[0..29] of ansichar; //8��
     EtccardID:array[0..19] of AnsiChar;   //9��
     obuno:array[0..19] of AnsiChar;  //10
     expressid:array[0..29] of ansichar;  //11���˵���

 end;
  //�û��������������ģ�2044��
  TBANKORDERSENDRESPONSE = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     ResponseCode:array[0..1] of ansichar; //3��Ӧ����

 end;
 //����������ϸ�ļ�����֪ͨ���ģ�4043��
  TBANKGETDZXFTZBW = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     networkID:array[0..6] of ansichar;    //3��������
     TerminalID:array[0..9] of ansichar;   //4���ն˱��
     BankID:array[0..6] of ansichar;       //5�����б��
     FileName:array[0..35] of ansichar;    //6������FTP��ʽ�������ļ�
     RecordNumber:array[0..5] of ansichar; //7����¼����
     remark:array[0..99] of AnsiChar;   //8������˵��
     VerifyCode:array[0..31] of ansichar;  //9��Md5��

 end;
 //JZ�ۿ��ļ�����֪ͨ���ģ�5041��
  TBANKGETJZFKK = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     networkID:array[0..6] of ansichar;    //3��������
     TerminalID:array[0..9] of ansichar;   //4���ն˱��
     balanceDate:array[0..7] of ansichar;  //5����������
     BankID:array[0..6] of ansichar;       //6�����б��
     FileName:array[0..35] of ansichar;    //7������FTP��ʽ�������ļ�
     RecordNumber:array[0..5] of ansichar; //8����¼����
     totalcount:array[0..5] of AnsiChar;   //9���ۿ��ܱ���
     totalAmount:array[0..11] of AnsiChar;  //10 �ۿ��ܽ�
     VerifyCode:array[0..31] of ansichar;  //11��Md5��

 end;
 //�󶨿��ۿ��ļ�����Ӧ���ģ�4042��
  TBANKSETBDKK = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     ResponseCode:array[0..1] of ansichar; //3��Ӧ����
     networkID:array[0..6] of ansichar;    //4��������
     TerminalID:array[0..9] of ansichar;   //5���ն˱��
     BankID:array[0..6] of ansichar;       //6�����б��
     BalanceDate:array[0..7] of AnsiChar;  //7����������

 end;
 //����������ϸ�ļ�����Ӧ���ģ�4044��
  TBANKGETDZXFYDBW = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     ResponseCode:array[0..1] of ansichar; //3��Ӧ����
     networkID:array[0..6] of ansichar;    //4��������
     TerminalID:array[0..9] of ansichar;   //5���ն˱��
     BankID:array[0..6] of ansichar;       //6�����б��

 end;
 //JZF�ۿ��ļ�����Ӧ���ģ�5042��
  TBANKSETJZFKK = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     ResponseCode:array[0..1] of ansichar; //3��Ӧ����
     networkID:array[0..6] of ansichar;    //4��������
     TerminalID:array[0..9] of ansichar;   //5���ն˱��
     BankID:array[0..6] of ansichar;       //6�����б��
     BalanceDate:array[0..7] of AnsiChar;  //7����������

 end;
 //�󶨿��ۿ����ļ�����֪ͨ���� (4051)
  TBANKGETBDKKRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1�������ڣ�ָҵ����ʱ�ĵ�ǰ���ڡ���ʽ��YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2����ʱ�䣬ָҵ����ʱ�ĵ�ǰʱ�䡣��ʽ��hhmmss
     networkID:array[0..6] of ansichar;   //3�����ţ���Ź����������ʶ����ͬ��
     TerminalID:array[0..9] of ansichar;   //4�ն˱�ţ���Ź�����NetWorkID�����3λʮ��������
     balanceDate:array[0..7] of ansichar;  //5�������ڣ���ʽ��YYYYMMDD
     BankID:array[0..6] of ansichar;     //6���б�ţ���Ź����������ʶ����ͬ��
     FileName:array[0..35] of ansichar;  //7����FTP��ʽ�������ļ������ֵ�����ļ����ۿ��ļ���
     RecordNumber:array[0..5] of ansichar;//8��¼������ָ��ֵ�����ļ����������ļ����ۿ��ļ�ϸĿ������
     totalcount:array[0..5] of AnsiChar;  //9�ۿ��ܱ���
     totalAmount:array[0..11] of AnsiChar; //10 �ۿ��ܽ��
     SucceedCount:array[0..5] of AnsiChar; //11�ۿ�ɹ�����
     SucceedAmount:array[0..11] of AnsiChar;  //12 �ۿ�ɹ����
     FailCount:array[0..5] of AnsiChar;    //13�ۿ�ʧ�ܱ���
     FailAmount:array[0..11] of AnsiChar;   //14�ۿ�ʧ�ܽ��
     VerifyCode:array[0..31] of ansichar;   //15Md5��

 end;
  //���۽����ϸ�ļ�����֪ͨ���� (4053)
  TBANKGETDZJGMXFSTZBW = packed record
     ProcessDate:array[0..7] of ansichar;   //1�������ڣ�ָҵ����ʱ�ĵ�ǰ���ڡ���ʽ��YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2����ʱ�䣬ָҵ����ʱ�ĵ�ǰʱ�䡣��ʽ��hhmmss
     networkID:array[0..6] of ansichar;   //3�����ţ���Ź����������ʶ����ͬ��
     TerminalID:array[0..9] of ansichar;   //4�ն˱�ţ���Ź�����NetWorkID�����3λʮ��������
     BankID:array[0..6] of ansichar;     //5���б�ţ���Ź����������ʶ����ͬ��
     FileName:array[0..35] of ansichar;  //6����FTP��ʽ�������ļ������ֵ�����ļ����ۿ��ļ���
     RecordNumber:array[0..5] of ansichar;//7��¼������ָ��ֵ�����ļ����������ļ����ۿ��ļ�ϸĿ������
     remark:array[0..99] of AnsiChar;   //8����˵��
     VerifyCode:array[0..31] of ansichar;   //9 Md5��

 end;
 //JZF�ۿ����ļ�����֪ͨ���� (5051)
  TBANKGETBDJZFRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1�������ڣ�ָҵ����ʱ�ĵ�ǰ���ڡ���ʽ��YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2����ʱ�䣬ָҵ����ʱ�ĵ�ǰʱ�䡣��ʽ��hhmmss
     networkID:array[0..6] of ansichar;   //3�����ţ���Ź����������ʶ����ͬ��
     TerminalID:array[0..9] of ansichar;   //4�ն˱�ţ���Ź�����NetWorkID�����3λʮ��������
     balanceDate:array[0..7] of ansichar;  //5�������ڣ���ʽ��YYYYMMDD
     BankID:array[0..6] of ansichar;     //6���б�ţ���Ź����������ʶ����ͬ��
     FileName:array[0..35] of ansichar;  //7����FTP��ʽ�������ļ������ֵ�����ļ����ۿ��ļ���
     RecordNumber:array[0..5] of ansichar;//8��¼������ָ��ֵ�����ļ����������ļ����ۿ��ļ�ϸĿ������
     totalcount:array[0..5] of AnsiChar;  //9�ۿ��ܱ���
     totalAmount:array[0..11] of AnsiChar; //10 �ۿ��ܽ��
     SucceedCount:array[0..5] of AnsiChar; //11�ۿ�ɹ�����
     SucceedAmount:array[0..11] of AnsiChar;  //12 �ۿ�ɹ����
     FailCount:array[0..5] of AnsiChar;    //13�ۿ�ʧ�ܱ���
     FailAmount:array[0..11] of AnsiChar;   //14�ۿ�ʧ�ܽ��
     VerifyCode:array[0..31] of ansichar;   //15Md5��

 end;
 //�󶨿��ۿ����ļ�Ӧ��֪ͨ���� (4052)
  TBANKSETBDKKRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1�������ڣ�ָҵ����ʱ�ĵ�ǰ���ڡ���ʽ��YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2����ʱ�䣬ָҵ����ʱ�ĵ�ǰʱ�䡣��ʽ��hhmmss
     ResponseCode:array[0..1] of ansichar; //3��Ӧ����
     networkID:array[0..6] of ansichar;   //4�����ţ���Ź����������ʶ����ͬ��
     TerminalID:array[0..9] of ansichar;   //5�ն˱�ţ���Ź�����NetWorkID�����3λʮ��������
     BankID:array[0..6] of ansichar;     //7���б�ţ���Ź����������ʶ����ͬ��
     balanceDate:array[0..7] of ansichar;  //6�������ڣ���ʽ��YYYYMMDD

 end;
 //���۽����ϸ�ļ�����Ӧ���� (4054)
  TBANKSETDZJGMXJSYDBW = packed record
     ProcessDate:array[0..7] of ansichar;   //1�������ڣ�ָҵ����ʱ�ĵ�ǰ���ڡ���ʽ��YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2����ʱ�䣬ָҵ����ʱ�ĵ�ǰʱ�䡣��ʽ��hhmmss
     ResponseCode:array[0..1] of ansichar; //3��Ӧ����
     networkID:array[0..6] of ansichar;   //4�����ţ���Ź����������ʶ����ͬ��
     TerminalID:array[0..9] of ansichar;   //5�ն˱�ţ���Ź�����NetWorkID�����3λʮ��������
     BankID:array[0..6] of ansichar;     //6���б�ţ���Ź����������ʶ����ͬ��

 end;
 //JZF�ۿ����ļ�Ӧ��֪ͨ���� (5052)
  TBANKSETBDJZFRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1�������ڣ�ָҵ����ʱ�ĵ�ǰ���ڡ���ʽ��YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2����ʱ�䣬ָҵ����ʱ�ĵ�ǰʱ�䡣��ʽ��hhmmss
     ResponseCode:array[0..1] of ansichar; //3��Ӧ����
     networkID:array[0..6] of ansichar;   //4�����ţ���Ź����������ʶ����ͬ��
     TerminalID:array[0..9] of ansichar;   //5�ն˱�ţ���Ź�����NetWorkID�����3λʮ��������
     BankID:array[0..6] of ansichar;     //7���б�ţ���Ź����������ʶ����ͬ��
     balanceDate:array[0..7] of ansichar;  //6�������ڣ���ʽ��YYYYMMDD

 end;
  //�󶨿�ǩԼ֪ͨ���� (4071)
  TBANKGETBDKBDRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1�������ڣ�ָҵ����ʱ�ĵ�ǰ���ڡ���ʽ��YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2����ʱ�䣬ָҵ����ʱ�ĵ�ǰʱ�䡣��ʽ��hhmmss
     networkID:array[0..6] of ansichar;   //3�����ţ���Ź����������ʶ����ͬ��
     TerminalID:array[0..9] of ansichar;   //4�ն˱�ţ���Ź�����NetWorkID�����3λʮ��������
     balanceDate:array[0..7] of ansichar;  //5�������ڣ���ʽ��YYYYMMDD
     BankID:array[0..6] of ansichar;     //6���б�ţ���Ź����������ʶ����ͬ��
     FileName:array[0..35] of ansichar;  //7����FTP��ʽ�������ļ������ֵ�����ļ����ۿ��ļ���
     RecordNumber:array[0..5] of ansichar;//8��¼������ָ��ֵ�����ļ����������ļ����ۿ��ļ�ϸĿ������
     VerifyCode:array[0..31] of ansichar;   //9Md5��

 end;
 //�󶨿��󶨽���ļ�Ӧ��֪ͨ���� (4072)
  TBANKSETBDKBDRESULT = packed record
     ProcessDate:array[0..7] of ansichar;   //1�������ڣ�ָҵ����ʱ�ĵ�ǰ���ڡ���ʽ��YYYYMMDD
     ProcessTime:array[0..5] of ansichar;   //2����ʱ�䣬ָҵ����ʱ�ĵ�ǰʱ�䡣��ʽ��hhmmss
     ResponseCode:array[0..1] of ansichar; //3��Ӧ����
     networkID:array[0..6] of ansichar;   //4�����ţ���Ź����������ʶ����ͬ��
     TerminalID:array[0..9] of ansichar;   //5�ն˱�ţ���Ź�����NetWorkID�����3λʮ��������
     BankID:array[0..6] of ansichar;     //7���б�ţ���Ź����������ʶ����ͬ��
     balanceDate:array[0..7] of ansichar;  //6�������ڣ���ʽ��YYYYMMDD

 end;
 //������֪ͨ����  4021
  TBANKGETBLACKCARD = packed record
     ProcessDate:array[0..7] of ansichar; //1����������
     ProcessTime:array[0..5] of ansichar; //2�� ����ʱ��
     networkID:array[0..6] of ansichar;   //3��������
     TerminalID:array[0..9] of ansichar;   //4���ն˱��
     BankID:array[0..6] of ansichar;       //5�����б��
     CostomerID:array[0..19] of ansichar;  //6����ͨ���û���
     UserType:array[0..1] of ansichar;     //7���û�����
     UserName:array[0..99] of AnsiChar;     //8����ͨ���û���
     CertificateType:array[0..1] of AnsiChar; //9��֤������
     CertificateID:array[0..59] of ansichar;  //10��֤������
     PCardNetID:array[0..3] of ansichar;  //11����ͨ����������
     PCardID:array[0..15] of ansichar;  //12����ͨ������
     BankCardID:array[0..31] of AnsiChar; //13�����п�����
     BankWasteSN:array[0..29] of AnsiChar; //14�����н�����ˮ��
     TranType:array[0..1] of AnsiChar;     //15�����Ӱ󶨿�������22-�����󶨿�������

     BindingCardBlackCause:array[0..0] of AnsiChar;//16���󶨿�����������ԭ��
 end;
 //������Ӧ����4022
  TBANKSETBLACKCARD = packed record
     ProcessDate:array[0..7] of ansichar;   //1����������
     ProcessTime:array[0..5] of ansichar;   //2������ʱ��
     ResponseCode:array[0..1] of ansichar;  //3��Ӧ����
     networkID:array[0..6] of ansichar;     //4��������
     TerminalID:array[0..9] of ansichar;    //5���ն˱��
     BankID:array[0..6] of ansichar;        //6�����б��
     CustomerID:array[0..19] of AnsiChar;   //7����ͨ���û���
     UserName:array[0..99] of ansichar;     //8����ͨ���û���
     PCardNetID:array[0..3] of AnsiChar;    //9����ͨ����������
     PCardID:array[0..15] of ansichar;      //10����ͨ������
     BankCardID:array[0..31] of AnsiChar;   //11�����п�����
 end;
 //�������ļ�����֪ͨ���ģ�4031��
   TBANKGETBLACKFILE = packed record
     ProcessDate:array[0..7] of ansichar;  //1����������
     ProcessTime:array[0..5] of ansichar;  //2������ʱ��
     networkID:array[0..6] of ansichar;    //3��������
     TerminalID:array[0..9] of ansichar;   //4���ն˱��
     WorkDate:array[0..7] of ansichar;     //5����������
     BankID:array[0..6] of ansichar;       //6�����б��
     filename:array[0..35] of ansichar;    //7������FTP��ʽ�������ļ������ֵ�����ļ����ۿ��ļ���
     RecordNumber:array[0..5] of AnsiChar; //8����¼����
     VerifyCode:array[0..31] of AnsiChar;  //9��Md5��

   end;
   //�������ļ�����Ӧ���ģ�4032��
    TBANKSETBLACKFILE = packed record
     ProcessDate:array[0..7] of ansichar; //1����������
     ProcessTime:array[0..5] of ansichar; //2�� ����ʱ��
     ResponseCode:array[0..1] of ansichar;//3��Ӧ����
     networkID:array[0..6] of ansichar;   //3��������
     TerminalID:array[0..9] of ansichar;   //4���ն˱��
     BankID:array[0..6] of ansichar;  //5�����б��
     WorkDate:array[0..7] of ansichar;       //6����������


   end;

  TBANKGETBDPJDY = packed record
     ProcessDate:array[0..7] of ansichar;
     ProcessTime:array[0..5] of ansichar;
     networkID:array[0..6] of ansichar;
     TerminalID:array[0..9] of ansichar;
     CustomerID:array[0..19] of AnsiChar;
     PCardNetID:array[0..3] of ansichar;
     PCardID:array[0..15] of ansichar;
     InvoiceBatch:array[0..3] of ansichar;   //Ʊ������
     InvoiceID:array[0..7] of ansichar;   //Ʊ�ݺ�
     begindate:array[0..7] of ansichar;    //������ˮ��
     enddate:array[0..7] of ansichar;    //������ˮ��
     InvoiceType:array[0..1] of ansichar;  //Ʊ������
     operatorID:array[0..7] of ansichar;  //����Ա
 end;
 //Ʊ�ݴ�ӡӦ��

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
     XFMoney:array[0..11] of ansichar;    //��ֵ�������
     FreeMoney:array[0..11] of ansichar;
     BeginDate:array[0..7] of ansichar;
     EndDate:array[0..7] of ansichar;
     InvoiceBatch:array[0..3] of ansichar;   //Ʊ������
     InvoiceID:array[0..7] of ansichar;   //Ʊ�ݺ�
     vehplate:array[0..15] of ansichar;  //д����־
     InvoiceType:array[0..1] of ansichar;  //Ʊ������


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
  //ϵͳ��Ϣ�ṹ(�ֽ�38)
  TSysInfoType =  record
    contractProvider:  array [0..15] of char;     //�����̴���  �ַ�����ʽ
    contractType:  array [0..1] of  char;              //��ͬ����
    contractVersion: array [0..1] of char;            //��ͬ�汾
    contractSerialNumber: array [0..15] of char;  //�������к�  BCD���ʽ
    contractSignedDate: array [0..7] of char;    //��������    BCD���ʽ
    contractExpiredDate: array [0..7] of char;   //��������    BCD��ʽ
    //26
    Reserved: array [0..1] of char;             //27, ����λ
    //vehicleLicencePlateNumber: array [0..11] of char;       //���ƺ���     �ַ�����ʽ
  end;
  PSysInfoType = ^TSysInfoType;
    //���η������ݲ���(���롢����)
  TOBUVehicleInfo = packed record
    VehPlate: array [0..11] of char;     //���Ʊ��
    CarIDcolor: array [0..2] of char;    //������ɫ
    VehType: integer;                    //����
    UserType: integer;                  //�û�����
    CarLen: integer;                    //����
    CarWidth: integer;                  //����
    CarHight: integer;                  //����
    Wheel: integer;                     //������
    Axle: integer;                      //������
    AxleLen: integer;                   //���
    CarLoad: integer;                   //�����غ�
    CarInfo: array [0..15] of char;      //��������
    VehEngineNo: array [0..15] of char;  //���ͻ���

    DismantleCount: integer;            //��ж����
    BecomeDueDate: array [0..7] of char; //��������  20100802
    SignDate: array [0..7] of char;      //ǩ������
  end;
  POBUVehicleInfo = ^TOBUVehicleInfo;
  //��ǰ�û�����
  TUserInfo = packed record
    UserID: string[20];                   //�û�����
    UserName: array [0..31] of char;      //�û�����
    ShiftId: integer;                     //���ID
    UserPassword: array [0..31] of char;  //�û�����
    RolList: array [0..2047] of char;      //�û�Ȩ�޹����б�
    NodeId: integer;                      //��ǰ��������λ�������ڵ�ID
    NodeName: array [0..100] of char;     //��ǰ��������λ�������ڵ�����
    OrganType: integer;                   //�ڵ������������ 1:�������� 2��Ƭ������ 3��·������ 4���շ�վ 5��Ӫ������ 6����������
    WorkDate: TDateTime;                  //��������
    Function_Id: integer;                 //����ID
    RoleNo: integer;                      //�û���ɫ��  
  end;
  //ϵͳ���в����ӿ�
  TRunParameter = packed record
    UserInfo: TUserInfo;       //�û���Ϣ
  end;
  PRunParameter = ^TRunParameter;


implementation
end.