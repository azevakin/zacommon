//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("ZSySqlCB4.res");
USEPACKAGE("vcl40.bpi");
USEPACKAGE("vcldb40.bpi");
USEUNIT("dbase\ZSySqlTr.pas");
USERES("dbase\ZSySqlTr.dcr");
USEUNIT("dbase\ZSySqlCon.pas");
USERES("dbase\ZSySqlCon.dcr");
USEUNIT("dbase\ZSySqlProp.pas");
USEUNIT("dbase\ZSySqlQuery.pas");
USERES("dbase\ZSySqlQuery.dcr");
USEUNIT("dbase\ZSySqlReg.pas");
USEUNIT("dbase\ZDirSySql.pas");
USEUNIT("dbase\ZSySqlStoredProc.pas");
USEPACKAGE("ZDbwareCB4.bpi");
USEPACKAGE("ZCommonCB4.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
