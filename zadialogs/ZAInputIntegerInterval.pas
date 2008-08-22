unit ZAInputIntegerInterval;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls, NumberEdit;

type
  TInputIntegerInterval = class(TForm)
    edtBegin: TNumberEdit;
    edtEnd: TNumberEdit;
    bvl1: TBevel;
    btnOk: TButton;
    btnCancel: TButton;
    lblBegin: TLabel;
    lblEnd: TLabel;
    procedure ChangeInterval(Sender: TObject);
  private
    FAllowNegative: Boolean;
    function GetBeginInterval: Integer;
    function GetBeginIntervalPrompt: string;
    function GetEndInterval: Integer;
    function GetEndIntervalPrompt: string;
    procedure SetAllowNegative(const Value: Boolean);
    procedure SetBeginInterval(const Value: Integer);
    procedure SetBeginIntervalPrompt(const Value: string);
    procedure SetEndInterval(const Value: Integer);
    procedure SetEndIntervalPrompt(const Value: string);
  public
    property AllowNegative: Boolean read FAllowNegative write SetAllowNegative;
    property BeginInterval: Integer read GetBeginInterval write SetBeginInterval;
    property BeginIntervalPrompt: string read GetBeginIntervalPrompt write SetBeginIntervalPrompt;
    property EndInterval: Integer read GetEndInterval write SetEndInterval;
    property EndIntervalPrompt: string read GetEndIntervalPrompt write SetEndIntervalPrompt;
    function Execute: Boolean;
  end;

function inputYearsInterval(var yBegin, yEnd: Word): Boolean;

implementation

uses ZAStdCtrlsUtils;

{$R *.dfm}


function inputYearsInterval(var yBegin, yEnd: Word): Boolean;
begin
  with TInputIntegerInterval.Create(Application) do
  try
    AllowNegative := False;
    Caption := 'Введите интервал лет';
    BeginIntervalPrompt := 'Год начала';
    EndIntervalPrompt := 'Год окончания';
    Result := Execute;
    if Result then
    begin
      yBegin := BeginInterval;
      yEnd := EndInterval;
    end;  
  finally
    Free;
  end;
end;


{ TInputIntegerInterval }

function TInputIntegerInterval.Execute: Boolean;
begin
  Result := IsPositiveResult(ShowModal);
end;

function TInputIntegerInterval.GetBeginInterval: Integer;
begin
  Result := StrToInt(edtBegin.Text);
end;

function TInputIntegerInterval.GetBeginIntervalPrompt: string;
begin
  Result := lblBegin.Caption;
end;

function TInputIntegerInterval.GetEndInterval: Integer;
begin
  Result := StrToInt(edtEnd.Text);
end;

function TInputIntegerInterval.GetEndIntervalPrompt: string;
begin
  Result := lblEnd.Caption;
end;

procedure TInputIntegerInterval.SetAllowNegative(const Value: Boolean);
begin
  if FAllowNegative <> Value then
  begin
    FAllowNegative := Value;
    edtBegin.AllowNegative := Value;
    edtEnd.AllowNegative := Value;
  end;
end;

procedure TInputIntegerInterval.SetBeginInterval(const Value: Integer);
begin
  edtBegin.Text := IntToStr(Value);
end;

procedure TInputIntegerInterval.SetBeginIntervalPrompt(
  const Value: string);
begin
  lblBegin.Caption := Value;
end;

procedure TInputIntegerInterval.SetEndInterval(const Value: Integer);
begin
  edtEnd.Text := IntToStr(Value);
end;

procedure TInputIntegerInterval.SetEndIntervalPrompt(const Value: string);
begin
  lblEnd.Caption := Value;
end;

procedure TInputIntegerInterval.ChangeInterval(Sender: TObject);
begin
  btnOk.Enabled := not IsEmpty(edtBegin) and not IsEmpty(edtEnd);
end;

end.
