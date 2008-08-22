inherited DictionaryLvDlg: TDictionaryLvDlg
  Left = 377
  Top = 316
  Caption = 'DictionaryLvDlg'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlLeft: TPanel
    object pnlSearch: TPanel
      Left = 0
      Top = 0
      Width = 397
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        397
        41)
      object lblSearch: TLabel
        Left = 16
        Top = 20
        Width = 35
        Height = 13
        Caption = #1055#1086#1080#1089#1082':'
        FocusControl = edtSearch
      end
      object edtSearch: TEdit
        Left = 68
        Top = 16
        Width = 329
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = edtSearchChange
      end
    end
    object pnlValues: TPanel
      Left = 0
      Top = 41
      Width = 397
      Height = 241
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        397
        241)
      object lvValues: TListView
        Left = 16
        Top = 16
        Width = 381
        Height = 218
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = lvValuesDblClick
        OnMouseDown = lvValuesMouseDown
      end
    end
  end
end
