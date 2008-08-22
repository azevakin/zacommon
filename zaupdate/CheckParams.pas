unit CheckParams;

interface

const
  {$WRITEABLECONST ON}
  REG_KEY: string = '';
  OUT_DIR: string = '';
  FTP_DIR: string = '';

implementation

uses Windows;

const
  ERROR_MESSAGE = '�� ����� ������ ��������� �������!'#13#13+
                  '���������� ���������� ��������� � ����� �����������:'#13+
                  '  1) ���� ������� � �����������.'#13+
                  '  2) ���������� ���� ����� ����������� ����������.'#13+
                  '  3) ���������� � ����������� �� FTP �������.';

var
  Len: Integer;

procedure SetParams;
begin
  REG_KEY := ParamStr(1);
  OUT_DIR := ParamStr(2);
  FTP_DIR := ParamStr(3);

  Len := Length(OUT_DIR);
  if OUT_DIR[Len] = '\' then
    SetLength(OUT_DIR, Len-1);

  {$WRITEABLECONST OFF}
end;

initialization
  if ParamCount = 3 then
    SetParams
  else
  begin
    MessageBox(0, ERROR_MESSAGE, '������', MB_ICONERROR or MB_OK);
    Halt;
  end;
end.
