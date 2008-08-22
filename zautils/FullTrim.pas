unit FullTrim;

interface

function TrimAll(const S: string): string;

implementation

uses RegExpr;

var
  re_doubles, re_ends: TRegExpr;

function TrimAll(const S: string): string;
begin
  Result := re_doubles.Replace(re_ends.Replace(S, ''), ' ');
end;

initialization
  re_doubles := TRegExpr.Create;
  re_doubles.Expression := '\s{2,}';

  re_ends := TRegExpr.Create;
  re_ends.Expression := '^\s+|\s+$';

finalization
  re_doubles.Free;
  re_doubles := nil;

  re_ends.Free;
  re_ends := nil;
end.
