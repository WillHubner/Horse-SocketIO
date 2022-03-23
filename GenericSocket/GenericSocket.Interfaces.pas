unit GenericSocket.Interfaces;

interface

uses
  System.JSON;

type
  TSocketResponse = reference to function(Message : String) : String;

  iSocketMessage = interface
    function Title(vTitle : String) : iSocketMessage;
    function Body(vBody : TJSONValue) : iSocketMessage;
    function GetTitle : String;
    function JSONValue : TJSONValue;
  end;

  iSocketServer = interface
    function Start : iSocketServer;
    function Stop : iSocketServer;
    function Clients : TArray<String>;
    function Send(SocketName : String; JSONMessage : TJSONValue) : iSocketMessage; overload;
    function Send(SocketName : String; StringMessage : String) : iSocketMessage; overload;
    function Result : iSocketMessage;
  end;

  iSocketClient = interface
    function RegisterCallback(Param : String; CallbackProcedure : TSocketResponse) : iSocketClient;
    function Connect : iSocketClient; overload;
    function Connect(vHost : String; vPort:  Integer) : iSocketClient; overload;
    function Disconnet : iSocketClient;

    function Connected : Boolean;
  end;

implementation

end.
