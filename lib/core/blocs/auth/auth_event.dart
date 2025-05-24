part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLogin extends AuthEvent {
  final String username;
  final String password;

  const AuthLogin({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class AuthLogout extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class AuthUpdateUser extends AuthEvent {
  final Usuario user;

  const AuthUpdateUser(this.user);

  @override
  List<Object> get props => [user];
}
