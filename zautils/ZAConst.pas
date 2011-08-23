unit ZAConst;

interface

const
  colorMale = $00FEF5E7;
  colorFemale = $00F5F4FF;

  SRusYes = 'Да';
  SRusNo = 'Нет';

  SRusMale = 'мужской';
  SRusFemale = 'женский';

  SNull = '';
  SSpace = ' ';
  ChNull = #0;

  SHost = 'Host';
  SPort = 'Port';
  SDataBase = 'DataBase';
  SLogin = 'Login';

  SEdit = 'Редактирование';
  SInsert = 'Добавление';

  whereTpl: array[Boolean] of string = (' and ', 'where ');

  notTpl: array[Boolean] of string = (' not ', '');

  SPleaseWait = 'Пожалуйста подождите...';
  SLoadingData = 'Загружаются данные...';
  SNotDataForReport = 'Нет данных удовлетворяющих заданному условию.';
  SWarningSelect = 'Выберите элемент из списка';
  SEnterTextForSearch = 'Введите текст для поиска';

  SDeleteConfirm = 'Удалить "%s"?';

  NullIndex = -1;
  Zero = 0;

  maskForDate = '  .  .    ';

  function isEqual(const first, second: Integer): Boolean; overload;
  function isEqual(const first, second: string): Boolean; overload;
  function isEqual(const first, second: Real): Boolean; overload;
  function isEqual(const first, second: Boolean): Boolean; overload;

  function isNull(const value: string): Boolean;
  function isZero(const value: Integer): Boolean;

implementation

function isEqual(const first, second: Integer): Boolean;
begin
  Result := first = second;
end;

function isEqual(const first, second: string): Boolean;
begin
  Result := first = second;
end;

function isEqual(const first, second: Real): Boolean;
begin
  Result := first = second;
end;

function isEqual(const first, second: Boolean): Boolean;
begin
  Result := first = second;
end;

function isZero(const value: Integer): Boolean;
begin
  Result := isEqual(value, Zero);
end;

function isNull(const value: string): Boolean;
begin
  Result := isEqual(value, SNull);
end;

end.

