object ProgressDlg: TProgressDlg
  Left = 339
  Top = 348
  BorderStyle = bsNone
  ClientHeight = 102
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 350
    Height = 102
    Align = alClient
    TabOrder = 0
    object lblPrompt: TLabel
      Left = 20
      Top = 15
      Width = 311
      Height = 13
      AutoSize = False
      Caption = 'Prompt'
    end
    object lblCount: TLabel
      Left = 20
      Top = 60
      Width = 3
      Height = 13
      Transparent = True
    end
    object ProgressBar: TProgressBar
      Left = 20
      Top = 35
      Width = 311
      Height = 16
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 255
      Top = 60
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
