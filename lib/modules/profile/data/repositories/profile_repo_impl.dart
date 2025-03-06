import 'package:ctntelematics/modules/profile/data/models/req_models/change_pwd_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/req_models/create_schedule_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/req_models/expeneses_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/req_models/gen_otp_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/req_models/token_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/resp_models/expenses_resp_model.dart';
import 'package:ctntelematics/modules/profile/data/models/resp_models/profile_vehicles_resp_model.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/change_pwd_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/complete_schedule_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/create_schedule_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/expenses_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/gen_otp_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/token_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/req_entities/verify_email_req_entity.dart';
import 'package:ctntelematics/modules/profile/domain/entitties/resp_entities/create_schedule_resp_entity.dart';

import '../../../../core/model/token_req_entity.dart';
import '../../../../core/model/token_req_model.dart';
import '../../../../core/network/network_exception.dart';
import '../../../../core/resources/profile_data_state.dart';
// import '../../domain/entitties/req_entities/token_req_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_api_client.dart';
import '../models/req_models/complete_schedule_req_model.dart';
import '../models/resp_models/complete_schedule_resp_model.dart';
import '../models/resp_models/create_schedule_resp_model.dart';
import '../models/resp_models/get_schedule_notice_resp_model.dart';
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
      password_confirmation: changePwdReqEntity.password_confirmation,
    );
    print("email: ${reqChangePwdReqModel.email}");
    print("otp: ${ reqChangePwdReqModel.otp}");
    print("password: ${ reqChangePwdReqModel.password}");
    print("password_confirmation: ${reqChangePwdReqModel.password_confirmation}");
    print("source-code: ${sourceCode}");
    try {
      return await handleProfileErrorHandling(
          apiClient.changePassword(
          reqChangePwdReqModel.email.trim(),
          reqChangePwdReqModel.otp.trim(),
          reqChangePwdReqModel.password.trim(),
          reqChangePwdReqModel.password_confirmation.trim(), sourceCode)
    );
    }
    on ApiErrorException catch (e) {
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
      return await handleGetScheduleErrorHandling(
       apiClient.getSchedule(tokenReqModel.token));
      } on ApiErrorException catch (e) {
        throw ApiErrorException(e.message); // Propagate the error with the API message
      } on NetworkException catch (e) {
        throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      print("error::::: $e");
      throw Exception("An error occurred while changing password.");
    }
  }

  @override
  Future<CreateScheduleRespModel> onCreateSchedule(CreateScheduleReqEntity createScheduleReqEntity) async {
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
      return await handleCreateScheduleErrorHandling(
          apiClient.createSchedule(
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
          createScheduleReqModel.token));
      } on ApiErrorException catch (e) {
        throw ApiErrorException(e.message); // Propagate the error with the API message
      } on NetworkException catch (e) {
        throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      print("error:::---:: $e");
      throw Exception("An error occurred while creating schedule.");
    }
  }


  @override
  Future<ProfileVehicleRespModel> onGetAllVehicles(TokenReqEntity vehicleReqEntity) async {

    TokenReqModel vehicleReqModel = TokenReqModel(
        token: vehicleReqEntity.token,
        contentType: vehicleReqEntity.contentType);
    try {
      return await handleProfileVehicleErrorHandling(
        apiClient.getAllVehicles(vehicleReqModel.token, vehicleReqModel.contentType!)
      );

    }
    on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    }
    catch (e) {
      throw Exception("An error occurred while logging in: $e");
    }
  }


  @override
  Future<List<GetScheduleNoticeRespModel>> onGetScheduleNotice(TokenReqEntity param) async {

    TokenReqModel vehicleReqModel = TokenReqModel(
        token: param.token,
        contentType: param.contentType);

    print("token: ${vehicleReqModel.token}");
    print("contentType: ${vehicleReqModel.contentType}");
    try {
      return await handleScheduleNoticeErrorHandling(
           apiClient.getScheduleNotice(vehicleReqModel.token, vehicleReqModel.contentType!)
      );

    }
    on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    }
    catch (e) {
      print("error:- $e");
      throw Exception("An error occurred while logging in: $e");
    }
  }

  @override
  Future<CompleteScheduleRespModel> onCompleteSchedule(CompleteScheduleReqEntity completeScheduleReqEntity) async {
    CompleteScheduleReqModel completeScheduleReqModel = CompleteScheduleReqModel(
        vehicle_vin: completeScheduleReqEntity.vehicle_vin,
        schedule_id: completeScheduleReqEntity.schedule_id,
        token: completeScheduleReqEntity.token);
    try {
      return await handleCompleteScheduleErrorHandling(
          apiClient.completeSchedule(
              completeScheduleReqModel.vehicle_vin,
              completeScheduleReqModel.schedule_id,
              completeScheduleReqModel.token));
    } on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    } catch (e) {
      throw Exception("An error occurred while creating schedule.");
    }
  }

  @override
  Future<GetScheduleNoticeRespModel> onGetSingleScheduleNotice(TokenReqEntity param) async {

    TokenReqModel vehicleReqModel = TokenReqModel(
        token: param.token,
        contentType: param.contentType,
        vehicle_vin: param.vehicle_vin
    );

    print("token: ${vehicleReqModel.token}");
    print("vehicle_vin: ${vehicleReqModel.vehicle_vin}");
    try {
      // return await handleScheduleNoticeErrorHandling(
      return apiClient.getSingleScheduleNotice(vehicleReqModel.vehicle_vin!, vehicleReqModel.token, vehicleReqModel.contentType!);
      // );

    }
    on ApiErrorException catch (e) {
      throw ApiErrorException(e.message); // Propagate the error with the API message
    } on NetworkException catch (e) {
      throw NetworkException(); // Propagate network-specific errors
    }
    catch (e) {
      throw Exception("An error occurred while logging in: $e");
    }
  }

  @override
  Future<ExpensesRespModel> onGetExpenses(ExpensesReqEntity param) async {

    ExpensesReqModel expensesReqModel = ExpensesReqModel(
        from: param.from,
        to: param.to,
        token: param.token
    );
    try {
      // return await handleScheduleNoticeErrorHandling(
      return apiClient.getExpenses(expensesReqModel.from, expensesReqModel.to, expensesReqModel.token);
      // );

    }
    // on ApiErrorException catch (e) {
    //   throw ApiErrorException(e.message); // Propagate the error with the API message
    // } on NetworkException catch (e) {
    //   throw NetworkException(); // Propagate network-specific errors
    // }
    catch (e) {
      throw Exception("An error occurred while logging in: $e");
    }
  }

}
