{********************************************************}
{                                                        }
{                 Zeos Database Objects                  }
{                Sybase SQL direct class API             }
{                                                        }
{       Copyright (c) 1999-2001 Sergey Seroukhov         }
{    Copyright (c) 1999-2002 Zeos Development Group      }
{                                                        }
{********************************************************}

unit ZDirSySql;

interface

uses SysUtils, Classes, ZDirSql, ZLibSySql, Db, ZTransact, ZSqlTypes, ZSqlExtra, {Sybase32,} dialogs,
  Windows {$IFDEF VER100}, DbTables{$ENDIF};

{$IFNDEF LINUX}
{$INCLUDE ..\Zeos.inc}
{$ELSE}
{$INCLUDE ../Zeos.inc}
{$ENDIF}

type
  { Direct  Sybase Sql connection }
  TDirSySQLConnect = class (TDirConnect)
  protected
    function GetErrorMsg: ShortString; override;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Connect; override;
    procedure Disconnect; override;
    procedure CreateDatabase(Params: string); override;
    procedure DropDatabase; override;
  end;

  { Direct Sybase Sql transaction }
  TDirSySQLTransact = class (TDirTransact)
  private
    FHandle: PDBPROCESS;
    FLoginRec: PLOGINREC;
  protected
    function GetErrorMsg: ShortString; override;
  public
    constructor Create(AConnect: TDirSySQLConnect);
    destructor Destroy; override;

    procedure Open; override;
    procedure Close; override;
    procedure StartTransaction; override;
    procedure EndTransaction; override;
    procedure Commit; override;
    procedure Rollback; override;

    property Handle: PDBPROCESS read FHandle;
    property LoginRec: PLOGINREC read FLoginRec;
  end;

  { Direct Sybsae Sql query }
  TDirSySQLQuery = class (TDirQuery)
  protected
    function GetErrorMsg: ShortString; override;
  public
    constructor Create(AConnect: TDirSySQLConnect; ATransact: TDirSySQLTransact);

    function  Execute: LongInt; override;

    procedure Open; override;
    procedure Close; override;
//    function  CreateBlobObject: TDirBlob; override;

    procedure ShowDatabases(DatabaseName: ShortString); override;
    procedure ShowTables(TableName: ShortString); override;
    procedure ShowColumns(TableName, ColumnName: ShortString); override;
    procedure ShowIndexes(TableName: ShortString); override;

    procedure Next; override;

    function  FieldCount: Integer; override;
    function  RecordCount: Integer; override;

    function  FieldName(FieldNum: Integer): ShortString; override;
    function  FieldSize(FieldNum: Integer): Integer; override;
    function  FieldMaxSize(FieldNum: Integer): Integer; override;
    function  FieldType(FieldNum: Integer): Integer; override;
    function  FieldDataType(FieldNum: Integer): TFieldType; override;
    function  FieldIsNull(FieldNum: Integer): Boolean; override;
    function  Field(FieldNum: Integer): string; override;
    function  FieldBuffer(FieldNum: Integer): PChar; override;

    function StringToSql(Value: string): string; override;
  end;

  { Sybase SQL stored proc }
  TDirSySQLStoredProc = class(TDirStoredProc)
  private
    procedure BindParam(Param: TParam);
  protected
    function GetErrorMsg: ShortString; override;
  public
    constructor Create(AConnect: TDirSySQLConnect; ATransact: TDirSySQLTransact);

    procedure Prepare(Params: TParams); override;
    procedure UnPrepare; override;
    procedure ExecProc; override;
    procedure Open; override;
    procedure Close; override;
//    function  CreateBlobObject: TDirBlob; override;
    function GetReturnValue: string; override;

    procedure ShowStoredProcs; override;
    procedure ShowParams(StoredProcedureName: ShortString); override;

    procedure Next; override;

    function FieldCount: Integer; override;
    function RecordCount: Integer; override;
    function ParamCount: Integer; override;

    function FieldName(FieldNum: Integer): ShortString; override;
    function FieldSize(FieldNum: Integer): Integer; override;
    function FieldMaxSize(FieldNum: Integer): Integer; override;
    function FieldType(FieldNum: Integer): Integer; override;
    function FieldDataType(FieldNum: Integer): TFieldType; override;
    function FieldIsNull(FieldNum: Integer): Boolean; override;
    function Field(FieldNum: Integer): string; override;
    function FieldBuffer(FieldNum: Integer): PChar; override;

    { All param functions deal with returnparameters only }
    function ParamName(ParamNum: Integer): ShortString; override;
    function ParamSize(ParamNum: Integer): Integer; override;
    function ParamMaxSize(ParamNum: Integer): Integer; override;
    function ParamType(ParamNum: Integer): Integer; override;
    function ParamDataType(ParamNum: Integer): TFieldType; override;
    function ParamIsNull(ParamNum: Integer): Boolean; override;
    function Param(ParamNum: Integer): string; override;
    function ParamBuffer(ParamNum: Integer): PChar; override;

    function StringToSql(Value: string): string; override;
  end;

const
  { SySQL ParamTypes }
  SQL_PARAM_TYPE_UNKNOWN = 0;
  SQL_PARAM_TYPE_INPUT = 1;
  SQL_PARAM_TYPE_OUTPUT = 2;
  SQL_RESULT_COL = 3;
  SQL_PARAM_OUTPUT = 4;
  SQL_RETURN_VALUE =5;


{ SySQLToDelphiParamType translates a SySQL ParamType to a Delphi ParamType
  pre:   Value=SySQL ParamType to translate
  post:  Result=Delphi ParamType }
function SySQLToDelphiParamType(Value: Integer): TParamType;
function DelphiToSySQLType(const DelphiType: TFieldType): Integer;

{ Convert Sybase SQL field type to delphi field type }
function SySQLToDelphiType(Value: Integer): TFieldType;

{ Convert Sybase SQL field types description to delphi field types }
function SySQLToDelphiTypeDesc(Value: string): TFieldType;

{ Monitor list }
var MonitorList: TZMonitorList;

implementation

uses ZDBaseConst, ZExtra;

{***************** TDirSySQLConnect implementation *****************}

{ Class constructor }
constructor TDirSySQLConnect.Create;
begin
  inherited Create;
  Port := '1433';
end;

{ Class destructor }
destructor TDirSySQLConnect.Destroy;
begin
  inherited Destroy;
end;

{ Get an error message }
function TDirSySQLConnect.GetErrorMsg: ShortString;
begin
  if Status <> csOk then
  begin
    Result := dbsqlerror;
    if StrCmpBegin(Result, 'General SQL Server error') then
      Result := dbmessage;
  end else
    Result := '';
end;

{ Connect to database }
procedure TDirSySQLConnect.Connect;
begin
  inherited Connect;
  if hDll = 0 then SySQLLoadLib;
  dbinit;

  SetStatus(csOk);
  SetActive(True);
end;

{ Disconnect from database }
procedure TDirSySQLConnect.Disconnect;
begin
  SetStatus(csOk);
  SetActive(False);
end;

{ Create and connect to database }
procedure TDirSySQLConnect.CreateDatabase(Params: string);
var
  FHandle: PDBPROCESS;
  FLoginRec: PLOGINREC;
  Temp: string;
  Buffer: string;
begin
  if Active then Disconnect;
  if hDll = 0 then SySQLLoadLib;
  SetStatus(csFail);

  { creating Login struct }
  FLoginRec := dbLogin;
  if FLoginRec = nil then
  begin
    MonitorList.InvokeEvent(Format('CONNECT %s',[Database]), Error, True);
    Exit;
  end;
  Temp := Login;
  if dbsetluser(FLoginRec,PChar(Temp)) = DBFAIL then
  begin
    dbfreelogin(FLoginRec);
    MonitorList.InvokeEvent(Format('CONNECT %s',[Database]), Error, True);
    Exit;
  end;
  Temp := Passwd;
  if dbsetlpwd(FLoginRec,PChar(Temp)) = DBFAIL then
  begin
    dbfreelogin(FLoginRec);
    MonitorList.InvokeEvent(Format('CONNECT %s',[Database]), Error, True);
    Exit;
  end;
  dbsetlapp(FLoginRec, PChar(ExtractFileName(ParamStr(0))));
  Temp := HostName;
  { connect to the server }
  FHandle := ZlibSySql.dbopen(FLoginRec, PChar(Temp));
  if FHandle <> nil then
  begin
    { must use master-table }
    dbuse(FHandle, 'Master');
    Buffer := 'CREATE DATABASE '+Database+' '+Params;
    dbcmd(FHandle, PChar(Buffer));
    dbsqlexec(FHandle);
    if dbresults(FHandle) <> DBFAIL then
    begin
      MonitorList.InvokeEvent(Buffer, 'OK.', False);
      SetStatus(csOK);
    end
    else
      MonitorList.InvokeEvent(Buffer, Error, True);
    ZlibSySql.dbclose(FHandle);
  end
  else
    MonitorList.InvokeEvent(Format('CONNECT %s',[Database]), Error, True);

  dbfreelogin(FLoginRec);
end;

{ Drop current database }
procedure TDirSySQLConnect.DropDatabase;
var
  FHandle: PDBPROCESS;
  FLoginRec: PLOGINREC;
  Temp: string;
  Buffer: string;
begin
  if Active then Disconnect;
  if hDll = 0 then SySQLLoadLib;
  dbinit();
  SetStatus(csFail);

  { creating Login struct }
  FLoginRec := dbLogin;
  if FLoginRec = nil then
  begin
    MonitorList.InvokeEvent(Format('CONNECT %s',[Database]), Error, True);
    Exit;
  end;
  Temp := Login;
  if dbsetluser(FLoginRec,PChar(Temp)) = DBFAIL then
  begin
    dbfreelogin(FLoginRec);
    MonitorList.InvokeEvent(Format('CONNECT %s',[Database]), Error, True);
    Exit;
  end;
  Temp := Passwd;
  if dbsetlpwd(FLoginRec,PChar(Temp)) = DBFAIL then
  begin
    dbfreelogin(FLoginRec);
    MonitorList.InvokeEvent(Format('CONNECT %s',[Database]), Error, True);
    Exit;
  end;
  dbsetlapp(FLoginRec,PChar(ExtractFileName(ParamStr(0))));
  Temp := HostName;
  { connect to the server }
  FHandle := ZlibSySql.dbopen(FLoginRec, PChar(Temp));
  if FHandle <> nil then
  begin
    { must use master-table }
    dbuse(FHandle, 'Master');
    Buffer := 'DROP DATABASE ' + Database;
    dbcmd(FHandle, PChar(Buffer));
    dbsqlexec(FHandle);
    if dbresults(FHandle) <> DBFAIL then
    begin
      MonitorList.InvokeEvent(Buffer, 'OK.', False);
      SetStatus(csOK);
    end
    else
      MonitorList.InvokeEvent(Buffer, Error, True);
    ZlibSySql.dbclose(FHandle);
  end
  else
    MonitorList.InvokeEvent(Format('CONNECT %s', [Database]), Error, True);

  dbfreelogin(FLoginRec);
end;

{ Class constructor }
constructor TDirSySQLTransact.Create(AConnect: TDirSySQLConnect);
begin
  inherited Create;
  Connect := AConnect;
  FHandle := nil;
  FLoginRec := nil;
end;

{ Class destructor }
destructor TDirSySQLTransact.Destroy;
begin
  inherited Destroy;
end;

{ Get error message }
function TDirSySQLTransact.GetErrorMsg: ShortString;
begin
  if Status <> csOk then
  begin
    Result := dbsqlerror;
    if StrCmpBegin(Result, 'General SQL Server error') then
      Result := dbmessage;
  end else
    Result := '';
end;

{ Disconnect from database }
procedure TDirSySQLTransact.Open;
label
  ErrorProc;
var
  Temp: string;
begin
  inherited Open;
  SetStatus(csFail);
  if not Assigned(Connect) or not Connect.Active then
    Exit;

  { Allocate login record }
  FLoginRec := dblogin;
  if FLoginRec = nil then
    goto ErrorProc;
  { Setup login record }
  // mjd - added following "dbsetlhost" statements to ensure proper hostname
  Temp := Connect.hostname;
  if dbsetlhost(FLoginRec, PChar(Temp) ) = DBFAIL then
  begin
    dbfreelogin(FLoginRec);
    goto errorproc;
  end;
  // mjd - added previous "dbsetlhost" statements to ensure proper hostname
  Temp := Connect.Login;
  if dbsetluser(FLoginRec, PChar(Temp)) = DBFAIL then
  begin
    dbfreelogin(FLoginRec);
    goto ErrorProc;
  end;
  Temp := Connect.Passwd;
  if dbsetlpwd(FLoginRec, PChar(Temp)) = DBFAIL then
  begin
    dbfreelogin(FLoginRec);
    goto ErrorProc;
  end;
  dbsetlapp(FLoginRec, PChar(ExtractFileName(ParamStr(0))));
  { Connect to database }
  Temp := Connect.HostName;
  FHandle := ZlibSySql.dbopen(FLoginRec, PChar(Temp));
  if FHandle <> nil then
  begin
    dbsetopt(FHandle, DBTEXTLIMIT, '2147483647',2147483647 ); // mjd - added numeric value of the text string
    dbsetopt(FHandle, DBTEXTSIZE, '2147483647', 2147483647); // mjd - added numeric value of the text string
    dbsqlexec(FHandle);
    while dbresults(FHandle) = DBSUCCEED do;

    Temp := Connect.Database;
    if dbuse(FHandle, PChar(Temp)) = DBFAIL then
    begin
      ZlibSySql.dbclose(FHandle);
      FHandle := nil;
      goto ErrorProc;
    end;
    MonitorList.InvokeEvent(Format('CONNECT %s',[Connect.Database]), 'OK.', False);
  end else
    goto ErrorProc;

  StartTransaction;
  SetActive(Status = csOk);
  Exit;

  { Process error status }
ErrorProc:
  MonitorList.InvokeEvent(Format('CONNECT %s',[Connect.Database]), Error, True);
end;

{ Connect to database }
procedure TDirSySQLTransact.Close;
begin
  EndTransaction;
  if Active then
  begin
    { Disconnect database }
    if FHandle <> nil then
    begin
      ZlibSySql.dbclose(FHandle);
      FHandle := nil;
    end;
    { Free login record }
    if FLoginRec <> nil then
    begin
      dbfreelogin(FLoginRec);
      FLoginRec := nil;
    end;
    { Update transact status }
    if Assigned(Connect) then
      MonitorList.InvokeEvent(Format('DISCONNECT %s',[Connect.Database]), 'OK.', False);
  end;
  SetActive(False);
end;

{ Connect to database and start transaction }
procedure TDirSySQLTransact.StartTransaction;
begin
  { Set startup values }
  SetStatus(csFail);
  if not Assigned(Connect) then Exit;
  SetStatus(csOk);
  { Begin transaction }
  if TransactSafe then
  begin
    dbcmd(FHandle, 'BEGIN TRANSACTION');
    dbsqlexec(FHandle);
    MonitorList.InvokeEvent('BEGIN TRANSACTION', Error, Error <> '');
    dbcancel(FHandle);
  end;
end;

{ End transaction and disconnect from database }
procedure TDirSySQLTransact.EndTransaction;
begin
  { Setup transact properties }
  SetStatus(csOk);
  if Active then
  begin
    { End transaction }
    if TransactSafe then
    begin
      dbcmd(FHandle, 'ROLLBACK');
      dbsqlexec(FHandle);
      if dbresults(FHandle) <> DBSUCCEED then
        SetStatus(csFail);
      MonitorList.InvokeEvent('ROLLBACK', Error, Error <> '');
      dbcancel(FHandle);
    end;
  end;
end;

{ Commit transaction }
procedure TDirSySQLTransact.Commit;
begin
  { Check status }
  SetStatus(csFail);
  if not Active or not Assigned(FHandle) then Exit;
  SetStatus(csOk);
  if TransactSafe then
  begin
    { Commit execute }
    dbcmd(FHandle, 'COMMIT');
    dbsqlexec(FHandle);
    if dbresults(FHandle) <> DBSUCCEED then
      SetStatus(csFail);
    MonitorList.InvokeEvent('COMMIT', Error, Error <> '');
    dbcancel(FHandle);
    { Start new trasaction }
    dbcmd(FHandle, 'BEGIN TRANSACTION');
    dbsqlexec(FHandle);
    if dbresults(FHandle) <> DBSUCCEED then
      SetStatus(csFail);
    dbcancel(FHandle);
    MonitorList.InvokeEvent('BEGIN TRANSACTION', Error, Error <> '');
  end;
end;

{ Rollback transaction }
procedure TDirSySQLTransact.Rollback;
begin
  { Check status }
  SetStatus(csFail);
  if not Active or not Assigned(FHandle) then Exit;
  SetStatus(csOk);
  if TransactSafe then
  begin
    { Rollback execute }
    dbcmd(FHandle, 'ROLLBACK');
    dbsqlexec(FHandle);
    if dbresults(FHandle) <> DBSUCCEED then
      SetStatus(csFail);
    MonitorList.InvokeEvent('ROLLBACK', Error, Error <> '');
    dbcancel(FHandle);
    { Start new trasaction }
    dbcmd(FHandle, 'BEGIN TRANSACTION');
    dbsqlexec(FHandle);
    if dbresults(FHandle) <> DBSUCCEED then
      SetStatus(csFail);
    MonitorList.InvokeEvent('BEGIN TRANSACTION', Error, Error <> '');
    dbcancel(FHandle);
  end;
end;

{******************* TDirSySQLQuery implementation **********************}

{ Class constructor }
constructor TDirSySQLQuery.Create(AConnect: TDirSySQLConnect;
  ATransact: TDirSySQLTransact);
begin
  inherited Create;
  Connect := AConnect;
  Transact := ATransact;
end;

{ Get an error message }
function TDirSySQLQuery.GetErrorMsg: ShortString;
begin
  if Transact = nil then
    Result := 'Transaction object not defined'
  else if not Transact.Active then
    Result := 'Connection closed'
  else if not (Status in [qsTuplesOk, qsCommandOk]) then
  begin
    Result := dbsqlerror;
    if StrCmpBegin(Result, 'General SQL Server error') then
      Result := dbmessage;
  end else
    Result := '';
end;

{ Close open query }
procedure TDirSySQLQuery.Close;
begin
  if Active and Assigned(Transact) then
    dbcancel(TDirSySQLTransact(Transact).Handle);
  inherited Close;
  SetActive(False);
  SetStatus(qsCommandOk);
end;

{ Execute the query }
// mjd 9/28/2001 replaced code with Janos' suggestion on sourceforge,
// then modified to fit sybase (see rowsaf)
function TDirSySqlQuery.Execute: LongInt;
var
  SyTransact: TDirSySqlTransact;
  dbRes: Integer;
  rowsaf: integer; // mjd 9/21/2001 added line to support number of rows affected

begin
  Result := inherited Execute;
  SetStatus(qsFail);
  if not Assigned(Connect) or not Assigned(Transact) or
     not (Connect.Active and Transact.Active) then
    Exit;

  SyTransact := TDirSySqlTransact(Transact);
  dbcmd(SyTransact.Handle, PChar(Trim(Sql)));
//  dbsqlexec(SyTransact.Handle); // mjd 9/28/2001 removed for sybase "rows affected"
  rowsaf := dbsqlexec(SyTransact.Handle);        // mjd 9/28/2001 added "rowsaf :=" to add support for rows affected

  repeat
    dbRes := dbresults(SyTransact.Handle);
  until dbRes in [DBFAIL, NO_MORE_RESULTS];
  //Clear all pending errors. Important: Only the last error will be displayed.

  if dbRes = DBFAIL then
    repeat until dbresults(SyTransact.Handle) = NO_MORE_RESULTS;

  if dbRes = NO_MORE_RESULTS then
  dbRes := DBSUCCEED;
  if dbRes = DBSUCCEED then
  begin
//    SetAffectedRows(dbcount(SyTransact.Handle));  mjd 9/28/2001 for sybase rows affected
    SetAffectedRows( rowsaf ); // mjd 9/21/2001 added line to support sybase rows affected
    Result := AffectedRows;
    SetStatus(qsCommandOk);
  end;
  dbcancel(SyTransact.Handle);
  MonitorList.InvokeEvent(Sql, Error, Error <> '');
end;

{ Open the query with result set }
procedure TDirSySQLQuery.Open;
var
  SyTransact: TDirSySQLTransact;
  Result: Integer;
begin
  inherited Open;
  SetStatus(qsFail);
  if not Assigned(Connect) or not Assigned(Transact)
    or not (Connect.Active and Transact.Active) then
    Exit;

  SyTransact := TDirSySQLTransact(Transact);
  dbcmd(SyTransact.Handle, PChar(Trim(Sql)));
  dbsqlexec(SyTransact.Handle);

  Result := dbresults(SyTransact.Handle);
  while dbresults(SyTransact.Handle) = DBSUCCEED do;

  if Result = DBSUCCEED then
  begin
    SetActive(True);
    SetStatus(qsTuplesOk);
    SetBOF(False);
    SetEOF(False);
    Next;
    if Status <> qsTuplesOk then
      SetActive(False);
  end;
  MonitorList.InvokeEvent(Sql, Error, not Active);
end;

{ Go to next row }
procedure TDirSySQLQuery.Next;
var
  FetchStat: Integer;
begin
  if not Active or EOF then Exit;
  SetStatus(qsFail);
  if not Assigned(Connect) or not Assigned(Transact) then
    Exit;

  FetchStat := dbnextrow(TDirSySQLTransact(Transact).Handle);
  if FetchStat <> DBFAIL then
  begin
    SetStatus(qsTuplesOk);
    SetEOF(FetchStat = NO_MORE_ROWS);
    if FetchStat <> NO_MORE_ROWS then
      SetRecNo(RecNo+1);
  end else
    SetEOF(True);
end;

{ Get record quantity }
function TDirSySQLQuery.RecordCount: Integer;
begin
  if not Active then Result := 0
  else Result := dbcount(TDirSySQLTransact(Transact).Handle);
end;

{ Get fields quantity }
function TDirSySQLQuery.FieldCount: Integer;
begin
  Result := 0;
  if Active then
    Result := dbnumcols(TDirSySQLTransact(Transact).Handle);
end;

{ Get field name }
function TDirSySQLQuery.FieldName(FieldNum: Integer): ShortString;
var
  Temp: PChar;
begin
  Result := '';
  if Active then
  begin
    Temp := dbcolname(TDirSySQLTransact(Transact).Handle, FieldNum+1);
    if (Temp <> nil) and (Temp^ <> #0) then
      Result := StrPas(Temp)
    else
      Result := 'Field' + IntToStr(FieldNum+1);
  end;
end;

{ Get field size }
function TDirSySQLQuery.FieldSize(FieldNum: Integer): Integer;
begin
  Result := 0;
  if Active then
  begin
    Result := dbdatlen(TDirSySQLTransact(Transact).Handle, FieldNum+1);
    if Result = -1 then Result := 0;
  end;
end;

{ Get maximum field size }
function TDirSySQLQuery.FieldMaxSize(FieldNum: Integer): Integer;
begin
  Result := 0;
  if Active then
  begin
    Result := dbcollen(TDirSySQLTransact(Transact).Handle, FieldNum+1);
    if Result = -1 then Result := 0;
  end;
end;

{ Get field type }
function TDirSySQLQuery.FieldType(FieldNum: Integer): Integer;
begin
  Result := 0;
  if Active then
    Result := dbcoltype(TDirSySQLTransact(Transact).Handle, FieldNum+1);
end;

{ Define field type }
function TDirSySQLQuery.FieldDataType(FieldNum: Integer): TFieldType;
begin
  Result := SySQLToDelphiType(FieldType(FieldNum));
end;

{ Get field value }
function TDirSySQLQuery.Field(FieldNum: Integer): string;
var
  Length: LongInt;
  SyTransact: TDirSySQLTransact;
  Ptr: PByte;
  ColType: Integer;
  DateRec: DBDATEREC;
  TempDate: TDateTime;
  TempSqlDate: DBDATETIME;
  TempFloat: Double;
begin
  Result := '';
  if not Active or Eof or Bof then Exit;

  SyTransact := TDirSySQLTransact(Transact);
  Length := dbdatlen(SyTransact.Handle, FieldNum+1);
  if Length = -1 then Length := 0;
  Ptr := dbdata(SyTransact.Handle, FieldNum+1);
  if Ptr = nil then Exit;
  ColType := dbcoltype(SyTransact.Handle, FieldNum+1);
  case ColType of
    SQLINT1: Result := IntToStr(PByte(Ptr)^);
    SQLINT2: Result := IntToStr(PSmallInt(Ptr)^);
    SQLINT4: Result := IntToStr(PInteger(Ptr)^);
    SQLVARCHAR, SQLCHAR, SQLVARBINARY, SQLBINARY:
      Result := MemPas(PChar(Ptr), Length);
    SQLBIT:
      if PByte(Ptr)^ <> 0 then Result := '1'
      else Result := '0';
    SQLFLT4: Result := FloatToStr(PSingle(Ptr)^);
    SQLFLT8: Result := FloatToStr(PDouble(Ptr)^);
    SQLDATETIME, SQLDATETIM4:
      begin
        dbconvert(SyTransact.Handle, ColType, Ptr, Length, SQLDATETIME,
          @TempSqlDate, SizeOf(DBDATETIME));
        dbdatecrack(SyTransact.Handle, @DateRec, @TempSqlDate);
            // mjd 9/28/2001 - added following code as per bug report
            if (DateRec.year > 1900) and (DateRec.year < 2200)then
            begin
              TempDate := EncodeDate(DateRec.year,
                          DateRec.month+1, DateRec.day);
              TempDate := TempDate +
                           EncodeTime(DateRec.hour,
                           DateRec.minute, DateRec.second,
                           DateRec.millisecond);
            end
            else
            begin
              TempDate := 0;
            end;
//        TempDate := EncodeDate(DateRec.year, DateRec.month+1, DateRec.day); //mjd - added month + 1
  //      TempDate := TempDate + EncodeTime(DateRec.hour, DateRec.minute,
//        DateRec.second, DateRec.millisecond);
        Result := DateTimeToSqlDate(TempDate);
      end;
    SQLMONEY, SQLMONEY4:
      begin
        dbconvert(SyTransact.Handle, ColType, Ptr, Length, SQLFLT8,
          @TempFloat, SizeOf(TempFloat));
        Result := FloatToStr(TempFloat);
      end;
    else
      Result := MemPas(PChar(Ptr), Length);
  end;
end;

{ Get field buffer }
function TDirSySQLQuery.FieldBuffer(FieldNum: Integer): PChar;
begin
  if not Active or Eof or Bof then
    Result := nil
  else
    Result := PChar(dbdata(TDirSySQLTransact(Transact).Handle, FieldNum+1));
end;

{ Is field null }
function TDirSySQLQuery.FieldIsNull(FieldNum: Integer): Boolean;
begin
  if not Active or Eof or Bof then
    Result := True
  else
    Result := (dbdata(TDirSySQLTransact(Transact).Handle, FieldNum+1) = nil);
end;

{ Showes databases }
procedure TDirSySQLQuery.ShowDatabases(DatabaseName: ShortString);
begin
  if Active then Close;
  Sql := 'SELECT name FROM master..sysdatabases';
  if DatabaseName <> '' then
    Sql := Sql + ' WHERE name LIKE '''+DatabaseName+'''';
  Sql := Sql + ' ORDER BY name';
  Open;
end;

{ Showes tables of the database }
procedure TDirSySQLQuery.ShowTables(TableName: ShortString);
begin
  if Active then Close;
  Sql := 'select name from sysobjects where type=''U''';
  if TableName <> '' then
    Sql := Sql + ' and name like '''+TableName+'''';
  Sql := Sql + ' order by name';
  Open;
end;

{ Showes columns of the table }
procedure TDirSySQLQuery.ShowColumns(TableName, ColumnName: ShortString);
begin
  if Active then Close;
  Sql := 'EXEC sp_mshelpcolumns '''+TableName+'''';
  Open;
end;

{ Showes indexes of the table }
procedure TDirSySQLQuery.ShowIndexes(TableName: ShortString);
begin
  if Active then Close;
  Sql := 'EXEC sp_helpindex '''+TableName+'''';
  Open;
end;

{ Convert string to sql format }
function TDirSySQLQuery.StringToSql(Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
  begin
    Result := Result + Value[I];
    if Value[I] = '''' then
      Result := Result + Value[I];
  end;
end;

{ TDirSySQLStoredProc }

procedure TDirSySQLStoredProc.BindParam(Param: TParam);
var
  BindKind: Byte;
  MaxLen: LongInt;
  DataLen: LongInt;
  Ptr: PByte;
  tp: Integer;

  // temporary variables to pass a parameter to db-lib
  tmpInteger: Integer;
  tmpString: string;
  tmpBoolean: Boolean;
  tmpSmallInt: SmallInt;
  tmpWord: Word;
  tmpCurrency: Currency;
  tmpDouble: Double;
begin
  if Param.ParamType = ptUnknown then
    raise Exception.Create('Param '+Param.Name+' is of unknown type')
  else
  begin
    tp := DelphiToSySQLType(Param.DataType);
    if Param.ParamType = ptInput then
    begin
      BindKind := 0;//DBRPCDEFAULT;
      MaxLen := -1;
      case Param.DataType of
        ftInteger, ftSmallint, ftWord, ftBoolean, ftFloat, ftCurrency, ftDateTime,
        ftDate, ftTime {$IFNDEF VER100}, ftLargeInt{$ENDIF}:
          DataLen := -1;
      else
        DataLen := Length(Param.asString)*SizeOf(Char);
      end;
    end
    else
    begin
      BindKind := DBRPCRETURN;
      case Param.DataType of
      ftInteger, ftSmallint, ftWord, ftBoolean, ftFloat, ftCurrency,
      ftDateTime, ftDate, ftTime {$IFNDEF VER100}, ftLargeInt {$ENDIF}:
          begin
             MaxLen := -1;
             if Param.Isnull then
               DataLen := 0
             else
               DataLen := -1;
          end;
      else
        begin
          if Param.Isnull then
          begin
            MaxLen := 0;
            DataLen := 0;
          end
          else
          begin
            //MaxLen := High(string);
            MaxLen := 2147483647;
            DataLen := Length(Param.asString)*SizeOf(Char);
          end;
        end;
      end;
    end;

    // Getting a pointer to a variable containing the value of the parameter
    case Param.DataType of
      ftInteger {$IFNDEF VER100}, ftLargeInt{$ENDIF}:
        begin
          tmpInteger := Param.AsInteger;
          Ptr := PByte(@tmpInteger);
        end;
      ftString:
        begin
          tmpString := Param.AsString;
          Ptr := PByte(PChar(tmpString));
        end;
      ftBoolean:
        begin
          tmpBoolean := Param.asBoolean;
          Ptr := PByte(@tmpBoolean);
        end;
      ftBlob, ftGraphic, ftFmtMemo:
        begin
          tmpString := Param.AsBlob;
          Ptr := PByte(PChar(tmpString));
        end;
      ftCurrency:
        begin
          tmpCurrency := Param.AsCurrency;
          Ptr := PByte(@tmpCurrency);
        end;
      ftDate:
        begin
          tmpDouble := Param.asDate;
          Ptr := PByte(@tmpDouble);
        end;
      ftDateTime:
        begin
          tmpDouble := Param.asDateTime;
          Ptr := PByte(@tmpDouble);
        end;
      ftTime:
        begin
          tmpDouble := Param.asTime;
          Ptr := PByte(@tmpDouble);
        end;
      ftFloat:
        begin
          tmpDouble := Param.asFloat;
          Ptr := PByte(@tmpDouble);
        end;
      ftSmallInt:
        begin
          tmpSmallInt := Param.AsSmallInt;
          Ptr := PByte(@tmpSmallInt);
        end;
      ftWord:
        begin
          tmpWord := Param.asWord;
          Ptr := PByte(@tmpWord);
        end;
      ftMemo:
        begin
          tmpString := Param.AsString;
          Ptr := PByte(PChar(tmpString));
        end
    else
      begin
        tmpString := Param.AsString;
        Ptr := PByte(PChar(tmpString));
      end;
    end;

    // add the parameter
    dbrpcparam(TDirSySQLTransact(Transact).Handle, PChar(Param.Name), BindKind,
      tp, MaxLen, DataLen, Ptr);
  end;
end;

procedure TDirSySQLStoredProc.Close;
begin
  if Active and Assigned(Transact) then
    dbcancel(TDirSySQLTransact(Transact).Handle);

  inherited Close;
  SetActive(False);
  SetStatus(qsCommandOk);
end;

constructor TDirSySQLStoredProc.Create(AConnect: TDirSySQLConnect;
  ATransact: TDirSySQLTransact);
begin
  inherited Create;
  Connect := AConnect;
  Transact := ATransact;
end;

procedure TDirSySQLStoredProc.ExecProc;
var
  SyTransact: TDirSySQLTransact;
  dbResult: Integer;
begin
  if Prepared then
  begin
    inherited ExecProc;
    SetStatus(qsFail);
    if not Assigned(Connect) or not Assigned(Transact)
      or not (Connect.Active and Transact.Active) then
        Exit;

    SyTransact := TDirSySQLTransact(Transact);
//    dbrpcexec(SyTransact.Handle);  // mjd - commented out - MS-SQL can do dbrpcexec, Sybase can't
    dbrpcexec(SyTransact.Handle);  // mjd - added - Sybase can only do dbrpcsend, not dbrpcexec
    dbResult := dbresults(SyTransact.Handle);

    while dbresults(SyTransact.Handle) = DBSUCCEED do;

    if dbResult = DBSUCCEED then
    begin
      SetActive(True);
      SetStatus(qsTuplesOk);
      SetBOF(False);
      SetEOF(False);
      Next;
      if Status <> qsTuplesOk then
        SetActive(False);
    end;

    MonitorList.InvokeEvent(StoredProcName, Error, not Active);
  end;
end;

function TDirSySQLStoredProc.Field(FieldNum: Integer): string;
var
  Length: LongInt;
  SyTransact: TDirSySQLTransact;
  Ptr: PByte;
  ColType: Integer;
  DateRec: DBDATEREC;
  TempDate: TDateTime;
  TempSqlDate: DBDATETIME;
  TempFloat: Double;
begin
  Result := '';
  if not Active or Eof or Bof then Exit;

  SyTransact := TDirSySQLTransact(Transact);
  Length := dbdatlen(SyTransact.Handle, FieldNum+1);
  if Length = -1 then Length := 0;
  Ptr := dbdata(SyTransact.Handle, FieldNum+1);
  if Ptr = nil then Exit;
  ColType := dbcoltype(SyTransact.Handle, FieldNum+1);
  case ColType of
    SQLINT1: Result := IntToStr(PByte(Ptr)^);
    SQLINT2: Result := IntToStr(PSmallInt(Ptr)^);
    SQLINT4: Result := IntToStr(PInteger(Ptr)^);
    SQLVARCHAR, SQLCHAR, SQLVARBINARY, SQLBINARY:
      Result := MemPas(PChar(Ptr), Length);
    SQLBIT:
      if PByte(Ptr)^ <> 0 then Result := '1'
      else Result := '0';
    SQLFLT4: Result := FloatToStr(PSingle(Ptr)^);
    SQLFLT8: Result := FloatToStr(PDouble(Ptr)^);
    SQLDATETIME, SQLDATETIM4:
      begin
        dbconvert(SyTransact.Handle, ColType, Ptr, Length, SQLDATETIME,
          @TempSqlDate, SizeOf(DBDATETIME));
        dbdatecrack(SyTransact.Handle, @DateRec, @TempSqlDate);
            // mjd 9/28/2001 - added following code as per bug report
            if (DateRec.year > 1900) and (DateRec.year < 2200)then
            begin
              TempDate := EncodeDate(DateRec.year,
                          DateRec.month+1, DateRec.day);
              TempDate := TempDate +
                           EncodeTime(DateRec.hour,
                           DateRec.minute, DateRec.second,
                           DateRec.millisecond);
            end
            else
            begin
              TempDate := 0;
            end;

//        TempDate := EncodeDate(DateRec.year, DateRec.month+1, DateRec.day);  // mjd - added month + 1
//        TempDate := TempDate + EncodeTime(DateRec.hour, DateRec.minute,
//        DateRec.second, DateRec.millisecond);
        Result := DateTimeToSqlDate(TempDate);
      end;
    SQLMONEY, SQLMONEY4:
      begin
        dbconvert(SyTransact.Handle, ColType, Ptr, Length, SQLFLT8,
          @TempFloat, SizeOf(TempFloat));
        Result := FloatToStr(TempFloat);
      end;
    else
      Result := MemPas(PChar(Ptr), Length);
  end;
end;

function TDirSySQLStoredProc.FieldBuffer(FieldNum: Integer): PChar;
begin
  if not Active or Eof or Bof then
    Result := nil
  else
    Result := PChar(dbdata(TDirSySQLTransact(Transact).Handle, FieldNum+1));
end;

function TDirSySQLStoredProc.FieldCount: Integer;
begin
  Result := 0;
  if Active then
    Result := dbnumcols(TDirSySQLTransact(Transact).Handle);
end;

function TDirSySQLStoredProc.FieldDataType(FieldNum: Integer): TFieldType;
begin
  Result := SySQLToDelphiType(FieldType(FieldNum));
end;

function TDirSySQLStoredProc.FieldIsNull(FieldNum: Integer): Boolean;
begin
  if not Active or Eof or Bof then
    Result := True
  else
    Result := (dbdata(TDirSySQLTransact(Transact).Handle, FieldNum+1) = nil);
end;

function TDirSySQLStoredProc.FieldMaxSize(FieldNum: Integer): Integer;
begin
  Result := 0;
  if Active then
  begin
    Result := dbcollen(TDirSySQLTransact(Transact).Handle, FieldNum+1);
    if Result = -1 then Result := 0;
  end;
end;

function TDirSySQLStoredProc.FieldName(FieldNum: Integer): ShortString;
var
  Temp: PChar;
begin
  Result := '';
  if Active then
  begin
    Temp := dbcolname(TDirSySQLTransact(Transact).Handle, FieldNum+1);
    if (Temp <> nil) and (Temp^ <> #0) then
      Result := StrPas(Temp)
    else
      Result := 'Field' + IntToStr(FieldNum+1);
  end;
end;

function TDirSySQLStoredProc.FieldSize(FieldNum: Integer): Integer;
begin
  Result := 0;
  if Active then
  begin
    Result := dbdatlen(TDirSySQLTransact(Transact).Handle, FieldNum+1);
    if Result = -1 then Result := 0;
  end;
end;

function TDirSySQLStoredProc.FieldType(FieldNum: Integer): Integer;
begin
  Result := 0;
  if Active then
    Result := dbcoltype(TDirSySQLTransact(Transact).Handle, FieldNum+1);
end;

function TDirSySQLStoredProc.GetErrorMsg: ShortString;
begin
  if Transact = nil then
    Result := 'Transaction object not defined'
  else if not Transact.Active then
    Result := 'Connection closed'
  else if not (Status in [qsTuplesOk, qsCommandOk]) then
  begin
    Result := dbsqlerror;
    if StrCmpBegin(Result, 'General SQL Server error') then
      Result := dbmessage;
  end else
    Result := '';
end;

procedure TDirSySQLStoredProc.Next;
var
  FetchStat: Integer;
begin
  if not Active or EOF then Exit;
  SetStatus(qsFail);
  if not Assigned(Connect) or not Assigned(Transact) then
    Exit;

  FetchStat := dbnextrow(TDirSySQLTransact(Transact).Handle);
  if FetchStat <> DBFAIL then
  begin
    SetStatus(qsTuplesOk);
    SetEOF(FetchStat = NO_MORE_ROWS);
    if FetchStat <> NO_MORE_ROWS then
      SetRecNo(RecNo+1);
  end else
    SetEOF(True);
end;

procedure TDirSySQLStoredProc.Open;
begin
  ExecProc;
end;

function TDirSySQLStoredProc.Param(ParamNum: Integer): string;
var
  SyTransact: TDirSySQLTransact;
  Length: LongInt;
  Ptr: PByte;
  ParType: Integer;
  tmpSqlDate: DBDATETIME;
  DateRec: DBDATEREC;
  TempDate: TDateTime;
  TempFloat: Double;
begin
  Result := '';
  if not Active then
    Exit;

  SyTransact := TDirSySQLTransact(Transact);
  Length := dbretlen(SyTransact.Handle,ParamNum+1);
  if Length = -1 then
    Length := 0;
  Ptr := dbretdata(SyTransact.Handle,ParamNum+1);
  if Ptr = nil then
    Exit;
  ParType := dbrettype(SyTransact.Handle,ParamNum+1);
  case ParType of
    SQLINT1: Result := IntToStr(PByte(Ptr)^);
    SQLINT2: Result := IntToStr(PSmallInt(Ptr)^);
    SQLINT4: Result := IntToStr(PInteger(Ptr)^);
    SQLVARCHAR, SQLCHAR, SQLVARBINARY, SQLBINARY:
      Result := MemPas(PChar(Ptr),Length);
    SQLBIT: if PByte(Ptr)^ <> 0 then
              Result := '1'
            else
              Result := '0';
    SQLFLT4: Result := FloatToStr(PSingle(Ptr)^);
    SQLFLT8: Result := FloatToStr(PDouble(Ptr)^);
    SQLDATETIME, SQLDATETIM4:
      begin
        dbconvert(SyTransact.Handle,ParType,Ptr,Length,SQLDATETIME,
                  @tmpSqlDate, sizeof(DBDATETIME));
        dbdatecrack(SyTransact.Handle,@DateRec,@tmpSqlDate);

            // mjd 9/28/2001 - added following code as per bug report
            if (DateRec.year > 1900) and (DateRec.year < 2200)then
            begin
              TempDate := EncodeDate(DateRec.year,
                          DateRec.month+1, DateRec.day);
              TempDate := TempDate +
                           EncodeTime(DateRec.hour,
                           DateRec.minute, DateRec.second,
                           DateRec.millisecond);
            end
            else
            begin
              TempDate := 0;
            end;

{        TempDate := EncodeDate(DateRec.year, DateRec.Month+1, DateRec.Day); // mjd - added month+1
        TempDate := TempDate+EncodeTime(DateRec.Hour,DateRec.Minute,
                                        DateRec.Second,DateRec.MilliSecond);}
        Result := DateTimeToSqlDate(TempDate);
      end;
    SQLMONEY, SQLMONEY4:
      begin
        dbconvert(SyTransact.Handle,ParType,Ptr,Length,SQLFLT8,@TempFloat,
                  sizeOf(TempFloat));
        Result := FloatToStr(TempFloat);
      end;
    else
      Result := MemPas(PChar(Ptr),Length);
  end;
end;

function TDirSySQLStoredProc.ParamBuffer(ParamNum: Integer): PChar;
begin
  if not Transact.Active then
    Result := nil
  else
    Result := PChar(dbretdata(TDirSySQLTransact(Transact).Handle, ParamNum+1));
end;

function TDirSySQLStoredProc.ParamCount: Integer;
begin
  Result := 0;
  if Transact.Active then
    Result := dbnumrets(TDirSySQLTransact(Transact).Handle);
end;

function TDirSySQLStoredProc.ParamDataType(ParamNum: Integer): TFieldType;
begin
  Result := SySQLToDelphiType(ParamType(ParamNum));
end;

function TDirSySQLStoredProc.ParamIsNull(ParamNum: Integer): Boolean;
begin
  if not Transact.Active then
    Result := True
  else
    Result := (dbretdata(TDirSySQLTransact(Transact).Handle, ParamNum+1) = nil);
end;

function TDirSySQLStoredProc.ParamMaxSize(ParamNum: Integer): Integer;
begin
  Result := 0;
  if Transact.Active then
  begin
    Result := dbretlen(TDirSySQLTransact(Transact).Handle, ParamNum+1);
    if Result = -1 then Result := 0;
  end;
end;

function TDirSySQLStoredProc.ParamName(ParamNum: Integer): ShortString;
var
  Temp: PChar;
begin
  Result := '';
  if Transact.Active then
  begin
    Temp := dbretname(TDirSySQLTransact(Transact).Handle, ParamNum+1);
    if (Temp <> nil) and (Temp^ <> #0) then
      Result := StrPas(Temp)
    else
      Result := 'Field' + IntToStr(ParamNum+1);
  end;
end;

function TDirSySQLStoredProc.ParamSize(ParamNum: Integer): Integer;
begin
  Result := 0;
  if Transact.Active then
  begin
    Result := dbretlen(TDirSySQLTransact(Transact).Handle, ParamNum+1);
    if Result = -1 then Result := 0;
  end;
end;

function TDirSySQLStoredProc.ParamType(ParamNum: Integer): Integer;
begin
  Result := 0;
  if Transact.Active then
    Result := dbrettype(TDirSySQLTransact(Transact).Handle, ParamNum+1);
end;

procedure TDirSySQLStoredProc.Prepare(Params: TParams);
var
  I: Integer;
begin
  if not Prepared then
  begin
    dbrpcinit(TDirSySQLTransact(Transact).Handle,PChar(StoredProcName),0);
    for I := 0 to Params.Count-1 do
//      if (Params[I].ParamType=ptInput) or (Params[I].ParamType=ptInputOutput) then
      BindParam(Params[i]);
    Prepared := true;
  end;
end;

function TDirSySQLStoredProc.RecordCount: Integer;
begin
  if not Active then
    Result := 0
  else
    Result := dbcount(TDirSySQLTransact(Transact).Handle);
end;

procedure TDirSySQLStoredProc.ShowParams(StoredProcedureName: ShortString);
var
  tmpString: String;
  tmpprocname: string;
  Ptr: PByte;
begin
  if Active then
    Close;

//  StoredprocName := 'sp_sproc_columns';
  tmpprocname := 'sp_sproc_columns';
  dbrpcinit(TDirSySQLTransact(Transact).Handle,PChar(tmpprocname),0);
    if dbresults(TDirSySQLTransact(Transact).Handle)<>SUCCEED then
      raise Exception.Create('no succes init');

  if StoredProcedureName<>'' then
  begin
//    if StoredProcedureName[Length(StoredProcedureName)] = '.' then
//    raise Exception.Create(storedprocedurename[Length(StoredProcedureName)]);
    tmpString := Copy(StoredProcedureName,1,pos(';',StoredProcedureName)-1);
    Ptr := PByte(PChar(tmpString));
    dbrpcparam(TDirSySQLTransact(Transact).Handle,PChar('@procedure_name'),0,
               SQLVARCHAR,-1,Length(tmpString)*sizeof(Char),Ptr);
    if dbresults(TDirSySQLTransact(Transact).Handle)<>SUCCEED then
      raise Exception.Create('no succes');
  end
  else
    raise exception.Create('no spName');
  Prepared := true;
  ExecProc;
end;

procedure TDirSySQLStoredProc.ShowStoredProcs;
begin
  if Active then
    Close;

  StoredProcName := 'sp_stored_procedures';
  dbrpcinit(TDirSySQLTransact(Transact).Handle,PChar(StoredProcName),0);
  Prepared := true;
  ExecProc;
end;

function TDirSySQLStoredProc.StringToSql(Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
  begin
    Result := Result + Value[I];
    if Value[I] = '''' then
      Result := Result + Value[I];
  end;
end;

procedure TDirSySQLStoredProc.UnPrepare;
begin
  inherited Unprepare;
  dbcancel(TDirSySQLTransact(Transact).Handle);
end;

function DelphiToSySQLType(const DelphiType: TFieldType): Integer;
begin
  case DelphiType of
    ftUnknown: Result := -1;
    ftString: Result := SQLVARCHAR;
    ftSmallInt: Result := SQLINT2;
    ftInteger: Result := SQLINT4;
    ftWord: Result := SQLINT2;
    ftBoolean: Result := SQLBIT;
    ftFloat: Result := SQLFLT8;
    ftCurrency: Result := SQLMONEY;
    ftDate: Result := SQLDATETIME;
    ftTime: Result := SQLDATETIME;
    ftDateTime: Result := SQLDATETIME;
    ftBytes: Result := SQLBINARY;
    ftVarBytes: Result := SQLVARBINARY;
    ftBlob: Result := SQLIMAGE;
    ftMemo: Result := SQLTEXT;
    ftGraphic: Result := SQLIMAGE;
    ftFmtMemo: Result := SQLIMAGE;
//    ftFixedChar: Result := SQLCHAR;
//    ftWideString: Result := SQLVARCHAR;
//    ftLargeInt: Result := SQLINT4;
  else
    Result := -1;
  end;
end;

function TDirSySQLStoredProc.GetReturnValue: String;
begin
  if Transact.Active and dbhasretstat(TDirSySQLTransact(Transact).Handle) then
    Result := IntToStr(dbretstatus(TDirSySQLTransact(Transact).Handle));
end;

function SySQLToDelphiParamType(Value: Integer): TParamType;
begin
  case Value of
    SQL_PARAM_TYPE_UNKNOWN: Result := ptUnknown;
    SQL_PARAM_TYPE_INPUT: Result := ptInput;
    SQL_PARAM_TYPE_OUTPUT: Result := ptInputOutput;
    SQL_RESULT_COL: Result := ptUnknown;
    SQL_PARAM_OUTPUT: Result := ptUnknown;
    SQL_RETURN_VALUE: Result := ptResult;
  else
    Result := ptUnknown;
  end;
end;

{*************** Extra functions implementation ****************}

{ Convert Sybase SQL field type to delphi field type }
function SySQLToDelphiType(Value: Integer): TFieldType;
begin
  case Value of
    SQLINT1, SQLINT2:
      Result := ftSmallInt;
    SQLINT4:
      Result := ftInteger;
    SQLFLT4, SQLFLT8, SQLFLTN:
      Result := ftFloat;
    SQLDECIMAL, SQLNUMERIC:
      Result := ftFloat;
    SQLMONEY, SQLMONEYN:
      Result := ftCurrency;
    SQLBINARY, SQLVARBINARY:
      Result := ftBytes;
    SQLDATETIME:
      Result := ftDateTime;
    SQLBIT:
      Result := ftBoolean;
    SQLTEXT:
      Result := ftMemo;
    SQLIMAGE:
      Result := ftBlob;
    else
      Result := ftString;
  end;
end;

{ Convert Sybase SQL field types description to delphi field types }
function SySQLToDelphiTypeDesc(Value: string): TFieldType;
begin
  Value := LowerCase(Value);
  if Value = 'int' then
    Result := ftInteger
  else if (Value = 'char') or (Value = 'varchar') then
    Result := ftString
  else if (Value = 'nchar') or (Value = 'nvarchar') then
    Result := ftString
  else if (Value = 'varbinary') or (Value = 'binary')
    or (Value = 'timestamp') then
    Result := ftBytes
  else if (Value = 'float') or (Value = 'real') then
    Result := ftFloat
  else if (Value = 'decimal') or (Value = 'numeric') then
    Result := ftFloat
  else if (Value = 'datetime') or (Value = 'smalldatetime') then
    Result := ftDateTime
  else if (Value = 'money') or (Value = 'smallmoney') then
    Result := ftCurrency
  else if (Value = 'tinyint') or (Value = 'smallint') then
    Result := ftSmallInt
  else if Value = 'text' then
    Result := ftMemo
  else if Value = 'image' then
    Result := ftBlob
  else if Value = 'bit' then
    Result := ftBoolean
  else
    Result := ftUnknown;
end;

initialization
  MonitorList := TZMonitorList.Create;
finalization
  MonitorList.Free;
end.
