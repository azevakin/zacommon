unit ZAProgressDlg;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TProgressDlg = class(TForm)
    MainPanel: TPanel;
    ProgressBar: TProgressBar;
    btnCancel: TButton;
    lblPrompt: TLabel;
    lblCount: TLabel;
    procedure btnCancelClick(Sender: TObject);
  private
    FIsCancel: Boolean;
  public
    class function Execute(const Prompt: string; const Min, Max: Integer): TProgressDlg;

    procedure Init(const prompt: string; const min, max: Integer);
    procedure SetProgress(const position: Integer);
    procedure SetProgressWOcount(const position: Integer);

    property IsCancel: Boolean read FIsCancel;
  end;

const
  SPrepareData = 'Подготавливаются данные...';
  SPrepareReport = 'Формируется отчет...';

implementation

{$R *.dfm}

uses ZAApplicationUtils;

{ TProgressDlg }

procedure TProgressDlg.Init(const prompt: string; const min, max: Integer);
begin
  Application.ProcessMessages;

  lblPrompt.Caption := prompt;
  ProgressBar.Max := max;
  ProgressBar.Min := min;

  FIsCancel := False;

  if Self.Visible then
    Self.BringToFront
  else
    Self.Show;

  Application.ProcessMessages;
end;

procedure TProgressDlg.SetProgress(const position: Integer);
begin
  Application.ProcessMessages;
  ProgressBar.Position := position;
  lblCount.Caption := Format('%d из %d', [position, ProgressBar.Max]);
end;

procedure TProgressDlg.btnCancelClick(Sender: TObject);
begin
  if IsPositiveResult(CBox('Вы уверены?')) then
  begin
    FIsCancel := True;
    Hide;
  end;
end;

procedure TProgressDlg.SetProgressWOcount(const position: Integer);
begin
  Application.ProcessMessages;
  ProgressBar.Position := position;
  Application.ProcessMessages;
end;

class function TProgressDlg.Execute(const Prompt: string; const Min,
  Max: Integer): TProgressDlg;
begin
  Result := TProgressDlg.Create(nil);
  Result.Init(Prompt, Min, Max);
end;

end.




