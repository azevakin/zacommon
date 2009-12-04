{******************************************************************************

             Компонент TNumberEdit для Delphi 7

  Описание: Поле ввода допускающее ввод только чисел
  Версия:   1.0
  Дата:     20.12.2003 г.
  Автор:    Зевакин А. С.
  Город:    Тюмень
  Свойства: AllowNegative: Boolean - допускает ввод отрицательных значений
            AllowDecimal:  Boolean - допускает ввод десятичних чисел

*******************************************************************************}

unit NumberEdit;

interface

uses
  SysUtils, Classes, Controls, StdCtrls;

type
  TNumberEdit = class(TCustomEdit)
  private
    FAllowDecimal: Boolean;
    FAllowNegative: Boolean;
    FOnKeyPress: TKeyPressEvent;
    function CheckDecimalSeparator(var Key: Char): Boolean;
    function CheckDigits(var Key: Char): Boolean;
    function CheckMinus(var Key: Char): Boolean;
    procedure SetAllowDecimal(const Value: Boolean);
    procedure SetAllowNegative(const Value: Boolean);
  protected
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    function DecimalValue: Single;
    function IntegerValue: Integer;
    property AllowDecimal: Boolean read FAllowDecimal write SetAllowDecimal default False;
    property AllowNegative: Boolean read FAllowNegative write SetAllowNegative default False;
    property Anchors;
    property AutoSize;
    property AutoSelect;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TNumberEdit]);
end;

{ TNumberEdit }

function TNumberEdit.CheckDecimalSeparator(var Key: Char): Boolean;
begin
  { Если нажата клавиша Del(.) на NumPad,
    то будем считать что это DecimalSeparator }
  if Key = #46 then Key := DecimalSeparator;
  { Проверка на DecimalSeparator и его повторяемость }
  Result := (Key = DecimalSeparator) and (Pos(Key, Text) = 0);
end;

function TNumberEdit.CheckDigits(var Key: Char): Boolean;
begin
  { Проверка на цифры и BackSpace }
  Result := Key in ['0'..'9', #8];
  { Если Key не цифра и не BackSpace он нам не нужен }
  if not Result then
  begin
    Key := #0;
    Beep;
  end;
end;

function TNumberEdit.CheckMinus(var Key: Char): Boolean;
begin
  { Проверка на минус и его повторяемость }
  Result := (Key = '-') and (Pos(Key, Text) = 0);
end;

procedure TNumberEdit.KeyPress(var Key: Char);
var
  Position, MPos: Integer;

  procedure InsertZero();
  var
    S: String;
  begin
    S := Text;
    Insert('0', S, Position+1);  { Перед DecimalSeparator ставим ноль }
    Insert(Key, S, Position+2);  { Добавляем DecimalSeparator }
    Text := S;
    SelStart := Position+2;      { Возвращаем курсор на место}
    Key := #0;                     { Он нам уже не нужен }
  end;

begin
  inherited KeyPress(Key);

  if FAllowNegative and CheckMinus(Key) then
  begin
    Position := SelStart;      { Запоминаем позицию курсора }
    Text := Key + Text;        { Ставим минус в начало }
    SelStart := Position+1;    { Возвращаем курсор }
    Key := #0;                 { Он нам уже не нужен }
  end else begin
    if FAllowDecimal and CheckDecimalSeparator(Key) then
    begin
      Position := SelStart;    { Запоминаем позицию курсора }
      if Position = 0 then     { Если перед DecimalSeparator ничего нет }
        InsertZero
      else
        if FAllowNegative then
        begin
          MPos := Pos('-', Text);
          if MPos = Position then { Если перед DecimalSeparator стоит минус }
            InsertZero;
        end;
    end else
      CheckDigits(Key);
  end;

  if Assigned(FOnKeyPress) then FOnKeyPress(Self, Key);
end;

procedure TNumberEdit.SetAllowDecimal(const Value: Boolean);
var
  Position: Integer;
begin
  FAllowDecimal := Value;
  if not FAllowDecimal then
  begin
    { Проверяем на наличие DecimalSeparator }
    Position := Pos(DecimalSeparator, Text);
    if Position > 0 then  { Если DecimalSeparator присутствует в тексте}
    begin
      Text := Copy(Text, 1, Position-1); { Копируем целую часть }
      SelStart := Position;              { Ставим курсор в конец текста }
    end;
  end;
end;

procedure TNumberEdit.SetAllowNegative(const Value: Boolean);
var
  Position: Integer;
begin
  FAllowNegative := Value;
  if not FAllowNegative and (Pos('-', Text) > 0) then
  begin
    Position := SelStart;                      { Запоминаем позицию курсора }
    Text := StringReplace(Text, '-', '', []);  { Удаляем из текста минус }
    SelStart := Position - 1;                  { Возвращаем курсор }
  end;
end;

constructor TNumberEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  AutoSelect   := False; без него не так удобно
  ControlStyle := ControlStyle - [csSetCaption];
end;

function TNumberEdit.DecimalValue: Single;
begin
  Result := StrToFloat(Text);
end;

function TNumberEdit.IntegerValue: Integer;
begin
  Result := StrToInt(Text);
end;

end.
