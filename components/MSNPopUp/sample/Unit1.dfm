object Form1: TForm1
  Left = 356
  Top = 268
  Width = 334
  Height = 163
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
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Popup'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 8
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Destroy'
    TabOrder = 1
    OnClick = Button2Click
  end
  object MSNPopUp1: TMSNPopUp
    Text = #1053#1072' '#1089#1077#1088#1074#1077#1088#1077' '#1058#1102#1084#1043#1053#1043#1059' '#1080#1084#1077#1077#1090#1089#1103' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1086#1090#1076#1077#1083#1072' '#1082#1072#1076#1088#1086#1074
    URL = 'http://www.url.com/'
    GradientColor1 = 13395456
    GradientColor2 = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clBlue
    HoverFont.Height = -12
    HoverFont.Name = 'MS Sans Serif'
    HoverFont.Style = [fsUnderline]
    Title = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    TextCursor = crDefault
    PopupMarge = 5
    PopupStart = 5
    CascadePopups = True
    SystemFont = True
    DefaultMonitor = dmDesktop
    Left = 116
    Top = 52
  end
end
