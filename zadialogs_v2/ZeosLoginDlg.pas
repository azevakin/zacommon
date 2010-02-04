unit ZeosLoginDlg;

interface

uses
  Classes, Controls, Forms, ZeosCommonForm, ZeosCommonDialog, StdCtrls, ExtCtrls;

type
  TLoginDlg = class(TZeosCommonDlg)
    btnOk: TButton;
    btnCancel: TButton;
    btnOptions: TButton;
    LoginLabel: TLabel;
    PasswordLabel: TLabel;
    edtLogin: TEdit;
    edtPassword: TEdit;
    pnlOptions: TPanel;
    Bevel: TBevel;
    procedure edtLoginChange(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    ConnectOptions: TConnectOptions;
    procedure Connect;
  protected
    procedure DoShow; override;
    procedure SetConnection(const AConnection: TZConnection); override;
  public
    class function Execute(const AConnection: TZConnection): Boolean; overload;
  end;

implementation

uses ZeosConnectOptionsDlg, SysUtils;

{$R *.dfm}

{ TLoginDlg }

procedure TLoginDlg.SetConnection(const AConnection: TZConnection);
begin
  inherited SetConnection(AConnection);

  if not Assigned(ConnectOptions) then
    ConnectOptions := TConnectOptions.Create(Self, Connection)
  else
    ConnectOptions.Connection := Connection;
end;

procedure TLoginDlg.Connect;
begin
  try
    Connection.Connect;
  except
    on e: Exception do
    begin
      if eHasText(e, 'user') and eHasText(e, 'does not exist') then
      begin
        edtLogin.SetFocus;
        raise Exception.CreateFmt('ОШИБКА: Пользователь "%s" не существует', [
          Connection.User]);
      end;

      if eHasText(e, 'no password supplied') then
      begin
        edtPassword.SetFocus;
        raise Exception.Create('ОШИБКА: Необходимо ввести пароль');
      end;

      if eHasText(e, 'Password authentication failed for user') then
      begin
        edtPassword.SetFocus;
        raise Exception.Create('ОШИБКА: Введен неверный пароль');
      end;

      if eHasText(e, 'unknown hostname') or eHasText(e, 'unknown host') then
        raise Exception.Create('ОШИБКА: Задано неверное имя сервера, либо сервер недоступен');

      if eHasText(e, 'connectDBStart() -- connect() failed:') then
        raise Exception.Create('ОШИБКА: Сервер в данный момент недоступен');

      raise Exception.Create(e.Message);
    end;
  end;
end;

procedure TLoginDlg.DoShow;
begin
  if ConnectOptions.LoadOptions(True) then
    pnlOptions.Caption := getConnectOptions
  else
    btnOptions.Click;

  edtLogin.Text := Connection.User;
  if edtLogin.Text <> '' then
    edtPassword.SetFocus;

  inherited doShow;
end;

procedure TLoginDlg.edtLoginChange(Sender: TObject);
begin
  btnOk.Enabled := (Sender as TEdit).Text <> '';
end;

procedure TLoginDlg.btnOptionsClick(Sender: TObject);
begin
  if TConnectOptionsDlg.Execute(Connection) then
  begin
    pnlOptions.Caption := GetConnectOptions;
    edtLogin.SetFocus;
  end
  else
  begin
    if edtLogin.Text = '' then
    begin
      edtLogin.SetFocus;
      Exit;
    end;

    if edtPassword.Text = '' then
    begin
      edtPassword.SetFocus;
      Exit;
    end;

    btnOk.SetFocus;
  end;  
end;

procedure TLoginDlg.btnOkClick(Sender: TObject);
begin
  Connection.User := edtLogin.Text;
  Connection.Password := edtPassword.Text;
  Connect;
  ConnectOptions.SaveLogin;
  ModalResult := mrOk;
end;

class function TLoginDlg.Execute(const AConnection: TZConnection): Boolean;
begin
  with TLoginDlg.Create(nil, AConnection) do
  try
    Result := Execute;
  finally
    Free;
  end;
end;

end.
