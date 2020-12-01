program Cliente;

uses
  Vcl.Forms,
  View.Principal in 'View.Principal.pas' {Principal},
  Controller.SocketIO in 'Controller.SocketIO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPrincipal, Principal);
  Application.Run;
end.
