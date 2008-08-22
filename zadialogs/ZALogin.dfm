object LoginDlg: TLoginDlg
  Left = 330
  Top = 329
  ActiveControl = edtLogin
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077' '#1082' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 176
  ClientWidth = 277
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
  object LoginLabel: TLabel
    Left = 16
    Top = 52
    Width = 34
    Height = 13
    Caption = #1051#1086#1075#1080#1085':'
    FocusControl = edtLogin
  end
  object PasswordLabel: TLabel
    Left = 16
    Top = 85
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
    FocusControl = edtPassword
  end
  object Bevel: TBevel
    Left = 0
    Top = 120
    Width = 277
    Height = 56
    Align = alBottom
    Shape = bsTopLine
  end
  object btnOk: TButton
    Left = 104
    Top = 136
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 184
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object btnOptions: TButton
    Left = 16
    Top = 136
    Width = 75
    Height = 25
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
    TabOrder = 0
    OnClick = btnOptionsClick
  end
  object edtLogin: TEdit
    Left = 104
    Top = 48
    Width = 155
    Height = 21
    TabOrder = 3
    OnChange = changeLogin
  end
  object edtPassword: TEdit
    Left = 104
    Top = 80
    Width = 155
    Height = 23
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 4
  end
  object pnlOptions: TPanel
    Left = 16
    Top = 16
    Width = 243
    Height = 21
    BevelOuter = bvLowered
    TabOrder = 5
  end
end
