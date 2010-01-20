inherited DictionaryLvDlg: TDictionaryLvDlg
  Caption = 'DictionaryLvDlg'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlLeft: TPanel
    inherited pnlValues: TPanel
      Top = 41
      Height = 241
      TabOrder = 1
      DesignSize = (
        397
        241)
      inherited lvValues: TListView
        Height = 225
      end
    end
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
        OnKeyDown = edtSearchKeyDown
      end
    end
  end
end
