unit ZeosCommonDialog;

interface

uses
  Classes, Controls, Forms, ZeosCommonForm;

type
  TZeosCommonDlg = class(TZeosCommonFrm)
  private
    procedure SaveSettings;
    procedure LoadSettings;
    function GetIniFilename: string;
  protected
    procedure DoShow; override;
    procedure DoDestroy; override;
  public
    function Execute: boolean;
      // Показывает модальный диалог.
    property IniFilename: string read GetIniFilename;
  end;

implementation

{$R *.dfm}

uses IniFiles, SysUtils;

const
  LeftValue = 'Left';
  TopValue = 'Top';
  HeightValue = 'Height';
  WidthValue = 'Width';

procedure TZeosCommonDlg.DoDestroy;
begin
  SaveSettings;
  inherited;
end;

procedure TZeosCommonDlg.DoShow;
begin
  inherited;
  LoadSettings;
end;

function TZeosCommonDlg.Execute: boolean;
begin
  Result := IsPositiveResult(ShowModal);
end;

function TZeosCommonDlg.GetIniFilename: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.ini');
end;

procedure TZeosCommonDlg.LoadSettings;
begin
  if FileExists(IniFilename) then
  with TIniFile.Create(IniFilename) do
  try
    if ValueExists(Self.Caption, LeftValue) then
      Self.Left := ReadInteger(Self.Caption, LeftValue, Self.Left);

    if ValueExists(Self.Caption, TopValue) then
      Self.Top := ReadInteger(Self.Caption, TopValue, Self.Top);

    if Self.BorderStyle = bsSizeable then
    begin
      if ValueExists(Self.Caption, HeightValue) then
        Self.Height := ReadInteger(Self.Caption, HeightValue, Self.Height);

      if ValueExists(Self.Caption, WidthValue) then
        Self.Width := ReadInteger(Self.Caption, WidthValue, Self.Width);
    end;
  finally
    Free;
  end;
end;

procedure TZeosCommonDlg.SaveSettings;
begin
  with TIniFile.Create(IniFilename) do
  try
    WriteInteger(Self.Caption, LeftValue, Self.Left);
    WriteInteger(Self.Caption, TopValue, Self.Top);
    if Self.BorderStyle = bsSizeable then
    begin
      WriteInteger(Self.Caption, HeightValue, Self.Height);
      WriteInteger(Self.Caption, WidthValue, Self.Width);
    end;
  finally
    Free;
  end;
end;

end.
