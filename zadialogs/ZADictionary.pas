unit ZADictionary;

interface

uses
  Classes, Controls, Forms, ZAPgSqlForm, ZASelectDlg, StdCtrls,
  ZAInputBox, ComCtrls;

type
  TDictionaryDlg = class(TSelectDialog)
    btnDelete: TButton;
    btnInsert: TButton;
    btnUpdate: TButton;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
  private
    fDeleteSql: String;
    fInsertSql: String;
    fUpdateSql: String;
    fInputDlg: TInputDlg;
    procedure deleteValue;
    function getAllowSelect: Boolean;
    function getPrompt: string;
    procedure insertValue;
    function newModifyQuery(const modifySQL: string): TZPgSqlQuery;
    procedure setAllowSelect(const Value: Boolean);
    procedure setDeleteSql(const Value: String);
    procedure setInsertSql(const Value: String);
    procedure setPrompt(const Value: string);
    procedure setUpdateSql(const Value: String);
    procedure updateValue;
  protected
    procedure doCreate; override;
  public
    property allowSelect: Boolean read getAllowSelect write setAllowSelect default False;
    ///////////////////////////////////////////////////////////////////////////
    //  ������ ��������� ������ "�������".
    ///////////////////////////////////////////////////////////////////////////

    property deleteSql: String read fDeleteSql write setDeleteSql;
    ///////////////////////////////////////////////////////////////////////////
    //  SQL ��� �������� ����������� ��������.
    //  ��������:
    //    delete from ������� where ���=:id
    //  ���
    //    select �������_��������_��_�������(:id)
    ///////////////////////////////////////////////////////////////////////////

    property insertSql: String read fInsertSql write setInsertSql;
    ///////////////////////////////////////////////////////////////////////////
    //  SQL ��� ������� ������ ��������.
    //  ������ ��������� ����� ������ � �������� �� �������������.
    //  ��������:
    //    insert into ������� (��������) values (:value);
    //    select currval('�������_�������')
    //  ���
    //    select ��������_��������_�_�������(:value)
    ///////////////////////////////////////////////////////////////////////////

    property prompt: string read getPrompt write setPrompt;
    ///////////////////////////////////////////////////////////////////////////
    //  ������ ��������� ������� ��� ����� ��������
    ///////////////////////////////////////////////////////////////////////////

    property updateSql: String read fUpdateSql write setUpdateSql;
    ///////////////////////////////////////////////////////////////////////////
    //  SQL ��� �������������� ����������� ��������.
    //  ��������:
    //    update ������� set ��������=:value where ���=:id
    //  ���
    //    select ��������_��������_�_�������(:value, :id)
    ///////////////////////////////////////////////////////////////////////////
  end;

implementation

uses ZAApplicationUtils, ZAConst, SysUtils;

{$R *.dfm}

procedure TDictionaryDlg.deleteValue;
begin
  with newModifyQuery(fDeleteSql) do
  try
    case withID of
      withIntegerID:
        ParamByName('id').AsInteger := Integer(selectedObject);

      withStringID:
        ParamByName('id').AsString := string(selectedObject);

      withoutID:
        ParamByName('value').AsString := selectedText;
    end;
    try
      ExecSql;
      ListBox.DeleteSelected;
      updateRecordCount;
    except
      on e: Exception do
        raise Exception.Create(e.Message);
    end;
  finally
    Free;
  end;
end;

function TDictionaryDlg.getAllowSelect: Boolean;
begin
  Result := btnSelect.Visible;
end;

function TDictionaryDlg.getPrompt: string;
begin
  Result := fInputDlg.prompt;
end;

procedure TDictionaryDlg.insertValue;
begin
  with newModifyQuery(fInsertSql) do
  try
    ParamByName('value').AsString := fInputDlg.value;
    try
      Open;
      case withID of
        withIntegerID:
          ListBox.Items.AddObject(fInputDlg.value, TObject(Fields[0].AsInteger));

        withStringID:
          ListBox.Items.AddObject(fInputDlg.value, TObject(Fields[0].AsString));

        withoutID:
          ListBox.Items.Add(fInputDlg.value);
      end;
      updateRecordCount;
    except
      on e: Exception do
        raise Exception.Create(e.Message);
    end;
  finally
    Free;
  end;
end;

function TDictionaryDlg.newModifyQuery(const modifySQL: string): TZPgSqlQuery;
begin
  Result := newQuery;
  Result.Sql.Text := modifySQL;
end;

procedure TDictionaryDlg.setAllowSelect(const Value: Boolean);
begin
  btnSelect.Visible := Value;
end;

procedure TDictionaryDlg.setDeleteSql(const Value: String);
begin
  if fDeleteSql <> Value then
    fDeleteSql := Value;
end;

procedure TDictionaryDlg.setInsertSql(const Value: String);
begin
  if fInsertSql <> Value then
    fInsertSql := Value;
end;

procedure TDictionaryDlg.setPrompt(const Value: string);
begin
  fInputDlg.prompt := Value;
end;

procedure TDictionaryDlg.setUpdateSql(const Value: String);
begin
  if fUpdateSql <> Value then
    fUpdateSql := Value;
end;

procedure TDictionaryDlg.updateValue;
begin
  with newModifyQuery(fUpdateSql) do
  try
    ParamByName('value').AsString := fInputDlg.value;
    case withID of
      withIntegerID:
        ParamByName('id').AsInteger := Integer(selectedObject);

      withStringID:
        ParamByName('id').AsString := string(selectedObject);

      withoutID:
        ParamByName('value').AsString := selectedText;
    end;
    try
      ExecSql;
      ListBox.Items[ListBox.ItemIndex] := fInputDlg.value;
    except
      on e: Exception do
        raise Exception.Create(e.Message);
    end;
  finally
    Free;
  end;
end;

procedure TDictionaryDlg.doCreate;
begin
  inherited doCreate;

  fInputDlg := TInputDlg.Create(Self);
  fInputDlg.checkInput := True;
end;

procedure TDictionaryDlg.btnDeleteClick(Sender: TObject);
begin
  if ListBox.ItemIndex = NullIndex then
    WBox(SWarningSelect)
  else
    if CBoxFmtB('������� "%s"?', [selectedText]) then
      deleteValue;
end;

procedure TDictionaryDlg.btnInsertClick(Sender: TObject);
begin
  fInputDlg.clear;
  if fInputDlg.execute
    then insertValue;
end;

procedure TDictionaryDlg.btnUpdateClick(Sender: TObject);
begin
  if ListBox.ItemIndex = NullIndex then
    WBox(SWarningSelect)
  else
  begin
    fInputDlg.value := selectedText;
    if fInputDlg.execute
      then updateValue;
  end;
end;

procedure TDictionaryDlg.ListBoxDblClick(Sender: TObject);
begin
  if AllowSelect then
    inherited
  else
    btnUpdate.Click;
end;

end.
