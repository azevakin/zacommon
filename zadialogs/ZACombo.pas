unit ZACombo;

interface

uses
  Classes, Controls, Forms, ZAPgSqlDialog, StdCtrls;

type
  TComboDlg = class(TPgSqlDlg)
    gbValues: TGroupBox;
    cbValues: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    procedure cbValuesChange(Sender: TObject);
  private
    function GetPrompt: string;
    procedure SetPrompt(const Value: string);
  protected
    procedure DoShow; override;
  public
    SelectSQL: string;
    property Prompt: string read GetPrompt write SetPrompt;
    function SelectedID: Integer;
  end;

implementation

uses ZAClasses;

{$R *.dfm}

{ TComboDlg }

procedure TComboDlg.DoShow;
begin
  inherited;

  with OpenQuery(SelectSQL) do
  try
    cbValues.Items.BeginUpdate;
    try
      while not Eof do
      begin
        Application.ProcessMessages;
        cbValues.Items.AddObject(Fields[0].AsString, TID.Create(Fields[1]));
        Next;                       
      end;
    finally
      cbValues.Items.EndUpdate;
    end;   
  finally
    Free;
  end;
end;

function TComboDlg.GetPrompt: string;
begin
  Result := gbValues.Caption;
end;

function TComboDlg.SelectedID: Integer;
begin
  Result := TID(cbValues.Items.Objects[ cbValues.ItemIndex ]).Id;
end;

procedure TComboDlg.SetPrompt(const Value: string);
begin
  gbValues.Caption := Value;
end;

procedure TComboDlg.cbValuesChange(Sender: TObject);
begin
  inherited;
  btnOk.Enabled := (Sender as TComboBox).ItemIndex <> -1;
end;

end.
