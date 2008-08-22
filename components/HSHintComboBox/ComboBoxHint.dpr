program ComboBoxHint;

uses
  Forms,
  main in 'main.pas' {Form1},
  HSHintComboBox in 'HSHintComboBox.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
