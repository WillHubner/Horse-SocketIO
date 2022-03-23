unit GenericSocket.Server;

interface

uses
  StrUtils,
  System.JSON,
  System.Classes,
  System.SyncObjs,
  System.Generics.Collections,

  IdBaseComponent, IdComponent, IdCustomTCPServer, IdSocksServer,
  IdCustomTransparentProxy, IdSocks, IdTCPConnection, IdTCPServer,
  IdContext,

  GenericSocket.Interfaces;

type
  TSocketServer = Class(TInterfacedObject, iSocketServer)
  private
    FRunning : Boolean;
    FServer : TIdTCPServer;
    FPort : Integer;
    FClients : TDictionary<String, TIdContext>;
    FEvent : TEvent;

    procedure ServerConnect(AContext: TIdContext);
    procedure ServerExecute(AContext: TIdContext);

    function GetDefaultEvent: TEvent;
  public
    class function New : iSocketServer;

    function Start : iSocketServer;
    function Stop : iSocketServer;
    function Clients : TArray<String>;
    function Send(SocketName : String; JSONMessage : TJSONValue) : iSocketMessage; overload;
    function Send(SocketName : String; StringMessage : String) : iSocketMessage; overload;
    function Result : iSocketMessage;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, GenericSocket.Message;

{ TSocketServer }

function TSocketServer.Clients: TArray<String>;
begin
  Result := FClients.Keys.ToArray;
end;

constructor TSocketServer.Create;
begin
  FServer := TIdTCPServer.Create(nil);
  FServer.OnExecute := ServerExecute;
  FServer.OnConnect := ServerConnect;

  FClients := TDictionary<String, TIdContext>.Create;

  FRunning := False;
  FPort := 8080;
end;

destructor TSocketServer.Destroy;
begin
  FServer.Free;
  FClients.Free;

  inherited;
end;

function TSocketServer.GetDefaultEvent: TEvent;
begin
  if FEvent = nil then
    FEvent := TEvent.Create;
  Result := FEvent;
end;

class function TSocketServer.New: iSocketServer;
begin
  Result := Self.Create;
end;

function TSocketServer.Result: iSocketMessage;
begin

end;

function TSocketServer.Send(SocketName : String; JSONMessage : TJSONValue) : iSocketMessage;
begin
  Result := Send(SocketName, JSONMessage.ToString);
end;

function TSocketServer.Send(SocketName, StringMessage: String): iSocketMessage;
begin
  FClients.Items[SocketName].Connection.IOHandler.WriteLn(StringMessage);

  sleep(1);

  Result := TSocketMessage.New( FClients.Items[SocketName].Connection.IOHandler.ReadLn );
end;

procedure TSocketServer.ServerConnect(AContext: TIdContext);
var
  vMessage : iSocketMessage;
  JSONMessage : TJSONObject;
begin
  AContext.Connection.IOHandler.WriteLn('SOCKET_NAME');

  vMessage := TSocketMessage.New(AContext.Connection.IOHandler.ReadLn);

  JSONMessage := TJSONObject.ParseJSONValue(vMessage.JSONValue.GetValue<String>('message')) as TJSONObject;

  try
    FClients.Add(JSONMessage.GetValue<String>('name'), aContext);
  finally
    JSONMessage.Free;
  end;
end;

procedure TSocketServer.ServerExecute(AContext: TIdContext);
begin
  //
end;

function TSocketServer.Start: iSocketServer;
begin
  Result := Self;

  FServer.DefaultPort := FPort;
  FServer.Active := True;
  FRunning := True;

//  if IsConsole then
//    while FRunning do
//      GetDefaultEvent.WaitFor();
end;

function TSocketServer.Stop: iSocketServer;
begin
  if (FEvent <> nil) then
    FreeAndNil(FEvent);

  Result := Self;
  FServer.Active := False;
  FRunning := False;
end;

end.
