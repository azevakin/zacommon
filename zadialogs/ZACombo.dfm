inherited ComboDlg: TComboDlg
  Left = 394
  Top = 360
  BorderStyle = bsDialog
  ClientHeight = 110
  ClientWidth = 403
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object gbValues: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 49
    TabOrder = 0
    object cbValues: TComboBox
      Left = 8
      Top = 16
      Width = 369
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbValuesChange
    end
  end
  object btnOk: TButton
    Left = 120
    Top = 72
    Width = 75
    Height = 25
    Caption = #1054#1050
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 208
    Top = 72
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
