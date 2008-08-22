unit DataM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ZSySqlQuery, Db, ZQuery, ZTransact, ZSySqlTr, ZConnect, ZSySqlCon,
  ZPgSqlQuery, ZPgSqlTr, ZPgSqlCon, ZDb2SqlQuery, ZDb2SqlTr, ZDb2SqlCon,
  ZIbSqlQuery, ZIbSqlTr, ZIbSqlCon, ZMsSqlQuery, ZMsSqlTr, ZMsSqlCon,
  ZMySqlQuery, ZMySqlTr, ZMySqlCon, ZOraSqlQuery, ZOraSqlTr, ZOraSqlCon,
  StdCtrls;

type
  TDM = class(TForm)
    ZSySqlDatabase1: TZSySqlDatabase;
    ZSySqlTransact1: TZSySqlTransact;
    ZSySqlQuery1: TZSySqlQuery;
    ZSySqlQuery2: TZSySqlQuery;
    ZSySqlTable1: TZSySqlTable;
    ZSySqlTable2: TZSySqlTable;
    ZPgSqlDatabase1: TZPgSqlDatabase;
    ZPgSqlTransact1: TZPgSqlTransact;
    ZPgSqlQuery1: TZPgSqlQuery;
    ZPgSqlQuery2: TZPgSqlQuery;
    ZPgSqlTable1: TZPgSqlTable;
    ZPgSqlTable2: TZPgSqlTable;
    ZOraSqlDatabase1: TZOraSqlDatabase;
    ZOraSqlTransact1: TZOraSqlTransact;
    ZOraSqlTable1: TZOraSqlTable;
    ZOraSqlQuery1: TZOraSqlQuery;
    ZOraSqlQuery2: TZOraSqlQuery;
    ZOraSqlTable2: TZOraSqlTable;
    ZMySqlDatabase1: TZMySqlDatabase;
    ZMySqlTransact1: TZMySqlTransact;
    ZMySqlQuery1: TZMySqlQuery;
    ZMySqlQuery2: TZMySqlQuery;
    ZMySqlTable1: TZMySqlTable;
    ZMySqlTable2: TZMySqlTable;
    ZMsSqlDatabase1: TZMsSqlDatabase;
    ZMsSqlTransact1: TZMsSqlTransact;
    ZMsSqlQuery1: TZMsSqlQuery;
    ZMsSqlTable1: TZMsSqlTable;
    ZMsSqlQuery2: TZMsSqlQuery;
    ZMsSqlTable2: TZMsSqlTable;
    ZIbSqlDatabase1: TZIbSqlDatabase;
    ZIbSqlTransact1: TZIbSqlTransact;
    ZIbSqlTable1: TZIbSqlTable;
    ZIbSqlQuery1: TZIbSqlQuery;
    ZIbSqlQuery2: TZIbSqlQuery;
    ZIbSqlTable2: TZIbSqlTable;
    ZDb2SqlDatabase1: TZDb2SqlDatabase;
    ZDb2SqlTransact1: TZDb2SqlTransact;
    ZDb2SqlTable1: TZDb2SqlTable;
    ZDb2SqlQuery1: TZDb2SqlQuery;
    ZDb2SqlQuery2: TZDb2SqlQuery;
    ZDb2SqlTable2: TZDb2SqlTable;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
  private
    { Private declarations }
  public
    database: TZDatabase;
    dataset1: TZDataset;
    dataset2: TZDataset;
    procedure SetDatabaseComponents(index, query_comp: word);
    procedure QueryAfterScroll(DataSet: TDataSet);
  end;

const
 sql1 = 'select * from vendors';
 sql2 = 'select *  from parts where vendorno = :vendorno';

var
  DM: TDM;

implementation

{$R *.DFM}

uses Main;

procedure TDM.QueryAfterScroll(DataSet: TDataSet);
var
 field: TField;
begin
 if DataSet2.Active then DataSet2.Close;
 field := DataSet1.FindField('VendorNo');
 if Assigned(field) then begin
  DataSet2.ParamByName('vendorno').AsInteger := field.AsInteger;
  DataSet2.Open;
  MainForm.ComboBox2.OnChange(self);
 end;
end;

procedure TDM.SetDatabaseComponents(index, query_comp: word);
var
 param: TParam;
begin
 case index of
  0: begin
      database := ZMySqlDatabase1;
      if query_comp = 0 then begin
       dataset1 := ZMySqlQuery1;
       dataset2 := ZMySqlQuery2;
      end else begin
       dataset1 := ZMySqlTable1;
       dataset2 := ZMySqlTable2;
      end;
     end;
  1: begin
      database := ZPgSqlDatabase1;
      if query_comp = 0 then begin
       dataset1 := ZPgSqlQuery1;
       dataset2 := ZPgSqlQuery2;
      end else begin
       dataset1 := ZPgSqlTable1;
       dataset2 := ZPgSqlTable2;
      end;
     end;
  2: begin
      database := ZIbSqlDatabase1;
      if query_comp = 0 then begin
       dataset1 := ZIbSqlTable1;
       dataset2 := ZIbSqlQuery2;
      end else begin
       dataset1 := ZIbSqlTable1;
       dataset2 := ZIbSqlTable2;
      end;
     end;
  3: begin
      database := ZSySqlDatabase1;
      if query_comp = 0 then begin
       dataset1 := ZSySqlQuery1;
       dataset2 := ZSySqlQuery2;
      end else begin
       dataset1 := ZSySqlTable1;
       dataset2 := ZSySqlTable2;
      end;
     end;
  4: begin
      database := ZMsSqlDatabase1;
      if query_comp = 0 then begin
       dataset1 := ZMsSqlQuery1;
       dataset2 := ZMsSqlQuery2;
      end else begin
       dataset1 := ZMsSqlTable1;
       dataset2 := ZMsSqlTable2;
      end;
     end;
  5: begin
      database := ZDb2SqlDatabase1;
      if query_comp = 0 then begin
       dataset1 := ZDb2SqlQuery1;
       dataset2 := ZDb2SqlQuery2;
      end else begin
       dataset1 := ZDb2SqlTable1;
       dataset2 := ZDb2SqlTable2;
      end;
     end;
   6: begin
      database := ZOraSqlDatabase1;
      if query_comp = 0 then begin
       dataset1 := ZOraSqlQuery1;
       dataset2 := ZOraSqlQuery2;
      end else begin
       dataset1 := ZOraSqlTable1;
       dataset2 := ZOraSqlTable2;
      end;
     end;
 end;
 DataSource1.DataSet := dataset1;
 DataSource2.DataSet := dataset2;
 if query_comp = 0 then begin
  dataset1.Sql.Text := sql1;
  dataset2.Sql.Text := sql2;
  param := DM.dataset2.ParamByName('vendorno');
  if param = nil then param := DM.dataset2.Params.CreateParam(ftInteger, 'vendorno', ptInput);
  param.DataType := ftInteger;
  dataset1.AfterScroll := QueryAfterScroll;
 end else begin
  dataset2.MasterSource := DataSource1;
  dataset2.LinkFields := 'VendorNo=VendorNo';
 end;
end;

end.
