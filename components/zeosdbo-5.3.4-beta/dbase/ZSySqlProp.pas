{********************************************************}
{                                                        }
{                 Zeos Database Objects                  }
{                Sybase SQL property editors                 }
{                                                        }
{       Copyright (c) 1999-2001 Sergey Seroukhov         }
{    Copyright (c) 1999-2002 Zeos Development Group      }
{                                                        }
{********************************************************}

unit ZSySqlProp;

interface

{$IFNDEF LINUX}
{$INCLUDE ..\ZeosDef.inc}
{$ELSE}
{$INCLUDE ../ZeosDef.inc}
{$ENDIF}

uses Classes, {$IFNDEF VERCLX}DsgnIntf,{$ELSE}DesignIntf,{$ENDIF} ZProperty,
  ZSySqlStoredProc;

{$IFNDEF LINUX}
{$INCLUDE ..\Zeos.inc}
{$ELSE}
{$INCLUDE ../Zeos.inc}
{$ENDIF}

type
  { Property editor for TSySQLTable }
  TZSySqlTableNameProperty = class(TDbPropertyEditor)
    procedure GetValueList(Values: TStringList); override;
  end;

  { Property editor for TSySQLDatabase }
  TZSySqlDatabaseNameProperty = class(TDbPropertyEditor)
    procedure GetValueList(Values: TStringList); override;
  end;

  { Property editor for tZSySqlStoredProc }
  TZSySqlStoredProcNameProperty = class(TDbPropertyEditor)
    procedure GetValueList(Values: TStringList); override;
  end;

implementation

uses SysUtils, ZDirSySql, ZSySqlCon, ZSySqlQuery;

{*********** TZSySqlTableNameProperty implementation ***********}

procedure TZSySqlTableNameProperty.GetValueList(Values: TStringList);
var
  Connect: TDirSySQLConnect;
  Transact: TDirSySQLTransact;
  Query: TDirSySQLQuery;
begin
  Connect := TDirSySQLConnect.Create;
  Transact := TDirSySQLTransact.Create(Connect);
  Query := TDirSySQLQuery.Create(Connect, Transact);
  try
    with GetComponent(0) as TZSySqlTable do
    begin
      if Assigned(Database) then
      begin
        Connect.HostName := Database.Host;
        Connect.Database := Database.Database;
        Connect.Login := Database.Login;
        Connect.Passwd := Database.Password;
      end;
      Connect.Connect;
      Transact.Open;
    end;
    if Transact.Active then
    begin
      Query.ShowTables('');
      if Query.Active then
        while not Query.Eof do
        begin
          Values.Add(Query.Field(0));
          Query.Next;
        end;
    end;
  finally
    Query.Free;
    Transact.Free;
    Connect.Free;
  end;
end;

{*********** TZSySqlDatabaseNameProperty implementation ***********}

procedure TZSySqlDatabaseNameProperty.GetValueList(Values: TStringList);
var
  _Connect: TDirSySQLConnect;
  Transact: TDirSySQLTransact;
  Query: TDirSySQLQuery;
begin
  _Connect := TDirSySQLConnect.Create;
  Transact := TDirSySQLTransact.Create(_Connect);
  Query := TDirSySQLQuery.Create(_Connect, Transact);
  try
    with GetComponent(0) as TZSySqlDatabase do
    begin
      _Connect.HostName := Host;
      _Connect.Database := Database;
      _Connect.Login := Login;
      _Connect.Passwd := Password;

      _Connect.Connect;
      Transact.Open;
    end;
    if Transact.Active then
    begin
      Query.ShowDatabases('');
      if Query.Active then
        while not Query.Eof do
        begin
          Values.Add(Query.Field(0));
          Query.Next;
        end;
    end;
  finally
    Query.Free;
    Transact.Free;
    _Connect.Free;
  end;
end;

{ TZSySqlStoredProcNameProperty }

procedure TZSySqlStoredProcNameProperty.GetValueList(Values: TStringList);
var
  Connect: TDirSySQLConnect;
  Transact: TDirSySQLTransact;
//  Query: TDirSySQLQuery;
  StoredProc: TDirSySQLStoredProc;
begin
  Connect := TDirSySQLConnect.Create;
  Transact := TDirSySQLTransact.Create(Connect);
//  Query := TDirSySQLQuery.Create(Connect, Transact);
  StoredProc := TDirSySQLStoredProc.Create(Connect, Transact);
  try
    with GetComponent(0) as TZSySqlStoredProc do
    begin
      if Assigned(Database) then
      begin
        Connect.HostName := Database.Host;
        Connect.Database := Database.Database;
        Connect.Login := Database.Login;
        Connect.Passwd := Database.Password;
      end;
      Connect.Connect;
      Transact.Open;
    end;
    if Transact.Active then
    begin
//      Query.Sql := 'select name from sysobjects where type=''P''';
//      Query.Open;
      StoredProc.ShowStoredProcs;
//      if Query.Active then
      if StoredProc.Active then
      begin
        while not StoredProc.Eof do
        begin
          Values.Add(StoredProc.Field(2));
          StoredProc.Next;
        end;
        StoredProc.Close;
      end;
//        while not Query.Eof do
//        begin
//          Values.Add(Query.Field(0));
//          Query.Next;
//        end;
    end;
  finally
//    Query.Free;
    StoredProc.Free;
    Transact.Free;
    Connect.Free;
  end;
end;

end.
