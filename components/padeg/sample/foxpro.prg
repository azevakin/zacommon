*     _______________________________________Петров А.О.__
*    |  Преобразование ФИО v2.1							  |
*    |  Адаптация всех функций под Visual FoxPRO		  |
*    |  Программа FoxPRO.prg							  |
*    |____________________________________________________|
*    |  Дата изменения: 13.04.05,   написана  11.02.04    |
*    |____________________________________________________|
* 13.04.05 Исправил багис с полом

#DEFINE MAX_FIO_LEN 100
PRIVATE f,l,s
m.f='Петрова'
m.l='Мария'
m.s='Ивановна'
m.sex='ж'

DECLARE integer GetFIOPadeg IN padeg.dll;
	string pFirstName,;
	string pLastName,;
	string pMiddleName,;
	integer bSex,;
	integer nPadeg,;
	string @pResult,;
	integer @nLen
	
DECLARE integer GetFIOPadegAS IN padeg.dll;
	string pFirstName,;
	string plastName,;
	string pMiddleName,;
	integer nPadeg,;
	string @pResult,;
	integer @nLen

DECLARE integer GetFIOPadegFS IN padeg.dll;
	string pFIO,;
	integer bSex,;
	integer nPadeg,;
	string @pResult,;
	integer @nLen

DECLARE integer GetFIOPadegFSAS IN padeg.dll;
	string pFIO,;
	integer nPadeg,;
	string @pResult,;
	integer @nLen
	
DECLARE integer GetIFPadeg IN padeg.dll;
	string pFirstName,;
	string pLastName,;
	integer bSex,;
	integer nPadeg,;
	string @pResult,;
	integer @nLen

DECLARE integer GetIFPadegFS IN padeg.dll;
	string pIF,;
	integer bSex,;
	integer nPadeg,;
	string @pResult,;
	integer @nLen
	
DECLARE integer GetNominativePadeg IN padeg.dll;
	string pFIO,;
	string @pResult,;
	integer @nLen

DECLARE integer UpdateExceptions IN padeg.dll;

*  ============================== КОД ЗДЕСЬ =================================
PRIVATE _l

CLEAR
FOR m.x=1 TO 6
	m._l=MAX_FIO_LEN
	m.str=SPACE(m._l)
	=getfiopadeg(m.f,m.l,m.s,IIF(m.sex='м',1,0),m.x,@str,@_l)
	? 'Номер падежа = ',x,' ФИО = ',SUBSTR(str,1,m._l)
ENDFOR

? 'GetFIO			= ',getfio(m.f,m.l,m.s,ASC(m.sex),2)
? 'GetFIOFromStr		= ',getfiofromstr(f+' '+l+' '+s,ASC(m.sex),2)
? 'GetIF			= ',getif(m.f,m.l,ASC(m.sex),2)
? 'GetIFFromStr		= ',getiffromstr(m.f+' '+m.l,ASC(m.sex),2)
? 'GetNominative		= ',getnominative(getfio(m.f,m.l,m.s,ASC(m.sex),2))

? 'UpdateExceptions = ',UpdateExceptions()#0
*  ==========================================================================

FUNCTION GetFIO
LPARAMETERS pFirstName, plastName, pMiddleName, bSex, nPadeg
PRIVATE result, l
m.l=MAX_FIO_LEN
m.result=REPLICATE(CHR(0),m.l)
m.bsex=IIF(m.sex='м',1,0)
=getfiopadeg(pFirstName, plastName, pMiddleName, bSex, nPadeg, @result, @l)
RETURN SUBSTR(m.result,1,m.l)

FUNCTION GetFIOFromStr
LPARAMETERS pFIO, bSex, nPadeg
PRIVATE result, l
m.l=MAX_FIO_LEN
m.result=REPLICATE(CHR(0),m.l)
m.bsex=IIF(m.sex='м',1,0)
=getFIOPadegFS(pFIO, bSex, nPadeg, @result, @l)
RETURN SUBSTR(m.result,1,m.l)

FUNCTION GetIF
LPARAMETERS plastName, pFirstName, bSex, nPadeg
PRIVATE result, l
m.l=MAX_FIO_LEN
m.result=REPLICATE(CHR(0),m.l)
m.bsex=IIF(m.sex='м',1,0)
=GetIFpadeg(plastName, pFirstName, bSex, nPadeg, @result, @l)
RETURN SUBSTR(m.result,1,m.l)

FUNCTION GetIFFromStr
LPARAMETERS pIF, bSex, nPadeg
PRIVATE result, l
m.l=MAX_FIO_LEN
m.result=REPLICATE(CHR(0),m.l)
m.bsex=IIF(m.sex='м',1,0)
=getIFPadegFS(pIF, bSex, nPadeg, @result, @l)
RETURN SUBSTR(m.result,1,m.l)

FUNCTION GetNominative
LPARAMETERS pFIO
PRIVATE result, l
m.l=MAX_FIO_LEN
m.result=REPLICATE(CHR(0),m.l)
m.bsex=IIF(m.sex='м',1,0)
=getnominativepadeg(pFIO, @result, @l)
RETURN SUBSTR(m.result,1,m.l)