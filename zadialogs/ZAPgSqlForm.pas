unit ZAPgSqlForm;

interface

uses
  Classes, Forms, DB, ZConvert, ZPgSqlCon, ZPgSqlTr, ZPgSqlQuery, SysUtils;

type
  TQueryRec = record
    Data: TZPgSqlQuery;
    FreeQuery: Boolean;
  end;

  TParams = DB.TParams;

  TField = DB.TField;

  TZPgSqlTransact = ZPgSqlTr.TZPgSqlTransact;

  TZPgSqlQuery = ZPgSqlQuery.TZPgSqlQuery;

  TZPgSqlDatabase = ZPgSqlCon.TZPgSqlDatabase;

  TEncodingType = ZConvert.TEncodingType;

  TPgSqlForm = class(TForm)
  private
    FTransaction: TZPgSqlTransact;
  protected
    function NewQuery: TZPgSqlQuery;
    function ExecQuery(const SQL: string; const Args: array of const): TZPgSqlQuery; overload;
    function ExecQuery(const SQL: string): TZPgSqlQuery; overload;
    function OpenQuery(const SQL: string; const Args: array of const): TZPgSqlQuery; overload;
    function OpenQuery(const SQL: string): TZPgSqlQuery; overload;
    function OpenQuery(const SQL: string; const Args: array of const; const FreeQuery: Boolean): TQueryRec; overload;
    function OpenQuery(const SQL: string; const FreeQuery: Boolean): TQueryRec; overload;
    procedure SetTransaction(const tr: TZPgSqlTransact); virtual;
  public
    constructor Create(AOwner: TComponent; ATransaction: TZPgSqlTransact); reintroduce; virtual;

    function GetConnectOptions: string;

    property Transaction: TZPgSqlTransact read FTransaction write SetTransaction;
  end;


  TConnectOptions = class(TComponent)
  private
    FTransaction: TZPgSqlTransact;
    FRegistryKey: string;
    FIniFilename: string;
    procedure SetTransaction(const Value: TZPgSqlTransact);
    procedure SetRegistryKey(const Value: string);
  public
    constructor Create(AOwner: TComponent; ATransaction: TZPgSqlTransact); reintroduce; virtual;

    function IniFilename: string;
    function LoadOptions(const withLogin: Boolean): Boolean;
    procedure SaveLogin;
    procedure SaveOptions;

    property RegistryKey: string read FRegistryKey write SetRegistryKey;
    property Transaction: TZPgSqlTransact read FTransaction write SetTransaction;
  end;

  function ConnectOptionsKey(const ApplicationKey: string; const NewStyle: Boolean=False): string;
  function EHasText(e: Exception; const text: string): Boolean;
  function QueryRec(const Query: TZPgSqlQuery; const FreeQuery: Boolean = False): TQueryRec;

implementation

uses ZQuery, ZAConst, Registry, Controls, IniFiles;

{$R *.dfm}

const
  sec_connection = 'Connection';

function ConnectOptionsKey(const ApplicationKey: string; const NewStyle: Boolean=False): string;
const
  key: array[Boolean] of string = ('Connect options', '��������� �����������');
begin
  Result := ApplicationKey + '\' + key[NewStyle];
end;

function EHasText(e: Exception; const text: string): Boolean;
begin
  Result := Pos(AnsiLowerCase(text), AnsiLowerCase(e.Message)) > 0;
end;

function QueryRec(const Query: TZPgSqlQuery; const FreeQuery: Boolean = False): TQueryRec;
begin
  Result.Data := Query;
  Result.FreeQuery := FreeQuery;
end;

{ TPgSqlForm }

const
  e_duplicate_unique_constraint = 'duplicate key';
  duplicate_unique_constraint = '������: ������� ����� ���������.'#13'������ � ������� ����������� ��� ����������.';

constructor TPgSqlForm.Create(AOwner: TComponent;
  ATransaction: TZPgSqlTransact);
begin
  Transaction := ATransaction;
  inherited Create(AOwner);
end;

function TPgSqlForm.GetConnectOptions: string;
begin
  if Assigned(FTransaction) then
    with FTransaction.Database do
      Result := Format('%s - %s:%s', [Database, Host, Port]);
end;

function TPgSqlForm.NewQuery: TZPgSqlQuery;
begin
  Result := TZPgSqlQuery.Create(Self);
  Result.Database := FTransaction.Database;
  Result.Transaction := FTransaction;
  Result.Options := Result.Options-[doHourGlass];
end;

function TPgSqlForm.ExecQuery(const SQL: string; const Args: array of const): TZPgSqlQuery;
var
  opt: TFormatSettings;
begin
  opt.DecimalSeparator := '.';
  Result := NewQuery;
  Result.Sql.Add(Format(SQL, Args, opt));
  try
    Screen.Cursor := crHourGlass;
    try
      Application.ProcessMessages;
      Result.Transaction.StartTransaction;
      Application.ProcessMessages;
      Result.ExecSql;
      Application.ProcessMessages;
    finally
      Screen.Cursor := crDefault;
    end;
  except
    on e: Exception do
    begin
      Result.Transaction.Rollback;
      if Pos(e_duplicate_unique_constraint, e.Message) > 0 then
        raise Exception.Create(duplicate_unique_constraint)
      else
        raise Exception.Create(e.Message);
    end;
  end;
end;

function TPgSqlForm.ExecQuery(const SQL: string): TZPgSqlQuery;
begin
  Result := ExecQuery(SQL, []);
end;

function TPgSqlForm.OpenQuery(const SQL: string; const Args: array of const): TZPgSqlQuery;
begin
  Result := NewQuery;
  Result.Sql.Add(Format(SQL, Args));
  try
    Screen.Cursor := crHourGlass;
    try
      Application.ProcessMessages;
      Result.Transaction.StartTransaction;
      Application.ProcessMessages;
      Result.Open;
      Application.ProcessMessages;
    finally
      Screen.Cursor := crDefault;
    end;
  except
    on e: Exception do
    begin
      Result.Transaction.Rollback;
      if Pos(e_duplicate_unique_constraint, e.Message) > 0 then
        raise Exception.Create(duplicate_unique_constraint)
      else
        raise Exception.Create(e.Message);
    end;
  end;
end;

function TPgSqlForm.OpenQuery(const SQL: string): TZPgSqlQuery;
begin
  Result := OpenQuery(SQL, []);
end;

procedure TPgSqlForm.SetTransaction(const tr: TZPgSqlTransact);
begin
  if FTransaction <> tr then
    FTransaction := tr;
end;

function TPgSqlForm.OpenQuery(const SQL: string;
  const Args: array of const; const FreeQuery: Boolean): TQueryRec;
begin
  Result.Data := Self.OpenQuery(SQL, Args);
  Result.FreeQuery := FreeQuery;
end;

function TPgSqlForm.OpenQuery(const SQL: string;
  const FreeQuery: Boolean): TQueryRec;
begin
  Result := Self.OpenQuery(SQL, [], FreeQuery);
end;

{ TConnectOptions }

function TConnectOptions.IniFilename: string;
begin
  if FIniFilename = '' then
    Self.FIniFilename := ChangeFileExt(ParamStr(0), '.ini');

  Result := Self.FIniFilename;
end;

constructor TConnectOptions.Create(AOwner: TComponent;
  ATransaction: TZPgSqlTransact);
begin
  inherited Create(AOwner);
  Transaction := ATransaction;
end;

function TConnectOptions.LoadOptions(const withLogin: Boolean): Boolean;
const
  ArrayOfResults: array[0..2] of Boolean = (False, False, True);
var
  Count: Integer;
begin
  Count := Zero;
  if Assigned(FTransaction) and (FRegistryKey <> SNull) then
  with TRegistry.Create do
  try
    if OpenKey(FRegistryKey, False) then
    begin
      if ValueExists(SHost) then
      begin
        Inc(Count);
        FTransaction.Database.Host := ReadString(SHost);
      end;

      if ValueExists(SDataBase) then
      begin
        Inc(Count);
        FTransaction.Database.Database := ReadString(SDataBase);
      end;

      if ValueExists(SPort) then
        FTransaction.Database.Port := ReadString(SPort);

      if withLogin and ValueExists(SLogin) then
        FTransaction.Database.Login := ReadString(SLogin);
    end;
  finally
    Free;
  end
  else
  begin
    if FileExists(IniFilename) then
    with TIniFile.Create(IniFilename) do
    try
      if ValueExists(sec_connection, SHost) then
      begin
        Inc(Count);
        FTransaction.Database.Host := ReadString(sec_connection, SHost, '');
      end;

      if ValueExists(sec_connection, SDataBase) then
      begin
        Inc(Count);
        FTransaction.Database.Database := ReadString(sec_connection, SDataBase, '');
      end;

      if ValueExists(sec_connection, SPort) then
        FTransaction.Database.Port := ReadString(sec_connection, SPort, '');

      if withLogin and ValueExists(sec_connection, SLogin) then
        FTransaction.Database.Login := ReadString(sec_connection, SLogin, '');
    finally
      Free;
    end;
  end;
  Result := ArrayOfResults[Count];
end;

procedure TConnectOptions.SaveLogin;
begin
  if Assigned(FTransaction) and (FRegistryKey <> SNull) then
  with TRegistry.Create do
  try
    if OpenKey(FRegistryKey, True) then
      WriteString(SLogin, FTransaction.Database.Login);
  finally
    Free;
  end
  else
  begin
    with TIniFile.Create(IniFilename) do
    try
      WriteString(sec_connection, SLogin, FTransaction.Database.Login);
    finally
      Free;
    end;
  end;
end;

procedure TConnectOptions.SaveOptions;
begin
  if Assigned(FTransaction) then
  begin
    if (FRegistryKey <> SNull) then
    with TRegistry.Create do
    try
      if OpenKey(FRegistryKey, True) then
      begin
        WriteString(SHost, FTransaction.Database.Host);
        WriteString(SDataBase, FTransaction.Database.Database);
        WriteString(SPort, FTransaction.Database.Port);
      end;
    finally
      Free;
    end
    else
    begin
      with TIniFile.Create(IniFilename) do
      try
        WriteString(sec_connection, SHost, FTransaction.Database.Host);
        WriteString(sec_connection, SDataBase, FTransaction.Database.Database);
        WriteString(sec_connection, SPort, FTransaction.Database.Port);
      finally
        Free;
      end;
    end;
  end;
end;

procedure TConnectOptions.SetRegistryKey(const Value: string);
begin
  if FRegistryKey <> Value then
    FRegistryKey := Value;
end;

procedure TConnectOptions.SetTransaction(const Value: TZPgSqlTransact);
begin
  if FTransaction <> Value then
    FTransaction := Value;
end;

end.
