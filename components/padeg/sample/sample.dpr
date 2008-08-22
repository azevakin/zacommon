program sample;

uses
  Forms,
  declen in '..\pascal\declen.pas',
  main in 'main.pas' {MainForm};

{$R *.res}

var
  MainForm: TMainForm;

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
