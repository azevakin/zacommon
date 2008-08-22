{********************************************************}
{                                                        }
{                 Zeos Database Objects                  }
{             Linux non QT dependent Timer               }
{                                                        }
{       Copyright (c) 2002      Ofer Wald                }
{       Copyright (c) 2002      Ayelet Shemesh           }
{    Copyright (c) 1999-2002 Zeos Development Group      }
{                                                        }
{ This unit implements a simple threaded timer for linux }
{ which sleeps on a thread in order to trigger the timer }
{ event, this code is based on code by Boyan Krastev for }
{ the free pascal compiler                               }
{********************************************************}
unit ZLTimer;

interface
uses
  SysUtils,
  Classes, Libc;

type
  TTimer=class(TThread)
  private
    FEnabled : Boolean;
    FInterval: timespec;
    FOnTimer : TNotifyEvent;
    FCreated : Boolean;
    MyPID    : integer;
  protected
    procedure Execute; override;
    function  GetInterval : Cardinal;
    procedure SetInterval(value: Cardinal);
    procedure SetEnabled(value: Boolean);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    property OnTimer : TNotifyEvent read FOnTimer write FOnTimer;
    property Interval: Cardinal read GetInterval write SetInterval default 1000;
    property Enabled : Boolean read FEnabled write SetEnabled default false;
  end;

implementation

procedure TTimer.Execute;
var
  dummy: timespec;
  SigAction_T : tsigaction;

  procedure DoSig(Sig : integer); cdecl;
  begin
  end;
begin
  // Get thread handle for later use (can only be done in Exec func)
  MyPID := getpid;
  // Set signal handler for SIGUSR1 - ignore it
  SigAction_T.__sigaction_handler := @DoSig;
  SigAction_T.sa_flags := 0;
  SigAction_T.sa_restorer := nil;
  sigaction(SIGUSR1,@SigAction_T,nil);

  // Loop until finished
  repeat
    while FEnabled do begin
      if nanosleep(FInterval, @dummy) = 0 then
        if FEnabled then
          FOntimer(self);
    end;
    // In order to prevent CPU hogging
    sleep(0);
  until FCreated = false;
end;

function TTimer.GetInterval: Cardinal;
var i: Cardinal;
begin
  i := FInterval.tv_sec*1000+FInterval.tv_nsec div 1000;
  result := i;
end;

procedure TTimer.SetInterval(value :Cardinal);
var tm: timespec;
begin
 tm.tv_sec := value div 1000;
 tm.tv_nsec := (value mod 1000)*1000000;
 FInterval := tm;
end;

procedure TTimer.SetEnabled(value: Boolean);
begin
 FEnabled := value;
 if (not FEnabled) then
   kill(MyPid,SIGUSR1);
end;

constructor TTimer.Create(AOwner: TComponent);
begin
  // notice that AOwner is ignored, and is just for
  // QT timer compatability
  FCreated := true;
  SetInterval(1000); // defaults to 1 second
  inherited Create(false);
end;

destructor TTimer.Destroy;
begin
  FEnabled := False;
  FCreated := False;
  terminate;
  kill(ThreadID,SIGKILL);
  inherited Destroy;
end;

initialization

end.

