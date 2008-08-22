object MainForm: TMainForm
  Left = 405
  Top = 306
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
  ClientHeight = 210
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  DesignSize = (
    410
    210)
  PixelsPerInch = 96
  TextHeight = 13
  object lvValues: TListView
    Left = 16
    Top = 16
    Width = 377
    Height = 153
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    BevelOuter = bvRaised
    Columns = <
      item
        Width = 290
      end
      item
        Width = 60
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ShowColumnHeaders = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object pb: TProgressBar
    Left = 16
    Top = 176
    Width = 377
    Height = 16
    Anchors = [akLeft, akRight, akBottom]
    Step = 1
    TabOrder = 1
  end
end
