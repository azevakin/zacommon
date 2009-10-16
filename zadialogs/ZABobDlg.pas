unit ZABobDlg;

interface

uses
  Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls;

type
  TBobDlg = class(TForm)
  private
    Message: TLabel;
    Panel: TPanel;
    FPadding: Integer;
    function GetText: String;
    procedure InitDlg;
    procedure InitSize;
    procedure SetText(const Value: String);
    procedure SetPadding(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; AText: String); reintroduce; overload;
    property Text: String read GetText write SetText;
    property Padding: Integer read FPadding write SetPadding default 10;
    procedure HideBob;
    procedure ShowMessage(const AText: String); overload;
    procedure ShowMessage(const AText: String; const Seconds: Byte); overload;
    procedure ShowMessageFmt(const fmt: string; const args: array of const);
  end;

  function showBobDlg(const text: string): TBobDlg;

implementation

{$R *.dfm}

uses SysUtils;

function showBobDlg(const text: string): TBobDlg;
begin
  Result := TBobDlg.Create(Application, text);
  Result.Show;
  Application.ProcessMessages;
end;

{ TBobDialog }

constructor TBobDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitDlg;
end;

constructor TBobDlg.Create(AOwner: TComponent; AText: String);
begin
  inherited Create(AOwner);
  InitDlg;
  SetText(AText);
end;

function TBobDlg.GetText: String;
begin
  Result := Message.Caption;
end;

procedure TBobDlg.InitDlg;
begin
  FPadding := 10;

  Panel := TPanel.Create(Self);
  Panel.Parent := Self;
  Panel.ParentColor := True;

  Message := TLabel.Create(Self);
  Message.AutoSize := True;
  Message.Parent := Panel;
  Message.ParentColor := True;
  Message.Font.Style := [fsBold];
end;

procedure TBobDlg.InitSize;
begin
  Panel.ClientHeight := Message.Height + FPadding*2;
  Panel.ClientWidth := Message.Width + FPadding*2;
  Message.Left := FPadding;
  Message.Top := FPadding;
  ClientHeight := Panel.Height;
  ClientWidth := Panel.Width;
  Left := Screen.Width div 2 - Width div 2;
  Top := Screen.Height div 2 - Height div 2;
  Update;
end;

procedure TBobDlg.SetText(const Value: String);
begin
  if Value <> Message.Caption then
  begin
    Message.Caption := Value;
    InitSize;
  end;
end;

procedure TBobDlg.SetPadding(const Value: Integer);
begin
  if Value <> FPadding then
  begin
    FPadding := Value;
    InitSize;
  end;
end;

procedure TBobDlg.ShowMessage(const AText: String);
begin
  Text := AText;
  Show;
  Application.ProcessMessages;
end;

procedure TBobDlg.ShowMessage(const AText: String; const Seconds: Byte);
begin
  Text := AText;
  Show;
  Application.ProcessMessages;
  Sleep(Seconds * 1000);
  Application.ProcessMessages;
end;

procedure TBobDlg.ShowMessageFmt(const fmt: string; const args: array of const);
begin
  ShowMessage(Format(fmt, args));
end;

procedure TBobDlg.HideBob;
begin
  Self.Hide;
  Application.ProcessMessages;
end;

end.
