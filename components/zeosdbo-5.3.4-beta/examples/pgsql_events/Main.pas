unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ZTransact, ZPgSqlQuery, ZPgSqlTr, Db, ZQuery, ZConnect, ZPgSqlCon, StdCtrls,
  ZIbSqlQuery, Grids, DBGrids, ExtCtrls, ZDirSql, ZUpdateSql, ZDirPgSql, IniFiles;

const
  strSection = 'Main';
  strDatabase = 'Database';
  strHost = 'Host';
  strLogin = 'Login';
  strPassword = 'Password';

type
  TfrmMain = class(TForm)
    bsDrop: TZBatchSql;
    DataSource1: TDataSource;
    mmStatus: TMemo;
    bsCreate: TZBatchSql;
    DBGrid1: TDBGrid;
    trMain: TZPgSqlTransact;
    mtMonitor: TZMonitor;
    mmEvents: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    lbPIDStatus: TLabel;
    lbPID: TLabel;
    tbMain: TZPgSqlTable;
    dbMain: TZPgSqlDatabase;
    ntMain: TZPgSqlNotify;
    GroupBox1: TGroupBox;
    lbHost: TLabel;
    lbDb: TLabel;
    lbLogin: TLabel;
    lbPswd: TLabel;
    btConnect: TButton;
    btDisconnect: TButton;
    btReset: TButton;
    edHost: TEdit;
    edDatabase: TEdit;
    edLogin: TEdit;
    edPassword: TEdit;
    btSave: TButton;
    GroupBox2: TGroupBox;
    btCreate: TButton;
    btDrop: TButton;
    GroupBox3: TGroupBox;
    brActivate: TButton;
    btSetEvents: TButton;
    btNotify: TButton;
    lbDBStatus: TLabel;
    lbDBConnected: TLabel;
    btOpen: TButton;
    procedure ZPgSqlMonitor1MonitorEvent(Sql, Result: String);
    procedure btConnectClick(Sender: TObject);
    procedure btCreateClick(Sender: TObject);
    procedure btDropClick(Sender: TObject);
    procedure btResetClick(Sender: TObject);
    procedure mtMonitorMonitorEvent(Sql, Result: String);
    procedure brActivateClick(Sender: TObject);
    procedure btNotifyClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure btSetEventsClick(Sender: TObject);
    procedure EventAlert(Sender: TObject; Event: String);
    procedure trMainAfterConnect(Sender: TObject);
    procedure trMainAfterDisconnect(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  IniFileName: string;
  IniFile: TIniFile;

implementation

{$R *.DFM}

procedure TfrmMain.ZPgSqlMonitor1MonitorEvent(Sql, Result: String);
begin
  mmStatus.Lines.Add(Result);
end;

procedure TfrmMain.btConnectClick(Sender: TObject);
begin
  dbMain.Host:=edHost.Text;
  dbMain.Database:=edDatabase.Text;
  dbMain.Login:=edLogin.Text;
  dbMain.Password:=edPassword.Text;
  ntMain.EventsList.Text:=mmEvents.Text;
  ntMain.Active:=True;
  tbMain.Active:=True;
end;

procedure TfrmMain.btCreateClick(Sender: TObject);
begin
  bsCreate.ExecSql;
  mmStatus.Lines.Append('Table create sucessfully');
end;

procedure TfrmMain.btDropClick(Sender: TObject);
begin
  bsDrop.ExecSql;
  mmStatus.Lines.Append('Table dropped sucessfully');
end;

procedure TfrmMain.btResetClick(Sender: TObject);
begin
  trMain.Reset;
end;

procedure TfrmMain.mtMonitorMonitorEvent(Sql, Result: String);
begin
  if Assigned(mmStatus) then
    mmStatus.Lines.Append(Format('%s ==> %s', [Sql, Result]));
end;

procedure TfrmMain.brActivateClick(Sender: TObject);
begin
  ntMain.Active:=True;
  if not ntMain.Active then
    DatabaseError('Oh-oh.');
end;

procedure TfrmMain.btNotifyClick(Sender: TObject);
begin
  ntMain.DoNotify('TestEvent');
end;

procedure TfrmMain.btDisconnectClick(Sender: TObject);
begin
  dbMain.Disconnect;
end;

procedure TfrmMain.btSetEventsClick(Sender: TObject);
begin
  ntMain.EventsList.Text:=mmEvents.Text;
end;

procedure TfrmMain.EventAlert(Sender: TObject; Event: String);
begin
  SysUtils.Beep;
  if lowercase(Event)='insertrecord' then
    ShowMessage(Format('Our spies report that backend PID %d just inserted a record on relation "blah".', [TDirPgSqlNotify(ntMain.Handle).Handle.be_pid]))
  else
    ShowMessage(Format('Event "%s" just happened on backend PID %d.', [Event, TDirPgSqlNotify(ntMain.Handle).Handle.be_pid]));
end;

procedure TfrmMain.trMainAfterConnect(Sender: TObject);
begin
  if trMain.Connected then
  begin
    lbDBConnected.Caption:='Connected';
    lbPID.Caption:=IntToStr(trMain.PID);
  end;
end;

procedure TfrmMain.trMainAfterDisconnect(Sender: TObject);
begin
  if not trMain.Connected then
  begin
    lbDBConnected.Caption:='(Disconnected)';
    lbPID.Caption:='(Disconnected)';
  end;
end;

procedure TfrmMain.btSaveClick(Sender: TObject);
begin
  IniFile.WriteString(strSection, strHost, edHost.Text);
  IniFile.WriteString(strSection, strDatabase, edDatabase.Text);
  IniFile.WriteString(strSection, strLogin, edLogin.Text);
  IniFile.WriteString(strSection, strPassword, edPassword.Text);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if FileExists(IniFileName) then
  begin
    edHost.Text:=IniFile.ReadString(strSection, strHost, edHost.Text);
    edDatabase.Text:=IniFile.ReadString(strSection, strDatabase, edDatabase.Text);
    edLogin.Text:=IniFile.ReadString(strSection, strLogin, edLogin.Text);
    edPassword.Text:=IniFile.ReadString(strSection, strPassword, edPassword.Text);
  end;
end;

procedure TfrmMain.btOpenClick(Sender: TObject);
begin
  tbMain.Active:=True;
end;

initialization
  IniFileName:=ChangeFileExt(ParamStr(0), '.ini');
  IniFile:=TIniFile.Create(IniFileName);
finalization
  IniFile.Free;
end.
