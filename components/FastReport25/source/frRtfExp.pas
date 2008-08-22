{******************************************}
{                                          }
{             FastReport v2.5              }
{          Adv. RTF export filter          }
{                                          }
{Copyright(c) 1998-2003 by FastReports Inc.}
{                                          }
{******************************************}

unit frRtfExp;

interface

{$I Fr.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, Clipbrd, Printers, FR_Class
{$IFDEF Delphi6}
, Variants
{$ENDIF},
  FR_Progr, FR_Ctrls;

function ComparePoints(Item1, Item2: Pointer): Integer;
function CompareObjects(Item1, Item2: Pointer): Integer;

const
  Xdivider = 8;
  Ydivider = 1.3;

type
TfrRtfExpSet = class(TForm)
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
    CB_PageBreaks: TCheckBox;
    CB_Pictures: TCheckBox;
    procedure FormCreate(Sender: TObject);
 private
    procedure Localize;
end;


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

TfrRtfAdvExport = class(TfrExportFilter)
  private
    CurrentPage: integer;
    FirstPage: boolean;
    CurY: integer;
    RX: TList; // TObjCell
    RY: TList; // TObjCell
    ObjectPos: TList; // TObjPos
    PageObj: TList; // TfrView
    TempStream  : TStream;
    FontTable, ColorTable: TStringList;
    DataList    : TList;
    CY, LastY: integer;
    frExportSet: TfrRtfExpSet;
    pgList: TStringList;
    pgBreakList: TStringList;
    CntPics: integer;
    NewPage : boolean;
    expPageBreaks, expPictures: boolean;
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
    property ExportPictures : Boolean read expPictures write expPictures default True;
    property LeftMargin : Double read expLeftMargin write expLeftMargin;
    property PageBreaks : Boolean read expPageBreaks write expPageBreaks default True;
    property TopMargin : Double read expTopMargin write expTopMargin;
end;


implementation

uses FR_Const, FR_Utils, FR_Rich
{$IFDEF Delphi6}
, StrUtils
{$ENDIF};

{$R *.dfm}

const TemplateStr = '{\rtf1\ansi' + #13#10 + '\paperw%d\paperh%d\margl%d\margr%d\margt%d\margb%d';

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

constructor TfrRtfAdvExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  frRegisterExportFilter(Self, frLoadStr(frRes + 1870), '*.rtf');
  RX := TList.Create;
  RY := TList.Create;
  PageObj := TList.Create;
  ObjectPos := TList.Create;
  pgList := TStringList.Create;
  pgBreakList := TStringList.Create;
  ShowDialog := True;
  expPageBreaks := True;
  expPictures := True;
  expScaleX := 1.0;
  expScaleY := 1.0;
end;

destructor TfrRtfAdvExport.Destroy;
begin
  ClearLastPage;
  frUnRegisterExportFilter(Self);
  RX.Destroy;
  RY.Destroy;
  PageObj.Destroy;
  ObjectPos.Destroy;
  pgList.Destroy;
  pgBreakList.Destroy;
  inherited;
end;

function TfrRtfAdvExport.CleanReturns(Str: string): string;
var
  i: integer;
begin
{   i := Pos(#13, Str);
   while i > 0 do
   begin
      if i > 0 then
      begin
        Delete(Str, i, 1);
        Insert(#13#10, Str, i);
      end;
      i := Pos(#13, Str);
   end;}
   i := Pos(#1, Str);
   while i > 0 do
   begin
      if i > 0 then Delete(Str, i, 1);
      i := Pos(#1, Str);
   end;
   Result := Str;
end;

procedure TfrRtfAdvExport.ClearLastPage;
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

procedure TfrRtfAdvExport.ObjCellAdd(Vector: TList; Value: integer);
var
   ObjCell: TObjCell;
begin
   ObjCell := TObjCell.Create;
   ObjCell.Value := Value;
   Vector.Add(ObjCell);
end;

procedure TfrRtfAdvExport.ObjPosAdd(Vector: TList; x, y, dx, dy, obj: integer);
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

procedure TfrRtfAdvExport.DeleteMultiplePoint(Vector: TList);
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

procedure TfrRtfAdvExport.OrderObjectByCells;
var
   obj, c, fx, fy, dx, dy, m, mi: integer;
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
          while m < TfrView(PageObj[obj]).x + TfrView(PageObj[obj]).dx do
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
          while m < TfrView(PageObj[obj]).y + TfrView(PageObj[obj]).dy do
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

function TfrRtfAdvExport.ShowModal: Word;

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
  frExportSet := TfrRtfExpSet.Create(nil);
  frExportSet.E_ScaleX.Text := FloatToStr(Int(expScaleX*100));
  frExportSet.E_ScaleY.Text := FloatToStr(Int(expScaleY*100));
  frExportSet.E_TMargin.Text := FloatToStr(expTopMargin);
  frExportSet.E_LMargin.Text := FloatToStr(expLeftMargin);
  frExportSet.CB_Pictures.Checked := expPictures;
  Result := frExportSet.ShowModal;
  PageNumbers := frExportSet.E_Range.Text;
  expScaleX := StrToInt(frExportSet.E_ScaleX.Text) / 100;
  expScaleY := StrToInt(frExportSet.E_ScaleY.Text) / 100;
  expTopMargin := StrToFloat(frExportSet.E_TMargin.Text);
  expLeftMargin := StrToFloat(frExportSet.E_LMargin.Text);
  expPictures := frExportSet.CB_Pictures.Checked;
  frExportSet.Destroy;
 end
 else
   Result := mrOk;
 pgList.Clear;
 pgBreakList.Clear;
 ParsePageNumbers;
end;

procedure TfrRtfAdvExport.ExportPage;
var
  i, j, n, n1, x, y, dx, dy: Integer;
  s0, s, s1, s2: String;
  Str: TStream;
  bArr: Array[0..1023] of Byte;
  obj: TfrMemoView;
  objR : TfrRichView;

  function GetFontStyle(f: TFontStyles): String;
  begin
    Result := '';
    if f = [fsItalic] then Result := '\i';
    if f = [fsBold] then Result := Result + '\b';
    if f = [fsUnderline] then Result := Result + '\ul';
  end;

  function GetFontColor(f: String): String;
  var
    i: Integer;
  begin
    i := ColorTable.IndexOf(f);
    if i <> -1 then
      Result := IntToStr(i + 1)
    else
    begin
      ColorTable.Add(f);
      Result := IntToStr(ColorTable.Count);
    end;
  end;

  function GetFontName(f: String): String;
  var
    i: Integer;
  begin
    i := FontTable.IndexOf(f);
    if i <> -1 then
      Result := IntToStr(i)
    else
    begin
      FontTable.Add(f);
      Result := IntToStr(FontTable.Count - 1);
    end;
  end;

  function GetRtfAlignment(Alignment : Integer) : String;
  begin
    Result:='';
    if (Alignment and frtaLeft    )<>0 then Result:=Result+'\ql';
    if (Alignment and frtaRight   )<>0 then Result:=Result+'\qr';
    if (Alignment and frtaCenter  )<>0 then Result:=Result+'\qc';
    if (Alignment and frtaVertical)<>0 then Result:=Result+'\clvertalt';
    if (Alignment and frtaMiddle  )<>0 then Result:=Result+'\clvertalc';
    if (Alignment and frtaDown    )<>0 then Result:=Result+'\clvertalb';
    if Result='' then Result:='\ql';
  end;

begin
  if NewPage and PageBreaks then
  begin
    s := '\page' + #13#10;
    TempStream.Write(s[1], Length(s));
  end;
  if CurPage.pgOr = poLandscape then
  begin
    s := '\lndscpsxn ' + #13#10;
    TempStream.Write(s[1], Length(s));
  end;
 if expPictures then
    for i := 0 to DataList.Count - 1 do
    begin
      Str := TStream(DataList[i]);
      Str.Position := 0;
      Str.Read(x, 4);
      Str.Read(y, 4);
      Str.Read(dx, 4);
      Str.Read(dy, 4);
      s := '\pard\phmrg\posx' + FloatToStr(Round(x / (1 / expScaleX) * 15.05)) +
           '\posy' + FloatToStr(Round(y * 15.05 / 1)) +
           '\absh' + FloatToStr(Round(dy * 15.05)) +
           '\absw' + FloatToStr(Round(dx * 15.05)) +
           '{\pict\wmetafile8\picw' + FloatToStr(Round(dx * 26.46875)) +
           '\pich' + FloatToStr(Round(dy * 26.46875)) + ' \picbmp\picbpp4' + #13#10;
      TempStream.Write(s[1], Length(s));
      Str.Read(dx, 4);
      Str.Read(dy, 4);
      Str.Read(n, 2);
      Str.Read(n, 4);
      n := n div 2 + 7;
      s0 := IntToHex(n + $24, 8);
      s := '010009000003' + Copy(s0, 7, 2) + Copy(s0, 5, 2) +
           Copy(s0, 3, 2) + Copy(s0, 1, 2) + '0000';
      s0 := IntToHex(n, 8);
      s1 := Copy(s0, 7, 2) + Copy(s0, 5, 2) + Copy(s0, 3, 2) + Copy(s0, 1, 2);
      s := s + s1 + '0000050000000b0200000000050000000c02';
      s0 := IntToHex(dy, 4);
      s := s + Copy(s0, 3, 2) + Copy(s0, 1, 2);
      s0 := IntToHex(dx, 4);
      s := s + Copy(s0, 3, 2) + Copy(s0, 1, 2) +
           '05000000090200000000050000000102ffffff000400000007010300' + s1 +
           '430f2000cc000000';
      s0 := IntToHex(dy, 4);
      s := s + Copy(s0, 3, 2) + Copy(s0, 1, 2);
      s0 := IntToHex(dx, 4);
      s := s + Copy(s0, 3, 2) + Copy(s0, 1, 2) + '00000000';
      s0 := IntToHex(dy, 4);
      s := s + Copy(s0, 3, 2) + Copy(s0, 1, 2);
      s0 := IntToHex(dx, 4);
      s := s + Copy(s0, 3, 2) + Copy(s0, 1, 2) + '00000000' + #13#10;
      TempStream.Write(s[1], Length(s));
      Str.Read(bArr[0], 8);
      n1 := 0; s := '';
      repeat
        n := Str.Read(bArr[0], 1024);
        for j := 0 to n - 1 do
        begin
          s := s + IntToHex(bArr[j], 2);
          Inc(n1);
          if n1 > 63 then
          begin
            n1 := 0;
            s := s + #13#10;
            TempStream.Write(s[1], Length(s));
            s := '';
          end;
        end;
      until n < 1024;
      Str.Free;
      if n1 <> 0 then
        TempStream.Write(s[1], Length(s));
      s := '030000000000}\par' + #13#10;
      TempStream.Write(s[1], Length(s));
    end;
    s := '\margtsxn0 ' + #13#10;
    TempStream.Write(s[1], Length(s));
    s :='\par ';
    TempStream.Write(s[1], Length(s));
    for i:=0  to PageObj.Count-1 do
    begin
      if TfrView(PageObj[i]) is TfrMemoView then
      begin
        Obj := TfrMemoView(PageObj[i]);
        x := Round(Obj.x / (1 / expScaleX) * 15.05);
        y := Round(Obj.y / (1 / expScaleY) * 15.05);
        dx := Round(Obj.dx / (1 / expScaleX) * 15.05);
        dy := Round(Obj.dy / (1 / expScaleY) * 15.05);
        s := '\trowd\posx'+IntToStr(x);
        s := s + '\posy'+IntToStr(y);
        s := s +'\absw'+IntToStr(dx);
        s := s +'\absh'+IntToStr(dy);
        s := s +'\trgaph5\trrh'+IntToStr(dy);
        s2 := CleanReturns(Obj.Memo.Text);
        if Obj.Font.Color = clWhite then
          Obj.Font.Color := clBlack;
        s1 := '\f' + GetFontName(Obj.Font.Name);
        s1 := s1 + '\fs' + IntToStr(Obj.Font.Size * 2);
        s1 := s1 + GetFontStyle(obj.Font.Style);
        s1 := s1 + '\cf' + GetFontColor(IntToStr(obj.Font.Color));
        s0 := '';
        If (obj.FillColor mod 16777216) <> clWhite then
          s0 := s0+'\clcbpat' + GetFontColor(IntToStr(Obj.FillColor));
        if (Obj.FrameTyp and frftLeft) <> 0 then
          s0:=s0+'\clbrdrl\brdrw15\brdrs';
        if (Obj.FrameTyp and frftRight) <> 0 then
          s0:=s0+'\clbrdrr\brdrw15\brdrs';
        if (Obj.FrameTyp and frftTop) <> 0 then
          s0:=s0+'\clbrdrt\brdrw15\brdrs';
        if (Obj.FrameTyp and frftBottom) <> 0 then
          s0:=s0+'\clbrdrb\brdrw15\brdrs';
        s := s + s0 + '\cellx' + IntToStr(dx) + GetRtfAlignment(obj.Alignment) + '{' + s1  + ' ' + s2 + '}\cell\pard\intbl\intbl\row\pard';
        TempStream.Write(s[1], Length(s));
      end
      else
      if TfrView(PageObj[i]) is TfrRichView then
      begin
        ObjR := TfrRichView(PageObj[i]);
        x := Round(ObjR.x / (1 / expScaleX) * 15.05);
        y := Round(ObjR.y / (1 / expScaleY) * 15.05);
        dx := Round(ObjR.dx / (1 / expScaleX) * 15.05);
        dy := Round(ObjR.dy / (1 / expScaleY) * 15.05);
        s := '\trowd\posx'+IntToStr(x);
        s := s + '\posy'+IntToStr(y);
        s := s +'\absw'+IntToStr(dx);
        s := s +'\absh'+IntToStr(dy);
        s := s +'\trgaph5\trrh'+IntToStr(dy);
        s0 := '';
        if (ObjR.FrameTyp and frftLeft) <> 0 then
          s0:=s0+'\clbrdrl\brdrw15\brdrs';
        if (ObjR.FrameTyp and frftRight) <> 0 then
          s0:=s0+'\clbrdrr\brdrw15\brdrs';
        if (ObjR.FrameTyp and frftTop) <> 0 then
          s0:=s0+'\clbrdrt\brdrw15\brdrs';
        if (ObjR.FrameTyp and frftBottom) <> 0 then
          s0:=s0+'\clbrdrb\brdrw15\brdrs';
        s := s + s0 + '\cellx' + IntToStr(dx)+ '{';
        TempStream.Write(s[1], Length(s));
        ObjR.RichEdit.PlainText :=  true;
        ObjR.RichEdit.Lines.SaveToStream(TempStream);
        s := '}\cell\pard\intbl\intbl\row\pard';
        TempStream.Write(s[1], Length(s));
      end;
    end;
  s := '\pard' + #13#10;
  TempStream.Write(s[1], Length(s));
  NewPage := True;
  DataList.Clear;
end;

procedure TfrRtfAdvExport.OnBeginDoc;
var
  buf : string;
begin
  NewPage := False;
  OnAfterExport := AfterExport;
  FontTable := TStringList.Create;
  ColorTable := TStringList.Create;
  DataList := TList.Create;
  TempStream := TMemoryStream.Create;
  buf := Format(TemplateStr, [Round(CurPage.pgWidth * 5.67), Round(CurPage.pgHeight * 5.67),
                              0,0,600,600]) + #13#10;
  Stream.Write(buf[1], Length(buf));
  CurrentPage := 0;
  CurY := 0;
  FirstPage := true;
  ClearLastPage;
  CY := 0;
  lastY := 0;
  CntPics := 0;
end;

procedure TfrRtfAdvExport.OnBeginPage;
begin
  Inc(CurrentPage);
  ObjCellAdd(RX, 0);
  ObjCellAdd(RY, 0);
end;

procedure TfrRtfAdvExport.OnData(x, y: Integer; View: TfrView);
var
    MemoView : TfrMemoView;
    RichView : TfrRichView;
    PicView : TfrPictureView;
    ind : integer;
    bit : TBitmap;
    Str: TStream;
    n: Integer;
    Graphic: TGraphic;

begin
  ind := 0;
  CY := 0;
  if (pgList.Find(IntToStr(CurrentPage),ind)) or (pgList.Count = 0) then
  begin
      if View is TfrMemoView then
      begin
        if (TfrMemoView(View).Memo.Count > 0) or (TfrMemoView(View).FrameTyp > 0) then
        begin
          MemoView := TfrMemoView.Create;
          MemoView.Assign(View);
          PageObj.Add(MemoView);
          ObjCellAdd(RX, View.x);
          ObjCellAdd(RX, View.x + View.dx);
          ObjCellAdd(RY, View.y + CY);
          ObjCellAdd(RY, View.y + View.dy + CY);
        end;
      end
      else
      if View is TfrRichView then
      begin
          RichView := TfrRichView.Create;
          RichView.Assign(View);
          PageObj.Add(RichView);
          ObjCellAdd(RX, View.x);
          ObjCellAdd(RX, View.x + View.dx);
          ObjCellAdd(RY, View.y + CY);
          ObjCellAdd(RY, View.y + View.dy + CY);
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
        Graphic := TfrPictureView(PicView).Picture.Graphic;
        if not ((Graphic = nil) or Graphic.Empty) then
        begin
          Str := TMemoryStream.Create;
          Str.Write(x, 4);
          Str.Write(y, 4);
          Str.Write(View.dx, 4);
          Str.Write(View.dy, 4);
          n := Graphic.Width;
          Str.Write(n, 4);
          n := Graphic.Height;
          Str.Write(n, 4);
          Graphic.SaveToStream(Str);
          DataList.Add(Str);
        end;
        PicView.Free;
      end;
   end;
end;

procedure TfrRtfAdvExport.OnEndPage;
var
  ind: integer;
begin
  CY := LastY;
  ind := 0;
  RX.Sort(@ComparePoints);
  RY.Sort(@ComparePoints);
  DeleteMultiplePoint(RX);
  DeleteMultiplePoint(RY);
  PageObj.Sort(@CompareObjects);
  OrderObjectByCells;
  if (pgList.Find(IntToStr(CurrentPage),ind)) or (pgList.Count = 0) then
    ExportPage;
  ClearLastPage;
end;

procedure TfrRtfAdvExport.OnEndDoc;
var
  i, c: Integer;
  s, s1: String;
begin
  s := '\par}';
  TempStream.Write(s[1], Length(s));
  s := '{\fonttbl';
  for i := 0 to FontTable.Count - 1 do begin
    s1 := '{\f' + IntToStr(i) + ' ' + FontTable[i] + '}';
    if Length(s + s1) < 255 then
      s := s + s1
    else begin
      s := s + #13#10;
      Stream.Write(s[1], Length(s));
      s := s1;
    end;
  end;
  s := s + '}' + #13#10;
  Stream.Write(s[1], Length(s));
  s := '{\colortbl;';
  for i := 0 to ColorTable.Count - 1 do begin
    c := StrToInt(ColorTable[i]);
    s1 := '\red' + IntToStr(GetRValue(c)) +
          '\green' + IntToStr(GetGValue(c)) +
          '\blue' + IntToStr(GetBValue(c)) + ';';
    if Length(s + s1) < 255 then
      s := s + s1
    else begin
      s := s + #13#10;
      Stream.Write(s[1], Length(s));
      s := s1;
    end;
  end;
  s := s + '}' + #13#10;
  Stream.Write(s[1], Length(s));
  Stream.CopyFrom(TempStream, 0);
  TempStream.Free;
  FontTable.Free;
  ColorTable.Free;
  DataList.Free;
end;

procedure TfrRtfAdvExport.AfterExport(const FileName: string);
begin

end;

procedure TfrRtfExpSet.Localize;
begin
  Ok.Caption := frLoadStr(SOk);
  Cancel.Caption := frLoadStr(SCancel);
  GroupPageRange.Caption := frLoadStr(frRes + 44);
  Pages.Caption := frLoadStr(frRes + 47);
  Descr.Caption := frLoadStr(frRes + 48);
  Caption := frLoadStr(frRes + 1871);
  GroupPageSettings.Caption := frLoadStr(frRes + 1845);
  Topm.Caption := frLoadStr(frRes + 1846);
  Leftm.Caption := frLoadStr(frRes + 1847);
  ScX.Caption := frLoadStr(frRes + 1848);
  ScY.Caption := frLoadStr(frRes + 1849);
  GroupCellProp.Caption := frLoadStr(frRes + 1850);
  CB_PageBreaks.Caption := frLoadStr(frRes + 1860);
  CB_Pictures.Caption := frLoadStr(frRes + 1863);
end;

procedure TfrRtfExpSet.FormCreate(Sender: TObject);
begin
   Localize;
end;

end.
