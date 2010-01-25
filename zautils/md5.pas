unit md5;

interface

uses Classes, IdHash, IdHashMessageDigest;

type
  TMD5 = class(TIdHashMessageDigest5)
  private
    FDigest: T4x4LongWordRecord;
  public
    class function AsHex(const AValue: T4x4LongWordRecord): string;

    constructor Create(const Src: string; const IsFilename: Boolean = False); overload;
    constructor Create(const Src: TStream); overload;

    function Digest: T4x4LongWordRecord;

    function HexDigest: string; overload;
    function HexDigest(const Src: string; const IsFilename: Boolean = False): string; overload;
    function HexDigest(const Src: TStream): string; overload;

    procedure InitDigest(const Src: string; const IsFilename: Boolean = False); overload;
    procedure InitDigest(const Src: TStream); overload;
  end;

implementation

uses SysUtils;

{ TMD5 }

class function TMD5.AsHex(const AValue: T4x4LongWordRecord): string;
begin
  inherited AsHex(AValue);
end;

constructor TMD5.Create(const Src: string; const IsFilename: Boolean);
begin
  Self.InitDigest(Src, IsFilename);
end;

constructor TMD5.Create(const Src: TStream);
begin
  Self.InitDigest(Src);
end;

function TMD5.Digest: T4x4LongWordRecord;
begin
  Result := Self.FDigest;
end;

function TMD5.HexDigest: string;
begin
  Result := Self.AsHex(Self.FDigest);
end;

function TMD5.HexDigest(const Src: string;
  const IsFilename: Boolean): string;
begin
  Self.InitDigest(Src, IsFilename);
  Result := Self.HexDigest;
end;

function TMD5.HexDigest(const Src: TStream): string;
begin
  Self.InitDigest(Src);
  Result := Self.HexDigest;
end;

procedure TMD5.InitDigest(const Src: string; const IsFilename: Boolean);
var
  Stream: TStream;
begin
  if IsFilename then
  begin
    Stream := TFileStream.Create(Src, fmOpenRead);
    try
      Self.InitDigest(Stream);
    finally
      Stream.Free;
    end;
  end
  else
    Self.FDigest := Self.HashValue(Src);
end;

procedure TMD5.InitDigest(const Src: TStream);
begin
  Self.FDigest := Self.HashValue(Src);
end;

end.
