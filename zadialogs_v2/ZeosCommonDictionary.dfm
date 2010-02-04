inherited ZeosCommonDictionaryDlg: TZeosCommonDictionaryDlg
  Left = 321
  Top = 239
  Width = 510
  Height = 328
  Caption = 'ZeosCommonDictionaryDlg'
  Constraints.MinHeight = 265
  Constraints.MinWidth = 250
  PixelsPerInch = 96
  TextHeight = 13
  object pnlRight: TPanel
    Left = 397
    Top = 0
    Width = 105
    Height = 282
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object pnlSelect: TPanel
      Left = 0
      Top = 0
      Width = 105
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      object btnSelect: TButton
        Left = 16
        Top = 16
        Width = 75
        Height = 25
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1080' '#1087#1077#1088#1077#1081#1090#1080' '#1082' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1084#1091' '#1076#1080#1072#1083#1086#1075#1091
        Caption = #1042#1099#1073#1088#1072#1090#1100
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 41
      Width = 105
      Height = 241
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pnlOther: TPanel
        Left = 0
        Top = 123
        Width = 105
        Height = 118
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        object btnCancel: TButton
          Left = 16
          Top = 69
          Width = 75
          Height = 25
          Hint = #1047#1072#1082#1088#1099#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
          Cancel = True
          Caption = #1047#1072#1082#1088#1099#1090#1100
          ModalResult = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object pnlEdit: TPanel
        Left = 0
        Top = 41
        Width = 105
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object btnEdit: TButton
          Left = 16
          Top = 16
          Width = 75
          Height = 25
          Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object pnlAdd: TPanel
        Left = 0
        Top = 0
        Width = 105
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btnAdd: TButton
          Left = 16
          Top = 16
          Width = 75
          Height = 25
          Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
      object pnlDelete: TPanel
        Left = 0
        Top = 82
        Width = 105
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object btnDelete: TButton
          Left = 16
          Top = 15
          Width = 75
          Height = 25
          Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 282
    Width = 502
    Height = 19
    Panels = <
      item
        Bevel = pbNone
        Width = 14
      end
      item
        Bevel = pbNone
        Width = 115
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
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 397
    Height = 282
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
end
