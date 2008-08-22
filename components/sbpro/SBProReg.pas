{------------------------------------------------------------------------------}
{                                                                              }
{  TStatusBarPro v1.73                                                         }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{  Special thanks to:                                                          }
{    :: Rudi Loos <loos@intekom.co.za> for Color of panels.                    }
{    :: Alexander Alexishin <sancho@han.kherson.ua> for AutoHintPanelIndex     }
{       and fixing the bug on painting the panels.                             }
{    :: Piet Vandenborre <plsoft@pi.be> for fixing the bug on painting the     }
{       panels.                                                                }
{    :: Viatcheslav V. Vassiliev <vvv@spacenet.ru> for adding the Control      }
{       property to the panels.                                                }
{    :: Roland <Beduerftig@SoftwareCreation.de> for fixing a bug.              }
{                                                                              }
{------------------------------------------------------------------------------}

{$I DELPHIAREA.INC}

unit SBProReg;

interface

uses
  Windows, Classes, {$IFDEF DELPHI6_UP} DesignIntf, DesignEditors {$ELSE} DsgnIntf {$ENDIF};

type
  TStatusBarProEditor = class(TDefaultEditor)
  protected
    {$IFNDEF DELPHI6_UP}
    procedure PanelsEditor(Prop: TPropertyEditor);
    {$ENDIF}
  public
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
    {$IFDEF DELPHI6_UP}
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    {$ELSE}
    procedure Edit; override;
    {$ENDIF}
  end;

procedure Register;

implementation

uses
  SBPro, TypInfo;

function TStatusBarProEditor.GetVerbCount: Integer;
begin
  Result:= 1;
end;

function TStatusBarProEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Panels Editor...'
  else
    Result := inherited GetVerb(Index);
end;

procedure TStatusBarProEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    Edit
  else
    inherited ExecuteVerb(Index);
end;

{$IFDEF DELPHI6_UP}

procedure TStatusBarProEditor.EditProperty(const Prop: IProperty;
  var Continue: Boolean);
begin
  if Prop.GetName = 'Panels' then
  begin
    Prop.Edit;
    Continue := False;
  end;
end;

{$ELSE}

procedure TStatusBarProEditor.PanelsEditor(Prop: TPropertyEditor);
begin
  if Prop.GetName = 'Panels' then
    Prop.Edit;
end;

procedure TStatusBarProEditor.Edit;
var
  {$IFDEF DELPHI5}
  List: TDesignerSelectionList;
  {$ELSE}
  List: TComponentList;
  {$ENDIF}
begin
  {$IFDEF DELPHI5}
  List := TDesignerSelectionList.Create;
  {$ELSE}
  List := TComponentList.Create;
  {$ENDIF}
  try
    List.Add(Component);
    GetComponentProperties(List, [tkClass], Designer, PanelsEditor);
  finally
    List.Free;
  end;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents('Delphi Area', [TStatusBarPro]);
  RegisterComponentEditor(TStatusBarPro, TStatusBarProEditor);
end;

end.
