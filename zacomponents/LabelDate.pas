unit LabelDate;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, Buttons, Messages, Windows;

type
  TLabelDate = class(TLabeledEdit)
  private
    FButton: TSpeedButton;
    FButtonWidth: Integer;
    FDate: TDate;
    FOnButtonClick: TNotifyEvent;
    procedure DoButtonClick(Sender: TObject);
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure DoLabelDateEnter(Sender: TObject);
    procedure DoLabelDateExit(Sender: TObject);
  protected
    procedure SetDate(Value: TDate);
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
    procedure CreateWnd; override;
    function GetMonth(dt: TDate): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Date: TDate read FDate write SetDate;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TLabelDate]);
end;

{ TLabelDate }

constructor TLabelDate.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 LabelPosition        := lpLeft;
 Self.Cursor          := crIBeam;
 OnEnter              := DoLabelDateEnter;
 OnExit               := DoLabelDateExit;
 FButton              := TSpeedButton.Create(Self);
 FButtonWidth         := GetSystemMetrics(SM_CXVSCROLL);
 with FButton do
  begin
   Caption      := '...';
   Cursor       := crArrow;
   Transparent  := false;
   Parent       := Self;
   SetBounds(Width - FButtonWidth -5, -1, FButtonWidth +2, Height-2);
   OnClick      := DoButtonClick;
   OnMouseDown  := DoMouseDown;
  end;
end;

procedure TLabelDate.CreateWnd;
begin
  inherited CreateWnd;
  SendMessage(Handle, EM_SETMARGINS, EC_RIGHTMARGIN, MAKELONG(0, FButtonWidth + 2));
end;

destructor TLabelDate.Destroy;
begin
  FButton.Free;
  inherited;
end;

procedure TLabelDate.DoButtonClick(Sender: TObject);
begin
  SetFocus;
  if Assigned(FOnButtonClick) then FOnButtonClick(Self);
end;

procedure TLabelDate.DoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not Focused and (Button = mbLeft) then
    SetFocus;
end;

procedure TLabelDate.KeyDown(var Key: word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_F4) and (Shift = []) then begin
    DoButtonClick(Self);
    Key := 0;
  end;
end;

procedure TLabelDate.SetDate(Value: TDate);
begin
 FDate := Value;
 if DateToStr(FDate) = '30.12.1899'
   then Text := ''
   else
    if Self.Focused
     then Text := DateToStr(Value)
     else Text := GetMonth(FDate);
end;

procedure TLabelDate.WMSize(var Message: TWMSize);
begin
  inherited;
  FButton.SetBounds(Width - FButtonWidth -5, -1, FButtonWidth +2, Height-2);
end;

function TLabelDate.GetMonth(dt: TDate): String;
 var y, m, d: Word;
begin
 DecodeDate(dt, y, m, d);
 case m of
 1  : result := '€нвар€';
 2  : result := 'феврал€';
 3  : result := 'марта';
 4  : result := 'апрел€';
 5  : result := 'ма€';
 6  : result := 'июн€';
 7  : result := 'июл€';
 8  : result := 'августа';
 9  : result := 'сент€бр€';
 10 : result := 'окт€бр€';
 11 : result := 'но€бр€';
 12 : result := 'декабр€';
 end;
 result := format('%d %s %d г.', [d, result, y]);
end;

procedure TLabelDate.DoLabelDateEnter(Sender: TObject);
begin
  if DateToStr(Date) = '30.12.1899'
   then Text := ''
   else Text := DateToStr(Date);
end;

procedure TLabelDate.DoLabelDateExit(Sender: TObject);
begin
  if Text > '' then
    begin
     Date := StrToDate(Text);
     Text := GetMonth(Date);
    end
   else Date := StrToDate('30.12.1899');
end;

end.
