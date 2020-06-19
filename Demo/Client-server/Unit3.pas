unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.JSON, System.JSON, IdWebsocketServer,
  IdHTTPWebsocketClient, superobject, IdSocketIOHandling, IdIOHandlerWebsocket,IdCoderMIME;

type
  TfPrincipal = class(TForm)
    Button1: TButton;
    memLog: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Edit2: TEdit;
    mmoError: TMemo;
    mmConn: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    C_CLIENT_EVENT : String;
    procedure RegistryEvents(_client : TIdHTTPWebsocketClient);
    procedure Produtos(const ASocket: ISocketIOContext; const aArgument: TSuperArray; const aCallback: ISocketIOCallback);
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

function SalvaErro(E : String):Boolean;
Var
  openfile: TextFile;
  NomeDoLog: String;
begin
  NomeDoLog :=  ExtractFilePath(Application.ExeName)+'\LogError ' +FormatDateTime('dd-mm-yyyy', Now) + '.txt';

  if FileExists(NomeDoLog) then
    begin
      AssignFile(openfile, NomeDoLog);
      Append(openfile);
      WriteLn(openfile, #13 + FormatDateTime('hh:mm:ss', now) + '-' +E );
    end
  else
    begin
      ReWrite( openfile, NomeDoLog);
      CloseFile(openfile);
      AssignFile(openfile, NomeDoLog);
      Append(openfile);
      WriteLn(openfile, #13 + FormatDateTime('hh:mm:ss', now) + '-' +E );
    end;

  CloseFile(openfile);
end;

procedure ShowMessageInMainthread(const aMsg: string) ;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      ShowMessage(aMsg);
    end);
end;

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
  client.SocketIO.Emit(C_CLIENT_EVENT, SO([ 'request', edit1.Text]),

    procedure(const ASocket: ISocketIOContext; const aJSON: ISuperObject; const aCallback: ISocketIOCallback)
    begin
      memLog.Lines.Add('RESPONSE: ' + aJSON.AsJSon);
    end);
end;

procedure TfPrincipal.RegistryEvents(_client : TIdHTTPWebsocketClient);
begin
  _client.SocketIO.OnEvent(C_SERVER_EVENT,
    procedure(const ASocket: ISocketIOContext; const aArgument: TSuperArray; const aCallback: ISocketIOCallback)
    begin
      memLog.Lines.Add('Server: ' + aArgument[0].AsJSon);

      if aCallback <> nil then
        aCallback.SendResponse(Edit2.Text);
    end);

  _client.SocketIO.OnEvent(ID_CLIENTE,
    procedure(const ASocket: ISocketIOContext; const aArgument: TSuperArray; const aCallback: ISocketIOCallback)
    begin
      if aCallback <> nil then
        aCallback.SendResponse(Edit2.Text);
    end);

  _client.SocketIO.OnEvent('/produtos', Produtos);
end;

procedure TfPrincipal.Produtos(const ASocket: ISocketIOContext;
  const aArgument: TSuperArray; const aCallback: ISocketIOCallback);
var
  Obj : TJsonObject;
  Ary : TJSONArray;
  I :integer;
begin

  Ary := TJSONArray.Create;

  for I := 1 to 3 do
    begin
      Obj := TJSONObject.Create;

      Obj.AddPair('descricao','Produto '+I.Tostring);

      ary.addElement(OBj);
    end;

  memLog.Lines.Add(Ary.ToJSON);

  if aCallback <> nil then
    aCallback.SendResponse(Ary.ToJSON);
end;


end.
