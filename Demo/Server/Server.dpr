program Server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  System.JSON,
  Horse.SocketIO;

begin
  THorse
    .Use(Jhonson)
    .Use(CORS)
    .Use(SocketIO)
    .Listen(9000);

  StartSocket(55666);
end.
