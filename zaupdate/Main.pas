unit Main;

interface

uses
  SysUtils, Classes, Controls, Forms, ImgList, ComCtrls, StdCtrls, Updater;

type
  TMainForm = class(TForm)
    lvValues: TListView;
    pb: TProgressBar;
    procedure FormActivate(Sender: TObject);
  private
    Item: TListItem;
    Updater: TUpdater;
    function AddEvent(const EventText: string): TListItem; overload;
    function AddEvent(const Fmt: string; Args: array of const): TListItem; overload;
    procedure CloseEvent(Item: TListItem; const EventResult: string);
    procedure After(Sender: TObject; const ActionResult: String);
    procedure Before(Sender: TObject; const Action: String);
    procedure Progress(Sender: TObject; const Max, Position: Integer);
    procedure RunApplication;
    procedure SetOptions;
  protected
    procedure DoCreate; override;
    procedure DoDestroy; override;
  public
  end;

implementation

uses CheckParams, IniFiles, UpdaterOptions, Windows;

{$R *.dfm}

procedure TMainForm.Before(Sender: TObject; const Action: String);
begin
  Application.ProcessMessages;
  Item := AddEvent(Action);
end;

procedure TMainForm.After(Sender: TObject; const ActionResult: String);
begin
  Application.ProcessMessages;
  CloseEvent(Item, ActionResult);
end;

procedure TMainForm.Progress(Sender: TObject; const Max, Position: Integer);
begin
  Application.ProcessMessages;
  pb.Max := Max;
  pb.Position := Position;
end;

procedure TMainForm.RunApplication;
var
  filename: string;
begin
  if Updater.RunSectionExists(filename) then
  begin
    Application.MessageBox(
      'Программа успешно обновлена!',
      'Информация',
      MB_ICONINFORMATION or MB_OK
    );
    WinExec(PChar(filename + ' ' + WithOutUpdateParam), SW_SHOW)
  end
  else
    Application.MessageBox(
      'Программа успешно обновлена.'#13'Перезапустите программу!',
      'Информация',
      MB_ICONINFORMATION or MB_OK
    );
end;

function TMainForm.AddEvent(const EventText: string): TListItem;
begin
  Result := lvValues.Items.Add;
  Result.Caption := EventText;
  Result.MakeVisible(True);
end;

function TMainForm.AddEvent(const Fmt: string; Args: array of const): TListItem;
begin
  Result := AddEvent(Format(Fmt, Args));
end;

procedure TMainForm.CloseEvent(Item: TListItem; const EventResult: string);
begin
  Item.SubItems.Add(EventResult);
end;

procedure TMainForm.DoCreate;
begin
  inherited;
  Updater := TUpdater.Create(REG_KEY, OUT_DIR, FTP_DIR);
  Updater.BeforeAction := Before;
  Updater.AfterAction := After;
  Updater.OnProgress := Progress;
end;

procedure TMainForm.DoDestroy;
begin
  Updater.Free;
  inherited;
end;

procedure TMainForm.SetOptions;
begin
  with TUpdaterOptionsDlg.Create(Self) do
  try
    Updater := Self.Updater;
    if IsPositiveResult(ShowModal) then
    begin
      if not Updater.Options.LoadOptions(True) then
        SetOptions;
    end
    else
    begin
      Application.MessageBox(
        'Обновление программы без задания параметров подключения '+
          'к FTP серверу невозможно!'#13'Обратитесь к разработчику.',
        'Ошибка',
        MB_ICONERROR or MB_OK
      );
      Application.MainForm.Close;
    end;
  finally
    Free;
  end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  Application.ProcessMessages;
  if not Updater.Options.LoadOptions(True) then
    SetOptions;

  Updater.Connect;

  if not Updater.AbortUpdate then
  begin
    Updater.ChangeRemoteDir;
  end;

  if not Updater.AbortUpdate then
  begin
    Updater.DownloadInstructions;
  end;

  if not Updater.AbortUpdate then
    Updater.DownloadFiles;

  RunApplication;

  Application.MainForm.Close;
end;

end.

