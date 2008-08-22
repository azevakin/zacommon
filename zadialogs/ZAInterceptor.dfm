object InterceptionDlg: TInterceptionDlg
  Left = 364
  Top = 289
  BorderStyle = bsDialog
  Caption = #1057#1077#1090#1077#1074#1099#1077' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
  ClientHeight = 92
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    360
    92)
  PixelsPerInch = 96
  TextHeight = 13
  object lblMessage: TLabel
    Left = 10
    Top = 10
    Width = 339
    Height = 38
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object btnConnect: TButton
    Left = 13
    Top = 60
    Width = 174
    Height = 25
    Default = True
    TabOrder = 0
    OnClick = btnConnectClick
  end
  object btnCancel: TButton
    Left = 193
    Top = 60
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object btnExit: TButton
    Left = 275
    Top = 60
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = btnExitClick
  end
end
