unit Controller.SocketIO;

interface

uses
  System.JSON, IdWebsocketServer,
  IdHTTPWebsocketClient, IdSocketIOHandling,
  IdIOHandlerWebsocket, System.SysUtils,
  System.Generics.Collections;

var
  client: TIdHTTPWebsocketClient;
  C_CLIENT_EVENT : String;

  SOCKET_USER : String;
  SOCKET_PORT : String;
  SOCKET_SERVER : String;

const
  C_SERVER_EVENT = 'SERVER_TO_CLIENT_EVENT_TEST';
  ID_CLIENTE = 'ID_CLIENT';

procedure Socket_connect;
procedure RegistryEvents;

procedure Produtos(const ASocket: ISocketIOContext; const aArgument: TJSONValue; const aCallback: ISocketIOCallback);

implementation

uses View.Principal;

procedure Socket_connect;
begin
  C_CLIENT_EVENT := SOCKET_USER;

  client := TIdHTTPWebsocketClient.Create(nil);

  client.Port := SOCKET_PORT.ToInteger;
  client.Host := SOCKET_SERVER;
  client.SocketIOCompatible := True;

  RegistryEvents;

  client.Connect;
end;

procedure RegistryEvents;
begin
  client.SocketIO.OnEvent(C_SERVER_EVENT,
    procedure(const ASocket: ISocketIOContext; const aArgument: TJSONValue; const aCallback: ISocketIOCallback)
    begin
      Principal.memLog.Lines.Add('Server: ' + aArgument.ToJSON);

      if aCallback <> nil then
        aCallback.SendResponse(C_CLIENT_EVENT);
    end);

  client.SocketIO.OnEvent(ID_CLIENTE,
    procedure(const ASocket: ISocketIOContext; const aArgument: TJSONValue; const aCallback: ISocketIOCallback)
    begin
      if aCallback <> nil then
        aCallback.SendResponse( TJSONObject.ParseJSONValue('{"socket_user":"' + SOCKET_USER+ '"}').ToJSON);
    end);

  client.SocketIO.OnEvent('/produtos', Produtos);
end;

procedure Produtos(const ASocket: ISocketIOContext; const aArgument: TJSONValue; const aCallback: ISocketIOCallback);
var
  Obj : TJsonObject;
  Ary : TJSONArray;
  I :integer;
begin
  Principal.memLog.Lines.Add('Obtendo Produtos: ' + aArgument.ToJSON);

  Ary := TJSONArray.Create;

  for I := 1 to 3 do
    begin
      Obj := TJSONObject.Create;

      Obj.AddPair('descricao','Produto '+I.Tostring);

      ary.addElement(OBj);
    end;

  if aCallback <> nil then
    aCallback.SendResponse(ary.ToJSON);
end;

end.
