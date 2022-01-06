class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_NOT_FOUND": "O Email não foi encontrado",
    "INVALID_PASSWORD": "Senha inválida",
    "EMAIL_EXISTS": "Este email já está cadastrado",
    "OPERATION_NOT_ALLOWED": "Operação não permitida",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Acesso bloqueado, tenta novamente mais tarde",
    "USER_DISABLED": "Esta conta foi desabilitada"
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro no processo de autenticação';
  }
}
