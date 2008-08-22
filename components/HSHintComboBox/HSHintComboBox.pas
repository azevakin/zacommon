{
  Наследник TComboBox, показывающий Hint для строки в ListBox'овой части,
  не видимой целиком.

  Автор: Игорь Шевченко
  Дата создания: 13.04.2002

  Ограничения:
  Компонент проверялся при работе с значением Style: csDropDown, csDropDownList.
  при остальных значениях работа не гарантируется :-)
  Компонент не тестировался в режиме design-time.

  История изменений:
  16.04.2002 Исправлено поведение при закрытии, когда показан hint и ComboBox
             закрывается по клавише Enter, Escape или F4. Теперь hint убирается.
             Добавлено свойство HorizontalExtent, позволяющее устанавливать
             горизонтальный Scrollbar в списке ComboBox'a. По умолчанию свойство
             имеет значение -1, что запрещает установку горизонтального
             ScrollBar'а.
  30.12.2003 Исправлено поведение при появлении вертикального Scrollbar'а.
             Теперь hint показывается если текущая строка не помещается целиком
             в область ListBox ограниченную вертикальным Scrollbar'ом 
}
unit HSHintComboBox;

interface
uses
  Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls;

type
  TListBoxTip = class(THintWindow)
  end;

  TShowComboToolTipEvent = procedure (Sender : TObject;
                                     const ToolTipText : String;
                                     var HideToolTip : Boolean) of object;

  THSHintComboBox = class(TComboBox)
  private
    FListBoxTip : TListBoxTip;
    FListHandle : HWND;
    FListWndProcInstance : TFarProc;
    FOldListWndProc : TFarProc;
    FOnListMouseMove: TMouseMoveEvent;
    FOnShowComboToolTip: TShowComboToolTipEvent;
    FShowToolTips: Boolean;
    FHorizontalExtent: Integer;
    procedure ListWndProc (var Message : TMessage);
    function ListBoxItemAtPos (I : Integer) : String;
    function ListBoxItemRectAtPos (I : Integer; AText : String) : TRect;
    procedure SetShowToolTips(const Value: Boolean);
    procedure SetHorizontalExtent(const Value: Integer);
  protected
    procedure DoListMouseMove (Shift: TShiftState; X, Y: Integer); dynamic;
    procedure DoShowComboToolTip (const ToolTipText : String;
                                 var HideToolTip : Boolean); dynamic;
    procedure WndProc (var Message: TMessage); override;
{16.04.2002}
    procedure CreateParams (var Params : TCreateParams); override;
    procedure CreateWnd; override;
{/16.04.2002}
  public
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    { Handle окна ListBox'а, являющегося частью ComboBox'a }
    property HSListHandle : HWND read FListHandle;
    { Показывать ли Hint для строк, не видимых целиком в ListBox'е }
    property ShowToolTips : Boolean read FShowToolTips
                         write SetShowToolTips default true;
    { Событие при движении мыши по ListBox'у. Так как ListBox захватывает
      (Captured) мышь, то координаты курсора в этом событии могут быть за
      пределами клентской части ListBox'а }
    property OnListMouseMove : TMouseMoveEvent read FOnListMouseMove
        write FOnListMouseMove;
    { Событие при показе Hint'а для ListBox'а. Установив HideHint в True,
      можно запретить показ конкретного Hint'а }
    property OnShowComboToolTip : TShowComboToolTipEvent
        read FOnShowComboToolTip write FOnShowComboToolTip;
{16.04.2002}
    property HorizontalExtent : Integer read FHorizontalExtent
       write SetHorizontalExtent default -1;
{/16.04.2002}
  end;

procedure Register;

implementation

uses SysUtils;

procedure Register;
begin
  RegisterComponents('Samples', [THSHintComboBox]);
end;

function RectWidth(R : TRect) : Integer;
begin
  Result := R.Right - R.Left;
end;

function RectHeight(R : TRect) : Integer;
begin
  Result := R.Bottom - R.Top;
end;

{ THSHintComboBox }

constructor THSHintComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FListBoxTip := TListBoxTip.Create(Self);
{30.12.2003 ZemA}
  FListBoxTip.Parent := Self;
{/30.12.2003 ZemA}
  FListBoxTip.Color := clInfoBk;
  FListWndProcInstance := Classes.MakeObjectInstance(ListWndProc);
  FShowToolTips := True;
  FHorizontalExtent := -1;
end;

destructor THSHintComboBox.Destroy;
begin
  if (FListHandle <> 0) AND IsWindow(FListHandle) then
    SetWindowLong(FListHandle, GWL_WNDPROC, LongInt(FOldListWndProc));
  Classes.FreeObjectInstance(FListWndProcInstance);
  inherited;
end;

procedure THSHintComboBox.DoShowComboToolTip(const ToolTipText: String;
                                             var HideToolTip : Boolean);
begin
  if Assigned(FOnShowComboToolTip) then
    FOnShowComboToolTip (Self, ToolTipText, HideToolTip);
end;

procedure THSHintComboBox.DoListMouseMove(Shift: TShiftState; X,
  Y: Integer);

  procedure AdjustHintRect (var R : TRect; const AHintStr : String);
  var
    DC : HDC;
    OldFont : HFONT;
    TextSize : SIZE;
  begin
    DC := GetDC (HWND_DESKTOP);
    try
      OldFont := SelectObject(DC, Screen.HintFont.Handle);
      try
        if (NOT GetTextExtentPoint32(DC, PChar(AHintStr), StrLen(PChar(AHintStr)), TextSize)) then
          RaiseLastOSError;
        Inc(TextSize.cx, 6);
        Inc(TextSize.cy, 2);
        if RectWidth(R) < TextSize.cx then
          R.Right := R.Left + TextSize.cx;
        if RectHeight(R) < TextSize.cy then
          R.Bottom := R.Top + TextSize.cy;
      finally
        SelectObject(DC, OldFont);
      end;
    finally
      ReleaseDC (HWND_DESKTOP, DC);
    end;
  end;

var R, ItemRect : TRect;
    I : Integer;
    ItemText : String;
    HideToolTip : Boolean;
begin
  HideToolTip := True; { По умолчанию выключать Hint }
  if FShowToolTips then begin
    Windows.GetClientRect(FListHandle, R);
    { X и Y являются координатами клиента (в данном случае, ListBox }
    if PtInRect(R, Point(X,Y)) AND (Shift = []) then begin
      { Определим, помещается ли текущая строка целиком в область ListBox }
      I := SendMessage(FListHandle, LB_ITEMFROMPOINT, 0, MakeLParam(X,Y));
      if HiWord(I) <> 0 then
        I := -1;
      if I <> -1 then begin
        ItemText := ListBoxItemAtPos(I);
        ItemRect := ListBoxItemRectAtPos(I, ItemText);
        if RectWidth(ItemRect) > RectWidth(R) then begin
          { Надо показывать Hint, так как строка не помещается целиком
            в клиентскую область ListBox }
          Windows.ClientToScreen(FListHandle, ItemRect.TopLeft);
          Windows.ClientToScreen(FListHandle, ItemRect.BottomRight);
          Dec(ItemRect.Left, 3);
          Inc(ItemRect.Right, 6);
          HideToolTip := false; { Не надо гасить hint }
          DoShowComboToolTip (ItemText, HideToolTip); { Для возможности
                                         отображения строки Hint дополнительно
                                         в другом месте или запрета
                                         конкретного Hint'а}
{16.04.2002}
          if NOT HideToolTip then
{ Если двигаться мышью в горизонтальном направлении на элементе, для которого
  должен показываться Hint, то ActivateHint не стоит вызывать, если Hint уже
  уже на экране }
            if NOT (IsWindow(FListBoxTip.Handle) and
                    IsWindowVisible(FListBoxTip.Handle) and
                    (StrComp(PChar(FListBoxTip.Caption),PChar(ItemText)) = 0)) then begin
              AdjustHintRect(ItemRect, ItemText);
              FListBoxTip.ActivateHint(ItemRect, ItemText);
            end;
{/16.04.2002}
        end;
      end;
    end;
  end;
  if HideToolTip then
    FListBoxTip.ReleaseHandle; { Не надо показывать Hint, если мышь за пределами
                                 ListBox или строка видна целиком }
  { Если кому-то вздумается следить за перемещениями мыши в области ListBox.
    Я при отладке использовал это событие для отображения координат мыши }
  if Assigned(FOnListMouseMove) then
    FOnListMouseMove(Self, Shift, X, Y);
end;

function THSHintComboBox.ListBoxItemAtPos(I: Integer): String;
var
  L : Integer;
begin
  if I <> -1 then begin
    L := SendMessage(FListHandle, LB_GETTEXTLEN, I, 0);
    SetLength(Result, L+1); { +1 на нулевой символ в конце строки }
    SendMessage(FListHandle, LB_GETTEXT, I, Integer(PChar(Result)));
  end else
    Result := '';
end;

function THSHintComboBox.ListBoxItemRectAtPos(I: Integer;
  AText: String): TRect;
var
  DC : HDC;
  OldFont : HFONT;
begin
  Result := Rect(0, 0, 0, 0);
  if (I <> -1) AND (SendMessage(FListHandle, LB_GETITEMRECT, I,
                    Integer(@Result)) <> LB_ERR) then begin
    DC := GetDC(FListHandle);
    try
      OldFont := SelectObject(DC, Font.Handle);
      try
        DrawText(DC, PChar(AText), -1, Result, DT_CALCRECT);
      finally
        SelectObject(DC, OldFont);
      end;
    finally
      ReleaseDC(FListHandle, DC);
    end;
  end;
end;

procedure THSHintComboBox.ListWndProc(var Message: TMessage);
begin
  case Message.Msg of
  WM_MOUSEMOVE:
    with TWMMouseMove(Message) do
      DoListMouseMove(KeysToShiftState(Keys), XPos, YPos);
{16.04.2002}
{ Как выяснилось, при нажатии Esc или Enter на выбранном элементе, который
  показывает Hint, ComboBox закрывается, а Hint остается. :-(
  Сообщение SHOWWINDOW с WPARAM=0 гарантировано выдается, когда закрывается
  окно, так что это место можно использовать для гашения Hint'a }
  WM_SHOWWINDOW:
    if Message.WParam = 0 then
      FListBoxTip.ReleaseHandle();
{/16.04.2002}
  end;
  with Message do
    Result := CallWindowProc(FOldListWndProc, FListHandle, Msg, WParam, LParam);
end;

procedure THSHintComboBox.SetShowToolTips(const Value: Boolean);
begin
  FShowToolTips := Value;
end;

procedure THSHintComboBox.WndProc(var Message: TMessage);
begin
  if (Message.Msg = WM_CTLCOLORLISTBOX) AND (FListHandle = 0) then begin
    FListHandle := HWND(Message.LParam);
    FOldListWndProc := Pointer(GetWindowLong(FListHandle, GWL_WNDPROC));
    SetWindowLong(FListHandle,
                  GWL_WNDPROC, LongInt(FListWndProcInstance));
  end;
  inherited;
end;

{16.04.2002}
procedure THSHintComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if FHorizontalExtent <> -1 then
    with Params do
      Style := Style OR WS_HSCROLL;
end;

procedure THSHintComboBox.SetHorizontalExtent(const Value: Integer);
begin
  if (FHorizontalExtent <> Value) then begin
    FHorizontalExtent := Value;
    if NOT (csLoading in ComponentState) then
      RecreateWnd();
  end;
end;

procedure THSHintComboBox.CreateWnd;
begin
  inherited;
  if FHorizontalExtent <> -1 then
    Perform(CB_SETHORIZONTALEXTENT, FHorizontalExtent, 0);
end;
{/16.04.2002}

end.
