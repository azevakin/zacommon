unit ZeosConnectOptionsDlg;

interface

uses
  Classes, Controls, Forms, ZeosCommonDialog, StdCtrls, ExtCtrls,
  Spin, ZeosCommonForm;

type
  TConnectOptionsDlg = class(TZeosCommonDlg)
    btnOk: TButton;
    btnCancel: TButton;
    HostLabel: TLabel;
    DatabaseLabel: TLabel;
    PortLabel: TLabel;
    edtHostName: TEdit;
    edtDatabase: TEdit;
    Bevel: TBevel;
    edtPort: TSpinEdit;
    procedure ChangeOptions(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    ConnectOptions: TConnectOptions;
    procedure LoadOptions;
    procedure SaveOptions;
  protected
    procedure DoShow; override;
    procedure SetConnection(const AConnection: TZConnection); override;
  public
    class function Execute(const AConnection: TZConnection): Boolean; overload;
  end;

implementation

uses ZConnection;

{$R *.dfm}

{ TConnectOptionsDlg }

procedure TConnectOptionsDlg.LoadOptions;
begin
  ConnectOptions.LoadOptions(False);
  edtHostName.Text := Connection.HostName;
  edtDatabase.Text := Connection.Database;
  edtPort.Value := Connection.Port;
end;

procedure TConnectOptionsDlg.SaveOptions;
begin
  Connection.HostName := edtHostName.Text;
  Connection.Database := edtDatabase.Text;
  Connection.Port := edtPort.Value;
  ConnectOptions.SaveOptions;
end;

procedure TConnectOptionsDlg.DoShow;
begin
  LoadOptions;
  inherited DoShow;
end;

procedure TConnectOptionsDlg.ChangeOptions(Sender: TObject);
begin
  btnOk.Enabled :=  (edtHostName.Text <> '') and (edtDatabase.Text <> '');
end;

procedure TConnectOptionsDlg.btnOkClick(Sender: TObject);
begin
  SaveOptions;
  ModalResult := mrOk;
end;

procedure TConnectOptionsDlg.SetConnection(
  const AConnection: TZConnection);
begin
  inherited SetConnection(AConnection);

  if not Assigned(connectOptions) then
    ConnectOptions := TConnectOptions.Create(Self, Connection)
  else
    if ConnectOptions.Connection <> Connection then
      ConnectOptions.Connection := Connection;
end;

class function TConnectOptionsDlg.Execute(
  const AConnection: TZConnection): Boolean;
begin
  with TConnectOptionsDlg.Create(nil, AConnection) do
  try
    Result := Execute;
  finally
    Free;
  end;   
end;

end.
