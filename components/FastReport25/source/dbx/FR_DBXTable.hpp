// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FR_DBXTable.pas' rev: 6.00

#ifndef FR_DBXTableHPP
#define FR_DBXTableHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <FR_DBSet.hpp>	// Pascal unit
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

namespace Fr_dbxtable
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrDBXDataset;
class PASCALIMPLEMENTATION TfrDBXDataset : public Fr_class::TfrNonVisualControl 
{
	typedef Fr_class::TfrNonVisualControl inherited;
	
protected:
	Sqlexpr::TSQLDataSet* FDataSet;
	Db::TDataSource* FDataSource;
	Fr_dbset::TfrDBDataSet* FDBDataSet;
	void __fastcall FieldsEditor(System::TObject* Sender);
	void __fastcall ReadFields(Classes::TStream* Stream);
	void __fastcall WriteFields(Classes::TStream* Stream);
	virtual void __fastcall SetPropValue(AnsiString Index, const Variant &Value);
	virtual Variant __fastcall GetPropValue(AnsiString Index);
	virtual Variant __fastcall DoMethod(AnsiString MethodName, const Variant &Par1, const Variant &Par2, const Variant &Par3);
	
public:
	__fastcall virtual TfrDBXDataset(void);
	__fastcall virtual ~TfrDBXDataset(void);
	virtual void __fastcall DefineProperties(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall ShowEditor(void);
};


class DELPHICLASS TfrDBXTable;
class PASCALIMPLEMENTATION TfrDBXTable : public TfrDBXDataset 
{
	typedef TfrDBXDataset inherited;
	
private:
	Sqlexpr::TSQLTable* FTable;
	void __fastcall JoinEditor(System::TObject* Sender);
	
protected:
	virtual void __fastcall SetPropValue(AnsiString Index, const Variant &Value);
	virtual Variant __fastcall GetPropValue(AnsiString Index);
	
public:
	__fastcall virtual TfrDBXTable(void);
	virtual void __fastcall LoadFromStream(Classes::TStream* Stream);
	virtual void __fastcall SaveToStream(Classes::TStream* Stream);
	virtual void __fastcall DefineProperties(void);
	virtual void __fastcall Loaded(void);
	__property Sqlexpr::TSQLTable* Table = {read=FTable};
public:
	#pragma option push -w-inl
	/* TfrDBXDataset.Destroy */ inline __fastcall virtual ~TfrDBXTable(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Fr_dbxtable */
using namespace Fr_dbxtable;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FR_DBXTable
