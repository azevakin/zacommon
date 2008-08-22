unit declen;

interface

////////////////////////////////////////////////////////////////////////////////
//    �������� � ����� (pResult) ������� (nLen) ��������� ���������
//  ������� (pLastName), ����� (pFirstName) � �������� (pMiddleName)
//  ���� (bSex: True - �������, False - �������) � �������� �����  (nPadeg).
//  �������� ������� - ��������� ���������� �������� ��������������.
//   0 - �������� ����������;
//  -1 - ������������ �������� ������;
//  -2 - ������������ �������� ����;
//  -3 - ������ ������ ������������ ��� ���������� ���������� �������������� ���.
////////////////////////////////////////////////////////////////////////////////
function GetFIOPadeg(pLastName, pFirstName, pMiddleName: PChar;
  bSex: Boolean; nPadeg: LongInt; pResult: PChar; var nLen: LongInt): Integer; stdcall;
////////////////////////////////////////////////////////////////////////////////
function GetFIOPadegString(const lastName, firstName, middleName: string;
  const bSex: Boolean; const nPadeg: LongInt): string;
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//    �������� � ����� (pResult) ������� (nLen) ��������� ���������
//  ������� (pLastName), ����� (pFirstName) � �������� (pMiddleName)
//  � �������� ����� (nPadeg) � �������������� ������������ ����.
//  �������� ������� - ��������� ���������� �������� ��������������.
//   0 - �������� ����������;
//  -1 - ������������ �������� ������;
//  -2 - ������������ �������� ����;
//  -3 - ������ ������ ������������ ��� ���������� ���������� �������������� ���.
////////////////////////////////////////////////////////////////////////////////
function GetFIOPadegAS(pLastName, pFirstName, pMiddleName: PChar;
  nPadeg: LongInt; pResult: PChar; var nLen: LongInt): Integer; stdcall;
////////////////////////////////////////////////////////////////////////////////
function GetFIOPadegASString(const lastName, firstName, middleName: string;
  const nPadeg: LongInt): string;
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//    �������� � ����� (pResult) ������� (nLen) ��������� ���������
//  ������� ����� � ��������, ���������� ����� ������� (pFIO),
//  ���� (bSex: True - �������, False - �������) � �������� ����� (nPadeg).
//  �������� ������� - ��������� ���������� �������� ��������������.
//   0 - �������� ����������;
//  -1 - ������������ �������� ������;
//  -2 - ������������ �������� ����;
//  -3 - ������ ������ ������������ ��� ���������� ���������� �������������� ���.
////////////////////////////////////////////////////////////////////////////////
function GetFIOPadegFS(pFIO: PChar; bSex: Boolean; nPadeg: LongInt;
  pResult: PChar; var nLen: LongInt):Integer; stdcall;
////////////////////////////////////////////////////////////////////////////////
function GetFIOPadegFSString(const FIO: string; const bSex: Boolean;
  const nPadeg: LongInt): string;
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//    �������� � ����� (pResult) ������� (nLen) ��������� ���������
//  ������� ����� � ��������, ���������� ����� ������� (pFIO),
//  � �������� ����� (nPadeg) � �������������� ������������ ����.
//  �������� ������� - ��������� ���������� �������� ��������������.
//   0 - �������� ����������;
//  -1 - ������������ �������� ������;
//  -2 - ������������ �������� ����;
//  -3 - ������ ������ ������������ ��� ���������� ���������� �������������� ���.
////////////////////////////////////////////////////////////////////////////////
function GetFIOPadegFSAS(pFIO: PChar; nPadeg: LongInt; pResult: PChar;
  var nLen: LongInt):Integer; stdcall;
////////////////////////////////////////////////////////////////////////////////
function GetFIOPadegFSASString(const FIO: string; const nPadeg: LongInt): string;
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//    �������� � ����� (pResult) ������� (nLen) ��������� ���������
//  ����� (pFirstName) � ������� (pLastName)
//  ���� (bSex: True - �������, False - �������) � �������� ����� (nPadeg).
//  �������� ������� - ��������� ���������� �������� ��������������.
//   0 - �������� ����������;
//  -1 - ������������ �������� ������;
//  -2 - ������������ �������� ����;
//  -3 - ������ ������ ������������ ��� ���������� ���������� �������������� ���.
////////////////////////////////////////////////////////////////////////////////
function GetIFPadeg(pFirstName, pLastName: PChar; bSex: Boolean;
  nPadeg: LongInt; pResult: PChar; var nLen: LongInt): Integer; stdcall;
////////////////////////////////////////////////////////////////////////////////
function GetIFPadegString(const firstName, lastName: String; const bSex: Boolean;
  const nPadeg: LongInt): string;
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//    �������� � ����� (pResult) ������� (nLen) ��������� ���������
//  ����� � ������� (pIF), ���������� ����� �������,
//  ���� (bSex: True - �������, False - �������) � ��������� ����� (nPadeg).
//  �������� ������� - ��������� ���������� �������� ��������������.
//   0 - �������� ����������;
//  -1 - ������������ �������� ������;
//  -2 - ������������ �������� ����;
//  -3 - ������ ������ ������������ ��� ���������� ���������� �������������� ���.
////////////////////////////////////////////////////////////////////////////////
function GetIFPadegFromStr(pIF: PChar; bSex: Boolean; nPadeg: LongInt;
  pResult: PChar; var nLen: LongInt): Integer; stdcall;
////////////////////////////////////////////////////////////////////////////////
function GetIFPadegFromStrString(const sIF: string; const bSex: Boolean;
  const nPadeg: LongInt): string;
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//    �������� � ����� (pResult) ������� (nLen) ��������������� ������������
//  ����� ��� ���, ����������� ����� ������� (pFIO) � ������������ ������.
//  �������� ������� - ��������� ���������� �������� ��������������.
////////////////////////////////////////////////////////////////////////////////
function GetNominativePadeg(pFIO, pResult: PChar;
  var nLen: LongInt): Integer; stdcall;
////////////////////////////////////////////////////////////////////////////////
function GetNominativePadegString(const FIO: string): string;
////////////////////////////////////////////////////////////////////////////////


function boolSex(const ASex: Char): Boolean; overload;
function boolSex(const ASex: string): Boolean; overload;

implementation


const
  PadegDLL = 'Padeg.dll';


function GetFIOPadeg; external PadegDLL name 'GetFIOPadeg';
function GetFIOPadegAS; external PadegDLL name 'GetFIOPadegAS';
function GetFIOPadegFS; external PadegDLL name 'GetFIOPadegAS';
function GetFIOPadegFSAS; external PadegDLL name 'GetFIOPadegAS';
function GetIFPadeg; external PadegDLL name 'GetFIOPadegAS';
function GetIFPadegFromStr; external PadegDLL name 'GetFIOPadegAS';
function GetNominativePadeg; external PadegDLL name 'GetFIOPadegAS';



function boolSex(const ASex: Char): Boolean; overload;
begin
  if ASex in ['�','�'] then
    Result := True
  else
    Result := False;
end;

function boolSex(const ASex: string): Boolean; overload;
begin
  if ASex <> '' then
    Result := boolSex(ASex[1])
  else
    Result := True;
end;



function GetFIOPadegString(const lastName, firstName, middleName: string;
  const bSex: Boolean; const nPadeg: LongInt): string;
var
  pRes: array[0..254] of Char;
  nRes, nLen: integer;
begin
  pRes := #0;
  nLen := 255;
  nRes := GetFIOPadeg(
    PChar(lastName), PChar(firstName), PChar(middleName), bSex, nPadeg, pRes, nLen);

  if nRes = 0 then
    result := pRes
  else
    result := '';
end;

function GetFIOPadegASString(const lastName, firstName, middleName: string;
  const nPadeg: LongInt): string;
var
  pRes: array[0..254] of Char;
  nRes, nLen: integer;
begin
  pRes := #0;
  nLen := 255;
  nRes := GetFIOPadegAS(
    PChar(lastName), PChar(firstName), PChar(middleName), nPadeg, pRes, nLen);

  if nRes = 0 then
    result := pRes
  else
    result := '';
end;

function GetFIOPadegFSString(const FIO: string; const bSex: Boolean;
  const nPadeg: LongInt): string;
var
  pRes: array[0..254] of Char;
  nRes, nLen: integer;
begin
  pRes := #0;
  nLen := 255;
  nRes := GetFIOPadegFS(PChar(FIO), bSex, nPadeg, pRes, nLen);

  if nRes = 0 then
    result := pRes
  else
    result := '';
end;

function GetFIOPadegFSASString(const FIO: string; const nPadeg: LongInt): string;
var
  pRes: array[0..254] of Char;
  nRes, nLen: integer;
begin
  pRes := #0;
  nLen := 255;
  nRes := GetFIOPadegFSAS(PChar(FIO), nPadeg, pRes, nLen);

  if nRes = 0 then
    result := pRes
  else
    result := '';
end;

function GetIFPadegString(const firstName, lastName: String; const bSex: Boolean;
  const nPadeg: LongInt): string;
var
  pRes: array[0..254] of Char;
  nRes, nLen: integer;
begin
  pRes := #0;
  nLen := 255;
  nRes := GetIFPadeg(PChar(firstName), PChar(lastName), bSex, nPadeg, pRes, nLen);

  if nRes = 0 then
    result := pRes
  else
    result := '';
end;

function GetIFPadegFromStrString(const sIF: string; const bSex: Boolean;
  const nPadeg: LongInt): string;
var
  pRes: array[0..254] of Char;
  nRes, nLen: integer;
begin
  pRes := #0;
  nLen := 255;
  nRes := GetIFPadegFromStr(PChar(sIF), bSex, nPadeg, pRes, nLen);

  if nRes = 0 then
    result := pRes
  else
    result := '';
end;

function GetNominativePadegString(const FIO: string): string; 
var
  pRes: array[0..254] of Char;
  nRes, nLen: integer;
begin
  pRes := #0;
  nLen := 255;
  nRes := GetNominativePadeg(PChar(FIO), pRes, nLen);

  if nRes = 0 then
    result := pRes
  else
    result := '';
end;

end.