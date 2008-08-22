unit selectStudents;

interface

uses
  Classes, Controls, Forms, ZAPgSqlForm, StdCtrls, ExtCtrls, ComCtrls,
  coolListView, ZABobDlg;

type
  TSelectStudentsDlg = class(TPgSqlForm)
    Bevel: TBevel;
    doSubmit: TButton;
    doClose: TButton;
    prompt: TLabel;
    listView: TCoolListView;
  private
    fQueryForSelect: TZPgSqlQuery;
  protected
    procedure doShow; override;
  public
    constructor Create(AOwner: TComponent; ATransaction: TZPgSqlTransact); override;
    function execute: Boolean;
    procedure fillForm;
    property queryForSelect: TZPgSqlQuery read fQueryForSelect write fQueryForSelect;
  end;

implementation

uses SysUtils, ZAConst;

{$R *.dfm}

constructor TSelectStudentsDlg.Create(AOwner: TComponent;
  ATransaction: TZPgSqlTransact);
begin
  inherited Create(AOwner, ATransaction);
  fQueryForSelect := Self.NewQuery;
end;

function TSelectStudentsDlg.execute: Boolean;
begin
  Result := IsPositiveResult(Self.ShowModal);
end;

procedure TSelectStudentsDlg.fillForm;
var
  i, len: Integer;
begin
  fQueryForSelect.Open;
  try
    listView.Items.BeginUpdate;
    try
      listView.Items.Clear;
      len := fQueryForSelect.FieldCount-1;
      while not fQueryForSelect.Eof do
        with listView.Items.Add do
        begin
          for i := 1 to len do
            SubItems.Add(fQueryForSelect.Fields[i].AsString);

          Data := Pointer(fQueryForSelect.Fields[0].AsInteger);
          fQueryForSelect.Next;
        end;
    finally
      listView.Items.EndUpdate;
    end;
  finally
    fQueryForSelect.Close;
  end;
end;

procedure TSelectStudentsDlg.doShow;
begin
  if fQueryForSelect.Sql.Count = 0 then
    raise Exception.Create('ОШИБКА: Не задан SQL для получения данных')
  else
    with showBobDlg(SPleaseWait) do
    try
      FillForm;
    finally
      Free;
    end;

  inherited doShow;
end;

end.
