unit ZADialogs;

interface

uses Forms, Classes, Controls, StdCtrls, ExtCtrls;

type
  TQuarterRec = packed record
    Year: Word;
    Quarter: Word;
  end;

  TRadioDlg = class(TComponent)
  private
    Form: TForm;
    Radio: TRadioGroup;
    btnCancel: TButton;
    btnOk: TButton;
    function GetRadioItems: TStrings;
    procedure OkClick(Sender: TObject);
    function GetRadioIndex: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    function AddRadioItem(S: String; AObject: TObject): Integer;
    function ShowModal: Integer;
    property RadioIndex: Integer read GetRadioIndex;
    property RadioItems: TStrings read GetRadioItems;
  end;


function InputBox(const ACaption, APrompt, ADefault: string): string;
function InputYear(var AYear: Word): Boolean;
function InputMoney(const ACaption, APrompt: string; var AMoney: Extended): Boolean; overload;
function InputMoney(var AMoney: Extended): Boolean; overload;
function InputQuarter(var AQuarter: TQuarterRec; const withAll: Boolean = True): Boolean;
function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;

implementation

uses Windows, Graphics, SysUtils, NumberEdit, ZAApplicationUtils;

const
  iIndent = 10;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..63] of Char;
begin
  for I := 0 to 31 do Buffer[I] := Chr(I + Ord('А'));
  for I := 0 to 31 do Buffer[I + 32] := Chr(I + Ord('а'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 64, TSize(Result));
  Result.X := Result.X div 64;
end;

{ Диалоги для ввода данных }

function InputQuery(const ACaption, APrompt: string;
  var Value: string): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Ok';
        ModalResult := IDOK;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Отмена';
        ModalResult := IDCANCEL;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = IDOK then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function InputBox(const ACaption, APrompt, ADefault: string): string;
begin
  Result := ADefault;
  InputQuery(ACaption, APrompt, Result);
end;

function InputYear(var AYear: Word): Boolean;
var
  sYear: String;
  Code: Integer;
begin
  if AYear = 0 then
    sYear := IntToStr(CurrentYear)
  else
    sYear := IntToStr(AYear);

  Result := InputQuery('Введите год', 'Год', sYear);

  if Result then
  begin
    Val(sYear, AYear, Code);
    if Code <> 0 then
      Raise Exception.Create('Необходимо ввести целое число!'#13'Например: 1980');
  end;
end;

function InputMoney(const ACaption, APrompt: string; var AMoney: Extended): Boolean;
const
  exceptionMessage = 'Необходимо ввести число рублей и копеек разделенных "%s"!'#13'Например: 10000 или 9000%s99';
var
  sMoney: String;
begin
  if AMoney = 0 then
    sMoney := ''
  else
    sMoney := FloatToStr(AMoney);

  Result := InputQuery(ACaption, APrompt, sMoney);

  if Result then
  begin
    Result := TextToFloat(PChar(sMoney), AMoney, fvExtended);
    if not Result then
      Raise Exception.CreateFmt(exceptionMessage, [DecimalSeparator, DecimalSeparator]);
  end;
end;

function InputMoney(var AMoney: Extended): Boolean;
const
  ACaption = 'Введите неоходимое количество денег';
  exceptionMessage = 'Необходимо ввести число рублей и копеек разделенных "%s"!'#13'Например: 10000 или 9000%s99';

  function APrompt: String;
  begin
    Result := Format('Деньги (рубли%sкопейки)', [DecimalSeparator]);
  end;

begin
  Result := InputMoney(ACaption, APrompt, AMoney);
end;

function InputQuarter(var AQuarter: TQuarterRec; const withAll: Boolean = True): Boolean;
const
  iSize = 110;
  withAllArray: array[Boolean] of string = ('', 'Все (за год)');

var
  frm: TForm;
  rg: TRadioGroup;
  ne: TNumberEdit;
  tx: TLabel;
  btnOK, btnCancel: TButton;
begin
  Result := False;
  frm := TForm.Create(Application);
  try
    rg := TRadioGroup.Create(frm);
    rg.Parent := frm;
    rg.SetBounds(iIndent, iIndent, iSize, iSize);
    rg.Caption := 'Кварталы';
    rg.Items.Add(withAllArray[withAll]);
    rg.Items.Add('1 квартал');
    rg.Items.Add('2 квартал');
    rg.Items.Add('3 квартал');
    rg.Items.Add('4 квартал');

    if AQuarter.Quarter > 0 then
      rg.ItemIndex := AQuarter.Quarter
    else
      rg.ItemIndex := 0;

    btnCancel := TButton.Create(frm);
    btnCancel.Parent := frm;
    btnCancel.Left := rg.Left + rg.Width + iIndent;
    btnCancel.Top := rg.Top + rg.Height - btnCancel.Height;
    btnCancel.Caption := 'Отмена';
    btnCancel.Cancel := True;
    btnCancel.ModalResult := IDCancel;

    btnOK := TButton.Create(frm);
    btnOK.Parent := frm;
    btnOK.Left := btnCancel.Left;
    btnOK.Top := btnCancel.Top - btnOK.Height - iIndent;
    btnOK.Caption := 'Ok';
    btnOK.Default := True;
    btnOK.ModalResult := IDOk;

    tx := TLabel.Create(frm);
    tx.Parent := frm;
    tx.Caption := 'Год';
    tx.Left := btnOK.Left;
    tx.Top := rg.Top;

    ne := TNumberEdit.Create(frm);
    ne.Parent := frm;
    ne.Left := tx.Left;
    ne.Top := tx.Top + tx.Height + 1;
    ne.Width := btnOK.Width;

    if AQuarter.Year > 0 then
      ne.Text := IntToStr(AQuarter.Year)
    else
      ne.Text := IntToStr(CurrentYear);

    frm.Caption := 'Выберите квартал';
    frm.BorderStyle := bsDialog;
    frm.Position := poScreenCenter;
    frm.ClientWidth := rg.Width + btnOK.Width + iIndent*3;
    frm.ClientHeight := rg.Height + iIndent*2;
    if frm.ShowModal = IDOK then
    begin
      AQuarter.Year := StrToInt(ne.Text);
      AQuarter.Quarter := rg.ItemIndex;
      Result := True;
    end;
  finally
    FreeAndNil(frm);
  end;
end;

function TRadioDlg.AddRadioItem(S: String; AObject: TObject): Integer;
begin
  Result := Radio.Items.AddObject(S, AObject);
end;

constructor TRadioDlg.Create(AOwner: TComponent);
begin
  inherited;
  Form := TForm.Create(Self);
  Form.BorderStyle := bsDialog;
  Form.Caption := 'Диалог выбора';
  Form.Position := poScreenCenter;

  Radio := TRadioGroup.Create(Form);
  Radio.Parent := Form;
  Radio.SetBounds(iIndent, iIndent, 185, 105);
  Radio.TabStop := True;
  Radio.TabOrder := 0;

  btnCancel := TButton.Create(Form);
  btnCancel.Cancel := True;
  btnCancel.Caption := 'Отмена';
  btnCancel.Left := iIndent + Radio.Width - btnCancel.Width;
  btnCancel.ModalResult := mrCancel;
  btnCancel.Parent := Form;
  btnCancel.TabOrder := 2;
  btnCancel.Top := iIndent + Radio.Height + iIndent;

  btnOk := TButton.Create(Form);
  btnOk.Caption := 'Ok';
  btnOk.Default := True;
  btnOk.Left := btnCancel.Left - iIndent - btnOk.Width;
  btnOk.OnClick := OkClick;
  btnOk.Parent := Form;
  btnOk.TabOrder := 1;
  btnOk.Top := iIndent + Radio.Height + iIndent;

  Form.ActiveControl := Radio;
  Form.ClientHeight := Radio.Height + btnCancel.Height + iIndent*3;
  Form.ClientWidth := Radio.Width + iIndent*2;
end;

function TRadioDlg.GetRadioIndex: Integer;
begin
  Result := Radio.ItemIndex;
end;

function TRadioDlg.GetRadioItems: TStrings;
begin
  Result := Radio.Items;
end;

procedure TRadioDlg.OkClick(Sender: TObject);
begin
  if Radio.ItemIndex <> LB_ERR then
    Form.ModalResult := mrOk
  else
    if Radio.Items.Count > 0 then
      IBox('Выберите элемент из группы')
    else
      Form.ModalResult := mrCancel;
end;

function TRadioDlg.ShowModal: Integer;
begin
  Result := Form.ShowModal;
end;

end.
