unit ZADateRange;

interface

uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls, ComCtrls;

type
  TRangeResult = (rrNone, rrAll, rrRange);

  TDateRangeDlg = class(TForm)
    dpBegin: TDateTimePicker;
    dpEnd: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    btnOk: TButton;
    btnCancel: TButton;
    chAll: TCheckBox;
  protected
    procedure doShow; override;
  end;

function DateRangeDlg(var BeginDate, EndDate: TDate): TRangeResult;

implementation

uses SysUtils, Windows;

{$R *.dfm}

function DateRangeDlg(var BeginDate, EndDate: TDate): TRangeResult;
begin
  with TDateRangeDlg.Create(Application) do
  try
    ShowModal;
    if IsPositiveResult(ModalResult) then
    begin
      if chAll.Checked then
        Result := rrAll
      else begin
        Result := rrRange;
        BeginDate := dpBegin.Date;
        EndDate := dpEnd.Date;
      end;  
    end else
      Result := rrNone;
  finally
    Free;
  end;
end;

procedure TDateRangeDlg.doShow;
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  dpEnd.Date := SystemTimeToDateTime(SystemTime);

  SystemTime.wDay := 1;
  dpBegin.Date := SystemTimeToDateTime(SystemTime);

  inherited doShow;
end;

end.
