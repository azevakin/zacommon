unit ZAProgressDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TProgressDlg = class(TForm)
    MainPanel: TPanel;
    ProgressBar: TProgressBar;
    btnCancel: TButton;
    lblPrompt: TLabel;
    lblCount: TLabel;
    procedure btnCancelClick(Sender: TObject);
  private
    fIsCancel: Boolean;
  public
    procedure init(const prompt: string; const min, max: Integer);
    procedure setProgress(const position: Integer);
    procedure SetProgressWOcount(const position: Integer);

    property isCancel: Boolean read fIsCancel;
  end;

const
  SPrepareData = 'Подготавливаются данные...';
  SPrepareReport = 'Формируется отчет...';

implementation

{$R *.dfm}

uses ZAApplicationUtils;

{ TProgressDlg }

procedure TProgressDlg.init(const prompt: string; const min, max: Integer);
begin
  Application.ProcessMessages;

  lblPrompt.Caption := prompt;
  ProgressBar.Min := min;
  ProgressBar.Max := max;

  fIsCancel := False;

  if Self.Visible then
    Self.BringToFront
  else
    Self.Show;

  Application.ProcessMessages;
end;

procedure TProgressDlg.setProgress(const position: Integer);
begin
  Application.ProcessMessages;
  ProgressBar.Position := position;
  lblCount.Caption := Format('%d из %d', [position, ProgressBar.Max]);
end;

procedure TProgressDlg.btnCancelClick(Sender: TObject);
begin
  if IsPositiveResult(CBox('Вы уверены?')) then
  begin
    fIsCancel := True;
    Hide;
  end;
end;

procedure TProgressDlg.SetProgressWOcount(const position: Integer);
begin
  Application.ProcessMessages;
  ProgressBar.Position := position;
  Application.ProcessMessages;
end;

end.




