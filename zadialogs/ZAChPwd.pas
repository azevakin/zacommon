unit ZAChPwd;

interface

uses
  Classes,
  Controls,
  Forms,
  StdCtrls,
  ZPgSqlTr;

type
  TChangePassword = class(TForm)
    GroupBox1: TGroupBox;
    edOldPwd: TEdit;
    edNewPwd: TEdit;
    edConfirmPwd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OkButton: TButton;
    CancelButton: TButton;
    procedure edOldPwdChange(Sender: TObject);
    procedure edNewPwdChange(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    Tr: TZPgSqlTransact;
  end;

procedure ChangePasswordDlg(Transaction: TZPgSqlTransact);

implementation

{$R *.dfm}

procedure ChangePasswordDlg(Transaction: TZPgSqlTransact);
begin
  with TChangePassword.Create(Application) do
  try
    Tr := Transaction;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TChangePassword.edOldPwdChange(Sender: TObject);
begin
  edNewPwd.Enabled := edOldPwd.Text = Tr.Database.Password;
  edConfirmPwd.Enabled := edNewPwd.Enabled;
end;

procedure TChangePassword.edNewPwdChange(Sender: TObject);
begin
  OkButton.Enabled := edNewPwd.Text = edConfirmPwd.Text;
end;

procedure TChangePassword.OkButtonClick(Sender: TObject);
begin
  Tr.BatchExecSql('alter user '+Tr.Database.Login+' with password '''+edNewPwd.Text+'''');
  ModalResult := mrOk;
end;

end.
