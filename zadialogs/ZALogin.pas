unit ZALogin;

interface

uses
  Classes, Controls, Forms, ZAPgSqlForm, StdCtrls, ExtCtrls;

type
  TLoginDlg = class(TPgSqlForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnOptions: TButton;
    LoginLabel: TLabel;
    PasswordLabel: TLabel;
    edtLogin: TEdit;
    edtPassword: TEdit;
    pnlOptions: TPanel;
    Bevel: TBevel;
    procedure changeLogin(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    connectOptions: TConnectOptions;
    fRegistryKey: string;
    procedure connect;
    procedure setRegistryKey(const Value: string);
  protected
    procedure doShow; override;
    procedure setTransaction(const tr: TZPgSqlTransact); override;
  public
    function execute: Boolean;
    property registryKey: string read fRegistryKey write setRegistryKey;
  end;

  function loginDlg(aTransaction: TZPgSqlTransact;
    const aRegistryKey: string): Boolean;

implementation

uses ZAStdCtrlsUtils, ZAConnectOptions, ZAConst, SysUtils;

{$R *.dfm}

function loginDlg(aTransaction: TZPgSqlTransact;
  const aRegistryKey: string): Boolean;
begin
  with TLoginDlg.Create(Application, ATransaction) do
  try
    registryKey := ARegistryKey;
    Result := execute;
  finally
    Free;
  end;
end;

{ TLoginDlg }

procedure TLoginDlg.setTransaction(const tr: TZPgSqlTransact);
begin
  inherited setTransaction(tr);

  if not Assigned(connectOptions) then
    connectOptions := TConnectOptions.create(Self, transaction)
  else
    if connectOptions.transaction <> transaction then
    begin
      connectOptions.Free;
      connectOptions := TConnectOptions.create(Self, transaction)
    end;
end;

procedure TLoginDlg.connect;
begin
  try
    transaction.Database.Connect;
  except
    on e: Exception do
    begin
      if eHasText(e, 'user') and eHasText(e, 'does not exist') then
      begin
        edtLogin.SetFocus;
        raise Exception.CreateFmt('ОШИБКА: Пользователь "%s" не существует', [
          transaction.Database.Login]);
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

procedure TLoginDlg.setRegistryKey(const Value: string);
begin
  if fRegistryKey <> Value then
  begin
    fRegistryKey := Value;
    connectOptions.registryKey := Value;
  end;
end;

function TLoginDlg.execute: Boolean;
begin
  Result := IsPositiveResult(ShowModal);
end;

procedure TLoginDlg.doShow;
begin
  if connectOptions.loadOptions(True) then
    pnlOptions.Caption := getConnectOptions
  else
    btnOptions.Click;

  edtLogin.Text := transaction.Database.Login;
  if edtLogin.Text <> SNull then
    edtPassword.SetFocus;

  inherited doShow;
end;

procedure TLoginDlg.changeLogin(Sender: TObject);
begin
  btnOk.Enabled := not isEmpty(Sender as TEdit);
end;

procedure TLoginDlg.btnOptionsClick(Sender: TObject);
begin
  if connectOptionsDlg(transaction, fRegistryKey) then
  begin
    pnlOptions.Caption := getConnectOptions;
    edtLogin.SetFocus;
  end
  else
  begin
    if IsEmpty(edtLogin) then
    begin
      edtLogin.SetFocus;
      Exit;
    end;

    if IsEmpty(edtPassword) then
    begin
      edtPassword.SetFocus;
      Exit;
    end;

    btnOk.SetFocus;
  end;  
end;

procedure TLoginDlg.btnOkClick(Sender: TObject);
begin
  transaction.Database.Login := edtLogin.Text;
  transaction.Database.Password := edtPassword.Text;
  connect;
  connectOptions.saveLogin;
  ModalResult := mrOk;
end;

end.
