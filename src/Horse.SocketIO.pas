unit Horse.SocketIO;

interface

uses
  Horse,
  Horse.SocketIO.ServerSocket;

procedure StartSocket;

function SocketIO : THorseCallback; overload;
function SocketIO(aPort : Integer) : THorseCallback; overload;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  System.SysUtils, System.JSON, Horse.SocketIO.Functions;

var
  PORT : INTEGER;

function SocketIO : THorseCallback;
begin
  Result := SocketIO(8050);
end;

function SocketIO(aPort : Integer) : THorseCallback;
begin
  PORT := aPort;
  Result := Middleware;
end;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Next;
end;

procedure StartSocket;
begin
  _ServerSocket := TSocketServer.New;
  _ServerSocket.StartServer(PORT);

  Registry;
end;

initialization
  StartSocket;

end.
