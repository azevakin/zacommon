{********************************************************}
{                                                        }
{                 Zeos Database Objects                  }
{              Sybase SQL Transaction component          }
{                                                        }
{       Copyright (c) 1999-2001 Sergey Seroukhov         }
{    Copyright (c) 1999-2002 Zeos Development Group      }
{                                                        }
{********************************************************}

unit ZSySqlCon;

interface

{$R *.dcr}

uses
  Classes, ZConnect, ZDirSySql;

{$IFNDEF LINUX}
{$INCLUDE ..\Zeos.inc}
{$ELSE}
{$INCLUDE ../Zeos.inc}
{$ENDIF}

type
  { Sybase SQL database }
  TZSySqlDatabase = class(TZDatabase)
  public
    constructor Create(AOwner: TComponent); override;
  published
    property  Host;
    property  Database;
    property  Encoding;
    property  Login;
    property  Password;
    property  LoginPrompt;
    property  Connected;
  end;

implementation

{***************** TSySQLDatabase implementation *****************}

{ Class constructor }
constructor TZSySqlDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := TDirSySQLConnect.Create;
end;

end.
