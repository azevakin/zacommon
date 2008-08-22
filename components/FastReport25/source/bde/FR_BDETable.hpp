// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FR_BDETable.pas' rev: 5.00

#ifndef FR_BDETableHPP
#define FR_BDETableHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <FR_DBSet.hpp>	// Pascal unit
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

namespace Fr_bdetable
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrBDEDataset;
class PASCALIMPLEMENTATION TfrBDEDataset : public Fr_class::TfrNonVisualControl 
{
	typedef Fr_class::TfrNonVisualControl inherited;
	
protected:
	Dbtables::TDBDataSet* FDataSet;
	Db::TDataSource* FDataSource;
	Fr_dbset::TfrDBDataSet* FDBDataSet;
	void __fastcall FieldsEditor(System::TObject* Sender);
	void __fastcall ReadFields(Classes::TStream* Stream);
	void __fastcall WriteFields(Classes::TStream* Stream);
	virtual void __fastcall SetPropValue(AnsiString Index, const Variant &Value);
	virtual Variant __fastcall GetPropValue(AnsiString Index);
	virtual Variant __fastcall DoMethod(AnsiString MethodName, const Variant &Par1, const Variant &Par2
		, const Variant &Par3);
	
public:
	__fastcall virtual TfrBDEDataset(void);
	__fastcall virtual ~TfrBDEDataset(void);
	virtual void __fastcall DefineProperties(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall ShowEditor(void);
};


class DELPHICLASS TfrBDETable;
class PASCALIMPLEMENTATION TfrBDETable : public TfrBDEDataset 
{
	typedef TfrBDEDataset inherited;
	
private:
	Dbtables::TTable* FTable;
	void __fastcall JoinEditor(System::TObject* Sender);
	
protected:
	virtual void __fastcall SetPropValue(AnsiString Index, const Variant &Value);
	virtual Variant __fastcall GetPropValue(AnsiString Index);
	
public:
	__fastcall virtual TfrBDETable(void);
	virtual void __fastcall LoadFromStream(Classes::TStream* Stream);
	virtual void __fastcall SaveToStream(Classes::TStream* Stream);
	virtual void __fastcall DefineProperties(void);
	virtual void __fastcall Loaded(void);
	__property Dbtables::TTable* Table = {read=FTable};
public:
	#pragma option push -w-inl
	/* TfrBDEDataset.Destroy */ inline __fastcall virtual ~TfrBDETable(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Fr_bdetable */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Fr_bdetable;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FR_BDETable
