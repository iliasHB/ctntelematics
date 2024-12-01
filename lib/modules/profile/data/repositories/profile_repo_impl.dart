import 'package:ctntelematics/modules/profile/data/models/req_models/change_pwd_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/req_models/create_schedule_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/req_models/gen_otp_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/req_models/token_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/resp_models/profile_vehicles_resp_model.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/create_schedule_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/gen_otp_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/verify_email_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/create_schedule_resp_entity.dart';

import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/profile_data_state.dart';
// import '../../domain/entitties/req_entities/token_req_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_api_client.dart';
import '../models/resp_models/get_schedule_resp_model.dart';
import '../models/resp_models/profile_resp_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiClient apiClient;
  String sourceCode =
      "c085645f276fd835042d3730d6a8fc99f6a3f0e8dd3d3ee73f61bbe9db425f13";
  ProfileRepositoryImpl(this.apiClient);

  @override
  Future<ProfileRespModel> onGenerateOtp(
      GenOtpReqEntity genOtpReqEntity) async {
    GenOtpReqModel regOtpReqModel =
        GenOtpReqModel(email: genOtpReqEntity.email);
    try {
      return await handleProfileErrorHandling(
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
  Future<ProfileRespModel> onChangePassword(
      ChangePwdReqEntity changePwdReqEntity) async {
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
      return await handleProfileErrorHandling(apiClient.changePassword(
          reqChangePwdReqModel.email,
          reqChangePwdReqModel.otp,
          reqChangePwdReqModel.password,
          reqChangePwdReqModel.passwordConfirmation,
          sourceCode));
    } on ApiErrorException catch (e) {
      print('object----eeee:::: ${e.message}');
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while changing password.");
    }
  }

  @override
  Future<ProfileRespModel> onVerifyEmail(
      VerifyEmailReqEntity verifyEmailReqEntity) async {
    VerifyEmailReqEntity reqVerifyEmailReqEntity = VerifyEmailReqEntity(
      email: verifyEmailReqEntity.email,
      otp: verifyEmailReqEntity.otp,
    );
    try {
      return await handleProfileErrorHandling(apiClient.verifyEmail(
          reqVerifyEmailReqEntity.email,
          reqVerifyEmailReqEntity.otp,
          sourceCode));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while changing password.");
    }
  }

  @override
  Future<ProfileRespModel> onLogout(TokenReqEntity tokenReqEntity) async {
    TokenReqModel tokenReqModel = TokenReqModel(token: tokenReqEntity.token);
    try {
      return await handleProfileErrorHandling(
          apiClient.logout(tokenReqModel.token));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(
          e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while logging out.");
    }
  }

  @override
  Future<GetScheduleRespModel> onGetSchedule(
      TokenReqEntity tokenReqEntity) async {
    TokenReqModel tokenReqModel = TokenReqModel(token: tokenReqEntity.token);
    print("token:::::::--- ${tokenReqModel.token}");
    try {
      //return await handleProfileErrorHandling(
      return apiClient.getSchedule(tokenReqModel.token);
      // } on ApiErrorException catch (e) {
      //   throw ApiErrorException(e.message); // Propagate the error with the API message
      // } on NetworkException catch (e) {
      //   throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      print("error::::: $e");
      throw Exception("An error occurred while changing password.");
    }
  }

  @override
  Future<CreateScheduleRespEntity> onCreateSchedule(CreateScheduleReqEntity createScheduleReqEntity) async {
    CreateScheduleReqModel createScheduleReqModel = CreateScheduleReqModel(
        description: createScheduleReqEntity.description,
        vehicle_vin: createScheduleReqEntity.vehicle_vin,
        schedule_type: createScheduleReqEntity.schedule_type,
        start_date: createScheduleReqEntity.start_date,
        number_kilometer: createScheduleReqEntity.number_kilometer,
        number_time: createScheduleReqEntity.number_time,
        category_time: createScheduleReqEntity.category_time,
        number_hour: createScheduleReqEntity.number_hour,
        reminder_advance_days: createScheduleReqEntity.reminder_advance_days,
        reminder_advance_hr: createScheduleReqEntity.reminder_advance_hr,
        reminder_advance_km: createScheduleReqEntity.reminder_advance_km,
        token: createScheduleReqEntity.token);
    try {
      //return await handleProfileErrorHandling(
      return apiClient.createSchedule(
          createScheduleReqModel.description,
          createScheduleReqModel.vehicle_vin,
          createScheduleReqModel.schedule_type,
          createScheduleReqModel.start_date,
          createScheduleReqModel.number_kilometer,
          createScheduleReqModel.number_time,
          createScheduleReqModel.category_time,
          createScheduleReqModel.number_hour,
          createScheduleReqModel.reminder_advance_days,
          createScheduleReqModel.reminder_advance_hr,
          createScheduleReqModel.reminder_advance_km,
          createScheduleReqModel.token);
      // } on ApiErrorException catch (e) {
      //   throw ApiErrorException(e.message); // Propagate the error with the API message
      // } on NetworkException catch (e) {
      //   throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      print("error::::: $e");
      throw Exception("An error occurred while changing password.");
    }
  }


  @override
  Future<ProfileVehicleRespModel> onGetAllVehicles(TokenReqEntity vehicleReqEntity) async {

    TokenReqModel vehicleReqModel = TokenReqModel(
        token: vehicleReqEntity.token,
        contentType: vehicleReqEntity.contentType);

    print("token: ${vehicleReqModel.token}");
    print("contentType: ${vehicleReqModel.contentType}");
    try {
      // return await handleVehicleErrorHandling(
          return apiClient.getAllVehicles(vehicleReqModel.token, vehicleReqModel.contentType!);
      // );
    }
    // on ApiErrorException catch (e) {
    //   throw ApiErrorException(e.message); // Propagate the error with the API message
    // } on NetworkException catch (e) {
    //   throw NetworkException(); // Propagate network-specific errors
    // }
    catch (e) {
      print("error:- $e");
      throw Exception("An error occurred while logging in: $e");
    }
  }

}
