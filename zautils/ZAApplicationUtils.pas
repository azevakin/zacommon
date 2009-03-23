unit ZAApplicationUtils;

interface

  function GetApplicationVersion(var Major, Minor, Release, Build: Cardinal): Boolean;

  function applicationFileDir: string;
  function applicationFileDrive: string;
  function applicationFileExt: string;
  function applicationFileName: string;
  function applicationFilePath: string;

  function CBox(const Text: String; const WithCancel: Boolean = False): Integer;
  function CBoxB(const Text: String): Boolean;
  function CBoxFmt(const S: string; const Args: array of const; const WithCancel: Boolean = False): Integer;
  function CBoxFmtB(const S: string; const Args: array of const): Boolean;

  procedure MBox(const Text: String);
  procedure MBoxFmt(const S: string; const Args: array of const);

  procedure EBox(const Text: String);
  procedure EBoxFmt(const S: string; const Args: array of const);

  procedure IBox(const Text: String);
  procedure IBoxFmt(const S: string; const Args: array of const);

  procedure WBox(const Text: String);
  procedure WBoxFmt(const S: string; const Args: array of const);

const
  s_no_data_for_report = 'Нет данных для отображения';

implementation

uses Forms, SysUtils, Windows;


function GetApplicationVersion(var Major, Minor, Release, Build: Cardinal): Boolean;
var
  info: Pointer;
  infosize: DWORD;
  fileinfo: PVSFixedFileInfo;
  fileinfosize: DWORD;
  tmp: DWORD;
begin
  infosize := GetFileVersionInfoSize(PChar(ParamStr(0)), tmp);
  Result := infosize <> 0;
  if Result then
  begin
    GetMem(info, infosize);
    try
      GetFileVersionInfo(PChar(ParamStr(0)), 0, infosize, info);
      VerQueryValue(info, nil, Pointer(fileinfo), fileinfosize);
      Major   := fileinfo.dwProductVersionMS shr 16;
      Minor   := fileinfo.dwProductVersionMS and $FFFF;
      Release := fileinfo.dwProductVersionLS shr 16;
      Build   := fileinfo.dwProductVersionLS and $FFFF;
    finally
      FreeMem(info, fileinfosize);
    end;
  end;
end;

function exename: string;
begin
  Result := ParamStr(0);
end;

function applicationFileDir: string;
begin
  Result := ExtractFileDir(exename);
end;

function applicationFileDrive: string;
begin
  Result := ExtractFileDrive(exename);
end;

function applicationFileExt: string;
begin
  Result := ExtractFileExt(exename);
end;

function applicationFileName: string;
begin
  Result := ExtractFileName(exename);
end;

function applicationFilePath: string;
begin
  Result := ExtractFilePath(exename);
end;


procedure MBox(const Text: String);
begin
  Application.MessageBox(
    PChar(Text),
    PChar(ExtractFileName(Application.ExeName)),
    MB_APPLMODAL);
end;

procedure MBoxFmt(const S: string; const Args: array of const);
begin
  MBox(Format(S, Args));
end;

procedure EBox(const Text: String);
begin
  Application.MessageBox(
    PChar(Text),
    'Ошибка',
    MB_APPLMODAL + MB_ICONERROR);
end;

procedure EBoxFmt(const S: string; const Args: array of const);
begin
  EBox(Format(S, Args));
end;

procedure IBox(const Text: String);
begin
  Application.MessageBox(
    PChar(Text),
    'Информация',
    MB_APPLMODAL + MB_ICONINFORMATION);
end;

procedure IBoxFmt(const S: string; const Args: array of const);
begin
  IBox(Format(S, Args));
end;

procedure WBox(const Text: String);
begin
  Application.MessageBox(
    PChar(Text),
    'Предупреждение',
    MB_APPLMODAL + MB_ICONWARNING);
end;

procedure WBoxFmt(const S: string; const Args: array of const);
begin
  WBox(Format(S, Args));
end;

function CBox(const Text: String; const WithCancel: Boolean = False): Integer; 
var
  Flags: Integer;
begin
  Flags := MB_APPLMODAL + MB_ICONQUESTION;

  if WithCancel then
    Flags := Flags + MB_YESNOCANCEL
  else
    Flags := Flags + MB_YESNO;

  Result := Application.MessageBox(
    PChar(Text),
    'Подтверждение',
    Flags);
end;

function CBoxB(const Text: String): Boolean;
begin
  Result := CBox(Text, False) = ID_YES;
end;

function CBoxFmt(const S: string; const Args: array of const; const WithCancel: Boolean = False): Integer;
begin
  Result := CBox(Format(S, Args), WithCancel);
end;

function CBoxFmtB(const S: string; const Args: array of const): Boolean;
begin
  Result := CBox(Format(S, Args)) = ID_YES;
end;

end.




