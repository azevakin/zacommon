unit ZeosCommonDictionary;

interface

uses
  Classes, Controls, Forms, ComCtrls, StdCtrls, ZeosCommonForm, ZeosCommonDialog,
  ExtCtrls;

type
  TZeosCommonDictionaryDlg = class(TZeosCommonDlg)
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
    FAfterLoad: TNotifyEvent;
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
    //==========================================================================
    //  Заполняет форму данными.
    //==========================================================================

    procedure SetButtonsEnabled(const BValue: Boolean);
    //==========================================================================
    //  Задает активность(Enabled) кнопкам(Выбрать, Изменить, Удалить).
    //==========================================================================

    procedure UpdateRecordCount; virtual;
    //==========================================================================
    //  Задает количество записей в строке статуса.
    //==========================================================================
  public
    property AllowAdd: Boolean read GetAllowAdd write SetAllowAdd;
    //==========================================================================
    //  Задает видимость кнопки "Добавить".
    //==========================================================================

    property AllowEdit: Boolean read GetAllowEdit write SetAllowEdit;
    //==========================================================================
    //  Задает видимость кнопки "Изменить".
    //==========================================================================

    property AllowDelete: Boolean read GetAllowDelete write SetAllowDelete;
    //==========================================================================
    //  Задает видимость кнопки "Удалить".
    //==========================================================================

    property AllowSelect: Boolean read GetAllowSelect write SetAllowSelect;
    //==========================================================================
    //  Задает видимость кнопки "Выбрать".
    //==========================================================================

    property AfterLoad: TNotifyEvent read FAfterLoad write FAfterLoad;
  end;


implementation

{$R *.dfm}

{ TCustomDictionaryDlg }

function TZeosCommonDictionaryDlg.GetAllowAdd: Boolean;
begin
  Result := btnAdd.Visible;
end;

function TZeosCommonDictionaryDlg.GetAllowDelete: Boolean;
begin
  Result := btnDelete.Visible;
end;

function TZeosCommonDictionaryDlg.GetAllowEdit: Boolean;
begin
  Result := btnEdit.Visible;
end;

function TZeosCommonDictionaryDlg.GetAllowSelect: Boolean;
begin
  Result := pnlSelect.Visible;
end;

procedure TZeosCommonDictionaryDlg.SetAllowAdd(const BValue: Boolean);
begin
  btnAdd.Visible := BValue;
end;

procedure TZeosCommonDictionaryDlg.SetAllowDelete(const BValue: Boolean);
begin
  btnDelete.Visible := BValue;
end;

procedure TZeosCommonDictionaryDlg.SetAllowEdit(const BValue: Boolean);
begin
  btnEdit.Visible := BValue;
end;

procedure TZeosCommonDictionaryDlg.SetAllowSelect(const BValue: Boolean);
begin
  pnlSelect.Visible := BValue;
end;

procedure TZeosCommonDictionaryDlg.DoShow;
begin
  inherited;
  LoadValues;
  if Assigned(FAfterLoad) then
    FAfterLoad(Self);
end;

procedure TZeosCommonDictionaryDlg.LoadValues;
begin

end;

procedure TZeosCommonDictionaryDlg.SetButtonsEnabled(const BValue: Boolean);
begin
  btnSelect.Enabled := BValue;
  btnEdit.Enabled := BValue;
  btnDelete.Enabled := BValue;
end;

procedure TZeosCommonDictionaryDlg.UpdateRecordCount;
begin
  StatusBar.Panels[1].Text := 'количество записей:';
end;

end.
