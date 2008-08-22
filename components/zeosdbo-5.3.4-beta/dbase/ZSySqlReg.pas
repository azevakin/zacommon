{********************************************************}
{                                                        }
{                 Zeos Database Objects                  }
{              Sybase SQL components registration        }
{                                                        }
{       Copyright (c) 1999-2001 Sergey Seroukhov         }
{    Copyright (c) 1999-2002 Zeos Development Group      }
{                                                        }
{********************************************************}

unit ZSySqlReg;

interface

{$IFNDEF LINUX}
{$INCLUDE ..\Zeos.inc}
{$INCLUDE ..\ZeosDef.inc}
{$ELSE}
{$INCLUDE ../Zeos.inc}
{$INCLUDE ../ZeosDef.inc}
{$ENDIF}

procedure Register;

implementation

uses Classes, ZSySqlCon, ZSySqlTr, ZSySqlQuery, ZSySqlStoredProc
  {$IFDEF WITH_PROPEDIT}, ZSySqlProp, {$IFNDEF VERCLX}DsgnIntf
  {$ELSE}DesignIntf{$ENDIF}{$ENDIF};

{ Register components in a component palette }
procedure Register;
begin
  RegisterComponents(ZEOS_DB_PALETTE, [TZSySqlDatabase]);
{$IFDEF WITH_PROPEDIT}
  RegisterPropertyEditor(TypeInfo(string), TZSySqlDatabase, 'Database',
    TZSySqlDatabaseNameProperty);
{$ENDIF}

  RegisterComponents(ZEOS_DB_PALETTE, [TZSySqlTransact]);

  RegisterComponents(ZEOS_DB_PALETTE, [TZSySqlTable]);
  RegisterComponents(ZEOS_DB_PALETTE, [TZSySqlQuery]);
  RegisterComponents(ZEOS_DB_PALETTE, [TZSySqlStoredProc]);
{$IFDEF WITH_PROPEDIT}
  RegisterPropertyEditor(TypeInfo(string), TZSySqlTable, 'TableName',
    TZSySqlTableNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TZSySqlStoredProc, 'StoredProcName',
    TZSySqlStoredProcNameProperty);
{$ENDIF}
end;

end.
