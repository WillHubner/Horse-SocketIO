unit Horse.SocketIO;

interface

uses
  Horse,
  Horse.SocketIO.ServerSocket;

procedure StartSocket(PORT : Integer);
procedure SocketIO(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  System.SysUtils, System.JSON, Horse.SocketIO.Functions;

procedure SocketIO(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Next;
end;

procedure StartSocket(PORT : Integer);
begin
  _ServerSocket := TSocketServer.New;
  _ServerSocket.StartServer(PORT);

  Registry;
end;

initialization
  StartSocket(8050);

end.
