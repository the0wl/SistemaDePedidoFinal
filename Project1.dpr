program Project1;

uses
  Vcl.Forms,
  frmLogin in 'frmLogin.pas' {fLogin},
  frmDados in 'frmDados.pas' {fDados: TDataModule},
  frmMain in 'frmMain.pas' {fMain},
  frmManutencaoPedidos in 'frmManutencaoPedidos.pas' {fCadastrarPedidos},
  frmConsultarPedidos in 'frmConsultarPedidos.pas' {fConsultarPedidos},
  frmUtils in 'frmUtils.pas',
  frmConsts in 'frmConsts.pas',
  Vcl.Themes,
  Vcl.Styles,
  frmManutencaoItens in 'frmManutencaoItens.pas' {fManutencaoItens};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfLogin, fLogin);
  Application.CreateForm(TfDados, fDados);
  Application.CreateForm(TfManutencaoItens, fManutencaoItens);
  Application.Run;
end.
