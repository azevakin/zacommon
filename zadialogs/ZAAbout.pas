unit ZAAbout;

interface

uses
  Windows,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  ExtCtrls,
  ShellApi;

type
  TAboutBox = class(TForm)
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Author: TLabel;
    OKButton: TButton;
    Image1: TImage;
    procedure AuthorClick(Sender: TObject);
  end;

procedure AboutDlg;

implementation

{$R *.dfm}

procedure AboutDlg;
begin
  with TAboutBox.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TAboutBox.AuthorClick(Sender: TObject);
begin
  ShellExecute(
    Application.Handle,
    'open',
    'mailto:zevakin@tgngu.tyumen.ru',
    nil,
    nil,
    SW_SHOWNORMAL);
end;

end.

