unit ZADeclension;

interface

type
  { ����� }
  TPadeg = 1..6;
  ///////////////////////////////////////////////////////////
  // 1. // ������������ // Nominitive    // ���?, ���?     //
  // 2. // �����������  // Genitive      // ����?, ����?   //
  // 3. // ���������    // Dative        // ����?, ����?   //
  // 4. // �����������  // Accusative    // ����?, ���?    //
  // 5. // ������������ // Instrumental  // ���?, ���?     //
  // 6. // ����������   // Prepositional // � ���?, � ���? //
  ///////////////////////////////////////////////////////////

  TMonth = 1..12;

const
  DeclensionMons: array[TMonth, TPadeg] of String = (
    ('������', '������', '������', '������', '�������', '������'),
    ('�������', '�������', '�������', '�������', '��������', '�������'),
    ('����', '�����', '�����', '����', '������', '�����'),
    ('������', '������', '������', '������', '�������', '������'),
    ('���', '���', '���', '���', '����', '���'),
    ('����', '����', '����', '����', '�����', '����'),
    ('����', '����', '����', '����', '�����', '����'),
    ('������', '�������', '�������', '������', '��������', '�������'),
    ('��������', '��������', '��������', '��������', '���������', '��������'),
    ('�������', '�������', '�������', '�������', '��������', '�������'),
    ('������', '������', '������', '������', '�������', '������'),
    ('�������', '�������', '�������', '�������', '��������', '�������')
  );

  DeclensionYear: array[TPadeg] of String = (
    '���', '����', '����', '���', '�����', '����'
  );

  { ��� }
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
  Result := StringReplace(EducationForm, '��', '��', []);
end;

function StudentStr(const padeg: TPadeg; const sex: Boolean): String;
begin
  Result := '�������';
  if sex then
    case padeg of
      3: Result := Result + '�';
      5: Result := Result + '��';
      6: Result := Result + '�';
    else
      Result := Result + '�';
    end
  else
    case padeg of
      2: Result := Result + '��';
      4: Result := Result + '��';
    else
      Result := Result + '��';
    end;
end;

function DeclensionInstitute(const S: String): String;
 var p: byte;
begin
 result := S;
 p := Pos('������', AnsiLowerCase(Result));
 if  p > 0 then
   begin
    Delete(Result, p, Length('������'));
    Insert('�������', Result, p);
   end;
 p := Pos('�� ', AnsiLowerCase(Result));
 if  p > 0 then
   begin
    Delete(Result, p, Length('��'));
    Insert('���', Result, p);
   end;
 p := Pos('�� ', AnsiLowerCase(Result));
 if  p > 0 then
   begin
    Delete(Result, p, Length('��'));
    Insert('���', Result, p);
   end;
 p := Pos('��������', AnsiLowerCase(Result));
 if  p > 0 then
   begin
    Delete(Result, p, Length('��������'));
    Insert('���������', Result, p);
   end;
 Result := Trim(FirstUpper(Result));
end;

{
function Years(Value: Word; WithNumber: Boolean): string;
begin
  if (Value < 10) or (Value > 20) then
    case Value of
      1:
        Result := '���';
      2..4:
        Result := '����';
    else
      Result := '���';
    end;
  else
    Result := '���';
  result:= IntToStr(y) + ' ' + result;
end;

function months(y: real): string;
 var completion: integer;
begin
 completion:= StrToInt(RStr(FloatToStr(y), 1));
 if (y < 10) or (y > 20) then
 begin
  case completion of
  1:     result:= '�����';
  2..4:  result:= '������';
  else   result:= '�������';
  end;
 end else result:= '�������';
 result:= FloatToStr(y) + ' ' + result;
end;
}
end.
