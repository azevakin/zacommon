unit UpdaterOptions;

interface

uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls, NumberEdit, Updater;

type
  TUpdaterOptionsDlg = class(TForm)
    lbl1: TLabel;
    edtHost: TEdit;
    lbl2: TLabel;
    edtPort: TNumberEdit;
    lbl3: TLabel;
    edtDir: TEdit;
    lbl4: TLabel;
    edtFile: TEdit;
    bvlMain: TBevel;
    btnOk: TButton;
    btnCancel: TButton;
    lbl5: TLabel;
    edtLogin: TEdit;
    lbl6: TLabel;
    edtPassword: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public
    Updater: TUpdater;
  end;

  procedure ChangeOptions(const OptionsKey, FTPDirectory: String);

implementation

uses SysUtils;

{$R *.dfm}

procedure ChangeOptions(const OptionsKey, FTPDirectory: String);
begin
  with TUpdaterOptionsDlg.Create(Application) do
  try
    Updater := TUpdater.Create(OptionsKey, '', FTPDirectory);
    Updater.Options.LoadOptions(True);
    ShowModal;
  finally
    Free;
  end;
end;

{ TOptionsDlg }

procedure TUpdaterOptionsDlg.btnOkClick(Sender: TObject);
begin
  Updater.FTP.Host := edtHost.Text;
  Updater.FTP.Port := StrToInt(edtPort.Text);
  Updater.FTP.Username := edtLogin.Text;
  Updater.FTP.Password := edtPassword.Text;

  Updater.Options.Directory := edtDir.Text;
  Updater.Options.Filename := edtFile.Text;

  Updater.Options.SaveOptions;

  ModalResult := mrOk;
end;

procedure TUpdaterOptionsDlg.FormShow(Sender: TObject);
begin
  if Assigned(Updater) then
  begin
    edtHost.Text := Updater.FTP.Host;
    edtPort.Text := IntToStr(Updater.FTP.Port);
    edtLogin.Text := Updater.FTP.Username;
    edtPassword.Text := Updater.FTP.Password;
    edtDir.Text := Updater.Options.Directory;
    edtFile.Text := Updater.Options.Filename;
  end;  
end;

end.
