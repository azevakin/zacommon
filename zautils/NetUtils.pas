unit NetUtils;

interface

  function GetComputerIP: string;

implementation

uses Windows, WinSock, SysUtils;

//Win95 or later and NT3.1 or later
function GetComputerIP: string;
var
  Len:    Cardinal;
  pStr:   PChar;
  h:      pHostent;
  b:      array[0..3] of byte;
begin
  pStr:=nil;
  Len:=256;
  try
    pStr:=StrAlloc(Len);
    if GetComputerName(pStr,Len) then
    begin
      h:=GetHostByName(pStr);
      b[0]:=byte(h.h_addr^[0]);
      b[1]:=byte(h.h_addr^[1]);
      b[2]:=byte(h.h_addr^[2]);
      b[3]:=byte(h.h_addr^[3]);
      Result:= Format('%d.%d.%d.%d', [b[0], b[1], b[2], b[3]]);
    end else
      Result := '';
  finally
    if pStr<>nil then StrDispose(pStr);
  end;
end;

end.
