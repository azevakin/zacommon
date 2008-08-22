unit coolClipboard;

interface

uses Clipbrd;

type
  TCoolClipboard = class(TClipboard)
  private
  public
    function readAsAnsiText: string;
    function readAsOemText: string;
    function readAsUnicodeText: widestring;
    procedure writeAsAnsiText(const value: string);
    procedure writeAsOemText(const value: string);
    procedure writeAsUnicodeText(const value: widestring);
  end;

implementation

uses Windows;

{ TCoolClipboard }

function TCoolClipboard.readAsAnsiText: string;
var
  Data: THandle;
begin
  Open;
  Data := GetClipboardData(CF_TEXT);
  try
    if Data <> 0 then
      Result := PChar(GlobalLock(Data))
    else
      Result := '';
  finally
    if Data <> 0 then GlobalUnlock(Data);
    Close;
  end;
end;

function TCoolClipboard.readAsOemText: string;
var
  Data: THandle;
begin
  Open;
  Data := GetClipboardData(CF_OEMTEXT);
  try
    if Data <> 0 then
      Result := PChar(GlobalLock(Data))
    else
      Result := '';
  finally
    if Data <> 0 then GlobalUnlock(Data);
    Close;
  end;
end;

function TCoolClipboard.readAsUnicodeText: widestring;
var
  Data: THandle;
begin
  Open;
  Data := GetClipboardData(CF_UNICODETEXT);
  try
    if Data <> 0 then
      Result := PWideChar(GlobalLock(Data))
    else
      Result := '';
  finally
    if Data <> 0 then GlobalUnlock(Data);
    Close;
  end;
end;

procedure TCoolClipboard.writeAsAnsiText(const value: String);
var
  size: Integer;
begin
  size := (length(value)+1) * sizeOf(Char);
  SetBuffer(CF_TEXT, PChar(value)^, size);
end;

procedure TCoolClipboard.writeAsOemText(const value: String);
var
  size: Integer;
begin
  size := (length(value)+1) * sizeOf(Char);
  SetBuffer(CF_OEMTEXT, PChar(value)^, size);
end;

procedure TCoolClipboard.writeAsUnicodeText(const value: widestring);
var
  size: Integer;
begin
  size := (length(value)+1) * sizeOf(WideChar);
  SetBuffer(CF_UNICODETEXT, PWideChar(value)^, size);
end;

end.
