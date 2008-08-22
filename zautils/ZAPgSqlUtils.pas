unit ZAPgSqlUtils;

interface

uses Classes, ZPgSqlTr, ZPgSqlQuery;

  function NewQuery(Transaction: TZPgSqlTransact; AOwner: TComponent = nil): TZPgSqlQuery;
  function ChkDateTime(Transaction: TZPgSqlTransact): Boolean;

  // копирует настройки Source в Destination
  procedure CopyQueryOptions(Source, Destination: TZPgSqlQuery);

implementation

uses ZQuery, Windows, SysUtils;

function NewQuery(Transaction: TZPgSqlTransact; AOwner: TComponent = nil): TZPgSqlQuery;
begin
  Result := TZPgSqlQuery.Create(AOwner);
  Result.Database := Transaction.Database;
  Result.Transaction := Transaction;
  Result.Options := Result.Options - [doHourGlass];
end;

// синхронизирует дату и время с сервером
function ChkDateTime(Transaction: TZPgSqlTransact): Boolean;
var
  ServerTime: TSystemTime;
  SystemTime: TSystemTime;

  function is_equal: Boolean;
  begin
    Result := (ServerTime.wYear = SystemTime.wYear) and
              (ServerTime.wMonth = SystemTime.wMonth) and
              (ServerTime.wDay = SystemTime.wDay) and
              (ServerTime.wHour = SystemTime.wHour) and
              (ServerTime.wMinute = SystemTime.wMinute);
  end;

begin
  Result := False;
  with NewQuery(Transaction) do
  try
    Sql.Text := 'select now()';
    Open;
    DateTimeToSystemTime(Fields[0].AsDateTime, ServerTime);
    GetLocalTime(SystemTime);
    if not is_equal then
    begin
      SetLocalTime(ServerTime);
      Result := True;
    end;
  finally
    Free;
  end;
end;


procedure CopyQueryOptions(Source, Destination: TZPgSqlQuery);
begin
  Destination.Database    := Source.Database;
  Destination.Transaction := Source.Transaction;
  Destination.Options     := Source.Options;
end;

end.