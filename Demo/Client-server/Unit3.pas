unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.JSON, System.JSON, IdWebsocketServer,
  IdHTTPWebsocketClient, IdSocketIOHandling, IdIOHandlerWebsocket,IdCoderMIME;

type
  TfPrincipal = class(TForm)
    Button1: TButton;
    memLog: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    C_CLIENT_EVENT : String;
    procedure RegistryEvents(_client : TIdHTTPWebsocketClient);
    procedure Produtos(const ASocket: ISocketIOContext; const aArgument: TJSONValue; const aCallback: ISocketIOCallback);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

var
  client: TIdHTTPWebsocketClient;

const
  C_SERVER_EVENT = 'SERVER_TO_CLIENT_EVENT_TEST';
  ID_CLIENTE = 'ID_CLIENT';

{$R *.dfm}

procedure TfPrincipal.Button1Click(Sender: TObject);
begin
  C_CLIENT_EVENT := Edit2.Text;

  client := TIdHTTPWebsocketClient.Create(Self);

  client.Port := 55666;
  client.Host := 'localhost';
  client.SocketIOCompatible := True;

  RegistryEvents(client);

  try
    client.Connect;
  except
    on e : Exception do
      ShowMessage(e.Message);
  end;
end;

procedure TfPrincipal.Button2Click(Sender: TObject);
begin
  client.SocketIO.Emit(C_CLIENT_EVENT, '{"request":"'+ edit1.Text+'"}',

    procedure(const ASocket: ISocketIOContext; const aJSON: TJSONValue; const aCallback: ISocketIOCallback)
    begin
      memLog.Lines.Add('RESPONSE: ' + aJSON.Value);
    end);
end;

procedure TfPrincipal.RegistryEvents(_client : TIdHTTPWebsocketClient);
begin
  _client.SocketIO.OnEvent(C_SERVER_EVENT,
    procedure(const ASocket: ISocketIOContext; const aArgument: TJSONValue; const aCallback: ISocketIOCallback)
    begin
      memLog.Lines.Add('Server: ' + aArgument.ToJSON);

      if aCallback <> nil then
        aCallback.SendResponse(Edit2.Text);
    end);

  _client.SocketIO.OnEvent(ID_CLIENTE,
    procedure(const ASocket: ISocketIOContext; const aArgument: TJSONValue; const aCallback: ISocketIOCallback)
    begin
      if aCallback <> nil then
        aCallback.SendResponse( TJSONObject.ParseJSONValue('{"socket_user":"' + Edit2.Text+ '"}').ToJSON);
    end);

  _client.SocketIO.OnEvent('/produtos', Produtos);
end;

procedure TfPrincipal.Produtos(const ASocket: ISocketIOContext; const aArgument: TJSONValue; const aCallback: ISocketIOCallback);
var
  Obj : TJsonObject;
  Ary : TJSONArray;
  I :integer;
begin
  memLog.Lines.Add(aArgument.ToJSON);

  Ary := TJSONArray.Create;

  for I := 1 to 3 do
    begin
      Obj := TJSONObject.Create;

      Obj.AddPair('descricao','Produto '+I.Tostring);

      ary.addElement(OBj);
    end;

  memLog.Lines.Add(Ary.ToJSON);

  if aCallback <> nil then
    aCallback.SendResponse(ary.ToJSON);
end;


end.
