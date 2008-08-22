unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, SBPro, {$IFNDEF VER100} ImgList, {$ENDIF} Gauges, ExtCtrls,
  StdCtrls;

type
  TForm1 = class(TForm)
    StatusBarPro1: TStatusBarPro;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    FirstPanelPopup1: TMenuItem;
    SecondPanelPopup1: TMenuItem;
    StatusBarPopup1: TMenuItem;
    ImageList1: TImageList;
    Gauge1: TGauge;
    Label1: TLabel;
    Edit1: TEdit;
    procedure StatusBarPro1Panels0Click(Sender: TObject);
    procedure StatusBarPro1Panels1DblClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.StatusBarPro1Panels0Click(Sender: TObject);
begin
  with TStatusPanelPro(Sender) do
    case Alignment of
      taLeftJustify: Alignment := taCenter;
      taCenter: Alignment := taRightJustify;
      taRightJustify: Alignment := taLeftJustify;
    end;
end;

procedure TForm1.StatusBarPro1Panels1DblClick(Sender: TObject);
begin
  with TStatusPanelPro(Sender) do
    ImageIndex := 3 - ImageIndex;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  StatusBarPro1.Panels[0].Text := Edit1.Text;
end;

end.
