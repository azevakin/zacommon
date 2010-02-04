unit ZeosInputBox;

interface

uses
  SysUtils, Classes, Controls, Forms, ZeosInputDialog, ExtCtrls, StdCtrls;

type
  TInputBox = class(TZeosInputDlg)
    edtValue: TLabeledEdit;
    bvl1: TBevel;
    procedure edtValueChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    OldValue: string;
    FCaptions: array[Boolean] of string;
    FSQLs: array[Boolean] of string;
    function GetValue: string;
    procedure SetValue(const Value: string);
    function OldValueQuoted: string;
    function ValueQuoted: string;
    procedure SetPrompt(const Value: string);
    function GetSQLs(const IsInsert: Boolean): string;
    function GetCaptions(const IsInsert: Boolean): string;
    procedure SetCaptions(const IsInsert: Boolean; const AValue: string);
    procedure SetSQLs(const IsInsert: Boolean; const AValue: string);
    function GetPrompt: string;
  public
    property Captions[const IsInsert: Boolean]: string read GetCaptions write SetCaptions;
    property Prompt: string read GetPrompt write SetPrompt;
    property SQLs[const IsInsert: Boolean]: string read GetSQLs write SetSQLs;
    property Value: string read GetValue write SetValue;
  end;

var
  InputBox: TInputBox;

implementation

{$R *.dfm}

{ TInputBox }

function TInputBox.GetValue: string;
begin
  Result := Trim(Self.edtValue.Text);
end;

procedure TInputBox.SetValue(const Value: string);
begin
  Self.OldValue := Value;
  Self.edtValue.Text := Value;
  Self.Caption := Self.Captions[False];
end;

procedure TInputBox.edtValueChange(Sender: TObject);
begin
  btnOk.Enabled := ((Self.OldValue = '') and (Self.edtValue.Text <> ''))
    or ((Self.OldValue <> '') and (Self.edtValue.Text <> '') and (Self.edtValue.Text <> Self.OldValue));
end;

procedure TInputBox.btnOkClick(Sender: TObject);
begin
  inherited;
  with ExecQuery(SQLs[OldValue=''], [ValueQuoted, OldValueQuoted]) do
  try
    ModalResult := mrOk;
  finally
    Free;
  end;    
end;

function TInputBox.ValueQuoted: string;
begin
  Result := QuotedStr(Self.Value);
end;

function TInputBox.OldValueQuoted: string;
begin
  Result := QuotedStr(Self.OldValue);
end;

function TInputBox.GetPrompt: string;
begin
  Result := edtValue.EditLabel.Caption;
end;

procedure TInputBox.SetPrompt(const Value: string);
begin
  edtValue.EditLabel.Caption := Value;
end;

function TInputBox.GetSQLs(const IsInsert: Boolean): string;
begin
  Result := FSQLs[IsInsert];
end;

procedure TInputBox.SetSQLs(const IsInsert: Boolean;
  const AValue: string);
begin
  FSQLs[IsInsert] := AValue;
end;

function TInputBox.GetCaptions(const IsInsert: Boolean): string;
begin
  Result := FCaptions[IsInsert];
end;

procedure TInputBox.SetCaptions(const IsInsert: Boolean; const AValue: string);
begin
  FCaptions[IsInsert] := AValue;
  if IsInsert then
    Self.Caption := AValue;
end;

end.
