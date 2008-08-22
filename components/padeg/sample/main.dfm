object MainForm: TMainForm
  Left = 242
  Top = 114
  BorderStyle = bsDialog
  Caption = #1055#1088#1080#1084#1077#1088' '#1089#1082#1083#1086#1085#1077#1085#1080#1103' '#1060#1048#1054
  ClientHeight = 275
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lastNameLabel: TLabel
    Left = 160
    Top = 16
    Width = 49
    Height = 13
    Caption = #1060#1072#1084#1080#1083#1080#1103
    FocusControl = lastName
  end
  object firstNameLabel: TLabel
    Left = 160
    Top = 64
    Width = 22
    Height = 13
    Caption = #1048#1084#1103
    FocusControl = firstName
  end
  object middleNameLabel: TLabel
    Left = 160
    Top = 112
    Width = 47
    Height = 13
    Caption = #1054#1090#1095#1077#1089#1090#1074#1086
    FocusControl = middleName
  end
  object firstName: TEdit
    Left = 152
    Top = 80
    Width = 169
    Height = 21
    TabOrder = 2
    Text = #1048#1074#1072#1085
  end
  object lastName: TEdit
    Left = 152
    Top = 32
    Width = 169
    Height = 21
    TabOrder = 1
    Text = #1048#1074#1072#1085#1086#1074
  end
  object middleName: TEdit
    Left = 152
    Top = 128
    Width = 169
    Height = 21
    TabOrder = 3
    Text = #1048#1074#1072#1085#1086#1074#1080#1095
  end
  object rg: TRadioGroup
    Left = 16
    Top = 16
    Width = 121
    Height = 133
    Caption = #1055#1072#1076#1077#1078#1080
    ItemIndex = 0
    Items.Strings = (
      #1080#1084#1077#1085#1080#1090#1077#1083#1100#1085#1099#1081
      #1088#1086#1076#1080#1090#1077#1083#1100#1085#1099#1081
      #1076#1072#1090#1077#1083#1100#1085#1099#1081
      #1074#1080#1085#1080#1090#1077#1083#1100#1085#1099#1081' '
      #1090#1074#1086#1088#1080#1090#1077#1083#1100#1085#1099#1081
      #1087#1088#1077#1076#1083#1086#1078#1085#1099#1081)
    TabOrder = 0
  end
  object btnDeclension: TButton
    Left = 16
    Top = 169
    Width = 121
    Height = 25
    Caption = #1057#1082#1083#1086#1085#1103#1090#1100
    TabOrder = 5
    OnClick = btnDeclensionClick
  end
  object gb: TGroupBox
    Left = 16
    Top = 208
    Width = 305
    Height = 49
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1082#1083#1086#1085#1077#1085#1080#1103
    TabOrder = 6
    object declenResult: TEdit
      Left = 8
      Top = 18
      Width = 289
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
  end
  object rgSex: TRadioGroup
    Left = 152
    Top = 163
    Width = 169
    Height = 32
    Caption = #1055#1086#1083
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      #1084#1091#1078#1089#1082#1086#1081
      #1078#1077#1085#1089#1082#1080#1081)
    TabOrder = 4
  end
end
