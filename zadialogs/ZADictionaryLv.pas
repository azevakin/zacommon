unit ZADictionaryLv;

interface

uses
  Classes, Controls, Forms, ZACustomDictionaryLv, ComCtrls, StdCtrls,
  ExtCtrls, ZACustomDictionary;

type
  TDictionaryLvDlg = class(TCustomDictionaryLvDlg)
    edtSearch: TEdit;
    lblSearch: TLabel;
    pnlSearch: TPanel;
    procedure edtSearchChange(Sender: TObject);
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

end.
