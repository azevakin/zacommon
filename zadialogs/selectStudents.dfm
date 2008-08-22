object SelectStudentsDlg: TSelectStudentsDlg
  Left = 378
  Top = 334
  AutoScroll = False
  ClientHeight = 252
  ClientWidth = 495
  Color = clBtnFace
  Constraints.MinHeight = 255
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    495
    252)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel: TBevel
    Left = 0
    Top = 198
    Width = 495
    Height = 54
    Align = alBottom
    Shape = bsTopLine
  end
  object prompt: TLabel
    Left = 8
    Top = 8
    Width = 479
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1090#1091#1076#1077#1085#1090#1086#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object doSubmit: TButton
    Left = 322
    Top = 213
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1044#1072#1083#1077#1077
    TabOrder = 0
  end
  object doClose: TButton
    Left = 402
    Top = 213
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 2
    TabOrder = 1
  end
  object listView: TCoolListView
    Left = 8
    Top = 48
    Width = 479
    Height = 135
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        MaxWidth = 20
        MinWidth = 20
        Width = 20
      end
      item
        AutoSize = True
        Caption = #1060#1072#1084#1080#1083#1080#1103
      end
      item
        AutoSize = True
        Caption = #1048#1084#1103
      end
      item
        AutoSize = True
        Caption = #1054#1090#1095#1077#1089#1090#1074#1086
      end
      item
        AutoSize = True
        Caption = #1043#1088#1091#1087#1087#1072
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
  end
end
