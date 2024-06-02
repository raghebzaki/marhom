part of 'verify_account_cubit.dart';

@freezed
class VerifyAccountStates with _$VerifyAccountStates {
  const factory VerifyAccountStates.initial() = _Initial;
  const factory VerifyAccountStates.loading() = Loading;
  const factory VerifyAccountStates.success(final VerifyAccountEntity verifyAccount) = Success;
  const factory VerifyAccountStates.error(final Failure failure) = Error;
  const factory VerifyAccountStates.resendCode(final ResendCodeEntity resendCode) = ResendCode;
}
