unit GenericSocket;

interface

uses
  System.JSON,
  GenericSocket.Interfaces;

type
  iGenericSocket = interface
    function SocketServer : iSocketServer;
    function SocketClient : iSocketClient;
  end;

  TGenericSocket = Class(TInterfacedObject, iGenericSocket)
  private
    FSocketServer : iSocketServer;
    FSocketClient : iSocketClient;
  public
    class function New : iGenericSocket;

    function SocketServer : iSocketServer;
    function SocketClient : iSocketClient;

    constructor Create;
    destructor Destroy; override;
  End;

implementation

uses
  GenericSocket.Client,
  GenericSocket.Server;

{ TGenericSocket }

constructor TGenericSocket.Create;
begin
  FSocketServer := TSocketServer.New;
  FSocketClient := TSocketClient.New;
end;

destructor TGenericSocket.Destroy;
begin

  inherited;
end;

class function TGenericSocket.New: iGenericSocket;
begin
  Result := Self.Create;
end;

function TGenericSocket.SocketClient: iSocketClient;
begin
  Result := FSocketClient;
end;

function TGenericSocket.SocketServer: iSocketServer;
begin
  Result := FSocketServer;
end;

end.
