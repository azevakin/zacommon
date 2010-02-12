unit ZeosCommonDictionaryLV;

interface

uses
  Classes, Controls, Forms, ZeosCommonDictionary, ComCtrls, 
  ExtCtrls, StdCtrls;

type
  TZeosCommonDictionaryLVDlg = class(TZeosCommonDictionaryDlg)
    lvValues: TListView;
    pnlValues: TPanel;
    procedure lvValuesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvValuesDblClick(Sender: TObject);
    procedure lvValuesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvValuesDeletion(Sender: TObject; Item: TListItem);
  protected
    procedure UpdateLastColumnWidth;
    procedure UpdateRecordCount; override;
  end;

implementation

uses SysUtils;

{$R *.dfm}

procedure TZeosCommonDictionaryLVDlg.UpdateLastColumnWidth;
var
  c,  // количество столбцов в списке
  i,  // счетчик для цикла
  w   // будующая ширина последнего столбца
  : Integer;
begin
  // запомним количество столбцов
  c := lvValues.Columns.Count;
  case c of
    // если столбцов ноль, то ничего не делаем
    0:;
    // если один столбец, то зададим ему ширину,
    // равную ширине клиентской области списка
    1: lvValues.Column[0].Width := lvValues.ClientWidth;
  else
    // если столбцов больше одного, то зададим последнему ширину,
    // равную ширине клиентской области списка минус сумму ширин предыдущих столбцов
    w := lvValues.ClientWidth;
    for i := 0 to c-2 do
      Dec(w, lvValues.Column[i].Width);
    lvValues.Column[c-1].Width := w;
  end;
end;

procedure TZeosCommonDictionaryLVDlg.UpdateRecordCount;
begin
  inherited;
  StatusBar.Panels[2].Text := IntToStr(lvValues.Items.Count);
end;

procedure TZeosCommonDictionaryLVDlg.lvValuesDblClick(Sender: TObject);
begin
  if btnSelect.Enabled then
  begin
    if AllowSelect then
      btnSelect.Click
    else
      btnEdit.Click;
  end;
end;

procedure TZeosCommonDictionaryLVDlg.lvValuesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetButtonsEnabled(Assigned(lvValues.GetItemAt(X,Y)));
end;

procedure TZeosCommonDictionaryLVDlg.lvValuesChange(Sender: TObject; Item: TListItem;
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

procedure TZeosCommonDictionaryLVDlg.lvValuesDeletion(Sender: TObject;
  Item: TListItem);
begin
  inherited;
  Application.ProcessMessages;
end;

end.
