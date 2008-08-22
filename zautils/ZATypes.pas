unit ZATypes;

interface

uses
  ZPgSqlCon, ZAConst;

type
{ режим работы диалога }
  TDlgMode = (
    dmRead,  { чтение         }
    dmWrite, { вставка        }
    dmEdit); { редактирование }

  TDialogMode = TDlgMode;

  TDictionaryValue = record
    Value: String;
    Id: Integer;
  end;

  TThreeValue = packed record
    First:  String;
    Second: String;
    Third:  String;
  end;

  SexStr = String[8];

  TFam = String[26];
  TNam = String[16];
  TOt = String[22];

  TFIObj = class
    fam: TFam;
    nam: TNam;
    ot: TOt;
    id: Integer;
  end;

  TZADicDataRec = record
    Text: String;
    Id: Int64;
  end;

  TZAEditMode = (doInsert, doUpdate, doRead);

  TZAHandBookRec = record
    Name: String;
    SmallName: String;
    Id: Int64;
    WhatIs: Integer;
  end;

  TZALoginRec = record
    RegistryPath: String;
    DataBase: TZPgSqlDatabase;
  end;

  TZAWhatIsRec = record
    Caption: String;
    WhatIs: Integer;
  end;



  function ThreeValue(const First, Second, Third: String): TThreeValue;

function FIObj(const fam: TFam; const nam: TNam; const ot: TOt; const id: Integer): TFIObj;

function ZADicDataRec(Text: String; Id: Int64): TZADicDataRec;
function ZAHandBookRec(const Name, SmallName: String; const Id: Int64; WhatIs: Integer): TZAHandBookRec;
function ZALoginRec(RegistryPath: String; DataBase: TZPgSqlDatabase): TZALoginRec;
function ZAWhatIsRec(Caption: String; WhatIs: Integer): TZAWhatIsRec;

////////////////////////////////////////////////////////////////////////////////
// переводит 'м'|'М' в 'мужской', 'ж'|'Ж' в 'женский'
function SexCharToStr(Chr: Char): SexStr;
////////////////////////////////////////////////////////////////////////////////
// переводит 'мужской' в 'м', 'женский' в 'ж'
function SexStrToChar(Str: SexStr): Char;
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//  Переводит 'м', 'М' в true остальное в false
////////////////////////////////////////////////////////////////////////////////
function boolSex(const ASex: Char): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////
function boolSex(const ASex: string): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////


implementation


function boolSex(const ASex: Char): Boolean;
begin
  if ASex in ['м','М'] then
    Result := True
  else
    Result := False;
end;

function boolSex(const ASex: string): Boolean;
begin
  Result := boolSex(ASex[1]);
end;


function ThreeValue(const First, Second, Third: String): TThreeValue;
begin
  Result.First := First;
  Result.Second := Second;
  Result.Third := Third;
end;

function ZADicDataRec(Text: String; Id: Int64): TZADicDataRec;
begin
  Result.Text := Text;
  Result.Id := Id;
end;

function ZAHandBookRec(const Name, SmallName: String; const Id: Int64; WhatIs: Integer): TZAHandBookRec;
begin
  Result.Name := Name;
  Result.SmallName := SmallName;
  Result.Id := Id;
  Result.WhatIs := WhatIs;
end;

function ZALoginRec(RegistryPath: String; DataBase: TZPgSqlDatabase): TZALoginRec;
begin
  Result.RegistryPath := RegistryPath;
  Result.DataBase := DataBase;
end;

function ZAWhatIsRec(Caption: String; WhatIs: Integer): TZAWhatIsRec;
begin
  Result.Caption  := Caption;
  Result.WhatIs   := WhatIs;
end;

function SexStrToChar(Str: SexStr): Char;
begin
  Result := ChNull;
  if Str = SRusMale then Result := 'м';
  if Str = SRusFemale then Result := 'ж';
end;

function SexCharToStr(Chr: Char): SexStr;
begin
  case Chr of
    'м', 'М': Result := SRusMale;
    'ж', 'Ж': Result := SRusFemale;
  else
    Result := SNull;
  end;
end;

function FIObj(const fam: TFam; const nam: TNam; const ot: TOt; const id: Integer): TFIObj;
begin
  Result := TFIObj.Create;
  Result.fam := fam;
  Result.nam := nam;
  Result.ot := ot;
  Result.id := id;
end;

end.
