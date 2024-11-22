
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/create_schedule_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/gen_otp_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/verify_email_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/profile_vehicle_resp_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../entitties/resp_entities/create_schedule_resp_entity.dart';
import '../entitties/resp_entities/profile_resp_entity.dart';
import '../repositories/profile_repository.dart';

class ProfileGenerateOtpUseCase extends UseCase<void, GenOtpReqEntity>{
  final ProfileRepository repository;

  ProfileGenerateOtpUseCase(this.repository);

  @override
  Future<ProfileRespEntity> call(GenOtpReqEntity params) async {
    return await repository.onGenerateOtp(params);
  }
}


class ProfileChangePasswordUseCase extends UseCase<void, ChangePwdReqEntity>{
  final ProfileRepository repository;

  ProfileChangePasswordUseCase(this.repository);

  @override
  Future<ProfileRespEntity> call(ChangePwdReqEntity params) async {
    return await repository.onChangePassword(params);
  }
}

class ProfileVerifyEmailUseCase extends UseCase<void, VerifyEmailReqEntity>{
  final ProfileRepository repository;

  ProfileVerifyEmailUseCase(this.repository);

  @override
  Future<ProfileRespEntity> call(VerifyEmailReqEntity params) async {
    return await repository.onVerifyEmail(params);
  }
}

class LogoutUseCase extends UseCase<void, TokenReqEntity>{
  final ProfileRepository repository;

  LogoutUseCase(this.repository);
  @override
  Future<ProfileRespEntity> call(TokenReqEntity params) async {
    // TODO: implement call
    return await repository.onLogout(params);
  }

}


class GetScheduleUseCase extends UseCase<void, TokenReqEntity>{
  final ProfileRepository repository;

  GetScheduleUseCase(this.repository);
  @override
  Future<GetScheduleRespEntity> call(TokenReqEntity params) async {
    // TODO: implement call
    return await repository.onGetSchedule(params);
  }

}

class CreateScheduleUseCase extends UseCase<void, CreateScheduleReqEntity>{
  final ProfileRepository repository;

  CreateScheduleUseCase(this.repository);
  @override
  Future<CreateScheduleRespEntity> call(CreateScheduleReqEntity params) async {
    // TODO: implement call
    return await repository.onCreateSchedule(params);
  }

}

class ProfileVehicleUseCase extends UseCase<void, TokenReqEntity>{
  final ProfileRepository repository;

  ProfileVehicleUseCase(this.repository);

  @override
  Future<ProfileVehicleRespEntity> call(TokenReqEntity params) async {
    return await repository.onGetAllVehicles(params);
  }
}