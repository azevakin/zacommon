object UpdaterOptionsDlg: TUpdaterOptionsDlg
  Left = 462
  Top = 224
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1082' FTP '#1089#1077#1088#1074#1077#1088#1091
  ClientHeight = 293
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 12
    Width = 62
    Height = 13
    Caption = 'FTP '#1089#1077#1088#1074#1077#1088':'
  end
  object lbl2: TLabel
    Left = 280
    Top = 12
    Width = 28
    Height = 13
    Caption = #1055#1086#1088#1090':'
  end
  object lbl3: TLabel
    Left = 8
    Top = 68
    Width = 145
    Height = 13
    Caption = #1044#1080#1088#1077#1082#1090#1086#1088#1080#1103' '#1089' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077#1084':'
  end
  object lbl4: TLabel
    Left = 8
    Top = 124
    Width = 192
    Height = 13
    Caption = #1060#1072#1081#1083' '#1089' '#1080#1085#1089#1090#1088#1091#1082#1094#1080#1077#1081' '#1076#1083#1103' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103':'
  end
  object bvlMain: TBevel
    Left = 8
    Top = 232
    Width = 313
    Height = 9
    Shape = bsBottomLine
  end
  object lbl5: TLabel
    Left = 8
    Top = 180
    Width = 34
    Height = 13
    Caption = #1051#1086#1075#1080#1085':'
  end
  object lbl6: TLabel
    Left = 176
    Top = 180
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object edtHost: TEdit
    Left = 8
    Top = 32
    Width = 257
    Height = 21
    TabOrder = 0
  end
  object edtPort: TNumberEdit
    Left = 280
    Top = 32
    Width = 41
    Height = 21
    TabOrder = 1
  end
  object edtDir: TEdit
    Left = 8
    Top = 88
    Width = 313
    Height = 21
    TabOrder = 2
  end
  object edtFile: TEdit
    Left = 8
    Top = 144
    Width = 313
    Height = 21
    TabOrder = 3
  end
  object btnOk: TButton
    Left = 86
    Top = 256
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 6
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 176
    Top = 256
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
  object edtLogin: TEdit
    Left = 8
    Top = 200
    Width = 153
    Height = 21
    TabOrder = 4
  end
  object edtPassword: TEdit
    Left = 176
    Top = 200
    Width = 145
    Height = 21
    AutoSize = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 5
  end
end
