unit Updater;

interface

uses Classes, IdFTP, IniFiles;

type
  TIdFTP = IdFTP.TIdFTP;

  TUpdaterOptions = class
    FTP: TIdFTP;
    RegistryKey: string;
    DirectoryDefault: string;
    Directory: string;
    Filename: string;
  public
    constructor Create(const ARegistryKey: string; AFTP: TIdFTP);
    function LoadOptions(const LoadAll: Boolean): Boolean;
    procedure SaveOptions;
  end;

  TBeforeAction = procedure(Sender: TObject; const Action: String) of object;
  TAfterAction = procedure(Sender: TObject; const ActionResult: String) of object;
  TOnProgress = procedure(Sender: TObject; const Max, Position: Integer) of object;

  TUpdater = class(TObject)
    FTP: TIdFTP;
    Options: TUpdaterOptions;
  private
    Instructions: TIniFile;
    OutDirectory: string;
    FAbortUpdate: Boolean;
    FAfterAction: TAfterAction;
    FBeforeAction: TBeforeAction;
    FOnProgress: TOnProgress;
  protected
    procedure DoAfterAction(const ActionResult: string);
    procedure DoBeforeAction(const Action: string); overload;
    procedure DoBeforeAction(const Action: string; Params: array of const); overload;
    procedure DoOnProgress(const Max, Position: Integer);
  public
    constructor Create(const SRegistryKey, SOutDirectory, SFTPDirectory: string);
    destructor Destroy; override;
    property AbortUpdate: Boolean read FAbortUpdate write FAbortUpdate;
    property AfterAction: TAfterAction read FAfterAction write FAfterAction;
    property BeforeAction: TBeforeAction read FBeforeAction write FBeforeAction;
    procedure ChangeRemoteDir;
    function IsNewVersion(const Major, Minor, Release, Build: Cardinal): Boolean;
    procedure Connect;
    function Connected: Boolean;
    procedure DownloadFiles;
    procedure DownloadInstructions(const UseLocal: Boolean = False);
    procedure Disconnect;
    property OnProgress: TOnProgress read FOnProgress write FOnProgress;
    function RunSectionExists(out Filename: string): Boolean;
  end;

procedure RunUpdater(const Filename, OptionsKey, OutDir, FTPDirDefault: String);

function HasNewVersion(const OptionsKey, FTPDirectory: String;
  const VMajor, VMinor, VRelease, VBuild: Cardinal): Boolean;


const
  UpdateConfirmation = 'Версия программы устарела, скачать обновление?';
  WithOutUpdateParam = '-woupdate';

implementation

uses Registry, SysUtils, Windows, Messages, ShellAPI;

const
  EventOk = 'OK';
  EventBad = 'Ошибка';

  //  разделы INI файла с инструкцией для программы обновления
  SectionFiles = 'Files';     //  в данной секции перечислены файлы,
                              //  которые необходимо обновить
  SectionRun = 'Run';         //  секция в которой задан файл для запуска
                              //  после обновления программы
  SectionVersion = 'Version'; //  секция в версией новой программы

  //  параметры разделов файла с инструкцией
  IdentMajor = 'Major';       //  параметр, хранящий Мажорную версию программы
  IdentMinor = 'Minor';       //  параметр, хранящий Минорную версию программы
  IdentRelease = 'Release';   //  параметр, хранящий номер Релиза программы
  IdentBuild = 'Build';       //  параметр, хранящий номер Билда программы
  IdentFilename = 'Filename'; //  параметр, хранящий файл для запуска
                              //  после обновления программы

  SConnect = 'Подключение к серверу FTP...';
  SChangeDir = 'Переход в папку "%s"...';
  SDownloadFile = 'Загрузка файла "%s"...';
  SNoInstructions = 'Не задан файл, содержащий инструкции, для программы обновления.';
  SNull = '';
  SSpace = ' ';
  SReadInstructions = 'Чтение инструкций...';

  //  параметры для подключения к FTP серверу
  ValHost = 'Сервер'; // ftp сервер
  ValHostDefault = 'dbserver.tsogu.ru'; // значение по умолчанию для ValHost
  ValPort = 'Порт'; // порт ftp
  ValPortDefault = 21; // значение по умолчанию для ValPort
  ValDir = 'Папка'; // директория в домашней папке пользователя в которой
                    // находятся файлы для обновления
  ValFile = 'Файл'; // файл с инструкцией для программы обновления
  ValFileDefault = 'update.ini'; // значение по умолчанию для ValFile
  ValLogin = 'Логин'; // логин к ftp серверу
  ValLoginDefault = 'infs'; // значение по умолчанию для ValLogin
  ValPassword = 'Пароль'; // пароль к ftp серверу
  ValPasswordDefault = '123456'; // значение по умолчанию для ValPassword

function SetEnv(const Name, Value: string): Boolean;
begin
  Result := SetEnvironmentVariable(PChar(Name), PChar(Value));
end;

function GetEnv(const Name: string; var Value: string): Boolean;
var
  R: DWORD;
begin
  R := GetEnvironmentVariable(PChar(Name), nil, 0);
  SetLength(Value, R);
  R := GetEnvironmentVariable(PChar(Name), PChar(Value), R);
  Result := R <> 0;
  if not Result then
    Value := '';
end;

function ApplicationPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function ProcessMessage(var Msg: TMsg): Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    if Msg.Message <> WM_QUIT then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end
    else
  end;
end;

procedure ProcessMessages;
var
  Msg: TMsg;
begin
  while ProcessMessage(Msg) do {loop};
end;

function PrepareMessage(const s: string): string;
begin
  Result := StringReplace(s, #10, SSpace, [rfReplaceAll]);
  Result := StringReplace(Result, #13, SSpace, [rfReplaceAll]);
end;

function TempPath: string;
var
  Buffer: array[0..MAX_PATH] of char;
  len: Cardinal;
begin
  Buffer := #0;
  len := GetTempPath(0, Buffer);
  GetTempPath(len, Buffer);
  Result := Buffer;
end;

procedure RunUpdater(const Filename, OptionsKey, OutDir, FTPDirDefault: String);
(*****************************************************************************
 *  Filename      - имя файла с программой обновления
 *  OptionsKey    - ключ в реестре windows
 *  OutDir        - директория в которую будет загружено обновление
 *  FTPDirDefault - директория на FTP с обновлением по умолчанию 
 *****************************************************************************)
const
  SErrorOnRun = 'Ошибка при запуске программы обновления';
  SFileIsInvalid = '"%s" не является приложением Win32 или имеет неверный формат';
  SFileNotCopy = 'Не удается скопировать файл "%s", обновление невозможно';
  SFileNotFound = 'Файл не найден "%s", обновление невозможно';
  SFmtCmd = '"%s" "%s" "%s"';
  SOutOfMemory = 'Системе не хватает ресурсов для запуска программы обновления';
  SPathNotFound = 'Путь не найден "%s", обновление невозможно';
var
  RCode: Cardinal;
  ACmdLine,
  ADestFile,
  ASourceFile,
  ATempDir: String;

begin
  ATempDir := TempPath;
  ASourceFile := ApplicationPath + Filename;
  ADestFile := ATempDir + Filename;

  if FileExists(ASourceFile) then
  begin
    if CopyFile(PChar(ASourceFile), PChar(ADestFile), False) then
    begin
      ACmdLine := Format(SFmtCmd, [OptionsKey, OutDir, FTPDirDefault]);
      RCode := ShellExecute(
        0,
        'open',
        PChar(ADestFile),
        PChar(ACmdLine),
        PChar(ATempDir),
        SW_SHOW
      );
      
      if RCode < 32 then
      case RCode of
        0:{ The system is out of memory or resources. }
          raise Exception.Create(SOutOfMemory);
        ERROR_BAD_FORMAT:
          raise Exception.CreateFmt(SFileIsInvalid, [ADestFile]);
        ERROR_FILE_NOT_FOUND:
          raise Exception.CreateFmt(SFileNotFound, [ADestFile]);
        ERROR_PATH_NOT_FOUND:
          raise Exception.CreateFmt(SPathNotFound, [ATempDir]);
      else
        raise Exception.Create(SErrorOnRun);
      end;
    end
    else
      raise Exception.CreateFmt(SFileNotCopy, [FileName]);
  end
  else
    raise Exception.CreateFmt(SFileNotFound, [FileName]);
end;

function HasNewVersion(const OptionsKey, FTPDirectory: String;
  const VMajor, VMinor, VRelease, VBuild: Cardinal): Boolean;
begin
  Result := False;
  with TUpdater.Create(OptionsKey, SNull, FTPDirectory) do
  try
    Options.LoadOptions(True);
    Connect;

    if not AbortUpdate then
      ChangeRemoteDir;

    if not AbortUpdate then
      DownloadInstructions;

    if not AbortUpdate then
      Result := IsNewVersion(VMajor, VMinor, VRelease, VBuild);
  finally
    Free;
  end;
end;

{ TOptions }

constructor TUpdaterOptions.Create(const ARegistryKey: string; AFTP: TIdFTP);
begin
  Self.FTP := AFTP;
  Self.RegistryKey := ARegistryKey;
end;

function TUpdaterOptions.LoadOptions(const LoadAll: Boolean): Boolean;
begin
  Result := False;
  with TRegistry.Create do
  try
    if OpenKey(RegistryKey, True) then
    begin
      if LoadAll then
      begin
        if ValueExists(ValHost) then
        begin
          FTP.Host := ReadString(ValHost);
          Result := True;
        end
        else
        begin
          FTP.Host := ValHostDefault;
          Result := Result and False;
        end;

        if ValueExists(ValPort) then
        begin
          FTP.Port := ReadInteger(ValPort);
          Result := Result and True;
        end
        else
        begin
          FTP.Port := ValPortDefault;
          Result := Result and False;
        end;

        if ValueExists(ValLogin) then
        begin
          FTP.Username := ReadString(ValLogin);
          Result := Result and True;
        end
        else
        begin
          FTP.Username := ValLoginDefault;
          Result := Result and False;
        end;

        if ValueExists(ValPassword) then
        begin
          FTP.Password := ReadString(ValPassword);
          Result := Result and True;
        end
        else
        begin
          FTP.Password := ValPasswordDefault;
          Result := Result and False;
        end;
      end;

      if ValueExists(ValDir) then
      begin
        Directory := ReadString(ValDir);
        Result := Result and True;
      end
      else
      begin
        Directory := DirectoryDefault;
        Result := Result and False;
      end;

      if ValueExists(ValFile) then
      begin
        Filename := ReadString(ValFile);
        Result := Result and True;
      end
      else
      begin
        Filename := ValFileDefault;
        Result := Result and False;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TUpdaterOptions.SaveOptions;
begin
  with TRegistry.Create do
  try
    if OpenKey(RegistryKey, True) then
    begin
      if FTP.Host <> '' then
        WriteString(ValHost, FTP.Host);

      if FTP.Port <> 0 then
        WriteInteger(ValPort, FTP.Port);

      if FTP.Username <> '' then
        WriteString(ValLogin, FTP.Username);

      if FTP.Password <> '' then
        WriteString(ValPassword, FTP.Password);

      if Directory <> '' then
        WriteString(ValDir, Directory);

      if Filename <> '' then
        WriteString(ValFile, Filename);
    end;
  finally
    Free;
  end;
end;

{ TUpdater }

procedure TUpdater.ChangeRemoteDir;
begin
  AbortUpdate := False;
  if (Options.Directory <> SNull) then
  try
    DoBeforeAction(SChangeDir, [Options.Directory]);
    FTP.ChangeDir(Options.Directory);
    DoAfterAction(EventOk);
  except
    on e: Exception do
    begin
      AbortUpdate := True;
      DoAfterAction(EventBad);
      DoBeforeAction(PrepareMessage(e.Message));
      DoAfterAction(SSpace);
    end;
  end;
end;

function TUpdater.IsNewVersion(const Major, Minor, Release, Build: Cardinal): Boolean;
  function eq(const Ident: string; const Value: Integer): Boolean;
  begin
    try
      Result := Instructions.ReadInteger(SectionVersion, Ident, 0) = Value;
    except
      on e: Exception do
        raise Exception.Create(e.Message);
    end;
  end;

  function gt(const Ident: string; const Value: Integer): Boolean;
  begin
    try
      Result := Instructions.ReadInteger(SectionVersion, Ident, 0) > Value;
    except
      on e: Exception do
        raise Exception.Create(e.Message);
    end;
  end;

begin
  Result := gt(IdentMajor, Major) or
    (eq(IdentMajor, Major) and gt(IdentMinor, Minor)) or
    (eq(IdentMajor, Major) and eq(IdentMinor, Minor) and gt(IdentRelease, Release)) or
    (eq(IdentMajor, Major) and eq(IdentMinor, Minor) and eq(IdentRelease, Release) and gt(IdentBuild, Build));
end;

procedure TUpdater.Connect;
begin
  AbortUpdate := False;
  try
    if (FTP.Host = '') then
    begin
      DoBeforeAction(EventBad);
      DoAfterAction('Не задан хост!');
      AbortUpdate := True;
      Exit;
    end;

    DoBeforeAction(SConnect);
    FTP.Connect();
    DoAfterAction(EventOk);
    if not Connected then
      raise Exception.Create('');
  except
    on e: Exception do
    begin
      AbortUpdate := True;
      DoAfterAction(EventBad);
      DoBeforeAction(PrepareMessage(e.Message));
      DoAfterAction(SSpace);
    end;
  end;
end;

function TUpdater.Connected: Boolean;
begin
  Result := FTP.Connected;
end;

constructor TUpdater.Create(const SRegistryKey, SOutDirectory, SFTPDirectory: string);
begin
  FTP := TIdFTP.Create(nil);
  Options := TUpdaterOptions.Create(SRegistryKey, FTP);
  Options.DirectoryDefault := SFTPDirectory;
  OutDirectory := SOutDirectory;
end;

destructor TUpdater.Destroy;
begin
  FTP.Disconnect;
  FTP.Free;
  Instructions.Free;
  Options.Free;
  inherited;
end;

procedure TUpdater.Disconnect;
begin
  FTP.Disconnect;
end;

procedure TUpdater.DoAfterAction(const ActionResult: string);
begin
  if Assigned(FAfterAction)
    then FAfterAction(Self, ActionResult);
end;

procedure TUpdater.DoBeforeAction(const Action: string);
begin
  if Assigned(FBeforeAction)
    then FBeforeAction(Self, Action);
end;

procedure TUpdater.DoBeforeAction(const Action: string;
  Params: array of const);
begin
  DoBeforeAction(Format(Action, Params));
end;

procedure TUpdater.DoOnProgress(const Max, Position: Integer);
begin
  if Assigned(FOnProgress)
    then FOnProgress(Self, Max, Position);
end;

procedure TUpdater.DownloadFiles;
var
  i, Len: Integer;
  Ident: string;
  Idents: TStringList;
  Dest: string;
  DestDir: string;

  function ReadTemplate: string;
  begin
    Result := Instructions.ReadString(SectionFiles, Ident, SNull);
  end;
begin
  Idents := TStringList.Create;
  try
    Instructions.ReadSection(SectionFiles, Idents);
    Len := Idents.Count;
    if Len > 0 then
    begin
      for i := 0 to Len-1 do
      begin
        ProcessMessages;
        if AbortUpdate
          then Exit;
        DoOnProgress(Len, i+1);
        Ident := Idents[i];
        DoBeforeAction(SDownloadFile, [Ident]);
        try
          Dest := Format(ReadTemplate, [OutDirectory]);
          DestDir := ExtractFileDir(Dest);
          if not DirectoryExists(DestDir)
            then CreateDir(DestDir);
          FTP.Get(Ident, Dest, True);
          DoAfterAction(EventOk);
        except
          on e: Exception do
          begin
            DoAfterAction(EventBad);
            DoBeforeAction(PrepareMessage(e.Message));
            DoAfterAction(SSpace);
          end;
        end;
      end;
    end;
  finally
    Idents.Free;
  end;
end;

procedure TUpdater.DownloadInstructions(const UseLocal: Boolean);
var
  LocalFile: string;
begin
  AbortUpdate := False;
  if Options.Filename <> SNull then
  begin
    LocalFile := TempPath + Options.Filename;
    if not UseLocal then
    try
      DoBeforeAction(SDownloadFile, [Options.Filename]);
      FTP.Get(Options.Filename, LocalFile, True);
      DoAfterAction(EventOk);
    except
      on e: Exception do
      begin
        AbortUpdate := True;
        DoAfterAction(EventBad);
        DoBeforeAction(PrepareMessage(e.Message));
        DoAfterAction(SSpace);
      end;
    end;

    if not AbortUpdate then
    try
      DoBeforeAction(SReadInstructions);
      Instructions := TIniFile.Create(LocalFile);
      DoAfterAction(EventOk);
    except
      on e: Exception do
      begin
        AbortUpdate := True;
        DoAfterAction(EventBad);
        DoBeforeAction(PrepareMessage(e.Message));
        DoAfterAction(SSpace);
      end;
    end;
  end
  else
    raise Exception.Create(SNoInstructions);
end;

function TUpdater.RunSectionExists(out Filename: string): Boolean;
begin
  Result := Instructions.SectionExists(SectionRun) and
    Instructions.ValueExists(SectionRun, IdentFilename);

  if Result then
    Filename := Format(
      Instructions.ReadString(SectionRun, IdentFilename, ''),
      [ OutDirectory ]
    );
end;

end.
