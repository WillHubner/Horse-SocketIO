unit Unit4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls, GenericSocket;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ClientSocket : iGenericSocket;

    function SocketProdutos(Message : String) : String;
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

{ TForm4 }

procedure TForm4.Button1Click(Sender: TObject);
begin
  ClientSocket.SocketClient
    .RegisterCallback('/produtos', SocketProdutos)
    .Connect('localhost', 8050, '@brst');
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  ClientSocket := TGenericSocket.New;
end;

function TForm4.SocketProdutos(Message: String): String;
begin
  Memo1.Lines.Add('Recebi ' + Message + ' e Respondi.');
  Result := 'Respondido!';
end;

end.
