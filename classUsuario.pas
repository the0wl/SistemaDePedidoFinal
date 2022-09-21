unit classUsuario;

interface

type
  TUsuario = class
    FCodUsuario: Integer;
    FLogin: String;
    FSenha: String;
    FNome: String;
  private
    constructor Create(pCodUsuario: Integer; pLogin, pSenha, pNome: String);

    function cadastroValido: Boolean;
  public

  end;

var
  Usuario: TUsuario;

implementation

constructor TUsuario.Create(pCodUsuario: Integer; pLogin, pSenha, pNome: String);
begin
  FCodUsuario := pCodUsuario;
  FLogin := pLogin;
  FSenha := pSenha;
  FNome := pNome;
end;

function TUsuario.cadastroValido: Boolean;
begin
  Result := False;

  // Controller

  Result := True;
end;

end.
