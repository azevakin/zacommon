unit ZAThreeValue;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, StdCtrls, ZAPgSqlForm;

type
  TThreeCheck = packed record
    First:  Boolean;
    Second: Boolean;
    Third:  Boolean;
  end;

  TInputForm = class(TPgSqlForm)
    FirstEdit: TEdit;
    FirstLabel: TLabel;
    SecondEdit: TEdit;
    SecondLabel: TLabel;
    ThirdEdit: TEdit;
    ThirdLabel: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FirstEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FCheckInput: Boolean;
    FLastActiveControl: TControl;
    FRequiredValue: TThreeCheck;
    FCloseAction: TCloseAction;
    function IsEmpty(Value: TEdit): Boolean;
    procedure CheckValues;
    procedure SetCheckInput(const Value: Boolean);
    procedure SetRequiredValue(const Value: TThreeCheck);
  public
    property CheckInput: Boolean read FCheckInput write SetCheckInput;
    property LastActiveControl: TControl read FLastActiveControl;
    property RequiredValue: TThreeCheck read FRequiredValue write SetRequiredValue;
  end;

  function ThreeCheck(const First, Second, Third: Boolean): TThreeCheck;


implementation

{$R *.dfm}

uses ZAApplicationUtils;

function ThreeCheck(const First, Second, Third: Boolean): TThreeCheck;
begin
  Result.First := First;
  Result.Second := Second;
  Result.Third := Third;
end;

function IsEqual(const First, Second: TThreeCheck): Boolean;
begin
  Result := (First.First = Second.First) and
    (First.Second = Second.Second) and (First.Third = Second.Third);
end;

{ TInputForm }

function TInputForm.IsEmpty(Value: TEdit): Boolean;
begin
  Result := Length(Trim(Value.Text)) = 0;
end;

procedure TInputForm.CheckValues;
const
  wmessage = '¬ведите значение';
begin
  if Self.Visible and CheckInput then
  begin
    if RequiredValue.First and IsEmpty(FirstEdit) then
    begin
      WBox(wmessage);
      FirstEdit.SetFocus;
      FCloseAction := caNone;
      Exit;
    end;

    if RequiredValue.Second and IsEmpty(SecondEdit) then
    begin
      WBox(wmessage);
      SecondEdit.SetFocus;
      FCloseAction := caNone;
      Exit;
    end;

    if RequiredValue.Third and IsEmpty(ThirdEdit) then
    begin
      WBox(wmessage);
      ThirdEdit.SetFocus;
      FCloseAction := caNone;
      Exit;
    end;
  end;
end;

procedure TInputForm.FirstEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(CM_DialogKey, VK_Tab, 0);
end;

procedure TInputForm.SetRequiredValue(const Value: TThreeCheck);
begin
  if not IsEqual(FRequiredValue, Value) then
  begin
    FRequiredValue := Value;
    CheckValues;
  end;
end;

procedure TInputForm.SetCheckInput(const Value: Boolean);
begin
  if FCheckInput <> Value then
  begin
    FCheckInput := Value;
    CheckValues;
  end;
end;

procedure TInputForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := FCloseAction;
end;

procedure TInputForm.FormCreate(Sender: TObject);
begin
  inherited;
  FCloseAction := caHide;
end;

procedure TInputForm.btnOkClick(Sender: TObject);
begin
  inherited;
  CheckValues;
end;

procedure TInputForm.btnCancelClick(Sender: TObject);
begin
  inherited;
  FCloseAction := caHide;
end;

end.
