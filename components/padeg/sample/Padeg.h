#ifndef ___Padeg_H
#define Padeg_v2
#define Padeg_v3
#define ___Padeg_H

typedef int (__stdcall *tdGetFIOPadeg)(unsigned char *, unsigned char *, unsigned char *, BOOL, int, unsigned char *, int *);
typedef int (__stdcall *tdGetFIOPadegAS)(unsigned char *, unsigned char *, unsigned char *, int, unsigned char *, int *);
typedef int (__stdcall *tdGetFIOPadegFS)(unsigned char *, BOOL, int, unsigned char *, int *);
typedef int (__stdcall *tdGetFIOPadegFSAS)(unsigned char *, int, unsigned char *, int *);
typedef int (__stdcall *tdGetIFPadeg)(unsigned char *, unsigned char *, BOOL, int, unsigned char *, int *);
typedef int (__stdcall *tdGetIFPadegFS)(unsigned char *, BOOL, int, unsigned char *, int *);
typedef int (__stdcall *tdGetNominativePadeg)(unsigned char *, int *);
typedef BOOL (__stdcall *tdUpdateExceptions)(void);

#ifdef Padeg_v3

typedef struct 
{
	unsigned char * szLastName;
	unsigned char * szFirstName; 
	unsigned char * szMiddleName;
	int cbLastName, cbFirstName, cbMiddleName;
} TPartsFIO, * PPartsFIO;

typedef int (__stdcall *tdGetAppointmentPadeg)(unsigned char *, int, unsigned char *, int *);
typedef int (__stdcall *tdGetOfficePadeg)(unsigned char *, int, unsigned char *, int *);
typedef int (__stdcall *tdGetSex)(unsigned char *);
typedef int (__stdcall *tdGetFIOParts)(unsigned char *, PPartsFIO);
#endif

#endif