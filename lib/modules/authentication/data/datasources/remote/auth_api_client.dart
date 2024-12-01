import 'dart:async';
import 'dart:convert';

import 'package:ctntelematics/modules/authentication/data/models/auth_resp_models/auth_resp_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../../../../core/utils/app_export_util.dart';
import '../../models/auth_resp_models/login_resp_model.dart';
import '../../models/auth_resp_models/gen_otp_resp_model.dart';

part 'auth_api_client.g.dart';

@RestApi(baseUrl: baseUri)
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST("/user/login")
  @FormUrlEncoded()
  Future<LoginRespModel> getUserLogin(
      @Field("email") String email,
      @Field("password") String password,
      @Header("source_code") String sourceCode);

  @POST("/user/regenerate/otp")
  @FormUrlEncoded()
  Future<AuthRespModel> generateOtp(@Field("email") String email,
      @Header("source_code") String sourceCode);

  @POST("/user/verify/email")
  @FormUrlEncoded()
  Future<AuthRespModel> verifyEmail(@Field("email") String email,
      @Field("otp") String otp,
      @Header("source_code") String sourceCode);

  @POST("/user/change/password")
  @FormUrlEncoded()
  Future<AuthRespModel> changePassword(
      @Field("email") String email,
      @Field("otp") String otp,
      @Field("password") String password,
      @Field("password_confirmation") String passwordConfirmation,
      @Header("source_code") String sourceCode);
}