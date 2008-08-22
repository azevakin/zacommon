unit ZACommonUtils;

interface

uses Forms, Classes;

function NowStr: String;

function formatError(const myMessage, eMessage: String): String; overload;
function formatError(const myMessage: String): String; overload;

procedure RunUpdateOld(const FileName: String); overload;
procedure RunUpdate(const PRG_KEY, FILE_NAME, PRG_NAME: ShortString); overload;

function TemplatePath(AValue: String): String;
function TemplatePathFmt(const S: string; const Args: array of const): String;

procedure WriteLogFile(const text: String; const user: string = '');
procedure WriteExeName(PROGRAMM_KEY: ShortString);

implementation

uses SysUtils, Windows, ZASysUtils, Registry, ZAConst, ZASysFolders,
  ZAApplicationUtils;

function formatError(const myMessage, eMessage: String): String;
const
  formatString = '%s'#13'---------------------------'#13'%s';
begin
  Result := Format(formatString, [myMessage, eMessage]);
end;

function formatError(const myMessage: String): String;
begin
  Result := Format('ОШИБКА: %s', [myMessage]);
end;

procedure WriteLogFile(const text: String; const user: string = '');
{var
  LogFile: TextFile;
  FileName: ShortString;
  exe_name, dir: String;
  ver: OSVERSIONINFO;}
begin
(*
  exe_name := Application.ExeName;

  if GetDriveType(PChar(ExtractFileDrive(exe_name))) = DRIVE_FIXED then
  begin
    GetVersionEx(ver);
    if ver.dwPlatformId = VER_PLATFORM_WIN32_NT then
    begin
      dirGetUserAppDataDir
    end else begin
    end;
  end;

{  if exe_name[1] = '\' then
    FileName := Format('%s\logs\%s.log', [ADir, user])
  else
    FileName := ChangeFileExt(exe_name, '.log');}
//  FileName := Format('%s\logs\%s.log', [ADir, user]);
  AssignFile(LogFile, FileName);

  if FileExists(FileName)  then
    Append(LogFile)
  else
    Rewrite(LogFile);

  Writeln(LogFile, Format('%s => %s', [DateTimeToStr(Now), text]));
  Flush(LogFile);
  CloseFile(LogFile);
*)
end;

procedure WriteExeName(PROGRAMM_KEY: ShortString);
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_CURRENT_USER;
    if OpenKey(PROGRAMM_KEY, True) then
    begin
      WriteString(SNull, Application.ExeName);
      CloseKey;
    end;
  finally
    Free;
  end;
end;

function NowStr: String;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
    Result := Format('%d.%d.%d.%d.%d.%d.%d', [
      wYear, wMonth, wDay, wHour, wMinute, wSecond, wMilliseconds]);
end;

procedure RunUpdateOld(const FileName: String);
const
  SPathNotFound = 'Путь не найден %s, обновление невозможно';
  SFileNotFound = 'Файл не найден %s, обновление невозможно';
  SFileNotCopy = 'Не удается скопировать файл %s, обновление невозможно';
  SUnableCreateFolder = 'Не удается создать папку %s, обновление невозможно';
  SOutOfMemory = 'Системе не хватает ресурсов для запуска программы обновления';
  SFileIsInvalid = '%s не является приложением Win32 или имеет неверный формат';
var
  RCode: Cardinal;
  ATempDir, ASourceFile, ADestFile: String;
begin
  ATempDir := GetTempPathStr + NowStr;
  ADestFile := Format('%s\%s', [ATempDir, FileName]);
  ASourceFile := Format('%s\%s', [applicationFileDir, FileName]);
  if CreateDir(ATempDir) then begin
    if FileExists(ASourceFile) then begin
      if CopyFile(PChar(ASourceFile), PChar(ADestFile), False) then begin
        RCode := WinExec(PChar(ADestFile), SW_SHOW);
        if RCode < 32 then
          case RCode of
            0: // The system is out of memory or resources.
              raise Exception.Create(SOutOfMemory);
            ERROR_BAD_FORMAT:
              raise Exception.CreateFmt(SFileIsInvalid, [ADestFile]);
            ERROR_FILE_NOT_FOUND:
              raise Exception.CreateFmt(SFileNotFound, [ADestFile]);
            ERROR_PATH_NOT_FOUND:
              raise Exception.CreateFmt(SPathNotFound, [ATempDir]);
          else
            raise Exception.Create('Ошибка при запуске программы обновления');
          end;
      end else raise Exception.CreateFmt(SFileNotCopy, [FileName]);
    end else raise Exception.CreateFmt(SFileNotFound, [FileName]);
  end else raise Exception.CreateFmt(SUnableCreateFolder, [ATempDir]);
end;

procedure RunUpdate(const PRG_KEY, FILE_NAME, PRG_NAME : ShortString);
(*****************************************************************************
 *  PRG_KEY   - ключ в реестре windows
 *  FILE_NAME - файл с обновлением, находящийся на сервере
 *  PRG_NAME  - название программы, нужно для задания заголовка окна
 *****************************************************************************)
const
  SPathNotFound = 'Путь не найден %s, обновление невозможно';
  SFileNotFound = 'Файл не найден %s, обновление невозможно';
  SFileNotCopy = 'Не удается скопировать файл %s, обновление невозможно';
  SUnableCreateFolder = 'Не удается создать папку %s, обновление невозможно';
  SOutOfMemory = 'Системе не хватает ресурсов для запуска программы обновления';
  SFileIsInvalid = '%s не является приложением Win32 или имеет неверный формат';
  SFmtPath = '%s\%s';
  SFmtCmd = '%s "%s" %s %s';
  FileName = 'ZAUpdate.exe';
var
  RCode: Cardinal;
  ATempDir, ASourceFile, ADestFile, ACmdLine: String;
begin
  ATempDir := GetTempPathStr + NowStr;
  ADestFile := Format(SFmtPath, [ATempDir, FileName]);
  ASourceFile := Format(SFmtPath, [applicationFileDir, FileName]);
  if CreateDir(ATempDir) then
  begin
    if FileExists(ASourceFile) then
    begin
      if CopyFile(PChar(ASourceFile), PChar(ADestFile), False) then
      begin
        ACmdLine := Format(SFmtCmd, [ADestFile, PRG_KEY, FILE_NAME, PRG_NAME]);
        RCode := WinExec(PChar(ACmdLine), SW_SHOW);
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
            raise Exception.Create('Ошибка при запуске программы обновления');
          end;
      end else raise Exception.CreateFmt(SFileNotCopy, [FileName]);
    end else raise Exception.CreateFmt(SFileNotFound, [FileName]);
  end else raise Exception.CreateFmt(SUnableCreateFolder, [ATempDir]);
end;

function TemplatePath(AValue: String): String;
begin
  Result := Format('%s\Resource\%s', [applicationFileDir, AValue]);
end;

function TemplatePathFmt(const S: string; const Args: array of const): String;
begin
  Result := TemplatePath(Format(S, Args));
end;

end.
