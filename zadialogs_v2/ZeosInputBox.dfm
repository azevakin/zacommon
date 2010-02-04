inherited InputBox: TInputBox
  ActiveControl = edtValue
  Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
  ClientHeight = 117
  ClientWidth = 330
  PixelsPerInch = 96
  TextHeight = 13
  object bvl1: TBevel [0]
    Left = 0
    Top = 64
    Width = 330
    Height = 53
    Align = alBottom
    Shape = bsTopLine
  end
  inherited btnOk: TButton
    Left = 154
    Top = 78
    OnClick = btnOkClick
  end
  inherited btnCancel: TButton
    Left = 240
    Top = 78
  end
  object edtValue: TLabeledEdit
    Left = 16
    Top = 28
    Width = 299
    Height = 21
    Anchors = [akTop, akRight]
    EditLabel.Width = 59
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1086#1076#1089#1082#1072#1079#1082#1072':'
    LabelSpacing = 4
    TabOrder = 2
    OnChange = edtValueChange
  end
end
