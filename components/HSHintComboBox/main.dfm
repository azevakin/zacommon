object Form1: TForm1
  Left = 185
  Top = 107
  Width = 544
  Height = 375
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbCoord: TLabel
    Left = 152
    Top = 20
    Width = 77
    Height = 13
    AutoSize = False
  end
  object ComboBox: TComboBox
    Left = 20
    Top = 16
    Width = 125
    Height = 21
    Hint = '��� ������ ��������� ��� ComboBox'
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    Items.Strings = (
      '������ 1'
      '������ ������� ������ � ComboBox'
      '������ 3'
      '������ ����� ������� ������ � ComboBox'
      '������� ������ � ComboBox')
  end
  object ListBox: TListBox
    Left = 232
    Top = 12
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 1
  end
end
