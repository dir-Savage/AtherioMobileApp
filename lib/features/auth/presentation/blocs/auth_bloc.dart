import 'package:atherio/core/const/core_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/forget_pwd.dart';
import 'package:atherio/features/auth/domain/usecases/login_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reg_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reset_pwd.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Register register;
  final GetCurrentUser getCurrentUser;
  final ForgotPassword forgotPassword;
  final ResetPassword resetPassword;

  AuthBloc({
    required this.login,
    required this.register,
    required this.getCurrentUser,
    required this.forgotPassword,
    required this.resetPassword,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await login(LoginParams(
        email: event.email,
        password: event.password,
      ));
      await result.fold(
        (failure) async => emit(AuthFailure(failure.message)),
        (user) async => emit(AuthAuthenticated(user: user)),
      );
    } catch (e) {
      emit(AuthFailure('Login failed: $e'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await register(RegisterParams(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
      ));
      await result.fold(
        (failure) async => emit(AuthFailure(failure.message)),
        (user) async => emit(AuthAuthenticated(user: user)),
      );
    } catch (e) {
      emit(AuthFailure('Registration failed: $e'));
    }
  }

  Future<void> _onGetCurrentUser(
      GetCurrentUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await getCurrentUser(NoParams());
      await result.fold(
        (failure) async => emit(AuthFailure(failure.message)),
        (user) async => emit(AuthAuthenticated(user: user)),
      );
    } catch (e) {
      emit(AuthFailure('Failed to fetch user: $e'));
    }
  }

  Future<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await forgotPassword(event.email);
      await result.fold(
        (failure) async => emit(AuthFailure(failure.message)),
        (_) async => emit(const AuthSuccess('Password reset email sent')),
      );
    } catch (e) {
      emit(AuthFailure('Failed to send reset email: $e'));
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await resetPassword(event.newPassword);
      await result.fold(
        (failure) async => emit(AuthFailure(failure.message)),
        (_) async => emit(const AuthSuccess('Password reset successful')),
      );
    } catch (e) {
      emit(AuthFailure('Failed to reset password: $e'));
    }
  }
}
