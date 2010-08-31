unit ZAStrUtils;

interface

type
  TFullName = (fnFullName, fnFirstInitials, fnLastInitials);

  function FirstLower(S: String): String;
  function FirstUpper(S: String): String;
  function FormatFIO(const fam, nam, ot: String; const Convert: TFullName): string;
  function RStr(const S: String; Count: Integer): String;
  function FullName(const LastName, FirstName, MiddleName: String; const Convert: TFullName): string; deprecated;
  function TrimAll(const S: String): String;

implementation

uses Windows, ZAConst;

function FirstLower(S: String): String;
begin
  Result := S;
  if Length(Result) > 0 then
    CharLowerBuff(@Result[1], 1);
end;

function FirstUpper(S: String): String;
begin
  Result := S;
  if Length(Result) > 0 then
    CharUpperBuff(@Result[1], 1);
end;

function RStr(const S: String; Count: Integer): String;
var
  Len: Integer;
begin
  Result := SNull;
  Len := Length(S);
  if Count > Len then
    Count := Len;
  if Count = 1 then
    Result := S[Len]
  else
    Result := Copy(S, Len + 1 - Count, Count);
end;

function FormatFIO(const fam, nam, ot: String; const Convert: TFullName): string;

  function ChkNull(const s: String): String;
  begin
    result := SNull;
    if Length(s) > 0 then
      result := s[1] + '. ';
  end;

begin
  case Convert of
    fnFullName:
      Result := fam + SSpace + nam + SSpace + ot;
    fnFirstInitials:
      Result := ChkNull(nam) + ChkNull(ot) + fam;
    fnLastInitials:
      Result := fam + SSpace + ChkNull(nam) + ChkNull(ot);
  end;
end;

function FullName(const LastName, FirstName, MiddleName: String; const Convert: TFullName): string;
begin
  result := FormatFIO(LastName, FirstName, MiddleName, Convert);
end;

function TrimAll(const S: String): String;
var
  I: Integer;
begin
  Result := S;
  if Result = SNull then Exit;
  I := Pos(SSpace, Result);
  while I <> 0 do
  begin
    Delete(Result, I, 1);
    I := Pos(SSpace, Result);
  end;
end;

end.
