object Form1: TForm1
  Left = 248
  Top = 309
  Width = 917
  Height = 445
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
  object btn1: TButton
    Left = 72
    Top = 40
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 0
  end
  object btn2: TButton
    Left = 72
    Top = 96
    Width = 75
    Height = 25
    Caption = 'btn2'
    TabOrder = 1
  end
  object mmo1: TMemo
    Left = 216
    Top = 56
    Width = 657
    Height = 329
    Lines.Strings = (
      'mmo1')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object btn3: TButton
    Left = 64
    Top = 144
    Width = 75
    Height = 25
    Caption = 'btn3'
    TabOrder = 3
    OnClick = btn3Click
  end
  object btn4: TButton
    Left = 56
    Top = 192
    Width = 75
    Height = 25
    Caption = 'btnFromDb'
    TabOrder = 4
    OnClick = btn4Click
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
    Left = 320
    Top = 8
  end
  object idcdrm1: TIdDecoderMIME
    FillChar = '='
    Left = 240
    Top = 16
  end
  object idncdrm1: TIdEncoderMIME
    FillChar = '='
    Left = 288
    Top = 16
  end
  object con1: TADOConnection
    Provider = 'SQLNCLI11.1'
    Left = 80
    Top = 248
  end
end
