object DateDlg: TDateDlg
  Left = 248
  Top = 107
  ActiveControl = MonthCalendar
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1072#1090#1091
  ClientHeight = 245
  ClientWidth = 191
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 15
    Top = 210
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 100
    Top = 210
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 191
    Height = 201
    Align = alTop
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clWindow
    TabOrder = 0
    object MonthCalendar: TMonthCalendar
      Left = 6
      Top = 7
      Width = 176
      Height = 183
      CalColors.TitleTextColor = clWindow
      CalColors.MonthBackColor = clWindow
      Date = 38295.629097581020000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
end
