unit ZACustomDictionary;

interface

uses
  Classes, Controls, Forms, ZAPgSqlDialog, ComCtrls, StdCtrls, ZAPgSqlForm,
  ExtCtrls;

type
  TCustomDictionaryDlg = class(TPgSqlDlg)
    btnSelect: TButton;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnCancel: TButton;
    StatusBar: TStatusBar;
    pnlRight: TPanel;
    pnlSelect: TPanel;
    pnlButtons: TPanel;
    pnlLeft: TPanel;
    pnlAdd: TPanel;
    pnlEdit: TPanel;
    pnlOther: TPanel;
    pnlDelete: TPanel;
  private
    function GetAllowAdd: Boolean;
    function GetAllowDelete: Boolean;
    function GetAllowEdit: Boolean;
    function GetAllowSelect: Boolean;
    procedure SetAllowAdd(const BValue: Boolean);
    procedure SetAllowDelete(const BValue: Boolean);
    procedure SetAllowEdit(const BValue: Boolean);
    procedure SetAllowSelect(const BValue: Boolean);
  protected
    procedure DoShow; override;

    procedure LoadValues; virtual;
    ///////////////////////////////////////////////////////////////////////////
    //  Заполняет форму данными.
    ///////////////////////////////////////////////////////////////////////////

    procedure SetButtonsEnabled(const BValue: Boolean);
    ///////////////////////////////////////////////////////////////////////////
    //  Задает активность(Enabled) кнопкам(Выбрать, Изменить, Удалить).
    ///////////////////////////////////////////////////////////////////////////

    procedure UpdateRecordCount; virtual;
    ///////////////////////////////////////////////////////////////////////////
    //  Задает количество записей в строке статуса.
    ///////////////////////////////////////////////////////////////////////////
  public
    property AllowAdd: Boolean read GetAllowAdd write SetAllowAdd;
    ///////////////////////////////////////////////////////////////////////////
    //  Задает видимость кнопки "Добавить".
    ///////////////////////////////////////////////////////////////////////////

    property AllowEdit: Boolean read GetAllowEdit write SetAllowEdit;
    ///////////////////////////////////////////////////////////////////////////
    //  Задает видимость кнопки "Изменить".
    ///////////////////////////////////////////////////////////////////////////

    property AllowDelete: Boolean read GetAllowDelete write SetAllowDelete;
    ///////////////////////////////////////////////////////////////////////////
    //  Задает видимость кнопки "Удалить".
    ///////////////////////////////////////////////////////////////////////////

    property AllowSelect: Boolean read GetAllowSelect write SetAllowSelect;
    ///////////////////////////////////////////////////////////////////////////
    //  Задает видимость кнопки "Выбрать".
    ///////////////////////////////////////////////////////////////////////////
  end;


implementation

{$R *.dfm}

{ TCustomDictionaryDlg }

function TCustomDictionaryDlg.GetAllowAdd: Boolean;
begin
  Result := btnAdd.Visible;
end;

function TCustomDictionaryDlg.GetAllowDelete: Boolean;
begin
  Result := btnDelete.Visible;
end;

function TCustomDictionaryDlg.GetAllowEdit: Boolean;
begin
  Result := btnEdit.Visible;
end;

function TCustomDictionaryDlg.GetAllowSelect: Boolean;
begin
  Result := pnlSelect.Visible;
end;

procedure TCustomDictionaryDlg.SetAllowAdd(const BValue: Boolean);
begin
  btnAdd.Visible := BValue;
end;

procedure TCustomDictionaryDlg.SetAllowDelete(const BValue: Boolean);
begin
  btnDelete.Visible := BValue;
end;

procedure TCustomDictionaryDlg.SetAllowEdit(const BValue: Boolean);
begin
  btnEdit.Visible := BValue;
end;

procedure TCustomDictionaryDlg.SetAllowSelect(const BValue: Boolean);
begin
  pnlSelect.Visible := BValue;
end;

procedure TCustomDictionaryDlg.DoShow;
begin
  inherited;
  LoadValues;
end;

procedure TCustomDictionaryDlg.LoadValues;
begin

end;

procedure TCustomDictionaryDlg.SetButtonsEnabled(const BValue: Boolean);
begin
  btnSelect.Enabled := BValue;
  btnEdit.Enabled := BValue;
  btnDelete.Enabled := BValue;
end;

procedure TCustomDictionaryDlg.UpdateRecordCount;
begin
  StatusBar.Panels[1].Text := 'количество записей:';
end;

end.
