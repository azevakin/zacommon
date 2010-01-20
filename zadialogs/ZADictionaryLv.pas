unit ZADictionaryLv;

interface

uses
  Classes, Controls, Forms, ZACustomDictionaryLv, ComCtrls, StdCtrls,
  ExtCtrls, ZACustomDictionary, Windows;

type
  TDictionaryLvDlg = class(TCustomDictionaryLvDlg)
    edtSearch: TEdit;
    lblSearch: TLabel;
    pnlSearch: TPanel;
    procedure edtSearchChange(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function GetAllowSearch: Boolean;
    procedure SetAllowSearch(const BValue: Boolean);
  public
    property AllowSearch: Boolean read GetAllowSearch write SetAllowSearch;
  end;

implementation

{$R *.dfm}

function TDictionaryLvDlg.GetAllowSearch: Boolean;
begin
  Result := pnlSearch.Visible;
end;

procedure TDictionaryLvDlg.SetAllowSearch(const BValue: Boolean);
begin
  pnlSearch.Visible := BValue;
end;

procedure TDictionaryLvDlg.edtSearchChange(Sender: TObject);
var
  Item: TListItem;
begin
  if edtSearch.Text <> '' then
  begin
    Item := lvValues.FindCaption(0, edtSearch.Text, True, True, False);
    if Assigned(Item) then
    begin
      Item.MakeVisible(True);
      Item.Selected := True;
      Item.Focused := True;
      SetButtonsEnabled(True);
    end;
  end;
end;

procedure TDictionaryLvDlg.edtSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Assigned(lvValues.Selected) and (Key in [VK_UP, VK_DOWN]) then
  begin
    case Key of
      VK_UP:
        if lvValues.ItemIndex > 0 then
          lvValues.ItemIndex := lvValues.ItemIndex - 1;

      VK_DOWN:
        if lvValues.ItemIndex < lvValues.Items.Count-1 then
          lvValues.ItemIndex := lvValues.ItemIndex + 1;
    end;

    lvValues.Selected.MakeVisible(True);
    lvValues.Selected.Focused := True;
  end;
end;

end.
