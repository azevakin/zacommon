unit ZAPgSqlDialog;

interface

uses
  Classes, Controls, Forms, ZAPgSqlForm;

type
  TPgSqlDlg = class(TPgSqlForm)
  private
    FRegistryKey: string;
    procedure SaveSettings;
    procedure LoadSettings;
  protected
    procedure AlignCenter;
    procedure DoShow; override;
    procedure DoDestroy; override;
  public
    property RegistryKey: string read FRegistryKey write FRegistryKey;
    //=========================================================================
    //  Задает ключ реестра для записи позиций и размеров формы
    //  Пример: software\название приложения\формы\
    //=========================================================================
    function Execute: boolean;
    //=========================================================================
    // Показывает модальный диалог.
    //=========================================================================
  end;

implementation

{$R *.dfm}

uses Registry, ZAConst;

const
  LeftValue = 'Left';
  TopValue = 'Top';
  HeightValue = 'Height';
  WidthValue = 'Width';

procedure TPgSqlDlg.DoDestroy;
begin
  saveSettings;
  inherited;
end;

procedure TPgSqlDlg.DoShow;
begin
  inherited;
  LoadSettings;
end;

function TPgSqlDlg.Execute: boolean;
begin
  Result := IsPositiveResult(ShowModal);
end;

procedure TPgSqlDlg.AlignCenter;
begin
  Self.Left := (Screen.Width div 2) - (Self.Width div 2);
  Self.Top := (Screen.Height div 2) - (Self.Height div 2);
end;

procedure TPgSqlDlg.LoadSettings;
begin
  if RegistryKey = SNull then
  begin
    AlignCenter;
    Exit;
  end;

  with TRegistry.Create do
  try
    if OpenKey(RegistryKey + Self.Caption, False) then
    begin
      if ValueExists(LeftValue) then
        Self.Left := ReadInteger(LeftValue);

      if ValueExists(TopValue) then
        Self.Top := ReadInteger(TopValue);

      if Self.BorderStyle = bsSizeable then
      begin
        if ValueExists(HeightValue) then
          Self.Height := ReadInteger(HeightValue);

        if ValueExists(WidthValue) then
          Self.Width := ReadInteger(WidthValue);
      end;
    end
    else
      AlignCenter;
  finally
    Free;
  end;
end;

procedure TPgSqlDlg.SaveSettings;
begin
  if RegistryKey = SNull then Exit;

  with TRegistry.Create do
  try
    if OpenKey(RegistryKey + Self.Caption, True) then
    begin
      WriteInteger(LeftValue, Self.Left);
      WriteInteger(TopValue, Self.Top);
      if Self.BorderStyle = bsSizeable then
      begin
        WriteInteger(HeightValue, Self.Height);
        WriteInteger(WidthValue, Self.Width);
      end;
    end;
  finally
    Free;
  end;
end;

end.
