program simple_mysql;

uses
  {$IFDEF MSWINDOWS}Forms,{$ELSE}QForms,{$ENDIF}
  simple_mysql1 in 'simple_mysql1.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
