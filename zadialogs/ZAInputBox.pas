unit ZAInputBox;

interface

uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls;

type
  TInputDlg = class(TForm)
    lblPrompt: TLabel;
    edtValue: TEdit;
    bvlBottom: TBevel;
    btnOk: TButton;
    btnCancel: TButton;
    btnShowMemo: TButton;
    mmoValue: TMemo;
    procedure btnShowMemoClick(Sender: TObject);
    procedure edtValueChange(Sender: TObject);
    procedure edtValueEnter(Sender: TObject);
    procedure mmoValueEnter(Sender: TObject);
    procedure mmoValueExit(Sender: TObject);
    procedure mmoValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fCheckInput: Boolean;
    fOldValue: string;
    fIsEditMode: Boolean;
    function getPrompt: string;
    function getValue: string;
    procedure setCheckInput(const AValue: Boolean);
    procedure setIsEditMode(const AValue: Boolean);
    procedure setPrompt(const AValue: string);
    procedure setValue(const AValue: string);
  protected
    procedure Activate; override;
    procedure doCheckInput; dynamic;
  public
    property checkInput: Boolean read fCheckInput write setCheckInput default False;
    procedure clear; dynamic;
    function execute: Boolean; dynamic;
    property isEditMode: Boolean read fIsEditMode write setIsEditMode;
    property prompt: string read getPrompt write setPrompt;
    property value: string read getValue write setValue;
    function valueIsNull: Boolean;
    function valueIsReady: Boolean;
  end;

function InputBox(const SCaption, SPrompt: String; var SValue: String): Boolean;

implementation

uses ZAConst, Windows;

{$R *.dfm}

function InputBox(const SCaption, SPrompt: String; var SValue: String): Boolean;
begin
  with TInputDlg.Create(Application) do
  try
    Caption := SCaption;
    prompt := SPrompt;
    value := SValue;
    Result := execute;
    if Result then
      SValue := value;
  finally
    Free;
  end;
end;

{ TInputDlg }

function TInputDlg.getPrompt: string;
begin
  Result := lblPrompt.Caption;
end;

function TInputDlg.getValue: string;
begin
  Result := edtValue.Text;
end;

procedure TInputDlg.setCheckInput(const AValue: Boolean);
begin
  if fCheckInput <> AValue then
    fCheckInput := AValue;
end;

procedure TInputDlg.setIsEditMode(const AValue: Boolean);
begin
  if fIsEditMode <> AValue then
    fIsEditMode := AValue;
end;

procedure TInputDlg.setPrompt(const AValue: string);
begin
  lblPrompt.Caption := AValue;
end;

procedure TInputDlg.setValue(const AValue: string);
begin
  fOldValue := AValue;
  edtValue.Text := AValue;
  isEditMode := True;
end;

procedure TInputDlg.Activate;
begin
  inherited Activate;

  edtValue.SetFocus;
end;

procedure TInputDlg.doCheckInput;
begin
  btnOk.Enabled := valueIsReady;
end;

procedure TInputDlg.clear;
begin
  value := SNull;
  isEditMode := False;
end;

function TInputDlg.execute: Boolean;
begin
  Result := IsPositiveResult(ShowModal);
end;

function TInputDlg.valueIsNull: Boolean;
begin
  Result := value = SNull;
end;

function TInputDlg.valueIsReady: Boolean;
begin
  if isEditMode then
    Result := (value <> fOldValue) and (value <> SNull)
  else
    Result := (value <> SNull);
end;

procedure TInputDlg.btnShowMemoClick(Sender: TObject);
begin
  if mmoValue.Visible then
  begin
    edtValue.Text := mmoValue.Lines.Text;
    edtValue.SetFocus;
    edtValue.SelStart := Length(value);
    mmoValue.Hide;
  end
  else
  begin
    mmoValue.Lines.Text := value;
    mmoValue.Show;
    mmoValue.SetFocus;
    mmoValue.SelStart := Length(mmoValue.Text);
  end;
end;

procedure TInputDlg.edtValueChange(Sender: TObject);
begin
  if CheckInput then
    doCheckInput
  else
    btnOk.Enabled := True;
end;

procedure TInputDlg.edtValueEnter(Sender: TObject);
begin
  btnOk.Default := True;
  edtValue.SelectAll;
end;

procedure TInputDlg.mmoValueEnter(Sender: TObject);
begin
  btnOk.Default := False;
end;

procedure TInputDlg.mmoValueExit(Sender: TObject);
begin
  btnShowMemo.Click;
end;

procedure TInputDlg.mmoValueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN
    then btnShowMemo.Click;
end;

end.
