unit ZADictionaryTwo;

interface

uses
  Classes, Controls, Forms, ZADictionaryLv, ComCtrls, StdCtrls,
  ZACustomDictionary, ExtCtrls;

type
  TDictionaryTwoDlg = class(TDictionaryLvDlg)
    procedure lvValuesDeletion(Sender: TObject; Item: TListItem);
    procedure btnSelectClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    FSqlForInsert: string;
    FSqlForSelect: string;
    FSqlForDelete: string;
    FSqlForUpdate: string;
    FCaptionTemplate: string;
    procedure AddValue;
    procedure DeleteValue;
    procedure EditValue;
    function GetSelectedID: Integer;
    function GetSelectedShort: string;
    function GetSelectedValue: string;
    procedure SetSelectedShort(const Value: string);
    procedure SetSelectedValue(const Value: string);
  protected
    procedure LoadValues; override;
  public
    property SelectedID: Integer read GetSelectedID;
    ///////////////////////////////////////////////////////////////////////////
    //  ¬ыбранное значение (код)
    ///////////////////////////////////////////////////////////////////////////

    property SelectedValue: string read GetSelectedValue write SetSelectedValue;
    ///////////////////////////////////////////////////////////////////////////
    //  ¬ыбранное значение (название)
    ///////////////////////////////////////////////////////////////////////////

    property SelectedShort: string read GetSelectedShort write SetSelectedShort;
    ///////////////////////////////////////////////////////////////////////////
    //  ¬ыбранное значение (сокращение)
    ///////////////////////////////////////////////////////////////////////////

    property SqlForInsert: string read FSqlForInsert write FSqlForInsert;
    ///////////////////////////////////////////////////////////////////////////
    //  SQL дл€ вставки нового значени€.
    //  ƒолжен добавл€ть новую запись и получать ее идентификатор.
    //  Ќапример:
    //    insert into таблица (значение, сокращение) values (%s, %s);
    //    select currval('счетчик_таблицы')
    //  или
    //    select добавить_значение_в_таблицу(%s, %s)
    ///////////////////////////////////////////////////////////////////////////

    property SqlForDelete: string read FSqlForDelete write FSqlForDelete;
    ///////////////////////////////////////////////////////////////////////////
    //  SQL дл€ удалени€ выделенного значени€.
    //  Ќапример:
    //    delete from таблица where код=%d
    //  или
    //    select удалить_значение_из_таблицы(%d)
    ///////////////////////////////////////////////////////////////////////////

    property SqlForSelect: string read FSqlForSelect write FSqlForSelect;
    ///////////////////////////////////////////////////////////////////////////
    //  SQL дл€ загрузки данных.
    //  Ќапример:
    //    select код, значение, сокращение from таблица order by значение
    ///////////////////////////////////////////////////////////////////////////

    property SqlForUpdate: string read FSqlForUpdate write FSqlForUpdate;
    ///////////////////////////////////////////////////////////////////////////
    //  SQL дл€ редактировани€ выделенного значени€.
    //  Ќапример:
    //    update таблица set значение=%s, сокращение=%s where код=%d
    //  или
    //    select изменить_значение_в_таблице(%s, %s, %d)
    ///////////////////////////////////////////////////////////////////////////

    property CaptionTemplate: string read FCaptionTemplate write FCaptionTemplate;
    ///////////////////////////////////////////////////////////////////////////
    //  «аголовок(Caption) дл€ InputBox'a
    //  Ќапример:
    //    %s "Ўтатное расписание"
    ///////////////////////////////////////////////////////////////////////////
  end;

implementation

uses inputValues, ZAClasses, ZAApplicationUtils, ZAConst,
  SysUtils, Windows;

{$R *.dfm}

procedure TDictionaryTwoDlg.AddValue;
begin
  with TInputValuesDlg.Create(Self, transaction) do
  try
    Caption := Format(CaptionTemplate, ['ƒобавить']);
    SqlTemplate := SqlForInsert;
    registryKey := Self.registryKey;
    if execute then
    begin
      lvValues.Items.Add.Selected := True;
      lvValues.Selected.Caption := Value;
      lvValues.Selected.Data := TID.Create(ID);
      lvValues.Selected.SubItems.Add(Short);
      lvValues.Selected.MakeVisible(True);
      lvValues.Selected.Focused := True;
      SetButtonsEnabled(True);
      UpdateRecordCount;
    end;
  finally
    Free;
  end;
end;

procedure TDictionaryTwoDlg.DeleteValue;
begin
  with execQuery(SqlForDelete, [SelectedID]) do
  try
    lvValues.Selected.Delete;
    SetButtonsEnabled(False);
    UpdateRecordCount;
  finally
    Free;
  end;
end;

procedure TDictionaryTwoDlg.EditValue;
begin
  with TInputValuesDlg.Create(Self, transaction) do
  try
    Caption := Format(CaptionTemplate, ['–едактировать']);
    SqlTemplate := SqlForUpdate;
    registryKey := Self.registryKey;
    ID := SelectedID;
    Value := SelectedValue;
    Short := SelectedShort;
    if execute then
    begin
      SelectedValue := Value;
      SelectedShort := Short;
    end;
  finally
    Free;
  end;
end;

function TDictionaryTwoDlg.GetSelectedID: Integer;
begin
  Result := TID(lvValues.Selected.Data).id;
end;

function TDictionaryTwoDlg.GetSelectedShort: string;
begin
  Result := lvValues.Selected.SubItems[0];
end;

function TDictionaryTwoDlg.GetSelectedValue: string;
begin
  Result := lvValues.Selected.Caption;
end;

procedure TDictionaryTwoDlg.SetSelectedShort(const Value: string);
begin
  lvValues.Selected.SubItems[0] := Value;
end;

procedure TDictionaryTwoDlg.SetSelectedValue(const Value: string);
begin
  lvValues.Selected.Caption := Value;
end;

procedure TDictionaryTwoDlg.LoadValues;
begin
  inherited;
  with openQuery(SqlForSelect) do
  try
    lvValues.Items.BeginUpdate;
    while not Eof do
      with lvValues.Items.Add do
      begin
        Application.ProcessMessages;
        Data := TID.Create(Fields[0].AsInteger);
        Caption := Fields[1].AsString;
        SubItems.Add(Fields[2].AsString);
        Next;
      end;
  finally
    lvValues.Items.EndUpdate;
    lvValues.Columns[1].Width := lvValues.ClientWidth
                               - lvValues.Columns[0].Width
                               - GetSystemMetrics(SM_CXVSCROLL);
    UpdateRecordCount;
    Free;
  end;
end;

procedure TDictionaryTwoDlg.lvValuesDeletion(Sender: TObject;
  Item: TListItem);
begin
  if Assigned(Item) then
  begin
    TID(Item.Data).Free;
    Item.Data := nil;
  end;
end;

procedure TDictionaryTwoDlg.btnSelectClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TDictionaryTwoDlg.btnAddClick(Sender: TObject);
begin
  inherited;
  AddValue;
end;

procedure TDictionaryTwoDlg.btnEditClick(Sender: TObject);
begin
  inherited;
  EditValue;
end;

procedure TDictionaryTwoDlg.btnDeleteClick(Sender: TObject);
begin
  inherited;
  if CBoxFmtB(SDeleteConfirm, [SelectedValue]) then
    DeleteValue;
end;

end.
