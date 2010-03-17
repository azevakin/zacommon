unit ZAWordApplication;

interface

uses
  SysUtils,
  Variants,
  ComObj,
  Classes;

type
  TZAWordApplication = class(TComponent)
  private
    FVisible: Boolean;
    FWordApplication: OleVariant;
    function GetConnected: Boolean;
    procedure SetConnected(const Value: Boolean);
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    function GetSelection: OleVariant;
    function GetActiveDocument: OleVariant;
    procedure SetSelection(const Value: OleVariant);
    function GetDocuments: OleVariant;
    procedure CheckConnected;
    function GetApplication: OleVariant;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function CentimetersToPoints(Centimeters: Single): Single;
    class function MillimetersToPoints(Millimeters: Single): Single;
  published
    procedure Activate;
    procedure Connect;
    procedure Close;
    procedure Disconnect;
    procedure GoToBookmark(const Name: String);
    procedure InsertAfter(const S: String);
    procedure InsertBefore(const S: String);
    procedure Show;
    procedure TypeText(const S: String; const Paragraph: Boolean = False);
    property ActiveDocument: OleVariant read GetActiveDocument;
    property Application: OleVariant read GetApplication;
    property Connected: Boolean read GetConnected write SetConnected;
    property Documents: OleVariant read GetDocuments;
    property Selection: OleVariant read GetSelection write SetSelection;
    property Visible: Boolean read GetVisible write SetVisible default False;
    property WordApplication: OleVariant read FWordApplication;
  end;

//const
//  wdAutoFitFixed = $00000000;
//  wdAutoFitContent = $00000001;
//  wdAutoFitWindow = $00000002;
                                 
implementation

uses WordConst;

const
  SWordApplication = 'Word.Application';

{ TZAWordApplication }

constructor TZAWordApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TZAWordApplication.Destroy;
begin
  Disconnect;
  inherited Destroy;
end;

procedure TZAWordApplication.Activate;
begin
  if Connected then
    FWordApplication.Activate;
end;

function TZAWordApplication.GetVisible: Boolean;
begin
  if not Connected then
    Result := False
  else
    Result := FVisible;
end;

procedure TZAWordApplication.SetVisible(const Value: Boolean);
begin
  if Connected then
    FWordApplication.Visible := Value;
end;

function TZAWordApplication.GetConnected: Boolean;
begin
  Result := not VarIsEmpty(FWordApplication);
end;

procedure TZAWordApplication.SetConnected(const Value: Boolean);
begin
  if Value = Connected then Exit;

  if Value then
  begin
    FWordApplication := CreateOleObject(SWordApplication);
    if VarIsEmpty(FWordApplication) then
      raise Exception.CreateFmt('Не могу создать объект ''%s''', [SWordApplication]);
  end else
    FWordApplication := Unassigned;
end;

procedure TZAWordApplication.Connect;
begin
  Connected := True;
end;

procedure TZAWordApplication.Disconnect;
begin
  Connected := False;
end;

procedure TZAWordApplication.CheckConnected;
begin
  if not Connected then
    raise Exception.Create('Нет активного документа');
end;

function TZAWordApplication.GetSelection: OleVariant;
begin
  CheckConnected;
  Result := FWordApplication.Selection;
end;

procedure TZAWordApplication.GoToBookmark(const Name: String);
begin
  Self.Selection.GoTo($FFFFFFFF, EmptyParam, EmptyParam, Name);
end;

procedure TZAWordApplication.InsertAfter(const S: String);
begin
  Self.Selection.InsertAfter(S);
end;

procedure TZAWordApplication.InsertBefore(const S: String);
begin
  Self.Selection.InsertBefore(S);
end;

procedure TZAWordApplication.TypeText(const S: String; const Paragraph: Boolean = False);
begin
  Self.Selection.TypeText(S);
  if Paragraph then
    Self.Selection.TypeParagraph;
end;

procedure TZAWordApplication.Show;
begin
  Visible := True;
  Activate;
end;

class function TZAWordApplication.CentimetersToPoints(Centimeters: Single): Single;
begin
  Result := Centimeters * 28.35;
end;

class function TZAWordApplication.MillimetersToPoints(Millimeters: Single): Single;
begin
  Result := Millimeters * 2.85;
end;

function TZAWordApplication.GetActiveDocument: OleVariant;
begin
  CheckConnected;
  Result := FWordApplication.ActiveDocument;
end;

procedure TZAWordApplication.SetSelection(const Value: OleVariant);
begin
  CheckConnected;
  if FWordApplication.Selection <> Value then
    FWordApplication.Selection := Value;
end;

function TZAWordApplication.GetDocuments: OleVariant;
begin
  CheckConnected;
  Result := FWordApplication.Documents;
end;

function TZAWordApplication.GetApplication: OleVariant;
begin
  CheckConnected;
  Result := FWordApplication.Application;
end;

procedure TZAWordApplication.Close;
begin
  Application.Quit(wdDoNotSaveChanges);
end;

end.
