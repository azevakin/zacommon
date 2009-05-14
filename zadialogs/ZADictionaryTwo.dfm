inherited DictionaryTwoDlg: TDictionaryTwoDlg
  Caption = ''
  Constraints.MinWidth = 315
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlRight: TPanel
    inherited pnlSelect: TPanel
      inherited btnSelect: TButton
        OnClick = btnSelectClick
      end
    end
    inherited pnlButtons: TPanel
      inherited pnlEdit: TPanel
        inherited btnEdit: TButton
          OnClick = btnEditClick
        end
      end
      inherited pnlAdd: TPanel
        inherited btnAdd: TButton
          OnClick = btnAddClick
        end
      end
      inherited pnlDelete: TPanel
        inherited btnDelete: TButton
          OnClick = btnDeleteClick
        end
      end
    end
  end
  inherited pnlLeft: TPanel
    inherited pnlValues: TPanel
      inherited lvValues: TListView
        Columns = <
          item
            AutoSize = True
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            MinWidth = 100
          end
          item
            AutoSize = True
            Caption = #1057#1086#1082#1088#1072#1097#1077#1085#1080#1077
            MinWidth = 80
          end>
        OnDeletion = lvValuesDeletion
      end
    end
  end
end
