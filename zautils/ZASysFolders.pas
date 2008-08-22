unit ZASysFolders;

interface

function GetSystemDir: string;
function GetSystemDrive: string;
function GetTempPath: string;
function GetUserAppDataDir: string;
function GetUserDesktopDir: string;
function GetWindowsDir: string;

implementation

uses Registry, Windows, ZAConst;

const
  RK_ShellFolders = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\';

  VAppData = 'AppData';
// .....
  VDesktop = 'Desktop';

  Slash = '\';

type
  PathBuffer = array [0..MAX_PATH] of Char;

procedure ChkDir(var Value: String);
var
  len: Integer;
begin
  len := length(value);
  if Value[len] = Slash then
    Delete(Value, len, 1);
end;

procedure ChkPath(var Value: String);
var
  len: Integer;
begin
  len := length(value);
  if Value[len] <> Slash then
    Insert(Slash, Value, len);
end;

function GetWindowsDir: string;
var
  Buffer: PathBuffer;
begin
  Result := SNull;
  Windows.GetWindowsDirectory(Buffer, SizeOf(Buffer));
  Result := Buffer;
  ChkDir(Result);
end;

function GetSystemDir: string;
var
  Buffer: PathBuffer;
begin
  Result := SNull;
  Windows.GetSystemDirectory(Buffer, SizeOf(Buffer));
  Result := Buffer;
  ChkDir(Result);
end;

function GetSystemDrive: string;
begin
  Result := SNull;
  Result := Copy(GetSystemDir, 1, 2);
end;

function GetTempPath: string;
var
  Buffer: PathBuffer;
begin
  Result := SNull;
  Windows.GetTempPath(SizeOf(Buffer), Buffer);
  Result := Buffer;
  ChkPath(Result);
end;

function GetUserAppDataDir: string;
begin
  Result := SNull;
  with TRegistry.Create do
  try
    OpenKey(RK_ShellFolders, False);
    Result := ReadString(VAppData);
    ChkDir(Result);
  finally
    Free;
  end;
end;

function GetUserDesktopDir: string;
begin
  Result := SNull;
  with TRegistry.Create do
  try
    OpenKey(RK_ShellFolders, False);
    Result := ReadString(VDesktop);
    ChkDir(Result);
  finally
    Free;
  end;
end;

end.
