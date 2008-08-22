unit ZAStdCtrlsUtils;

interface

uses Classes, StdCtrls, ZAClasses;

type
  TCustomEdits = array of TCustomEdit;

  function IsEmpty(Value: TCustomEdit): Boolean; overload;
  function IsEmpty(Value: TMemo): Boolean; overload;

  function IsEqual(Value: TMemo; text: string): Boolean; overload;
  function IsEqual(Value: TCustomEdit; text: string): Boolean; overload;

  procedure initCustomEdits(var value: TCustomEdits; const len: Integer);

  procedure setIndex(cb: TComboBox; const index: Integer); overload;
  procedure setIndex(cb: TComboBox; obj: TObject); overload;
  procedure setIndex(cb: TComboBox; const str: string); overload;
  procedure setIndexByID(cb: TCustomComboBox; const ID: Integer); overload;

  function selectedObject(cb: TComboBox): TObject;
  function selectedText(cb: TComboBox): string;


implementation

uses SysUtils, ZAConst;

function IsEmpty(Value: TCustomEdit): Boolean;
begin
  Result := isEqual(Value, SNull);
end;

function IsEmpty(Value: TMemo): Boolean;
begin
  Result := isEqual(Value, SNull);
end;

function IsEqual(Value: TCustomEdit; text: string): Boolean;
begin
  Result := Trim(Value.Text) = text;
end;

function IsEqual(Value: TMemo; text: string): Boolean;
begin
  Result := Trim(Value.Lines.Text) = text;
end;

procedure initCustomEdits(var value: TCustomEdits; const len: Integer);
begin
  SetLength(value, len);
end;

procedure setIndex(cb: TComboBox; const index: Integer);
begin
  cb.ItemIndex := index;
end;

procedure setIndex(cb: TComboBox; obj: TObject);
begin
  cb.ItemIndex := cb.Items.IndexOfObject(obj);
end;

procedure setIndex(cb: TComboBox; const str: string);
begin
  cb.ItemIndex := cb.Items.IndexOf(str);
end;

procedure setIndexByID(cb: TCustomComboBox; const ID: Integer);
var
  i: Integer;
begin
  for i := 0 to cb.Items.Count-1 do
    if TID(cb.Items.Objects[i]).Id = ID then
    begin
      cb.ItemIndex := i;
      Break;
    end;
end;

function selectedObject(cb: TComboBox): TObject;
begin
  Result := cb.Items.Objects[cb.ItemIndex];
end;

function selectedText(cb: TComboBox): string;
begin
  Result := cb.Items[cb.ItemIndex];
end;

end.
