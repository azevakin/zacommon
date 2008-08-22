unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, Db, EasyTable, FR_PTabl,
  FR_Desgn;

type
  TMainForm = class(TForm)
    EasyTable1: TEasyTable;
    DataSource1: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    Panel3: TPanel;
    NewCustBtn: TBitBtn;
    EditCustBtn: TBitBtn;
    DeleteCustBtn: TBitBtn;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    cbCaseSensitive: TCheckBox;
    cbNoPartialCompare: TCheckBox;
    FilterCondition: TComboBox;
    Label2: TLabel;
    btFilterOn: TButton;
    btFilterOff: TButton;
    btFindFirst: TButton;
    btFindNext: TButton;
    EasyDatabase1: TEasyDatabase;
    bnReport: TBitBtn;
    frPrint: TfrPrintTable;
    frDesigner1: TfrDesigner;
    procedure FormCreate(Sender: TObject);
    procedure NewCustBtnClick(Sender: TObject);
    procedure EditCustBtnClick(Sender: TObject);
    procedure DeleteCustBtnClick(Sender: TObject);
    procedure btFilterOnClick(Sender: TObject);
    procedure btFilterOffClick(Sender: TObject);
    procedure btFindFirstClick(Sender: TObject);
    procedure btFindNextClick(Sender: TObject);
    procedure bnReportClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateButtons;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses Cust;

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin

  with EasyTable1 do
  {if table doesn't exist}
  if not Exists then
   begin
      {set table structure}
			with FieldDefs do
				begin
 			   Clear;
         Add('CustNo',ftInteger,0,False);
         Add('Company',ftString,30,False);
         Add('Address',ftString,30,False);
         Add('Phone',ftString,15,False);
         Add('FAX',ftString,15,False);
         Add('TaxRate',ftFloat,0,False);
         Add('LastInvoiceDate',ftDateTime,0,False);
 				end;
			with IndexDefs do
				begin
				 Clear;
         Add('PrimaryKey','CustNo',[ixPrimary]);
         Add('ByCompany','Company',[ixCaseInsensitive]);
				end;
      {and create the table}
	 	  CreateTable;
   end;
 // open table
 EasyTable1.Active := true;
 // add filter condition (it is locale dependent, so we should generate this)
 FilterCondition.Items.Add('LastInvoiceDate <= '+QuotedStr(DateToStr(Now)));
 // update buttons
 UpdateButtons;
end;

procedure TMainForm.NewCustBtnClick(Sender: TObject);
begin
 EasyTable1.Insert;
 CustForm.ShowModal;
 // update buttons
 UpdateButtons;
end;

procedure TMainForm.EditCustBtnClick(Sender: TObject);
begin
 if (EditCustBtn.Enabled) then
  begin
   EasyTable1.Edit;
   CustForm.ShowModal;
   // update buttons
   UpdateButtons;
  end;
end;

procedure TMainForm.DeleteCustBtnClick(Sender: TObject);
begin
 if MessageDlg('Do you really want to delete '+
               QuotedStr(EasyTable1.FieldByName('Company').AsString)+
               ' company?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
  EasyTable1.Delete;
 // update buttons
 UpdateButtons;
end;

procedure TMainForm.UpdateButtons;
begin
 // New / Edit / Delete buttons
 if (EasyTable1.RecordCount > 0) then
  begin
   EditCustBtn.Enabled := true;
   DeleteCustBtn.Enabled := true;
  end
 else
  begin
   EditCustBtn.Enabled := false;
   DeleteCustBtn.Enabled := false;
  end;

 // Filter On, Off buttons
 if EasyTable1.Filtered then
  begin
   btFilterOn.Enabled := false;
   btFilterOff.Enabled := true;
  end
 else
  begin
   btFilterOn.Enabled := true;
   btFilterOff.Enabled := false;
  end;
end;

procedure TMainForm.btFilterOnClick(Sender: TObject);
begin
 with EasyTable1 do
  begin
   Filter := FilterCondition.Text;
   FilterOptions := [];
   if not cbCaseSensitive.Checked then
    FilterOptions := FilterOptions + [foCaseInsensitive];
   if cbNoPartialCompare.Checked then
    FilterOptions := FilterOptions + [foNoPartialCompare];
   Filtered := true;
  end;
 UpdateButtons;
end;

procedure TMainForm.btFilterOffClick(Sender: TObject);
begin
 EasyTable1.Filtered := false;
 UpdateButtons;
end;

procedure TMainForm.btFindFirstClick(Sender: TObject);
begin
 with EasyTable1 do
  begin
   Filter := FilterCondition.Text;
   FilterOptions := [];
   if not cbCaseSensitive.Checked then
    FilterOptions := FilterOptions + [foCaseInsensitive];
   if cbNoPartialCompare.Checked then
    FilterOptions := FilterOptions + [foNoPartialCompare];
   if not EasyTable1.FindFirst then
    MessageDlg('Record not found.',mtInformation,[mbOk],0);
  end;
end;

procedure TMainForm.btFindNextClick(Sender: TObject);
begin
 if not EasyTable1.FindNext then
  MessageDlg('Record not found.',mtInformation,[mbOk],0);
end;

procedure TMainForm.bnReportClick(Sender: TObject);
begin
 frPrint.ShowReport;
end;

end.
