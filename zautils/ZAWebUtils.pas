unit ZAWebUtils;

interface

uses Classes, ZAClasses, SHDocVw; //, ComCtrls, OleCtrls, ZAClasses;

type
  THtmlDocument = class(TPgSqlClass)
  private
    Styles: TStringList;
    FStylesFilename: string;
    function GetDocumentText: string;
    procedure SetStylesFilename(const Value: string);
  protected
    procedure AddCol; overload;
    procedure AddCol(const Width: string); overload;
    procedure AddTag(const Value: string); overload;
    procedure AddTag(const S: string; const Args: array of const); overload;
    procedure AddTR(const TH, TD: string); overload;
    procedure AddTR(const TH, TD, TH2, TD2: string); overload;
    procedure AddTR(const TD: string; const ColCount: Integer); overload;
    procedure AddTR(TDvalues: array of string; const IsHeader: Boolean=False); overload;
    procedure AddTR(TDvalues, TDalign: array of string;
      const IsHeader: Boolean=False); overload;
//    procedure AddTR(const TD; const Level, ColCount: Integer); overload;
//    procedure AddTR(const TH, TD; Sizes: array of string); overload;
    procedure AddTRwTDs(TDs: array of string);
    procedure AddHeader(const Value: string; const ColCount: Integer); overload;
    procedure AddHeader(const ClassName, Value: string; const ColCount: Integer); overload;
    procedure BeginDocument;
    procedure BeginTable;
    procedure BeginTableBordered;
    procedure EndDocument;
    procedure EndTable;
//    function TD(const Value: string; ColSpan: Integer): string; overload;
    function TD(const Value, Align: string; const ColSpan, RowSpan: Byte): string; overload;
    function TD(const Value: string; const ColSpan, RowSpan: Byte): string; overload;
    function TH(const Value, Align: string; const ColSpan, RowSpan: Byte): string; overload;
    function TH(const Value: string; const ColSpan, RowSpan: Byte): string; overload;
  public
    Document: TStringList;
    constructor Create(ATransaction: TZPgSqlTransact); override;
    destructor Destroy; override;
    property DocumentText: string read GetDocumentText;
    property StylesFilename: string read FStylesFilename write SetStylesFilename;
  end;


function GetBrowserSelection(WebBrowser: TWebBrowser): string;
procedure ShowHtml(htmlText: String; WebBrowser: TWebBrowser);

const
  AlignCenter='Center';
  AlignLeft='Left';
  AlignRight='Right';
  nbsp = '&nbsp;';
  Silver = 'silver';

implementation

uses Variants, ActiveX, MSHTML, SysUtils, ZAConst;

resourcestring
  htmlHead='<html><head><meta http-equiv="Content-Type" content="text/html;'+
           'charset=win1251"></head><body>';

  htmlEnd='</body>';

  col='<col>';
  colWidth='<col width=%s>';

  tableBegin='<table>';
  tableBeginBordered='<table class=bordered>';
  tableEnd='</table>';

  trBegin='<tr>';
  trEnd='</tr>';

  tdColSpan='<td colspan=%d>%s';
  tdAlignTpl='<td align=%s>%s';
  tdBegin='<td>';
  tdSize='<td width=%s>%s';
  tdTpl='<td %s>';
  tdEnd='</td>';
  tdRowSpan='<td rowspan=%d>%s';
  tdColRowSpan='<td colspan=%d rowspan=%d>%s';

  thAlignTpl='<th align=%s>%s';
  thAlignHeaderTpl='<th align=%s>%s';
  thBegin='<th>';
  thBeginHeader='<th>';
  thSize='<th width=%s>%s';
  thColRowSpan='<th colspan=%d rowspan=%d>%s';
  thColSpan='<th colspan=%d>%s';
  thRowSpan='<th rowspan=%d>%s';

  headerTpl='<tr><th colspan=%d>%s';



function GetBrowserSelection(WebBrowser: TWebBrowser): string;
var
  Doc: Variant;
begin
  if WebBrowser.Document <> nil then
  begin
    Doc := WebBrowser.Document;
    try
      Result := Doc.Selection.createRange.Text
    finally
      Doc := Unassigned;
    end;
  end
  else
    Result := SNull;
end;

procedure ShowHtml(htmlText: String; WebBrowser: TWebBrowser);
var
  v: Variant;
  HTMLDocument: IHTMLDocument2;
begin
  if WebBrowser.Document = nil then
    WebBrowser.Navigate('about:blank');

  HTMLDocument := WebBrowser.Document as IHTMLDocument2;
  try
    v := VarArrayCreate([0, 0], varVariant);
    v[0] := htmlText; // текст HTML
    HTMLDocument.Write(PSafeArray(TVarData(v).VArray));
  finally
    HTMLDocument.Close;
  end;
end;

{ THtmlDocument }

procedure THtmlDocument.AddCol;
begin
  Document.Add(col);
end;

procedure THtmlDocument.AddCol(const Width: string);
begin
  Document.Add(Format(colWidth, [Width]));
end;

procedure THtmlDocument.AddTR(const TH, TD: string);
begin
  Document.Add(trBegin + thBegin + TH + tdBegin + TD);
end;

procedure THtmlDocument.AddTR(const TD: string; const ColCount: Integer);
begin
  Document.Add(trBegin + Format(tdColSpan, [ColCount, TD]));
end;

procedure THtmlDocument.AddTR(TDvalues: array of string;
  const IsHeader: Boolean=False);
var
  i: Integer;
  str: string;
begin
  str := trBegin;

  if IsHeader then
    for i := Low(TDvalues) to High(TDvalues) do
      str := str + thBeginHeader + TDvalues[i]
  else
    for i := Low(TDvalues) to High(TDvalues) do
      str := str + tdBegin + TDvalues[i];

  Document.Add(str);
end;

procedure THtmlDocument.AddTR(TDvalues, TDalign: array of string;
  const IsHeader: Boolean);
var
  i: Integer;
  str: string;
begin
  str := trBegin;

  if IsHeader then
    for i := Low(TDvalues) to High(TDvalues) do
      str := str + Format(thAlignHeaderTpl, [TDalign[i], TDvalues[i]])
  else
    for i := Low(TDvalues) to High(TDvalues) do
      str := str + Format(tdAlignTpl, [TDalign[i], TDvalues[i]]);

  Document.Add(str);
end;

procedure THtmlDocument.AddHeader(const Value: string; const ColCount: Integer);
begin
  Document.Add(Format(headerTpl, [ColCount, Value]));
end;

procedure THtmlDocument.BeginDocument;
begin
  Document.BeginUpdate;
  Document.Clear;
  Document.Add(htmlHead);
  Document.AddStrings(Styles);
end;

procedure THtmlDocument.BeginTable;
begin
  Document.Add(tableBegin);
end;

procedure THtmlDocument.BeginTableBordered;
begin
  Document.Add(tableBeginBordered);
end;

constructor THtmlDocument.Create(ATransaction: TZPgSqlTransact);
begin
  inherited;
  Document := TStringList.Create;
  Styles := TStringList.Create;
end;

destructor THtmlDocument.Destroy;
begin
  Document.Destroy;
  Styles.Destroy;
  inherited;
end;

procedure THtmlDocument.EndDocument;
begin
  Document.Add(htmlEnd);
  Document.EndUpdate;
end;

procedure THtmlDocument.EndTable;
begin
  Document.Add(tableEnd);
end;

function THtmlDocument.GetDocumentText: string;
begin
  Result := Document.Text;
end;

procedure THtmlDocument.SetStylesFilename(const Value: string);
begin
  if not isEqual(FStylesFilename, Value) then
  begin
    FStylesFilename := Value;
    if isNull(FStylesFilename) then
      Styles.Clear
    else
    begin
      if FileExists(Value) then
      begin
        Styles.LoadFromFile(Value);
        if not isZero(Styles.Count) then
        begin
          Styles.Insert(0, '<style>');
          Styles.Add('</style>');
        end;
      end;
    end;
  end;
end;

function THtmlDocument.TD(const Value: string; const ColSpan, RowSpan: Byte): string;
begin
  if (ColSpan > 0) and (RowSpan > 0) then
    Result := Format(tdColRowSpan, [ColSpan, RowSpan, Value])
  else
  begin
    if ColSpan > 0 then
    begin
      Result := Format(tdColSpan, [ColSpan, Value]);
      Exit;
    end;

    if RowSpan > 0 then
    begin
      Result := Format(tdRowSpan, [RowSpan, Value]);
      Exit;
    end;

    Result := thBeginHeader + Value;
  end;
end;

procedure THtmlDocument.AddTRwTDs(TDs: array of string);
var
  i: Integer;
  str: string;
begin
  str := trBegin;

  for i := Low(TDs) to High(TDs) do
    str := str + TDs[i];

  Document.Add(str);
end;

function THtmlDocument.TD(const Value, Align: string; const ColSpan,
  RowSpan: Byte): string;
begin
  if (ColSpan > 0) and (RowSpan > 0) then
    Result := Format('<td colspan=%d rowspan=%d align=%s>%s',
      [ColSpan, RowSpan, Align, Value])
  else
  begin
    if ColSpan > 0 then
    begin
      Result := Format('<td colspan=%d align=%s>%s', [ColSpan, Align, Value]);
      Exit;
    end;

    if RowSpan > 0 then
    begin
      Result := Format('<td rowspan=%d align=%s>%s', [RowSpan, Align, Value]);
      Exit
    end;

    Result := Format('<td align=%s>%s', [Align, Value]);
  end;
end;

procedure THtmlDocument.AddTag(const Value: string);
begin
  Document.Add(Value);
end;

procedure THtmlDocument.AddTag(const S: string; const Args: array of const);
begin
  AddTag(Format(s, Args));
end;

procedure THtmlDocument.AddTR(const TH, TD, TH2, TD2: string);
begin
  Document.Add(trBegin + thBegin + TH + tdBegin + TD + thBegin + TH2 + tdBegin + TD2);
end;

function THtmlDocument.TH(const Value, Align: string; const ColSpan,
  RowSpan: Byte): string;
begin
  if (ColSpan > 0) and (RowSpan > 0) then
    Result := Format('<th colspan=%d rowspan=%d align=%s>%s',
      [ColSpan, RowSpan, Align, Value])
  else
  begin
    if ColSpan > 0 then
    begin
      Result := Format('<th colspan=%d align=%s>%s', [ColSpan, Align, Value]);
      Exit;
    end;

    if RowSpan > 0 then
    begin
      Result := Format('<th rowspan=%d align=%s>%s', [RowSpan, Align, Value]);
      Exit
    end;

    Result := Format('<th align=%s>%s', [Align, Value]);
  end;
end;

function THtmlDocument.TH(const Value: string; const ColSpan,
  RowSpan: Byte): string;
begin
  if (ColSpan > 0) and (RowSpan > 0) then
    Result := Format(thColRowSpan, [ColSpan, RowSpan, Value])
  else
  begin
    if ColSpan > 0 then
    begin
      Result := Format(thColSpan, [ColSpan, Value]);
      Exit;
    end;

    if RowSpan > 0 then
    begin
      Result := Format(thRowSpan, [RowSpan, Value]);
      Exit;
    end;

    Result := thBeginHeader + Value;
  end;
end;

procedure THtmlDocument.AddHeader(const ClassName, Value: string;
  const ColCount: Integer);
begin
  Document.Add(
    Format('<tr><th class="%s" colspan=%d>%s', [ClassName, ColCount, Value])
  );
end;

end.
