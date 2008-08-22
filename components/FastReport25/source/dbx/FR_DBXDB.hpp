// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FR_DBXDB.pas' rev: 6.00

#ifndef FR_DBXDBHPP
#define FR_DBXDBHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <SqlExpr.hpp>	// Pascal unit
#include <DBXpress.hpp>	// Pascal unit
#include <DB.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <FR_Class.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fr_dbxdb
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrDBXComponents;
class PASCALIMPLEMENTATION TfrDBXComponents : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TfrDBXComponents(Classes::TComponent* AOwner) : Classes::TComponent(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrDBXComponents(void) { }
	#pragma option pop
	
};


class DELPHICLASS TfrDBXDatabase;
class PASCALIMPLEMENTATION TfrDBXDatabase : public Fr_class::TfrNonVisualControl 
{
	typedef Fr_class::TfrNonVisualControl inherited;
	
private:
	Sqlexpr::TSQLConnection* FDatabase;
	void __fastcall LinesEditor(System::TObject* Sender);
	
protected:
	virtual void __fastcall SetPropValue(AnsiString Index, const Variant &Value);
	virtual Variant __fastcall GetPropValue(AnsiString Index);
	virtual Variant __fastcall DoMethod(AnsiString MethodName, const Variant &Par1, const Variant &Par2, const Variant &Par3);
	
public:
	__fastcall virtual TfrDBXDatabase(void);
	__fastcall virtual ~TfrDBXDatabase(void);
	virtual void __fastcall LoadFromStream(Classes::TStream* Stream);
	virtual void __fastcall SaveToStream(Classes::TStream* Stream);
	virtual void __fastcall DefineProperties(void);
	__property Sqlexpr::TSQLConnection* Database = {read=FDatabase};
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Fr_dbxdb */
using namespace Fr_dbxdb;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FR_DBXDB
