object ETCCXFORM: TETCCXFORM
  Left = 567
  Top = 387
  Width = 869
  Height = 480
  Caption = 'ETC'#20449#24687#26597#35810
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 853
    Height = 442
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'ETC'#27969#27700#26597#35810
      object DBGrid1: TDBGrid
        Left = 0
        Top = 76
        Width = 845
        Height = 338
        Align = alBottom
        DataSource = DS_ETCLIST
        TabOrder = 11
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ListNo'
            Title.Alignment = taCenter
            Title.Caption = #27969#27700#21495
            Width = 98
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'YNok'
            Title.Alignment = taCenter
            Title.Caption = #26159#21542#19978#20256
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CreateTime'
            Title.Alignment = taCenter
            Title.Caption = #21019#24314#26085#26399
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BalanceDate'
            Title.Alignment = taCenter
            Title.Caption = #19978#20256#26085#26399
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CustomerID'
            Title.Alignment = taCenter
            Title.Caption = #29992#25143'ID'
            Width = 102
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UserName'
            Title.Alignment = taCenter
            Title.Caption = #29992#25143#21517
            Width = 121
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BankCardID'
            Title.Alignment = taCenter
            Title.Caption = #38134#34892#21345'ID'
            Width = 159
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ETCCardID'
            Title.Alignment = taCenter
            Title.Caption = 'ETC'#21345'ID'
            Width = 178
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TotalToll'
            Title.Alignment = taCenter
            Title.Caption = #28040#36153#39069
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'optime'
            Title.Alignment = taCenter
            Title.Caption = #29983#25104#26085#26399
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'bankid'
            Title.Alignment = taCenter
            Title.Caption = #38134#34892'ID'
            Visible = True
          end>
      end
      object ETCID: TCheckBox
        Left = 16
        Top = 16
        Width = 97
        Height = 17
        Caption = 'ETC'#21345'ID'#26597#35810':'
        TabOrder = 1
      end
      object TXT_ETCID: TEdit
        Left = 128
        Top = 16
        Width = 217
        Height = 21
        TabOrder = 2
      end
      object Btn_etclist: TButton
        Left = 736
        Top = 8
        Width = 75
        Height = 25
        Caption = #26597#35810
        TabOrder = 0
        OnClick = Btn_etclistClick
      end
      object optime: TCheckBox
        Left = 16
        Top = 56
        Width = 113
        Height = 17
        Caption = #27969#27700#29983#25104#26085#26399#65306
        TabOrder = 10
      end
      object Date_QSRQ: TDateTimePicker
        Left = 128
        Top = 48
        Width = 105
        Height = 21
        Date = 42008.617597835650000000
        Format = 'yyyy-MM-dd'
        Time = 42008.617597835650000000
        TabOrder = 5
      end
      object Date_ZZRQ: TDateTimePicker
        Left = 248
        Top = 48
        Width = 97
        Height = 21
        Date = 42008.617597835650000000
        Format = 'yyyy-MM-dd'
        Time = 42008.617597835650000000
        TabOrder = 6
      end
      object Button1: TButton
        Left = 792
        Top = 48
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 9
        OnClick = Button1Click
      end
      object listno: TCheckBox
        Left = 376
        Top = 16
        Width = 97
        Height = 17
        Caption = #27969#27700#21495#65306
        TabOrder = 3
      end
      object TXT_LISTNO: TEdit
        Left = 448
        Top = 16
        Width = 217
        Height = 21
        TabOrder = 4
      end
      object bankcardid: TCheckBox
        Left = 376
        Top = 48
        Width = 97
        Height = 17
        Caption = #38134#34892#21345'ID'#65306
        TabOrder = 7
      end
      object TXT_bankcardid: TEdit
        Left = 456
        Top = 48
        Width = 217
        Height = 21
        TabOrder = 8
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'ETC'#25187#36153#27969#27700#26597#35810
      ImageIndex = 1
      object DBGrid2: TDBGrid
        Left = 0
        Top = 84
        Width = 845
        Height = 330
        Align = alBottom
        DataSource = DS_BANK
        TabOrder = 10
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'BalanceDate'
            Title.Alignment = taCenter
            Title.Caption = #26085#26399
            Width = 98
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ListNo'
            Title.Alignment = taCenter
            Title.Caption = #27969#27700
            Width = 136
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CustomerID'
            Title.Alignment = taCenter
            Title.Caption = #23458#25143'ID'
            Width = 141
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UserName'
            Title.Alignment = taCenter
            Title.Caption = #29992#25143#21517
            Width = 194
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PCardNetID'
            Title.Alignment = taCenter
            Title.Caption = 'ETC'#21345'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PCardID'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BankCardID'
            Title.Alignment = taCenter
            Title.Caption = #38134#34892#21345'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Amount'
            Title.Alignment = taCenter
            Title.Caption = #37329#39069
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Remarks'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'result'
            Title.Alignment = taCenter
            Title.Caption = #32467#26524
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OpTime'
            Title.Alignment = taCenter
            Title.Caption = #27969#27700#24418#25104#26085#26399
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BankID'
            Title.Alignment = taCenter
            Title.Caption = #38134#34892'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ProcRlt'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ProcOperator'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ProcOperatorName'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ProcOPTime'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ProcDesc'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Spare1'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Spare2'
            Title.Alignment = taCenter
            Visible = True
          end>
      end
      object Chk_ETCID: TCheckBox
        Left = 16
        Top = 16
        Width = 97
        Height = 17
        Caption = 'ETC'#21345'ID'#26597#35810':'
        TabOrder = 0
      end
      object Edt_etcid: TEdit
        Left = 128
        Top = 16
        Width = 217
        Height = 21
        TabOrder = 1
      end
      object CHK_optime: TCheckBox
        Left = 16
        Top = 56
        Width = 113
        Height = 17
        Caption = #27969#27700#29983#25104#26085#26399#65306
        TabOrder = 9
      end
      object bank_qsrq: TDateTimePicker
        Left = 128
        Top = 48
        Width = 105
        Height = 21
        Date = 42008.617597835650000000
        Format = 'yyyy-MM-dd'
        Time = 42008.617597835650000000
        TabOrder = 5
      end
      object bank_zzrq: TDateTimePicker
        Left = 248
        Top = 48
        Width = 97
        Height = 21
        Date = 42008.617597835650000000
        Format = 'yyyy-MM-dd'
        Time = 42008.617597835650000000
        TabOrder = 6
      end
      object chk_listno: TCheckBox
        Left = 376
        Top = 16
        Width = 97
        Height = 17
        Caption = #27969#27700#21495#65306
        TabOrder = 2
      end
      object edt_listno: TEdit
        Left = 448
        Top = 16
        Width = 225
        Height = 21
        TabOrder = 3
      end
      object chk_bankcardid: TCheckBox
        Left = 376
        Top = 48
        Width = 97
        Height = 17
        Caption = #38134#34892#21345'ID'#65306
        TabOrder = 7
      end
      object edt_bankcardid: TEdit
        Left = 456
        Top = 48
        Width = 217
        Height = 21
        TabOrder = 8
      end
      object Button2: TButton
        Left = 704
        Top = 32
        Width = 75
        Height = 25
        Caption = #26597#35810
        TabOrder = 4
        OnClick = Button2Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'ETC'#40657#21517#21333#26597#35810
      ImageIndex = 2
      object DBGrid3: TDBGrid
        Left = 0
        Top = 88
        Width = 853
        Height = 330
        Align = alBottom
        DataSource = DS_etcblack
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CustomerID'
            Title.Alignment = taCenter
            Title.Caption = #23458#25143'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UserName'
            Title.Alignment = taCenter
            Title.Caption = #29992#25143#21517
            Width = 179
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CertificateID'
            Title.Alignment = taCenter
            Title.Caption = #35777#20214'ID'
            Width = 136
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PCardID'
            Title.Alignment = taCenter
            Title.Caption = 'ETC'#21345'ID'
            Width = 249
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BankCardID'
            Title.Alignment = taCenter
            Title.Caption = #38134#34892#21345'ID'
            Visible = True
          end
          item
            Alignment = taLeftJustify
            Expanded = False
            FieldName = 'BindingCardBlackCause'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CREATEDATE'
            Title.Alignment = taCenter
            Title.Caption = #19979#21457#26085#26399
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BANKID'
            Title.Alignment = taCenter
            Title.Caption = #38134#34892'ID'
            Visible = True
          end>
      end
      object chk_id: TCheckBox
        Left = 16
        Top = 24
        Width = 73
        Height = 17
        Caption = #35777#20214'ID'#65306
        TabOrder = 1
      end
      object edt_id: TEdit
        Left = 96
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object chk_edtid: TCheckBox
        Left = 224
        Top = 24
        Width = 73
        Height = 17
        Caption = 'ETC'#21345'ID'#65306
        TabOrder = 3
      end
      object EDT1_etcid: TEdit
        Left = 304
        Top = 24
        Width = 169
        Height = 21
        TabOrder = 4
      end
      object chk_bankid: TCheckBox
        Left = 488
        Top = 24
        Width = 97
        Height = 17
        Caption = #38134#34892#21345'ID'#65306
        TabOrder = 5
      end
      object edt_bankcardid1: TEdit
        Left = 568
        Top = 24
        Width = 169
        Height = 21
        TabOrder = 6
      end
      object Button3: TButton
        Left = 744
        Top = 24
        Width = 75
        Height = 25
        Caption = #26597#35810
        TabOrder = 7
        OnClick = Button3Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = #38134#34892#21345#40657#21517#21333#26597#35810
      ImageIndex = 3
      object CheckBox2: TCheckBox
        Left = 8
        Top = 24
        Width = 73
        Height = 17
        Caption = 'ETC'#21345'ID'#65306
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 88
        Top = 24
        Width = 169
        Height = 21
        TabOrder = 1
      end
      object Button4: TButton
        Left = 552
        Top = 24
        Width = 75
        Height = 25
        Caption = #26597#35810
        TabOrder = 2
        OnClick = Button4Click
      end
      object DBGrid4: TDBGrid
        Left = 0
        Top = 88
        Width = 853
        Height = 330
        Align = alBottom
        DataSource = DS_bankblack
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'VERNO'
            Title.Alignment = taCenter
            Title.Caption = #29256#26412#21495
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CARDNO'
            Title.Alignment = taCenter
            Title.Caption = #21345'NO'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CARDID'
            Title.Alignment = taCenter
            Title.Caption = 'ETC'#21345'ID'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'STARTTIME'
            Title.Alignment = taCenter
            Title.Caption = #36215#22987#26085#26399
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ENDTIME'
            Title.Alignment = taCenter
            Title.Caption = #32456#27490#26085#26399
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TRANSFERTAG'
            Title.Alignment = taCenter
            Visible = True
          end>
      end
    end
    object TabSheet5: TTabSheet
      Caption = #38134#34892#21345#21516'ETC'#32465#23450#26597#35810' '
      ImageIndex = 4
      object DBGrid5: TDBGrid
        Left = 0
        Top = 120
        Width = 853
        Height = 298
        Align = alBottom
        DataSource = DS_etcbank
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BankCardID'
            Title.Alignment = taCenter
            Title.Caption = #38134#34892#21345'ID'
            Width = 204
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'ETCCardID'
            Title.Alignment = taCenter
            Title.Caption = 'ETC'#21345'ID'
            Width = 199
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'NetWorkID'
            Title.Alignment = taCenter
            Title.Caption = #32593#32476'ID'
            Width = 75
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'TerminalID'
            Title.Alignment = taCenter
            Title.Caption = #32456#31471'ID'
            Width = 121
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BankID'
            Title.Alignment = taCenter
            Title.Caption = #38134#34892'ID'
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'CustomerID'
            Title.Alignment = taCenter
            Title.Caption = #25143'ID'
            Width = 171
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'UserType'
            Title.Alignment = taCenter
            Title.Caption = #29992#25143#29366#24577
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'UserName'
            Title.Alignment = taCenter
            Title.Caption = #29992#25143#21517
            Width = 162
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'CertificateID'
            Title.Alignment = taCenter
            Title.Caption = #35777#20214'ID'
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'PCardID'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'CardType'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'EntrustVerifyCode'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Vehplate'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'VehplateColor'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'VehType'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'VehSeatNum'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'WasteSN'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Optime'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'ResponseCode'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'ResponseDesc'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BankCardType'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BCertificateType'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BVCertificateID'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BUserName'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BindState'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'OperatorNO'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'OperatorName'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'ActiveDate'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BindStartTime'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BindEndTime'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'BindResult'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Spare1'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Spare2'
            Title.Alignment = taCenter
            Visible = True
          end>
      end
      object CheckBox1: TCheckBox
        Left = 32
        Top = 24
        Width = 97
        Height = 17
        Caption = 'ETC'#21345'ID'#65306
        TabOrder = 1
      end
      object Edit1: TEdit
        Left = 136
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'Edit1'
      end
      object CheckBox3: TCheckBox
        Left = 272
        Top = 24
        Width = 97
        Height = 17
        Caption = #38134#34892#21345'ID'#65306
        TabOrder = 3
      end
      object Edit3: TEdit
        Left = 352
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 4
        Text = 'Edit1'
      end
      object Button5: TButton
        Left = 704
        Top = 24
        Width = 75
        Height = 25
        Caption = #26597#35810' '
        TabOrder = 5
        OnClick = Button5Click
      end
      object CheckBox4: TCheckBox
        Left = 488
        Top = 24
        Width = 97
        Height = 17
        Caption = #29992#25143#21517
        TabOrder = 6
      end
      object Edit4: TEdit
        Left = 560
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 7
        Text = 'Edit4'
      end
    end
  end
  object DS_ETCLIST: TDataSource
    DataSet = ADO_ETCLIST
    Left = 44
    Top = 216
  end
  object ADO_ETCLIST: TADOQuery
    Connection = dmform.adocn
    Parameters = <>
    SQL.Strings = (
      'select * from ETCBoutToBankFile')
    Left = 44
    Top = 160
    object ADO_ETCLISTListNo: TStringField
      FieldName = 'ListNo'
      Size = 31
    end
    object ADO_ETCLISTYNok: TMemoField
      FieldName = 'YNok'
      BlobType = ftMemo
    end
    object ADO_ETCLISTFileName: TStringField
      FieldName = 'FileName'
      Size = 50
    end
    object ADO_ETCLISTExpInfo: TStringField
      FieldName = 'ExpInfo'
      Size = 50
    end
    object ADO_ETCLISTSpare1: TIntegerField
      FieldName = 'Spare1'
    end
    object ADO_ETCLISTspare2: TIntegerField
      FieldName = 'spare2'
    end
    object ADO_ETCLISTspare3: TIntegerField
      FieldName = 'spare3'
    end
    object ADO_ETCLISTSpare4: TIntegerField
      FieldName = 'Spare4'
    end
    object ADO_ETCLISTSpare5: TStringField
      FieldName = 'Spare5'
      Size = 500
    end
    object ADO_ETCLISTSpare6: TStringField
      FieldName = 'Spare6'
      Size = 500
    end
    object ADO_ETCLISTCreateTime: TDateTimeField
      FieldName = 'CreateTime'
    end
    object ADO_ETCLISTBalanceDate: TStringField
      FieldName = 'BalanceDate'
      Size = 8
    end
    object ADO_ETCLISTCustomerID: TStringField
      FieldName = 'CustomerID'
      Size = 50
    end
    object ADO_ETCLISTUserType: TIntegerField
      FieldName = 'UserType'
    end
    object ADO_ETCLISTUserName: TStringField
      FieldName = 'UserName'
      Size = 100
    end
    object ADO_ETCLISTBankCardID: TStringField
      FieldName = 'BankCardID'
      Size = 50
    end
    object ADO_ETCLISTETCCardID: TStringField
      FieldName = 'ETCCardID'
      Size = 50
    end
    object ADO_ETCLISTCardID: TStringField
      FieldName = 'CardID'
      Size = 30
    end
    object ADO_ETCLISTPCardNo: TStringField
      FieldName = 'PCardNo'
      Size = 30
    end
    object ADO_ETCLISTTotalToll: TIntegerField
      FieldName = 'TotalToll'
    end
    object ADO_ETCLISToptime: TStringField
      FieldName = 'optime'
      Size = 16
    end
    object ADO_ETCLISTbankid: TStringField
      FieldName = 'bankid'
      Size = 10
    end
  end
  object ADO_bank: TADOQuery
    Connection = dmform.adocn
    Parameters = <>
    SQL.Strings = (
      'select * from ETCBindCardDeductMoneyList_Bank')
    Left = 140
    Top = 160
    object ADO_bankBalanceDate: TIntegerField
      FieldName = 'BalanceDate'
    end
    object ADO_bankListNo: TStringField
      FieldName = 'ListNo'
      Size = 50
    end
    object ADO_bankBankID: TIntegerField
      FieldName = 'BankID'
    end
    object ADO_bankCustomerID: TStringField
      FieldName = 'CustomerID'
      Size = 50
    end
    object ADO_bankUserType: TIntegerField
      FieldName = 'UserType'
    end
    object ADO_bankUserName: TStringField
      FieldName = 'UserName'
      Size = 100
    end
    object ADO_bankPCardNetID: TStringField
      FieldName = 'PCardNetID'
    end
    object ADO_bankPCardID: TStringField
      FieldName = 'PCardID'
    end
    object ADO_bankBankCardID: TStringField
      FieldName = 'BankCardID'
      Size = 50
    end
    object ADO_bankAmount: TIntegerField
      FieldName = 'Amount'
    end
    object ADO_bankRemarks: TStringField
      FieldName = 'Remarks'
      Size = 50
    end
    object ADO_bankresult: TIntegerField
      FieldName = 'result'
    end
    object ADO_bankOpTime: TDateTimeField
      FieldName = 'OpTime'
    end
    object ADO_bankProcRlt: TIntegerField
      FieldName = 'ProcRlt'
    end
    object ADO_bankProcOperator: TStringField
      FieldName = 'ProcOperator'
    end
    object ADO_bankProcOperatorName: TStringField
      FieldName = 'ProcOperatorName'
      Size = 50
    end
    object ADO_bankProcOPTime: TIntegerField
      FieldName = 'ProcOPTime'
    end
    object ADO_bankProcDesc: TStringField
      FieldName = 'ProcDesc'
      Size = 50
    end
    object ADO_bankSpare1: TIntegerField
      FieldName = 'Spare1'
    end
    object ADO_bankSpare2: TStringField
      FieldName = 'Spare2'
      Size = 50
    end
  end
  object DS_BANK: TDataSource
    DataSet = ADO_bank
    Left = 140
    Top = 216
  end
  object DS_etcblack: TDataSource
    DataSet = ADO_etcblack
    Left = 252
    Top = 224
  end
  object ADO_etcblack: TADOQuery
    Connection = dmform.adocn
    Parameters = <>
    SQL.Strings = (
      'select * from PCardBlackList_bank')
    Left = 252
    Top = 160
    object ADO_etcblackCustomerID: TStringField
      FieldName = 'CustomerID'
    end
    object ADO_etcblackUserType: TStringField
      FieldName = 'UserType'
      Size = 2
    end
    object ADO_etcblackUserName: TStringField
      FieldName = 'UserName'
      Size = 100
    end
    object ADO_etcblackCertificateType: TStringField
      FieldName = 'CertificateType'
      Size = 2
    end
    object ADO_etcblackCertificateID: TStringField
      FieldName = 'CertificateID'
      Size = 30
    end
    object ADO_etcblackPCardID: TStringField
      FieldName = 'PCardID'
      Size = 60
    end
    object ADO_etcblackBankCardID: TStringField
      FieldName = 'BankCardID'
      Size = 32
    end
    object ADO_etcblackTranType: TIntegerField
      FieldName = 'TranType'
    end
    object ADO_etcblackBindingCardBlackCause: TIntegerField
      FieldName = 'BindingCardBlackCause'
    end
    object ADO_etcblackPCardNetID: TStringField
      FieldName = 'PCardNetID'
    end
    object ADO_etcblackCREATEDATE: TDateTimeField
      FieldName = 'CREATEDATE'
    end
    object ADO_etcblackBANKID: TStringField
      FieldName = 'BANKID'
      Size = 10
    end
  end
  object ADO_bankblack: TADOQuery
    Connection = dmform.adocn
    Parameters = <>
    SQL.Strings = (
      'select * from PCardBlackList')
    Left = 372
    Top = 152
    object ADO_bankblackVERNO: TIntegerField
      FieldName = 'VERNO'
    end
    object ADO_bankblackCARDNO: TStringField
      FieldName = 'CARDNO'
      Size = 30
    end
    object ADO_bankblackCARDID: TStringField
      FieldName = 'CARDID'
      Size = 30
    end
    object ADO_bankblackCARDTYPE: TIntegerField
      FieldName = 'CARDTYPE'
    end
    object ADO_bankblackBLACKTYPE: TIntegerField
      FieldName = 'BLACKTYPE'
    end
    object ADO_bankblackVALIDFLAG: TSmallintField
      FieldName = 'VALIDFLAG'
    end
    object ADO_bankblackSTARTTIME: TDateTimeField
      FieldName = 'STARTTIME'
    end
    object ADO_bankblackENDTIME: TDateTimeField
      FieldName = 'ENDTIME'
    end
    object ADO_bankblackSTATIONNO: TIntegerField
      FieldName = 'STATIONNO'
    end
    object ADO_bankblackREMARK: TStringField
      FieldName = 'REMARK'
      Size = 100
    end
    object ADO_bankblackSPARE1: TIntegerField
      FieldName = 'SPARE1'
    end
    object ADO_bankblackSPARE2: TStringField
      FieldName = 'SPARE2'
      Size = 50
    end
    object ADO_bankblackTRANSFERTAG: TIntegerField
      FieldName = 'TRANSFERTAG'
    end
  end
  object DS_bankblack: TDataSource
    DataSet = ADO_bankblack
    Left = 372
    Top = 224
  end
  object ADO_ectbank: TADOQuery
    Connection = dmform.adocn
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM ETCBankCardBindTab')
    Left = 492
    Top = 160
    object ADO_ectbankwasteNO: TStringField
      FieldName = 'wasteNO'
      Size = 100
    end
    object ADO_ectbankProcessDate: TStringField
      FieldName = 'ProcessDate'
      Size = 8
    end
    object ADO_ectbankProcessTime: TStringField
      FieldName = 'ProcessTime'
      Size = 6
    end
    object ADO_ectbankNetWorkID: TIntegerField
      FieldName = 'NetWorkID'
    end
    object ADO_ectbankTerminalID: TStringField
      FieldName = 'TerminalID'
      Size = 50
    end
    object ADO_ectbankBankID: TStringField
      FieldName = 'BankID'
      Size = 10
    end
    object ADO_ectbankCustomerID: TStringField
      FieldName = 'CustomerID'
      Size = 50
    end
    object ADO_ectbankUserType: TIntegerField
      FieldName = 'UserType'
    end
    object ADO_ectbankUserName: TStringField
      FieldName = 'UserName'
      Size = 100
    end
    object ADO_ectbankCertificateType: TIntegerField
      FieldName = 'CertificateType'
    end
    object ADO_ectbankCertificateID: TStringField
      FieldName = 'CertificateID'
      Size = 50
    end
    object ADO_ectbankPCardNetID: TStringField
      FieldName = 'PCardNetID'
      Size = 4
    end
    object ADO_ectbankPCardID: TStringField
      FieldName = 'PCardID'
      Size = 16
    end
    object ADO_ectbankETCCardID: TStringField
      FieldName = 'ETCCardID'
      Size = 50
    end
    object ADO_ectbankCardType: TIntegerField
      FieldName = 'CardType'
    end
    object ADO_ectbankEntrustVerifyCode: TStringField
      FieldName = 'EntrustVerifyCode'
      Size = 50
    end
    object ADO_ectbankVehplate: TStringField
      FieldName = 'Vehplate'
      Size = 50
    end
    object ADO_ectbankVehplateColor: TIntegerField
      FieldName = 'VehplateColor'
    end
    object ADO_ectbankVehType: TIntegerField
      FieldName = 'VehType'
    end
    object ADO_ectbankVehSeatNum: TIntegerField
      FieldName = 'VehSeatNum'
    end
    object ADO_ectbankWasteSN: TStringField
      FieldName = 'WasteSN'
      Size = 50
    end
    object ADO_ectbankOptime: TDateTimeField
      FieldName = 'Optime'
    end
    object ADO_ectbankResponseCode: TStringField
      FieldName = 'ResponseCode'
      Size = 50
    end
    object ADO_ectbankResponseDesc: TStringField
      FieldName = 'ResponseDesc'
      Size = 50
    end
    object ADO_ectbankBankCardType: TIntegerField
      FieldName = 'BankCardType'
    end
    object ADO_ectbankBankCardID: TStringField
      FieldName = 'BankCardID'
      Size = 50
    end
    object ADO_ectbankBCertificateType: TIntegerField
      FieldName = 'BCertificateType'
    end
    object ADO_ectbankBVCertificateID: TStringField
      FieldName = 'BVCertificateID'
      Size = 100
    end
    object ADO_ectbankBUserName: TStringField
      FieldName = 'BUserName'
      Size = 100
    end
    object ADO_ectbankBindState: TIntegerField
      FieldName = 'BindState'
    end
    object ADO_ectbankOperatorNO: TStringField
      FieldName = 'OperatorNO'
      Size = 30
    end
    object ADO_ectbankOperatorName: TStringField
      FieldName = 'OperatorName'
      Size = 100
    end
    object ADO_ectbankActiveDate: TStringField
      FieldName = 'ActiveDate'
      Size = 50
    end
    object ADO_ectbankBindStartTime: TDateTimeField
      FieldName = 'BindStartTime'
    end
    object ADO_ectbankBindEndTime: TDateTimeField
      FieldName = 'BindEndTime'
    end
    object ADO_ectbankBindResult: TIntegerField
      FieldName = 'BindResult'
    end
    object ADO_ectbankSpare1: TIntegerField
      FieldName = 'Spare1'
    end
    object ADO_ectbankSpare2: TStringField
      FieldName = 'Spare2'
      Size = 50
    end
  end
  object DS_etcbank: TDataSource
    DataSet = ADO_ectbank
    Left = 484
    Top = 224
  end
end
