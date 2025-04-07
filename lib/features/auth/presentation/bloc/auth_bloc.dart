import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women/features/auth/domain/usecases/user_login.dart';
import 'package:women/features/auth/domain/usecases/user_sign_up.dart';
import 'package:women/database/database_helper.dart'; // ✅ Import SQLite Helper

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
  }
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print("🚀 Signup started...");

    final res = await _userSignUp(UserSignUpParams(
      email: event.email,
      name: event.name,
      password: event.password,
    ));

    res.fold(
      (failure) {
        print("❌ Signup failed: ${failure.message}");
        emit(AuthFailure(failure.message));
      },
      (user) async {
        print("✅ Signup successful: ${user.email}");

        // 🔹 Ensure Supabase automatically logs in the user after signup
        final supabase = Supabase.instance.client;
        await supabase.auth.refreshSession();
        final session = supabase.auth.currentSession;

        if (session?.user != null) {
          print("🚀 User session exists after signup!");

          // ✅ Insert user into SQLite for local tracking
          await DatabaseHelper.instance.insertUser(event.name, event.email);

          // ✅ Emit AuthSuccess with the user object
          emit(AuthSuccess(user));
        } else {
          print(
              "⚠️ Signup successful, but user is not logged in. Prompting login.");
          emit(AuthFailure("Signup successful. Please log in."));
        }
      },
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) {
        print("❌ Login failed: ${failure.message}");
        emit(AuthFailure(failure.message));
      },
      (user) {
        print("✅ Login successful: ${user.email}");
        emit(AuthSuccess(user)); // ✅ Pass the correct user object
      },
    );
  }
}
