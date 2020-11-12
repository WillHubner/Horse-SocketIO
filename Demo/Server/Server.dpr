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
    .Use(SocketIO);  
    
  StartSocket(55666);
  
  THorse.Listen(9000);  
end.
