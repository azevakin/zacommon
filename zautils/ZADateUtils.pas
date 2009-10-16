unit ZADateUtils;

interface

function CurrentMonth: Word;
function IsDate(const value: string): Boolean;
function MonthOf(const ADate: TDateTime): Word;
function QuarterOf(const ADate: TDateTime): Word;
function YearOf(const ADate: TDateTime): Word;

implementation

uses SysUtils, Windows;

function CurrentMonth: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wMonth;
end;

function IsDate(const value: string): Boolean;
begin
  Result := False;
  try
    StrToDate(value);
    Result := True;
  except
  end;
end;

function MonthOf(const ADate: TDateTime): Word;
var
  LYear, LDay: Word;
begin
  DecodeDate(ADate, LYear, Result, LDay);
end;

function QuarterOf(const ADate: TDateTime): Word;
var
  LYear, LMonth, LDay: Word;
begin
  result := 0;
  DecodeDate(ADate, LYear, LMonth, LDay);
  case LMonth of
    1, 2, 3:
      result := 1;
    4, 5, 6:
      result := 2;
    7, 8, 9:
      result := 3;
    10, 11, 12:
      result := 4;
  end;
end;

function YearOf(const ADate: TDateTime): Word;
var
  LMonth, LDay: Word;
begin
  DecodeDate(ADate, Result, LMonth, LDay);
end;

end.
