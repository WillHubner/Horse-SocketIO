program ServerSide;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.SocketIO;

begin
  THorse
    .Use(Jhonson)
    .Use(SocketIO);

  THorse.Listen(9000);
end.
