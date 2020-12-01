unit Horse.SocketIO.Functions;

interface

uses
  Horse,
  Horse.SocketIO.ServerSocket,
  System.JSON,
  Web.HTTPApp;

procedure Registry();
procedure GET_SocketClients(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure POST_clients(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  System.SysUtils;

procedure Registry();
begin
  THorse.GetInstance.Get('/socket_clients', GET_SocketClients);
  THorse.GetInstance.Post('/reg_clients', POST_clients);
  THorse.GetInstance.Get('/socket', Middleware);
  THorse.GetInstance.Get('/socket/:id', Middleware);
  THorse.GetInstance.Post('/socket/:id', Middleware);
end;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LWebRequest: TWebRequest;
  LPreparedBody : String;
  LPath : String;
begin
  LWebRequest := THorseHackRequest(Req).GetWebRequest;

  LPreparedBody := Req.Body;

  if not (Req.Headers['content-type'] = 'application/json') then
    LPreparedBody := '"'+ LPreparedBody + '"';

  LPath := Copy(LWebRequest.PathInfo, 8, length(LWebRequest.PathInfo));

  Res.Send<TJSONValue>(
    TJSONObject.ParseJSONValue(
      _ServerSocket.Send(
        Req.Headers['socket_client'],
        '/produtos',
        LPreparedBody
      )
    )
  ).Status(THTTPStatus.OK);
end;

procedure GET_SocketClients(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send<TJSONArray>(
    _ServerSocket.ClientsList
  );
end;

procedure POST_clients(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  try
    try
      _ServerSocket.Registry_clients;
    except
      Res.Send('Erro ao executar!').Status(400)
    end;
  finally
    Res.Send('Clientes Registrados!')
  end;
end;

end.

