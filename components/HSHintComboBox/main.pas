unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, HSHintComboBox;

type
  TForm1 = class(TForm)
    ComboBox: TComboBox;
    ListBox: TListBox;
    lbCoord: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FHSHintComboBox : THSHintComboBox;
    procedure HSHintComboBoxListMouseMove (Sender : TObject;
                                       Shift : TShiftState; X, Y : Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FHSHintComboBox := THSHintComboBox.Create(Self);
  with FHSHintComboBox do begin
    Parent := Self;
    Items.Assign(ComboBox.Items);
    BoundsRect := ComboBox.BoundsRect;
    if NOT (ComboBox.Style in [csDropDown, csDropDownList]) then
      raise Exception.Create (
       'HSHintComboBox поддерживает стиль только csDropDown и csDropDownList');
    Style := ComboBox.Style;
    DropDownCount := ComboBox.DropDownCount;
    TabOrder := ComboBox.TabOrder;
    TabStop := ComboBox.TabStop;
    OnListMouseMove := HSHintComboBoxListMouseMove;
  end;
  ComboBox.Free();
end;

procedure TForm1.HSHintComboBoxListMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  R : TRect;
begin
  Windows.GetClientRect(FHSHintComboBox.HSListHandle, R);
  if NOT PtInRect(R, Point(X,Y)) then
    lbCoord.Caption := 'Outside'
  else
    lbCoord.Caption := Format('X:%d,Y:%d', [X, Y]);
end;

end.
