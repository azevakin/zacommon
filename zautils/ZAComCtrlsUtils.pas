unit ZAComCtrlsUtils;

interface

uses ComCtrls;

// добавл€ет к переданному TTreeView узел
function AddTreeItem(tv: TTreeView; parent: TTreeNode; caption: string;
  data: Pointer; hasChildren: Boolean; imageIndex: Integer): TTreeNode;

// подсчитывает количество отмеченных(Checked) элементов у переданного lv
// вместо этой функции лучше использовать элемент управлени€ TCoolListView,
// наход€щегос€ в модуле coolListView
function checkedCount(lv: TListView): Integer; deprecated;

// провер€ет переданный RichEdit на пустоту
function IsEmpty(Value: TRichEdit): Boolean; overload;

// провер€ет что переданный Item выбран и имеет фокус
function isSelectedAndFocused(Item: TListItem; Change: TItemChange): Boolean;

// удал€ет у Node всех потомков и если они были устанавливает HasChildren в True
procedure deleteChildrenAndSetHasChildren(Node: TTreeNode);

// удал€ет у lv переданный item и устанавливает ItemIndex
procedure deleteListItem(lv: TListView; item: TListItem);

// у всех листов, переданного PageControl, скрывает закладки
procedure hideTabs(PageControl: TPageControl);

// если находит у переданного lv элемент с заголовком=caption выдел€ет его
procedure selectItem(lv: TListView; const caption: String);

function selection(tv: TTreeView): String; overload;
function selection(lv: TListView): String; overload;
procedure deleteSelection(tv: TTreeView);
procedure moveSelection(tv: TTreeView; dest: TTreeNode; mode: TNodeAttachMode);
procedure incItemHeight(tv: TTreeView; const incBy: Byte);


implementation

uses CommCtrl, SysUtils, ZAConst;

function AddTreeItem(tv: TTreeView; parent: TTreeNode; caption: string;
  data: Pointer; hasChildren: Boolean; imageIndex: Integer): TTreeNode;
begin
  Result := tv.Items.AddChildObject(parent, caption, data);
  Result.HasChildren := hasChildren;
  Result.ImageIndex := imageIndex;
end;

function checkedCount(lv: TListView): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to lv.Items.Count-1 do
    Result := Result + Ord(lv.Items[i].Checked);
end;

function IsEmpty(Value: TRichEdit): Boolean;
begin
  Result := Length(Trim(Value.Lines.Text)) = Zero;
end;

function isSelectedAndFocused(Item: TListItem; Change: TItemChange): Boolean;
begin
  Result := (Change = ctState) and (Item.Selected) and (Item.Focused);
end;

procedure deleteChildrenAndSetHasChildren(Node: TTreeNode);
begin
  if Node.HasChildren then
  begin
    Node.DeleteChildren;
    Node.HasChildren := True;
  end;
end;

procedure deleteListItem(lv: TListView; item: TListItem);
var
  idx: Integer;
begin
  idx := item.Index;
  item.Delete;
  if idx = lv.Items.Count then
    lv.ItemIndex := idx-1
  else
    lv.ItemIndex := idx;
end;

procedure hideTabs(PageControl: TPageControl);
var
  i, len: Integer;
begin
  len := PageControl.PageCount-1;
  for i := 0 to len do
    PageControl.Pages[i].TabVisible := False;
end;

procedure selectItem(lv: TListView; const caption: String);
var
  lvItem: TListItem;
begin
  lvItem := lv.FindCaption(-1, caption, True, False, False);
  if lvItem <> nil then
  begin
    lvItem.MakeVisible(True);
    lvItem.Selected := True;
    lvItem.Focused := True;
  end;
end;

function selection(tv: TTreeView): String;
var
  I, Count: Cardinal;
begin
  Result := SNull;
  Count := tv.SelectionCount;

  if Count > 0 then
    for I := 0 to Count-1 do
      Result := Result + IntToStr(Integer(tv.Selections[I].Data)) + ', ';

  Result := Copy(Result, 1, Length(Result)-2);
end;

function selection(lv: TListView): string;
var
  I, Count: Cardinal;
begin
  Result := SNull;
  Count := lv.Items.Count;

  if lv.SelCount > 0 then
  begin
    for I := 0 to Count - 1 do
      if lv.Items[I].Selected then
        Result := Result + IntToStr(Integer(lv.Items[I].Data)) + ', ';

    Result := Copy(Result, 1, Length(Result) - 2);
  end;
end;

procedure deleteSelection(tv: TTreeView);
var
  I: Integer;
  Count: Cardinal;
begin
  Count := tv.SelectionCount;
  if Count > 0 then
    for I := Count-1 downto 0 do
      tv.Selections[I].Delete;
end;

procedure moveSelection(tv: TTreeView; dest: TTreeNode; mode: TNodeAttachMode);
var
  I: Integer;
  Count: Cardinal;
begin
  Count := tv.SelectionCount;
  if Count > 0 then
    for I := Count-1 downto 0 do
      tv.Selections[I].MoveTo(dest, mode);
end;

procedure incItemHeight(tv: TTreeView; const incBy: Byte);
var
  ItemHeight: Integer;
begin
  ItemHeight := tv.Perform(TVM_GETITEMHEIGHT, 0, 0);
  Inc(ItemHeight, incBy);
  tv.Perform(TVM_SETITEMHEIGHT, ItemHeight, 0);
end;

end.


