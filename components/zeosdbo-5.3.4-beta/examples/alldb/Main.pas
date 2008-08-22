unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, ZQuery, ExtDlgs, DB;

type
  TMainForm = class(TForm)
    ListView: TListView;
    Label1: TLabel;
    Label2: TLabel;
    DatabaseEdit: TEdit;
    Label3: TLabel;
    UserEdit: TEdit;
    PasswordEdit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    RoleEdit: TEdit;
    ComponentGroup: TRadioGroup;
    OpenBtn: TButton;
    Host: TLabel;
    HostEdit: TEdit;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    ComboBox2: TComboBox;
    ComboBox1: TComboBox;
    procedure OpenBtnClick(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComponentGroupClick(Sender: TObject);
  private
//    query: TZ;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses DataM;

procedure TMainForm.OpenBtnClick(Sender: TObject);
var
 i: integer;
begin
 try
  DM.database.Host := HostEdit.Text;
  DM.database.Login := UserEdit.Text;
  DM.database.Database := DatabaseEdit.Text;
  DM.database.Password :=  PasswordEdit.Text;
  DM.ZIbSqlDatabase1.SqlRole := RoleEdit.Text;
  DM.database.Connect;
  DM.dataset1.open;
  DM.dataset2.open;
  ComboBox1.Items.Add('none');
  ComboBox2.Items.Add('none');
  for i := 0 to DM.dataset1.Fields.Count-1 do ComboBox1.Items.Add(DM.dataset1.Fields[i].FieldName);
  for i := 0 to DM.dataset2.Fields.Count-1 do ComboBox2.Items.Add(DM.dataset2.Fields[i].FieldName);
  ComboBox1.ItemIndex := 0;
  ComboBox2.ItemIndex := 0;
 except
  ShowMEssage('Cant connect please check settings');
 end;
end;

procedure TMainForm.ListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if DM.database <> nil then DM.database.Disconnect;
 DM.SetDatabaseComponents(Item.Index, ComponentGroup.ItemIndex);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
 ComboBox1.Items.Clear;
 ComboBox2.Items.Clear;
 ListView.Selected := ListView.Items[0];
 DM.SetDatabaseComponents(0, ComponentGroup.ItemIndex);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 ListView.OnSelectItem := nil;
end;

procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
 if TComboBox(sender).ItemIndex = 0 then DM.dataset1.SortClear
 else DM.dataset1.SortByField(TComboBox(sender).Text);
end;

procedure TMainForm.ComboBox2Change(Sender: TObject);
begin
 if TComboBox(sender).ItemIndex = 0 then DM.dataset2.SortClear
 else DM.dataset2.SortByField(TComboBox(sender).Text);
end;

procedure TMainForm.ComponentGroupClick(Sender: TObject);
begin
 DM.dataset1.Close;
 DM.dataset2.Close;
 DM.SetDatabaseComponents(ListView.Selected.Index, ComponentGroup.ItemIndex);
end;

end.
