program ZAUpdate;

uses
  CheckParams in 'CheckParams.pas',
  Forms,
  SysUtils,
  Updater in 'Updater.pas',
  UpdaterOptions in 'UpdaterOptions.pas' {UpdaterOptionsDlg},
  Main in 'Main.pas' {MainForm};

{$R *.res}

var
  MainForm: TMainForm;

begin
  // обновление запущено из директории программы!
  if ExtractFileDir(ParamStr(0)) = OUT_DIR then
    // перезапустим его из TEMP'a
    RunUpdater(ExtractFileName(ParamStr(0)), REG_KEY, OUT_DIR, FTP_DIR)
  else
  begin
    Application.Initialize;
    Application.Title := 'Обновление программы';
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
  end;
end.
