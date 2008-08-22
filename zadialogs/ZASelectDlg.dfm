object SelectDialog: TSelectDialog
  Left = 199
  Top = 131
  Width = 415
  Height = 393
  ActiveControl = btnCancel
  BorderIcons = []
  Color = clBtnFace
  Constraints.MinHeight = 254
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    407
    366)
  PixelsPerInch = 96
  TextHeight = 13
  object Edit: TEdit
    Left = 8
    Top = 8
    Width = 301
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnChange = EditChange
    OnEnter = EditEnter
    OnExit = EditExit
  end
  object ListBox: TListBox
    Left = 8
    Top = 40
    Width = 301
    Height = 297
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = ListBoxDblClick
  end
  object btnSelect: TButton
    Left = 320
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 2
    OnClick = btnSelectClick
  end
  object btnCancel: TButton
    Left = 320
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 347
    Width = 407
    Height = 19
    Panels = <
      item
        Alignment = taRightJustify
        Bevel = pbNone
        Text = #1074#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081':'
        Width = 100
      end
      item
        Bevel = pbNone
        Width = 75
      end
      item
        Bevel = pbNone
        Width = 50
      end>
  end
end
