unit Horse.SocketIO;

interface

uses
  Horse, Horse.SocketIO.ServerSocket, Web.HTTPApp, System.SysUtils, System.JSON;

procedure StartSocket(PORT : Integer);
procedure SocketIO(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses Horse.SocketIO.Functions, Horse.Commons;

procedure SocketIO(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Next;
end;

procedure StartSocket(PORT : Integer);
begin
  _ServerSocket.Connect(PORT);

  Registry;
end;

initialization
  StartSocket(55666);

end.
