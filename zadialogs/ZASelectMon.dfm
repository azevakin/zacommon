object SelectMonthDlg: TSelectMonthDlg
  Left = 357
  Top = 313
  ActiveControl = seYear
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1084#1077#1089#1103#1094
  ClientHeight = 363
  ClientWidth = 162
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 12
    Width = 21
    Height = 13
    Caption = #1043#1086#1076':'
    FocusControl = seYear
  end
  object rgMon: TRadioGroup
    Left = 8
    Top = 40
    Width = 145
    Height = 281
    Caption = #1052#1077#1089#1103#1094#1099
    ItemIndex = 0
    Items.Strings = (
      #1042#1077#1089#1100' '#1075#1086#1076
      #1071#1085#1074#1072#1088#1100
      #1060#1077#1074#1088#1072#1083#1100
      #1052#1072#1088#1090
      #1040#1087#1088#1077#1083#1100
      #1052#1072#1081
      #1048#1102#1085#1100
      #1048#1102#1083#1100
      #1040#1074#1075#1091#1089#1090
      #1057#1077#1085#1090#1103#1073#1088#1100
      #1054#1082#1090#1103#1073#1088#1100
      #1053#1086#1103#1073#1088#1100
      #1044#1077#1082#1072#1073#1088#1100)
    TabOrder = 1
  end
  object btn1: TButton
    Left = 8
    Top = 328
    Width = 65
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btn2: TButton
    Left = 78
    Top = 328
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object seYear: TSpinEdit
    Left = 56
    Top = 8
    Width = 97
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
end
