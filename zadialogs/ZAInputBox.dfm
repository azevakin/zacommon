object InputDlg: TInputDlg
  Left = 246
  Top = 232
  BorderStyle = bsDialog
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
  ClientHeight = 107
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    266
    107)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrompt: TLabel
    Left = 8
    Top = 8
    Width = 43
    Height = 13
    Caption = 'lblPrompt'
  end
  object bvlBottom: TBevel
    Left = 0
    Top = 56
    Width = 266
    Height = 51
    Align = alBottom
    Shape = bsTopLine
  end
  object edtValue: TEdit
    Left = 8
    Top = 24
    Width = 217
    Height = 21
    TabOrder = 0
    OnChange = edtValueChange
    OnEnter = edtValueEnter
  end
  object btnOk: TButton
    Left = 102
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 182
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object btnShowMemo: TButton
    Left = 232
    Top = 24
    Width = 25
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = btnShowMemoClick
  end
  object mmoValue: TMemo
    Left = 8
    Top = 48
    Width = 249
    Height = 49
    TabOrder = 2
    Visible = False
    WantReturns = False
    OnEnter = mmoValueEnter
    OnExit = mmoValueExit
    OnKeyDown = mmoValueKeyDown
  end
end
