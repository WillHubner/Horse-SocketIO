unit GenericSocket.Client;

interface

uses
  StrUtils,

  System.JSON,
  System.Classes,
  System.SyncObjs,
  System.SysUtils,
  System.Generics.Collections,

  IdBaseComponent, IdComponent, IdCustomTCPServer, IdSocksServer,
  IdCustomTransparentProxy, IdSocks, IdTCPConnection, IdTCPClient,
  IdContext, IdGlobal,
  GenericSocket.Interfaces;

type
  TSocketClient = Class(TInterfacedObject, iSocketClient)
  private
    FCallbacks : TDictionary<String, TSocketResponse>;
    FClient : TIdTCPClient;
    FConnected : Boolean;
    FHost : String;
    FPort : Integer;
    FTask : TThread;

    procedure OnDisconnect(Sender: TObject);
    procedure OnStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);

    procedure VerifySocketMessages;
    procedure CallbackFunction;
    procedure SendMessage(AMessage : String);

    function onConnect(Message : String) : String;
  public
    class function New : iSocketClient;

    function RegisterCallback(Param : String; CallbackProcedure : TSocketResponse) : iSocketClient;
    function Connect : iSocketClient; overload;
    function Connect(vHost : String; vPort:  Integer) : iSocketClient; overload;
    function Disconnet : iSocketClient;
    function Host(vHost : String) : iSocketClient;
    function Port(vPort : Integer) : iSocketClient;

    function Connected : Boolean;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TSocketClient }

function TSocketClient.Connect: iSocketClient;
begin
  Result := Self;
  FClient.Host := FHost;
  FClient.Port := FPort;

  try
    FClient.Connect;
  finally
    FConnected := True;
    FTask.Start;
  end;
end;

procedure TSocketClient.CallbackFunction;
var
  ReadString : String;
  Command : String;
begin
  try
    if FClient.IOHandler.InputBufferIsEmpty then
      begin
        FClient.IOHandler.CheckForDataOnSource(10);
        FClient.IOHandler.CheckForDisconnect;

        if FClient.IOHandler.InputBufferIsEmpty then exit;
      end;

    ReadString := FClient.IOHandler.ReadLn;

    if Pos('?', ReadString) > 0 then
      Command := Copy(ReadString, 0, Pos('?', ReadString))
    else
      Command := ReadString;

    if FCallbacks.ContainsKey(Command) then
      SendMessage(FCallbacks[Command](ReadString));
  except
    Self.Disconnet;
  end;
end;

function TSocketClient.Connect(vHost: String; vPort: Integer): iSocketClient;
begin
  Result := Self;

  FHost := vHost;
  FPort := vPort;

  Self.Connect;
end;

function TSocketClient.Connected: Boolean;
begin
  Result := FConnected;
end;

constructor TSocketClient.Create;
begin
  FCallbacks := TDictionary<String, TSocketResponse>.Create;
  FTask := TThread.CreateAnonymousThread( Self.VerifySocketMessages );
  FTask.FreeOnTerminate := False;

  FClient := TIdTCPClient.Create(nil);
  FClient.OnStatus := OnStatus;
  FClient.OnDisconnected := OnDisconnect;
  FClient.ConnectTimeout := 0;

  Self.RegisterCallback('SOCKET_NAME', onConnect);
end;

destructor TSocketClient.Destroy;
begin
  FCallbacks.Free;
  FClient.Free;
  FTask.Free;

  inherited;
end;

function TSocketClient.Disconnet: iSocketClient;
begin
  Result := Self;

  FClient.Disconnect;

  FConnected := FClient.Connected;
end;

function TSocketClient.Host(vHost: String): iSocketClient;
begin
  Result := Self;
  FHost := vHost;
end;

class function TSocketClient.New: iSocketClient;
begin
  Result := Self.Create;
end;

function TSocketClient.onConnect(Message: String): String;
var
  JSONConnect : TJSONObject;
begin
  JSONConnect := TJSONObject.Create.AddPair('name', TGUID.NewGuid.ToString);

  try
    Result := JSONConnect.ToJSON;
  finally
    JSONConnect.Free;
  end;
end;

procedure TSocketClient.OnDisconnect(Sender: TObject);
begin
  FConnected := False;
end;

procedure TSocketClient.OnStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin

end;

function TSocketClient.Port(vPort: Integer): iSocketClient;
begin
  Result := Self;
  FPort := vPort;
end;

function TSocketClient.RegisterCallback(Param: String;
  CallbackProcedure: TSocketResponse): iSocketClient;
begin
  Result := Self;
  FCallbacks.Add(Param, CallbackProcedure);
end;

procedure TSocketClient.SendMessage(AMessage: String);
var
  JSONMessage : TJSONObject;
begin
  JSONMessage :=
    TJSONObject
      .Create
      .AddPair('title', 'SOCKET_MESSAGE')
      .AddPair('body', TJSONObject.Create.AddPair('message', AMessage));

  try
    FClient.IOHandler.WriteLn(JSONMessage.ToJSON);
  finally
    JSONMessage.Free;
  end;
end;

procedure TSocketClient.VerifySocketMessages;
begin
  while FConnected do
    CallbackFunction;
end;

end.
