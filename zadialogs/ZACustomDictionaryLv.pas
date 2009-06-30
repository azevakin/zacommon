unit ZACustomDictionaryLv;

interface

uses
  Classes, Controls, Forms, ZACustomDictionary, ComCtrls, StdCtrls,
  ExtCtrls;

type
  TCustomDictionaryLvDlg = class(TCustomDictionaryDlg)
    lvValues: TListView;
    pnlValues: TPanel;
    procedure lvValuesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvValuesDblClick(Sender: TObject);
    procedure lvValuesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  protected
    procedure UpdateLastColumnWidth;
    procedure UpdateRecordCount; override;
  end;

implementation

uses SysUtils, ZAComCtrlsUtils;

{$R *.dfm}

procedure TCustomDictionaryLvDlg.UpdateLastColumnWidth;
// Метод для задания ширины последнего столбца списка при изменении количества строк в нем.
// Позволяет избавиться от горизонтальной полосы прокрутки (scrollbar'a ;)
begin
  ZAComCtrlsUtils.UpdateLastColumnWidth(lvValues);
end;

procedure TCustomDictionaryLvDlg.UpdateRecordCount;
begin
  inherited;
  StatusBar.Panels[2].Text := IntToStr(lvValues.Items.Count);
end;

procedure TCustomDictionaryLvDlg.lvValuesDblClick(Sender: TObject);
begin
  if btnSelect.Enabled then
  begin
    if AllowSelect then
      btnSelect.Click
    else
      btnEdit.Click;
  end;
end;

procedure TCustomDictionaryLvDlg.lvValuesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetButtonsEnabled(Assigned(lvValues.GetItemAt(X,Y)));
end;

procedure TCustomDictionaryLvDlg.lvValuesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Assigned(Item) then
  begin
    if (Change=ctState) and Item.Selected and Item.Focused then
      SetButtonsEnabled(True);
  end
  else
    SetButtonsEnabled(False);
end;

end.
