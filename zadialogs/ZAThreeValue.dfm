object InputForm: TInputForm
  Left = 365
  Top = 234
  BorderStyle = bsDialog
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1079#1085#1072#1095#1077#1085#1080#1103
  ClientHeight = 187
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FirstLabel: TLabel
    Left = 15
    Top = 10
    Width = 88
    Height = 13
    Caption = #1055#1077#1088#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object SecondLabel: TLabel
    Left = 15
    Top = 55
    Width = 86
    Height = 13
    Caption = #1042#1090#1086#1088#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object ThirdLabel: TLabel
    Left = 15
    Top = 100
    Width = 86
    Height = 13
    Caption = #1058#1088#1077#1090#1100#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object FirstEdit: TEdit
    Left = 10
    Top = 25
    Width = 251
    Height = 21
    TabOrder = 0
    OnKeyDown = FirstEditKeyDown
  end
  object SecondEdit: TEdit
    Left = 10
    Top = 70
    Width = 251
    Height = 21
    TabOrder = 1
    OnKeyDown = FirstEditKeyDown
  end
  object ThirdEdit: TEdit
    Left = 10
    Top = 115
    Width = 251
    Height = 21
    TabOrder = 2
    OnKeyDown = FirstEditKeyDown
  end
  object btnOk: TButton
    Left = 60
    Top = 150
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 140
    Top = 150
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = btnCancelClick
  end
end
