

import 'package:ctntelematics/core/usecase/usecase.dart';
import 'package:ctntelematics/modules/authentication/domain/entities/auth_req_entites/gen_otp_req_entity.dart';

import '../entities/auth_req_entites/change_pwd_req_entity.dart';
import '../entities/auth_req_entites/login_req_entity.dart';
import '../entities/auth_req_entites/verify_email_req_entity.dart';
import '../entities/auth_resp_entities/login_resp_entites.dart';
import '../entities/auth_resp_entities/auth_resp_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<void, LoginReqEntity>{
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<LoginRespEntity> call(LoginReqEntity params) async {
    return await repository.onLogin(params);
  }
}

class GenerateOtpUseCase extends UseCase<void, GenOtpReqEntity>{
  final AuthRepository repository;

  GenerateOtpUseCase(this.repository);

  @override
  Future<AuthRespEntity> call(GenOtpReqEntity params) async {
    return await repository.onGenerateOtp(params);
  }
}


class ChangePasswordUseCase extends UseCase<void, ChangePwdReqEntity>{
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<AuthRespEntity> call(ChangePwdReqEntity params) async {
    return await repository.onChangePassword(params);
  }
}

class VerifyEmailUseCase extends UseCase<void, VerifyEmailReqEntity>{
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  @override
  Future<AuthRespEntity> call(VerifyEmailReqEntity params) async {
    return await repository.onVerifyEmail(params);
  }
}