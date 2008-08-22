unit ZAInterceptor;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ZConnect,
  ZAPgSqlForm;

type
  TInterceptionDlg = class(TForm)
    lblMessage: TLabel;
    btnConnect: TButton;
    btnCancel: TButton;
    btnExit: TButton;
    procedure btnConnectClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    FIndicator: Byte;
    FCountAttempt: Byte;
    FDataBase: TZDatabase;
    procedure InterceptionConnect;
    procedure SetBtnCaption;
    procedure TimerProc(var Param: PMsg); message WM_TIMER;
  protected
    procedure DoCreate; override;
    procedure DoDestroy; override;
    procedure DoShow; override;
  public
    property DataBase: TZDatabase read FDataBase write FDataBase;
  end;

function InterceptionDlg(db: TZDatabase): Boolean;

implementation

{$R *.dfm}

const
  Interval = 10;
  ServerNotAnswer = 'Ошибка: Сервер PostgreSql не отвечает.';
  UnknownHostname = 'Ошибка: Сервер PostgreSql недоступен.'#13 +
    'Обратитесь в центр поддержки за помощью';

procedure TInterceptionDlg.InterceptionConnect;
begin
  try
    FIndicator := Interval;
    Inc(FCountAttempt);
    Database.Connect;
    if Database.Connected then
    begin
      ModalResult := mrOk;
    end;
  except
    case FCountAttempt of
      1:
        begin
          Caption := 'Ошибка подключения';
          Update;
          lblMessage.Caption := ServerNotAnswer;
          lblMessage.Update;
        end;
      2,3,4:
        begin
          lblMessage.Caption := ServerNotAnswer;
          lblMessage.Update;
        end;
      5:
        begin
          Application.MessageBox(UnknownHostname, nil, MB_ICONERROR or MB_OK);
          btnExitClick(Self);
        end;
    end;
  end;
end;

procedure TInterceptionDlg.btnConnectClick(Sender: TObject);
begin
  InterceptionConnect;
end;

procedure TInterceptionDlg.SetBtnCaption;
begin
  btnConnect.Caption := Format('П&овторное подключение = %d', [FIndicator]);
  btnConnect.Update;
end;

function InterceptionDlg(db: TZDatabase): Boolean;
begin
  with TInterceptionDlg.Create(Application) do
  try
    DataBase := db;

    if Assigned(DataBase) then
      Database.Disconnect;

    Result := IsPositiveResult(ShowModal);
  finally
    Free;
  end;
end;

procedure TInterceptionDlg.btnExitClick(Sender: TObject);
begin
  Application.MainForm.Close;
end;

procedure TInterceptionDlg.DoCreate;
begin
  inherited DoCreate;

  FIndicator := Interval;
  FCountAttempt := 0;

  SetBtnCaption;
  lblMessage.Caption := 'Неудалось связаться с сервером PostgreSql.'#13 +
    'Ожидается повторное подключение...';
end;

procedure TInterceptionDlg.DoDestroy;
begin
  KillTimer(Handle, 0);
  inherited DoDestroy;
end;

procedure TInterceptionDlg.DoShow;
begin
  SetTimer(Handle, 0, 1200, nil);
  inherited DoShow;
end;

procedure TInterceptionDlg.TimerProc(var Param: PMsg);
begin
  Application.ProcessMessages;
  SetBtnCaption;
  Dec(FIndicator);
  if FIndicator = 0 then
    InterceptionConnect;
end;

end.

