{*******************************************************}
{*******************************************************}

unit ZAChkList;

{$T-,H+,X+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls;

type
  TZAChkListBox = class(TCustomListBox)
  private
    FAllowGrayed: Boolean;
    FCheckedCount: Integer;
    FFlat: Boolean;
    FStandardItemHeight: Integer;
    FOnClickCheck: TNotifyEvent;
    FSaveStates: TList;
    FHeaderColor: TColor;
    FHeaderBackgroundColor: TColor;
    procedure ResetItemHeight;
    procedure DrawCheck(R: TRect; AState: TCheckBoxState; AEnabled: Boolean);
    procedure SetChecked(Index: Integer; AChecked: Boolean);
    function GetChecked(Index: Integer): Boolean;
    procedure SetState(Index: Integer; AState: TCheckBoxState);
    function GetState(Index: Integer): TCheckBoxState;
    procedure ToggleClickCheck(Index: Integer);
    procedure InvalidateCheck(Index: Integer);
    function CreateWrapper(Index: Integer): TObject;
    function ExtractWrapper(Index: Integer): TObject;
    function GetWrapper(Index: Integer): TObject;
    function HaveWrapper(Index: Integer): Boolean;
    procedure SetFlat(Value: Boolean);
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMDestroy(var Msg : TWMDestroy);message WM_DESTROY;
    function GetItemEnabled(Index: Integer): Boolean;
    procedure SetItemEnabled(Index: Integer; const Value: Boolean);
    function GetHeader(Index: Integer): Boolean;
    procedure SetHeader(Index: Integer; const Value: Boolean);
    procedure SetHeaderBackgroundColor(const Value: TColor);
    procedure SetHeaderColor(const Value: TColor);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
    function InternalGetItemData(Index: Integer): Longint; override;
    procedure InternalSetItemData(Index: Integer; AData: Longint); override;
    procedure SetItemData(Index: Integer; AData: LongInt); override;
    function GetItemData(Index: Integer): LongInt; override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure ResetContent; override;
    procedure DeleteString(Index: Integer); override;
    procedure ClickCheck; dynamic;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function GetCheckWidth: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckedCount: Integer;
    property Checked[Index: Integer]: Boolean read GetChecked write SetChecked;
    procedure Items_Clear;
    property ItemEnabled[Index: Integer]: Boolean read GetItemEnabled write SetItemEnabled;
    property State[Index: Integer]: TCheckBoxState read GetState write SetState;
    property Header[Index: Integer]: Boolean read GetHeader write SetHeader;
    procedure CheckAll;
    procedure UnCheckAll;
  published
    property OnClickCheck: TNotifyEvent read FOnClickCheck write FOnClickCheck;
    property Align;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property Anchors;
    property AutoComplete;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Flat: Boolean read FFlat write SetFlat default True;
    //property ExtendedSelect;
    property Font;
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor default clInfoText;
    property HeaderBackgroundColor: TColor read FHeaderBackgroundColor write SetHeaderBackgroundColor default clInfoBk;
    property ImeMode;
    property ImeName;
    property IntegralHeight;
    property ItemHeight;
    property Items;
    //property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property Style;
    property TabOrder;
    property TabStop;
    property TabWidth;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnData;
    property OnDataFind;
    property OnDataObject;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

function GetValues(lb: TZAChkListBox): string;
function GetValue(lb: TZAChkListBox): string;
function GetIDs(lb: TZAChkListBox): string;
function GetID(lb: TZAChkListBox): Integer;
procedure Register;

implementation

uses Consts, RTLConsts, Themes, ZAConst, ZAClasses;

function GetID(lb: TZAChkListBox): Integer;
var
  I, Len: Integer;

begin
  Len := lb.Count-1;
  Result := 0;

  for I := 0 to Len do
    if lb.Checked[I] then
    begin
      Result := TID(lb.Items.Objects[I]).ID;
      Break;
    end;
end;

function GetIDs(lb: TZAChkListBox): string;
const
  Separator = ',';

var
  I, Len: Integer;

begin
  Len := lb.Count-1;
  Result := SNull;

  for I := 0 to Len do
    if lb.Checked[I] then
      Result := Result + IntToStr(TID(lb.Items.Objects[I]).ID) + Separator;

  if Result <> SNull then
    Delete(Result, Length(Result), 1);
end;

function GetValue(lb: TZAChkListBox): string;
var
  I, Len: Integer;

begin
  Len := lb.Count-1;
  Result := SNull;

  for I := 0 to Len do
    if lb.Checked[I] then
    begin
      Result := lb.Items[I];
      Break;
    end;
end;

function GetValues(lb: TZAChkListBox): string;
const
  Separator = ', ';

var
  I, Len: Integer;

begin
  Len := lb.Count-1;
  Result := SNull;

  for I := 0 to Len do
    if lb.Checked[I] then
      Result := Result + lb.Items[I] + Separator;

  if Result <> SNull then
    Delete(Result, Length(Result)-1, 2);
end;

procedure Register;
begin
  RegisterComponents('Samples', [TZAChkListBox]);
end;

type
  TCheckListBoxDataWrapper = class
  private
    FData: LongInt;
    FState: TCheckBoxState;
    FDisabled: Boolean;
    FHeader: Boolean;
  public
    class function GetDefaultState: TCheckBoxState;
    property State: TCheckBoxState read FState write FState;
    property Disabled: Boolean read FDisabled write FDisabled;
    property Header: Boolean read FHeader write FHeader;
  end;

var
  FCheckWidth, FCheckHeight: Integer;

procedure GetCheckSize;
begin
  with TBitmap.Create do
    try
      Handle := LoadBitmap(0, PChar(OBM_CHECKBOXES));
      FCheckWidth := Width div 4;
      FCheckHeight := Height div 3;
    finally
      Free;
    end;
end;

function MakeSaveState(State: TCheckBoxState; Disabled: Boolean): TObject;
begin
  Result := TObject((Byte(State) shl 16) or Byte(Disabled));
end;

function GetSaveState(AObject: TObject): TCheckBoxState;
begin
  Result := TCheckBoxState(Integer(AObject) shr 16);
end;

function GetSaveDisabled(AObject: TObject): Boolean;
begin
  Result := Boolean(Integer(AObject) and $FF);
end;

{ TCheckListBoxDataWrapper }

class function TCheckListBoxDataWrapper.GetDefaultState: TCheckBoxState;
begin
  Result := cbUnchecked;
end;

{ TCheckListBox }

constructor TZAChkListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCheckedCount := 0;
  FFlat := True;
  FHeaderColor := clInfoText;
  FHeaderBackgroundColor := clInfoBk;
end;

destructor TZAChkListBox.Destroy;
begin
  FSaveStates.Free;
  inherited;
end;

procedure TZAChkListBox.CreateWnd;
var
  I: Integer;
  Wrapper: TCheckListBoxDataWrapper;
  SaveState: TObject;
begin
  inherited CreateWnd;
  if FSaveStates <> nil then
  begin
    for I := 0 to FSaveStates.Count - 1 do
    begin
      Wrapper := TCheckListBoxDataWrapper(GetWrapper(I));
      SaveState := FSaveStates[I];
      Wrapper.FState := GetSaveState(SaveState);
      Wrapper.FDisabled := GetSaveDisabled(SaveState);
    end;
    FreeAndNil(FSaveStates);
  end;
  ResetItemHeight;
end;

procedure TZAChkListBox.DestroyWnd;
var
  I: Integer;
begin
  if Items.Count > 0 then
  begin
    FSaveStates := TList.Create;
    for I := 0 to Items.Count - 1 do
      FSaveStates.Add(MakeSaveState(State[I], not ItemEnabled[I]));
  end;
  inherited DestroyWnd;
end;

procedure TZAChkListBox.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
    if Style and (LBS_OWNERDRAWFIXED or LBS_OWNERDRAWVARIABLE) = 0 then
      Style := Style or LBS_OWNERDRAWFIXED;
end;

function TZAChkListBox.GetCheckWidth: Integer;
begin
  Result := FCheckWidth + 2;
end;

procedure TZAChkListBox.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResetItemHeight;
end;

procedure TZAChkListBox.ResetItemHeight;
begin
  if HandleAllocated and (Style = lbStandard) then
  begin
    Canvas.Font := Font;
    FStandardItemHeight := Canvas.TextHeight('Wg');
    Perform(LB_SETITEMHEIGHT, 0, FStandardItemHeight);
  end;
end;

procedure TZAChkListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  R: TRect;
  SaveEvent: TDrawItemEvent;
  ACheckWidth: Integer;
  Enable: Boolean;
begin
  ACheckWidth := GetCheckWidth;
  if Index < Items.Count then
  begin
    R := Rect;
    Enable := Self.Enabled and GetItemEnabled(Index);
    if not Header[Index] then
    begin
      if not UseRightToLeftAlignment then
      begin
        R.Right := Rect.Left;
        R.Left := R.Right - ACheckWidth;
      end
      else
      begin
        R.Left := Rect.Right;
        R.Right := R.Left + ACheckWidth;
      end;
      DrawCheck(R, GetState(Index), Enable);
    end
    else
    begin
      Canvas.Font.Color := HeaderColor;
      Canvas.Brush.Color := HeaderBackgroundColor;
    end;
    if not Enable then
      Canvas.Font.Color := clGrayText;
  end;

  if (Style = lbStandard) and Assigned(OnDrawItem) then
  begin
    { Force lbStandard list to ignore OnDrawItem event. }
    SaveEvent := OnDrawItem;
    OnDrawItem := nil;
    try
      inherited;
    finally
      OnDrawItem := SaveEvent;
    end;
  end
  else
    inherited;
end;

procedure TZAChkListBox.CNDrawItem(var Message: TWMDrawItem);
begin
  if Items.Count = 0 then exit;
  with Message.DrawItemStruct^ do
    if not Header[itemID] then
      if not UseRightToLeftAlignment then
        rcItem.Left := rcItem.Left + GetCheckWidth
      else
        rcItem.Right := rcItem.Right - GetCheckWidth;
  inherited;
end;

procedure TZAChkListBox.DrawCheck(R: TRect; AState: TCheckBoxState; AEnabled: Boolean);
var
  DrawState: Integer;
  DrawRect: TRect;
  OldBrushColor: TColor;
  OldBrushStyle: TBrushStyle;
  OldPenColor: TColor;
  Rgn, SaveRgn: HRgn;
  ElementDetails: TThemedElementDetails;
begin
  SaveRgn := 0;
  DrawRect.Left := R.Left + (R.Right - R.Left - FCheckWidth) div 2;
  DrawRect.Top := R.Top + (R.Bottom - R.Top - FCheckHeight) div 2;
  DrawRect.Right := DrawRect.Left + FCheckWidth;
  DrawRect.Bottom := DrawRect.Top + FCheckHeight;
  with Canvas do
  begin
    if Flat then
    begin
      { Remember current clipping region }
      SaveRgn := CreateRectRgn(0,0,0,0);
      GetClipRgn(Handle, SaveRgn);
      { Clip 3d-style checkbox to prevent flicker }
      with DrawRect do
        Rgn := CreateRectRgn(Left + 2, Top + 2, Right - 2, Bottom - 2);
      SelectClipRgn(Handle, Rgn);
      DeleteObject(Rgn);
    end;

   if ThemeServices.ThemesEnabled then
   begin
      case AState of
        cbChecked:
          if AEnabled then
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal)
          else
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxCheckedDisabled);
        cbUnchecked:
          if AEnabled then
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxUncheckedNormal)
          else
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxUncheckedDisabled)
        else // cbGrayed
          if AEnabled then
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxMixedNormal)
          else
            ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxMixedDisabled);
      end;
      ThemeServices.DrawElement(Handle, ElementDetails, R);
    end
    else
    begin
      case AState of
        cbChecked:
          DrawState := DFCS_BUTTONCHECK or DFCS_CHECKED;
        cbUnchecked:
          DrawState := DFCS_BUTTONCHECK;
        else // cbGrayed
          DrawState := DFCS_BUTTON3STATE or DFCS_CHECKED;
      end;
      if not AEnabled then
        DrawState := DrawState or DFCS_INACTIVE;
      DrawFrameControl(Handle, DrawRect, DFC_BUTTON, DrawState);
    end;

    if Flat then
    begin
      SelectClipRgn(Handle, SaveRgn);
      DeleteObject(SaveRgn);
      { Draw flat rectangle in-place of clipped 3d checkbox above }
      OldBrushStyle := Brush.Style;
      OldBrushColor := Brush.Color;
      OldPenColor := Pen.Color;
      Brush.Style := bsClear;
      Pen.Color := clBtnShadow;
      with DrawRect do
        Rectangle(Left + 1, Top + 1, Right - 1, Bottom - 1);
      Brush.Style := OldBrushStyle;
      Brush.Color := OldBrushColor;
      Pen.Color := OldPenColor;
    end;
  end;
end;

procedure TZAChkListBox.SetChecked(Index: Integer; AChecked: Boolean);
const
  cb_states: array[Boolean] of TCheckBoxState = (cbUnchecked, cbChecked);
begin
  if AChecked <> GetChecked(Index) then
    SetState(Index, cb_states[AChecked]);
end;

procedure TZAChkListBox.SetItemEnabled(Index: Integer; const Value: Boolean);
begin
  if Value <> GetItemEnabled(Index) then
  begin
    TCheckListBoxDataWrapper(GetWrapper(Index)).Disabled := not Value;
    InvalidateCheck(Index);
  end;
end;

procedure TZAChkListBox.SetState(Index: Integer; AState: TCheckBoxState);
const
  delta: array[TCheckBoxState] of Shortint = (-1, 1, -1);
begin
  if AState <> GetState(Index) then
  begin
    if AState <> TCheckListBoxDataWrapper(GetWrapper(Index)).State then
      Inc(FCheckedCount, delta[AState]);

    TCheckListBoxDataWrapper(GetWrapper(Index)).State := AState;
    InvalidateCheck(Index);
  end;
end;

procedure TZAChkListBox.InvalidateCheck(Index: Integer);
var
  R: TRect;
begin
  if not Header[Index] then
  begin
    R := ItemRect(Index);
    if not UseRightToLeftAlignment then
      R.Right := R.Left + GetCheckWidth
    else
      R.Left := R.Right - GetCheckWidth;
    InvalidateRect(Handle, @R, not (csOpaque in ControlStyle));
    UpdateWindow(Handle);
  end;
end;

function TZAChkListBox.GetChecked(Index: Integer): Boolean;
begin
  Result := GetState(Index) = cbChecked;
end;

function TZAChkListBox.GetItemEnabled(Index: Integer): Boolean;
begin
  if HaveWrapper(Index) then
    Result := not TCheckListBoxDataWrapper(GetWrapper(Index)).Disabled
  else
    Result := True;
end;

function TZAChkListBox.GetState(Index: Integer): TCheckBoxState;
begin
  if HaveWrapper(Index) then
    Result := TCheckListBoxDataWrapper(GetWrapper(Index)).State
  else
    Result := TCheckListBoxDataWrapper.GetDefaultState;
end;

procedure TZAChkListBox.KeyPress(var Key: Char);
begin
  if (Key = ' ') then
    ToggleClickCheck(ItemIndex);
  inherited KeyPress(Key);
end;

procedure TZAChkListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Index: Integer;
begin
  inherited;
  if Button = mbLeft then
  begin
    Index := ItemAtPos(Point(X,Y),True);
    if (Index <> -1) and GetItemEnabled(Index) then
      if not UseRightToLeftAlignment then
      begin
        if X - ItemRect(Index).Left < GetCheckWidth then
          ToggleClickCheck(Index)
      end
      else
      begin
        Dec(X, ItemRect(Index).Right - GetCheckWidth);
        if (X > 0) and (X < GetCheckWidth) then
          ToggleClickCheck(Index)
      end;
  end;
end;

procedure TZAChkListBox.ToggleClickCheck;
var
  State: TCheckBoxState;
begin
  if (Index >= 0) and (Index < Items.Count) and GetItemEnabled(Index) then
  begin
    State := Self.State[Index];
    case State of
      cbUnchecked:
        if AllowGrayed then State := cbGrayed else State := cbChecked;
      cbChecked: State := cbUnchecked;
      cbGrayed: State := cbChecked;
    end;
    Self.State[Index] := State;
    ClickCheck;
  end;
end;

procedure TZAChkListBox.ClickCheck;
begin
  if Assigned(FOnClickCheck) then FOnClickCheck(Self);
end;

function TZAChkListBox.GetItemData(Index: Integer): LongInt;
begin
  Result := 0;
  if HaveWrapper(Index) then
    Result := TCheckListBoxDataWrapper(GetWrapper(Index)).FData;
end;

function TZAChkListBox.GetWrapper(Index: Integer): TObject;
begin
  Result := ExtractWrapper(Index);
  if Result = nil then
    Result := CreateWrapper(Index);
end;

function TZAChkListBox.ExtractWrapper(Index: Integer): TObject;
begin
  Result := TCheckListBoxDataWrapper(inherited GetItemData(Index));
  if LB_ERR = Integer(Result) then
    raise EListError.CreateResFmt(@SListIndexError, [Index]);
  if (Result <> nil) and (not (Result is TCheckListBoxDataWrapper)) then
    Result := nil;
end;

function TZAChkListBox.InternalGetItemData(Index: Integer): LongInt;
begin
  Result := inherited GetItemData(Index);
end;

procedure TZAChkListBox.InternalSetItemData(Index: Integer; AData: LongInt);
begin
  inherited SetItemData(Index, AData);
end;

function TZAChkListBox.CreateWrapper(Index: Integer): TObject;
begin
  Result := TCheckListBoxDataWrapper.Create;
  inherited SetItemData(Index, LongInt(Result));
end;

function TZAChkListBox.HaveWrapper(Index: Integer): Boolean;
begin
  Result := ExtractWrapper(Index) <> nil;
end;

procedure TZAChkListBox.SetItemData(Index: Integer; AData: LongInt);
var
  Wrapper: TCheckListBoxDataWrapper;
begin
  if HaveWrapper(Index) or (AData <> 0) then
  begin
    Wrapper := TCheckListBoxDataWrapper(GetWrapper(Index));
    Wrapper.FData := AData;
  end;
end;

procedure TZAChkListBox.ResetContent;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    if HaveWrapper(I) then
      GetWrapper(I).Free;
  inherited;
end;

procedure TZAChkListBox.DeleteString(Index: Integer);
begin
  if HaveWrapper(Index) then
    GetWrapper(Index).Free;
  inherited;
end;

procedure TZAChkListBox.SetFlat(Value: Boolean);
begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    Invalidate;
  end;
end;

procedure TZAChkListBox.WMDestroy(var Msg: TWMDestroy);
var
  i: Integer;
begin
  for i := 0 to Items.Count -1 do
    ExtractWrapper(i).Free;
  inherited;
end;

function TZAChkListBox.GetHeader(Index: Integer): Boolean;
begin
  if HaveWrapper(Index) then
    Result := TCheckListBoxDataWrapper(GetWrapper(Index)).Header
  else
    Result := False;
end;

procedure TZAChkListBox.SetHeader(Index: Integer; const Value: Boolean);
begin
  if Value <> GetHeader(Index) then
  begin
    TCheckListBoxDataWrapper(GetWrapper(Index)).Header := Value;
    InvalidateCheck(Index);
  end;
end;

procedure TZAChkListBox.SetHeaderBackgroundColor(const Value: TColor);
begin
  if Value <> HeaderBackgroundColor then
  begin
    FHeaderBackgroundColor := Value;
    Invalidate;
  end;
end;

procedure TZAChkListBox.SetHeaderColor(const Value: TColor);
begin
  if Value <> HeaderColor then
  begin
    FHeaderColor := Value;
    Invalidate;
  end;
end;

function TZAChkListBox.CheckedCount: Integer;
begin
  Result := FCheckedCount;
end;

procedure TZAChkListBox.Items_Clear;
begin
  Items.Clear;
  FCheckedCount := 0;
end;

procedure TZAChkListBox.CheckAll;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    Checked[I] := True;
end;

procedure TZAChkListBox.UnCheckAll;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    Checked[I] := False;
end;

initialization
  GetCheckSize;

end.
