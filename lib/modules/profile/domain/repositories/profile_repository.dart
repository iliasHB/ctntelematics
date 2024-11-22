

import 'package:ctntelematics/modules/profile/data/models/resp_models/get_schedule_resp_model.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/create_schedule_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/gen_otp_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/verify_email_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/create_schedule_resp_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/get_schedule_resp_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/profile_vehicle_resp_entity.dart';

import '../entitties/resp_entities/profile_resp_entity.dart';

abstract class ProfileRepository{

  Future<ProfileRespEntity>onGenerateOtp(GenOtpReqEntity genOtpReqEntity);

  Future<ProfileRespEntity>onChangePassword(ChangePwdReqEntity changePwdReqEntity);

  Future<ProfileRespEntity>onVerifyEmail(VerifyEmailReqEntity verifyEmailReqEntity);

  Future<ProfileRespEntity>onLogout(TokenReqEntity tokenReqEntity);

  Future<GetScheduleRespEntity>onGetSchedule(TokenReqEntity tokenReqEntity);

  Future<CreateScheduleRespEntity>onCreateSchedule(CreateScheduleReqEntity createScheduleReqEntity);

  Future<ProfileVehicleRespEntity>onGetAllVehicles(TokenReqEntity tokenReqEntity);

}