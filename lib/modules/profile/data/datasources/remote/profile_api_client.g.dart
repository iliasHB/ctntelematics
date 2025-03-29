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
    baseUrl ??= 'http://196.3.101.150:8080/api';//'https://cti.maypaseducation.com/api';
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
    String password_confirmation,
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
      'password_confirmation': password_confirmation,
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

  @override
  Future<List<GetScheduleNoticeRespModel>> getScheduleNotice(
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
    final _options = _setStreamType<List<GetScheduleNoticeRespModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/get/notice',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<GetScheduleNoticeRespModel> _value;
      _value = _result.data!
          .map((dynamic i) =>
              GetScheduleNoticeRespModel.fromJson(i as Map<String, dynamic>))
          .toList();
    return _value;
  }

  @override
  Future<CompleteScheduleRespModel> completeSchedule(
    String vehicle_vin,
    String schedule_id,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'vehicle_vin': vehicle_vin,
      'schedule_id': schedule_id,
    };
    final _options = _setStreamType<CompleteScheduleRespModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/schedule/complete',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CompleteScheduleRespModel _value;
      _value = CompleteScheduleRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<GetScheduleNoticeRespModel> getSingleScheduleNotice(
    String vehicle_vin,
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
    final _data = {'vehicle_vin': vehicle_vin};
    final _options = _setStreamType<GetScheduleNoticeRespModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/get/notice/single',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetScheduleNoticeRespModel _value;
      _value = GetScheduleNoticeRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<ExpensesRespModel> getExpenses(
    String from,
    String to,
    String token,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'from': from,
      r'to': to,
    };
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<ExpensesRespModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/expenses',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ExpensesRespModel _value;
      _value = ExpensesRespModel.fromJson(_result.data!);
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
