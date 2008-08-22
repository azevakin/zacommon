{******************************************}
{                                          }
{             FastReport v2.5              }
{         Excel OLE export filter          }
{                                          }
{Copyright(c) 1998-2003 by FastReports Inc.}
{                                          }
{******************************************}

unit frOLEExl;

interface

{$I Fr.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, Clipbrd, Printers, ComObj, FR_Class
{$IFDEF Delphi6}
, Variants
{$ENDIF},
  FR_Progr, FR_Ctrls;

function ComparePoints(Item1, Item2: Pointer): Integer;
function CompareObjects(Item1, Item2: Pointer): Integer;

const
  Xdivider = 8;
  Ydivider = 1.3;
  XLMaxHeight = 409;

  xlLeft = -4131;
  xlRight = -4152;
  xlTop = -4160;
  xlCenter = -4108 ;
  xlBottom = -4107;
  xlJustify = -4130 ;
  xlThin = 2;
  xlHairline = 1;
  xlNone = -4142;
  xlAutomatic = -4105;
  xlInsideHorizontal = 12 ;
  xlInsideVertical = 11 ;
  xlEdgeBottom = 9 ;
  xlEdgeLeft = 7 ;
  xlEdgeRight = 10 ;
  xlEdgeTop = 8 ;
  xlSolid = 1 ;
  xlTextWindows = 20 ;
  xlNormal = -4143 ;
  xlNoChange = 1 ;
  xlPageBreakManual = -4135 ;

type

TfrOLEExcelSet = class(TForm)
  OK: TButton;
  Cancel: TButton;
    GroupPageSettings: TGroupBox;
    GroupPageRange: TGroupBox;
    LeftM: TLabel;
    Pages: TLabel;
    E_Range: TEdit;
    Descr: TLabel;
    E_LMargin: TEdit;
    TopM: TLabel;
    E_TMargin: TEdit;
    ScX: TLabel;
    E_ScaleX: TEdit;
    Label2: TLabel;
    ScY: TLabel;
    E_ScaleY: TEdit;
    Label9: TLabel;
    GroupCellProp: TGroupBox;
    CB_Merged: TCheckBox;
    CB_Align: TCheckBox;
    CB_FillColor: TCheckBox;
    CB_Borders: TCheckBox;
    CB_WrapWords: TCheckBox;
    CB_FontName: TCheckBox;
    CB_FontSize: TCheckBox;
    CB_FontStyle: TCheckBox;
    CB_FontColor: TCheckBox;
    CB_PageBreaks: TCheckBox;
    CB_OpenExcel: TCheckBox;
    Better: TButton;
    Faster: TButton;
    CB_Pictures: TCheckBox;
    procedure BetterClick(Sender: TObject);
    procedure FasterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
 private
    procedure Localize;
end;

TFrExcel = class;

TObjCell = class(TObject)
public
  Value: integer;
end;

TObjPos = class(TObject)
public
  obj: integer;
  x,y: integer;
  dx, dy: integer;
end;

TfrOLEExcelExport = class(TfrExportFilter)
  private
    CurrentPage: integer;
    FirstPage: boolean;
    CurY: integer;
    RX: TList; // TObjCell
    RY: TList; // TObjCell
    ObjectPos: TList; // TObjPos
    PageObj: TList; // TfrView
    Excel: TFrExcel;
    CY, LastY: integer;
    frExportSet: TfrOLEExcelSet;
    pgList: TStringList;
    pgBreakList: TStringList;
    PicFormat: Word;
    PicData: Cardinal;
    PicPalette: HPALETTE;
    CntPics: integer;
    expMerged, expWrapWords, expFillColor, expBorders, expAlign,
      expPageBreaks, expFontName, expFontSize, expFontStyle,
      expFontColor, expPictures, expOpenAfter: boolean;
    expScaleX, expScaleY, expTopMargin, expLeftMargin: Double;
    procedure ObjCellAdd(Vector: TList; Value: integer);
    procedure ObjPosAdd(Vector: TList; x, y, dx, dy, obj: integer);
    procedure DeleteMultiplePoint(Vector: TList);
    procedure ClearLastPage;
    procedure OrderObjectByCells;
    procedure ExportPage;
    function CleanReturns(Str: string): string;
    procedure AfterExport(const FileName: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowModal: Word; override;
    procedure OnBeginDoc; override;
    procedure OnEndDoc; override;
    procedure OnEndPage; override;
    procedure OnBeginPage; override;
    procedure OnData(x, y: Integer; View: TfrView); override;
  published
//    property ScaleX : Double read expScaleX write expScaleX default 1.0;
//    property ScaleY : Double read expScaleY write expScaleY default 1.0;
    property CellsAlign : Boolean read expAlign write expAlign default True;
    property CellsBorders : Boolean read expBorders write expBorders default True;
    property CellsFillColor : Boolean read expFillColor write expFillColor default True;
    property CellsFontColor : Boolean read expFontColor write expFontColor default True;
    property CellsFontName : Boolean read expFontName write expFontName default True;
    property CellsFontSize : Boolean read expFontSize write expFontSize default True;
    property CellsFontStyle : Boolean read expFontStyle write expFontStyle default True;
    property CellsMerged : Boolean read expMerged write expMerged default True;
    property CellsWrapWords : Boolean read expWrapWords write expWrapWords default True;
    property ExportPictures : Boolean read expPictures write expPictures default True;
    property LeftMargin : Double read expLeftMargin write expLeftMargin;
    property OpenExcelAfterExport : Boolean read expOpenAfter write expOpenAfter default False;
    property PageBreaks : Boolean read expPageBreaks write expPageBreaks default True;
    property TopMargin : Double read expTopMargin write expTopMargin;
end;

TFrExcel = class(TComponent)
private
  IsOpened: Boolean;
  IsVisible: Boolean;
  Excel: Variant;
  WorkBook: Variant;
  WorkSheet: Variant;
  Range : Variant;
protected
  procedure SetVisible(DoShow: Boolean);
  function GetCell(x, y: Integer): string;
  procedure SetCell(x, y: Integer; const Value: string);
  function Pos2Str(Pos: Integer): string;
  function IntToCoord(X, Y: Integer): string;
public
  constructor Create (AOwner: TComponent); override;
  destructor Destroy; override;
  procedure OpenExcel;
  procedure SetRange(x, y, dx, dy: integer);
  procedure SetColSize(x: integer; Size: Extended);
  procedure SetRowSize(y: integer; Size: Extended);
  procedure MergeCells;
  procedure SetPageMargin(Left, Right, Top, Bottom: Extended; Orient: integer);
  procedure SetCellFontName(FontName: string);
  procedure SetCellFontSize(FontSize: integer);
  procedure SetCellFontColor(FontColor: Integer);
  procedure SetCellFontStyle(Style: TFontStyles);
  procedure SetCellHAlign(Horiz: Integer);
  procedure SetCellVAlign(Vert: Integer);
  procedure SetCellOrientation(Grad: Integer);
  procedure SetCellFrame(Frame: integer);
  procedure SetCellFrameInsideV;
  procedure SetCellFrameInsideH;
  procedure SetCellFillColor(Color: integer);
  procedure SendArrayValue(Arr: variant);
  property Cell[x, y: Integer]: string read GetCell write SetCell;
  function IsOpen: Boolean;
published
  property Visible: Boolean read IsVisible write SetVisible;
end;

implementation

uses FR_Const, FR_Utils;

{$R *.dfm}

function ComparePoints(Item1, Item2: Pointer): Integer;
begin
  Result := TObjCell(Item1).Value - TObjCell(Item2).Value;
end;

function CompareObjects(Item1, Item2: Pointer): Integer;
var
  r: integer;
begin
  r := TfrView(Item1).y - TfrView(Item2).y;
  if r = 0 then
    r := TfrView(Item1).x - TfrView(Item2).x;
  if r = 0 then
    r :=Length(TfrView(Item1).Memo.Text) - Length(TfrView(Item2).Memo.Text);
  Result := r;
end;

constructor TfrOLEExcelExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  frRegisterExportFilter(Self, frLoadStr(frRes + 1840), '*.xls');
  RX := TList.Create;
  RY := TList.Create;
  PageObj := TList.Create;
  ObjectPos := TList.Create;
  Excel := TfrExcel.Create(nil);
  pgList := TStringList.Create;
  pgBreakList := TStringList.Create;
  ShowDialog := True;
  expMerged := True;
  expWrapWords := True;
  expFillColor := True;
  expBorders := True;
  expAlign := True;
  expPageBreaks := True;
  expFontName := True;
  expFontSize := True;
  expFontStyle := True;
  expFontColor := True;
  expPictures := True;
  expScaleX := 1.0;
  expScaleY := 1.0;
end;

destructor TfrOLEExcelExport.Destroy;
begin
  ClearLastPage;
  frUnRegisterExportFilter(Self);
  RX.Destroy;
  RY.Destroy;
  PageObj.Destroy;
  ObjectPos.Destroy;
  Excel.Destroy;
  pgList.Destroy;
  pgBreakList.Destroy;
  inherited;
end;

function TfrOLEExcelExport.CleanReturns(Str: string): string;
var
  i: integer;
begin
   i := Pos(#13, Str);
   while i > 0 do
   begin
      if i > 0 then Delete(Str, i, 1);
      i := Pos(#13, Str);
   end;
   i := Pos(#1, Str);
   while i > 0 do
   begin
      if i > 0 then Delete(Str, i, 1);
      i := Pos(#1, Str);
   end;
   while Copy(Str, Length(str), 1) = #10 do
      Delete(Str, Length(Str), 1);
   Result := Str;
end;

procedure TfrOLEExcelExport.ClearLastPage;
var
  i: integer;
begin
  for i := 0 to RX.Count - 1 do TObjCell(RX[i]).Free;
  RX.Clear;
  for i := 0 to RY.Count - 1 do TObjCell(RY[i]).Free;
  RY.Clear;
  for i := 0 to PageObj.Count - 1 do
  begin
    if TfrView(PageObj[i]) is TfrMemoView then
      TfrMemoView(PageObj[i]).Destroy
    else
    if TfrView(PageObj[i]) is TfrPictureView then
      TfrPictureView(PageObj[i]).Destroy;
  end;
  PageObj.Clear;
  for i := 0 to ObjectPos.Count - 1 do TObjPos(ObjectPos[i]).Free;
  ObjectPos.Clear;
end;

procedure TfrOLEExcelExport.ObjCellAdd(Vector: TList; Value: integer);
var
   ObjCell: TObjCell;
begin
   ObjCell := TObjCell.Create;
   ObjCell.Value := Value;
   Vector.Add(ObjCell);
end;

procedure TfrOLEExcelExport.ObjPosAdd(Vector: TList; x, y, dx, dy, obj: integer);
var
    ObjPos: TObjPos;
begin
   ObjPos := TObjPos.Create;
   ObjPos.x := x;
   ObjPos.y := y;
   ObjPos.dx := dx;
   ObjPos.dy := dy;
   ObjPos.obj := Obj;
   Vector.Add(ObjPos);
end;

procedure TfrOLEExcelExport.DeleteMultiplePoint(Vector: TList);
var
  i: integer;
  point, lpoint: TObjCell;
begin
   if Vector.Count > 0 then
   begin
    i := 0;
    lpoint := TObjCell(Vector[i]);
    inc(i);
    while i <= Vector.Count - 1 do
    begin
      point := TObjCell(Vector[i]);
      if (point.Value = lpoint.Value) then
      begin
        point.Free;
        Vector.Delete(i);
      end
      else
      begin
        lpoint := point;
        inc(i);
      end;
    end;
   end;
end;

procedure TfrOLEExcelExport.OrderObjectByCells;
var
   obj, c, fx, fy, dx, dy, m, mi, curx, cury: integer;
begin
   for obj := 0 to PageObj.Count - 1 do
   begin
     fx := 0; fy := 0;
     dx := 1; dy := 1;
     for c := 0 to RX.Count - 1 do
       if TObjCell(RX[c]).Value = TfrView(PageObj[obj]).x then
       begin
          fx := c;
          m := TfrView(PageObj[obj]).x;
          mi := c + 1;
          curx :=TfrView(PageObj[obj]).x + (TfrView(PageObj[obj]).dx - 10); //TfrView(PageObj[obj]).dx div 10
          while m < curx do
          begin
            m := m + TObjCell(RX[mi]).Value - TObjCell(RX[mi - 1]).Value;
            inc(mi);
          end;
          dx := mi - c - 1;
          break;
       end;
     for c := 0 to RY.Count - 1 do
       if TObjCell(RY[c]).Value = TfrView(PageObj[obj]).y then
       begin
          fy := c;
          m := TfrView(PageObj[obj]).y;
          mi := c + 1;
          cury := TfrView(PageObj[obj]).y + (TfrView(PageObj[obj]).dy - 10); //TfrView(PageObj[obj]).dy div 10
          while m < cury do
          begin
            m := m + TObjCell(RY[mi]).Value - TObjCell(RY[mi - 1]).Value;
            inc(mi);
          end;
          dy := mi - c - 1;
          break;
       end;
     ObjPosAdd(ObjectPos, fx, fy, dx, dy, obj);
   end;
end;

{$WARNINGS OFF}
procedure TfrOLEExcelExport.ExportPage;
var
  i, j, k, l, x, y, dx, dy : integer;
  x1, y1, dx1, dy1, olddx, olddy : integer;
  dcol, drow, delta, conv : Extended;
  s : string;
  Left, Right, Top, Bottom : Extended;
  Orient, Vert, Horiz: integer;
  m: TRect;
  obj: TfrMemoView;
  PicObj: TfrPictureView;
  ExlArray: Variant;
  TimeBegin, TimeRemain, TimeEstimate: TDateTime;
  Step: integer;
  defaultV, defaultH: integer;

  oldxFN, oldyFN: integer;
  oldFN: string;
  oldxFS, oldyFS: integer;
  oldFS: integer;
  oldxFSt, oldyFSt: integer;
  oldFSt: TFontStyles;
  oldxAH, oldyAH: integer;
  oldAH: integer;
  oldxAV, oldyAV: integer;
  oldAV: integer;
  oldxFC, oldyFC: integer;
  oldFC: integer;
  oldxFR, oldyFR: integer;
  oldFR: integer;
  oldxC, oldyC: integer;
  oldC: integer;

  procedure AlignFR2AlignExcel(Align: integer; var AlignH, AlignV: integer);
  begin
    if (Align and frtaRight) <> 0 then
         if (Align and frtaCenter) <> 0 then AlignH := xlJustify
         else AlignH := xlRight
      else if (Align and frtaCenter) <> 0 then AlignH := xlCenter
      else AlignH := xlLeft;
    if (Align and frtaMiddle) <> 0 then AlignV := xlCenter
      else if (Align and frtaDown) <> 0 then AlignV := xlBottom
      else AlignV := xlTop;
  end;

  procedure SetRegionAttrib(x1, y1, x2, y2: integer; Attr: variant; Attr2:TfontStyles; func: integer);
   var
     dx, dy: integer;
     procedure CallFunc(param: variant; param2: TfontStyles; numb: integer);
     begin
       case numb of
         1 : Excel.SetCellFontStyle(param2);
         2 : Excel.SetCellFontSize(param);
         3 : Excel.SetCellFontName(param);
         4 : Excel.SetCellHAlign(param);
         5 : Excel.SetCellVAlign(param);
         6 : Excel.SetCellFontColor(param);
         7 : begin
               Excel.SetCellFrame(param);
               if (dx > 1) and (param > 0) then
                 Excel.SetCellFrameInsideH;
               if (dy > 1) and (param > 0) then
                 Excel.SetCellFrameInsideV;
             end;
         8 : Excel.SetCellFillColor(param);
       end;
     end;
  begin
      if y2 > y1 then
      begin
        dx := RX.Count - x1; dy := 1;
        Excel.SetRange(x1, y1, dx, dy);
        CallFunc(Attr, Attr2, func);
        if y2 - y1 > 1 then
        begin
          dx := RX.Count - 1; dy := y2 - 1;
          Excel.SetRange(1, y1 + 1, dx, dy);
          CallFunc(Attr, Attr2, func);
        end;
        dx := x2 - 1; dy := 1;
        Excel.SetRange(1, y2, dx, dy);
        CallFunc(Attr, Attr2, func);
      end
      else
      begin
        dx := x2 - x1; dy := 1;
        Excel.SetRange(x1, y2, dx, dy);
        CallFunc(Attr, Attr2, func);
      end;
  end;

begin
  TimeBegin := Time;
  Step := 0;
  TimeRemain := 0;

  if CurReport.EMFPages[CurrentPage - 1].pgor = poLandscape then Orient := 2
    else Orient := 1;
  m := CurReport.EMFPages[CurrentPage - 1].pgMargins;
  Left := m.Left / 4;
  Right := m.Right / 4;
  Top := m.Top / 4;
  Bottom := m.Bottom / 4;
  Excel.SetPageMargin(Left, Right, Top, Bottom, Orient);

  i := 0;
  CurReport.Terminated := false;
  for y := 1 to RY.Count - 1 do
  begin
     frProgressForm.Label1.Caption := frLoadStr(frRes + 1865) + IntToStr(y);
     frProgressForm.Label1.Refresh;
     drow := expScaleY * (TObjCell(RY[y]).Value - TObjCell(RY[y - 1]).Value) / Ydivider;
     Excel.SetRowSize(y + cury, drow);
     if pgBreakList.Count > i then
     if (pgBreakList[i] = IntToStr(TObjCell(RY[y]).Value)) and expPageBreaks then
     begin
       Excel.WorkSheet.Rows[y + 2].PageBreak := xlPageBreakManual;
       inc(i);
     end;
  end;

  for x := 1 to RX.Count - 1 do
  begin
     frProgressForm.Label1.Caption := frLoadStr(frRes + 1866) + IntToStr(x);
     frProgressForm.Label1.Refresh;
     dcol := expScaleX*(TObjCell(RX[x]).Value - TObjCell(RX[x - 1]).Value) / Xdivider;
     Excel.SetColSize(x, dcol);
  end;

  ExlArray := VarArrayCreate([0,RY.Count - 1, 0,RX.Count - 1], varVariant);

  oldxFN := 1; oldyFN := CurY + 1;
  oldFN := '';
  oldxFC := 1; oldyFC := CurY + 1;
  oldFC := clBlack;
  oldxFS := 1; oldyFS := CurY + 1;
  oldFS := 10;
  oldxFSt := 1; oldyFSt := CurY + 1;
  oldFSt := [];
  oldxAH := 1; oldyAH := CurY + 1;
  oldAH:=xlLeft;
  oldxAV := 1; oldyAV := CurY + 1;
  oldAV := xlTop;
  oldxFR := 1; oldyFR := CurY + 1;
  oldFR := 0;
  oldxC := 1; oldyC := CurY + 1;
  oldC := clNone;

  for i := 0 to ObjectPos.Count - 1 do
  begin
    frProgressForm.Label1.Caption := frLoadStr(frRes + 1841) + IntToStr(Step) + frLoadStr(frRes + 1842) + TimeToStr(TimeRemain);
    frProgressForm.Label1.Refresh;

    x := TObjPos(ObjectPos[i]).x + 1;
    y := TObjPos(ObjectPos[i]).y + CurY + 1;
    dx := TObjPos(ObjectPos[i]).dx;
    dy := TObjPos(ObjectPos[i]).dy;
    Excel.SetRange(x, y, dx, dy);

    if TfrView(PageObj[TObjPos(ObjectPos[i]).obj]) is TfrMemoView then
    begin
        Obj := TfrMemoView(PageObj[TObjPos(ObjectPos[i]).obj]);
        s:=CleanReturns(Obj.Memo.Text);
        l:=pos('.', s);
        if l>0 then
        begin
          s[l]:=',';
{$IFDEF Delphi6}
          if TryStrToFloat(s, conv) then
            Excel.Range.Cells.NumberFormat := '@';
{$ENDIF}
        end;
        AlignFR2AlignExcel(Obj.Alignment, Horiz, Vert);
        if expBorders then
          Excel.SetCellFrame(Obj.FrameTyp);
        if expFillColor then
          if Obj.FillColor <> clNone then
            Excel.SetCellFillColor(Obj.FillColor);
        if (Obj.Alignment and $4) <>0 then
          Excel.SetCellOrientation(90);
        if expMerged then
          if (dx > 1) or (dy > 1) then  
          begin
            olddx := dx; olddy := dy;
            for j:=i+1 to ObjectPos.Count - 1 do
            begin
              x1 := TObjPos(ObjectPos[j]).x + 1;
              y1 := TObjPos(ObjectPos[j]).y + CurY + 1;
              if ((y + dy) > y1) and ((x + dx) > x1) and (x <= x1) then
              begin
                if y = y1 then
                begin
                  if (x + dx) > x1 then dx := x1 - x;
                  dy:=1
                end
                else
                  dy := y1 - y;
              end;
            end;
            if (dx > 1) or (dy > 1) then
            begin
              if (dx <> olddx) or (dy <> olddy) then
                Excel.SetRange(x, y, dx, dy);
              Excel.MergeCells;
            end;
          end;

        if (Obj.Font.Style <> OldFSt) and expFontStyle then
        begin
          SetRegionAttrib(OldxFSt, OldyFSt, x, y, 0, OldFSt, 1);
          OldxFSt := x; OldYFSt := y;
          OldFSt := Obj.Font.Style;
        end;
        if (Obj.Font.Size <> OldFS) and expFontSize then
        begin
          SetRegionAttrib(OldxFS, OldyFS, x, y, OldFS, [], 2);
          OldxFS := x; OldYFS := y;
          OldFS := Obj.Font.Size;
        end;
        if (Obj.Font.Name <> OldFN) and expFontName then
        begin
          SetRegionAttrib(OldxFN, OldyFN, x, y, OldFN, [], 3);
          OldxFN := x; OldYFN := y;
          OldFN := Obj.Font.Name;
        end;
        if expAlign then
        begin
          if Horiz <> OldAH then
          begin
            SetRegionAttrib(OldxAH, OldyAH, x, y, OldAH, [], 4);
            OldxAH := x; OldyAH := y;
            OldAH := Horiz;
          end;
          if Vert <> OldAV then
          begin
            SetRegionAttrib(OldxAV, OldyAV, x, y, OldAV, [], 5);
            OldxAV := x; OldyAV := y;
            OldAV := Vert;
          end;
        end;
        if (Obj.Font.Color <> OldFC) and expFontColor then
        begin
          SetRegionAttrib(OldxFC, OldyFC, x, y, OldFC, [], 6);
          OldxFC := x; OldYFC := y;
          OldFC := Obj.Font.Color;
        end;
        s := CleanReturns(Obj.Memo.Text);
        ExlArray[y-1-CurY, x-1] := s;
    end
    else
    if TfrView(PageObj[TObjPos(ObjectPos[i]).obj]) is TfrPictureView then
    begin
       Inc(CntPics);
       PicObj := TfrPictureView(PageObj[TObjPos(ObjectPos[i]).obj]);
{$IFDEF Delphi3}
       PicObj.Picture.SaveToClipboardFormat(PicFormat, THandle(PicData), HPALETTE(PicPalette));
{$ELSE}
       PicObj.Picture.SaveToClipboardFormat(PicFormat, PicData, PicPalette);
{$ENDIF}

       Clipboard.SetAsHandle(PicFormat,THandle(PicData));
{$IFDEF Delphi3}
       Excel.Range.PasteSpecial;
{$ELSE}
       Excel.Range.PasteSpecial(EmptyParam, EmptyParam, EmptyParam, EmptyParam);
{$ENDIF}
       Excel.WorkSheet.Pictures[CntPics].Width := PicObj.dx / 1.5;
       Excel.WorkSheet.Pictures[CntPics].Height := PicObj.dy / 1.5;
    end;

    inc(Step);
    TimeEstimate := TimeBegin + (ObjectPos.Count - 1) * (Time - TimeBegin) / Step;
    TimeRemain := TimeEstimate - Time;

    Application.ProcessMessages;

    if CurReport.Terminated then break;

  end;
  x := x + dx; y := y + dy;
  SetRegionAttrib(OldxFSt, OldyFSt, x, y, 0, OldFSt, 1);
  SetRegionAttrib(OldxFS, OldyFS, x, y, OldFS, [], 2);
  SetRegionAttrib(OldxFN, OldyFN, x, y, OldFN, [], 3);
  SetRegionAttrib(OldxAH, OldyAH, x, y, OldAH, [], 4);
  SetRegionAttrib(OldxAV, OldyAV, x, y, OldAV, [], 5);
  SetRegionAttrib(OldxFC, OldyFC, x, y, OldFC, [], 6);

  Excel.SetRange(1, CurY + 1, RX.Count - 1, RY.Count - 1);
  Excel.Range.Value := ExlArray;
  CurY := Y - 1;
end;
{$WARNINGS ON}

function TfrOLEExcelExport.ShowModal: Word;

var
  PageNumbers: string;

  procedure ParsePageNumbers;
  var
    i, j, n1, n2: Integer;
    s: String;
    IsRange: Boolean;
  begin
    s := PageNumbers;
    while Pos(' ', s) <> 0 do
      Delete(s, Pos(' ', s), 1);
    if s = '' then Exit;
    s := s + ',';
    i := 1; j := 1; n1 := 1;
    IsRange := False;
    while i <= Length(s) do
    begin
      if s[i] = ',' then
      begin
        n2 := StrToInt(Copy(s, j, i - j));
        j := i + 1;
        if IsRange then
          while n1 <= n2 do
          begin
            pgList.Add(IntToStr(n1));
            Inc(n1);
          end
        else
          pgList.Add(IntToStr(n2));
        IsRange := False;
      end
      else if s[i] = '-' then
      begin
        IsRange := True;
        n1 := StrToInt(Copy(s, j, i - j));
        j := i + 1;
      end;
      Inc(i);
    end;
  end;

begin
 if ShowDialog then
 begin
  frExportSet := TfrOLEExcelSet.Create(nil);
  frExportSet.CB_Merged.Checked := expMerged;
  frExportSet.CB_WrapWords.Checked := expWrapWords;
  frExportSet.CB_FillColor.Checked := expFillColor;
  frExportSet.CB_Borders.Checked := expBorders;
  frExportSet.CB_Align.Checked := expAlign;
  frExportSet.CB_PageBreaks.Checked := expPageBreaks;
  frExportSet.CB_FontName.Checked := expFontName;
  frExportSet.CB_FontSize.Checked := expFontSize;
  frExportSet.CB_FontStyle.Checked := expFontStyle;
  frExportSet.CB_FontColor.Checked := expFontColor;
  frExportSet.CB_Pictures.Checked := expPictures;
  frExportSet.CB_OpenExcel.Checked := expOpenAfter;
  frExportSet.E_ScaleX.Text := FloatToStr(Int(expScaleX*100));
  frExportSet.E_ScaleY.Text := FloatToStr(Int(expScaleY*100));
  frExportSet.E_TMargin.Text := FloatToStr(expTopMargin);
  frExportSet.E_LMargin.Text := FloatToStr(expLeftMargin);
  Result := frExportSet.ShowModal;
  PageNumbers := frExportSet.E_Range.Text;
  expMerged := frExportSet.CB_Merged.Checked;
  expWrapWords := frExportSet.CB_WrapWords.Checked;
  expFillColor := frExportSet.CB_FillColor.Checked;
  expBorders := frExportSet.CB_Borders.Checked;
  expAlign := frExportSet.CB_Align.Checked;
  expPageBreaks := frExportSet.CB_PageBreaks.Checked;
  expFontName := frExportSet.CB_FontName.Checked;
  expFontSize := frExportSet.CB_FontSize.Checked;
  expFontStyle := frExportSet.CB_FontStyle.Checked;
  expFontColor := frExportSet.CB_FontColor.Checked;
  expPictures := frExportSet.CB_Pictures.Checked;
  expOpenAfter := frExportSet.CB_OpenExcel.Checked;
  expScaleX := StrToInt(frExportSet.E_ScaleX.Text) / 100;
  expScaleY := StrToInt(frExportSet.E_ScaleY.Text) / 100;
  expTopMargin := StrToFloat(frExportSet.E_TMargin.Text);
  expLeftMargin := StrToFloat(frExportSet.E_LMargin.Text);
  frExportSet.Destroy;
 end
 else
   Result := mrOk;
 pgList.Clear;
 pgBreakList.Clear;
 ParsePageNumbers;
end;

procedure TfrOLEExcelExport.OnBeginDoc;
begin
  OnAfterExport := AfterExport;
  Excel.OpenExcel;
  CurrentPage := 0;
  CurY := 0;
  FirstPage := true;
  ClearLastPage;
  CY := 0;
  lastY := 0;
  CntPics := 0;
end;

procedure TfrOLEExcelExport.OnBeginPage;
begin
  Inc(CurrentPage);
end;

procedure TfrOLEExcelExport.OnData(x, y: Integer; View: TfrView);
var
    MemoView : TfrMemoView;
    PicView : TfrPictureView;
    ind, maxy, j, k, dy : integer;
    delta : Extended;
    bit : TBitmap;
begin
  ind := 0;
  if (pgList.Find(IntToStr(CurrentPage),ind)) or (pgList.Count = 0) then
  begin
      if View is TfrMemoView then
      begin
        if (TfrMemoView(View).Memo.Count > 0) or (TfrMemoView(View).FrameTyp > 0) then
        begin
          MemoView := TfrMemoView.Create;
          MemoView.Assign(View);
          MemoView.y := MemoView.y + CY;
          PageObj.Add(MemoView);
        end;
      end
      else
      begin
          PicView := TfrPictureView.Create;
          PicView.x := View.x;
          PicView.y := View.y;
          PicView.dx := View.dx;
          PicView.dy := View.dy;
          bit := TBitmap.Create;
          bit.Height := View.dy+1;
          bit.Width := View.dx+1;
          View.x := 0;
          View.y := 0;
          View.Draw(bit.Canvas);
          View.x := PicView.x;
          View.y := PicView.y;
          PicView.Picture.Bitmap.Assign(bit);
          bit.Destroy;
          PicView.y := PicView.y + CY;
          PageObj.Add(PicView);
      end;
      ObjCellAdd(RX, View.x);
      ObjCellAdd(RX, View.x + View.dx);
      ObjCellAdd(RY, View.y + CY);
      ObjCellAdd(RY, View.y + View.dy + CY);

      // Excel capability code
      if (View.y + CY) > lastY then
      begin
        delta := expScaleY * (View.y + CY - LastY) / Ydivider;
        if delta > XLMaxHeight then
        begin
          k := Trunc (delta / XLMaxHeight);
          dy :=  Trunc (XLMaxHeight * Ydivider / expScaleY);
          for j := 1 to k do
            ObjCellAdd(RY, LastY + dy * k);
        end;
      end;

      maxy := View.y + View.dy + CY;
      if maxy > LastY then
        LastY := maxy;
  end;
end;

procedure TfrOLEExcelExport.OnEndPage;
var
    ind: integer;
begin
  CY := LastY;
  ind := 0;
  if (pgList.Find(IntToStr(CurrentPage),ind)) or (pgList.Count = 0) then
    pgBreakList.Add(IntToStr(LastY));
end;

procedure TfrOLEExcelExport.OnEndDoc;
begin
//
end;

procedure TfrOLEExcelExport.AfterExport(const FileName: string);
begin
  RX.Sort(@ComparePoints);
  RY.Sort(@ComparePoints);
  DeleteMultiplePoint(RX);
  DeleteMultiplePoint(RY);
  PageObj.Sort(@CompareObjects);
  OrderObjectByCells;

  frProgressForm.Show;
  frProgressForm.Label1.Caption := frLoadStr(frRes + 1843);
  frProgressForm.Refresh;

  ExportPage;

  Excel.SetRange(1, 1, 1, 1);
  Excel.Range.Select;

  frProgressForm.Close;
  if expOpenAfter then
    Excel.Visible := true;
  try
   DeleteFile(FileName);
{$IFDEF Delphi3}
   Excel.WorkBook.SaveAs(FileName,xlNormal);
{$ELSE}
   Excel.WorkBook.SaveAs(FileName,xlNormal, EmptyParam,
     EmptyParam, EmptyParam, EmptyParam, xlNoChange, EmptyParam, EmptyParam, EmptyParam);
{$ENDIF}
  except
  end;
end;

///////////////////////////////////////////////////////////
constructor TFrExcel.Create (AOwner : TComponent);
begin
  inherited Create(AOwner);
  IsOpened := false;
  IsVisible := false;
end;

destructor TFrExcel.Destroy;
begin
  if IsOpened then
   try
    Excel.Quit;
   except
   end;
  Excel := Unassigned;
  inherited Destroy;
end;

function TfrExcel.Pos2Str(Pos: Integer): String;
var
  i, j: integer;
begin
    if Pos > 26 then
    begin
      i := Pos mod 26; j := Pos div 26;
      if i = 0 then Result := Chr(64 + j - 1)
        else Result := Chr(64 + j);
      if i = 0 then Result := Result + chr(90)
        else result := Result + Chr(64 + i);
    end
    else Result := Chr(64 + Pos);
end;

procedure TFrExcel.SetVisible(DoShow: Boolean);
begin
  if not IsOpened then exit;
  if DoShow then
  begin
    Excel.Application.Interactive := true;
    Excel.Application.ScreenUpdating := true;
    Excel.Application.DisplayAlerts := true;
    Excel.Visible := True
  end
  else
    Excel.Visible := false;
end;

function TFrExcel.IntToCoord(X, Y: Integer): string;
begin
  Result := Pos2Str(X) + IntToStr(Y);
end;

function TFrExcel.GetCell(x, y: Integer): string;
begin
  result := WorkSheet.Cells[y, x];
end;

procedure TFrExcel.SetCell(x, y: Integer; const Value: string);
var
  Cell: Variant;
begin
  Cell := WorkSheet.Cells[y, x];
  Cell.Value := Value;
end;

procedure TFrExcel.SetColSize(x: Integer; Size: Extended);
var
  r: variant;
begin
  r := WorkSheet.Columns;
  r.Columns[x].ColumnWidth := Size;
end;

procedure TFrExcel.SetRowSize(y: Integer; Size: Extended);
var
  r: variant;
begin
  r := WorkSheet.Rows;
  if size > 409 then size := 409;
  r.Rows[y].RowHeight := Size;
end;

procedure TFrExcel.MergeCells;
begin
  Range.MergeCells := true;
end;

procedure TFrExcel.OpenExcel;
begin
    try
      Excel := CreateOLEObject('Excel.Application'); //GetActiveOLEObject('Excel.Application')
      Excel.Application.EnableEvents := false;
      Excel.Application.EnableAutoComplete := false;
      Excel.Application.EnableAnimations := false;
      Excel.Application.ScreenUpdating := false;
      Excel.Application.Interactive := False;
      Excel.Application.DisplayAlerts := False;
      WorkBook := Excel.WorkBooks.Add;
      WorkSheet := WorkBook.WorkSheets[1];
      WorkSheet.Cells.WrapText := true;
      IsOpened := True;
    except
      IsOpened := false;
    end;
end;

function TFrExcel.IsOpen: Boolean;
begin
  result := IsOpened;
end;

procedure TFrExcel.SetPageMargin(Left, Right, Top, Bottom: Extended; Orient : Integer);
begin
    try
      Excel.ActiveSheet.PageSetup.LeftMargin := Left;
      Excel.ActiveSheet.PageSetup.RightMargin := Right;
      Excel.ActiveSheet.PageSetup.TopMargin := Top;
      Excel.ActiveSheet.PageSetup.BottomMargin := Bottom;
      Worksheet.PageSetup.Orientation := Orient;
    except
    end;
end;

procedure TFrExcel.SetCellFontName(FontName: string);
begin
  if length(FontName) > 0 then
    Range.Cells.Font.Name := FontName;
end;

procedure TFrExcel.SetCellFontSize(FontSize: integer);
begin
  Range.Cells.Font.Size := FontSize;
end;

procedure TFrExcel.SetCellFontColor(FontColor: integer);
begin
  Range.Cells.Font.Color:= FontColor;
end;

procedure TFrExcel.SetCellFontStyle(Style: TFontStyles);
begin
  Range.Cells.Font.Bold := fsBold in Style;
  Range.Cells.Font.Italic := fsItalic in Style;
  Range.Cells.Font.Underline := fsUnderline in Style;;
end;

procedure TFrExcel.SetCellVAlign(Vert: Integer);
begin
  Range.Select;
  Excel.Selection.Rows.VerticalAlignment := Vert;
end;

procedure TFrExcel.SetCellHAlign(Horiz: Integer);
begin
  Range.Select;
  Excel.Selection.Columns.HorizontalAlignment := Horiz;
end;

procedure TFrExcel.SetCellOrientation(Grad: Integer);
begin
  Range.Cells.Orientation := Grad;
end;

procedure TFrExcel.SetRange(x, y, dx, dy: Integer);
begin
 if (dx > 0) and (dy > 0) then
  Range := WorkSheet.Range[IntToCoord(x, y), IntToCoord(x + dx - 1, y + dy - 1)];
end;

procedure TfrExcel.SetCellFrame(Frame: integer);
begin
  if (Frame and frftLeft) <> 0 then
     Range.Cells.Borders.Item[xlEdgeLeft].Linestyle := xlSolid;
  if (Frame and frftRight) <> 0 then
     Range.Cells.Borders.Item[xlEdgeRight].Linestyle := xlSolid;
  if (Frame and frftTop) <> 0 then
     Range.Borders.Item[xlEdgeTop].Linestyle := xlSolid;
  if (Frame and frftBottom) <> 0 then
     Range.Borders.Item[xlEdgeBottom].Linestyle := xlSolid;
end;

procedure TfrExcel.SetCellFrameInsideH;
begin
  Range.Cells.Borders.Item[xlInsideVertical].Linestyle := xlSolid;
end;
procedure TfrExcel.SetCellFrameInsideV;
begin
  Range.Cells.Borders.Item[xlInsideHorizontal].Linestyle := xlSolid;
end;

procedure TfrExcel.SetCellFillColor(Color: integer);
begin
   Range.Interior.Color := Color;
end;

procedure TfrExcel.SendArrayValue(Arr: variant);
begin
    Range.Value:=Arr;
end;

//////////////////////////////////////////////

procedure TfrOLEExcelSet.Localize;
begin
  Ok.Caption := frLoadStr(SOk);
  Cancel.Caption := frLoadStr(SCancel);
  GroupPageRange.Caption := frLoadStr(frRes + 44);
  Pages.Caption := frLoadStr(frRes + 47);
  Descr.Caption := frLoadStr(frRes + 48);
  Caption := frLoadStr(frRes + 1844);
  GroupPageSettings.Caption := frLoadStr(frRes + 1845);
  Topm.Caption := frLoadStr(frRes + 1846);
  Leftm.Caption := frLoadStr(frRes + 1847);
  ScX.Caption := frLoadStr(frRes + 1848);
  ScY.Caption := frLoadStr(frRes + 1849);
  GroupCellProp.Caption := frLoadStr(frRes + 1850);
  CB_Merged.Caption := frLoadStr(frRes + 1851);
  CB_Align.Caption := frLoadStr(frRes + 1852);
  CB_FillColor.Caption := frLoadStr(frRes + 1853);
  CB_Borders.Caption := frLoadStr(frRes + 1854);
  CB_WrapWords.Caption := frLoadStr(frRes + 1855);
  CB_FontName.Caption := frLoadStr(frRes + 1856);
  CB_FontSize.Caption := frLoadStr(frRes + 1857);
  CB_FontStyle.Caption := frLoadStr(frRes + 1858);
  CB_FontColor.Caption := frLoadStr(frRes + 1859);
  CB_PageBreaks.Caption := frLoadStr(frRes + 1860);
  Better.Caption := frLoadStr(frRes + 1861);
  Faster.Caption := frLoadStr(frRes + 1862);
  CB_Pictures.Caption := frLoadStr(frRes + 1863);
  CB_OpenExcel.Caption := frLoadStr(frRes + 1864);
end;

procedure TfrOLEExcelSet.BetterClick(Sender: TObject);
begin
   CB_Merged.Checked := true;
   CB_WrapWords.Checked := true;
   CB_FillColor.Checked := true;
   CB_Borders.Checked := true;
   CB_Align.Checked := true;
   CB_PageBreaks.Checked := true;
   CB_FontName.Checked := true;
   CB_FontSize.Checked := true;
   CB_FontStyle.Checked := true;
   CB_FontColor.Checked := true;
   CB_Pictures.Checked := true;
end;

procedure TfrOLEExcelSet.FasterClick(Sender: TObject);
begin
   CB_Merged.Checked := true;
   CB_WrapWords.Checked := true;
   CB_FillColor.Checked := false;
   CB_Borders.Checked := false;
   CB_Align.Checked := false;
   CB_PageBreaks.Checked := true;
   CB_FontName.Checked := false;
   CB_FontSize.Checked := false;
   CB_FontStyle.Checked := false;
   CB_FontColor.Checked := false;
   CB_Pictures.Checked := false;
end;

procedure TfrOLEExcelSet.FormCreate(Sender: TObject);
begin
   Localize;
end;

end.
