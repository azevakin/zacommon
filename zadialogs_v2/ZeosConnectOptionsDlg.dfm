object ConnectOptionsDlg: TConnectOptionsDlg
  Left = 270
  Top = 206
  ActiveControl = edtHostName
  BorderStyle = bsDialog
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
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
  object HostLabel: TLabel
    Left = 16
    Top = 8
    Width = 67
    Height = 13
    Caption = #1048#1084#1103' '#1089#1077#1088#1074#1077#1088#1072
    FocusControl = edtHostName
  end
  object DatabaseLabel: TLabel
    Left = 16
    Top = 64
    Width = 65
    Height = 13
    Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
    FocusControl = edtDatabase
  end
  object PortLabel: TLabel
    Left = 204
    Top = 64
    Width = 25
    Height = 13
    Caption = #1055#1086#1088#1090
    FocusControl = edtPort
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
    TabOrder = 0
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
    TabOrder = 1
  end
  object edtHostName: TEdit
    Left = 16
    Top = 24
    Width = 241
    Height = 21
    TabOrder = 2
    OnChange = ChangeOptions
  end
  object edtDatabase: TEdit
    Left = 16
    Top = 80
    Width = 177
    Height = 21
    TabOrder = 3
    OnChange = ChangeOptions
  end
  object edtPort: TSpinEdit
    Left = 204
    Top = 80
    Width = 53
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 5432
  end
end
