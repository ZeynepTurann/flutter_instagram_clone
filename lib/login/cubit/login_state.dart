
part of 'login_cubit.dart';

/// [LoginErrorMessage] is a type alias for [String] that is used to indicate
/// error message, that will be shown to user, when he will try to submit login
/// form, but there is an error occurred. It is used to show user, what exactly
/// went wrong.
typedef LoginErrorMessage = String;

/// [LoginState] submission status, indicating current state of user login
/// process.
enum LogInSubmissionStatus {
  /// [LogInSubmissionStatus.idle] indicates that user has not yet submitted
  /// login form.  so you can consider it as a  inital state 
  idle,

  /// [LogInSubmissionStatus.loading] indicates that user has submitted
  /// login form and is currently waiting for response from backend. 
  loading,

  /// [LogInSubmissionStatus.googleAuthInProgress] indicates that user has
  /// submitted login with google.
  googleAuthInProgress,

  /// [LogInSubmissionStatus.githubAuthInProgress] indicates that user has
  /// submitted login with github.
  githubAuthInProgress,

  /// [LogInSubmissionStatus.success] indicates that user has successfully
  /// submitted login form and is currently waiting for response from backend.
  success,

  /// [LogInSubmissionStatus.invalidCredentials] indicates that user has
  /// submitted login form with invalid credentials.
  invalidCredentials,

  /// [LogInSubmissionStatus.userNotFound] indicates that user with provided
  /// credentials was not found in database.
  userNotFound,

  /// [LogInSubmissionStatus.loading] indicates that user has no internet
  /// connection,during network request.
  networkError,

  /// [LogInSubmissionStatus.error] indicates that something unexpected happen.
  error,

  /// [LogInSubmissionStatus.googleLogInFailure] indicates that some went
  /// wrong during google login process.
  googleLogInFailure;

  bool get isSuccess => this == LogInSubmissionStatus.success;
  bool get isLoading => this == LogInSubmissionStatus.loading;
  bool get isGoogleAuthInProgress =>
      this == LogInSubmissionStatus.googleAuthInProgress;
  bool get isGithubAuthInProgress =>
      this == LogInSubmissionStatus.githubAuthInProgress;
  bool get isInvalidCredentials =>
      this == LogInSubmissionStatus.invalidCredentials;
  bool get isNetworkError => this == LogInSubmissionStatus.networkError;
  bool get isUserNotFound => this == LogInSubmissionStatus.userNotFound;
  bool get isError =>
      this == LogInSubmissionStatus.error ||
      isUserNotFound ||
      isNetworkError ||
      isInvalidCredentials;
}

// enum LogInSubmissionStatus { initial, loading, success, failure }



class LoginState extends Equatable {
  const LoginState._(
      {required this.status,
      required this.email,
      required this.password,
      required this.showPassword});

  LoginState.initial()
      : this._(
            status: LogInSubmissionStatus.idle,
            email: const Email.pure(),
            password: const Password.pure(),
            showPassword: false);

  final LogInSubmissionStatus status;
  final Email email;
  final Password password;
  final bool showPassword;

  @override
  List<Object?> get props => [status, email, password, showPassword];

  LoginState copyWith(
      {LogInSubmissionStatus? status,
      Email? email,
      Password? password,
      bool? showPassword}) {
    return LoginState._(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        showPassword: showPassword ?? this.showPassword);
  }
}



//initial status da email and password untouched so is unvalidated