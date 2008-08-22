unit ZADateDlg;

interface

uses
  Classes, Controls, Forms, ComCtrls, ExtCtrls, StdCtrls;

type
  TDateLimit = (dlUnlimit, dlBeforeDate, dlAfterDate);
{ dlUnlimit    - лимита на ввод даты нет
  dlBeforeDate - дата должна быть меньше Date
  dlAfterDate  - дата должна быть больше Date }

  TDateDlg = class(TForm)
    MonthCalendar: TMonthCalendar;
    btnOk: TButton;
    btnCancel: TButton;
    Panel: TPanel;
  end;

function InputDateBox(var ADate: TDate; const Limit: TDateLimit = dlUnlimit): Boolean;

implementation

{$R *.dfm}

function InputDateBox(var ADate: TDate; const Limit: TDateLimit = dlUnlimit): Boolean;
begin
  with TDateDlg.Create(Application) do
  try
    if ADate > 0 then
      MonthCalendar.Date := ADate;
    case Limit of
      dlBeforeDate:
        MonthCalendar.MaxDate := MonthCalendar.Date;
      dlAfterDate:
        MonthCalendar.MinDate := MonthCalendar.Date;
    end;
    Result := ShowModal = mrOk;
    if Result then
      ADate := MonthCalendar.Date;  
  finally
    Free;
  end;
end;

end.
