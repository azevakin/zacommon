unit ZeosCommonForm;

interface

uses
  Classes, Forms, DB, SysUtils, ZConnection, 
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZDbcIntfs;

type
  TParams = DB.TParams;

  TField = DB.TField;

  TZConnection = ZConnection.TZConnection;

  TZQuery = ZDataset.TZQuery;

  TZTransactIsolationLevel = ZDbcIntfs.TZTransactIsolationLevel;

  TZeosCommonFrm = class(TForm)
  private
    FConnection: TZConnection;
  protected
    procedure SetConnection(const Value: TZConnection); virtual;
    function NewQuery: TZQuery;
    function ExecQuery(const SQL: string; const Args: array of const): TZQuery; overload;
    function ExecQuery(const SQL: string): TZQuery; overload;
    function OpenQuery(const SQL: string; const Args: array of const): TZQuery; overload;
    function OpenQuery(const SQL: string): TZQuery; overload;
  public
    constructor Create(AOwner: TComponent; AConnection: TZConnection); reintroduce; virtual;
    function GetConnectOptions: string;
    procedure CheckUniqueConstraint(const e: Exception);
    property Connection: TZConnection read FConnection write SetConnection;
  end;


  TConnectOptions = class(TComponent)
  private
    FConnection: TZConnection;
    FIniFilename: string;
    function GetIniFilename: string;
  public
    constructor Create(AOwner: TComponent; AConnection: TZConnection); reintroduce; virtual;

    function LoadOptions(const withLogin: Boolean): Boolean;
    procedure SaveLogin;
    procedure SaveOptions;

    property Connection: TZConnection read FConnection write FConnection;
    property IniFilename: string read GetIniFilename;
  end;

  function EHasText(e: Exception; const text: string): Boolean;

implementation

uses Controls, IniFiles, ZeosConst;

{$R *.dfm}

const
  sec_connection = 'Connection';
  e_duplicate_unique_constraint = 'duplicate key';
  duplicate_unique_constraint = 'ОШИБКА: Попытка ввода дубликата.'#13'Запись с данными параметрами уже существует.';


function EHasText(e: Exception; const text: string): Boolean;
begin
  Result := Pos(AnsiLowerCase(text), AnsiLowerCase(e.Message)) > 0;
end;

{ TZeosCommonFrm }

constructor TZeosCommonFrm.Create(AOwner: TComponent;
  AConnection: TZConnection);
begin
  inherited Create(AOwner);
  Connection := AConnection;
end;

function TZeosCommonFrm.GetConnectOptions: string;
begin
  if Assigned(Connection) then
    with Connection do
      Result := Format('%s - %s:%d', [Database, HostName, Port]);
end;

procedure TZeosCommonFrm.SetConnection(const Value: TZConnection);
begin
  FConnection := Value;
end;

function TZeosCommonFrm.NewQuery: TZQuery;
begin
  Result := TZQuery.Create(Self);
  Result.Connection := Self.Connection;
end;

function TZeosCommonFrm.ExecQuery(const SQL: string; const Args: array of const): TZQuery;
var
  opt: TFormatSettings;
begin
  opt.DecimalSeparator := '.';
  Result := Self.NewQuery;
  Result.Sql.Add(Format(SQL, Args, opt));
  try
    Screen.Cursor := crHourGlass;
    try
      Application.ProcessMessages;
      Result.ExecSql;
    finally
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  except
    on e: Exception do
      CheckUniqueConstraint(e);
  end;
end;

function TZeosCommonFrm.ExecQuery(const SQL: string): TZQuery;
begin
  Result := ExecQuery(SQL, []);
end;

function TZeosCommonFrm.OpenQuery(const SQL: string; const Args: array of const): TZQuery;
begin
  Result := Self.NewQuery;
  Result.Sql.Add(Format(SQL, Args));
  try
    Screen.Cursor := crHourGlass;
    try
      Application.ProcessMessages;
      Result.Open;
    finally
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  except
    on e: Exception do
      CheckUniqueConstraint(e);
  end;
end;

function TZeosCommonFrm.OpenQuery(const SQL: string): TZQuery;
begin
  Result := OpenQuery(SQL, []);
end;

procedure TZeosCommonFrm.CheckUniqueConstraint(const e: Exception);
begin
  if Pos(e_duplicate_unique_constraint, e.Message) > 0 then
    raise Exception.Create(duplicate_unique_constraint)
  else
    raise Exception.Create(e.Message);
end;

{ TConnectOptions }

function TConnectOptions.GetIniFilename: string;
begin
  if FIniFilename = '' then
    Self.FIniFilename := ChangeFileExt(ParamStr(0), '.ini');

  Result := Self.FIniFilename;
end;

constructor TConnectOptions.Create(AOwner: TComponent;
  AConnection: TZConnection);
begin
  inherited Create(AOwner);
  FConnection := AConnection;
end;

function TConnectOptions.LoadOptions(const withLogin: Boolean): Boolean;
begin
  if FileExists(IniFilename) then
  with TIniFile.Create(IniFilename) do
  try
    if ValueExists(sec_connection, SProtocol) then
      Connection.Protocol := ReadString(sec_connection, SProtocol, Connection.Protocol);

    if ValueExists(sec_connection, SHostName) then
      Connection.HostName := ReadString(sec_connection, SHostName, Connection.HostName);

    if ValueExists(sec_connection, SDataBase) then
      Connection.Database := ReadString(sec_connection, SDataBase, Connection.Database);

    if ValueExists(sec_connection, SPort) then
      Connection.Port := ReadInteger(sec_connection, SPort, Connection.Port);

    if withLogin and ValueExists(sec_connection, SUser) then
      Connection.User := ReadString(sec_connection, SUser, Connection.User);
  finally
    Free;
  end;

  with Connection do
    Result := (HostName <> '') and (Database <> '') and (Port <> 0);
end;

procedure TConnectOptions.SaveLogin;
begin
  if Assigned(Connection) then
  with TIniFile.Create(IniFilename) do
  try
    WriteString(sec_connection, SUser, Connection.User);
  finally
    Free;
  end;
end;

procedure TConnectOptions.SaveOptions;
begin
  if Assigned(Connection) then
  with TIniFile.Create(IniFilename) do
  try
    WriteString(sec_connection, SProtocol, Connection.Protocol);
    WriteString(sec_connection, SHostName, Connection.HostName);
    WriteString(sec_connection, SDataBase, Connection.Database);
    WriteString(sec_connection, SUser, Connection.User);
  finally
    Free;
  end;
end;

end.
