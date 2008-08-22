// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FR_BDEDB.pas' rev: 5.00

#ifndef FR_BDEDBHPP
#define FR_BDEDBHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <DBTables.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
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

namespace Fr_bdedb
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrBDEComponents;
class PASCALIMPLEMENTATION TfrBDEComponents : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
public:
	#pragma option push -w-inl
	/* TComponent.Create */ inline __fastcall virtual TfrBDEComponents(Classes::TComponent* AOwner) : Classes::TComponent(
		AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TComponent.Destroy */ inline __fastcall virtual ~TfrBDEComponents(void) { }
	#pragma option pop
	
};


class DELPHICLASS TfrBDEDatabase;
class PASCALIMPLEMENTATION TfrBDEDatabase : public Fr_class::TfrNonVisualControl 
{
	typedef Fr_class::TfrNonVisualControl inherited;
	
private:
	Dbtables::TDatabase* FDatabase;
	void __fastcall LinesEditor(System::TObject* Sender);
	
protected:
	virtual void __fastcall SetPropValue(AnsiString Index, const Variant &Value);
	virtual Variant __fastcall GetPropValue(AnsiString Index);
	virtual Variant __fastcall DoMethod(AnsiString MethodName, const Variant &Par1, const Variant &Par2
		, const Variant &Par3);
	
public:
	__fastcall virtual TfrBDEDatabase(void);
	__fastcall virtual ~TfrBDEDatabase(void);
	virtual void __fastcall LoadFromStream(Classes::TStream* Stream);
	virtual void __fastcall SaveToStream(Classes::TStream* Stream);
	virtual void __fastcall DefineProperties(void);
	__property Dbtables::TDatabase* Database = {read=FDatabase};
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Fr_bdedb */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Fr_bdedb;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FR_BDEDB
