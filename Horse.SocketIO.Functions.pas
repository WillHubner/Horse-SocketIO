unit Horse.SocketIO.Functions;

interface

uses
  Horse,
  Horse.SocketIO,
  Horse.SocketIO.ServerSocket;

procedure Registry();
procedure GET_SocketClients(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  System.SysUtils, System.JSON;

procedure Registry();
begin
  THorse.Get('/socket_clients', GET_SocketClients);
  THorse.Get('/socket', Middleware);
  THorse.Get('/socket/:id', Middleware);
  THorse.Post('/socket/:id', Middleware);
end;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LPreparedBody : String;
  LPath : String;
  LResponse : String;
begin
  LPreparedBody := Req.Body;

  if not (Req.Headers['content-type'] = 'application/json') then
    LPreparedBody := '"'+ LPreparedBody + '"';

  LPath := Copy(Req.RawWebRequest.PathInfo, 8, length(Req.RawWebRequest.PathInfo));

  if Req.Headers['socket_client'] = '' then
    begin
      _ServerSocket.Send('', LPath, LPreparedBody);
      Res.Send<TJSONValue>(TJSONObject.Create.AddPair('msg', 'success!'));
    end
  else
    LResponse := _ServerSocket.Send( Req.Headers['socket_client'], LPath, LPreparedBody );

    Res.Send<TJSONValue>( TJSONObject.ParseJSONValue( LResponse ) ).Status(THTTPStatus.OK);
end;

procedure GET_SocketClients(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send<TJSONArray>(
    _ServerSocket.ClientList
  );
end;

end.
