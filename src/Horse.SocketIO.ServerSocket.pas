unit Horse.SocketIO.ServerSocket;

interface

uses
  Horse,
  IdSocketIOHandling,
  IdServerWebsocketContext,
  IdWebsocketServer,
  IdHTTPWebsocketClient,
  IdIOHandlerWebsocket,
  IdCustomTCPServer,
  IdContext,
  System.Generics.Collections,
  System.Classes,
  System.JSON;

Type
  iServerSocket = interface
    ['{9A9E0911-AF21-49C4-BB12-DC1723D2B363}']
    procedure Connect(port : Integer);
    procedure SendAll(msg : String);
    procedure Registry_clients;
    procedure RegistryClient(vSocket: ISocketIOContext);

    function ConnectionsCount : Integer;
    function Send(id_client, CONTEXT, msg : String) : String;
    function ClientsList : TJSONArray;
    function Connected : Boolean;

  end;

  TServerSocket = class(TInterfacedObject, iServerSocket)
    private
      Fserver: TIdWebsocketServer;
      FlistaContext : TDictionary<String,ISocketIOContext>;
      FlistaClientes : TDictionary<String,ISocketIOContext>;
      FlistaClienteContext : TDictionary<String,String>;

      procedure ReceiveMessage(ASocket: ISocketIOContext; msg : String);
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iServerSocket;

      procedure Connect(port : Integer);
      procedure SendAll(msg : String);
      procedure Registry_clients;
      procedure RegistryClient(vSocket: ISocketIOContext);

      function Connected : Boolean;

      function ConnectionsCount : Integer;
      function Send(id_client, CONTEXT, msg : String) : String;
      function ClientsList : TJSONArray;
  end;

var
  _ServerSocket : iServerSocket;

const
  C_CLIENT_EVENT = 'CLIENT_TO_SERVER_EVENT_TEST';
  C_SERVER_EVENT = 'SERVER_TO_CLIENT_EVENT_TEST';
  ID_CLIENTE = 'ID_CLIENT';

implementation

uses
  System.SysUtils;

{ TServerSocket }

function TServerSocket.ClientsList: TJSONArray;
var
  i : Integer;
  vArray : TArray<String>;
  jsonobj : TJSONObject;
begin
  Result := TJSONArray.Create;

  vArray := FlistaClientes.Keys.ToArray;

  for I := 0 to Pred(Length(varray)) do
    begin
      jsonobj := TJSONObject.Create;
      jsonobj.AddPair('client_name', vArray[I]);

      Result.Add(jsonobj);
    end;
end;

procedure TServerSocket.Connect(port : Integer);
begin
  Fserver := TIdWebsocketServer.Create(nil);

  Fserver.DefaultPort := port;

  Fserver.SocketIO.OnDisconnect(
    procedure(const ASocket: ISocketIOContext)
    begin
      FlistaClientes.Remove( FlistaClienteContext.Items[ASocket.ResourceName] );

      FlistaClienteContext.Remove(ASocket.ResourceName);

      FlistaContext.Remove(ASocket.ResourceName);
    end);

  Fserver.SocketIO.OnConnection(
    procedure(const ASocket: ISocketIOContext)
    begin
      FlistaContext.Add(ASocket.ResourceName, ASocket);

      ASocket.EmitEvent(C_SERVER_EVENT, TJSONObject.ParseJSONValue('{"data":"Bem vindo"}'), nil, nil);

      RegistryClient(ASocket);
    end);

  Fserver.Active      := True;

  Writeln('SocketServer is running on port '+ port.ToString);
end;

function TServerSocket.Connected: Boolean;
begin
  Result := Fserver.Active;
end;

function TServerSocket.ConnectionsCount: Integer;
begin
  Result := Fserver.SocketIO.ConnectionCount;
end;

constructor TServerSocket.Create;
begin
  FlistaContext := TDictionary<String,ISocketIOContext>.Create;
  FlistaClientes := TDictionary<String,ISocketIOContext>.Create;
  FlistaClienteContext := TDictionary<String,String>.Create;
end;

destructor TServerSocket.Destroy;
begin
  FlistaContext.Destroy;
  FlistaClientes.Destroy;
  FlistaClienteContext.Destroy;

  inherited;
end;

class function TServerSocket.New: iServerSocket;
begin
  Result := Self.Create;
end;

procedure TServerSocket.ReceiveMessage(ASocket: ISocketIOContext; msg: String);
begin
  Writeln(ASocket.ResourceName + ' - ' + msg);
end;

procedure TServerSocket.RegistryClient(vSocket: ISocketIOContext);
begin
  Fserver.SocketIO.EmitEventTo
  (
    vSocket,
    ID_CLIENTE,
    TJSONObject.ParseJSONValue('{"data":""}'),
    procedure(const ASocket: ISocketIOContext; const aJSON: TJSONValue; const aCallback: ISocketIOCallback)
    begin
      FlistaClientes.Add(
        TJSONObject(ajson).GetValue('socket_user').Value,
        ASocket
      );

      FlistaClienteContext.Add(vSocket.ResourceName, TJSONObject(ajson).GetValue('socket_user').Value);
    end,
    nil
  );
end;

procedure TServerSocket.Registry_clients;
var
  i : Integer;
  ItemsArray : TJSONArray;
  vISocketIOContext : ISocketIOContext;
begin
  ItemsArray := TJSONArray(
    TJSONObject(
      TJSONObject.ParseJSONValue(
        FlistaContext.ToString
      )
    ).GetValue('FItems')
  );

  FlistaClientes.Clear;

  for I := 0 to Pred(ItemsArray.Count) do
    begin
      vISocketIOContext := FlistaContext.Items[ TJSONObject(ItemsArray.Items[I]).GetValue('Key').Value ];;

      Fserver.SocketIO.EmitEventTo
      (
        vISocketIOContext,
        ID_CLIENTE,
        TJSONObject.ParseJSONValue('{"data":""}'),
        procedure(const ASocket: ISocketIOContext; const aJSON: TJSONValue; const aCallback: ISocketIOCallback)
        begin
          FlistaClientes.Add(ajson.Value, ASocket);
        end,
        nil
      );
    end;
end;

function TServerSocket.Send(id_client, CONTEXT, msg : String) : String;
var
   _Result : String;
   _JSON : String;
begin
  _JSON := '{"data":'+msg+'}';

  Fserver.SocketIO.EmitEventTo
  (
    FlistaClientes.Items[ id_client ],
    CONTEXT,
    TJSONObject.ParseJSONValue (_json),
    procedure(const ASocket: ISocketIOContext; const aJSON: TJSONValue; const aCallback: ISocketIOCallback)
    begin
      _Result := aJSON.ToJSON
    end,
    nil
  );

  while (_Result = '') do
    begin

    end;

  Result := _Result;
end;

procedure TServerSocket.SendAll(msg: String);
begin
  Fserver.SendMessageToAll(msg);
//  Fserver.SocketIO.EmitEventToAll(C_SERVER_EVENT, '{"data":"'+ msg+'"}',
//
//  procedure(const ASocket: ISocketIOContext; const aJSON: TJSONValue; const aCallback: ISocketIOCallback)
//    begin
//      TThread.Synchronize(nil,
//          procedure
//          begin
//            ReceiveMessage(ASocket, aJSON.Value);
//          end);
//    end)
end;

initialization
  _ServerSocket := TServerSocket.New;

end.

