unit Horse.SocketIO.ServerSocket;

interface

uses
  System.JSON,
  GenericSocket;

type
  iSocketServer = interface
    procedure StartServer(aPort : Integer);
    function Send(aClient, aPath, aMessage : String) : String;
    function ClientList : TJSONArray;
  end;

  TSocketServer = Class(TInterfacedObject, iSocketServer)
    FGenericSocket : iGenericSocket;
  public
    procedure StartServer(aPort : Integer);
    function Send(aClient, aPath, aMessage : String) : String;
    function ClientList : TJSONArray;

    class function New : iSocketServer;

    constructor Create;
    destructor Destroy; override;
  End;

var
  _ServerSocket : iSocketServer;

implementation

{ TSocketServer }

function TSocketServer.ClientList: TJSONArray;
var
  Clientes : TArray<String>;
begin
  Clientes := FGenericSocket.SocketServer.Clients;

  Result := TJSONArray.Create;

  for var I := 0 to Pred(Length(Clientes)) do
    Result.Add(Clientes[I]);

end;

constructor TSocketServer.Create;
begin
  FGenericSocket := TGenericSocket.New;
end;

destructor TSocketServer.Destroy;
begin

  inherited;
end;

class function TSocketServer.New: iSocketServer;
begin
  Result := Self.Create;
end;

function TSocketServer.Send(aClient, aPath, aMessage: String): String;
begin
  Result := FGenericSocket.SocketServer.Send(aClient, aPath).JSONValue.ToJSON;
end;

procedure TSocketServer.StartServer(aPort: Integer);
begin
  FGenericSocket.SocketServer.Start(aPort);
end;

end.
