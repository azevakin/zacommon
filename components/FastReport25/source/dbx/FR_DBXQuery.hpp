// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FR_DBXQuery.pas' rev: 6.00

#ifndef FR_DBXQueryHPP
#define FR_DBXQueryHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <FR_DBUtils.hpp>	// Pascal unit
#include <SqlExpr.hpp>	// Pascal unit
#include <FR_DBXTable.hpp>	// Pascal unit
#include <DBXpress.hpp>	// Pascal unit
#include <DB.hpp>	// Pascal unit
#include <FR_Pars.hpp>	// Pascal unit
#include <FR_Class.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fr_dbxquery
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrDBXQuery;
class PASCALIMPLEMENTATION TfrDBXQuery : public Fr_dbxtable::TfrDBXDataset 
{
	typedef Fr_dbxtable::TfrDBXDataset inherited;
	
private:
	Sqlexpr::TSQLQuery* FQuery;
	Fr_pars::TfrVariables* FParams;
	void __fastcall SQLEditor(System::TObject* Sender);
	void __fastcall ParamsEditor(System::TObject* Sender);
	void __fastcall ReadParams(Classes::TStream* Stream);
	void __fastcall WriteParams(Classes::TStream* Stream);
	Fr_dbutils::TfrParamKind __fastcall GetParamKind(int Index);
	void __fastcall SetParamKind(int Index, Fr_dbutils::TfrParamKind Value);
	AnsiString __fastcall GetParamText(int Index);
	void __fastcall SetParamText(int Index, AnsiString Value);
	void __fastcall BeforeOpenQuery(Db::TDataSet* DataSet);
	
protected:
	virtual void __fastcall SetPropValue(AnsiString Index, const Variant &Value);
	virtual Variant __fastcall GetPropValue(AnsiString Index);
	virtual Variant __fastcall DoMethod(AnsiString MethodName, const Variant &Par1, const Variant &Par2, const Variant &Par3);
	
public:
	__fastcall virtual TfrDBXQuery(void);
	__fastcall virtual ~TfrDBXQuery(void);
	virtual void __fastcall LoadFromStream(Classes::TStream* Stream);
	virtual void __fastcall SaveToStream(Classes::TStream* Stream);
	virtual void __fastcall DefineProperties(void);
	virtual void __fastcall Loaded(void);
	__property Sqlexpr::TSQLQuery* Query = {read=FQuery};
	__property Fr_dbutils::TfrParamKind ParamKind[int Index] = {read=GetParamKind, write=SetParamKind};
	__property AnsiString ParamText[int Index] = {read=GetParamText, write=SetParamText};
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Fr_dbxquery */
using namespace Fr_dbxquery;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FR_DBXQuery
