{******************************************************************************

             ��������� TNumberEdit ��� Delphi 7

  ��������: ���� ����� ����������� ���� ������ �����
  ������:   1.0
  ����:     20.12.2003 �.
  �����:    ������� �. �.
  �����:    ������
  ��������: AllowNegative: Boolean - ��������� ���� ������������� ��������
            AllowDecimal:  Boolean - ��������� ���� ���������� �����

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
  { ���� ������ ������� Del(.) �� NumPad,
    �� ����� ������� ��� ��� DecimalSeparator }
  if Key = #46 then Key := DecimalSeparator;
  { �������� �� DecimalSeparator � ��� ������������� }
  Result := (Key = DecimalSeparator) and (Pos(Key, Text) = 0);
end;

function TNumberEdit.CheckDigits(var Key: Char): Boolean;
begin
  { �������� �� ����� � BackSpace }
  Result := Key in ['0'..'9', #8];
  { ���� Key �� ����� � �� BackSpace �� ��� �� ����� }
  if not Result then
  begin
    Key := #0;
    Beep;
  end;
end;

function TNumberEdit.CheckMinus(var Key: Char): Boolean;
begin
  { �������� �� ����� � ��� ������������� }
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
    Insert('0', S, Position+1);  { ����� DecimalSeparator ������ ���� }
    Insert(Key, S, Position+2);  { ��������� DecimalSeparator }
    Text := S;
    SelStart := Position+2;      { ���������� ������ �� �����}
    Key := #0;                     { �� ��� ��� �� ����� }
  end;

begin
  inherited KeyPress(Key);

  if FAllowNegative and CheckMinus(Key) then
  begin
    Position := SelStart;      { ���������� ������� ������� }
    Text := Key + Text;        { ������ ����� � ������ }
    SelStart := Position+1;    { ���������� ������ }
    Key := #0;                 { �� ��� ��� �� ����� }
  end else begin
    if FAllowDecimal and CheckDecimalSeparator(Key) then
    begin
      Position := SelStart;    { ���������� ������� ������� }
      if Position = 0 then     { ���� ����� DecimalSeparator ������ ��� }
        InsertZero
      else
        if FAllowNegative then
        begin
          MPos := Pos('-', Text);
          if MPos = Position then { ���� ����� DecimalSeparator ����� ����� }
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
    { ��������� �� ������� DecimalSeparator }
    Position := Pos(DecimalSeparator, Text);
    if Position > 0 then  { ���� DecimalSeparator ������������ � ������}
    begin
      Text := Copy(Text, 1, Position-1); { �������� ����� ����� }
      SelStart := Position;              { ������ ������ � ����� ������ }
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
    Position := SelStart;                      { ���������� ������� ������� }
    Text := StringReplace(Text, '-', '', []);  { ������� �� ������ ����� }
    SelStart := Position - 1;                  { ���������� ������ }
  end;
end;

constructor TNumberEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  AutoSelect   := False; ��� ���� �� ��� ������
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
