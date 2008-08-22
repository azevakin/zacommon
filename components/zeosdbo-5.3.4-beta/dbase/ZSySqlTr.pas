{********************************************************}
{                                                        }
{                 Zeos Database Objects                  }
{              Sybase SQL Transaction component          }
{                                                        }
{       Copyright (c) 1999-2001 Sergey Seroukhov         }
{    Copyright (c) 1999-2002 Zeos Development Group      }
{                                                        }
{********************************************************}

unit ZSySqlTr;

interface

{$R *.dcr}

uses
  Classes, ZDirSySql, ZSySqlCon, ZTransact, ZSqlTypes;

{$IFNDEF LINUX}
{$INCLUDE ..\Zeos.inc}
{$ELSE}
{$INCLUDE ../Zeos.inc}
{$ENDIF}

type
  { Sybase SQL transaction }
  TZSySqlTransact = class(TZTransact)
  private
    function  GetDatabase: TZSySqlDatabase;
    procedure SetDatabase(Value: TZSySqlDatabase);
  public
    constructor Create(AOwner: TComponent); override;

    procedure AddMonitor(Monitor: TZMonitor); override;
    procedure DeleteMonitor(Monitor: TZMonitor); override;
  published
    property Database: TZSySqlDatabase read GetDatabase write SetDatabase;
    property TransactSafe;
  end;

implementation

{***************** TZSySqlTransact implementation *****************}

{ Class constructor }
constructor TZSySqlTransact.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := TDirSySQLTransact.Create(nil);
  FQuery  := TDirSySQLQuery.Create(nil, TDirSySQLTransact(FHandle));
  FDatabaseType := dtMSSQL;
end;

{ Get database component }
function TZSySqlTransact.GetDatabase: TZSySqlDatabase;
begin
  Result := TZSySqlDatabase(FDatabase);
end;

{ Set database component }
procedure TZSySqlTransact.SetDatabase(Value: TZSySqlDatabase);
begin
  inherited SetDatabase(Value);
end;

{ Add monitor into monitor list }
procedure TZSySqlTransact.AddMonitor(Monitor: TZMonitor);
begin
  ZDirSySql.MonitorList.AddMonitor(Monitor);
end;

{ Delete monitor from monitor list }
procedure TZSySqlTransact.DeleteMonitor(Monitor: TZMonitor);
begin
  ZDirSySql.MonitorList.DeleteMonitor(Monitor);
end;

end.
