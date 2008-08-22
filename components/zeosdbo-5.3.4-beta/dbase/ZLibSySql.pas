{********************************************************}
{                                                        }
{                 Zeos Database Objects                  }
{        Delphi plain interface to libsybdb.dll          }
{                                                        }
{       Copyright (c) 1999-2001 Sergey Seroukhov         }
{    Copyright (c) 1999-2002 Zeos Development Group      }
{                                                        }
{********************************************************}

unit ZLibSySql;

interface

uses {$IFNDEF LINUX}Windows,{$ENDIF} Classes, ZSqlTypes;

{$IFNDEF LINUX}
{$INCLUDE ..\Zeos.inc}
{$ELSE}
{$INCLUDE ../Zeos.inc}
{$ENDIF}

{***************** Plain API Constants definition ****************}

const
{$IFNDEF LINUX}
  DEFAULT_DLL_LOCATION = 'libsybdb.dll';
{$ELSE}
  DEFAULT_DLL_LOCATION = '/usr/lib/sybase/libsybdb.so';
{$ENDIF}

{ General  #define }
  TIMEOUT_IGNORE        = Cardinal(-1);
  TIMEOUT_INFINITE      = 0;
  TIMEOUT_MAXIMUM       = 1200; { 20 minutes maximum timeout value }

{ Used for ServerType in dbgetprocinfo }
  SERVTYPE_UNKNOWN      = 0;
  SERVTYPE_MICROSOFT    = 1;

{ Used by dbcolinfo }
{enum CI_TYPES }
  CI_REGULAR            = 1;
  CI_ALTERNATE          = 2;
  CI_CURSOR             = 3;

{ Bulk Copy Definitions (bcp) }
  DB_IN	                = 1;  { Transfer from client to server }
  DB_OUT	        = 2;  { Transfer from server to client }

  BCPMAXERRS            = 1;  { bcp_control parameter }
  BCPFIRST              = 2;  { bcp_control parameter }
  BCPLAST               = 3;  { bcp_control parameter }
  BCPBATCH              = 4;  { bcp_control parameter }
  BCPKEEPNULLS          = 5;  { bcp_control parameter }
  BCPABORT              = 6;  { bcp_control parameter }

  TINYBIND              = 1;
  SMALLBIND             = 2;
  INTBIND               = 3;
  CHARBIND              = 4;
  BINARYBIND            = 5;
  BITBIND               = 6;
  DATETIMEBIND          = 7;
  MONEYBIND             = 8;
  FLT8BIND              = 9;
  STRINGBIND            = 10;
  NTBSTRINGBIND         = 11;
  VARYCHARBIND          = 12;
  VARYBINBIND           = 13;
  FLT4BIND              = 14;
  SMALLMONEYBIND        = 15;
  SMALLDATETIBIND       = 16;
  DECIMALBIND           = 17;
  NUMERICBIND           = 18;
  SRCDECIMALBIND        = 19;
  SRCNUMERICBIND        = 20;
  MAXBIND               = SRCNUMERICBIND;

  DBSAVE                = 1;
  DBNOSAVE              = 0;

  DBNOERR               = -1;
  DBFAIL                = 0;
  DBSUCCEED             = 1;
  DBFINDONE             = $04;  { Definately done }
  DBMORE                = $10;  { Maybe more commands waiting }
  DBMORE_ROWS           = $20;  { This command returned rows }

  MAXNAME               = 31;
  DBTXTSLEN             = 8;     { Timestamp length }
  DBTXPLEN              = 16;    { Text pointer length }

{ Error code returns }
  INT_EXIT              = 0;
  INT_CONTINUE          = 1;
  INT_CANCEL            = 2;

{ dboptions }
  DBBUFFER              = 0;
  DBOFFSET              = 1;
  DBROWCOUNT            = 2;
  DBSTAT                = 3;
  DBTEXTLIMIT           = 4;
  DBTEXTSIZE            = 5;
  DBARITHABORT          = 6;
  DBARITHIGNORE         = 7;
  DBNOAUTOFREE          = 8;
  DBNOCOUNT             = 9;
  DBNOEXEC              = 10;
  DBPARSEONLY           = 11;
  DBSHOWPLAN            = 12;
  DBSTORPROCID		= 13;
  DBANSITOOEM		= 14;
  DBOEMTOANSI	        = 15;
  DBCLIENTCURSORS       = 16;
  DBSET_TIME            = 17;
  DBQUOTEDIDENT         = 18;

{ Data Type Tokens }
  SQLVOID               = $1f;
  SQLTEXT               = $23;
  SQLVARBINARY          = $25;
  SQLINTN               = $26;
  SQLVARCHAR            = $27;
  SQLBINARY             = $2d;
  SQLIMAGE              = $22;
  SQLCHAR               = $2f;
  SQLINT1               = $30;
  SQLBIT                = $32;
  SQLINT2               = $34;
  SQLINT4               = $38;
  SQLMONEY              = $3c;
  SQLDATETIME           = $3d;
  SQLFLT8               = $3e;
  SQLFLTN               = $6d;
  SQLMONEYN             = $6e;
  SQLDATETIMN           = $6f;
  SQLFLT4               = $3b;
  SQLMONEY4             = $7a;
  SQLDATETIM4           = $3a;
  SQLDECIMAL            = $6a;
  SQLNUMERIC            = $6c;

{ Data stream tokens }
  SQLCOLFMT             = $a1;
  OLD_SQLCOLFMT         = $2a;
  SQLPROCID             = $7c;
  SQLCOLNAME            = $a0;
  SQLTABNAME            = $a4;
  SQLCOLINFO            = $a5;
  SQLALTNAME            = $a7;
  SQLALTFMT             = $a8;
  SQLERROR              = $aa;
  SQLINFO               = $ab;
  SQLRETURNVALUE        = $ac;
  SQLRETURNSTATUS       = $79;
  SQLRETURN             = $db;
  SQLCONTROL            = $ae;
  SQLALTCONTROL         = $af;
  SQLROW                = $d1;
  SQLALTROW             = $d3;
  SQLDONE               = $fd;
  SQLDONEPROC           = $fe;
  SQLDONEINPROC         = $ff;
  SQLOFFSET             = $78;
  SQLORDER              = $a9;
  SQLLOGINACK           = $ad; { NOTICE: change to real value }

{ Ag op tokens }
  SQLAOPCNT		= $4b;
  SQLAOPSUM             = $4d;
  SQLAOPAVG             = $4f;
  SQLAOPMIN             = $51;
  SQLAOPMAX             = $52;
  SQLAOPANY             = $53;
  SQLAOPNOOP            = $56;

{ Error numbers (dberrs) DB-Library error codes }
  SQLEMEM               = 10000;
  SQLENULL              = 10001;
  SQLENLOG              = 10002;
  SQLEPWD               = 10003;
  SQLECONN              = 10004;
  SQLEDDNE              = 10005;
  SQLENULLO             = 10006;
  SQLESMSG              = 10007;
  SQLEBTOK              = 10008;
  SQLENSPE              = 10009;
  SQLEREAD              = 10010;
  SQLECNOR              = 10011;
  SQLETSIT              = 10012;
  SQLEPARM              = 10013;
  SQLEAUTN              = 10014;
  SQLECOFL              = 10015;
  SQLERDCN              = 10016;
  SQLEICN               = 10017;
  SQLECLOS              = 10018;
  SQLENTXT              = 10019;
  SQLEDNTI              = 10020;
  SQLETMTD              = 10021;
  SQLEASEC              = 10022;
  SQLENTLL              = 10023;
  SQLETIME              = 10024;
  SQLEWRIT              = 10025;
  SQLEMODE              = 10026;
  SQLEOOB               = 10027;
  SQLEITIM              = 10028;
  SQLEDBPS              = 10029;
  SQLEIOPT              = 10030;
  SQLEASNL              = 10031;
  SQLEASUL              = 10032;
  SQLENPRM              = 10033;
  SQLEDBOP              = 10034;
  SQLENSIP              = 10035;
  SQLECNULL             = 10036;
  SQLESEOF              = 10037;
  SQLERPND              = 10038;
  SQLECSYN              = 10039;
  SQLENONET             = 10040;
  SQLEBTYP              = 10041;
  SQLEABNC              = 10042;
  SQLEABMT              = 10043;
  SQLEABNP              = 10044;
  SQLEBNCR              = 10045;
  SQLEAAMT              = 10046;
  SQLENXID              = 10047;
  SQLEIFNB              = 10048;
  SQLEKBCO              = 10049;
  SQLEBBCI              = 10050;
  SQLEKBCI              = 10051;
  SQLEBCWE              = 10052;
  SQLEBCNN              = 10053;
  SQLEBCOR              = 10054;
  SQLEBCPI              = 10055;
  SQLEBCPN              = 10056;
  SQLEBCPB              = 10057;
  SQLEVDPT              = 10058;
  SQLEBIVI              = 10059;
  SQLEBCBC              = 10060;
  SQLEBCFO              = 10061;
  SQLEBCVH              = 10062;
  SQLEBCUO              = 10063;
  SQLEBUOE              = 10064;
  SQLEBWEF              = 10065;
  SQLEBTMT              = 10066;
  SQLEBEOF              = 10067;
  SQLEBCSI              = 10068;
  SQLEPNUL              = 10069;
  SQLEBSKERR            = 10070;
  SQLEBDIO              = 10071;
  SQLEBCNT              = 10072;
  SQLEMDBP              = 10073;
  SQLINIT               = 10074;
  SQLCRSINV             = 10075;
  SQLCRSCMD             = 10076;
  SQLCRSNOIND           = 10077;
  SQLCRSDIS             = 10078;
  SQLCRSAGR             = 10079;
  SQLCRSORD             = 10080;
  SQLCRSMEM             = 10081;
  SQLCRSBSKEY           = 10082;
  SQLCRSNORES           = 10083;
  SQLCRSVIEW            = 10084;
  SQLCRSBUFR            = 10085;
  SQLCRSFROWN           = 10086;
  SQLCRSBROL            = 10087;
  SQLCRSFRAND           = 10088;
  SQLCRSFLAST           = 10089;
  SQLCRSRO              = 10090;
  SQLCRSTAB             = 10091;
  SQLCRSUPDTAB          = 10092;
  SQLCRSUPDNB           = 10093;
  SQLCRSVIIND           = 10094;
  SQLCRSNOUPD           = 10095;
  SQLCRSOS2             = 10096;
  SQLEBCSA              = 10097;
  SQLEBCRO              = 10098;
  SQLEBCNE              = 10099;
  SQLEBCSK              = 10100;
  SQLEUVBF              = 10101;
  SQLEBIHC              = 10102;
  SQLEBWFF              = 10103;
  SQLNUMVAL             = 10104;
  SQLEOLDVR             = 10105;
  SQLEBCPS	        = 10106;
  SQLEDTC 	        = 10107;
  SQLENOTIMPL	        = 10108;
  SQLENONFLOAT	        = 10109;
  SQLECONNFB            = 10110;

{ The severity levels are defined here }
  EXINFO                = 1;  { Informational, non-error }
  EXUSER                = 2;  { User error }
  EXNONFATAL            = 3;  { Non-fatal error }
  EXCONVERSION          = 4;  { Error in DB-LIBRARY data conversion }
  EXSERVER              = 5;  { The Server has returned an error flag }
  EXTIME                = 6;  { We have exceeded our timeout period while }
                           { waiting for a response from the Server - the }
                           { DBPROCESS is still alive }
  EXPROGRAM             = 7;  { Coding error in user program }
  EXRESOURCE            = 8;  { Running out of resources - the DBPROCESS may be dead }
  EXCOMM                = 9;  { Failure in communication with Server - the DBPROCESS is dead }
  EXFATAL               = 10; { Fatal error - the DBPROCESS is dead }
  EXCONSISTENCY         = 11; { Internal software error  - notify MS Technical Supprt }

{ Offset identifiers }
  OFF_SELECT            = $16d;
  OFF_FROM              = $14f;
  OFF_ORDER             = $165;
  OFF_COMPUTE           = $139;
  OFF_TABLE             = $173;
  OFF_PROCEDURE         = $16a;
  OFF_STATEMENT         = $1cb;
  OFF_PARAM             = $1c4;
  OFF_EXEC              = $12c;

{ Decimal constants }
  MAXNUMERICLEN = 16;
  MAXNUMERICDIG = 38;

  DEFAULTPRECISION = 18;
  DEFAULTSCALE     = 0;

{ Print lengths for certain fixed length data types }
  PRINT4                = 11;
  PRINT2                = 6;
  PRINT1                = 3;
  PRFLT8                = 20;
  PRMONEY               = 26;
  PRBIT                 = 3;
  PRDATETIME            = 27;
  PRDECIMAL             = (MAXNUMERICDIG + 2);
  PRNUMERIC             = (MAXNUMERICDIG + 2);

  SUCCEED               = 1;
  FAIL                  = 0;
  SUCCEED_ABORT         = 2;

  DBUNKNOWN             = 2;

  MORE_ROWS             = -1;
  NO_MORE_ROWS          = -2;
  REG_ROW               = MORE_ROWS;
  BUF_FULL              = -3;

{ Status code for dbresults(). Possible return values are }
{ SUCCEED, FAIL, and NO_MORE_RESULTS. }
  NO_MORE_RESULTS       = 2;
  NO_MORE_RPC_RESULTS   = 3;

{ Macros for dbsetlname() }
  DBSETHOST             = 1;
  DBSETUSER             = 2;
  DBSETPWD              = 3;
  DBSETAPP              = 4;
  DBSETID               = 5;
  DBSETLANG             = 6;

  DBSETSECURE           = 7;
  DBVER42               = 8;
  DBVER60               = 9;
  DBSET_LOGIN_TIME      = 10;
  DBSETFALLBACK         = 12;

{ Standard exit and error values }
  STDEXIT               = 0;
  ERREXIT               = -1;

{ dbrpcinit flags }
  DBRPCRECOMPILE        = $0001;
  DBRPCRESET            = $0004;
  DBRPCCURSOR           = $0008;

{ dbrpcparam flags }
  DBRPCRETURN           = $1;
  DBRPCDEFAULT          = $2;

{ Cursor related constants }

{ Following flags are used in the concuropt parameter in the dbcursoropen function }
  CUR_READONLY          = 1; { Read only cursor, no data modifications }
  CUR_LOCKCC            = 2; { Intent to update, all fetched data locked when }
                       { dbcursorfetch is called inside a transaction block }
  CUR_OPTCC             = 3; { Optimistic concurrency control, data modifications }
                       { succeed only if the row hasn't been updated since }
                       { the last fetch. }
  CUR_OPTCCVAL          = 4; { Optimistic concurrency control based on selected column values }

{ Following flags are used in the scrollopt parameter in dbcursoropen }
  CUR_FORWARD           = 0;   { Forward only scrolling }
  CUR_KEYSET            = -1;  { Keyset driven scrolling }
  CUR_DYNAMIC           = 1;   { Fully dynamic }
  CUR_INSENSITIVE       = -2;  { Server-side cursors only }

{ Following flags define the fetchtype in the dbcursorfetch function }
  FETCH_FIRST           = 1;  { Fetch first n rows }
  FETCH_NEXT            = 2;  { Fetch next n rows }
  FETCH_PREV            = 3;  { Fetch previous n rows }
  FETCH_RANDOM          = 4;  { Fetch n rows beginning with given row # }
  FETCH_RELATIVE        = 5;  { Fetch relative to previous fetch row # }
  FETCH_LAST            = 6;  { Fetch the last n rows }

{ Following flags define the per row status as filled by dbcursorfetch and/or dbcursorfetchex }
  FTC_EMPTY             = $00;  { No row available }
  FTC_SUCCEED           = $01;  { Fetch succeeded, (failed if not set) }
  FTC_MISSING           = $02;  { The row is missing }
  FTC_ENDOFKEYSET       = $04;  { End of the keyset reached }
  FTC_ENDOFRESULTS      = $08;  { End of results set reached }

{ Following flags define the operator types for the dbcursor function }
  CRS_UPDATE            = 1;  { Update operation }
  CRS_DELETE            = 2;  { Delete operation }
  CRS_INSERT            = 3;  { Insert operation }
  CRS_REFRESH           = 4;  { Refetch given row }
  CRS_LOCKCC            = 5;  { Lock given row }

{ Following value can be passed to the dbcursorbind function for NOBIND type }
  NOBIND                = -2; { Return length and pointer to data }

{ Following are values used by DBCURSORINFO's Type parameter }
  CU_CLIENT             = $00000001;
  CU_SERVER             = $00000002;
  CU_KEYSET             = $00000004;
  CU_MIXED              = $00000008;
  CU_DYNAMIC            = $00000010;
  CU_FORWARD            = $00000020;
  CU_INSENSITIVE        = $00000040;
  CU_READONLY           = $00000080;
  CU_LOCKCC             = $00000100;
  CU_OPTCC              = $00000200;
  CU_OPTCCVAL           = $00000400;

{ Following are values used by DBCURSORINFO's Status parameter }
  CU_FILLING            = $00000001;
  CU_FILLED             = $00000002;

{ Following are values used by dbupdatetext's type parameter }
  UT_TEXTPTR            = $0001;
  UT_TEXT               = $0002;
  UT_MORETEXT           = $0004;
  UT_DELETEONLY         = $0008;
  UT_LOG                = $0010;

{ The following values are passed to dbserverenum for searching criteria. }
  NET_SEARCH            = $0001;
  LOC_SEARCH            = $0002;

{ These constants are the possible return values from dbserverenum. }
  ENUM_SUCCESS          = $0000;
  MORE_DATA             = $0001;
  NET_NOT_AVAIL         = $0002;
  OUT_OF_MEMORY         = $0004;
  NOT_SUPPORTED         = $0008;
  ENUM_INVALID_PARAM    = $0010;

{ Netlib Error problem codes.  ConnectionError() should return one of }
{ these as the dblib-mapped problem code, so the corresponding string }
{ is sent to the dblib app's error handler as dberrstr.  Return NE_E_NOMAP }
{ for a generic DB-Library error string (as in prior versions of dblib). }

  NE_E_NOMAP            = 0;   { No string; uses dblib default. }
  NE_E_NOMEMORY         = 1;   { Insufficient memory. }
  NE_E_NOACCESS         = 2;   { Access denied. }
  NE_E_CONNBUSY         = 3;   { Connection is busy. }
  NE_E_CONNBROKEN       = 4;   { Connection broken. }
  NE_E_TOOMANYCONN      = 5;   { Connection limit exceeded. }
  NE_E_SERVERNOTFOUND   = 6;   { Specified SQL server not found. }
  NE_E_NETNOTSTARTED    = 7;   { The network has not been started. }
  NE_E_NORESOURCE       = 8;   { Insufficient network resources. }
  NE_E_NETBUSY          = 9;   { Network is busy. }
  NE_E_NONETACCESS      = 10;  { Network access denied. }
  NE_E_GENERAL          = 11;  { General network error.  Check your documentation. }
  NE_E_CONNMODE         = 12;  { Incorrect connection mode. }
  NE_E_NAMENOTFOUND     = 13;  { Name not found in directory service. }
  NE_E_INVALIDCONN      = 14;  { Invalid connection. }
  NE_E_NETDATAERR       = 15;  { Error reading or writing network data. }
  NE_E_TOOMANYFILES     = 16;  { Too many open file handles. }
  NE_E_CANTCONNECT	= 17;  { SQL Server does not exist or access denied. }

  NE_MAX_NETERROR       = 17;

{****************** Plain API Types definition *****************}

type
{ DBPROCESS, LOGINREC and DBCURSOR }
  PDBPROCESS            = Pointer;
  PLOGINREC             = Pointer;
  PDBCURSOR             = Pointer;
  PDBHANDLE             = Pointer;

//typedef int (SQLAPI *SQLFARPROC)();

//typedef       CHAR PTR LPSTR;
//typedef       BYTE PTR LPBYTE;
//typedef       void PTR LPVOID;
//typedef const CHAR PTR LPCSTR;

//typedef int BOOL;

{ DB-Library datatype definitions }
const
  DBMAXCHAR             = 256; { Max length of DBVARBINARY and DBVARCHAR, etc. }

type
  RETCODE               = Integer;
  STATUS                = Integer;

{ DB-Library datatypes }
  DBCHAR                = Char;
  DBBINARY              = Byte;
  DBTINYINT             = Byte;
  DBSMALLINT            = SmallInt;
  DBUSMALLINT           = Word;
  DBINT                 = LongInt;
  DBFLT8                = Double;
  DBBIT                 = Byte;
  DBBOOL                = Byte;
  DBFLT4                = Single;
  DBMONEY4              = LongInt;

  DBREAL                = DBFLT4;
  DBUBOOL               = Cardinal;

  DBDATETIM4 = packed record
    numdays:    Word;        { No of days since Jan-1-1900 }
    nummins:    Word;        { No. of minutes since midnight }
  end;
  PDBDATETIM4 = ^DBDATETIM4;

  DBVARYCHAR = packed record
    Len:        DBSMALLINT;
    Str:        array[0..DBMAXCHAR-1] of DBCHAR;
  end;

  DBVARYBIN = packed record
    Len:        DBSMALLINT;
    Bytes:	array[0..DBMAXCHAR-1] of Byte;
  end;

  DBMONEY = packed record
    mnyhigh:    DBINT;
    mnylow:     Cardinal;
  end;

  DBDATETIME = packed record
    dtdays:	DBINT;
    dttime:	Cardinal;
  end;
  PDBDATETIME = ^DBDATETIME;

{ DBDATEREC structure used by dbdatecrack }
(*  DBDATEREC = packed record                       // mjd - commented this date structure 
    year:       Integer;      { 1753 - 9999 }       //       out because MS and Sybase 
    quarter:    Integer;      { 1 - 4 }             //       really diverge here!!!
    month:      Integer;      { 1 - 12 }
    dayofyear:  Integer;      { 1 - 366 }
    day:        Integer;      { 1 - 31 }
    week:       Integer;      { 1 - 54 (for leap years) }
    weekday:    Integer;      { 1 - 7  (Mon - Sun) }
    hour:       Integer;      { 0 - 23 }
    minute:     Integer;      { 0 - 59 }
    second:     Integer;      { 0 - 59 }
    millisecond: Integer;     { 0 - 999 }
  end;*) //mjd
  DBDATEREC = packed record
    year:       Integer;      { 1753 - 9999 }
//    quarter:    Integer;      { 1 - 4 }
    month:      Integer;      { 0 - 11 } // mjd - months in sybase date format are 0-based
    day:        Integer;      { 1 - 31 }
    dayofyear:  Integer;      { 1 - 366 }
//    week:       Integer;      { 1 - 54 (for leap years) }
    weekday:    Integer;      { 0 - 6  (Sun - Sat) }
    hour:       Integer;      { 0 - 23 }
    minute:     Integer;      { 0 - 59 }
    second:     Integer;      { 0 - 59 }
    millisecond: Integer;     { 0 - 999 }
    timezone:   integer;      { 0 - 127 }
  end;

  PDBDATEREC = ^DBDATEREC;

type
  DBNUMERIC = packed record
    Precision:  Byte;
    Scale:      Byte;
    Sign:       Byte; { 1 = Positive, 0 = Negative }
    Val:        array[0..MAXNUMERICLEN-1] of Byte;
  end;

  DBDECIMAL = DBNUMERIC;

const
{ Pack the following structures on a word boundary }
  MAXCOLNAMELEN = 30;
  MAXTABLENAME  = 30;

type
  DBCOL = packed record
    SizeOfStruct: DBINT;
    Name:       array[0..MAXCOLNAMELEN] of Char;
    ActualName: array[0..MAXCOLNAMELEN] of Char;
    TableName:  array[0..MAXTABLENAME] of Char;
    Typ:        SmallInt;
    UserType:   DBINT;
    MaxLength:  DBINT;
    Precision:  Byte;
    Scale:      Byte;
    VarLength:  Bool;    { TRUE, FALSE }
    Null:       Byte;    { TRUE, FALSE or DBUNKNOWN }
    CaseSensitive: Byte; { TRUE, FALSE or DBUNKNOWN }
    Updatable:  Byte;    { TRUE, FALSE or DBUNKNOWN }
    Identity:   BOOL;    { TRUE, FALSE }
  end;
  PDBCOL = ^DBCOL;

const
  MAXSERVERNAME = 30;
  MAXNETLIBNAME = 255;
  MAXNETLIBCONNSTR = 255;

type
  DBPROC_INFO = packed record
    SizeOfStruct:       DBINT;
    ServerType:         Byte;
    ServerMajor:        Word;
    ServerMinor:        Word;
    ServerRevision:     Word;
    ServerName:         array[0..MAXSERVERNAME] of Char;
    NetLibName:         array[0..MAXNETLIBNAME] of Char;
    NetLibConnStr:      array[0..MAXNETLIBCONNSTR] of Char;
  end;
  PDBPROCINFO = ^DBPROC_INFO;

  DBCURSOR_INFO = packed record
    SizeOfStruct:       DBINT;    { Use sizeof(DBCURSORINFO) }
    TotCols:            Cardinal; { Total Columns in cursor }
    TotRows:            Cardinal; { Total Rows in cursor }
    CurRow:             Cardinal; { Current actual row in server }
    TotRowsFetched:     Cardinal; { Total rows actually fetched }
    CurType:            Cardinal; { See CU_... }
    Status:             Cardinal; { See CU_... }
  end;
  PDBCURSORINFO = ^DBCURSOR_INFO;

const
  INVALID_UROWNUM       = Cardinal(-1);

type
{ Pointer Datatypes }

//typedef const LPINT          LPCINT;
//typedef const LPBYTE         LPCBYTE ;
//typedef       USHORT PTR     LPUSHORT;
//typedef const LPUSHORT       LPCUSHORT;
//typedef       DBINT PTR      LPDBINT;
  PDBINT        = ^DBINT;
  PDBBINARY     = ^DBBINARY;
//typedef const LPDBBINARY     LPCDBBINARY;
//typedef       DBDATEREC PTR  LPDBDATEREC;
//typedef const LPDBDATEREC    LPCDBDATEREC;
//typedef       DBDATETIME PTR LPDBDATETIME;
//typedef const LPDBDATETIME   LPCDBDATETIME;

{************** Plain API Function types definition *************}

{ Macros for setting the PLOGINREC }
function DBSETLHOST(Login: PLOGINREC; ClientHost: PChar): RETCODE;
function DBSETLUSER(Login: PLOGINREC; UserName: PChar): RETCODE;
function DBSETLPWD(Login: PLOGINREC; Passwd: PChar): RETCODE;
function DBSETLAPP(Login: PLOGINREC; AppName: PChar): RETCODE;
function DBSETLNATLANG(Login: PLOGINREC; Lang: PChar): RETCODE;
function DBSETLSECURE(Login: PLOGINREC): RETCODE;
function DBSETLVERSION(Login: PLOGINREC; Version: Byte): RETCODE;
function DBSETLTIME(Login: PLOGINREC; Seconds: DWORD): RETCODE;
function DBSETLFALLBACK(Login: PLOGINREC; Fallback: PChar): RETCODE;

{ Function macros }
function dbrbuf(Proc: PDBPROCESS): DBINT;

type
  DBERRHANDLE_PROC = function(Proc: PDBPROCESS; Severity, DbErr, OsErr: Integer;
    DbErrStr, OsErrStr: PChar): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  DBMSGHANDLE_PROC = function(Proc: PDBPROCESS; MsgNo: DBINT; MsgState,
    Severity: Integer; MsgText, SrvName, ProcName: PChar; Line: DBUSMALLINT):
    Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

  Tdberrhandle = function(Handler: DBERRHANDLE_PROC): DBERRHANDLE_PROC; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbmsghandle = function(Handler: DBMSGHANDLE_PROC): DBMSGHANDLE_PROC; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

  Tdbprocerrhandle = function(DbHandle: PDBHANDLE; Handler: DBERRHANDLE_PROC):
    DBERRHANDLE_PROC; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbprocmsghandle = function(DbHandle: PDBHANDLE; Handler: DBMSGHANDLE_PROC):
    DBMSGHANDLE_PROC; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

  { Two-phase commit functions }
  Tabort_xact = function(Proc: PDBPROCESS; CommId: DBINT): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbuild_xact_string = procedure(XActName, Service: PChar; CommId: DBINT;
    Result: PChar); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tclose_commit = procedure(Proc: PDBPROCESS); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tcommit_xact = function(Proc: PDBPROCESS; CommId: DBINT): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Topen_commit = function(Login: PLOGINREC; ServerName: PChar): PDBPROCESS; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tremove_xact = function(Proc: PDBPROCESS; CommId: DBINT; SiteCount: Integer):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tscan_xact = function(Proc: PDBPROCESS; CommId: DBINT): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tstart_xact = function(Proc: PDBPROCESS; AppName, XActName: PChar;
    SiteCount: Integer): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tstat_xact = function(Proc: PDBPROCESS; CommId: DBINT): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

{ BCP functions }
  Tbcp_batch = function(Proc: PDBPROCESS): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_bind = function(Proc: PDBPROCESS; VarAddr: PByte; PrefixLen: Integer;
    VarLen: DBINT; Terminator: PByte; TermLen, Typ, TableColumn: Integer):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_colfmt = function(Proc: PDBPROCESS; FileColumn: Integer; FileType: Byte;
    FilePrefixLen: Integer; FileColLen: DBINT; FileTerm: PByte; FileTermLen,
    TableColumn: Integer): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_collen = function(Proc: PDBPROCESS; VarLen: DBINT; TableColumn: Integer):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_colptr = function(Proc: PDBPROCESS; ColPtr: PByte; TableColumn: Integer):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_columns = function(Proc: PDBPROCESS; FileColCount: Integer): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_control = function(Proc: PDBPROCESS; Field: Integer; Value: DBINT):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_done = function(Proc: PDBPROCESS): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_exec = function(Proc: PDBPROCESS; RowsCopied: PDBINT): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_init = function(Proc: PDBPROCESS; TableName, hFile, ErrFile: PChar;
    Direction: Integer): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_moretext = function(Proc: PDBPROCESS; Size: DBINT; Text: PByte):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_readfmt = function(Proc: PDBPROCESS; FileName: PChar): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_sendrow = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_setl = function(Login: PLOGINREC; Enable: BOOL): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tbcp_writefmt = function(Proc: PDBPROCESS; FileName: PChar): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

{ Standard DB-Library functions }
  Tdbadata = function(Proc: PDBPROCESS; ComputeId, Column: Integer): PByte; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbadlen = function(Proc: PDBPROCESS; ComputeId, Column: Integer): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbaltbind = function(Proc: PDBPROCESS; ComputeId, Column: Integer;
    VarType: Integer; VarLen: DBINT; VarAddr: PByte): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbaltcolid = function(Proc: PDBPROCESS; ComputeId, Column: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbaltlen = function(Proc: PDBPROCESS; ComputeId, Column: Integer): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbaltop = function(Proc: PDBPROCESS; ComputeId, Column: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbalttype = function(Proc: PDBPROCESS; ComputeId, Column: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbaltutype = function(Proc: PDBPROCESS; ComputeId, Column: Integer): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbanullbind = function(Proc: PDBPROCESS; ComputeId, Column: Integer;
    Indicator: PDBINT): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbbind = function(Proc: PDBPROCESS; Column, VarType, VarLen: Integer;
    VarAddr: PByte): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbbylist = function(Proc: PDBPROCESS; ComputeId: Integer; Size: PInteger):
    PByte; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcancel = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcanquery = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbchange = function(Proc: PDBPROCESS): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbclose = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbclrbuf = procedure(Proc: PDBPROCESS; N: DBINT); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbclropt = function(Proc: PDBPROCESS; Option: Integer; Param: PChar): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcmd = function(Proc: PDBPROCESS; Cmd: PChar): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcmdrow = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};  //!!!
  Tdbcolbrowse = function(Proc: PDBPROCESS; Column: Integer): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcolinfo = function(Handle: PDBHANDLE; Typ, Column, ComputeId: Integer;
    DbColumn: PDBCOL): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcollen = function(Proc: PDBPROCESS; Column: Integer): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcolname = function(Proc: PDBPROCESS; Column: Integer): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcolsource = function(Proc: PDBPROCESS; Column: Integer): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcoltype = function(Proc: PDBPROCESS; Column: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcolutype = function(Proc: PDBPROCESS; Column: Integer): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbconvert = function(Proc: PDBPROCESS; SrcType: Integer; Src: PByte;
    SrcLen: DBINT; DestType: Integer; Dest: PByte; DestLen: DBINT): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcount = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcurcmd = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcurrow = function(Proc: PDBPROCESS): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

  Tdbcursor = function(hCursor: PDBCURSOR; OpType, Row: Integer; Table,
    Values: PChar): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcursorbind = function(hCursor: PDBCURSOR; Col, VarType: Integer; VarLen: DBINT;
    POutLen: PDBINT; VarAddr: PByte): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcursorclose = function(DbHandle: PDBHANDLE): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcursorcolinfo = function(hCursor: PDBCURSOR; Column: Integer; ColName: PChar;
    ColType: PInteger; ColLen: PDBINT; UserType: PInteger): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcursorfetch = function(hCursor: PDBCURSOR; FetchType, RowNum: Integer):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcursorfetchex = function(hCursor: PDBCURSOR; FetchType: Integer; RowNum,
    nFetchRows, Reserved: DBINT): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcursorinfo = function(hCursor: PDBCURSOR; nCols: PInteger; nRows: PDBINT):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcursorinfoex = function(hCursor: PDBCURSOR; DbCursorInfo: PDBCURSORINFO):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbcursoropen = function(Proc: PDBPROCESS; Sql: PChar; ScrollOpt,
    ConCurOpt: Integer; nRows: Cardinal; PStatus: PDBINT): PDBCURSOR; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbdata = function(Proc: PDBPROCESS; Column: Integer): PByte; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbdataready = function(Proc: PDBPROCESS): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbdatecrack = function(Proc: PDBPROCESS; DateInfo: PDBDATEREC;
    DateType: PDBDATETIME): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbdatlen = function(Proc: PDBPROCESS; Column: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbdead = function(Proc: PDBPROCESS): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbexit = procedure; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
//  Tdbenlisttrans = function(PDBPROCESS, LPVOID): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
//  Tdbenlistxatrans = function(PDBPROCESS, BOOL): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
//  Tdbfcmd = function(PDBPROCESS, LPCSTR, ...): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbfirstrow = function(Proc: PDBPROCESS): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbfreebuf = procedure(Proc: PDBPROCESS); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbfreelogin = procedure(Login: PLOGINREC); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbfreequal = procedure(Ptr: PChar); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbgetchar = function(Proc: PDBPROCESS; N: Integer): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbgetmaxprocs = function: SmallInt; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbgetoff = function(Proc: PDBPROCESS; OffType: DBUSMALLINT;
    StartFrom: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbgetpacket = function(Proc: PDBPROCESS): Cardinal; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbgetrow = function(Proc: PDBPROCESS; Row: DBINT): STATUS; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbgettime = function: Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbgetuserdata = function(Proc: PDBPROCESS): Pointer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbhasretstat = function(Proc: PDBPROCESS): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbinit = function: PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbisavail = function(Proc: PDBPROCESS): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbiscount = function(Proc: PDBPROCESS): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbisopt = function(Proc: PDBPROCESS; Option: Integer; Param: PChar): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdblastrow = function(Proc: PDBPROCESS): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdblogin = function: PLOGINREC; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbmorecmds = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbmoretext = function(Proc: PDBPROCESS; Size: DBINT; Text: PByte): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbname = function(Proc: PDBPROCESS): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbnextrow = function(Proc: PDBPROCESS): STATUS; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbnullbind = function(Proc: PDBPROCESS; Column: Integer; Indicator: PDBINT):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbnumalts = function(Proc: PDBPROCESS; ComputeId: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbnumcols = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbnumcompute = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbnumorders = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbnumrets = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbopen = function(Login: PLOGINREC; Host: PChar): PDBPROCESS; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbordercol = function(Proc: PDBPROCESS; Order: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbprocinfo = function(Proc: PDBPROCESS; DbProcInfo: PDBPROCINFO): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbprhead = procedure(Proc: PDBPROCESS); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbprrow = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbprtype = function(Token: Integer): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbqual = function(Proc: PDBPROCESS; TabNum: Integer; TabName: PChar): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
//  Tdbreadpage = function(PDBPROCESS, LPCSTR, DBINT, DBINT, LPBYTE): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbreadtext = function(Proc: PDBPROCESS; Buf: Pointer; BufSize: DBINT): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbresults = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbretdata = function(Proc: PDBPROCESS; RetNum: Integer): PByte; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbretlen = function(Proc: PDBPROCESS; RetNum: Integer): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbretname = function(Proc: PDBPROCESS; RetNum: Integer): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbretstatus = function(Proc: PDBPROCESS): DBINT; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbrettype = function(Proc: PDBPROCESS; RetNum: Integer): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbrows = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF}; //!!!
  Tdbrowtype = function(Proc: PDBPROCESS): STATUS; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbrpcinit = function(Proc: PDBPROCESS; ProcName: PChar; Options: DBSMALLINT):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF}; //!!!
  Tdbrpcparam = function(Proc: PDBPROCESS; ParamName: PChar; Status: Byte;
    Typ: Integer; MaxLen, DataLen: DBINT; Value: PByte): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbrpcsend = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbrpcexec = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

  Tdbrpwclr = procedure(Login: PLOGINREC); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
//  Tdbrpwset = function(PLOGINREC, LPCSTR, LPCSTR, INT): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbserverenum = function(SearchMode: Word; ServNameBuf: PChar;
    ServNameBufSize: Word; NumEntries: PWord): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsetavail = procedure(Proc: PDBPROCESS); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsetmaxprocs = function(MaxProcs: SmallInt): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsetlname = function(Login: PLOGINREC; Value: POINTER; Item: word): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsetlogintime = function(Seconds: Integer): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

  Tdbsetlpacket = function(Login: PLOGINREC; PacketSize: Word): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsetnull = function(Proc: PDBPROCESS; BindType, BindLen: Integer;
    BindVal: PByte): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
//  Tdbsetopt = function(Proc: PDBPROCESS; Option: Integer; Param: PChar):
//    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};  mjd
  Tdbsetopt = function(Proc: PDBPROCESS; Option: Integer; Param: PChar; Param2:Integer):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};  // mjd 9/21/2001
  Tdbsettime = function(Seconds: Integer): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsetuserdata = procedure(Proc: PDBPROCESS; Ptr: Pointer); {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsqlexec = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsqlok = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbsqlsend = function(Proc: PDBPROCESS): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbstrcpy = function(Proc: PDBPROCESS; Start, NumBytes: Integer; Dest: PChar):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbstrlen = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtabbrowse = function(Proc: PDBPROCESS; TabNum: Integer): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtabcount = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtabname = function(Proc: PDBPROCESS; Table: Integer): PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtabsource = function(Proc: PDBPROCESS; Column: Integer; TabNum: PInteger):
    PChar; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtsnewlen = function(Proc: PDBPROCESS): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtsnewval = function(Proc: PDBPROCESS): PDBBINARY; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtsput = function(Proc: PDBPROCESS; NewTs: PDBBINARY; NewTsName,
    TabNum: Integer; TableName: PChar): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtxptr = function(Proc: PDBPROCESS; Column: Integer): PDBBINARY; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtxtimestamp = function(Proc: PDBPROCESS; Column: Integer): PDBBINARY; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtxtsnewval = function(Proc: PDBPROCESS): PDBBINARY; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbtxtsput = function(Proc: PDBPROCESS; NewTxts: PDBBINARY; Column: Integer):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbuse = function(Proc: PDBPROCESS; DbName: PChar): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbvarylen = function(Proc: PDBPROCESS; Column: Integer): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbwillconvert = function(SrcType, DestType: Integer): BOOL; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
//  Tdbwritepage = function(PDBPROCESS, LPCSTR, DBINT, DBINT, DBINT, LPBYTE): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbwritetext = function(Proc: PDBPROCESS; ObjName: PChar; TextPtr: PDBBINARY;
    TextPtrLen: DBTINYINT; Timestamp: PDBBINARY; Log: BOOL; Size: DBINT;
    Text: PByte): RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
  Tdbupdatetext = function(Proc: PDBPROCESS; DestObject: PChar; DestTextPtr,
    DestTimestamp: PDBBINARY; UpdateType: Integer; InsertOffset,
    DeleteLength: DBINT; SrcObject: PChar; SrcSize: DBINT; SrcText: PDBBINARY):
    RETCODE; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};

{************* Plain API Function variables definition ************}

var
  dberrhandle           : Tdberrhandle;
  dbmsghandle           : Tdbmsghandle;

  dbprocerrhandle       : Tdbprocerrhandle;
  dbprocmsghandle       : Tdbprocmsghandle;

  { Two-phase commit functions }
  abort_xact            : Tabort_xact;
  build_xact_string     : Tbuild_xact_string;
  close_commit          : Tclose_commit;
  commit_xact           : Tcommit_xact;
  open_commit           : Topen_commit;
  remove_xact           : Tremove_xact;
  scan_xact             : Tscan_xact;
  start_xact            : Tstart_xact;
  stat_xact             : Tstat_xact;

{ BCP functions }
  bcp_batch             : Tbcp_batch;
  bcp_bind              : Tbcp_bind;
  bcp_colfmt            : Tbcp_colfmt;
  bcp_collen            : Tbcp_collen;
  bcp_colptr            : Tbcp_colptr;
  bcp_columns           : Tbcp_columns;
  bcp_control           : Tbcp_control;
  bcp_done              : Tbcp_done;
  bcp_exec              : Tbcp_exec;
  bcp_init              : Tbcp_init;
  bcp_moretext          : Tbcp_moretext;
  bcp_readfmt           : Tbcp_readfmt;
  bcp_sendrow           : Tbcp_sendrow;
  bcp_setl              : Tbcp_setl;
  bcp_writefmt          : Tbcp_writefmt;

{ Standard DB-Library functions }
  dbadata               : Tdbadata;
  dbadlen               : Tdbadlen;
  dbaltbind             : Tdbaltbind;
  dbaltcolid            : Tdbaltcolid;
  dbaltlen              : Tdbaltlen;
  dbaltop               : Tdbaltop;
  dbalttype             : Tdbalttype;
  dbaltutype            : Tdbaltutype;
  dbanullbind           : Tdbanullbind;
  dbbind                : Tdbbind;
  dbbylist              : Tdbbylist;
  dbcancel              : Tdbcancel;
  dbcanquery            : Tdbcanquery;
  dbchange              : Tdbchange;
  dbclose               : Tdbclose;
  dbclrbuf              : Tdbclrbuf;
  dbclropt              : Tdbclropt;
  dbcmd                 : Tdbcmd;
  dbcmdrow              : Tdbcmdrow;
  dbcolbrowse           : Tdbcolbrowse;
  dbcolinfo             : Tdbcolinfo;
  dbcollen              : Tdbcollen;
  dbcolname             : Tdbcolname;
  dbcolsource           : Tdbcolsource;
  dbcoltype             : Tdbcoltype;
  dbcolutype            : Tdbcolutype;
  dbconvert             : Tdbconvert;
  dbcount               : Tdbcount;
  dbcurcmd              : Tdbcurcmd;
  dbcurrow              : Tdbcurrow;

  dbcursor              : Tdbcursor;
  dbcursorbind          : Tdbcursorbind;
  dbcursorclose         : Tdbcursorclose;
  dbcursorcolinfo       : Tdbcursorcolinfo;
  dbcursorfetch         : Tdbcursorfetch;
  dbcursorfetchex       : Tdbcursorfetchex;
  dbcursorinfo          : Tdbcursorinfo;
  dbcursorinfoex        : Tdbcursorinfoex;
  dbcursoropen          : Tdbcursoropen;
  dbdata                : Tdbdata;
  dbdataready           : Tdbdataready;
  dbdatecrack           : Tdbdatecrack;
  dbdatlen              : Tdbdatlen;
  dbdead                : Tdbdead;
  dbexit                : Tdbexit;
//  dbenlisttrans         : Tdbenlisttrans;
//  dbenlistxatrans       : Tdbenlistxatrans;
//  dbfcmd                :Tdbfcmd;
  dbfirstrow            : Tdbfirstrow;
  dbfreebuf             : Tdbfreebuf;
  dbfreelogin           : Tdbfreelogin;
  dbfreequal            : Tdbfreequal;
  dbgetchar             : Tdbgetchar;
  dbgetmaxprocs         : Tdbgetmaxprocs;
  dbgetoff              : Tdbgetoff;
  dbgetpacket           : Tdbgetpacket;
  dbgetrow              : Tdbgetrow;
  dbgettime             : Tdbgettime;
  dbgetuserdata         : Tdbgetuserdata;
  dbhasretstat          : Tdbhasretstat;
  dbinit                : Tdbinit;
  dbisavail             : Tdbisavail;
  dbiscount             : Tdbiscount;
  dbisopt               : Tdbisopt;
  dblastrow             : Tdblastrow;
  dblogin               : Tdblogin;
  dbmorecmds            : Tdbmorecmds;
  dbmoretext            : Tdbmoretext;
  dbname                : Tdbname;
  dbnextrow             : Tdbnextrow;
  dbnullbind            : Tdbnullbind;
  dbnumalts             : Tdbnumalts;
  dbnumcols             : Tdbnumcols;
  dbnumcompute          : Tdbnumcompute;
  dbnumorders           : Tdbnumorders;
  dbnumrets             : Tdbnumrets;
  dbopen                : Tdbopen;
  dbordercol            : Tdbordercol;
  dbprocinfo            : Tdbprocinfo;
  dbprhead              : Tdbprhead;
  dbprrow               : Tdbprrow;
  dbprtype              : Tdbprtype;
  dbqual                : Tdbqual;
//  dbreadpage            : Tdbreadpage;
  dbreadtext            : Tdbreadtext;
  dbresults             : Tdbresults;
  dbretdata             : Tdbretdata;
  dbretlen              : Tdbretlen;
  dbretname             : Tdbretname;
  dbretstatus           : Tdbretstatus;
  dbrettype             : Tdbrettype;
  dbrows                : Tdbrows;
  dbrowtype             : Tdbrowtype;
  dbrpcinit             : Tdbrpcinit;
  dbrpcparam            : Tdbrpcparam;
  dbrpcsend             : Tdbrpcsend;
  dbrpcexec             : Tdbrpcexec;

  dbrpwclr              : Tdbrpwclr;
//  dbrpwset              : Tdbrpwset;
  dbserverenum          : Tdbserverenum;
  dbsetavail            : Tdbsetavail;
  dbsetmaxprocs         : Tdbsetmaxprocs;
  dbsetlname            : Tdbsetlname;
  dbsetlogintime        : Tdbsetlogintime;

  dbsetlpacket          : Tdbsetlpacket;
  dbsetnull             : Tdbsetnull;
  dbsetopt              : Tdbsetopt;
  dbsettime             : Tdbsettime;
  dbsetuserdata         : Tdbsetuserdata;
  dbsqlexec             : Tdbsqlexec;
  dbsqlok               : Tdbsqlok;
  dbsqlsend             : Tdbsqlsend;
  dbstrcpy              : Tdbstrcpy;
  dbstrlen              : Tdbstrlen;
  dbtabbrowse           : Tdbtabbrowse;
  dbtabcount            : Tdbtabcount;
  dbtabname             : Tdbtabname;
  dbtabsource           : Tdbtabsource;
  dbtsnewlen            : Tdbtsnewlen;
  dbtsnewval            : Tdbtsnewval;
  dbtsput               : Tdbtsput;
  dbtxptr               : Tdbtxptr;
  dbtxtimestamp         : Tdbtxtimestamp;
  dbtxtsnewval          : Tdbtxtsnewval;
  dbtxtsput             : Tdbtxtsput;
  dbuse                 : Tdbuse;
  dbvarylen             : Tdbvarylen;
  dbwillconvert         : Tdbwillconvert;
//  dbwritepage           : Tdbwritepage;
  dbwritetext           : Tdbwritetext;
  dbupdatetext          : Tdbupdatetext;

function dbsqlerror: string;
function dboserror: string;
function dbmessage: string;

function SySQLLoadLib: Boolean;

const
  DLL: string = DEFAULT_DLL_LOCATION;
  hDLL: THandle = 0;
  LibLoaded: Boolean = False;

implementation


uses SysUtils, ZDBaseConst;

{ Handle sql server errors }

const
  DbErrorCode: Integer = 0;
  OsErrorCode: Integer = 0;
  DbMsgCode: Integer = 0;
  DbError: string = '';
  OsError: string = '';
  DbMsg: string = '';

var
  OldErrorHandle: DBERRHANDLE_PROC = nil;
  OldMessageHandle: DBMSGHANDLE_PROC = nil;

{ Handle sql server error messages }
function ErrorHandle(Proc: PDBPROCESS; Severity, DbErr, OsErr: Integer;
  DbErrStr, OsErrStr: PChar): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
begin
  DbErrorCode := DbErr;
  OsErrorCode := OsErr;
  DbError := StrPas(DbErrStr);
  OsError := StrPas(OsErrStr);
  Result := 0;
end;

{ Handle sql server messages }
function MessageHandle(Proc: PDBPROCESS; MsgNo: DBINT; MsgState, Severity: Integer;
  MsgText, SrvName, ProcName: PChar; Line: DBUSMALLINT): Integer; {$IFNDEF LINUX} stdcall {$ELSE} cdecl {$ENDIF};
begin
  if MsgState > 0 then  // mjd 10/5/2001 - as per MSSQL changes
  begin
    DbMsgCode := MsgNo;
    DbMsg := StrPas(MsgText);
  end;
  Result := 0;
end;

function dbsqlerror: string;
begin
  Result := DbError;
end;

function dboserror: string;
begin
  Result := OsError;
end;

// mjd 10/3/2001 - added mygetprocaddress to find unresolved externals to DLL for debugging DB-Lib
function MyGetProcAddress( hModule: THandle; lpProcName: Pchar): Pointer;
begin
  result := GetProcAddress( hModule, lpProcName );
  if result = nil then
    raise exception.create( 'Couldn''t find procedure entry point for: ' + lpProcName +' in '+ DLL  );
end;

function dbmessage: string;
begin
  Result := DbMsg;
end;

{ Initialize Sybase SQL dynamic library }
function SySQLLoadLib: Boolean;
begin
  if hDLL = 0 then
  begin
    hDLL := GetModuleHandle(PChar(DLL));
    LibLoaded := False;
    if hDLL = 0 then
    begin
      hDLL := LoadLibrary(PChar(DLL));
      LibLoaded := True;
    end;
  end;

  if hDLL <> 0 then
  begin
    @dberrhandle           := MyGetProcAddress(hDLL,'dberrhandle');
    @dbmsghandle           := MyGetProcAddress(hDLL,'dbmsghandle');
//    @dbprocerrhandle       := MyGetProcAddress(hDLL,'dbprocerrhandle'); // mjd 10/4/2001 - not implemented
//    @dbprocmsghandle       := MyGetProcAddress(hDLL,'dbprocmsghandle'); // mjd 10/4/2001 - not implemented
    @abort_xact            := MyGetProcAddress(hDLL,'abort_xact');
    @build_xact_string     := MyGetProcAddress(hDLL,'build_xact_string');
    @close_commit          := MyGetProcAddress(hDLL,'close_commit');
    @commit_xact           := MyGetProcAddress(hDLL,'commit_xact');
    @open_commit           := MyGetProcAddress(hDLL,'open_commit');
    @remove_xact           := MyGetProcAddress(hDLL,'remove_xact');
    @scan_xact             := MyGetProcAddress(hDLL,'scan_xact');
    @start_xact            := MyGetProcAddress(hDLL,'start_xact');
    @stat_xact             := MyGetProcAddress(hDLL,'stat_xact');
    @bcp_batch             := MyGetProcAddress(hDLL,'bcp_batch');
    @bcp_bind              := MyGetProcAddress(hDLL,'bcp_bind');
    @bcp_colfmt            := MyGetProcAddress(hDLL,'bcp_colfmt');
    @bcp_collen            := MyGetProcAddress(hDLL,'bcp_collen');
    @bcp_colptr            := MyGetProcAddress(hDLL,'bcp_colptr');
    @bcp_columns           := MyGetProcAddress(hDLL,'bcp_columns');
    @bcp_control           := MyGetProcAddress(hDLL,'bcp_control');
    @bcp_done              := MyGetProcAddress(hDLL,'bcp_done');
    @bcp_exec              := MyGetProcAddress(hDLL,'bcp_exec');
    @bcp_init              := MyGetProcAddress(hDLL,'bcp_init');
    @bcp_moretext          := MyGetProcAddress(hDLL,'bcp_moretext');
    @bcp_readfmt           := MyGetProcAddress(hDLL,'bcp_readfmt');
    @bcp_sendrow           := MyGetProcAddress(hDLL,'bcp_sendrow');
//    @bcp_setl              := MyGetProcAddress(hDLL,'bcp_setl');  // mjd 10/4/2001 - not implemented
    @bcp_writefmt          := MyGetProcAddress(hDLL,'bcp_writefmt');
    @dbadata               := MyGetProcAddress(hDLL,'dbadata');
    @dbadlen               := MyGetProcAddress(hDLL,'dbadlen');
    @dbaltbind             := MyGetProcAddress(hDLL,'dbaltbind');
    @dbaltcolid            := MyGetProcAddress(hDLL,'dbaltcolid');
    @dbaltlen              := MyGetProcAddress(hDLL,'dbaltlen');
    @dbaltop               := MyGetProcAddress(hDLL,'dbaltop');
    @dbalttype             := MyGetProcAddress(hDLL,'dbalttype');
    @dbaltutype            := MyGetProcAddress(hDLL,'dbaltutype');
    @dbanullbind           := MyGetProcAddress(hDLL,'dbanullbind');
    @dbbind                := MyGetProcAddress(hDLL,'dbbind');
    @dbbylist              := MyGetProcAddress(hDLL,'dbbylist');
    @dbcancel              := MyGetProcAddress(hDLL,'dbcancel');
    @dbcanquery            := MyGetProcAddress(hDLL,'dbcanquery');
    @dbchange              := MyGetProcAddress(hDLL,'dbchange');
    @dbclose               := MyGetProcAddress(hDLL,'dbclose');
    @dbclrbuf              := MyGetProcAddress(hDLL,'dbclrbuf');
    @dbclropt              := MyGetProcAddress(hDLL,'dbclropt');
    @dbcmd                 := MyGetProcAddress(hDLL,'dbcmd');
    @dbcmdrow              := MyGetProcAddress(hDLL,'dbcmdrow');
    @dbcolbrowse           := MyGetProcAddress(hDLL,'dbcolbrowse');
//    @dbcolinfo             := MyGetProcAddress(hDLL,'dbcolinfo'); // mjd 10/4/2001 - not implemented
    @dbcollen              := MyGetProcAddress(hDLL,'dbcollen');
    @dbcolname             := MyGetProcAddress(hDLL,'dbcolname');
    @dbcolsource           := MyGetProcAddress(hDLL,'dbcolsource');
    @dbcoltype             := MyGetProcAddress(hDLL,'dbcoltype');
    @dbcolutype            := MyGetProcAddress(hDLL,'dbcolutype');
    @dbconvert             := MyGetProcAddress(hDLL,'dbconvert');
    @dbcount               := MyGetProcAddress(hDLL,'dbcount');
    @dbcurcmd              := MyGetProcAddress(hDLL,'dbcurcmd');
    @dbcurrow              := MyGetProcAddress(hDLL,'dbcurrow');
    @dbcursor              := MyGetProcAddress(hDLL,'dbcursor');
    @dbcursorbind          := MyGetProcAddress(hDLL,'dbcursorbind');
    @dbcursorclose         := MyGetProcAddress(hDLL,'dbcursorclose');
    @dbcursorcolinfo       := MyGetProcAddress(hDLL,'dbcursorcolinfo');
    @dbcursorfetch         := MyGetProcAddress(hDLL,'dbcursorfetch');
//    @dbcursorfetchex       := MyGetProcAddress(hDLL,'dbcursorfetchex'); // mjd 10/4/2001 - not implemented
    @dbcursorinfo          := MyGetProcAddress(hDLL,'dbcursorinfo');
//    @dbcursorinfoex        := MyGetProcAddress(hDLL,'dbcursorinfoex'); // mjd 10/4/2001 - not implemented
    @dbcursoropen          := MyGetProcAddress(hDLL,'dbcursoropen');
    @dbdata                := MyGetProcAddress(hDLL,'dbdata');
//    @dbdataready           := MyGetProcAddress(hDLL,'dbdataready'); // mjd 10/4/2001 - not implemented
    @dbdatecrack           := MyGetProcAddress(hDLL,'dbdatecrack');
    @dbdatlen              := MyGetProcAddress(hDLL,'dbdatlen');
    @dbdead                := MyGetProcAddress(hDLL,'dbdead');
    @dbexit                := MyGetProcAddress(hDLL,'dbexit');
//    @dbenlisttrans         := MyGetProcAddress(hDLL,'dbenlisttrans');
//    @dbenlistxatrans       := MyGetProcAddress(hDLL,'dbenlistxatrans');
//    @dbfcmd                := MyGetProcAddress(hDLL,'dbfcmd');
    @dbfirstrow            := MyGetProcAddress(hDLL,'dbfirstrow');
    @dbfreebuf             := MyGetProcAddress(hDLL,'dbfreebuf');
//    @dbfreelogin           := MyGetProcAddress(hDLL,'dbfreelogin'); //mjd
    @dbfreelogin           := MyGetProcAddress(hDLL,'dbloginfree'); //mjd - sybase and MS difference
    @dbfreequal            := MyGetProcAddress(hDLL,'dbfreequal');
    @dbgetchar             := MyGetProcAddress(hDLL,'dbgetchar');
    @dbgetmaxprocs         := MyGetProcAddress(hDLL,'dbgetmaxprocs');
    @dbgetoff              := MyGetProcAddress(hDLL,'dbgetoff');
    @dbgetpacket           := MyGetProcAddress(hDLL,'dbgetpacket');
    @dbgetrow              := MyGetProcAddress(hDLL,'dbgetrow');
//    @dbgettime             := MyGetProcAddress(hDLL,'dbgettime'); // mjd 10/4/2001 - not implemented
    @dbgetuserdata         := MyGetProcAddress(hDLL,'dbgetuserdata');
    @dbhasretstat          := MyGetProcAddress(hDLL,'dbhasretstat');
    @dbinit                := MyGetProcAddress(hDLL,'dbinit');
    @dbisavail             := MyGetProcAddress(hDLL,'dbisavail');
//    @dbiscount             := MyGetProcAddress(hDLL,'dbiscount'); // mjd 10/4/2001 - not implemented
    @dbisopt               := MyGetProcAddress(hDLL,'dbisopt');
    @dblastrow             := MyGetProcAddress(hDLL,'dblastrow');
    @dblogin               := MyGetProcAddress(hDLL,'dblogin');
    @dbmorecmds            := MyGetProcAddress(hDLL,'dbmorecmds');
    @dbmoretext            := MyGetProcAddress(hDLL,'dbmoretext');
    @dbname                := MyGetProcAddress(hDLL,'dbname');
    @dbnextrow             := MyGetProcAddress(hDLL,'dbnextrow');
    @dbnullbind            := MyGetProcAddress(hDLL,'dbnullbind');
    @dbnumalts             := MyGetProcAddress(hDLL,'dbnumalts');
    @dbnumcols             := MyGetProcAddress(hDLL,'dbnumcols');
    @dbnumcompute          := MyGetProcAddress(hDLL,'dbnumcompute');
    @dbnumorders           := MyGetProcAddress(hDLL,'dbnumorders');
    @dbnumrets             := MyGetProcAddress(hDLL,'dbnumrets');
    @dbopen                := MyGetProcAddress(hDLL,'dbopen');
    @dbordercol            := MyGetProcAddress(hDLL,'dbordercol');
//    @dbprocinfo            := MyGetProcAddress(hDLL,'dbprocinfo'); // mjd 10/4/2001 - not implemented
    @dbprhead              := MyGetProcAddress(hDLL,'dbprhead');
    @dbprrow               := MyGetProcAddress(hDLL,'dbprrow');
    @dbprtype              := MyGetProcAddress(hDLL,'dbprtype');
    @dbqual                := MyGetProcAddress(hDLL,'dbqual');
//    @dbreadpage            := MyGetProcAddress(hDLL,'dbreadpage');
    @dbreadtext            := MyGetProcAddress(hDLL,'dbreadtext');
    @dbresults             := MyGetProcAddress(hDLL,'dbresults');
    @dbretdata             := MyGetProcAddress(hDLL,'dbretdata');
    @dbretlen              := MyGetProcAddress(hDLL,'dbretlen');
    @dbretname             := MyGetProcAddress(hDLL,'dbretname');
    @dbretstatus           := MyGetProcAddress(hDLL,'dbretstatus');
    @dbrettype             := MyGetProcAddress(hDLL,'dbrettype');
    @dbrows                := MyGetProcAddress(hDLL,'dbrows');
    @dbrowtype             := MyGetProcAddress(hDLL,'dbrowtype');
    @dbrpcinit             := MyGetProcAddress(hDLL,'dbrpcinit');
    @dbrpcparam            := MyGetProcAddress(hDLL,'dbrpcparam');
    @dbrpcsend             := MyGetProcAddress(hDLL,'dbrpcsend');
//    @dbrpcexec             := MyGetProcAddress(hDLL,'dbrpcexec'); // mjd 10/4/2001 - not implemented
    @dbrpwclr              := MyGetProcAddress(hDLL,'dbrpwclr');
//    @dbrpwset              := MyGetProcAddress(hDLL,'dbrpwset');
//    @dbserverenum          := MyGetProcAddress(hDLL,'dbserverenum'); // mjd 10/4/2001 - not implemented
    @dbsetavail            := MyGetProcAddress(hDLL,'dbsetavail');
    @dbsetmaxprocs         := MyGetProcAddress(hDLL,'dbsetmaxprocs');
    @dbsetlname            := MyGetProcAddress(hDLL,'dbsetlname');
    @dbsetlogintime        := MyGetProcAddress(hDLL,'dbsetlogintime');
//    @dbsetlpacket          := MyGetProcAddress(hDLL,'dbsetlpacket'); // mjd 10/4/2001 - not implemented
    @dbsetnull             := MyGetProcAddress(hDLL,'dbsetnull');
    @dbsetopt              := MyGetProcAddress(hDLL,'dbsetopt');
    @dbsettime             := MyGetProcAddress(hDLL,'dbsettime');
    @dbsetuserdata         := MyGetProcAddress(hDLL,'dbsetuserdata');
    @dbsqlexec             := MyGetProcAddress(hDLL,'dbsqlexec');
    @dbsqlok               := MyGetProcAddress(hDLL,'dbsqlok');
    @dbsqlsend             := MyGetProcAddress(hDLL,'dbsqlsend');
    @dbstrcpy              := MyGetProcAddress(hDLL,'dbstrcpy');
    @dbstrlen              := MyGetProcAddress(hDLL,'dbstrlen');
    @dbtabbrowse           := MyGetProcAddress(hDLL,'dbtabbrowse');
    @dbtabcount            := MyGetProcAddress(hDLL,'dbtabcount');
    @dbtabname             := MyGetProcAddress(hDLL,'dbtabname');
    @dbtabsource           := MyGetProcAddress(hDLL,'dbtabsource');
    @dbtsnewlen            := MyGetProcAddress(hDLL,'dbtsnewlen');
    @dbtsnewval            := MyGetProcAddress(hDLL,'dbtsnewval');
    @dbtsput               := MyGetProcAddress(hDLL,'dbtsput');
    @dbtxptr               := MyGetProcAddress(hDLL,'dbtxptr');
    @dbtxtimestamp         := MyGetProcAddress(hDLL,'dbtxtimestamp');
    @dbtxtsnewval          := MyGetProcAddress(hDLL,'dbtxtsnewval');
    @dbtxtsput             := MyGetProcAddress(hDLL,'dbtxtsput');
    @dbuse                 := MyGetProcAddress(hDLL,'dbuse');
    @dbvarylen             := MyGetProcAddress(hDLL,'dbvarylen');
    @dbwillconvert         := MyGetProcAddress(hDLL,'dbwillconvert');
//    @dbwritepage           := MyGetProcAddress(hDLL,'dbwritepage');
    @dbwritetext           := MyGetProcAddress(hDLL,'dbwritetext');
//    @dbupdatetext          := MyGetProcAddress(hDLL,'dbupdatetext'); // mjd 10/4/2001 - not implemented

    OldErrorHandle := dberrhandle(ErrorHandle);
    OldMessageHandle := dbmsghandle(MessageHandle);

    Result := True;
  end else
    raise Exception.Create(Format(SLibraryNotFound,[DLL]));
end;

function DBSETLHOST(Login: PLOGINREC; ClientHost: PChar): RETCODE;
begin
  Result := dbsetlname(Login, ClientHost, DBSETHOST);
end;

function DBSETLUSER(Login: PLOGINREC; UserName: PChar): RETCODE;
begin
  Result := dbsetlname(Login, UserName, DBSETUSER);
end;

function DBSETLPWD(Login: PLOGINREC; Passwd: PChar): RETCODE;
begin
  Result := dbsetlname(Login, Passwd, DBSETPWD);
end;

function DBSETLAPP(Login: PLOGINREC; AppName: PChar): RETCODE;
begin
  Result := dbsetlname(Login, AppName, DBSETAPP);
end;

function DBSETLNATLANG(Login: PLOGINREC; Lang: PChar): RETCODE;
begin
  Result := dbsetlname(Login, Lang, DBSETLANG);
end;

function DBSETLSECURE(Login: PLOGINREC): RETCODE;
begin
  Result := dbsetlname(Login, nil, DBSETSECURE);
end;

function DBSETLVERSION(Login: PLOGINREC; Version: Byte): RETCODE;
begin
  Result := dbsetlname(Login, nil, Version);
end;

function DBSETLTIME(Login: PLOGINREC; Seconds: DWORD): RETCODE;
begin
  Result := dbsetlname(Login, PChar(Cardinal(Seconds)), DBSET_LOGIN_TIME);
end;

function DBSETLFALLBACK(Login: PLOGINREC; Fallback: PChar): RETCODE;
begin
  Result := dbsetlname(Login, Fallback, DBSETFALLBACK);
end;

function dbrbuf(Proc: PDBPROCESS): DBINT;
begin
  Result := DBINT(dbdataready(Proc)); 
end;

initialization

finalization
  if hDLL <> 0 then
  begin
    dberrhandle(OldErrorHandle);
    dbmsghandle(OldMessageHandle);
    if LibLoaded then
    begin
      dbexit;
      FreeLibrary(hDLL);
    end;
  end;
end.
