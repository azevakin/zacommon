unit ZADictionaryLv;

interface

uses
  Classes, Controls, Forms, ZACustomDictionary, ComCtrls, StdCtrls,
  ExtCtrls;

type
  TDictionaryLvDlg = class(TCustomDictionaryDlg)
    edtSearch: TEdit;
    lblSearch: TLabel;
    lvValues: TListView;
    pnlSearch: TPanel;
    pnlValues: TPanel;
    procedure edtSearchChange(Sender: TObject);
    procedure lvValuesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvValuesDblClick(Sender: TObject);
  private
    function GetAllowSearch: Boolean;
    procedure SetAllowSearch(const BValue: Boolean);
  protected
    procedure UpdateRecordCount; override;
  public
    property AllowSearch: Boolean read GetAllowSearch write SetAllowSearch;
  end;

implementation

uses ZAStdCtrlsUtils, SysUtils;

{$R *.dfm}

function TDictionaryLvDlg.GetAllowSearch: Boolean;
begin
  Result := pnlSearch.Visible;
end;

procedure TDictionaryLvDlg.SetAllowSearch(const BValue: Boolean);
begin
  pnlSearch.Visible := BValue;
end;

procedure TDictionaryLvDlg.UpdateRecordCount;
begin
  inherited;
  StatusBar.Panels[2].Text := IntToStr(lvValues.Items.Count);
end;

procedure TDictionaryLvDlg.edtSearchChange(Sender: TObject);
var
  Item: TListItem;
begin
  if not IsEmpty(edtSearch) then
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

procedure TDictionaryLvDlg.lvValuesDblClick(Sender: TObject);
begin
  if btnSelect.Enabled then
  begin
    if AllowSelect then
      btnSelect.Click
    else
      btnEdit.Click;
  end;
end;

procedure TDictionaryLvDlg.lvValuesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetButtonsEnabled(Assigned(lvValues.GetItemAt(X,Y)));
end;

end.
