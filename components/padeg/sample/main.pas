unit main;

interface

uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    rg: TRadioGroup;
    lastName: TEdit;
    lastNameLabel: TLabel;
    firstName: TEdit;
    firstNameLabel: TLabel;
    middleName: TEdit;
    middleNameLabel: TLabel;
    btnDeclension: TButton;
    gb: TGroupBox;
    declenResult: TEdit;
    rgSex: TRadioGroup;
    procedure btnDeclensionClick(Sender: TObject);
  private
    function padeg: Integer;
    function sex: Boolean;
  end;

implementation

{$R *.dfm}

uses declen;

function TMainForm.padeg: Integer;
begin
  Result := rg.ItemIndex+1;
end;

function TMainForm.sex: Boolean;
begin
  Result := rgSex.ItemIndex = 0;
end;

procedure TMainForm.btnDeclensionClick(Sender: TObject);
begin
  declenResult.Text := GetFIOPadegString(
    lastName.Text, firstName.Text, middleName.Text, sex, padeg);
end;

end.
