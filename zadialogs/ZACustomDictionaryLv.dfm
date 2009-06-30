inherited CustomDictionaryLvDlg: TCustomDictionaryLvDlg
  Left = 377
  Top = 316
  Caption = 'CustomDictionaryLvDlg'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlRight: TPanel
    inherited pnlButtons: TPanel
      inherited pnlOther: TPanel
        inherited btnCancel: TButton
          Top = 29
        end
      end
    end
  end
  inherited pnlLeft: TPanel
    object pnlValues: TPanel
      Left = 0
      Top = 0
      Width = 397
      Height = 282
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        397
        282)
      object lvValues: TListView
        Left = 16
        Top = 16
        Width = 381
        Height = 266
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <>
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvValuesChange
        OnDblClick = lvValuesDblClick
        OnMouseDown = lvValuesMouseDown
      end
    end
  end
end
