object InputIntegerInterval: TInputIntegerInterval
  Left = 402
  Top = 297
  BorderStyle = bsDialog
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1080#1085#1090#1077#1088#1074#1072#1083
  ClientHeight = 122
  ClientWidth = 293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    293
    122)
  PixelsPerInch = 96
  TextHeight = 13
  object bvl1: TBevel
    Left = 0
    Top = 67
    Width = 293
    Height = 55
    Align = alBottom
    Shape = bsTopLine
  end
  object lblBegin: TLabel
    Left = 16
    Top = 16
    Width = 37
    Height = 13
    Caption = #1053#1072#1095#1072#1083#1086
  end
  object lblEnd: TLabel
    Left = 152
    Top = 16
    Width = 55
    Height = 13
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077
  end
  object edtBegin: TNumberEdit
    Left = 16
    Top = 32
    Width = 121
    Height = 21
    Anchors = [akBottom]
    TabOrder = 0
    OnChange = ChangeInterval
  end
  object edtEnd: TNumberEdit
    Left = 152
    Top = 32
    Width = 121
    Height = 21
    Anchors = [akBottom]
    TabOrder = 1
    OnChange = ChangeInterval
  end
  object btnOk: TButton
    Left = 62
    Top = 82
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = #1054#1050
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 152
    Top = 82
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
