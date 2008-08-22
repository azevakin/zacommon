{
    MSNPopUp - using MSN-style popup windows in your Delphi programs
    Copyright (C) 2001  JWB Software

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Web:   http://people.zeelandnet.nl/famboek/tmsnpopup/
    Email: jwbsoftware@zeelandnet.nl
}

unit MSNPopUp;

interface

uses
  Windows, Classes, Graphics, StdCtrls, ExtCtrls, Controls, Forms,
  ShellApi, Dialogs, SysUtils, Messages;

type TURLEvent = procedure (Sender: TObject; URL: String) of object;

type
  TMouseLabel = class(TLabel)
  private
    { Private declarations }
    fMouseEnter : TNotifyEvent;
    fMouseLeave : TNotifyEvent;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property OnMouseEnter : TNotifyEvent read fMouseEnter write fMouseEnter;
    property OnMouseLeave : TNotifyEvent read fMouseLeave write fMouseLeave;
  end;

type
  TOrientation = (mbHorizontal, mbVertical);
  TScrollSpeed = 1..50;

  TMSNPopUp = class(TComponent)
  private
    { Private declarations }
    FURL: String;
    FText: String;
    FTitle: String;
    FIcon: TIcon;
    FWidth: Integer;
    FHeight: Integer;
    FTimeOut: Integer;
    FScrollSpeed: TScrollSpeed;
    FAllowScroll: Boolean;
    FAllowHyperlink: Boolean;
    FColor1: TColor;
    FColor2: TColor;
    FGradientOrientation: TOrientation;
    FFont: TFont;
    FHoverFont: TFont;
    FTitleFont: TFont;
    FCursor: TCursor;
    FAutoOpenURL: Boolean;
    FSystemFont: Boolean;

    //Jelmer
    FPopupMarge, FPopupStart: Integer;
    FCascadePopups: Boolean;
    PopupCount, NextPopupPos: Integer;
    LastBorder: Integer;
    FDefaultMonitor: TDefaultMonitor;
    FBackground: TBitmap;

    FOnClick: TNotifyEvent;
    FOnURLClick: TURLEvent;

    procedure SetIcon(Value: TIcon);
    function GetEdge: Integer;
    function GetCaptionFont: TFont;

    // Jiang Hong
    procedure SetFont(Value: TFont);
    procedure SetHoverFont(Value: TFont);
    procedure SetTitleFont(Value: TFont);

    //Jelmer
    procedure SetBackground(Value: TBitmap);
  protected
    { Protected declarations }

//    procedure Click; dynamic;
//    procedure URLClick; dynamic;
  public
    { Public declarations }
    function ShowPopUp: Boolean;
    procedure ClosePopUps;
  published
    { Published declarations }
    property Text: String read FText write FText;
    property URL: String read FURL write FURL;
    property PopUpIcon: TIcon read FIcon write SetIcon stored True;
    property TimeOut: Integer read FTimeOut write FTimeOut default 10;
    property Width: Integer read FWidth write FWidth default 175;
    property Height: Integer read FHeight write FHeight default 175;
    property AllowScroll: Boolean read FAllowScroll write FAllowScroll default True;
    property AllowHyperlink: Boolean read FAllowHyperlink write FAllowHyperlink default True;
    property GradientColor1: TColor read FColor1 write FColor1;
    property GradientColor2: TColor read FColor2 write FColor2;
    property GradientOrientation: TOrientation read FGradientOrientation write FGradientOrientation default mbVertical;
    property ScrollSpeed: TScrollSpeed read FScrollSpeed write FScrollSpeed default 5;
    property Font: TFont read FFont write SetFont;
    property HoverFont: TFont read FHoverFont write SetHoverFont; //Jiang Hong
    property Title: String read FTitle write FTitle;			  //Jiang Hong
    property TitleFont: TFont read FTitleFont write SetTitleFont; //Jiang Hong
    //Jelmer
    property TextCursor: TCursor read FCursor write FCursor;
    property PopupMarge: Integer read FPopupMarge write FPopupMarge;
    property PopupStart: Integer read FPopupStart write FPopupStart;
    property CascadePopups: Boolean read FCascadePopups write FCascadePopups;
    property AutoOpenURL: Boolean read FAutoOpenURL write FAutoOpenURL default True;
    property SystemFont: Boolean read FSystemFont write FSystemFont default False;
    property DefaultMonitor: TDefaultMonitor read FDefaultMonitor write FDefaultMonitor;
    property BackgroundImage: TBitmap read FBackground write SetBackground;

    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnURLClick: TURLEvent read FOnURLClick write FOnURLClick;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

type
  TfrmMSNPopUp = class(TCustomForm)
    pnlBorder: TPanel;
    imgIcon: TImage;
    lblText: TMouseLabel;
    imgGradient: TImage;
    // add by Ahmed Hamed 21-3-2002
    imgMsn: TImage;
    //
    tmrExit: TTimer;
    tmrScroll: TTimer;
    // add by Ahmed Hamed 20-3-2002
    tmrScrollDown:TTimer;
    //
    lblTitle: TMouseLabel;

    procedure lblTextMouseEnter(Sender: TObject);
    procedure lblTextMouseLeave(Sender: TObject);
    procedure lblTextClick(Sender: TObject);
    procedure tmrExitTimer(Sender: TObject);
    // add by Ahmed Hamed 20-3-2002
    procedure tmrscrollDownTimer(Sender:TObject);
    //
    procedure lblTextMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lblTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tmrScrollTimer(Sender: TObject);
    procedure imgIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgGradientMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoClose(var Action: TCloseAction); override;
  private
    //Jelmer
    PopupPos: Integer;
    ParentMSNPopup: TMSNPopup;
    CanClose: Boolean;

    function CalcColorIndex(StartColor, EndColor: TColor; Steps, ColorIndex: Integer): TColor;
    procedure PositionText;
  public
    { Public declarations }
    URL, Text, Title: String;
    TimeOut: Integer;
    Icon: TIcon;
    sWidth: Integer;
    sHeight: Integer;
    bScroll, bHyperlink: Boolean;
    Color1, Color2: TColor;
    Orientation: TOrientation;
    ScrollSpeed: TScrollSpeed;
    Font, HoverFont, TitleFont: TFont;
    StoredBorder: Integer;
    Cursor: TCursor;

    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    procedure PopUp;
  end;

procedure Register;

implementation

{$R *.res}

procedure Register;
begin
  RegisterComponents('Custom', [TMSNPopUp]);
end;

// mouselabel-stuff

procedure TMouseLabel.CMMouseEnter(var Message: TMessage);
 begin
    if assigned( fMouseEnter ) then
     fMouseEnter( self );
 end;

procedure TMouseLabel.CMMouseLeave(var Message: TMessage);
 begin
    if assigned( fMouseLeave ) then
     fMouseLeave( self );
 end;

// component stuff

function TMSNPopUp.ShowPopUp: Boolean;
var
  r: TRect;
  MSNPopUp: TfrmMSNPopUp;
begin
  //Jelmer
  if GetEdge <> LastBorder then begin
    LastBorder := GetEdge;
    PopupCount := 0;
  end;
  Result := True;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
  if PopupCount > 0 then begin
    case LastBorder of
      ABE_BOTTOM: if (r.Bottom - (NextPopupPos + FHeight + PopupStart)) < 0 then begin
        Result := False;
        Exit;
      end;
      ABE_LEFT: if (NextPopupPos + FWidth + PopupStart) > r.Right then begin
        Result := False;
        Exit;
      end;
      ABE_RIGHT: if (r.Right - (NextPopupPos + FHeight + PopupStart)) < 0 then begin
        Result := False;
        Exit;
      end;
      ABE_TOP: if ((NextPopupPos + FHeight + PopupStart)) > r.Bottom then begin
        Result := False;
        Exit;
      end;
    end;
  end else NextPopupPos := 0;
  Inc(PopupCount);

  MSNPopUp := TfrmMSNPopUp.CreateNew( Self.Owner );
  MSNPopUp.Hide;

  //Jelmer
  MSNPopUp.ParentMSNPopup := Self;
  MSNPopUp.DefaultMonitor := FDefaultMonitor;

  MSNPopUp.sWidth := FWidth;
  MSNPopUp.sHeight := FHeight;

  MSNPopUp.Text := FText;
  MSNPopUp.URL := FURL;
  MSNPopUp.Title := FTitle;
  MSNPopUp.TimeOut := FTimeOut;

  MSNPopUp.Icon := FIcon;

  MSNPopUp.bScroll := FAllowScroll;
  MSNPopUp.bHyperlink := FAllowHyperlink;
  MSNPopUp.ScrollSpeed := FScrollSpeed;

  MSNPopUp.Font := FFont;
  MSNPopUp.HoverFont := FHoverFont;
  MSNPopUp.TitleFont := FTitleFont;
  MSNPopUp.Cursor := FCursor;

  MSNPopUp.Color1 := FColor1;
  MSNPopUp.Color2 := FColor2;
  MSNPopUp.Orientation := FGradientOrientation;

  MSNPopUp.PopUp;
end;

// JWB
procedure TMSNPopUp.ClosePopUps;
var 
  hTfrmMSNPopUp : Cardinal; 
  i : integer;
begin 
  for i:=0 to PopUpCount do begin 
    hTfrmMSNPopUp := FindWindow(PChar('TfrmMSNPopUP'),nil); 
    if hTfrmMSNPopUp <> 0 then 
    begin
      SendMessage(hTfrmMSNPopUp,WM_CLOSE,0,0);
      Application.ProcessMessages;
    end; 
  end; 
end;

//Jiang Hong
procedure TMSNPopup.SetFont(Value: TFont);
begin
  if not (FFont = Value) then
    FFont.Assign(Value);
end;

//Jiang Hong
procedure TMSNPopup.SetHoverFont(Value: TFont);
begin
  if not (FHoverFont = Value) then
    FHoverFont.Assign(Value);
end;

//Jiang Hong
procedure TMSNPopup.SetTitleFont(Value: TFont);
begin
  if not (FTitleFont = Value) then
    FTitleFont.Assign(Value);
end;

procedure TMSNPopUp.SetIcon(Value: TIcon);
begin
  if Value <> Self.FIcon then
  begin
    Self.FIcon.Assign(Value);
  end;
end;

// function to find out system's default font
function TMSNPopUp.GetCaptionFont: TFont;
var
  ncMetrics: TNonClientMetrics;
begin
  ncMetrics.cbSize := sizeof(TNonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, sizeof(TNonClientMetrics), @ncMetrics, 0);

  Result := TFont.Create;
  Result.Handle  := CreateFontIndirect(ncMetrics.lfMenuFont);
end;

constructor TMSNPopUp.Create(AOwner: TComponent);
begin
  inherited;

  FIcon := TIcon.Create;
  FFont := TFont.Create;
  FHoverFont := TFont.Create;
  FTitleFont := TFont.Create;

  //Jelmer
  FBackground := TBitmap.Create;

  if FSystemFont then
  begin
        FFont.Name := GetCaptionFont.Name;
        FHoverFont.Name := GetCaptionFont.Name;
        FTitleFont.Name := GetCaptionFont.Name;
  end;

  FWidth := 175;
  FHeight := 175;

  FTimeOut := 10;
  FScrollSpeed := 5;

  FText := 'text';
  FURL := 'http://www.url.com/';
  FTitle := 'title';

  FCursor := crDefault;

  FColor1 := RGB(0,102,204);
  FColor2 := RGB(255,255,255);
  FGradientOrientation := mbVertical;

  FHoverFont.Style := [fsUnderline];
  FHoverFont.Color := clBlue;

  FTitleFont.Style := [fsBold];

  FAllowScroll := True;
  FAllowHyperlink := True;
  FAutoOpenURL := True;

  //Jelmer
  PopupCount := 0;
  LastBorder := 0;
  FCascadePopups := True;
  FPopupMarge := 5;
  FPopupStart := 5;
  //---
end;

destructor TMSNPopUp.Destroy;
begin
  FIcon.Free;
  FFont.Free;
  FHoverFont.Free;
  FTitleFont.Free;

  //Jelmer
  FBackground.Free;

  inherited;
end;

// form's functions

procedure TfrmMSNPopUp.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and not WS_CAPTION or WS_POPUP;
  Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE;
  Params.WndParent := GetDesktopWindow;
end;

constructor TfrmMSNPopUp.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited;
  Self.BorderStyle := bsDialog;

  pnlBorder := TPanel.Create(Self);
  pnlBorder.Parent := Self;
  pnlBorder.Align := alClient;
  pnlBorder.BevelWidth := 2;
  pnlBorder.BevelOuter := bvLowered;
  imgGradient := TImage.Create(Self);
  imgGradient.Parent := pnlBorder;
  imgGradient.Align := alClient;
  imgGradient.Anchors := [akTop, akLeft, akRight, akBottom];
  imgGradient.OnMouseUp := Self.imgGradientMouseUp;

  imgIcon := TImage.Create(Self);
  imgIcon.Parent := pnlBorder;
  imgIcon.Left := 8;
  imgIcon.Top := 8;
  imgIcon.OnMouseUp := Self.imgIconMouseUp;

  lblText := TMouseLabel.Create(Self);
  lblText.ShowAccelChar := False;
  lblText.Layout := tlCenter;
  lblText.Alignment := taCenter;
  lblText.AutoSize := True;
  lblText.WordWrap := True;
  lblText.Parent := pnlBorder;
  lblText.Transparent := True;
  lblText.OnMouseEnter := Self.lblTextMouseEnter;
  lblText.OnMouseLeave := Self.lblTextMouseLeave;
  lblText.OnClick := Self.lblTextClick;
  lblText.OnMouseUp := Self.lblTextMouseUp;
  lblText.Left := 9;
  lblText.Top := 49;
  lblText.Width := 3;
  lblText.Height := 13;

  lblTitle := TMouseLabel.Create(Self);
  lblTitle.ShowAccelChar := False;
  lblTitle.Parent := pnlBorder;
  lblTitle.Transparent := True;
  lblTitle.Top := 8;
  lblTitle.Left := 48;
  lblTitle.OnMouseUp := Self.lblTitleMouseUp;

  tmrExit := TTimer.Create(Self);
  tmrExit.Enabled := False;
  tmrExit.OnTimer := tmrExitTimer;
  tmrExit.Interval := 10000;

  tmrScroll := TTimer.Create(Self);
  tmrScroll.Enabled := False;
  tmrScroll.OnTimer := tmrScrollTimer;
  tmrScroll.Interval := 25;
  // add by Ahmed Hamed 20-3-2002
  tmrScrollDown := TTimer.Create(Self);
  tmrScrollDown.Enabled := False;
  tmrScrollDown.OnTimer := tmrScrollDownTimer;
  tmrScrollDown.Interval := 25;
  //
 end;

function TMSNPopup.GetEdge: Integer;
var
  AppBar: TAppbarData;
begin
  Result := -1;

  FillChar( AppBar, sizeof(AppBar), 0);
  AppBar.cbSize := Sizeof(AppBar);

  if ShAppBarMessage( ABM_GETTASKBARPOS, AppBar ) <> 0 then
  begin
    if ((AppBar.rc.top = AppBar.rc.left) and (AppBar.rc.bottom > AppBar.rc.right)) then
      Result := ABE_LEFT
    else if ((AppBar.rc.top = AppBar.rc.left) and (AppBar.rc.bottom < AppBar.rc.right)) then
      Result := ABE_TOP
    else if (AppBar.rc.top > AppBar.rc.left ) then
      Result := ABE_BOTTOM
    else
      Result := ABE_RIGHT;
  end;
end;

procedure TfrmMSNPopUp.PopUp;
var
  r: TRect;
  gradient: TBitmap;
  i: Integer;

  //Jelmer
  OldLeft, OldTop: Integer;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);

  Self.AutoScroll := False;

  Self.Height := sHeight;
  Self.Width := sWidth;
  // add by Ahmed Hamed 21-3-2002
  imgMsn:= TImage.Create(Self);
  imgMsn.Stretch := True;
  imgMsn.Parent := pnlBorder;
  imgMsn.Height := 4;
  imgMsn.Align := alBottom;
  imgMsn.Width := Self.Width - 10;
  //
  lblText.Cursor := Cursor;

  //Jelmer
  StoredBorder := ParentMSNPopup.GetEdge;
  CanClose := True;

  case StoredBorder of
    ABE_LEFT:
    begin
      Self.Left := r.Left + ParentMSNPopup.PopupStart;

      //Jelmer
      Self.Top := r.Bottom - ParentMSNPopup.PopupStart - Self.Height - ParentMSNPopup.NextPopupPos;
    end;

    ABE_TOP:
    begin
      Self.Left := r.Right - Self.Width - ParentMSNPopup.PopupStart;

      //Jelmer
      Self.Top := r.Top + ParentMSNPopup.PopupStart + ParentMSNPopup.NextPopupPos;
    end;

    ABE_BOTTOM:
    begin
      Self.Left := r.Right - Self.Width - ParentMSNPopup.PopupStart;

      //Jelmer
      Self.Top := r.Bottom - ParentMSNPopup.PopupStart - Self.Height - ParentMSNPopup.NextPopupPos;
    end;

    ABE_RIGHT:
    begin
      Self.Left := r.Right - Self.Width - ParentMSNPopup.PopupStart;

      //Jelmer
      Self.Top := r.Bottom - ParentMSNPopup.PopupStart - Self.Height - ParentMSNPopup.NextPopupPos;
    end;
  end;

  //Jelmer
  PopupPos := ParentMSNPopup.NextPopupPos;
  if ParentMSNPopup.FCascadePopups = True then begin
    if (StoredBorder = ABE_BOTTOM) or (StoredBorder = ABE_TOP) then begin
      ParentMSNPopup.NextPopupPos := ParentMSNPopup.NextPopupPos + sHeight + ParentMSNPopup.FPopupMarge;
    end else if (StoredBorder = ABE_RIGHT) or (StoredBorder = ABE_LEFT) then begin
      ParentMSNPopup.NextPopupPos := ParentMSNPopup.NextPopupPos + sHeight + ParentMSNPopup.FPopupMarge;
    end;
  end else ParentMSNPopup.NextPopupPos := 0;

  lblTitle.Font := TitleFont;
  lblTitle.Caption := Title;

//Jelmer
  OldLeft := Left;
  OldTop := Top;
  Left := -Width - 10;
  Top := -Height - 10;
  Visible := True;
  Visible := False;
  Left := OldLeft;
  Top := OldTop;

  imgGradient.Align := alNone;
  pnlBorder.Align := alNone;

  imgGradient.Width := pnlBorder.Width;
  imgGradient.Height := pnlBorder.Height;

  if Icon.Empty = False then
  begin
    imgIcon.Picture.Icon := Icon;
  end
  else
    lblTitle.Left := 8;

  //Jelmer
  if Self.ParentMSNPopup.FBackground.Empty then begin
    // add by Ahmed Hamed 21-3-2002
    imgMsn.Picture.Bitmap.LoadFromResourceName(0, 'MSN');

    gradient := TBitmap.Create;
    gradient.Width := pnlBorder.Width - 4;
    gradient.Height := pnlBorder.Height;

    if Orientation = mbVertical then
    begin
      for i := 0 to gradient.Height do
      begin
        gradient.Canvas.Pen.Color := CalcColorIndex( Color1, Color2, gradient.Height + 1, i + 1 );
        gradient.Canvas.MoveTo(0,i);
        gradient.Canvas.LineTo(gradient.width,i);
      end;
    end;

    if Orientation = mbHorizontal then
    begin
      for i := 0 to gradient.Width do
      begin
        gradient.Canvas.Pen.Color := CalcColorIndex( Color1, Color2, gradient.Height + 1, i + 1 );
        gradient.Canvas.MoveTo(i,0);
        gradient.Canvas.LineTo(i,gradient.Height);
      end;
    end;

    imgGradient.Canvas.Draw(0,0,gradient);
    gradient.Free;
  end else begin
    //Jelmer
    imgGradient.Canvas.Draw(0, 0, ParentMSNPopup.FBackground);
  end;

  tmrExit.Interval := TimeOut * 1000;

  if bScroll then begin
    case ParentMSNPopup.GetEdge of
      ABE_TOP: begin
        Self.Height := 1;
      end;

      ABE_BOTTOM: begin
        Self.Top := Self.Top + Self.Height;
        Self.Height := 1;
      end;

      ABE_LEFT: begin
        Self.Width := 1;
      end;

      ABE_RIGHT:
      begin
        Self.Left := Self.Left + Self.Width;
        Self.Width := 1;
      end;
    end;
    tmrScroll.Enabled := True;
  end;

  if not bScroll then
    tmrExit.Enabled := True;

  Self.FormStyle := fsStayOnTop;
  ShowWindow( Self.Handle, SW_SHOWNOACTIVATE);
  Self.Visible := True;

  lblText.Font := HoverFont;
  PositionText;

  lblText.Font := Font;
  PositionText;
end;

procedure TfrmMSNPopUp.lblTextMouseEnter(Sender: TObject);
begin
  // when mouse cursor enters the url area,
  // the text is made blue & underlined
  if bHyperlink then
  begin
    lblText.Font := HoverFont;
    PositionText;
  end;
end;

procedure TfrmMSNPopUp.lblTextMouseLeave(Sender: TObject);
begin
  // when mouse cursor leaves the url area,
  // style of text is normal again
  if bHyperlink then
  begin
    lblText.Font := Font;
    PositionText;
  end;
end;

procedure TfrmMSNPopUp.PositionText;
begin
  lblText.Caption := Text;
  lblText.Width := pnlBorder.Width - 15;

  lblText.Left := Round( ( pnlBorder.Width - lblText.Width ) /2 );
  lblText.Top := Round( ( pnlBorder.Height - lblText.Height ) /2 );
end;

function TfrmMSNPopUp.CalcColorIndex(StartColor, EndColor: TColor; Steps, ColorIndex: Integer): TColor;
var
  BeginRGBValue: Array[0..2] of Byte;
  RGBDifference: Array[0..2] of Integer;
  Red, Green, Blue: Byte;
  NumColors: Integer;
begin
  // Initialize
  NumColors := Steps;
  Dec(ColorIndex);

  // Values are set
  BeginRGBValue[0] := GetRValue(ColorToRGB(StartColor));
  BeginRGBValue[1] := GetGValue(ColorToRGB(StartColor));
  BeginRGBValue[2] := GetBValue(ColorToRGB(StartColor));
  RGBDifference[0] := GetRValue(ColorToRGB(EndColor)) - BeginRGBValue[0];
  RGBDifference[1] := GetGValue(ColorToRGB(EndColor)) - BeginRGBValue[1];
  RGBDifference[2] := GetBValue(ColorToRGB(EndColor)) - BeginRGBValue[2];

  // Calculate the bands color
  Red := BeginRGBValue[0] + MulDiv(ColorIndex, RGBDifference[0], NumColors - 1);
  Green := BeginRGBValue[1] + MulDiv(ColorIndex, RGBDifference[1], NumColors - 1);
  Blue := BeginRGBValue[2] + MulDiv(ColorIndex, RGBDifference[2], NumColors - 1);

  // The final color is returned
  Result := RGB(Red, Green, Blue);
end;

procedure TfrmMSNPopUp.lblTextClick(Sender: TObject);
begin
  // when user clicks the hyperlink, and the Hyperlink
  // property is true, a browser window opens
  //Jelmer
  CanClose := False;
  if bHyperlink then begin
    if Assigned(Self.ParentMSNPopup.FOnURLClick) then Self.ParentMSNPopup.FOnURLClick(Self, URL);
    if Self.ParentMSNPopup.FAutoOpenURL = True then ShellExecute(0, nil, PChar(URL), nil, nil, SW_SHOWDEFAULT);
  end else if Assigned(Self.ParentMSNPopup.FOnClick) then Self.ParentMSNPopup.FOnClick(Self);
  CanClose := True;
  Self.Close;
end;

procedure TfrmMSNPopUp.tmrExitTimer(Sender: TObject);
begin
  // after several seconds, the popup window will disappear
  // add by Ahmed Hamed 20-3-2002
  tmrExit.Enabled :=False;
  tmrScrollDown.Enabled := True;
  //
end;

// add by Ahmed Hamed 20-3-2002
procedure TfrmMSNPopUp.tmrScrollDownTimer(Sender: TObject);
var
  r: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);

  case StoredBorder of
    ABE_LEFT:
    begin
      if (Self.Width - Scrollspeed) > 0 then
      begin
        Self.Width := Self.Width - ScrollSpeed;
      end
      else Self.Close;
    end;

    ABE_TOP:
    begin
      if (Self.Height - ScrollSpeed) > 0 then
      begin
        Self.Height := Self.Height - ScrollSpeed;
      end
      else  Self.Close;

    end;

    ABE_BOTTOM:
    begin
      if (Self.Height - ScrollSpeed) > 0 then
      begin
        Self.Top := Self.Top + ScrollSpeed;
        Self.Height := Self.Height - ScrollSpeed;
      end
     else Self.Close;
     end;

    ABE_RIGHT:
    begin
      if (Self.Width - ScrollSpeed) > 0 then
      begin
        Self.Left := Self.Left + ScrollSpeed;
        Self.Width := Self.Width - ScrollSpeed;
      end
     else Self.Close;
    end;
  end;
end;
//

procedure TfrmMSNPopUp.lblTextMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // close the popup window on right click
  //Jelmer
  if Button = mbRight then begin
    if Assigned(Self.ParentMSNPopup.FOnClick) then begin
      CanClose := False;
      Self.ParentMSNPopup.FOnClick(Self.ParentMSNPopup);
      CanClose := True;
    end;
    Self.Close;
  end;
end;

procedure TfrmMSNPopUp.tmrScrollTimer(Sender: TObject);
var
  r: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);

  case StoredBorder of
    ABE_LEFT:
    begin
      if (Self.Width + Scrollspeed) < sWidth then
      begin
        Self.Width := Self.Width + ScrollSpeed;
      end
      else
      begin
        Self.Width := sWidth;
        tmrScroll.Enabled := False;
        tmrExit.Enabled := True;
      end;
    end;

    ABE_TOP:
    begin
      if (Self.Height + ScrollSpeed) < sHeight then
      begin
        Self.Height := Self.Height + ScrollSpeed;
      end
      else
      begin
        Self.Height := sHeight;
        tmrScroll.Enabled := False;
        tmrExit.Enabled := True;
      end;
    end;

    ABE_BOTTOM:
    begin
      if (Self.Height + ScrollSpeed) < sHeight then
      begin
        Self.Top := Self.Top - ScrollSpeed;
        Self.Height := Self.Height + ScrollSpeed;
      end
      else
      begin
        Self.Height := sHeight;

        //Jelmer
        Self.Top := r.Bottom - ParentMSNPopup.PopupStart - Self.Height - Self.PopupPos;

        tmrScroll.Enabled := False;
        tmrExit.Enabled := True;
      end;
    end;

    ABE_RIGHT:
    begin
      if (Self.Width + ScrollSpeed) < sWidth then
      begin
        Self.Left := Self.Left - ScrollSpeed;
        Self.Width := Self.Width + ScrollSpeed;
      end
      else
      begin
        Self.Width := sWidth;

        //Jelmer
        Self.Left := r.Right - ParentMSNPopup.PopupStart - Self.Width;

        tmrScroll.Enabled := False;
        tmrExit.Enabled := True;
      end;
    end;
  end;
end;

procedure TfrmMSNPopUp.imgIconMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // close the popup window on click
  //Jelmer
  if Assigned(Self.ParentMSNPopup.FOnClick) then begin
    CanClose := False;
    Self.ParentMSNPopup.FOnClick(Self.ParentMSNPopup);
    CanClose := True;
  end;
  Self.Close;
end;

procedure TfrmMSNPopUp.imgGradientMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // close the popup window on click
  //Jelmer
  if Assigned(Self.ParentMSNPopup.FOnClick) then begin
    CanClose := False;
    Self.ParentMSNPopup.FOnClick(Self.ParentMSNPopup);
    CanClose := True;
  end;
  Self.Close;
end;

procedure TfrmMSNPopUp.lblTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // close the popup window on click
  //Jelmer
  if Assigned(Self.ParentMSNPopup.FOnClick) then begin
    CanClose := False;
    Self.ParentMSNPopup.FOnClick(Self.ParentMSNPopup);
    CanClose := True;
  end;
  Self.Close;
end;

procedure TfrmMSNPopUp.DoClose(var Action: TCloseAction);
begin
  //Jelmer
  if CanClose = False then begin
    Action := caHide;
  end else begin
    if ParentMSNPopup.PopupCount > 0 then Dec(ParentMSNPopup.PopupCount);
    Action := caFree;
  end;
  inherited;
end;

procedure TMSNPopUp.SetBackground(Value: TBitmap);
begin
  if Value <> Self.FBackground then
  begin
    Self.FBackground.Assign(Value);
  end;
end;

end.
