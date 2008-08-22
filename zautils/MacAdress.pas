{
*** Get MAC Adress ***
*** by Filip Skalka, fip@post.cz ***
*** September 2002 ***
}

unit MACAdress;

interface

uses classes;

function GetMACAddresses(const Adresses: TStringList;
  const MachineName: string = ''; const Separator: Char = ':'): Integer;
  
function GetMACAddress(const MachineName: string;
  const Separator: Char = ':'): string; overload;

implementation

uses NB30, SysUtils;

type
 ENetBIOSError = class(Exception);

function NetBiosCheck(const b: Char): Char;
begin
 if b <> chr(NRC_GOODRET) then
   raise ENetBIOSError.Create('NetBios error'#13#10'Error code ' + IntToStr(Ord(b)));
 Result := b;
end;

function AdapterToString(const Adapter: PAdapterStatus;
  const Separator: Char):string;
var
  AddressMask: String;
  I: Integer;
begin
 AddressMask := '%2.2x %2.2x %2.2x %2.2x %2.2x %2.2x';
 for I := 0 to Length(AddressMask)-1 do
   if AddressMask[I] = ' ' then
      AddressMask[I] := Separator;
 with Adapter^ do
   Result := Format(AddressMask,
     [Integer(adapter_address[0]), Integer(adapter_address[1]),
      Integer(adapter_address[2]), Integer(adapter_address[3]),
      Integer(adapter_address[4]), Integer(adapter_address[5])]);
end;

procedure MachineNameToAdapter(Name: string; var AdapterName: array of char);
begin
  if Name = '' then
    Name :='*'
  else
    Name := AnsiUpperCase(Name);
  Name := Name + StringOfChar(' ', Length(AdapterName) - Length(Name));
  Move(Name[1], AdapterName[0], Length(AdapterName));
end;

function GetMACAddresses(const Adresses: TStringList;
  const MachineName: string = ''; const Separator: Char = ':'):integer;
var
  i: Integer;
  NCB: PNCB;
  Adapter: PAdapterStatus;
  Lenum: PLanaEnum;
  RetCode: Char;
begin
  Adresses.Clear;

  New(NCB);
  New(Adapter);
  New(Lenum);
  try
    Fillchar(NCB^, SizeOf(TNCB), 0);
    FillChar(Lenum^, SizeOf(TLanaEnum), 0);
    NCB.ncb_command := chr(NCBENUM);
    NCB.ncb_buffer := Pointer(Lenum);
    NCB.ncb_length := SizeOf(Lenum);
    NetBiosCheck(Netbios(NCB));
    Result := Ord(Lenum.Length);

    for i := 0 to Result - 1 do
    begin
      Fillchar(NCB^, SizeOf(TNCB), 0);
      Ncb.ncb_command := chr(NCBRESET);
      Ncb.ncb_lana_num := lenum.lana[i];
      NetBiosCheck(Netbios(Ncb));

      FillChar(NCB^, SizeOf(TNCB), 0);
      FillChar(Adapter^, SizeOf(TAdapterStatus), 0);

      Ncb.ncb_command := chr(NCBASTAT);
      Ncb.ncb_lana_num := lenum.lana[i];
      MachineNameToAdapter(MachineName, Ncb.ncb_callname);
      Ncb.ncb_buffer := Pointer(Adapter);
      Ncb.ncb_length := SizeOf(TAdapterStatus);
      RetCode := Netbios(NCB);
      if RetCode in [chr(NRC_GOODRET), chr(NRC_INCOMP)] then
        Adresses.Add(AdapterToString(Adapter, Separator));
    end;
  finally
    Dispose(NCB);
    Dispose(Adapter);
    Dispose(Lenum);
  end;
end;

function GetMACAddress(const MachineName : string;
  const Separator: Char = ':'):string;
var
  stringlist: TStringList;
begin
  stringlist := TStringList.Create;
  try
    if GetMACAddresses(stringlist, MachineName, Separator) = 0 then
      Result := ''
    else
      Result := stringlist[0];
  finally
    stringlist.Destroy;
  end;
end;

end.
