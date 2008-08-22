unit ZAClasses;

interface

uses Classes, DB, ZConvert, ZPgSqlCon, ZPgSqlTr, ZPgSqlQuery;

type
  TRealValue = class;

  THashExtended = class(TStringList)
  private
    function GetByIndex(Index: Integer): TRealValue;
    function GetByKey(Key: string): TRealValue;
  public
    function Add(const S: string): Integer; override;
    function AddValue(const S: string; const Value: Extended): Integer;
    procedure ClearValues;
    property ByKey[Key: string]: TRealValue read GetByKey; default; // не менять
    property ByIndex[Index: Integer]: TRealValue read GetByIndex;
  end;

  THashInt = class(TStringList)
  private
    function GetByKey(const Key: string): Integer;
    procedure PutByKey(const Key: string; const Value: Integer);
    function GetByIndex(const Index: Integer): Integer;
    procedure PutByIndex(const Index, Value: Integer);
    function GetFirst: Integer;
    function GetLast: Integer;
    procedure SetFirst(const Value: Integer);
    procedure SetLast(const Value: Integer);
  public
    function Add(const Key: string): Integer; override;
    function AddValue(const Key: string; const Value: Integer): Integer;
    property ByKey[const Key: string]: Integer read GetByKey write PutByKey; default; // не менять
    property ByIndex[const Index: Integer]: Integer read GetByIndex write PutByIndex;
    property First: Integer read GetFirst write SetFirst;
    property Last: Integer read GetLast write SetLast;
  end;

  TIntList = class
  private
    FList: TList;
    function GetItem(Index: Integer): Integer;
    procedure SetItem(Index: Integer; const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: Integer): Integer;
    procedure Clear;
    function IndexOf(Item: Integer): Integer;
    function Count: Integer;
    property Items[Index: Integer]: Integer read GetItem write SetItem; default;
  end;

  TUniqueIntList = class
  private
    FList: TList;
    function ValueExists(const Value: Integer; out Index: Integer): Boolean;
    function GetItem(Index: Integer): Integer;
    procedure SetItem(Index: Integer; const Value: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Value: Integer): Integer; overload;
    function Add(Value: TField): Integer; overload;
    procedure Clear;
    function Count: Integer;
    property Items[Index: Integer]: Integer read GetItem write SetItem; default;
  end;

  TBoolValue = class
  public
    Value: Boolean;
    constructor Create(BValue: Boolean); overload;
    constructor Create(BValue: TField); overload;
  end;

  TRealValue = class
  public
    Value: Extended;
    constructor Create; overload;
    constructor Create(AValue: Extended); overload;
    constructor Create(AValue: TField); overload;
    procedure Clear;
    procedure IncValue(IncBy: Extended); overload;
    procedure IncValue(IncBy: TField); overload;
  end;

  TStrValue = class
  public
    Value: string;
    constructor Create(const AValue: string); overload;
    constructor Create(AValue: TField); overload;
    function Quoted: string;
  end;

  TID = class
  private
    FID: Integer;
    function GetAsString: string;
    procedure SetAsString(const Value: string);
  protected
    function GetID: Integer; virtual;
    procedure SetID(const Value: Integer); virtual;
  public
    constructor Create; overload; virtual;
    constructor Create(const iID: Integer); overload; virtual;
    constructor Create(const iID: TField); overload; virtual;

    property Id: Integer read GetID write SetID;
    property AsString: string read GetAsString write SetAsString;
  end;

  TIDs = class(TID)
  private
    IDs: array of Integer;
    function GetIDs(Index: Integer): Integer;
    procedure SetIDs(Index: Integer; const Value: Integer);
  protected
    function GetID: Integer; override;
    procedure SetID(const Value: Integer); override;
  public
    constructor Create(AIDs: array of Integer); reintroduce;
    property ID[Index: Integer]: Integer read GetIDs write SetIDs;
  end;

  TIDsPlus = class
  private
    IDs: array of Integer;
    Values: array of string;
    function GetID(Index: Integer): Integer;
    procedure SetID(Index: Integer; const AValue: Integer);
    function GetValue(Index: Integer): string;
    procedure SetValue(Index: Integer; const AValue: string);
  public
    constructor Create(AIDs: array of Integer; AValues: array of string);
    property ID[Index: Integer]: Integer read GetID write SetID;
    property Value[Index: Integer]: string read GetValue write SetValue;
  end;

  TParams = DB.TParams;

  TField = DB.TField;

  TZPgSqlTransact = ZPgSqlTr.TZPgSqlTransact;

  TZPgSqlQuery = ZPgSqlQuery.TZPgSqlQuery;

  TZPgSqlDatabase = ZPgSqlCon.TZPgSqlDatabase;

  TPgSqlClass = class
  protected
    function NewQuery: TZPgSqlQuery;
    function ExecQuery(const SQL: string; const Args: array of const): TZPgSqlQuery; overload;
    function ExecQuery(const SQL: string): TZPgSqlQuery; overload;
    function OpenQuery(const SQL: string; const Args: array of const): TZPgSqlQuery; overload;
    function OpenQuery(const SQL: string): TZPgSqlQuery; overload;
  public
    Transaction: TZPgSqlTransact;
    constructor Create(ATransaction: TZPgSqlTransact); virtual;
  end;


implementation

uses SysUtils, ZQuery, RTLConsts;

{ TBool }

constructor TBoolValue.Create(BValue: Boolean);
begin
  Value := BValue
end;

constructor TBoolValue.Create(BValue: TField);
begin
  Value := BValue.AsBoolean;
end;

{ TID }

constructor TID.Create(const iID: Integer);
begin
  Id := iID;
end;

constructor TID.Create(const iID: TField);
begin
  Id := iID.AsInteger;
end;

function TID.GetAsString: string;
begin
  Result := IntToStr(Id);
end;

constructor TID.Create;
begin
  Id := 0;
end;

function TID.GetID: Integer;
begin
  Result := FID;
end;

procedure TID.SetAsString(const Value: string);
begin
  Id := StrToInt(Value);
end;

procedure TID.SetID(const Value: Integer);
begin
  FID := Value;
end;

{ TPgSqlClass }

constructor TPgSqlClass.Create(ATransaction: TZPgSqlTransact);
begin
  Transaction := ATransaction;
end;

function TPgSqlClass.ExecQuery(const SQL: string;
  const Args: array of const): TZPgSqlQuery;
begin
  Result := NewQuery;
  Result.Sql.Add(Format(SQL, Args));
  try
    Result.ExecSql;
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TPgSqlClass.ExecQuery(const SQL: string): TZPgSqlQuery;
begin
  Result := ExecQuery(SQL, []);
end;

function TPgSqlClass.NewQuery: TZPgSqlQuery;
begin
  Result := TZPgSqlQuery.Create(nil);
  Result.Database := Transaction.Database;
  Result.Transaction := Transaction;
  Result.Options := Result.Options-[doHourGlass];
end;

function TPgSqlClass.OpenQuery(const SQL: string;
  const Args: array of const): TZPgSqlQuery;
begin
  Result := NewQuery;
  Result.Sql.Add(Format(SQL, Args));
  try
    Result.Open;
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TPgSqlClass.OpenQuery(const SQL: string): TZPgSqlQuery;
begin
  Result := OpenQuery(SQL, []);
end;

{ TIDs }

constructor TIDs.Create(AIDs: array of Integer);
var
  i: Integer;
begin
  try
    SetLength(IDs, Length(AIDs));
    for i := Low(AIDs) to High(AIDs)
      do IDs[i] := AIDs[i];
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TIDs.GetID: Integer;
begin
  try
    Result := ID[0];
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TIDs.GetIDs(Index: Integer): Integer;
begin
  try
    Result := IDs[Index];
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

procedure TIDs.SetID(const Value: Integer);
begin
  try
    ID[0] := Value;
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

procedure TIDs.SetIDs(Index: Integer; const Value: Integer);
begin
  try
    IDs[Index] := Value;
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

{ TIDsPlus }

constructor TIDsPlus.Create(AIDs: array of Integer;
  AValues: array of string);
var
  i: Integer;
begin
  try
    SetLength(IDs, Length(AIDs));
    for i := Low(AIDs) to High(AIDs)
      do IDs[i] := AIDs[i];

    SetLength(Values, Length(AValues));
    for i := Low(AValues) to High(AValues)
      do Values[i] := AValues[i];
  except
    on e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

function TIDsPlus.GetID(Index: Integer): Integer;
begin
  Result := IDs[Index];
end;

function TIDsPlus.GetValue(Index: Integer): string;
begin
  Result := Values[Index];
end;

procedure TIDsPlus.SetID(Index: Integer; const AValue: Integer);
begin
  IDs[Index] := AValue;
end;

procedure TIDsPlus.SetValue(Index: Integer; const AValue: string);
begin
  Values[Index] := AValue;
end;

{ TFloatValue }

procedure TRealValue.Clear;
begin
  Value := 0;
end;

constructor TRealValue.Create(AValue: TField);
begin
  Value := AValue.AsFloat;
end;

constructor TRealValue.Create(AValue: Extended);
begin
  Value := AValue;
end;

constructor TRealValue.Create;
begin
  Clear;
end;

procedure TRealValue.IncValue(IncBy: TField);
begin
  Value := Value + IncBy.AsFloat;
end;

procedure TRealValue.IncValue(IncBy: Extended);
begin
  Value := Value + IncBy;
end;

{ TIntList }

function TIntList.Add(Item: Integer): Integer;
begin
  Result := FList.Add(TID.Create(Item));
end;

procedure TIntList.Clear;
begin
  FList.Clear;
end;

constructor TIntList.Create;
begin
  FList := TList.Create;
end;

destructor TIntList.Destroy;
begin
  FList.Destroy;
  inherited;
end;

function TIntList.Count: Integer;
begin
  Result := FList.Count;
end;

function TIntList.GetItem(Index: Integer): Integer;
begin
  Result := TID(FList[Index]).Id;
end;

function TIntList.IndexOf(Item: Integer): Integer;
begin
  Result := 0;
  while (Result < Count) and (Items[Result] <> Item) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

procedure TIntList.SetItem(Index: Integer; const Value: Integer);
begin
  TID(FList[Index]).Id := Value;
end;

{ TUniqueIntList }

function TUniqueIntList.Add(Value: Integer): Integer;
begin
  if not ValueExists(Value, Result) then
    Result := FList.Add(TID.Create(Value));
end;

function TUniqueIntList.Add(Value: TField): Integer;
begin
  Result := Self.Add(Value.AsInteger);
end;

procedure TUniqueIntList.Clear;
begin
  FList.Clear;
end;

function TUniqueIntList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TUniqueIntList.Create;
begin
  FList := TList.Create;
end;

destructor TUniqueIntList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TUniqueIntList.GetItem(Index: Integer): Integer;
begin
  Result := TID(FList[Index]).Id;
end;

procedure TUniqueIntList.SetItem(Index: Integer; const Value: Integer);
begin
  TID(FList[Index]).Id := Value;
end;

function TUniqueIntList.ValueExists(const Value: Integer; out Index: Integer): Boolean;
begin
  Result := False;
  Index := 0;
  if Count > 0 then
    while (Index < Count) do
    begin
      Result := Items[Index] = Value;
      if Result then
        Break
      else
        Inc(Index);
    end;
end;

{ TStrValue }

constructor TStrValue.Create(const AValue: string);
begin
  Value := AValue;
end;

constructor TStrValue.Create(AValue: TField);
begin
  Value := AValue.AsString;
end;

function TStrValue.Quoted: string;
begin
  Result := QuotedStr(Value);
end;

{ TStringListExt }

function THashExtended.Add(const S: string): Integer;
begin
  Result := Self.AddObject(S, TRealValue.Create);
end;

function THashExtended.AddValue(const S: string;
  const Value: Extended): Integer;
begin
  Result := Self.AddObject(S, TRealValue.Create(Value));
end;

procedure THashExtended.ClearValues;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    ByIndex[i].Clear;
end;

function THashExtended.GetByKey(Key: string): TRealValue;
begin
  Result := TRealValue(Objects[IndexOf(Key)]);
end;

function THashExtended.GetByIndex(Index: Integer): TRealValue;
begin
  Result := TRealValue(Objects[Index]);
end;

{ THashInt }

function THashInt.Add(const Key: string): Integer;
begin
  Result := Self.AddObject(Key, TID.Create);
end;

function THashInt.AddValue(const Key: string;
  const Value: Integer): Integer;
begin
  Result := Self.AddObject(Key, TID.Create(Value));
end;

function THashInt.GetFirst: Integer;
begin
  Result := ByIndex[0];
end;

function THashInt.GetLast: Integer;
begin
  Result := ByIndex[Count-1];
end;

function THashInt.GetByIndex(const Index: Integer): Integer;
begin
  Result := TID(Objects[ Index ]).Id;
end;

function THashInt.GetByKey(const Key: string): Integer;
begin
  Result := TID(Objects[IndexOf(Key)]).Id;
end;

procedure THashInt.PutByIndex(const Index, Value: Integer);
begin
  TID(Objects[ Index ]).Id := Value;
end;

procedure THashInt.PutByKey(const Key: string;
  const Value: Integer);
begin
  TID(Objects[IndexOf(Key)]).Id := Value;
end;

procedure THashInt.SetFirst(const Value: Integer);
begin
  ByIndex[0] := Value;
end;

procedure THashInt.SetLast(const Value: Integer);
begin
  ByIndex[Count-1] := Value;
end;

end.
