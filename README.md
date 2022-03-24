# Horse-SocketIO
Middleware for Horse using SocketIO.
Library on https://github.com/WillHubner/GenericSocket

## Installation ->
Installation is done using the [`boss install`](https://github.com/HashLoad/boss) command:
``` sh
boss install willhubner/Horse-SocketIO
```

## How to use ->
```delphi
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
```

## Client Side ->
Install *GenericSocket*
``` sh
boss install willhubner/genericsocket
```

```delphi
  TGenericSocket
    .New
    .SocketClient
      .RegisterCallback('/route',
        function (Message : String) : String
        begin
          Result := 'Callback '+Message
        end
      )
      .Connect('192.168.0.128', 8080, '@socket_name');
```

## Jump the Cat ->
In your request, put a **HEADER** named *socket_client* and value with the name of client socket, in the example, called "socket_name".
Write your callback function acconding to the "route" especificated, map the functions that you use, when the request gets on horse, will be directed to client-socket.

The server socket will be started on port 8080.

The functions should be writen on client-socket, when the horse gets the header [socket_client] will redirect the calls.

## Basic routes ->
``` sh
[GET] /socket_clients 
```
*Return all connected clients.

``` sh
[GET] /socket/[route] 
[POST] /socket/[route] 
```
*Function to redirect your calls*

Example:
https://www.youtube.com/watch?v=JYLbiNEzIgs

<details>
  <summary>Português</summary>

  ```
  Middleware para Horse utilizando SocketIO.
  Biblioteca disponibilizada no link https://github.com/andremussche/DelphiWebsockets

  Para utilizar, coloque no HEADER a chave socket_client e o valor com o nome do cliente desejado.
  Na aplicação cliente, mapeie as funções que deseja, quando o request bater no horse, será direcionado para o client-socket.

  O servidor Socket será startado na porta 55666.

  As funções serão escritas dentro do cliente, e quando o horse receber o cabeçalho [socket_client] irá redirecionar as chamadas.

  Para obter a lista de clientes, chame o método /socket_clients na URL.
  ```
</details>

