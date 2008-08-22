//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("ZSySqlCB5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("dbase\ZSySqlTr.pas");
USERES("dbase\ZSySqlTr.dcr");
USEUNIT("dbase\ZLibSySql.pas");
USEUNIT("dbase\ZSySqlCon.pas");
USERES("dbase\ZSySqlCon.dcr");
USEUNIT("dbase\ZSySqlProp.pas");
USEUNIT("dbase\ZSySqlQuery.pas");
USERES("dbase\ZSySqlQuery.dcr");
USEUNIT("dbase\ZSySqlReg.pas");
USEUNIT("dbase\ZDirSySql.pas");
USEUNIT("dbase\ZSySqlStoredProc.pas");
USEPACKAGE("ZDbwareCB5.bpi");
USEPACKAGE("ZCommonCB5.bpi");
USEPACKAGE("Vcldb50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
