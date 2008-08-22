unit ZAConnectOptions;

interface

uses
  Classes, Controls, Forms, ZAPgSqlForm, StdCtrls, NumberEdit, ExtCtrls;

type
  TConnectOptionsDlg = class(TPgSqlForm)
    btnOk: TButton;
    btnCancel: TButton;
    HostLabel: TLabel;
    DatabaseLabel: TLabel;
    PortLabel: TLabel;
    edtHost: TEdit;
    edtDatabase: TEdit;
    edtPort: TNumberEdit;
    Bevel: TBevel;
    procedure changeOptions(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    connectOptions: TConnectOptions;
    fRegistryKey: string;
    procedure loadOptions;
    procedure saveOptions;
    procedure setRegistryKey(const Value: string);
  protected
    procedure doShow; override;
    procedure setTransaction(const tr: TZPgSqlTransact); override;
  public
    function execute: Boolean;
    property registryKey: string read fRegistryKey write setRegistryKey;
  end;

  function connectOptionsDlg(aTransaction: TZPgSqlTransact;
    const aRegistryKey: string): Boolean;

implementation

uses ZAStdCtrlsUtils;

{$R *.dfm}

function connectOptionsDlg(aTransaction: TZPgSqlTransact;
  const aRegistryKey: string): Boolean;
begin
  with TConnectOptionsDlg.Create(nil, ATransaction) do
  try
    registryKey := ARegistryKey;
    Result := execute;
  finally
    Free;
  end;
end;

{ TConnectOptionsDlg }

procedure TConnectOptionsDlg.setTransaction(const tr: TZPgSqlTransact);
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

procedure TConnectOptionsDlg.loadOptions;
begin
  connectOptions.loadOptions(False);
  edtHost.Text := Transaction.Database.Host;
  edtDatabase.Text := Transaction.Database.Database;
  edtPort.Text := Transaction.Database.Port;
end;

procedure TConnectOptionsDlg.saveOptions;
begin
  Transaction.Database.Host := edtHost.Text;
  Transaction.Database.Database := edtDatabase.Text;
  Transaction.Database.Port := edtPort.Text;
  connectOptions.saveOptions;
end;

procedure TConnectOptionsDlg.setRegistryKey(const Value: string);
begin
  if fRegistryKey <> Value then
  begin
    connectOptions.registryKey := Value;
    fRegistryKey := Value;
  end;
end;

function TConnectOptionsDlg.execute: Boolean;
begin
  Result := IsPositiveResult(ShowModal);
end;

procedure TConnectOptionsDlg.doShow;
begin
  loadOptions;

  inherited doShow;
end;

procedure TConnectOptionsDlg.changeOptions(Sender: TObject);
begin
  btnOk.Enabled :=  not isEmpty(edtHost)
                and not isEmpty(edtDatabase)
                and not isEmpty(edtPort);
end;

procedure TConnectOptionsDlg.btnOkClick(Sender: TObject);
begin
  saveOptions;
  ModalResult := mrOk;
end;

end.
