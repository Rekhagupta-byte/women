import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women/core/secrets/app_secrets.dart';
import 'package:women/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:women/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:women/features/auth/domain/repository/auth_repository.dart';
import 'package:women/features/auth/domain/usecases/user_login.dart';
import 'package:women/features/auth/domain/usecases/user_sign_up.dart';
import 'package:women/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseanonKey,
  );
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
    ),
  );
}
