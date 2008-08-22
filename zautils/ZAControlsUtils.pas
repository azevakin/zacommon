unit ZAControlsUtils;

interface

uses Controls;

type
  TWinControlsArray = array of TWinControl;

  procedure initWinControlsArray(var dest: TWinControlsArray; const len: Integer);
  
implementation

procedure initWinControlsArray(var dest: TWinControlsArray; const len: Integer);
begin
  if len > 0 then
    SetLength(dest, len);
end;

end.
