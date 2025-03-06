
import 'package:ctntelematics/core/constant/constant.dart';
import 'package:ctntelematics/modules/profile/data/models/req_models/create_schedule_req_model.dart';
import 'package:ctntelematics/modules/profile/data/models/resp_models/expenses_resp_model.dart';
import 'package:ctntelematics/modules/profile/data/models/resp_models/get_schedule_resp_model.dart';
import 'package:ctntelematics/modules/profile/data/models/resp_models/profile_resp_model.dart';
import 'package:ctntelematics/modules/profile/data/models/resp_models/profile_vehicles_resp_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/resp_models/complete_schedule_resp_model.dart';
import '../../models/resp_models/create_schedule_resp_model.dart';
import '../../models/resp_models/get_schedule_notice_resp_model.dart';

part 'profile_api_client.g.dart';

@RestApi(baseUrl: baseUri)
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio _dio) = _ProfileApiClient;

  @POST("/user/regenerate/otp")
  @FormUrlEncoded()
  Future<ProfileRespModel> generateOtp(
      @Field("email") String email,
      @Header("source_code") String sourceCode);

  @POST("/user/verify/email")
  @FormUrlEncoded()
  Future<ProfileRespModel> verifyEmail(
      @Field("email") String email,
      @Field("otp") String otp,
      @Header("source_code") String sourceCode);


  @POST("/user/change/password")
  @FormUrlEncoded()
  Future<ProfileRespModel> changePassword(
      @Field("email") String email,
      @Field("otp") String otp,
      @Field("password") String password,
      @Field("password_confirmation") String password_confirmation,
      @Header("source_code") String sourceCode);

  @GET("/user/logout")
  Future<ProfileRespModel> logout(
      @Header("Authorization") String token);

  @GET("/get/all/service")
  Future<GetScheduleRespModel> getSchedule(
      @Header("Authorization") String token);

  @POST("/schedule/service")
  @FormUrlEncoded()
  Future<CreateScheduleRespModel> createSchedule(
      @Field("description") String description,
      @Field("vehicle_vin") String vehicle_vin,
      @Field("schedule_type") String schedule_type,
      @Field("start_date") String start_date,
      @Field("number_kilometer") String number_kilometer,
      @Field("number_time") String number_time,
      @Field("category_time") String category_time,
      @Field("number_hour") String number_hour,
      @Field("reminder_advance_days") String reminder_advance_days,
      @Field("reminder_advance_hr") String reminder_advance_hr,
      @Field("reminder_advance_km") String reminder_advance_km,
      @Header("Authorization") String token);

  @POST("/view/vehicle")
  Future<ProfileVehicleRespModel> getAllVehicles(
      @Header("Authorization") String token,
      @Header("Accept") String contentType,);

  @GET("/get/notice")
  Future<List<GetScheduleNoticeRespModel>> getScheduleNotice(
      @Header("Authorization") String token,
      @Header("Accept") String contentType,);

  @POST("/schedule/complete")
  Future<CompleteScheduleRespModel> completeSchedule(
      @Field("vehicle_vin") String vehicle_vin,
      @Field("schedule_id") String schedule_id,
      @Header("Authorization") String token,);

  @GET("/get/notice/single")
  Future<GetScheduleNoticeRespModel> getSingleScheduleNotice(
      @Field("vehicle_vin") String vehicle_vin,
      @Header("Authorization") String token,
      @Header("Accept") String contentType,);

  @GET("/expenses")
  Future<ExpensesRespModel> getExpenses(
      @Query("from") String from,
      @Query("to") String to,
      @Header("Authorization") String token,);

}