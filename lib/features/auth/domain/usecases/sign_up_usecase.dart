import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);

  Future<void> call({
    required String email,
    required String password,
    String? fullName,
  }) =>
      _repository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
}