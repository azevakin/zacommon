{********************************************************}
{                                                        }
{                 Zeos Database Objects                  }
{            Database components registration            }
{                                                        }
{       Copyright (c) 1999-2001 Sergey Seroukhov         }
{    Copyright (c) 1999-2002 Zeos Development Group      }
{                                                        }
{********************************************************}

unit ZDBaseReg;

interface

{$IFNDEF LINUX}
{$INCLUDE ..\ZeosDef.inc}
{$INCLUDE ..\Zeos.inc}
{$ELSE}
{$INCLUDE ../ZeosDef.inc}
{$INCLUDE ../Zeos.inc}
{$ENDIF}

procedure Register;

implementation

uses Classes, ZTransact, ZUpdateSql, ZQuery
{$IFDEF WITH_PROPEDIT},ZProperty, ZLinkProp,
{$IFDEF VERCLX}
DesignIntf
{$ELSE}
{$IFDEF VER150ABOVE}
DesignIntf
{$ELSE}
DsgnIntf
{$ENDIF}{$ENDIF}
{$ENDIF};

{ Register component in a component pallette }
procedure Register;
begin
  RegisterComponents(ZEOS_DB_PALETTE, [TZBatchSql]);
  RegisterComponents(ZEOS_DB_PALETTE, [TZMonitor]);
  RegisterComponents(ZEOS_DB_PALETTE, [TZUpdateSql]);

{$IFDEF WITH_PROPEDIT}
  RegisterPropertyEditor(TypeInfo(string), TZDataset, 'IndexFieldNames',
    TZIndexFieldNamesProperty);
  RegisterPropertyEditor(TypeInfo(string), TZDataset, 'IndexName',
    TZIndexNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TZDataset, 'LinkFields',
    TZLinkFieldsProperty);
{$ENDIF}
end;

end.
