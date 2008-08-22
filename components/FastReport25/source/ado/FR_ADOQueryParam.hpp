// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FR_ADOQueryParam.pas' rev: 5.00

#ifndef FR_ADOQueryParamHPP
#define FR_ADOQueryParamHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <FR_ADOQuery.hpp>	// Pascal unit
#include <ADOInt.hpp>	// Pascal unit
#include <ADODB.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
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

namespace Fr_adoqueryparam
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrADOParamsForm;
class PASCALIMPLEMENTATION TfrADOParamsForm : public Forms::TForm 
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
	Adodb::TADOQuery* Query;
	Fr_adoquery::TfrADOQuery* QueryComp;
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TfrADOParamsForm(Classes::TComponent* AOwner) : 
		Forms::TForm(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrADOParamsForm(Classes::TComponent* AOwner, 
		int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrADOParamsForm(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TfrADOParamsForm(HWND ParentWindow) : Forms::TForm(
		ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Fr_adoqueryparam */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Fr_adoqueryparam;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FR_ADOQueryParam
