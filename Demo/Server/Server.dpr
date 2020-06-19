program Server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  System.JSON,
  Horse.SocketIO;

var
  App: THorse;

begin
  App := THorse.Create(2284);

  App.Use(Jhonson);
  App.Use(CORS);
  App.Use(SocketIO);

  StartSocket(55666);

  App.Start;
end.
