# Horse-SocketIO
Middleware para Horse utilizando SocketIO.
Biblioteca disponibilizada no link https://github.com/andremussche/DelphiWebsockets

Para utilizar, coloque no HEADER a chave socket_client e o valor com o nome do cliente desejado.
Na aplicação cliente, mapeie as funções que deseja, quando o request bater no horse, será direcionado para o client-socket.

O servidor Socket será startado na porta 55666.

As funções serão escritas dentro do cliente, e quando o horse receber o cabeçalho [socket_client] irá redirecionar as chamadas.

```delphi
uses
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Horse.SocketIO;

var
  App: THorse;

begin
  App := THorse.Create(9000);

  App.Use(Jhonson);
  App.Use(CORS);
  App.Use(SocketIO);

  App.Start;
end.
```
