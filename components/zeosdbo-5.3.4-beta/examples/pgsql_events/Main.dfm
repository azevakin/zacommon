�
 TFRMMAIN 0�  TPF0TfrmMainfrmMainLeft� TopqWidthvHeightCaptionTestColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderShowHint	OnCreate
FormCreatePixelsPerInch`
TextHeight TLabelLabel3Left0Top� WidthDHeightCaptionEvents List:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel4Left0Top Width)HeightCaptionStatus:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabellbPIDStatusLeftTopWidthPHeightCaptionBackend PID:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabellbPIDLeftXTopWidthHHeightCaption(Disconnected)  	TGroupBox	GroupBox3LeftTop� Width#HeightECaption Notify TabOrder TButton
brActivateLeftTopWidthKHeightHint$Activate the TZPgSqlNotify componentCaptionActivate...TabOrder OnClickbrActivateClick  TButtonbtSetEventsLeftWTopWidthKHeightHint>Assign the Events from the Events List to the Notify componentCaption
Set EventsTabOrderOnClickbtSetEventsClick  TButtonbtNotifyLeft� TopWidthKHeightHintGenerate a 'TestEvent' notifyCaptionNotify!!TabOrderOnClickbtNotifyClick   TMemommStatusLeft0TopWidth9Height� Lines.Strings  TabOrder   TDBGridDBGrid1Left Top%WidthnHeight� AlignalBottom
DataSourceDataSource1TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style   TMemommEventsLeft0Top� Width9HeightILines.Strings	TestEventInsertRecord TabOrder  	TGroupBox	GroupBox1LeftTopWidth#Height� Caption Connection TabOrder TLabellbHostLeftTopWidth5HeightCaption	Host Name  TLabellbDbLeftTop-Width.HeightCaptionDatabase  TLabellbLoginLeftTopEWidthHeightCaptionLogin  TLabellbPswdLeftTop]Width.HeightCaptionPassword  TLabel
lbDBStatusLeftTopvWidth)HeightCaptionStatus:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabellbDBConnectedLeft3TopvWidthBHeightCaptionDisconnected  TButton	btConnectLeft� TopWidthKHeightHintConnect to database, opCaptionConnect!TabOrder OnClickbtConnectClick  TButtonbtDisconnectLeft� Top-WidthKHeightHintDisconnect from databaseCaption
DisconnectTabOrderOnClickbtDisconnectClick  TButtonbtResetLeft� TopIWidthKHeightHint0Reset connection to backend server (PQreset API)CaptionResetTabOrderOnClickbtResetClick  TEditedHostLeftNTopWidthyHeightTabOrderText	localhost  TEdit
edDatabaseLeftNTop)WidthyHeightTabOrderTexttest  TEditedLoginLeftNTopAWidthyHeightTabOrderTextroot  TEdit
edPasswordLeftNTopYWidthyHeightPasswordChar*TabOrder  TButtonbtSaveLeft� TopfWidthKHeightHintSave settings to .ini fileCaptionSaveTabOrderOnClickbtSaveClick   	TGroupBox	GroupBox2LeftTop� Width$Height7Caption Table Creation/Drop TabOrder TButtonbtCreateLeftTopWidthKHeightHint0Create the test table 'blah' for the applicationCaptionCreate TableTabOrder OnClickbtCreateClick  TButtonbtDropLeftYTopWidthKHeightHint/Drop the test table 'blah' from the applicationCaption
Drop TableTabOrderOnClickbtDropClick  TButtonbtOpenLeft� TopWidthKHeightHint/Drop the test table 'blah' from the applicationCaption
Open TableTabOrderOnClickbtOpenClick   
TZBatchSqlbsDropTransactiontrMainSql.Stringsdrop table blah;  LeftTop�  TDataSourceDataSource1DataSettbMainLeft� TopX  
TZBatchSqlbsCreateTransactiontrMainSql.Stringscreate table blah(  var_field varchar(8),  n1 integer default 23,  n2 integer,  arr_str varchar[],
  m money,  s text);.create rule Detect_Insert as on insert to blah  do Notify InsertRecord; LeftTopu  TZPgSqlTransacttrMainOptionstoHourGlass 
AutoCommit	OnAfterConnecttrMainAfterConnectOnAfterDisconnecttrMainAfterDisconnectDatabasedbMainAutoRecovery	TransactSafe	TransIsolation	ziDefaultLeft� Top�  	TZMonitor	mtMonitorOnMonitorEventmtMonitorMonitorEventLeftBTopu  TZPgSqlTabletbMainDatabasedbMainTransactiontrMainCachedUpdatesShowRecordTypes
ztModified
ztInsertedztUnmodified OptionsdoHourGlassdoAutoFillDefs
doUseRowId LinkOptionsloAlwaysResync ExtraOptionspoTextAsMemopoOidAsBlob 	TableNameblahReadOnly	LefthTop�  TZPgSqlDatabasedbMainPort5432Encoding
etIso88592LoginPrompt	ConnectedLeft� Topu  TZPgSqlNotifyntMainActiveInterval�OnNotify
EventAlertDatabasedbMainLeft<Top�   