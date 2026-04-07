import 'package:equatable/equatable.dart';
import '../../data/models/user.dart';

/// Base class for Auth States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - app just started, checking auth status
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Checking if user is authenticated (loading from storage)
class AuthChecking extends AuthState {
  const AuthChecking();
}

/// User is authenticated (logged in)
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated (logged out or never logged in)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Login in progress
class AuthLoginInProgress extends AuthState {
  const AuthLoginInProgress();
}

/// Login failed with error
class AuthLoginFailure extends AuthState {
  final String message;

  const AuthLoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Logout in progress
class AuthLogoutInProgress extends AuthState {
  const AuthLogoutInProgress();
}

/// Refreshing user data
class AuthRefreshingUser extends AuthState {
  final User currentUser;

  const AuthRefreshingUser({required this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}
