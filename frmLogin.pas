unit frmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Mask, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,

  System.Hash, frmDados, frmMain;

type
  TfLogin = class(TForm)
    edLogin: TEdit;
    btLogin: TButton;
    btSair: TButton;
    edSenha: TEdit;
    queryUsuarios: TFDQuery;
    procedure btSairClick(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
    procedure edLoginKeyPress(Sender: TObject; var Key: Char);
    procedure edSenhaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLogin: TfLogin;

implementation

{$R *.dfm}

procedure TfLogin.btLoginClick(Sender: TObject);
var
  wSenha: String;
  wSenhaInformada: String;
begin
  queryUsuarios.Close;
  queryUsuarios.SQL.Text := 'SELECT * ' +
                            'FROM USUARIOS ' +
                            'WHERE LOGIN = ''' + edLogin.Text + '''';

  queryUsuarios.Open;

  wSenhaInformada := UpperCase(THashMD5.GetHashString('1234'));
  wSenha := queryUsuarios.FieldByName('SENHA').AsString;

  if wSenha = wSenhaInformada then
  begin
    Self.Hide;

    Application.CreateForm(TfMain, fMain);
    fMain.NomeUsuario := queryUsuarios.FieldByName('NOME').AsString;
    fMain.Show;
  end
  else
  begin
    ShowMessage('O login e/ou senha estão incorretos');
  end;
end;

procedure TfLogin.btSairClick(Sender: TObject);
begin
  Close;
  Application.Terminate;
end;

procedure TfLogin.edLoginKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not (Key in ['0'..'9','a'..'z','A'..'Z', Chr(8)]) then
    Key:= #0;
end;

procedure TfLogin.edSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if not (Key in ['0'..'9','a'..'z','A'..'Z', Chr(8)]) then
    Key:= #0;
end;

end.
