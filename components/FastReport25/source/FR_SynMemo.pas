
{******************************************}
{                                          }
{             FastReport v3.0              }
{           Syntax memo control            }
{                                          }
{Copyright(c) 1998-2003 by FastReports Inc.}
{                                          }
{******************************************}

unit FR_SynMemo;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, Forms;

type

{ Simple syntax highlighter. Supports Pascal and SQL syntax.

  Assign text to Text property.
  Assign desired value to SyntaxType property.
  Call SetPos to move caret.
  Call ShowMessage to display an error message at the bottom.
}

  TSyntaxType = (stPascal, stSQL, stText);
  TCharAttr = (caText, caBlock, caComment, caKeyword, caString);
  TCharAttributes = set of TCharAttr;

  TSyntaxMemo = class(TCustomControl)
  private
    FAllowLinesChange: Boolean;
    FBlockColor: TColor;
    FBlockFontColor: TColor;
    FBusy: Boolean;
    FCharHeight: Integer;
    FCharWidth: Integer;
    FCommentAttr: TFont;
    FDown: Boolean;
    FIsMonoType: Boolean;
    FKeywordAttr: TFont;
    FKeywords: String;
    FMaxLength: Integer;
    FMessage: String;
    FMoved: Boolean;
    FOffset: TPoint;
    FPos: TPoint;
    FReadOnly: Boolean;
    FSelEnd: TPoint;
    FSelStart: TPoint;
    FStringAttr: TFont;
    FSyn: String;
    FSyntaxType: TSyntaxType;
    FTempPos: TPoint;
    FText: TStringList;
    FTextAttr: TFont;
    FUndo: TStringList;
    FVScroll: TScrollBar;
    FWindowSize: TPoint;

    function GetText: TStrings;
    procedure SetText(Value: TStrings);
    procedure SetSyntaxType(Value: TSyntaxType);

    function GetCharAttr(Pos: TPoint; Pos1: Integer): TCharAttributes;
    function GetLineBegin(Index: Integer): Integer;
    function GetPlainTextPos(Pos: TPoint): Integer;
    function GetPosPlainText(Pos: Integer): TPoint;
    function GetSelText: String;
    function LineAt(Index: Integer): String;
    function LineLength(Index: Integer): Integer;
    function Pad(n: Integer): String;
    procedure AddSel;
    procedure AddUndo;
    procedure ClearSel;
    procedure CreateSynArray;
    procedure EnterIndent;
    procedure SetSelText(Value: String);
    procedure ShiftSelected(ShiftRight: Boolean);
    procedure ShowCaretPos;
    procedure TabIndent;
    procedure Undo;
    procedure UnIndent;
    procedure UpdateScrollBar;
    procedure UpdateSyntax;

    procedure DoLeft;
    procedure DoRight;
    procedure DoUp;
    procedure DoDown;
    procedure DoHome(Ctrl: Boolean);
    procedure DoEnd(Ctrl: Boolean);
    procedure DoPgUp;
    procedure DoPgDn;
    procedure DoChar(Ch: Char);
    procedure DoReturn;
    procedure DoDel;
    procedure DoBackspace;
    procedure DoCtrlI;
    procedure DoCtrlU;

    procedure ScrollClick(Sender: TObject);
    procedure ScrollEnter(Sender: TObject);
    procedure LinesChange(Sender: TObject);
  protected
    { Windows-specific stuff }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    { End of stuff }

    procedure SetParent(AParent: TWinControl); override;
    function GetClientRect: TRect; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;

    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure PasteFromClipboard;
    procedure SetPos(x, y: Integer);
    procedure ShowMessage(s: String);

    property BlockColor: TColor read FBlockColor write FBlockColor;
    property BlockFontColor: TColor read FBlockFontColor write FBlockFontColor;
    property CommentAttr: TFont read FCommentAttr write FCommentAttr;
    property KeywordAttr: TFont read FKeywordAttr write FKeywordAttr;
    property StringAttr: TFont read FStringAttr write FStringAttr;
    property TextAttr: TFont read FTextAttr write FTextAttr;
    property Color;
    property Font;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property SelText: String read GetSelText write SetSelText;
    property SyntaxType: TSyntaxType read FSyntaxType write SetSyntaxType;
    property Lines: TStrings read GetText write SetText;
  end;


implementation

uses Clipbrd;

const
  PasKeywords =
     'and,array,as,begin,case,class,const,constructor,destructor,div,'+
     'do,downto,else,end,except,finally,for,forward,function,goto,if,'+
     'is,in,inherited,label,mod,nil,not,object,of,on,or,override,'+
     'private,procedure,program,property,protected,public,raise,record,'+
     'repeat,set,shl,shr,string,then,to,try,type,until,uses,var,'+
     'virtual,while,with,xor';

  SQLKeywords =
    'active,after,all,alter,and,any,as,asc,ascending,at,auto,' +
    'base_name,before,begin,between,by,cache,cast,check,column,commit,' +
    'committed,computed,conditional,constraint,containing,count,create,' +
    'current,cursor,database,debug,declare,default,delete,desc,descending,' +
    'distinct,do,domain,drop,else,end,entry_point,escape,exception,execute,' +
    'exists,exit,external,extract,filter,for,foreign,from,full,function,' +
    'generator,grant,group,having,if,in,inactive,index,inner,insert,into,is,' +
    'isolation,join,key,left,level,like,merge,names,no,not,null,of,on,only,' +
    'or,order,outer,parameter,password,plan,position,primary,privileges,' +
    'procedure,protected,read,retain,returns,revoke,right,rollback,schema,' +
    'select,set,shadow,shared,snapshot,some,suspend,table,then,to,' +
    'transaction,trigger,uncommitted,union,unique,update,user,using,view,' +
    'wait,when,where,while,with,work';

type
  THackScrollBar = class(TScrollBar)
  end;


{ TSyntaxMemo }

constructor TSyntaxMemo.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF Delphi4}
  DoubleBuffered := True;
{$ENDIF}
  FVScroll := TScrollBar.Create(Self);
  FVScroll.Parent := Self;
  FVScroll.Kind := sbVertical;
  FVScroll.OnChange := ScrollClick;
  FVScroll.OnEnter := ScrollEnter;

  FText := TStringList.Create;
  FUndo := TStringList.Create;
  FText.Add('');
  FText.OnChange := LinesChange;
  FMaxLength := 1024;
  SyntaxType := stPascal;
  FMoved := True;
  SetPos(1, 1);

  Cursor := crIBeam;
  Font.Size := 10;
  Font.Name := 'Courier New';

  FBlockColor := clHighlight;
  FBlockFontColor := clHighlightText;

  FCommentAttr := TFont.Create;
  FCommentAttr.Color := clNavy;
  FCommentAttr.Style := [fsItalic];

  FKeywordAttr := TFont.Create;
  FKeywordAttr.Color := clWindowText;
  FKeywordAttr.Style := [fsBold];

  FStringAttr := TFont.Create;
  FStringAttr.Color := clWindowText;
  FStringAttr.Style := [];

  FTextAttr := TFont.Create;
  FTextAttr.Color := clWindowText;
  FTextAttr.Style := [];
end;

destructor TSyntaxMemo.Destroy;
begin
  FCommentAttr.Free;
  FKeywordAttr.Free;
  FStringAttr.Free;
  FTextAttr.Free;
  FText.Free;
  FUndo.Free;
  inherited;
end;

{ Windows-specific stuff }

procedure TSyntaxMemo.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
    ExStyle := ExStyle or WS_EX_CLIENTEDGE;
end;

procedure TSyntaxMemo.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  HideCaret(Handle);
  DestroyCaret;
end;

procedure TSyntaxMemo.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  CreateCaret(Handle, 0, 2, FCharHeight);
  ShowCaretPos;
end;

procedure TSyntaxMemo.ShowCaretPos;
begin
  SetCaretPos(FCharWidth * (FPos.X - 1 - FOffset.X) + 1,
    FCharHeight * (FPos.Y - 1 - FOffset.Y));
  ShowCaret(Handle);
end;

procedure TSyntaxMemo.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTTAB;
end;

procedure TSyntaxMemo.CMFontChanged(var Message: TMessage);
var
  b: TBitmap;
begin
  b := TBitmap.Create;
  with b.Canvas do
  begin
    Font.Assign(Self.Font);
    Font.Style := [fsBold];
    FCharHeight := TextHeight('Wg');
    FCharWidth := TextWidth('W');
    FIsMonoType := Pos('COURIER NEW', AnsiUppercase(Canvas.Font.Name)) <> 0;
  end;
  b.Free;
end;

{ End of stuff }

procedure TSyntaxMemo.SetParent(AParent: TWinControl);
begin
  inherited;
  if (Parent = nil) or (csDestroying in ComponentState) then Exit;

  FVScroll.Ctl3D := False;
  Color := clWindow;
  TabStop := True;
end;

function TSyntaxMemo.GetClientRect: TRect;
begin
  if FVScroll.Visible then
    Result := Bounds(0, 0, Width - FVScroll.Width - 4, Height) else
    Result := inherited GetClientRect;
end;

procedure TSyntaxMemo.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if FCharWidth = 0 then exit;

  FWindowSize := Point((ClientWidth - 2) div FCharWidth, (Height - 4) div FCharHeight);
  FVScroll.SetBounds(Width - FVScroll.Width - 4, 0, FVScroll.Width, Height - 4);
  UpdateScrollBar;
end;

procedure TSyntaxMemo.UpdateSyntax;
begin
  CreateSynArray;
  Repaint;
end;

procedure TSyntaxMemo.UpdateScrollBar;
begin
  with FVScroll do
  begin
// prevent OnScroll event
    FBusy := True;

    Position := 0;
{$IFDEF Delphi4}
    PageSize := 0;
{$ENDIF}
    Max := FText.Count;
    SmallChange := 1;
    if FWindowSize.Y < Max then
    begin
      Visible := True;
{$IFDEF Delphi4}
      PageSize := FWindowSize.Y;
{$ENDIF}
    end
    else
      Visible := False;
    LargeChange := FWindowSize.Y;
    Position := FOffset.Y;

// need to do this due to bug in the VCL
    THackScrollBar(FVScroll).RecreateWnd;
    FBusy := False;
  end;
end;

function TSyntaxMemo.GetText: TStrings;
var
  i: Integer;
begin
  for i := 0 to FText.Count - 1 do
    FText[i] := LineAt(i);
  Result := FText;
  FAllowLinesChange := True;
end;

procedure TSyntaxMemo.SetText(Value: TStrings);
begin
  FAllowLinesChange := True;
  FText.Assign(Value);
end;

procedure TSyntaxMemo.SetSyntaxType(Value: TSyntaxType);
begin
  FSyntaxType := Value;
  if Value = stPascal then
    FKeywords := PasKeywords
  else if Value = stSQL then
    FKeywords := SQLKeywords
  else
    FKeywords := '';
  UpdateSyntax;
end;

procedure TSyntaxMemo.LinesChange(Sender: TObject);
begin
  if FAllowLinesChange then
  begin
    FAllowLinesChange := False;
    if FText.Count = 0 then
      FText.Add('');
    FMoved := True;
    FUndo.Clear;
    FPos := Point(1, 1);
    FOffset := Point(0, 0);
    ClearSel;
    ShowCaretPos;
    UpdateSyntax;
  end;
end;

procedure TSyntaxMemo.ShowMessage(s: String);
begin
  FMessage := s;
  Repaint;
end;

procedure TSyntaxMemo.CopyToClipboard;
begin
  if FSelStart.X <> 0 then
    Clipboard.AsText := SelText;
end;

procedure TSyntaxMemo.CutToClipboard;
begin
  if not FReadOnly then
    if FSelStart.X <> 0 then
    begin
      Clipboard.AsText := SelText;
      SelText := '';
    end;
end;

procedure TSyntaxMemo.PasteFromClipboard;
begin
  if not FReadOnly then
    SelText := Clipboard.AsText;
end;

function TSyntaxMemo.LineAt(Index: Integer): String;
begin
  Result := TrimRight(FText[Index]);
end;

function TSyntaxMemo.LineLength(Index: Integer): Integer;
begin
  Result := Length(LineAt(Index));
end;

function TSyntaxMemo.Pad(n: Integer): String;
begin
  Result := '';
  while Length(Result) < n do
    Result := Result + ' ';
end;

procedure TSyntaxMemo.AddUndo;
begin
  if not FMoved then exit;
  FUndo.Add(Format('%5d%5d', [FPos.X, FPos.Y]) + FText.Text);
  if FUndo.Count > 32 then
    FUndo.Delete(0);
end;

procedure TSyntaxMemo.Undo;
var
  s: String;
begin
  FMoved := True;
  if FUndo.Count = 0 then exit;
  s := FUndo[FUndo.Count - 1];
  FPos.X := StrToInt(Copy(s, 1, 5));
  FPos.Y := StrToInt(Copy(s, 6, 5));
  FText.Text := Copy(s, 11, Length(s) - 10);
  FUndo.Delete(FUndo.Count - 1);
  SetPos(FPos.X, FPos.Y);
  UpdateSyntax;
end;

function TSyntaxMemo.GetPlainTextPos(Pos: TPoint): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Pos.Y - 2 do
    Result := Result + Length(FText[i]) + 2;
  Result := Result + Pos.X;
end;

function TSyntaxMemo.GetPosPlainText(Pos: Integer): TPoint;
var
  i: Integer;
  s: String;
begin
  Result := Point(0, 1);
  s := FText.Text;
  i := 1;
  while i <= Pos do
    if s[i] = #13 then
    begin
      Inc(i, 2);
      if i <= Pos then
      begin
        Inc(Result.Y);
        Result.X := 0;
      end
      else
        Inc(Result.X);
    end
    else
    begin
      Inc(i);
      Inc(Result.X);
    end;
end;

function TSyntaxMemo.GetLineBegin(Index: Integer): Integer;
var
  s: String;
begin
  s := FText[Index];
  Result := 1;
  if Trim(s) <> '' then
    for Result := 1 to Length(s) do
      if s[Result] <> ' ' then
        break;
end;

procedure TSyntaxMemo.TabIndent;
var
  i, n, res: Integer;
  s: String;
begin
  res := FPos.X;
  i := FPos.Y - 2;

  while i >= 0 do
  begin
    res := FPos.X;
    s := FText[i];
    n := LineLength(i);

    if res > n then
      Dec(i)
    else
    begin
      if s[res] = ' ' then
      begin
        while s[res] = ' ' do
          Inc(res);
      end
      else
      begin
        while (res <= n) and (s[res] <> ' ') do
          Inc(res);

        while (res <= n) and (s[res] = ' ') do
          Inc(res);
      end;
      break;
    end;
  end;

  SelText := Pad(res - FPos.X);
end;

procedure TSyntaxMemo.EnterIndent;
var
  res: Integer;
begin
  if Trim(FText[FPos.Y - 1]) = '' then
    res := FPos.X else
    res := GetLineBegin(FPos.Y - 1);

  FPos := Point(1, FPos.Y + 1);
  SelText := Pad(res - 1);
end;

procedure TSyntaxMemo.UnIndent;
var
  i, res: Integer;
begin
  i := FPos.Y - 2;
  res := FPos.X - 1;

  while i >= 0 do
  begin
    res := GetLineBegin(i);
    if (res < FPos.X) and (Trim(FText[i]) <> '') then
      break else
      Dec(i);
  end;
  FSelStart := FPos;
  FSelEnd := FPos;
  Dec(FSelEnd.X, FPos.X - res);
  SelText := '';
end;

procedure TSyntaxMemo.ShiftSelected(ShiftRight: Boolean);
var
  i, ib, ie: Integer;
  s: String;
  Shift: Integer;
begin
  if FReadOnly then exit;
  AddUndo;
  if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    ib := FSelStart.Y - 1;
    ie := FSelEnd.Y - 1;
  end
  else
  begin
    ib := FSelEnd.Y - 1;
    ie := FSelStart.Y - 1;
  end;
  if FSelEnd.X = 1 then
    Dec(ie);

  Shift := 2;
  if not ShiftRight then
    for i := ib to ie do
    begin
      s := FText[i];
      if (Trim(s) <> '') and (GetLineBegin(i) - 1 < Shift) then
        Shift := GetLineBegin(i) - 1;
    end;

  for i := ib to ie do
  begin
    s := FText[i];
    if ShiftRight then
      s := Pad(Shift) + s
    else if Trim(s) <> '' then
      Delete(s, 1, Shift);
    FText[i] := s;
  end;
  UpdateSyntax;
end;

function TSyntaxMemo.GetSelText: String;
var
  p1, p2: TPoint;
  i: Integer;
begin
  if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    p1 := FSelStart;
    p2 := FSelEnd;
    Dec(p2.X);
  end
  else
  begin
    p1 := FSelEnd;
    p2 := FSelStart;
    Dec(p2.X);
  end;

  if LineLength(p1.Y - 1) < p1.X then
  begin
    Inc(p1.Y);
    p1.X := 1;
  end;
  if LineLength(p2.Y - 1) < p2.X then
    p2.X := LineLength(p2.Y - 1);

  i := GetPlainTextPos(p1);
  Result := Copy(FText.Text, i, GetPlainTextPos(p2) - i + 1);
end;

procedure TSyntaxMemo.SetSelText(Value: String);
var
  p1, p2: TPoint;
  i: Integer;
  s: String;
begin
  if FReadOnly then exit;
  AddUndo;
  if FSelStart.X = 0 then
  begin
    p1 := FPos;
    p2 := p1;
    Dec(p2.X);
  end
  else if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    p1 := FSelStart;
    p2 := FSelEnd;
    Dec(p2.X);
  end
  else
  begin
    p1 := FSelEnd;
    p2 := FSelStart;
    Dec(p2.X);
  end;

  if LineLength(p1.Y - 1) < p1.X then
    FText[p1.Y - 1] := FText[p1.Y - 1] + Pad(p1.X - LineLength(p1.Y - 1) + 1);
  if LineLength(p2.Y - 1) < p2.X then
    p2.X := LineLength(p2.Y - 1);

  i := GetPlainTextPos(p1);
  s := FText.Text;
  Delete(s, i, GetPlainTextPos(p2) - i + 1);
  Insert(Value, s, i);
  FText.Text := s;
  p1 := GetPosPlainText(i + Length(Value));
  SetPos(p1.X, p1.Y);
  FSelStart.X := 0;
  UpdateSyntax;
end;

procedure TSyntaxMemo.ClearSel;
begin
  if FSelStart.X <> 0 then
  begin
    FSelStart := Point(0, 0);
    Repaint;
  end;
end;

procedure TSyntaxMemo.AddSel;
begin
  if FSelStart.X = 0 then
    FSelStart := FTempPos;
  FSelEnd := FPos;
  Repaint;
end;

procedure TSyntaxMemo.SetPos(x, y: Integer);
begin
  if FMessage <> '' then
  begin
    FMessage := '';
    Repaint;
  end;

  if x > FMaxLength then x := FMaxLength;
  if x < 1 then x := 1;
  if y > FText.Count then y := FText.Count;
  if y < 1 then y := 1;

  FPos := Point(x, y);
  if (FWindowSize.X = 0) or (FWindowSize.Y = 0) then exit;

  if FOffset.Y >= FText.Count then
    FOffset.Y := FText.Count - 1;

  if FPos.X > FOffset.X + FWindowSize.X then
  begin
    Inc(FOffset.X, FPos.X - (FOffset.X + FWindowSize.X));
    Repaint;
  end
  else if FPos.X <= FOffset.X then
  begin
    Dec(FOffset.X, FOffset.X - FPos.X + 1);
    Repaint;
  end
  else if FPos.Y > FOffset.Y + FWindowSize.Y then
  begin
    Inc(FOffset.Y, FPos.Y - (FOffset.Y + FWindowSize.Y));
    Repaint;
  end
  else if FPos.Y <= FOffset.Y then
  begin
    Dec(FOffset.Y, FOffset.Y - FPos.Y + 1);
    Repaint;
  end;

  ShowCaretPos;
  UpdateScrollBar;
end;

procedure TSyntaxMemo.ScrollClick(Sender: TObject);
begin
  if FBusy then exit;
  FOffset.Y := FVScroll.Position;
  if FOffset.Y > FText.Count then
    FOffset.Y := FText.Count;
  ShowCaretPos;
  Repaint;
end;

procedure TSyntaxMemo.ScrollEnter(Sender: TObject);
begin
  SetFocus;
end;

procedure TSyntaxMemo.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FMoved := True;
  if not Focused then
    SetFocus;
  FDown := True;
  SetPos(X div FCharWidth + 1 + FOffset.X, Y div FCharHeight + 1 + FOffset.Y);
  ClearSel;
end;

procedure TSyntaxMemo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FDown then
  begin
    FTempPos := FPos;
    SetPos(X div FCharWidth + 1 + FOffset.X, Y div FCharHeight + 1 + FOffset.Y);
    AddSel;
  end;
end;

procedure TSyntaxMemo.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FDown := False;
end;

procedure TSyntaxMemo.KeyDown(var Key: Word; Shift: TShiftState);
var
  MyKey: Boolean;
begin
  inherited;
  FAllowLinesChange := False;

  FTempPos := FPos;
  MyKey := True;
  case Key of
    vk_Left:
      DoLeft;

    vk_Right:
      DoRight;

    vk_Up:
      DoUp;

    vk_Down:
      DoDown;

    vk_Home:
      DoHome(ssCtrl in Shift);

    vk_End:
      DoEnd(ssCtrl in Shift);

    vk_Prior:
      DoPgUp;

    vk_Next:
      DoPgDn;

    vk_Return:
      if Shift = [] then
        DoReturn;

    vk_Delete:
      if ssShift in Shift then
        CutToClipboard else
        DoDel;

    vk_Back:
      DoBackspace;

    vk_Insert:
      if ssCtrl in Shift then
        CopyToClipboard
      else if ssShift in Shift then
        PasteFromClipboard;

    vk_Tab:
      TabIndent;
  else
    MyKey := False;
  end;

  if Key in [vk_Left, vk_Right, vk_Up, vk_Down, vk_Home, vk_End, vk_Prior, vk_Next] then
  begin
    FMoved := True;
    if ssShift in Shift then
      AddSel else
      ClearSel;
  end
  else if Key in [vk_Return, vk_Delete, vk_Back, vk_Insert, vk_Tab] then
    FMoved := False;

  if MyKey then
    Key := 0;
end;

procedure TSyntaxMemo.KeyPress(var Key: Char);
var
  MyKey: Boolean;
begin
  inherited;

  MyKey := True;
  case Key of
    #3:
      CopyToClipboard;

    #9:
      DoCtrlI;

    #21:
      DoCtrlU;

    #22:
      PasteFromClipboard;

    #24:
      CutToClipboard;

    #26:
      Undo;

    #32..#255:
      begin
        DoChar(Key);
        FMoved := False;
      end;
  else
    MyKey := False;
  end;

  if MyKey then
    Key := #0;
end;

procedure TSyntaxMemo.DoLeft;
begin
  Dec(FPos.X);
  if FPos.X < 1 then
    FPos.X := 1;
  SetPos(FPos.X, FPos.Y);
end;

procedure TSyntaxMemo.DoRight;
begin
  Inc(FPos.X);
  if FPos.X > FMaxLength then
    FPos.X := FMaxLength;
  SetPos(FPos.X, FPos.Y);
end;

procedure TSyntaxMemo.DoUp;
begin
  Dec(FPos.Y);
  if FPos.Y < 1 then
    FPos.Y := 1;
  SetPos(FPos.X, FPos.Y);
end;

procedure TSyntaxMemo.DoDown;
begin
  Inc(FPos.Y);
  if FPos.Y > FText.Count then
    FPos.Y := FText.Count;
  SetPos(FPos.X, FPos.Y);
end;

procedure TSyntaxMemo.DoHome(Ctrl: Boolean);
begin
  if Ctrl then
    SetPos(1, 1) else
    SetPos(1, FPos.Y);
end;

procedure TSyntaxMemo.DoEnd(Ctrl: Boolean);
begin
  if Ctrl then
    SetPos(LineLength(FText.Count - 1) + 1, FText.Count) else
    SetPos(LineLength(FPos.Y - 1) + 1, FPos.Y);
end;

procedure TSyntaxMemo.DoPgUp;
begin
  if FOffset.Y > FWindowSize.Y then
  begin
    Dec(FOffset.Y, FWindowSize.Y - 1);
    Dec(FPos.Y, FWindowSize.Y - 1);
  end
  else
  begin
    if FOffset.Y > 0 then
    begin
      Dec(FPos.Y, FOffset.Y);
      FOffset.Y := 0;
    end
    else
      FPos.Y := 1;
  end;
  SetPos(FPos.X, FPos.Y);
  Repaint;
end;

procedure TSyntaxMemo.DoPgDn;
begin
  if FOffset.Y + FWindowSize.Y < FText.Count then
  begin
    Inc(FOffset.Y, FWindowSize.Y - 1);
    Inc(FPos.Y, FWindowSize.Y - 1);
  end
  else
  begin
    FOffset.Y := FText.Count;
    FPos.Y := FText.Count;
  end;
  SetPos(FPos.X, FPos.Y);
  Repaint;
end;

procedure TSyntaxMemo.DoReturn;
var
  s: String;
begin
  if FReadOnly then exit;
  s := LineAt(FPos.Y - 1);
  FText[FPos.Y - 1] := Copy(s, 1, FPos.X - 1);
  FText.Insert(FPos.Y, Copy(s, FPos.X, FMaxLength));
  EnterIndent;
end;

procedure TSyntaxMemo.DoDel;
var
  s: String;
begin
  if FReadOnly then exit;
  FMessage := '';
  if FSelStart.X <> 0 then
    SelText := ''
  else
  begin
    s := FText[FPos.Y - 1];
    AddUndo;
    if FPos.X <= LineLength(FPos.Y - 1) then
    begin
      Delete(s, FPos.X, 1);
      FText[FPos.Y - 1] := s;
    end
    else if FPos.Y < FText.Count then
    begin
      s := s + Pad(FPos.X - Length(s) - 1) + LineAt(FPos.Y);
      FText[FPos.Y - 1] := s;
      FText.Delete(FPos.Y);
    end;
    UpdateScrollBar;
    UpdateSyntax;
  end;
end;

procedure TSyntaxMemo.DoBackspace;
var
  s: String;
begin
  if FReadOnly then exit;
  FMessage := '';
  if FSelStart.X <> 0 then
    SelText := ''
  else
  begin
    s := FText[FPos.Y - 1];
    if FPos.X > 1 then
    begin
      if (GetLineBegin(FPos.Y - 1) = FPos.X) or (Trim(s) = '') then
        UnIndent
      else
      begin
        AddUndo;
        if Trim(s) <> '' then
        begin
          Delete(s, FPos.X - 1, 1);
          FText[FPos.Y - 1] := s;
          DoLeft;
        end
        else
          DoHome(False);
        UpdateSyntax;
      end;
    end
    else if FPos.Y > 1 then
    begin
      AddUndo;
      s := LineAt(FPos.Y - 2);
      FText[FPos.Y - 2] := s + FText[FPos.Y - 1];
      FText.Delete(FPos.Y - 1);
      SetPos(Length(s) + 1, FPos.Y - 1);
      UpdateSyntax;
    end;
  end;
end;

procedure TSyntaxMemo.DoCtrlI;
begin
  if FSelStart.X <> 0 then
    ShiftSelected(True);
end;

procedure TSyntaxMemo.DoCtrlU;
begin
  if FSelStart.X <> 0 then
    ShiftSelected(False);
end;

procedure TSyntaxMemo.DoChar(Ch: Char);
begin
  SelText := Ch;
end;

// need two parameters to speed up the work
function TSyntaxMemo.GetCharAttr(Pos: TPoint; Pos1: Integer): TCharAttributes;

  function IsBlock: Boolean;
  var
    p1, p2, p3: Integer;
  begin
    Result := False;
    if FSelStart.X = 0 then exit;

    p1 := FSelStart.X + FSelStart.Y * FMaxLength;
    p2 := FSelEnd.X + FSelEnd.Y * FMaxLength;
    if p1 > p2 then
    begin
      p3 := p1;
      p1 := p2;
      p2 := p3;
    end;
    p3 := Pos.X + Pos.Y * FMaxLength;
    Result := (p3 >= p1) and (p3 < p2);
  end;

  function CharAttr: TCharAttr;
  begin
    if Pos1 <= Length(FSyn) then
      Result := TCharAttr(Ord(FSyn[Pos1])) else
      Result := caText;
  end;

begin
  Result := [CharAttr];
  if IsBlock then
    Result := Result + [caBlock];
end;

procedure TSyntaxMemo.Paint;
var
  i, j, j1, Pos1: Integer;
  a, a1: TCharAttributes;
  s: String;

  procedure SetAttr(a: TCharAttributes);
  begin
    with Canvas do
    begin
      Brush.Color := Color;

      if caText in a then
        Font.Assign(FTextAttr);

      if caComment in a then
        Font.Assign(FCommentAttr);

      if caKeyword in a then
        Font.Assign(FKeywordAttr);

      if caString in a then
        Font.Assign(FStringAttr);

      if caBlock in a then
      begin
        Brush.Color := FBlockColor;
        Font.Color := FBlockFontColor;
      end;

      Font.Name := Self.Font.Name;
      Font.Size := Self.Font.Size;
{$IFNDEF Delphi2}
      Font.Charset := Self.Font.Charset;
{$ENDIF}
    end;
  end;

  procedure MyTextOut(x, y: Integer; s: String);
  var
    i: Integer;
  begin
    if FIsMonoType then
      Canvas.TextOut(x, y, s)
    else
    with Canvas do
    begin
      FillRect(Rect(x, y, x + Length(s) * FCharWidth, y + FCharHeight));
      for i := 1 to Length(s) do
        TextOut(x + (i - 1) * FCharWidth, y, s[i]);
      MoveTo(x + Length(s) * FCharWidth, y);
    end;
  end;

begin
  with Canvas do
  begin

    for i := FOffset.Y to FOffset.Y + FWindowSize.Y do
    begin
      if i >= FText.Count then break;

      Pos1 := GetPlainTextPos(Point(1, i + 1)) - 1;
      s := FText[i];
      PenPos := Point(2, (i - FOffset.Y) * FCharHeight);
      j1 := FOffset.X + 1;
      a := GetCharAttr(Point(j1, i + 1), Pos1 + j1);
      a1 := a;

      for j := j1 to FOffset.X + FWindowSize.X do
      begin
        if j > Length(s) then break;

        a1 := GetCharAttr(Point(j, i + 1), Pos1 + j);
        if a1 <> a then
        begin
          SetAttr(a);
          MyTextOut(PenPos.X, PenPos.Y, Copy(FText[i], j1, j - j1));
          a := a1;
          j1 := j;
        end;
      end;

      SetAttr(a);
      MyTextOut(PenPos.X, PenPos.Y, Copy(s, j1, FMaxLength));
      if caBlock in GetCharAttr(Point(0, i + 2), 1) then
        MyTextOut(PenPos.X, PenPos.Y, Pad(FWindowSize.X - Length(s) - FOffset.X + 3));
    end;

    if FMessage <> '' then
    begin
      Font.Name := 'MS Sans Serif';
      Font.Color := clWhite;
      Font.Style := [];
      Brush.Color := clRed;
      FillRect(Rect(0, Height - TextHeight('|') - 6, Width, Height));
      TextOut(6, Height - TextHeight('|') - 5, FMessage);
    end;
  end;
end;

procedure TSyntaxMemo.CreateSynArray;
var
  i, n, Pos: Integer;
  ch: Char;

  procedure SkipSpaces;
  begin
    while (Pos <= Length(FSyn)) and
          ((FSyn[Pos] in [#1..#32]) or
           not (FSyn[Pos] in ['_', 'A'..'Z', 'a'..'z', '''', '"', '/', '{', '(', '-'])) do
      Inc(Pos);
  end;

  function IsKeyWord(s: String): Boolean;
  begin
    Result := False;
    if FKeywords = '' then exit;

    if FKeywords[1] <> ',' then
      FKeywords := ',' + FKeywords;
    if FKeywords[Length(FKeywords)] <> ',' then
      FKeywords := FKeywords + ',';

    Result := System.Pos(',' + AnsiLowerCase(s) + ',', FKeywords) <> 0;
  end;

  function GetIdent: TCharAttr;
  var
    i: Integer;
    cm1, cm2, cm3, cm4, st1: Char;
  begin
    i := Pos;
    Result := caText;

    if FSyntaxType = stPascal then
    begin
      cm1 := '/';
      cm2 := '{';
      cm3 := '(';
      cm4 := ')';
      st1 := '''';
    end
    else if FSyntaxType = stSQL then
    begin
      cm1 := '-';
      cm2 := ' ';
      cm3 := '/';
      cm4 := '/';
      st1 := '"';
    end
    else
    begin
      cm1 := ' ';
      cm2 := ' ';
      cm3 := ' ';
      cm4 := ' ';
      st1 := ' ';
    end;

    if FSyn[Pos] in ['_', 'A'..'Z', 'a'..'z'] then
    begin
      while FSyn[Pos] in ['_', 'A'..'Z', 'a'..'z', '0'..'9'] do
        Inc(Pos);
      if IsKeyWord(Copy(FSyn, i, Pos - i)) then
        Result := caKeyword;
      Dec(Pos);
    end
    else if (FSyn[Pos] = cm1) and (FSyn[Pos + 1] = cm1) then
    begin
      while (Pos <= Length(FSyn)) and not (FSyn[Pos] in [#10, #13]) do
        Inc(Pos);
      Result := caComment;
    end
    else if FSyn[Pos] = cm2 then
    begin
      while (Pos <= Length(FSyn)) and (FSyn[Pos] <> '}') do
        Inc(Pos);
      Result := caComment;
    end
    else if (FSyn[Pos] = cm3) and (FSyn[Pos + 1] = '*') then
    begin
      while (Pos < Length(FSyn)) and not ((FSyn[Pos] = '*') and (FSyn[Pos + 1] = cm4)) do
        Inc(Pos);
      Inc(Pos, 2);
      Result := caComment;
    end
    else if (FSyn[Pos] = '''') or (FSyn[Pos] = st1) then
    begin
      Inc(Pos);
      while (Pos < Length(FSyn)) and (FSyn[Pos] <> '''') and (FSyn[Pos] <> st1) and not (FSyn[Pos] in [#10, #13]) do
        Inc(Pos);
      Result := caString;
    end;
    Inc(Pos);
  end;

begin
  FSyn := GetText.Text + #0#0#0#0#0#0#0#0#0#0#0;
  FAllowLinesChange := False;
  Pos := 1;

  while Pos < Length(FSyn) do
  begin
    n := Pos;
    SkipSpaces;
    for i := n to Pos - 1 do
      if FSyn[i] > #31 then
        FSyn[i] := Chr(Ord(caText));

    n := Pos;
    ch := Chr(Ord(GetIdent));
    for i := n to Pos - 1 do
      if FSyn[i] > #31 then
        FSyn[i] := ch;
  end;
end;

end.
