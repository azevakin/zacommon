inherited DictionaryDlg: TDictionaryDlg
  ActiveControl = nil
  BorderIcons = [biSystemMenu]
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited ListBox: TListBox
    Height = 299
  end
  inherited btnSelect: TButton
    Visible = False
  end
  inherited btnCancel: TButton
    Top = 314
    TabOrder = 6
  end
  object btnInsert: TButton
    Left = 320
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 3
    OnClick = btnInsertClick
  end
  object btnUpdate: TButton
    Left = 320
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 4
    OnClick = btnUpdateClick
  end
  object btnDelete: TButton
    Left = 320
    Top = 104
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 5
    OnClick = btnDeleteClick
  end
end
