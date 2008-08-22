unit ZASelectDlg;

interface

uses
  Classes, Messages, Controls, Forms, StdCtrls, ExtCtrls, ComCtrls, ZAPgSqlForm;

type
  TWithID = (withIntegerID, withStringID, withoutID);

  TSelectDialog = class(TPgSqlForm)
    Edit: TEdit;
    ListBox: TListBox;
    btnSelect: TButton;
    btnCancel: TButton;
    StatusBar: TStatusBar;
    procedure EditChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure EditEnter(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
    procedure EditExit(Sender: TObject);
  private
    fQuery: TZPgSqlQuery;
    fWithID: TWithID;
    procedure fillForm;
    procedure fillWithIntegerID;
    procedure fillWithStringID;
    procedure fillWithoutID;
    procedure SetWithID(const Value: TWithID);
  protected
    procedure updateRecordCount;
    procedure doCreate; override;
    procedure doShow; override;
  public
    function execute: boolean;
    ///////////////////////////////////////////////////////////////////////////
    // ���������� ��������� ������.
    ///////////////////////////////////////////////////////////////////////////

    function selectedObject: TObject;
    ///////////////////////////////////////////////////////////////////////////
    // ���������� Object ����������� ��������
    ///////////////////////////////////////////////////////////////////////////

    function selectedText: string;
    ///////////////////////////////////////////////////////////////////////////
    // ���������� ����� ����������� ��������
    ///////////////////////////////////////////////////////////////////////////

    property queryForSelect: TZPgSqlQuery read fQuery write fQuery;
    ///////////////////////////////////////////////////////////////////////////
    // Query ��� �������� ������.
    // SQL ������ ���� ���� "select ����, ��� from �������".
    // ����� � ���� WithID ����� ������� ��� ��������������.
    ///////////////////////////////////////////////////////////////////////////

    property withID: TWithID read fWithID write SetWithID default withIntegerID;
    ///////////////////////////////////////////////////////////////////////////
    // ������ ������� �������������� � ������� � ��� ���.
    // ���� �������� ����� withoutID ������ �������������� ���.
    ///////////////////////////////////////////////////////////////////////////
  end;

implementation

uses SysUtils, ZAConst, ZAApplicationUtils;

{$R *.dfm}

{ TSelectDialog }

procedure TSelectDialog.doCreate;
begin
  inherited doCreate;
  fWithID := withIntegerID; 
  fQuery := NewQuery;
end;

procedure TSelectDialog.doShow;
begin
  Edit.Text := SEnterTextForSearch;

  if fQuery.Sql.Count = 0 then
    raise Exception.Create('������: �� ����� SQL ��� ��������� ������')
  else
  begin
    Screen.Cursor := crHourGlass;
    try
      fillForm;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

function TSelectDialog.execute: boolean;
begin
  Result := IsPositiveResult(ShowModal);
end;

procedure TSelectDialog.SetWithID(const Value: TWithID);
begin
  if Value <> fWithID then
    fWithID := Value;
end;

procedure TSelectDialog.fillWithIntegerID;
begin
   while not fQuery.Eof do
  begin
    Application.ProcessMessages;
    ListBox.Items.AddObject(fQuery.Fields[0].AsString,
      TObject(fQuery.Fields[1].AsInteger));
    fQuery.Next;
  end;
end;

procedure TSelectDialog.fillWithStringID;
begin
  while not fQuery.Eof do
  begin
    Application.ProcessMessages;
    ListBox.Items.AddObject(fQuery.Fields[0].AsString,
      TObject(fQuery.Fields[1].AsString));
    fQuery.Next;
  end;
end;

procedure TSelectDialog.fillWithoutID;
begin
  while not fQuery.Eof do
  begin
    Application.ProcessMessages;
    ListBox.Items.Add(fQuery.Fields[0].AsString);
    fQuery.Next;
  end;
end;

procedure TSelectDialog.fillForm;
begin
  fQuery.Open;
  try
    ListBox.Items.BeginUpdate;
    try
      ListBox.Items.Clear;
      case WithID of
        withIntegerID:
          fillWithIntegerID;

        withStringID:
          fillWithStringID;

        withoutID:
          fillWithoutID;
      end;
    finally
      ListBox.Items.EndUpdate;
    end;
  finally
    updateRecordCount;
    fQuery.Close;
  end;
end;

procedure TSelectDialog.EditChange(Sender: TObject);
begin
  ListBox.Perform(LB_SELECTSTRING, 0, Integer(PChar(Edit.Text)));
end;

procedure TSelectDialog.EditEnter(Sender: TObject);
begin
  if Edit.Text = SEnterTextForSearch then
    Edit.Text := SNull;
end;

procedure TSelectDialog.EditExit(Sender: TObject);
begin
  if Edit.Text = SNull then
    Edit.Text := SEnterTextForSearch;
end;

procedure TSelectDialog.btnSelectClick(Sender: TObject);
begin
  if ListBox.ItemIndex = NullIndex then
    WBox('�������� ������� �� ������!')
  else
  begin
    if fsModal in FormState then
      ModalResult := mrOk
    else
      Close;
  end;
end;

procedure TSelectDialog.ListBoxDblClick(Sender: TObject);
begin
  btnSelect.Click;
end;

procedure TSelectDialog.btnCancelClick(Sender: TObject);
begin
  if fsModal in FormState then
    ModalResult := mrCancel
  else
    Close;
end;

function TSelectDialog.selectedObject: TObject;
begin
  Result := ListBox.Items.Objects[ListBox.ItemIndex];
end;

function TSelectDialog.selectedText: string;
begin
  Result := ListBox.Items.Strings[ListBox.ItemIndex];
end;

procedure TSelectDialog.updateRecordCount;
begin
  StatusBar.Panels[1].Text := IntToStr(ListBox.Items.Count);
end;

end.
