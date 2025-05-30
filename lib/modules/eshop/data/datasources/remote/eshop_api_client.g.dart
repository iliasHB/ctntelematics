// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eshop_api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _EshopApiClient implements EshopApiClient {
  _EshopApiClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://ecom.verifycentre.com/api';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<GetAllProductModel> getProducts(
    String token,
    String sourceCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'source_code': sourceCode,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetAllProductModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/products',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetAllProductModel _value;
    _value = GetAllProductModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<GetCategoryModel> getCategory(String token) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': token};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetCategoryModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/categories',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetCategoryModel _value;
    _value = GetCategoryModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<GetProductModel> getProduct(
    int id,
    String token,
    String sourceCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': token,
      r'source_code': sourceCode,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetProductModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/products/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetProductModel _value;
    _value = GetProductModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<GetPaymentRespModel> initiatePayment(
    String email,
    String contact_phone,
    String delivery_address,
    String quantity,
    String product_id,
    String location_id,
    String sourceCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'source_code': sourceCode};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'email': email,
      'contact_phone': contact_phone,
      'delivery_address': delivery_address,
      'quantity': quantity,
      'product_id': product_id,
      'location_id': location_id,
    };
    final _options = _setStreamType<GetPaymentRespModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          '/payment/initiate',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetPaymentRespModel _value;
      _value = GetPaymentRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<ConfirmPaymentRespModel> confirmPayment(
    String reference,
    String sourceCode,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'source_code': sourceCode};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'reference': reference};
    final _options = _setStreamType<ConfirmPaymentRespModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          '/payment/confirm',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ConfirmPaymentRespModel _value;
      _value = ConfirmPaymentRespModel.fromJson(_result.data!);
    return _value;
  }

  @override
  Future<DeliveryLocationRespModel> getDeliveryLocation(
      String sourceCode) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'source_code': sourceCode};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<DeliveryLocationRespModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/delivery/location',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DeliveryLocationRespModel _value;
      _value = DeliveryLocationRespModel.fromJson(_result.data!);
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
