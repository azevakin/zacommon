{------------------------------------------------------------------------------}
{                                                                              }
{  TStatusBarPro v1.73                                                         }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{  Special thanks to:                                                          }
{    :: Rudi Loos <loos@intekom.co.za> for Color of panels.                    }
{    :: Alexander Alexishin <sancho@han.kherson.ua> for AutoHintPanelIndex     }
{       and fixing the bug on painting the panels.                             }
{    :: Piet Vandenborre <plsoft@pi.be> for fixing the bug on painting the     }
{       panels.                                                                }
{    :: Viatcheslav V. Vassiliev <vvv@spacenet.ru> for adding the Control      }
{       property to the panels.                                                }
{    :: Roland <Beduerftig@SoftwareCreation.de> for fixing a bug.              }
{                                                                              }
{------------------------------------------------------------------------------}

{$I DELPHIAREA.INC}

unit SBPro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls {$IFNDEF DELPHI3}, ImgList {$ENDIF};

type

  TStatusBarPro = class;

  TStatusPanelPro = class(TCollectionItem)
  private
    FText: String;
    FHint: String;
    FImageIndex: Integer;
    FPopupMenu: TPopupMenu;
    FWidth: Integer;
    FMinWidth: Integer;
    FMaxWidth: Integer;
    FAutoWidth: Boolean;
    FAutoSize: Boolean;
    FColor: TColor;                                                     {RAL}
    FParentColor: Boolean;
    FAlignment: TAlignment;
    FBevel: TStatusPanelBevel;
    {$IFDEF DELPHI4_UP}
    FBiDiMode: TBiDiMode;
    FParentBiDiMode: Boolean;
    {$ENDIF}
    FFont: TFont;
    FParentFont: Boolean;
    FIndent: Integer;
    FStyle: TStatusPanelStyle;
    FControl: TControl;                                                 {VVV}
    FUpdateNeeded: Boolean;
    FOnCLick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    procedure SetHint(Value: String);
    procedure SetImageIndex(Value: Integer);
    procedure SetPopupMenu(Value: TPopupMenu);
    procedure SetAlignment(Value: TAlignment);
    procedure SetBevel(Value: TStatusPanelBevel);
    procedure SetStyle(Value: TStatusPanelStyle);
    procedure SetText(const Value: string);
    procedure SetWidth(Value: Integer);
    procedure SetMinWidth(Value: Integer);
    procedure SetMaxWidth(Value: Integer);
    procedure SetAutoWidth(Value: Boolean);
    procedure SetAutoSize(Value: Boolean);
    procedure SetControl(Value: TControl);                              {VVV}
    procedure SetColor(Value: TColor);                                  {RAL}
    procedure SetParentColor(Value: Boolean);
    function IsColorStored: Boolean;
    {$IFDEF DELPHI4_UP}
    procedure SetBiDiMode(Value: TBiDiMode);
    procedure SetParentBiDiMode(Value: Boolean);
    function IsBiDiModeStored: Boolean;
    {$ENDIF}
    procedure SetFont(Value: TFont);
    procedure SetParentFont(Value: Boolean);
    procedure FontChanged(Sender: TObject);
    function IsFontStored: Boolean;
    procedure SetIndent(Value: Integer);
  protected
    function GetDisplayName: string; override;
    procedure UpdateControlBounds; virtual;                                {VVV}
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    {$IFDEF DELPHI4_UP}
    function UseRightToLeftAlignment: Boolean;
    function UseRightToLeftReading: Boolean;
    procedure ParentBiDiModeChanged;
    {$ENDIF}
    procedure ParentColorChanged;
    procedure ParentFontChanged;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property AutoWidth: Boolean read FAutoWidth write SetAutoWidth default False;
    property Bevel: TStatusPanelBevel read FBevel write SetBevel default pbLowered;
    {$IFDEF DELPHI4_UP}
    property BiDiMode: TBiDiMode read FBiDiMode write SetBiDiMode stored IsBiDiModeStored;
    {$ENDIF}
    property Color: TColor read FColor write SetColor stored IsColorStored;     {RAL}
    property Control: TControl read FControl write SetControl;                  {VVV}
    property Font: TFont read FFont write SetFont stored IsFontStored;
    property Hint: String read FHint write SetHint;
    property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
    property Indent: Integer read FIndent write SetIndent default 0;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth default 10000;
    property MinWidth: Integer read FMinWidth write SetMinWidth default 0;
    {$IFDEF DELPHI4_UP}
    property ParentBiDiMode: Boolean read FParentBiDiMode write SetParentBiDiMode default True;
    {$ENDIF}
    property ParentColor: Boolean read FParentColor write SetParentColor default True;
    property ParentFont: Boolean read FParentFont write SetParentFont default True;
    property PopupMenu: TPopupMenu read FPopupMenu write SetPopupMenu;
    property Style: TStatusPanelStyle read FStyle write SetStyle default psText;
    property Text: string read FText write SetText;
    property Width: Integer read FWidth write SetWidth;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
  end;

  TStatusPanelsPro = class(TCollection)
  private
    FStatusBar: TStatusBarPro;
    function GetItem(Index: Integer): TStatusPanelPro;
    procedure SetItem(Index: Integer; Value: TStatusPanelPro);
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(StatusBar: TStatusBarPro);
    function Add: TStatusPanelPro;
    property Items[Index: Integer]: TStatusPanelPro read GetItem write SetItem; default;
  end;

  TDrawPanelProEvent = procedure(StatusBar: TStatusBarPro; Panel: TStatusPanelPro;
    const Rect: TRect) of object;

  TStatusBarPro = class(TWinControl)
  private
    FPanels: TStatusPanelsPro;
    FCanvas: TCanvas;
    FSimpleText: string;
    FSimplePanel: Boolean;
    FSizeGrip: Boolean;
    FUseSystemFont: Boolean;
    {$IFDEF DELPHI4_UP}
    FAutoHint: Boolean;
    FAutoHintPanelIndex: Integer;	//// sancho 2002.09.03
    {$ENDIF}
    FOnDrawPanel: TDrawPanelProEvent;
    FOnHint: TNotifyEvent;
    FImages: {$IFNDEF DELPHI3} TCustomImageList {$ELSE} TImageList {$ENDIF};
    FImageChangeLink: TChangeLink;
    FMousePanel: TStatusPanelPro;
    {$IFDEF DELPHI4_UP}
    procedure DoRightToLeftAlignment(var Str: string; AAlignment: TAlignment;
      ARTLAlignment: Boolean);
    {$ENDIF}
    function IsFontStored: Boolean;
    procedure ImageListChange(Sender: TObject);
    procedure SetImages(Value: {$IFNDEF DELPHI3} TCustomImageList {$ELSE} TImageList {$ENDIF});
    procedure SetPanels(Value: TStatusPanelsPro);
    procedure SetSimplePanel(Value: Boolean);
    procedure UpdateSimpleText;
    procedure SetSimpleText(const Value: string);
    procedure SetSizeGrip(Value: Boolean);
    {$IFDEF DELPHI4_UP}
    procedure SetAutoHintPanelIndex(Value: Integer);
    {$ENDIF}
    procedure SyncToSystemFont;
    procedure UpdatePanelsWidth;
    procedure UpdatePanel(Index: Integer; Repaint: Boolean);
    procedure UpdatePanels(UpdateRects, UpdateText: Boolean);
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    {$IFDEF DELPHI4_UP}
    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    {$ENDIF}
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure CMWinIniChange(var Message: TMessage); message CM_WININICHANGE;
    procedure CMSysFontChanged(var Message: TMessage); message CM_SYSFONTCHANGED;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMGetTextLength(var Message: TWMGetTextLength); message WM_GETTEXTLENGTH;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure SetUseSystemFont(const Value: Boolean);
    function FindPanelAtPos(X, Y: Integer): TStatusPanelPro;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ChangeScale(M, D: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    function DoHint: Boolean; virtual;
    procedure DrawPanel(Panel: TStatusPanelPro; const Rect: TRect); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X: Integer; Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure Click; override;
    procedure DblClick; override;
    function GetPopupMenu: TPopupMenu; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {$IFDEF DELPHI4_UP}
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    procedure FlipChildren(AllLevels: Boolean); override;
    {$ENDIF}
    property Canvas: TCanvas read FCanvas;
  published
    {$IFDEF DELPHI4_UP}
    property Action;
    property AutoHint: Boolean read FAutoHint write FAutoHint default False;
    {$ENDIF}
    property Align default alBottom;
    {$IFDEF DELPHI4_UP}
    property Anchors;
    property BiDiMode;
    property BorderWidth;
    {$ENDIF}
    property Color default clBtnFace;
    property DragCursor;
    {$IFDEF DELPHI4_UP}
    property DragKind;
    {$ENDIF}
    property DragMode;
    property Enabled;
    property Font stored IsFontStored;
    property Images: {$IFNDEF DELPHI3} TCustomImageList {$ELSE} TImageList {$ENDIF}
      read FImages write SetImages;
    property Panels: TStatusPanelsPro read FPanels write SetPanels;
    {$IFDEF DELPHI4_UP}
    property AutoHintPanelIndex: Integer read FAutoHintPanelIndex write SetAutoHintPanelIndex default 0;  //// sancho 2002.09.03
    property Constraints;
    property ParentBiDiMode;
    {$ENDIF}
    property ParentColor default False;
    property ParentFont default False;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property SimplePanel: Boolean read FSimplePanel write SetSimplePanel;
    property SimpleText: string read FSimpleText write SetSimpleText;
    property SizeGrip: Boolean read FSizeGrip write SetSizeGrip default True;
    property UseSystemFont: Boolean read FUseSystemFont write SetUseSystemFont default True;
    property Visible;
    property OnClick;
    {$IFDEF DELPHI5_UP}
    property OnContextPopup;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF DELPHI4_UP}
    property OnEndDock;
    {$ENDIF}
    property OnEndDrag;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDrawPanel: TDrawPanelProEvent read FOnDrawPanel write FOnDrawPanel;
    {$IFDEF DELPHI4_UP}
    property OnResize;
    property OnStartDock;
    {$ENDIF}
    property OnStartDrag;
  end;

implementation

uses
  CommCtrl {$IFDEF DELPHI4_UP}, StdActns {$ENDIF};

const
  {$IFDEF DELPHI3}
  SB_SETBKCOLOR  = $2001;  // lParam = bkColor
  {$ENDIF}
  MaxPanelCount  = 128;
  SizeGripWidth  = 16;
  InternalIndent = 1;

{ TStatusPanelPro }

constructor TStatusPanelPro.Create(Collection: TCollection);
begin
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FColor := clBtnFace;
  FWidth := 50;
  FMinWidth := 0;
  FMaxWidth := 10000;
  FBevel := pbLowered;
  FImageIndex := -1;
  {$IFDEF DELPHI4_UP}
  FParentBiDiMode := True;
  {$ENDIF}
  FParentColor := True;
  FParentFont := True;
  inherited Create(Collection);
  {$IFDEF DELPHI4_UP}
  ParentBiDiModeChanged;
  {$ENDIF}
  ParentColorChanged;
  ParentFontChanged;
end;

destructor TStatusPanelPro.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TStatusPanelPro.Assign(Source: TPersistent);
begin
  if Source is TStatusPanel then
  begin
    Text := TStatusPanel(Source).Text;
    Width := TStatusPanel(Source).Width;
    Alignment := TStatusPanel(Source).Alignment;
    Bevel := TStatusPanel(Source).Bevel;
    Style := TStatusPanel(Source).Style;
    {$IFDEF DELPHI4_UP}
    BidiMode := TStatusPanelPro(Source).BiDiMode;
    ParentBidiMode := TStatusPanelPro(Source).ParentBiDiMode;
    {$ENDIF}
  end
  else if Source is TStatusPanelPro then
  begin
    Text := TStatusPanelPro(Source).Text;
    AutoSize := TStatusPanelPro(Source).AutoSize;
    AutoWidth := TStatusPanelPro(Source).AutoWidth;
    MinWidth := TStatusPanelPro(Source).MinWidth;
    MaxWidth := TStatusPanelPro(Source).MaxWidth;
    Width := TStatusPanelPro(Source).Width;
    Color := TStatusPanelPro(Source).Color;                             {RAL}
    ParentColor := TStatusPanelPro(Source).ParentColor;
    Alignment := TStatusPanelPro(Source).Alignment;
    Bevel := TStatusPanelPro(Source).Bevel;
    {$IFDEF DELPHI4_UP}
    BidiMode := TStatusPanelPro(Source).BiDiMode;
    ParentBidiMode := TStatusPanelPro(Source).ParentBiDiMode;
    {$ENDIF}
    Font := TStatusPanelPro(Source).Font;
    ParentFont := TStatusPanelPro(Source).ParentFont;
    Style := TStatusPanelPro(Source).Style;
    Hint := TStatusPanelPro(Source).Hint;
    ImageIndex := TStatusPanelPro(Source).ImageIndex;
    PopupMenu := TStatusPanelPro(Source).PopupMenu;
    OnClick := TStatusPanelPro(Source).OnClick;
    OnDblClick := TStatusPanelPro(Source).OnDblClick;
  end
  else
    inherited Assign(Source);
end;

{$IFDEF DELPHI4_UP}
function TStatusPanelPro.UseRightToLeftReading: Boolean;
begin
  Result := SysLocale.MiddleEast and (BiDiMode <> bdLeftToRight);
end;
{$ENDIF}

{$IFDEF DELPHI4_UP}
function TStatusPanelPro.UseRightToLeftAlignment: Boolean;
begin
  Result := SysLocale.MiddleEast and (BiDiMode = bdRightToLeft);
end;
{$ENDIF}

{$IFDEF DELPHI4_UP}
procedure TStatusPanelPro.ParentBiDiModeChanged;
begin
  if FParentBiDiMode and (GetOwner <> nil) then
  begin
    BiDiMode := TStatusPanelsPro(GetOwner).FStatusBar.BiDiMode;
    FParentBiDiMode := True;
  end;
end;
{$ENDIF}

{$IFDEF DELPHI4_UP}
procedure TStatusPanelPro.SetBiDiMode(Value: TBiDiMode);
begin
  if Value <> FBiDiMode then
  begin
    FBiDiMode := Value;
    FParentBiDiMode := False;
    Changed(False);
  end;
end;
{$ENDIF}

{$IFDEF DELPHI4_UP}
function TStatusPanelPro.IsBiDiModeStored: Boolean;
begin
  Result := not FParentBiDiMode;
end;
{$ENDIF}

{$IFDEF DELPHI4_UP}
procedure TStatusPanelPro.SetParentBiDiMode(Value: Boolean);
begin
  if FParentBiDiMode <> Value then
  begin
    FParentBiDiMode := Value;
    if FParentBiDiMode then
      ParentBiDiModeChanged;
    Changed(False);
  end;
end;
{$ENDIF}

procedure TStatusPanelPro.ParentColorChanged;
begin
  if FParentColor and (GetOwner <> nil) then
  begin
    Color := TStatusPanelsPro(GetOwner).FStatusBar.Color;
    FParentColor := True;
  end;
end;

procedure TStatusPanelPro.SetColor(Value : TColor);                     {RAL}
begin                                                                   {RAL}
 if FColor <> Value then                                                {RAL}
  begin                                                                 {RAL}
   FColor := Value;                                                     {RAL}
   FParentColor := False;
   Changed(False);                                                      {RAL}
  end;                                                                  {RAL}
end;                                                                    {RAL}

function TStatusPanelPro.IsColorStored: Boolean;
begin
  Result := not FParentColor;
end;

procedure TStatusPanelPro.SetParentColor(Value: Boolean);
begin
  if FParentColor <> Value then
  begin
    FParentColor := Value;
    if FParentColor then
      ParentColorChanged;
    Changed(False);
  end;
end;

procedure TStatusPanelPro.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TStatusPanelPro.SetParentFont(Value: Boolean);
begin
  if FParentFont <> Value then
  begin
    FParentFont := Value;
    if FParentFont then
      ParentFontChanged;
    Changed(False);
  end;
end;

procedure TStatusPanelPro.FontChanged(Sender: TObject);
begin
  FParentFont := False;
  Changed(False);
end;

function TStatusPanelPro.IsFontStored: Boolean;
begin
  Result := not ParentFont;
end;

procedure TStatusPanelPro.ParentFontChanged;
begin
  if FParentFont and (GetOwner <> nil) then
  begin
    FFont.Assign(TStatusPanelsPro(GetOwner).FStatusBar.Font);
    FParentFont := True;
  end;
end;

procedure TStatusPanelPro.SetIndent(Value: Integer);
begin
  if FIndent <> Value then
  begin
    FIndent := Value;
    Changed(False);
  end;
end;

function TStatusPanelPro.GetDisplayName: string;
begin
  Result := Text;
  if Result = '' then Result := inherited GetDisplayName;
end;

procedure TStatusPanelPro.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TStatusPanelPro.SetBevel(Value: TStatusPanelBevel);
begin
  if FBevel <> Value then
  begin
    FBevel := Value;
    Changed(False);
  end;
end;

procedure TStatusPanelPro.SetStyle(Value: TStatusPanelStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Changed(False);
  end;
end;

procedure TStatusPanelPro.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(FAutoWidth);
  end;
end;

procedure TStatusPanelPro.SetWidth(Value: Integer);
begin
  if not (FAutoSize or FAutoWidth) then
  begin
    if Value < FMinWidth then
      Value := FMinWidth
    else if Value > FMaxWidth then
      Value := FMaxWidth;
    if FWidth <> Value then
    begin
      FWidth := Value;
      Changed(True);
    end;
  end;
end;

procedure TStatusPanelPro.SetMinWidth(Value: Integer);
begin
  if FMinWidth <> Value then
  begin
    FMinWidth := Value;
    if not FAutoSize and (FWidth < FMinWidth) then
    begin
      FWidth := MinWidth;
      Changed(True);
    end
    else if FAutoWidth then
      Changed(True);
  end;
end;

procedure TStatusPanelPro.SetMaxWidth(Value: Integer);
begin
  if FMaxWidth <> Value then
  begin
    FMaxWidth := Value;
    if not FAutoSize and (FWidth > FMaxWidth) then
    begin
      FWidth := MaxWidth;
      Changed(True);
    end
    else if FAutoWidth then
      Changed(True);
  end;
end;

procedure TStatusPanelPro.SetAutoWidth(Value: Boolean);
begin
  if FAutoWidth <> Value then
  begin
    FAutoWidth := Value;
    if FAutoWidth then
    begin
      FAutoSize := False;
      Changed(True);
    end;
  end;
end;

procedure TStatusPanelPro.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if FAutoSize then
    begin
      FAutoWidth := False;
      Changed(True);
    end
    else if FWidth < FMinWidth then
    begin
      FWidth := FMinWidth;
      Changed(True);
    end
    else if FWidth > FMaxWidth then
    begin
      FWidth := FMaxWidth;
      Changed(True);
    end
  end;
end;

procedure TStatusPanelPro.SetHint(Value: String);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    Changed(False);
  end;
end;

procedure TStatusPanelPro.SetImageIndex(Value: Integer);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed(False);
  end;
end;

procedure TStatusPanelPro.SetPopupMenu(Value: TPopupMenu);
begin
  if FPopupMenu <> Value then
  begin
    FPopupMenu := Value;
    if (GetOwner <> nil) and (FPopupMenu <> nil) then
      FPopupMenu.FreeNotification(TStatusPanelsPro(GetOwner).FStatusBar);
  end;
end;

procedure TStatusPanelPro.SetControl(Value: TControl);
var
  I: Integer;
begin
  if Control <> Value then
  begin
    FControl := Value;
    if (GetOwner <> nil) and (FControl <> nil) then
    begin
      with TStatusPanelsPro(GetOwner) do
      begin
        for I := Count - 1 downto 0 do
          if (Items[I].Control = Value) and (Index <> I) then
            Items[I].Control := nil;
        FControl.FreeNotification(FStatusBar);
        FControl.Parent := FStatusBar;
      end;
      UpdateControlBounds;
    end;
  end;
end;

procedure TStatusPanelPro.UpdateControlBounds;
var
  SB: TStatusBarPro;
  Borders: array[0..2] of Integer;
  Rect: TRect;
begin
  if Assigned(FControl) and (GetOwner <> nil) then
  begin
    SetRect(Rect, 0, 0, 0, 0);
    SB := TStatusPanelsPro(GetOwner).FStatusBar;
    if not SB.SimplePanel then
    begin
      SB.Perform(SB_GETRECT, Index, Integer(@Rect));
      FillChar(Borders[0], SizeOf(Borders), 0);
      SB.Perform(SB_GETBORDERS, 0, Integer(@Borders[0]));
      InflateRect(Rect, -Borders[2] div 2, -Borders[1] div 2);
    end;
    if FControl is TWinControl then // Workaround Delphi bug!!!
      SetWindowPos(TWinControl(FControl).Handle, 0, Rect.Left, Rect.Top,
        Rect.Right - Rect.Left, Rect.Bottom - Rect.Top, SWP_NOZORDER)
    else
      FControl.BoundsRect := Rect;
  end;
end;

{ TStatusPanelsPro }

constructor TStatusPanelsPro.Create(StatusBar: TStatusBarPro);
begin
  inherited Create(TStatusPanelPro);
  FStatusBar := StatusBar;
end;

function TStatusPanelsPro.Add: TStatusPanelPro;
begin
  Result := TStatusPanelPro(inherited Add);
end;

function TStatusPanelsPro.GetItem(Index: Integer): TStatusPanelPro;
begin
  Result := TStatusPanelPro(inherited GetItem(Index));
end;

function TStatusPanelsPro.GetOwner: TPersistent;
begin
  Result := FStatusBar;
end;

procedure TStatusPanelsPro.SetItem(Index: Integer; Value: TStatusPanelPro);
begin
  inherited SetItem(Index, Value);
end;

procedure TStatusPanelsPro.Update(Item: TCollectionItem);
begin
  if Item <> nil then
    FStatusBar.UpdatePanel(Item.Index, False)
  else
    FStatusBar.UpdatePanels(True, False);
end;

{ TStatusBarPro }

constructor TStatusBarPro.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPanels := TStatusPanelsPro.Create(Self);
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque, csAcceptsControls];
  Color := clBtnFace;
  Height := 19;
  Align := alBottom;
  FSizeGrip := True;
  ParentFont := False;
  FUseSystemFont := True;
  SyncToSystemFont;
end;

destructor TStatusBarPro.Destroy;
begin
  Images := nil;
  FImageChangeLink.Free;
  FCanvas.Free;
  FPanels.Free;
  FPanels := nil;
  inherited Destroy;
end;

procedure TStatusBarPro.CreateParams(var Params: TCreateParams);
const
  GripStyles: array[Boolean] of DWORD = (CCS_TOP, SBARS_SIZEGRIP);
begin
  InitCommonControl(ICC_BAR_CLASSES);
  inherited CreateParams(Params);
  CreateSubClass(Params, STATUSCLASSNAME);
  with Params do
  begin
    Style := Style or GripStyles[FSizeGrip and
      (Parent is {$IFNDEF DELPHI3} TCustomForm {$ELSE} TForm {$ENDIF}) and
      ({$IFNDEF DELPHI3} TCustomForm {$ELSE} TForm {$ENDIF} (Parent).BorderStyle
       in [bsSizeable, bsSizeToolWin])];
    WindowClass.style := WindowClass.style and not CS_HREDRAW;
  end;
end;

procedure TStatusBarPro.CreateWnd;
begin
  inherited CreateWnd;
  SendMessage(Handle, SB_SETBKCOLOR, 0, ColorToRGB(Color));
  UpdatePanels(True, False);
  if FSimpleText <> '' then
    SendMessage(Handle, SB_SETTEXT, 255, Integer(PChar(FSimpleText)));
  if FSimplePanel then
    SendMessage(Handle, SB_SIMPLE, 1, 0);
end;

function TStatusBarPro.DoHint: Boolean;
begin
  if Assigned(FOnHint) then
  begin
    FOnHint(Self);
    Result := True;
  end
  else Result := False;
end;

procedure TStatusBarPro.DrawPanel(Panel: TStatusPanelPro; const Rect: TRect);
var
  X, Y: Integer;
  ImageWidth: Integer;
  Alignment: TAlignment;
  RightSideImage: Boolean;
begin
  if (Panel.Style = psOwnerDraw) and Assigned(FOnDrawPanel) then
    FOnDrawPanel(Self, Panel, Rect)
  else
  begin
    // Changes alignment according to BiDiMode
    Alignment := Panel.Alignment;
    {$IFDEF DELPHI4_UP}
    if Panel.UseRightToLeftAlignment then
      ChangeBiDiModeAlignment(Alignment);
    {$ENDIF}
    RightSideImage := (Alignment = taRightJustify) {$IFDEF DELPHI4_UP} or
      ((Alignment = taCenter) and Panel.UseRightToLeftAlignment) {$ENDIF};
    // Determines image's width
    if (FImages <> nil) and (Panel.ImageIndex >= 0) and
       (Panel.ImageIndex < FImages.Count) then
      ImageWidth := FImages.Width
    else
      ImageWidth := 0;
    // Determines X position
    case Alignment of
      taLeftJustify: X := Rect.Left + InternalIndent + Panel.Indent;
      taRightJustify: X := Rect.Right - ImageWidth - InternalIndent - Panel.Indent;
    else
      {$IFDEF DELPHI4_UP}
      if Panel.UseRightToLeftAlignment then
        X := Rect.Left + ((Rect.Right - Rect.Left) +
            (ImageWidth + FCanvas.TextWidth(Panel.Text))) div 2 - ImageWidth
      else
      {$ENDIF}
        X := Rect.Left + ((Rect.Right - Rect.Left) -
            (ImageWidth + FCanvas.TextWidth(Panel.Text))) div 2;
    end;
    FCanvas.Brush.Color := Panel.Color; {RAL: Put here so colors can be seen in design mode}
    FCanvas.FillRect(Rect);
    // Draws image
    if ImageWidth > 0 then
    begin
      Y := Rect.Top + ((Rect.Bottom - Rect.Top) - FImages.Height) div 2;
      FImages.Draw(FCanvas, X, Y, Panel.ImageIndex);
      if RightSideImage then
        Dec(X, 2 * InternalIndent)
      else
        Inc(X, FImages.Width + 2 * InternalIndent);
    end;
    // Draws text
    if Panel.Text <> '' then
    begin
      FCanvas.Font.Assign(Panel.Font);
      if RightSideImage then
        Dec(X, FCanvas.TextWidth(Panel.Text));
      Y := Rect.Top + ((Rect.Bottom - Rect.Top) - FCanvas.TextHeight('H')) div 2;
      {$IFDEF DELPHI4_UP}
      if Panel.UseRightToLeftReading then
        FCanvas.TextFlags := FCanvas.TextFlags or ETO_RTLREADING
      else
        FCanvas.TextFlags := FCanvas.TextFlags and not ETO_RTLREADING;
      {$ENDIF}
      FCanvas.TextOut(X, Y, Panel.Text);
    end;
  end;
end;

procedure TStatusBarPro.SetImages(Value:
  {$IFNDEF DELPHI3} TCustomImageList {$ELSE} TImageList {$ENDIF});
begin
  if FImages <> nil then
    FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end;
  Invalidate;
end;

procedure TStatusBarPro.ImageListChange(Sender: TObject);
begin
  Invalidate;
end;

procedure TStatusBarPro.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FImages then
      Images := nil
    else if Assigned(Panels) then
    begin
      if AComponent is TPopupMenu then
      begin
        for I := 0 to Panels.Count-1 do
          if Panels[I].PopupMenu = AComponent then
            Panels[I].PopupMenu := nil;
      end
      else if AComponent is TControl then
      begin
        for I := 0 to Panels.Count-1 do
          if Panels[I].Control = AComponent then
            Panels[I].Control := nil;
      end;
    end;
  end;
end;

procedure TStatusBarPro.SetPanels(Value: TStatusPanelsPro);
begin
  FPanels.Assign(Value);
end;

procedure TStatusBarPro.SetSimplePanel(Value: Boolean);
var
  I: Integer;
begin
  if FSimplePanel <> Value then
  begin
    FSimplePanel := Value;
    if HandleAllocated then
    begin
      SendMessage(Handle, SB_SIMPLE, Ord(FSimplePanel), 0);
      for I := 0 to Panels.Count - 1 do
        Panels[I].UpdateControlBounds;
    end;
  end;
end;

{$IFDEF DELPHI4_UP}
procedure TStatusBarPro.DoRightToLeftAlignment(var Str: string;
  AAlignment: TAlignment; ARTLAlignment: Boolean);
begin
  if ARTLAlignment then ChangeBiDiModeAlignment(AAlignment);

  case AAlignment of
    taCenter: Insert(#9, Str, 1);
    taRightJustify: Insert(#9#9, Str, 1);
  end;
end;
{$ENDIF}

procedure TStatusBarPro.UpdateSimpleText;
const
  RTLReading: array[Boolean] of Longint = (0, SBT_RTLREADING);
begin
  {$IFDEF DELPHI4_UP}
  DoRightToLeftAlignment(FSimpleText, taLeftJustify, UseRightToLeftAlignment);
  {$ENDIF}
  if HandleAllocated then
    SendMessage(Handle, SB_SETTEXT, 255
      {$IFDEF DELPHI4_UP} or RTLREADING[UseRightToLeftReading] {$ENDIF},
      Integer(PChar(FSimpleText)));
end;

procedure TStatusBarPro.SetSimpleText(const Value: string);
begin
  if FSimpleText <> Value then
  begin
    FSimpleText := Value;
    UpdateSimpleText;
  end;
end;

{$IFDEF DELPHI4_UP}
procedure TStatusBarPro.CMBiDiModeChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  for I := 0 to Panels.Count - 1 do
    if Panels[I].ParentBiDiMode then
      Panels[I].ParentBiDiModeChanged;
  if HandleAllocated then
    if SimplePanel then
      UpdateSimpleText
    else
      UpdatePanels(True, True);
end;
{$ENDIF}

{$IFDEF DELPHI4_UP}
procedure TStatusBarPro.FlipChildren(AllLevels: Boolean);
var
  Loop, FirstWidth, LastWidth: Integer;
  APanels: TStatusPanelsPro;
begin
  if HandleAllocated and
     (not SimplePanel) and (Panels.Count > 0) then
  begin
    { Get the true width of the last panel }
    LastWidth := ClientWidth;
    if SizeGrip then
      Dec(LastWidth, SizeGripWidth);
    FirstWidth := Panels[0].Width;
    for Loop := 0 to Panels.Count - 2 do Dec(LastWidth, Panels[Loop].Width);
    { Flip 'em }
    APanels := TStatusPanelsPro.Create(Self);
    try
      for Loop := 0 to Panels.Count - 1 do with APanels.Add do
        Assign(Self.Panels[Loop]);
      for Loop := 0 to Panels.Count - 1 do
        Panels[Loop].Assign(APanels[Panels.Count - Loop - 1]);
    finally
      APanels.Free;
    end;
    { Set the width of the last panel }
    if Panels.Count > 1 then
    begin
      Panels[Panels.Count-1].Width := FirstWidth;
      Panels[0].Width := LastWidth;
    end;
    UpdatePanels(True, True);
  end;
end;
{$ENDIF}

procedure TStatusBarPro.SetSizeGrip(Value: Boolean);
begin
  if FSizeGrip <> Value then
  begin
    FSizeGrip := Value;
    RecreateWnd;
  end;
end;

{$IFDEF DELPHI4_UP}
procedure TStatusBarPro.SetAutoHintPanelIndex(Value: Integer);
begin
  if (FAutoHintPanelIndex <> Value) and (Value >= 0) and (Value < Panels.Count) then
    FAutoHintPanelIndex := Value;
end;
{$ENDIF}

procedure TStatusBarPro.SyncToSystemFont;
{$IFNDEF DELPHI5_UP}
var
  NonClientMetrics: TNonClientMetrics;
{$ENDIF}
begin
  {$IFNDEF DELPHI5_UP}
  if FUseSystemFont then
  begin
    NonClientMetrics.cbSize := sizeof(NonClientMetrics);
    if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
      Font.Handle := CreateFontIndirect(NonClientMetrics.lfStatusFont)
  end;
  {$ELSE}
  if FUseSystemFont then
    Font := Screen.HintFont;
  {$ENDIF}
end;

procedure TStatusBarPro.UpdatePanel(Index: Integer; Repaint: Boolean);
var
  Flags: Integer;
  S: string;
  PanelRect: TRect;
begin
  if HandleAllocated then
    with Panels[Index] do
    begin
      if not Repaint then
      begin
        FUpdateNeeded := True;
        SendMessage(Handle, SB_GETRECT, Index, Integer(@PanelRect));
        InvalidateRect(Handle, @PanelRect, True);
      end
      else if FUpdateNeeded then
      begin
        FUpdateNeeded := False;
        Flags := 0;
        case Bevel of
          pbNone: Flags := SBT_NOBORDERS;
          pbRaised: Flags := SBT_POPOUT;
        end;
        {$IFDEF DELPHI4_UP}
        if UseRightToLeftReading then Flags := Flags or SBT_RTLREADING;
        {$ENDIF}
        {if Style = psOwnerDraw then} Flags := Flags or SBT_OWNERDRAW;
        S := Text;
        {$IFDEF DELPHI4_UP}
        if UseRightToLeftAlignment then
          DoRightToLeftAlignment(S, Alignment, UseRightToLeftAlignment)
        else
        {$ENDIF}
          case Alignment of
            taCenter: Insert(#9, S, 1);
            taRightJustify: Insert(#9#9, S, 1);
          end;
        SendMessage(Handle, SB_SETTEXT, Index or Flags, Integer(PChar(S)));
        UpdateControlBounds;
      end;
    end;
end;

procedure TStatusBarPro.UpdatePanels(UpdateRects, UpdateText: Boolean);
var
  I, Count, PanelPos: Integer;
  PanelEdges: array[0..MaxPanelCount - 1] of Integer;
begin
  Count := Panels.Count;
  if HandleAllocated then
  begin
    if UpdateRects then
    begin
      if Count > MaxPanelCount then
        Count := MaxPanelCount;
      if Count = 0 then
      begin
        PanelEdges[0] := -1;
        SendMessage(Handle, SB_SETPARTS, 1, Integer(@PanelEdges));
        SendMessage(Handle, SB_SETTEXT, 0, 0);
      end
      else
      begin
        UpdatePanelsWidth;
        PanelPos := 0;
        for I := 0 to Count - 2 do
        begin
          Inc(PanelPos, Panels[I].Width);
          PanelEdges[I] := PanelPos;
        end;
        PanelEdges[Count - 1] := -1;
        SendMessage(Handle, SB_SETPARTS, Count, Integer(@PanelEdges));
      end;
    end;
    for I := 0 to Count - 1 do
      UpdatePanel(I, UpdateText);
  end;
  {$IFDEF DELPHI4_UP}
  if FAutoHintPanelIndex >= Count then
    FAutoHintPanelIndex := 0;
  {$ENDIF}
end;

procedure TStatusBarPro.UpdatePanelsWidth;
var
  I, Count: Integer;
  FreeWidth: Integer;
  AutoSizeCount, AutoSizeWidth: Integer;
begin
  Count := Panels.Count;
  if Count > MaxPanelCount then
    Count := MaxPanelCount;
  AutoSizeCount := 0;
  FreeWidth := ClientWidth;
  if SizeGrip then
    Dec(FreeWidth, SizeGripWidth);
  for I := 0 to Count - 1 do
    with Panels[I] do
      if AutoSize then
        Inc(AutoSizeCount)
      else
      begin
        if AutoWidth then
        begin
          Canvas.Font.Assign(Font);
          FWidth := Canvas.TextWidth(Text) + 2 * (Indent + InternalIndent);
          if (FImages <> nil) and (ImageIndex >= 0) and (ImageIndex < FImages.Count) then
            Inc(FWidth, FImages.Width + 2 * InternalIndent);
          if FWidth < MinWidth then
            FWidth := MinWidth
          else if FWidth > MaxWidth then
            FWidth := MaxWidth;
        end;
        Dec(FreeWidth, Width);
      end;
  if AutoSizeCount > 0 then
  begin
    AutoSizeWidth := FreeWidth div AutoSizeCount;
    if AutoSizeWidth < 0 then
      AutoSizeWidth := 0;
    for I := 0 to Count - 1 do
      with Panels[I] do
        if AutoSize then
           FWidth := AutoSizeWidth;
  end;
end;

procedure TStatusBarPro.CMWinIniChange(var Message: TMessage);
begin
  inherited;
  if (Message.WParam = 0) or (Message.WParam = SPI_SETNONCLIENTMETRICS) then
    SyncToSystemFont;
end;

procedure TStatusBarPro.CNDrawItem(var Message: TWMDrawItem);
var
  SaveIndex: Integer;
begin
  with Message.DrawItemStruct^ do
  begin
    SaveIndex := SaveDC(hDC);
    FCanvas.Lock;
    try
      FCanvas.Handle := hDC;
      FCanvas.Font := Font;
      FCanvas.Brush.Color := Color;
      FCanvas.Brush.Style := bsSolid;
      if SizeGrip and (itemID + 1 = DWORD(Panels.Count)) then
        Dec(rcItem.Right, SizeGripWidth);
      DrawPanel(Panels[itemID], rcItem);
    finally
      FCanvas.Handle := 0;
      FCanvas.Unlock;
      RestoreDC(hDC, SaveIndex);
    end;
  end;
  Message.Result := 1;
end;

procedure TStatusBarPro.WMGetTextLength(var Message: TWMGetTextLength);
begin
  Message.Result := Length(FSimpleText);
end;

procedure TStatusBarPro.WMPaint(var Message: TWMPaint);
begin
  UpdatePanels(False, True);
  inherited;
end;

procedure TStatusBarPro.WMSize(var Message: TWMSize);
begin
  { Eat WM_SIZE message to prevent alignment by the control }
  {$IFDEF DELPHI4_UP}
  if not (csLoading in ComponentState) then Resize;
  {$ENDIF}
  UpdatePanels(True, False);
  Repaint;
end;

procedure TStatusBarPro.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  inherited;
  if Message.CalcValidRects then
    Message.Result := Message.Result or WVR_REDRAW;
end;

procedure TStatusBarPro.CMHintShow(var Message: TCMHintShow);
begin
  inherited;
  if Assigned(FMousePanel) and (FMousePanel.Hint <> '') then
    Message.HintInfo^.HintStr := FMousePanel.Hint
  else
    Message.HintInfo^.HintStr := Hint;
end;

function TStatusBarPro.FindPanelAtPos(X, Y: Integer): TStatusPanelPro;
var
  Index: Integer;
  PanelRect: TRect;
  Pt: TPoint;
begin
  Result := nil;
  Pt.X := X;
  Pt.Y := Y;
  for Index := 0 to FPanels.Count-1 do
  begin
    if (SendMessage(Handle, SB_GETRECT, Index, Integer(@PanelRect)) <> 0) and
       PtInRect(PanelRect, Pt) then
    begin
      Result := FPanels[Index];
      Break;
    end;
  end;
end;

procedure TStatusBarPro.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X: Integer; Y: Integer);
begin
  FMousePanel := FindPanelAtPos(X, Y);
  inherited;
end;

procedure TStatusBarPro.MouseMove(Shift: TShiftState; X: Integer; Y: Integer);
var
  OldPanel: TStatusPanelPro;
begin
  if ShowHint then
  begin
    OldPanel := FMousePanel;
    FMousePanel := FindPanelAtPos(X, Y);
    if OldPanel <> FMousePanel then Application.CancelHint;
  end;
  inherited;
end;

procedure TStatusBarPro.Click;
begin
  if Assigned(FMousePanel) and Assigned(FMousePanel.OnClick) then
    FMousePanel.OnClick(FMousePanel)
  else if Assigned(OnClick) then
    OnClick(Self);
end;

procedure TStatusBarPro.DblClick;
begin
  if Assigned(FMousePanel) and Assigned(FMousePanel.OnDblClick) then
    FMousePanel.OnDblClick(FMousePanel)
  else if Assigned(OnDblClick) then
    OnDblClick(Self);
end;

function TStatusBarPro.GetPopupMenu: TPopupMenu;
begin
  if Assigned(FMousePanel) and Assigned(FMousePanel.PopupMenu) then
  begin
    Result := FMousePanel.PopupMenu;
    {$IFDEF DELPHI4_UP}
    if Result <> nil then Result.BiDiMode := FMousePanel.BiDiMode;
    {$ENDIF}
  end
  else
    Result := PopupMenu;
end;

function TStatusBarPro.IsFontStored: Boolean;
begin
  Result := not FUseSystemFont and not ParentFont and not DesktopFont;
end;

procedure TStatusBarPro.SetUseSystemFont(const Value: Boolean);
begin
  if FUseSystemFont <> Value then
  begin
    FUseSystemFont := Value;
    if Value then
    begin
      if ParentFont then ParentFont := False;
      SyncToSystemFont;
    end;
  end;
end;

procedure TStatusBarPro.CMParentFontChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  if FUseSystemFont and ParentFont then
    FUseSystemFont := False;
  for I := 0 to Panels.Count - 1 do
    if Panels[I].ParentFont then
      Panels[I].ParentFontChanged;
end;

procedure TStatusBarPro.CMColorChanged(var Message: TMessage);
var
  I: Integer;
begin
  inherited;
  if HandleAllocated then
    SendMessage(Handle, SB_SETBKCOLOR, 0, ColorToRGB(Color));
  for I := 0 to Panels.Count - 1 do
    if Panels[I].ParentColor then
      Panels[I].ParentColorChanged;
end;

{$IFDEF DELPHI4_UP}
function TStatusBarPro.ExecuteAction(Action: TBasicAction): Boolean;
var
  SingleLineHint: String;
begin
  if AutoHint and (Action is THintAction) and not DoHint then
  begin
    SingleLineHint := StringReplace(THintAction(Action).Hint, #13#10, ' ', [rfReplaceAll]);	//// sancho 2002.09.03
    if SimplePanel or (Panels.Count = 0) then
      SimpleText := SingleLineHint
    else
      Panels[FAutoHintPanelIndex].Text := SingleLineHint;
    Result := True;
  end
  else
    Result := inherited ExecuteAction(Action);
end;
{$ENDIF}

procedure TStatusBarPro.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;

procedure TStatusBarPro.CMSysFontChanged(var Message: TMessage);
begin
  inherited;
  SyncToSystemFont;
end;

procedure TStatusBarPro.ChangeScale(M, D: Integer);
begin
  if FUseSystemFont then  // status bar size based on system font size
    ScalingFlags := [sfTop];
  inherited;
end;

end.
