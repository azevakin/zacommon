unit ZAPgSqlInputDialog;

interface

uses
  Classes, Controls, Forms, ZAPgSqlDialog, StdCtrls;

type
  TPgSqlInputDlg = class(TPgSqlDlg)
    btnOk: TButton;
    btnCancel: TButton;
  end;

implementation

{$R *.dfm}

end.
