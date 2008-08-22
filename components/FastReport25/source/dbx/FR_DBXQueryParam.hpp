// Borland C++ Builder
// Copyright (c) 1995, 2002 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FR_DBXQueryParam.pas' rev: 6.00

#ifndef FR_DBXQueryParamHPP
#define FR_DBXQueryParamHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <FR_DBXQuery.hpp>	// Pascal unit
#include <SqlExpr.hpp>	// Pascal unit
#include <DBXpress.hpp>	// Pascal unit
#include <DB.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <FR_Ctrls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fr_dbxqueryparam
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrDBXParamsForm;
class PASCALIMPLEMENTATION TfrDBXParamsForm : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TGroupBox* GroupBox1;
	Stdctrls::TLabel* Label2;
	Stdctrls::TListBox* ParamsLB;
	Stdctrls::TComboBox* TypeCB;
	Stdctrls::TRadioButton* ValueRB;
	Stdctrls::TRadioButton* AssignRB;
	Stdctrls::TLabel* Label1;
	Fr_ctrls::TfrComboEdit* ValueE;
	Stdctrls::TButton* Button1;
	Stdctrls::TButton* Button2;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall ParamsLBClick(System::TObject* Sender);
	void __fastcall ValueEExit(System::TObject* Sender);
	void __fastcall TypeCBChange(System::TObject* Sender);
	void __fastcall ValueRBClick(System::TObject* Sender);
	void __fastcall AssignRBClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall VarSBClick(System::TObject* Sender);
	
private:
	bool FBusy;
	int __fastcall CurParam(void);
	void __fastcall Localize(void);
	
public:
	Sqlexpr::TSQLQuery* Query;
	Fr_dbxquery::TfrDBXQuery* QueryComp;
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TfrDBXParamsForm(Classes::TComponent* AOwner) : Forms::TForm(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrDBXParamsForm(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrDBXParamsForm(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TfrDBXParamsForm(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Fr_dbxqueryparam */
using namespace Fr_dbxqueryparam;
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FR_DBXQueryParam
