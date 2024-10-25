part of 'sign_up_cubit.dart';

// enum SignUpStatus { initial, loading, success, failure }

/// Message that will be shown to user, when he will try to submit signup form,
/// but there is an error occurred. It is used to show user, what exactly went
/// wrong.
typedef SingUpErrorMessage = String;

/// Defines possible signup submission statuses. It is used to manipulate with
/// state, using Bloc, according to state. Therefore, when [success] we
/// can simply navigate user to main page and such.
enum SignUpSubmissionStatus {
  /// [SignUpSubmissionStatus.idle] indicates that user has not yet submitted
  /// signup form.
  idle,

  /// [SignUpSubmissionStatus.inProgress] indicates that user has submitted
  /// signup form and is currently waiting for response from backend.
  inProgress,

  /// [SignUpSubmissionStatus.success] indicates that user has successfully
  /// submitted signup form and is currently waiting for response from backend.
  success,

  /// [SignUpSubmissionStatus.emailAlreadyRegistered] indicates that email,
  /// provided by user, is occupied by another one in database.
  emailAlreadyRegistered,

  /// [SignUpSubmissionStatus.networkError] indicates that user had no internet
  /// connection during network request.
  networkError,

  /// [SignUpSubmissionStatus.error] indicates something went wrong when user
  /// tried to sign up.
  error;

  bool get isSuccess => this == SignUpSubmissionStatus.success;
  bool get isLoading => this == SignUpSubmissionStatus.inProgress;
  bool get isEmailRegistered =>
      this == SignUpSubmissionStatus.emailAlreadyRegistered;
  bool get isNetworkError => this == SignUpSubmissionStatus.networkError;
  bool get isError =>
      this == SignUpSubmissionStatus.error ||
      isNetworkError ||
      isEmailRegistered;
}

class SignUpState extends Equatable {
  const SignUpState._({
    required this.submissionStatus,
    required this.email,
    required this.password,
    required this.fullName,
    required this.username,
    required this.showPassword,
    // this.message
  });

  SignUpState.initial()
      : this._(
            submissionStatus: SignUpSubmissionStatus.idle,
            email: const Email.pure(),
            password: const Password.pure(),
            fullName: const FullName.pure(),
            username: const Username.pure(),
            showPassword: false);

  final SignUpSubmissionStatus submissionStatus;
  final Email email;
  final FullName fullName;
  final Username username;
  final Password password;
  final bool showPassword;
  // final LoginErrorMessage? message;

  @override
  List<Object?> get props =>
      [submissionStatus, email, password, username, fullName, showPassword];

  SignUpState copyWith(
      {SignUpSubmissionStatus? submissionStatus,
      Email? email,
      Password? password,
      FullName? fullName,
      Username? username,
      bool? showPassword,
      String? message}) {
    return SignUpState._(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      showPassword: showPassword ?? this.showPassword,
      // message: message
    );
  }
}

final signupSubmissionStatusMessage =
    <SignUpSubmissionStatus, SubmissionStatusMessage>{
  SignUpSubmissionStatus.emailAlreadyRegistered: const SubmissionStatusMessage(
    title: 'User with this email already exists.',
    description: 'Try another email address.',
  ),
  SignUpSubmissionStatus.error: const SubmissionStatusMessage.genericError(),
  SignUpSubmissionStatus.networkError:
      const SubmissionStatusMessage.networkError(),
};
