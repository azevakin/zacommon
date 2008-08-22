object ChangePassword: TChangePassword
  Left = 247
  Top = 107
  BorderStyle = bsDialog
  Caption = #1057#1084#1077#1085#1072' '#1087#1072#1088#1086#1083#1103
  ClientHeight = 207
  ClientWidth = 373
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
  object GroupBox1: TGroupBox
    Left = 10
    Top = 10
    Width = 351
    Height = 146
    TabOrder = 0
    object Label1: TLabel
      Left = 25
      Top = 32
      Width = 100
      Height = 17
      AutoSize = False
      Caption = #1057#1090#1072#1088#1099#1081' '#1087#1072#1088#1086#1083#1100
      FocusControl = edOldPwd
    end
    object Label2: TLabel
      Left = 25
      Top = 67
      Width = 100
      Height = 17
      AutoSize = False
      Caption = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
      FocusControl = edNewPwd
    end
    object Label3: TLabel
      Left = 25
      Top = 102
      Width = 100
      Height = 17
      AutoSize = False
      Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
      FocusControl = edConfirmPwd
    end
    object edOldPwd: TEdit
      Left = 140
      Top = 30
      Width = 191
      Height = 21
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1089#1090#1072#1088#1099#1081' '#1087#1072#1088#1086#1083#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 0
      OnChange = edOldPwdChange
    end
    object edNewPwd: TEdit
      Left = 140
      Top = 65
      Width = 191
      Height = 21
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
      Enabled = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 1
      OnChange = edNewPwdChange
    end
    object edConfirmPwd: TEdit
      Left = 140
      Top = 100
      Width = 191
      Height = 21
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100' '#1077#1097#1077' '#1088#1072#1079
      Enabled = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 2
      OnChange = edNewPwdChange
    end
  end
  object OkButton: TButton
    Left = 170
    Top = 170
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = OkButtonClick
  end
  object CancelButton: TButton
    Left = 250
    Top = 170
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
