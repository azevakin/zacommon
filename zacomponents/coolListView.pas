unit coolListView;

interface

uses
  Classes, Controls, ComCtrls;

type
  TCoolListView = class(TListView)
  private
    FCheckedItems: TList;
    function GetCheckedCount: Cardinal;
    function GetChecked(Index: Integer): TListItem;
    function IsChecked(listItem: TListItem): Boolean;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function getCheckedItems(list: TList): Integer;
    procedure CheckAll;
    procedure CheckItem(listItem: TListItem);
    procedure ClearItems;
    procedure deleteCheckedItems;
    procedure UncheckAll;
    procedure UncheckItem(listItem: TListItem);
    property CheckedCount: Cardinal read GetCheckedCount;
    property CheckedItem[Index: Integer]: TListItem read GetChecked;
  end;

  procedure Register;

implementation

uses Math, Windows;

procedure Register;
begin
  RegisterComponents('CoolControls', [TCoolListView]);
end;

{TCoolListView}

constructor TCoolListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCheckedItems := TList.Create;
end;

destructor TCoolListView.Destroy;
begin
  FCheckedItems.Free;
  inherited Destroy;
end;

function TCoolListView.GetCheckedCount: Cardinal;
begin
  Result := FCheckedItems.Count;
end;

function TCoolListView.GetChecked(Index: Integer): TListItem;
begin
  Result := TListItem(FCheckedItems[Index]);
end;

function TCoolListView.IsChecked(listItem: TListItem): Boolean;
begin
  Result := FCheckedItems.IndexOf(listItem) <> -1;
end;

procedure TCoolListView.CheckItem(listItem: TListItem);
begin
  FCheckedItems.Add(listItem);
end;

procedure TCoolListView.UncheckItem(listItem: TListItem);
begin
  FCheckedItems.Delete(FCheckedItems.IndexOf(listItem));
end;

procedure TCoolListView.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  listItem: TListItem;
begin
  if Button = mbLeft then
  begin
    listItem := GetItemAt(X, Y);
    if Assigned(listItem) and not listItem.Deleting then
    begin
      if IsChecked(listItem) then
      begin
        if not listItem.Checked then
          UncheckItem(listItem);
      end
      else
      begin
        if listItem.Checked then
          CheckItem(listItem);
      end;
      inherited;
    end;
  end;
end;

procedure TCoolListView.CheckAll;
var
  i, len: Integer;
begin
  FCheckedItems.Clear;
  len := Items.Count-1;
  for i := 0 to len do
  begin
    Items[i].Checked := True;
    CheckItem(Items[i]);
  end;
end;

procedure TCoolListView.UncheckAll;
var
  i, len: Integer;
begin
  FCheckedItems.Clear;
  len := Items.Count-1;
  for i := 0 to len do
    Items[i].Checked := False;
end;

procedure TCoolListView.ClearItems;
begin
  self.Clear;
  FCheckedItems.Clear;
end;

function compareListItemIndex(item1, item2: Pointer): Integer;
begin
  Result := CompareValue(TListItem(item1).Index, TListItem(item2).Index);
end;

function TCoolListView.getCheckedItems(list: TList): Integer;
var
  i, len: Integer;
begin
  list.Clear;
  len := FCheckedItems.Count-1;
  for i := 0 to len do
    list.Add(FCheckedItems[i]);

  Result := FCheckedItems.Count;
end;

procedure TCoolListView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Assigned(Selected) and (Key = VK_SPACE) then
  begin
    if IsChecked(Selected) then
      UncheckItem(Selected)
    else
      CheckItem(Selected);
  end;
end;

procedure TCoolListView.deleteCheckedItems;
var
  i, len: Integer;
begin
  len := FCheckedItems.Count-1;
  Self.Items.BeginUpdate;
  try
    for i := len downto 0 do
      Self.CheckedItem[i].Delete;
  finally
    Self.Items.EndUpdate;
    FCheckedItems.Clear;
  end;
end;

end.
