unit Horse.SocketIO.Functions;

interface

uses
  Horse,
  Horse.SocketIO.ServerSocket,
  System.JSON;

procedure Registry();
procedure GET_SocketClients(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure POST_clients(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry();
begin
  THorse.GetInstance.Get('/socket_clients', GET_SocketClients);
  THorse.GetInstance.Post('/reg_clients', POST_clients);
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

