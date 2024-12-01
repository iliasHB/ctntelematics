import 'package:ctntelematics/modules/authentication/data/datasources/remote/auth_api_client.dart';
import 'package:ctntelematics/modules/authentication/data/models/auth_req_models/gen_otp_req_model.dart';
import 'package:ctntelematics/modules/authentication/data/models/auth_resp_models/login_resp_model.dart';
import 'package:ctntelematics/modules/authentication/domain/entities/auth_req_entites/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/authentication/domain/entities/auth_req_entites/gen_otp_req_entity.dart';
import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/auth_req_entites/login_req_entity.dart';
import '../../domain/entities/auth_req_entites/verify_email_req_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_req_models/change_pwd_req_model.dart';
import '../models/auth_req_models/login_req_model.dart';
import '../models/auth_resp_models/auth_resp_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient apiClient;
  String sourceCode =
      "c085645f276fd835042d3730d6a8fc99f6a3f0e8dd3d3ee73f61bbe9db425f13";
  AuthRepositoryImpl(this.apiClient);

  @override
  Future<LoginRespModel> onLogin(LoginReqEntity loginReqEntity) async {
    LoginReqModel loginReqModel = LoginReqModel(
        email: loginReqEntity.email, password: loginReqEntity.password);

    try {
      return await handleLoginErrorHandling(
        apiClient.getUserLogin(
            loginReqModel.email, loginReqModel.password, sourceCode),
      );
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while logging in.");
    }
  }

  @override
  Future<AuthRespModel> onGenerateOtp(GenOtpReqEntity genOtpReqEntity) async {
    GenOtpReqModel regOtpReqModel =
        GenOtpReqModel(email: genOtpReqEntity.email);
    try {
      return await handleOtpErrorHandling(
          apiClient.generateOtp(regOtpReqModel.email, sourceCode));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while generate otp.");
    }
  }

  @override
  Future<AuthRespModel> onChangePassword(ChangePwdReqEntity changePwdReqEntity) async {
    ChangePwdReqModel reqChangePwdReqModel = ChangePwdReqModel(
      email: changePwdReqEntity.email,
      password: changePwdReqEntity.password,
      otp: changePwdReqEntity.otp,
      passwordConfirmation: changePwdReqEntity.passwordConfirmation,
    );

    print("email: ${reqChangePwdReqModel.email}");
    print("otp: ${ reqChangePwdReqModel.otp}");
    print("password: ${ reqChangePwdReqModel.password}");
    print("retype-pwd: ${reqChangePwdReqModel.passwordConfirmation}");
    try {
      return await handleOtpErrorHandling(
          apiClient.changePassword(
              reqChangePwdReqModel.email,
              reqChangePwdReqModel.otp,
              reqChangePwdReqModel.password,
              reqChangePwdReqModel.passwordConfirmation,
              sourceCode));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while changing password.");
    }
  }

  @override
  Future<AuthRespModel> onVerifyEmail(VerifyEmailReqEntity verifyEmailReqEntity) async {
    VerifyEmailReqEntity reqVerifyEmailReqEntity = VerifyEmailReqEntity(
      email: verifyEmailReqEntity.email,
      otp: verifyEmailReqEntity.otp,
    );
    try {
      return await handleOtpErrorHandling(
          apiClient.verifyEmail(
              reqVerifyEmailReqEntity.email,
              reqVerifyEmailReqEntity.otp,
              sourceCode));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while changing password.");
    }
  }

}
