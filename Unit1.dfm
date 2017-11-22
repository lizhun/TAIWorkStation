object Form1: TForm1
  Left = 925
  Top = 297
  Width = 917
  Height = 443
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmo1: TMemo
    Left = 136
    Top = 96
    Width = 737
    Height = 289
    Lines.Strings = (
      'mmo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btn4: TButton
    Left = 40
    Top = 24
    Width = 75
    Height = 25
    Caption = 'btnFromDb'
    TabOrder = 1
    OnClick = btn4Click
  end
  object lbledtpatid: TLabeledEdit
    Left = 136
    Top = 64
    Width = 121
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = 'lbledtpatid'
    TabOrder = 2
  end
  object lbledtimageId: TLabeledEdit
    Left = 280
    Top = 64
    Width = 121
    Height = 21
    EditLabel.Width = 62
    EditLabel.Height = 13
    EditLabel.Caption = 'lbledtimageId'
    TabOrder = 3
  end
  object lbledtDBase: TLabeledEdit
    Left = 136
    Top = 16
    Width = 705
    Height = 21
    EditLabel.Width = 57
    EditLabel.Height = 13
    EditLabel.Caption = 'lbledtDBase'
    TabOrder = 4
    Text = 
      'Provider=SQLNCLI11.1;User ID=demo;Password=demo;Initial Catalog=' +
      'test;Data Source=192.168.1.25;'
  end
  object lbledtimgLocalRootPath: TLabeledEdit
    Left = 424
    Top = 64
    Width = 169
    Height = 21
    EditLabel.Width = 112
    EditLabel.Height = 13
    EditLabel.Caption = 'lbledtimgLocalRootPath'
    TabOrder = 5
  end
  object lbledtimgServerRootPath: TLabeledEdit
    Left = 624
    Top = 64
    Width = 145
    Height = 21
    EditLabel.Width = 117
    EditLabel.Height = 13
    EditLabel.Caption = 'lbledtimgServerRootPath'
    TabOrder = 6
  end
  object idhtp1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 96
    Top = 328
  end
  object idcdrm1: TIdDecoderMIME
    FillChar = '='
    Left = 32
    Top = 328
  end
  object idncdrm1: TIdEncoderMIME
    FillChar = '='
    Left = 64
    Top = 328
  end
  object con1: TADOConnection
    Provider = 'SQLNCLI11.1'
    Left = 80
    Top = 248
  end
end
