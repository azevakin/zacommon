unit ZADeclension;

interface

type
  { ѕадеж }
  TPadeg = 1..6;
  ///////////////////////////////////////////////////////////
  // 1. // »менительный // Nominitive    // кто?, что?     //
  // 2. // –одительный  // Genitive      // кого?, чего?   //
  // 3. // ƒательный    // Dative        // кому?, чему?   //
  // 4. // ¬инительный  // Accusative    // кого?, что?    //
  // 5. // “ворительный // Instrumental  // кем?, чем?     //
  // 6. // ѕредложный   // Prepositional // о ком?, о чем? //
  ///////////////////////////////////////////////////////////

  TMonth = 1..12;

const
  DeclensionMons: array[TMonth, TPadeg] of String = (
    ('€нварь', '€нвар€', '€нварю', '€нварь', '€нварем', '€нваре'),
    ('февраль', 'феврал€', 'февралю', 'февраль', 'февралем', 'феврале'),
    ('март', 'марта', 'марту', 'март', 'мартом', 'марте'),
    ('апрель', 'апрел€', 'апрелю', 'апрель', 'апрелем', 'апреле'),
    ('май', 'ма€', 'маю', 'май', 'маем', 'мае'),
    ('июнь', 'июн€', 'июню', 'июнь', 'июнем', 'июне'),
    ('июль', 'июл€', 'июлю', 'июль', 'июлем', 'июле'),
    ('август', 'августа', 'августу', 'август', 'августом', 'августе'),
    ('сент€брь', 'сент€бр€', 'сент€брю', 'сент€брь', 'сент€брем', 'сент€бре'),
    ('окт€брь', 'окт€бр€', 'окт€брю', 'окт€брь', 'окт€брем', 'окт€бре'),
    ('но€брь', 'но€бр€', 'но€брю', 'но€брь', 'но€брем', 'но€бре'),
    ('декабрь', 'декабр€', 'декабрю', 'декабрь', 'декабрем', 'декабре')
  );

  DeclensionYear: array[TPadeg] of String = (
    'год', 'года', 'году', 'год', 'годом', 'годе'
  );

  { ѕол }
  male = True;
  female = False;

  function DeclensionDate(ADate: TDateTime; Padeg: TPadeg): String;
  function DeclensionEducationForm(const EducationForm: String): String;

  function StudentStr(const padeg: TPadeg; const sex: Boolean): String;

  function DeclensionInstitute(const S: String): String;

implementation

uses SysUtils, ZAConst, ZAStrUtils;

function DeclensionDate(ADate: TDateTime; Padeg: TPadeg): String;
var
  year, month, day: Word;
begin
  DecodeDate(ADate, year, month, day);
  Result := Format('%d %s %d %s', [day, DeclensionMons[month, Padeg], year, DeclensionYear[Padeg]]);
end;

function DeclensionEducationForm(const EducationForm: String): String;
begin
  Result := SNull;
  Result := StringReplace(EducationForm, 'а€', 'ой', []);
end;

function StudentStr(const padeg: TPadeg; const sex: Boolean): String;
begin
  Result := 'студент';
  if sex then
    case padeg of
      3: Result := Result + 'у';
      5: Result := Result + 'ом';
      6: Result := Result + 'е';
    else
      Result := Result + 'а';
    end
  else
    case padeg of
      2: Result := Result + 'ку';
      4: Result := Result + 'ки';
    else
      Result := Result + 'ке';
    end;
end;

function DeclensionInstitute(const S: String): String;
 var p: byte;
begin
 result := S;
 p := Pos('филиал', AnsiLowerCase(Result));
 if  p > 0 then
   begin
    Delete(Result, p, Length('филиал'));
    Insert('филиала', Result, p);
   end;
 p := Pos('ий ', AnsiLowerCase(Result));
 if  p > 0 then
   begin
    Delete(Result, p, Length('ий'));
    Insert('ого', Result, p);
   end;
 p := Pos('ый ', AnsiLowerCase(Result));
 if  p > 0 then
   begin
    Delete(Result, p, Length('ый'));
    Insert('ого', Result, p);
   end;
 p := Pos('институт', AnsiLowerCase(Result));
 if  p > 0 then
   begin
    Delete(Result, p, Length('институт'));
    Insert('института', Result, p);
   end;
 Result := Trim(FirstUpper(Result));
end;

{
function Years(Value: Word; WithNumber: Boolean): string;
begin
  if (Value < 10) or (Value > 20) then
    case Value of
      1:
        Result := 'год';
      2..4:
        Result := 'года';
    else
      Result := 'лет';
    end;
  else
    Result := 'лет';
  result:= IntToStr(y) + ' ' + result;
end;

function months(y: real): string;
 var completion: integer;
begin
 completion:= StrToInt(RStr(FloatToStr(y), 1));
 if (y < 10) or (y > 20) then
 begin
  case completion of
  1:     result:= 'мес€ц';
  2..4:  result:= 'мес€ца';
  else   result:= 'мес€цев';
  end;
 end else result:= 'мес€цев';
 result:= FloatToStr(y) + ' ' + result;
end;
}
end.
