unit ZASelectMon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls;

type
  TMonthRec = record
    Year,
    Month: Word;
    Title: string;
  end;

  TSelectMonthDlg = class(TForm)
    rgMon: TRadioGroup;
    lbl1: TLabel;
    btn1: TButton;
    btn2: TButton;
    seYear: TSpinEdit;
  private
    function MonthName: string;
  public
    class function Execute(var month: TMonthRec): Boolean;
  end;

implementation

{$R *.dfm}

{ TSelectMonthDlg }

class function TSelectMonthDlg.Execute(var month: TMonthRec): Boolean;
const
  t: array[Boolean] of string = (
    '%1:s %0:d года',
    '%d год'
  );
begin
  with TSelectMonthDlg.Create(nil) do
  try
    seYear.Value := month.Year;
    rgMon.ItemIndex := month.Month;
    Result := IsPositiveResult(ShowModal);
    if Result then
    begin
      month.Year := seYear.Value;
      month.Month := rgMon.ItemIndex;
      month.Title := Format(t[month.Month=0], [month.Year, MonthName]);
    end;
  finally
    Free;
  end;   
end;

function TSelectMonthDlg.MonthName: string;
begin
  Result := rgMon.Items[rgMon.ItemIndex];
end;

end.
