import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';

// Alias limpio para usar en toda la app
typedef Result<T> = Either<Failure, T>;

// Helpers para crear resultados sin escribir right/left cada vez
Result<T> success<T>(T value) => right(value);
Result<T> failure<T>(Failure f) => left(f);

// Ejecuta una operación async que puede fallar y la convierte a Result<T>.
// Captura cualquier excepción y la mapea a un Failure tipado.
Future<Result<T>> tryResult<T>(
  Future<T> Function() call, {
  Failure Function(Object e)? onError,
}) async {
  try {
    return right(await call());
  } catch (e) {
    return left(onError?.call(e) ?? mapExceptionToFailure(e));
  }
}