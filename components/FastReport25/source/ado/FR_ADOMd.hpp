// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FR_ADOMd.pas' rev: 5.00

#ifndef FR_ADOMdHPP
#define FR_ADOMdHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <FR_Const.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <ADOInt.hpp>	// Pascal unit
#include <ADODB.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
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

namespace Fr_adomd
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfrADOFieldsLinkForm;
class PASCALIMPLEMENTATION TfrADOFieldsLinkForm : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TListBox* DetailL;
	Stdctrls::TListBox* MasterL;
	Stdctrls::TLabel* Label1;
	Stdctrls::TLabel* Label2;
	Stdctrls::TButton* AddB;
	Stdctrls::TListBox* JoinL;
	Stdctrls::TLabel* Label3;
	Stdctrls::TButton* ClearB;
	Extctrls::TBevel* Bevel1;
	Stdctrls::TButton* OkB;
	Stdctrls::TButton* CancelB;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall ClearBClick(System::TObject* Sender);
	void __fastcall DetailLDrawItem(Controls::TWinControl* Control, int Index, const Windows::TRect &Rect
		, Windows::TOwnerDrawState State);
	void __fastcall DetailLClick(System::TObject* Sender);
	void __fastcall MasterLClick(System::TObject* Sender);
	void __fastcall AddBClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	
private:
	AnsiString FMasterFields;
	AnsiString FCurFields;
	Classes::TStringList* lm;
	Classes::TStringList* ld;
	void __fastcall FillLists(void);
	void __fastcall Localize(void);
	
public:
	Db::TDataSet* MasterDS;
	Adodb::TADOTable* DetailDS;
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TfrADOFieldsLinkForm(Classes::TComponent* AOwner
		) : Forms::TForm(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrADOFieldsLinkForm(Classes::TComponent* AOwner
		, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrADOFieldsLinkForm(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TfrADOFieldsLinkForm(HWND ParentWindow) : Forms::TForm(
		ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Fr_adomd */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Fr_adomd;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FR_ADOMd
