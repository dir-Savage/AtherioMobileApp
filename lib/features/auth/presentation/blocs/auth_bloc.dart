import 'package:atherio/core/const/core_usecase.dart';
import 'package:atherio/features/auth/domain/entities/user_entity.dart';
import 'package:atherio/features/auth/domain/usecases/forget_pwd.dart';
import 'package:atherio/features/auth/domain/usecases/login_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reg_usecase.dart';
import 'package:atherio/features/auth/domain/usecases/reset_pwd.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Register register;
  final Login login;
  final ForgotPassword forgotPassword;
  final ResetPassword resetPassword;
  final GetCurrentUser getCurrentUser;

  AuthBloc({
    required this.register,
    required this.login,
    required this.forgotPassword,
    required this.resetPassword,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await register.call(RegisterParams(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
    ));
    result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await login.call(LoginParams(
      email: event.email,
      password: event.password,
    ));
    result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await forgotPassword.call(event.email);
    result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (_) => emit(AuthSuccess()),
    );
  }

  Future<void> _onResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await resetPassword.call(event.newPassword);
    result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (_) => emit(AuthSuccess()),
    );
  }

  Future<void> _onGetCurrentUser(GetCurrentUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getCurrentUser.call(NoParams());
    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) => emit(AuthAuthenticated(user)),
    );
  }
}