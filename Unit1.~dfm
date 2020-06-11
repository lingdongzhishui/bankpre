object Form1: TForm1
  Left = 126
  Top = 47
  Width = 1022
  Height = 680
  Caption = 'ETC'#38134#34892#21069#32622#26381#21153#22120
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1006
    Height = 642
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 998
        Height = 541
        Align = alClient
        Caption = 'Panel2'
        TabOrder = 0
        object mmo1: TMemo
          Left = 1
          Top = 1
          Width = 996
          Height = 539
          Align = alClient
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
          Lines.Strings = (
            'mmo1')
          TabOrder = 0
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 541
        Width = 998
        Height = 73
        Align = alBottom
        TabOrder = 1
        object Button1: TButton
          Left = 832
          Top = 16
          Width = 81
          Height = 32
          Caption = #21551#29992
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 920
          Top = 16
          Width = 81
          Height = 32
          Caption = #20572#29992
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button4: TButton
          Left = 104
          Top = 23
          Width = 75
          Height = 25
          Caption = #21152#23494
          TabOrder = 2
          OnClick = Button4Click
        end
        object Button5: TButton
          Left = 200
          Top = 23
          Width = 75
          Height = 25
          Caption = #35299#23494
          TabOrder = 3
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 296
          Top = 23
          Width = 118
          Height = 25
          Caption = #25163#24037#35299#26512#23545#36134
          TabOrder = 4
          OnClick = Button6Click
        end
        object Button8: TButton
          Left = 656
          Top = 23
          Width = 75
          Height = 25
          Caption = #20449#24687#26597#35810
          TabOrder = 7
          OnClick = Button8Click
        end
        object Button3: TButton
          Left = 440
          Top = 23
          Width = 75
          Height = 25
          Caption = #27979#35797#27169#22359
          TabOrder = 5
          WordWrap = True
          OnClick = Button3Click
        end
        object Button7: TButton
          Left = 544
          Top = 23
          Width = 75
          Height = 25
          Caption = 'Getmd5'
          TabOrder = 6
          OnClick = Button7Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 558
        Width = 998
        Height = 56
        Align = alBottom
        Caption = 'Panel3'
        TabOrder = 1
        object Button9: TButton
          Left = 80
          Top = 8
          Width = 129
          Height = 25
          Caption = #25991#20214#29366#24577#26597#35810
          TabOrder = 0
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 998
        Height = 558
        Align = alClient
        Caption = 'Panel4'
        TabOrder = 0
        object DBGridEh1: TDBGridEh
          Left = 1
          Top = 37
          Width = 996
          Height = 520
          Align = alBottom
          Flat = False
          FooterColor = clWindow
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
        object Memo1: TMemo
          Left = 1
          Top = 1
          Width = 996
          Height = 36
          Align = alClient
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#20116#31508#36755#20837#27861
          Lines.Strings = (
            'Memo1')
          TabOrder = 0
        end
      end
    end
  end
  object idtcpsrvr1: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 6001
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = idtcpsrvr1Connect
    OnExecute = idtcpsrvr1Execute
    OnDisconnect = idtcpsrvr1Disconnect
    OnException = idtcpsrvr1Exception
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    TerminateWaitTime = 10000
    Left = 248
    Top = 56
  end
  object IdTCPClient1: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 30000
    BoundIP = '10.14.161.19'
    Host = '15.18.6.61'
    Port = 19170
    Left = 112
    Top = 88
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.txt|*.txt'
    InitialDir = '\ftpdir\detail'
    Left = 38
    Top = 470
  end
end
