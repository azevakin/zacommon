program Default;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  DataM in 'DataM.pas' {DM};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
