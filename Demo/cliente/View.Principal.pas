unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TPrincipal = class(TForm)
    edSocketName: TEdit;
    Button1: TButton;
    memLog: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Principal: TPrincipal;

implementation

{$R *.dfm}

uses Controller.SocketIO;

procedure TPrincipal.Button1Click(Sender: TObject);
begin
  SOCKET_USER := edSocketName.Text;
  SOCKET_PORT := '55666';
  SOCKET_SERVER := 'localhost';

  Socket_connect;
end;

end.
