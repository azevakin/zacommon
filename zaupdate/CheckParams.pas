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
  ERROR_MESSAGE = 'Не верно заданы параметры запуска!'#13#13+
                  'Приложение необходимо запустить с тремя параметрами:'#13+
                  '  1) Ключ реестра с настройками.'#13+
                  '  2) Директория куда будет установлено обновление.'#13+
                  '  3) Директория с обновлением на FTP сервере.';

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
    MessageBox(0, ERROR_MESSAGE, 'Ошибка', MB_ICONERROR or MB_OK);
    Halt;
  end;
end.
