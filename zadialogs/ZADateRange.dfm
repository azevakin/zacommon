object DateRangeDlg: TDateRangeDlg
  Left = 328
  Top = 219
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1080#1072#1087#1072#1079#1086#1085' '#1076#1072#1090
  ClientHeight = 119
  ClientWidth = 255
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    255
    119)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 17
    Width = 9
    Height = 16
    Caption = #1089
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 125
    Top = 17
    Width = 19
    Height = 16
    Caption = #1087#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 0
    Top = 69
    Width = 255
    Height = 50
    Align = alBottom
    Shape = bsTopLine
  end
  object dpBegin: TDateTimePicker
    Left = 25
    Top = 15
    Width = 91
    Height = 21
    Date = 38341.696162650460000000
    Time = 38341.696162650460000000
    TabOrder = 0
  end
  object dpEnd: TDateTimePicker
    Left = 150
    Top = 15
    Width = 91
    Height = 21
    Date = 38341.696162650460000000
    Time = 38341.696162650460000000
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 85
    Top = 82
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 165
    Top = 82
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object chAll: TCheckBox
    Left = 150
    Top = 40
    Width = 91
    Height = 17
    Alignment = taLeftJustify
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
end
