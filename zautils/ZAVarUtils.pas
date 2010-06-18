unit ZAVarUtils;

interface

uses DB;

function FieldToVariant(Field: TField): OLEVariant;

implementation

uses Variants;

function FieldToVariant(Field: TField): OLEVariant;
begin
  Result := Null;
  if not Field.IsNull then
  case Field.DataType of
    ftString,
    ftFixedChar,
    ftWideString,
    ftMemo,
    ftFmtMemo,
    ftDate,
    ftTime,
    ftDateTime:
      Result := Field.AsString;

    ftSmallint,
    ftInteger,
    ftWord,
    ftLargeint,
    ftAutoInc:
      Result := Field.AsInteger;

    ftFloat,
    ftCurrency,
    ftBCD:
      Result := Field.AsFloat;

    ftBoolean:
      Result := Field.AsBoolean;
  end;
end;

end.
