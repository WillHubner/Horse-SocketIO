program Client;

uses
  Vcl.Forms,
  Unit3 in 'Unit3.pas' {fPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
