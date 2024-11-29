// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ProfileApiClient implements ProfileApiClient {
  _ProfileApiClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://cti.maypaseducation.com/api';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<ProfileRespModel> generateOtp(
    String email,
    String sourceCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'source_code': sourceCode};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'email': email};
    final _options = _setStreamType<ProfileRespModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          '/user/regenerate/otp',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProfileRespModel _value;
      _value = ProfileRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<ProfileRespModel> verifyEmail(
    String email,
    String otp,
    String sourceCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'source_code': sourceCode};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'email': email,
      'otp': otp,
    };
    final _options = _setStreamType<ProfileRespModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          '/user/verify/email',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProfileRespModel _value;
      _value = ProfileRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<ProfileRespModel> changePassword(
    String email,
    String otp,
    String password,
    String passwordConfirmation,
    String sourceCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'source_code': sourceCode};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'email': email,
      'otp': otp,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    final _options = _setStreamType<ProfileRespModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          '/user/change/password',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProfileRespModel _value;
      _value = ProfileRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<ProfileRespModel> logout(String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ProfileRespModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/user/logout',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProfileRespModel _value;
      _value = ProfileRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<GetScheduleRespModel> getSchedule(String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetScheduleRespModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/get/all/service',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetScheduleRespModel _value;
      _value = GetScheduleRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<CreateScheduleRespModel> createSchedule(
    String description,
    String vehicle_vin,
    String schedule_type,
    String start_date,
    String number_kilometer,
    String number_time,
    String category_time,
    String number_hour,
    String reminder_advance_days,
    String reminder_advance_hr,
    String reminder_advance_km,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'description': description,
      'vehicle_vin': vehicle_vin,
      'schedule_type': schedule_type,
      'start_date': start_date,
      'number_kilometer': number_kilometer,
      'number_time': number_time,
      'category_time': category_time,
      'number_hour': number_hour,
      'reminder_advance_days': reminder_advance_days,
      'reminder_advance_hr': reminder_advance_hr,
      'reminder_advance_km': reminder_advance_km,
    };
    final _options = _setStreamType<CreateScheduleRespModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          '/schedule/service',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CreateScheduleRespModel _value;
      _value = CreateScheduleRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<ProfileVehicleRespModel> getAllVehicles(
    String token,
    String contentType,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'Accept': contentType,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ProfileVehicleRespModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/view/vehicle',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ProfileVehicleRespModel _value;
      _value = ProfileVehicleRespModel.fromJson(_result.data!);
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
