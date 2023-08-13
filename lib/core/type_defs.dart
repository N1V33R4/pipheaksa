import 'package:fpdart/fpdart.dart';
import 'package:pipheaksa/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
