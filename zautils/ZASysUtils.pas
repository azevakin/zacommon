unit ZASysUtils;

interface

function BoolToStrRus(B: Boolean): string;
function FormatRoubles(Value: Extended): String;
function GenerateFileName(const FileExt: ShortString) : ShortString;
function GetTempPathStr: String;
function KopeckToRouble(AValue: Int64): Extended;
function ReplaceStr(const AText, AFromText, AToText: string): string;
function RoubleToKopeck(const Value: String; const Separator: Char = ','): Integer;
function StrToBoolRus(const S: string): Boolean;

implementation

uses SysUtils, Windows, Math, ZAStrUtils, ZAConst;

function BoolToStrRus(B: Boolean): string;
const
  cSimpleBoolStrs: array [Boolean] of String = (SRusNo, SRusYes);
begin
  Result := cSimpleBoolStrs[B];
end;

function FormatRoubles(Value: Extended): String;
var
  fs: TFormatSettings;
begin
  fs.CurrencyFormat    := CurrencyFormat;
  fs.NegCurrFormat     := NegCurrFormat;
  fs.ThousandSeparator := SSpace;
  fs.DecimalSeparator  := DecimalSeparator;
  fs.CurrencyDecimals  := CurrencyDecimals;
  fs.CurrencyString    := SNull;
  Result := CurrToStrF(RoundTo(Value, -2), ffCurrency, 2, fs);
end;

function GenerateFileName(const FileExt: ShortString) : ShortString;
const
 alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
 i: integer;
begin
  Result := '';
  Randomize;
  for i:=1 to 8 do {генерируем случайное имя файла}
    Result := Concat(Result, alphabet[Random(length(alphabet)-1)+1]);
  if FileExt <> '' then
    Result := Concat(Result, FileExt);
end;

function GetTempPathStr: String;
var
  Buffer: array[0..MAX_PATH] of char;
begin
  Buffer := #0;
  GetTempPath(Length(Buffer), Buffer);
  Result := Buffer;
end;

function KopeckToRouble(AValue: Int64): Extended;
var
  Kopeck: Int64;
begin
  Kopeck := AValue div 100;
  Result := Kopeck + ( ( AValue - ( Kopeck * 100 ) ) * 0.01 );
end;

function ReplaceStr(const AText, AFromText, AToText: string): string;
begin
  Result := StringReplace(AText, AFromText, AToText, [rfReplaceAll]);
end;

function RoubleToKopeck(const Value: String; const Separator: Char = ','): Integer;
const
  Zero = '0';
var
  K: Integer;
  R, I, F: String;

  function ZeroIfNull(const S: String): String;
  begin
    Result := S;
    if Result = SNull then Result := Zero;
  end;

begin
  R := TrimAll(Value);
  K := Pos(Separator, R);
  if K > 0 then
  begin
    I := Copy(R, 1, K-1);
    F := Copy(R, K+1, Length(R));
    if Length(F) = 1 then Insert(Zero, F, 2);
  end else begin
    I := Copy(R, 1, Length(R));
    F := Zero;
  end;
  Result := StrToInt(ZeroIfNull(I)) * 100 + StrToInt(ZeroIfNull(F));
end;

function StrToBoolRus(const S: string): Boolean;
begin
  Result := False;
  if S = SRusYes then Result := True;
end;

end.
