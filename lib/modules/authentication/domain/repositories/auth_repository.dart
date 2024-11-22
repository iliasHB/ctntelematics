
import 'package:ctntelematics/modules/authentication/domain/entities/auth_req_entites/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/authentication/domain/entities/auth_req_entites/login_req_entity.dart';
import 'package:ctntelematics/modules/authentication/domain/entities/auth_req_entites/gen_otp_req_entity.dart';
import 'package:ctntelematics/modules/authentication/domain/entities/auth_req_entites/verify_email_req_entity.dart';
import 'package:ctntelematics/modules/authentication/domain/entities/auth_resp_entities/login_resp_entites.dart';

import '../../data/models/auth_resp_models/auth_resp_model.dart';
import '../entities/auth_resp_entities/auth_resp_entity.dart';

abstract class AuthRepository{

  Future<LoginRespEntity>onLogin(LoginReqEntity loginReqEntity);

  Future<AuthRespEntity>onGenerateOtp(GenOtpReqEntity genOtpReqEntity);

  Future<AuthRespEntity>onChangePassword(ChangePwdReqEntity changePwdReqEntity);

  Future<AuthRespEntity>onVerifyEmail(VerifyEmailReqEntity verifyEmailReqEntity);

}