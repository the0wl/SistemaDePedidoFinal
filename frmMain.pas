unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TfMain = class(TForm)
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    Pedidos1: TMenuItem;
    Sair1: TMenuItem;
    procedure Sair1Click(Sender: TObject);
    procedure Pedidos1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    NomeUsuario: String;
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

uses frmConsultarPedidos;

procedure TfMain.FormCreate(Sender: TObject);
begin
  Height := 720;
  Width  := 1280;
end;

procedure TfMain.Pedidos1Click(Sender: TObject);
begin
  Application.CreateForm(TfConsultarPedidos, fConsultarPedidos);
  fConsultarPedidos.NomeUsuario := NomeUsuario;
  fConsultarPedidos.Show;
end;

procedure TfMain.Sair1Click(Sender: TObject);
begin
  Close;
  Application.Terminate;
end;

end.
