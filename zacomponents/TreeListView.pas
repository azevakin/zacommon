unit TreeListView;

interface

uses
  Classes, Controls, ComCtrls, Graphics, Windows;

type
  TGetItemInfoEvent = procedure(
    Sender: TObject;
    Node: TTreeNode;
    Column: Integer;
    var ItemText: String;
    var ItemColor: TColor) of object;

  TTreeListView {v 1.4} = class(TComponent)
  private
    FOnGetItemInfo: TGetItemInfoEvent;
    FHeader: THeaderControl;
    FTree: TTreeView;
    procedure SetHeaderControl(const Value: THeaderControl);
    procedure SetTreeView(const Value: TTreeView);
    procedure AdvancedCustomDrawItem(
      Sender: TCustomTreeView;
      Node: TTreeNode;
      State: TCustomDrawState;
      Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure HeaderSectionTrack(
      HeaderControl: THeaderControl;
      HeaderSection: THeaderSection;
      Width: Integer;
      State: TSectionTrackState);
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(
      AOwner: TComponent;
      ATree: TTreeView;
      AHeader: THeaderControl); reintroduce; overload;
    destructor Destroy; override;
  published
    property TreeView: TTreeView read FTree write SetTreeView;
    property HeaderControl: THeaderControl read FHeader write SetHeaderControl;
    property OnGetItemInfo: TGetItemInfoEvent read FOnGetItemInfo write FOnGetItemInfo;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TTreeListView]);
end;

{ TTreeListView }

constructor TTreeListView.Create(AOwner: TComponent);
begin
  inherited;
  FOnGetItemInfo := nil;
  FHeader := nil;
  FTree := nil;
end;

constructor TTreeListView.Create(
  AOwner: TComponent;
  ATree: TTreeView;
  AHeader: THeaderControl);
begin
  inherited Create(AOwner);
  FOnGetItemInfo := nil;
  HeaderControl := AHeader;
  TreeView := ATree;
end;

destructor TTreeListView.Destroy;
begin
  inherited Destroy;
end;

procedure TTreeListView.AdvancedCustomDrawItem(
  Sender: TCustomTreeView;
  Node: TTreeNode;
  State: TCustomDrawState;
  Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: Boolean);

var // локальные переменные
  NodeRect, SectionRect: TRect;
  DC: HDC;
  clBackground, clText: TColor;
  Section: THeaderSection;
  SectionText: String;
  uDrawMode: UINT;
  i: Integer;
  bRowSelect, bSelected, bFocused: Boolean;
begin
  bRowSelect := FTree.RowSelect;
  bFocused := FTree.Focused;
  bSelected := cdsSelected in State;

  DefaultDraw := true;
  PaintImages := true;
{ выполняем, только если режим отрисовки cdPostPaint, при котором
  собственная отрисовка происходит поверх отрисовки по умолчанию }
  if Stage = cdPostPaint then
  begin
    DC := Sender.Canvas.Handle;
    SectionRect := Node.DisplayRect(true);

{   проходим через все колонки заголовка, для каждой из них вызывая
    срабатывание события OnGetItemInfo для получения текста колонки }
    for i := 0 to FHeader.Sections.Count-1 do
    begin
      Sleep(1);
      SectionText := '';
      if Assigned(FOnGetItemInfo) then
      begin
        OnGetItemInfo(Self, Node, i, SectionText, clText);
      end;

      Section := FHeader.Sections.Items[i];
      if i = 0 then
      begin
        if SectionRect.Right > Section.Right then
          SectionRect.Right := Section.Right;
        NodeRect := SectionRect;
      end else begin
        SectionRect.Left := Section.Left;
        SectionRect.Right := SectionRect.Left + Section.Width;
      end;

      clBackground := GetSysColor(COLOR_WINDOW);
      clText := GetSysColor(COLOR_WINDOWTEXT);

      if ((i=0) or bRowSelect) and (bSelected) then
      begin
        if bFocused then
        begin
          clBackground := GetSysColor(COLOR_HIGHLIGHT);
          clText := GetSysColor(COLOR_HIGHLIGHTTEXT);
        end else begin
          clBackground := GetSysColor(COLOR_BTNFACE);
          clText := GetSysColor(COLOR_WINDOWTEXT);
        end;
      end;

      SetBkColor(DC, clBackground);
      FillRect(DC, SectionRect, CreateSolidBrush(clBackground));

      uDrawMode := DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS;

      if Section.Alignment = taCenter then
      begin
        uDrawMode := uDrawMode or DT_CENTER;
      end;

      if Section.Alignment = taLeftJustify then
      begin
        uDrawMode := uDrawMode or DT_LEFT;
        SectionRect.Left := SectionRect.Left + 2;
      end;

      if Section.Alignment = taRightJustify then
      begin
        uDrawMode := uDrawMode or DT_RIGHT;
        SectionRect.Right := SectionRect.Right - 2;
      end;

      SetTextColor(DC, clText);
      DrawText(DC, PChar(SectionText), Length(SectionText), SectionRect, uDrawMode);
    end;
{   рисуем прямоугольник с фокусом, если фокус на элементе списка }
    if (cdsFocused in State) and not FTree.RowSelect then
    begin
      DrawFocusRect(DC, NodeRect);
    end;
  end;
end;

procedure TTreeListView.HeaderSectionTrack(
  HeaderControl: THeaderControl;
  HeaderSection: THeaderSection;
  Width: Integer;
  State: TSectionTrackState);
begin
{ когда пользователь заканчивает перемещение
  колонки заголовка, перерисовываем TreeView }
  if State = tsTrackEnd then
  begin
    FTree.Invalidate;
  end;
end;

procedure TTreeListView.SetHeaderControl(const Value: THeaderControl);
begin
  if FHeader <> Value then
  begin
    FHeader := Value;
    FHeader.OnSectionTrack := HeaderSectionTrack;
  end;
end;

procedure TTreeListView.SetTreeView(const Value: TTreeView);
begin
  if FTree <> Value then
  begin
    FTree := Value;
    FTree.OnAdvancedCustomDrawItem := AdvancedCustomDrawItem;
  end;
end;

end.
