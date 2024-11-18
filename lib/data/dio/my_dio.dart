// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:prueba_tecnica/config/constants/environment.dart';

part "interceptors.dart";

enum RequestType {
  GET,
  POST,
  PUT,
  DELETE,
  PATCH,
}

enum APIVersion {
  V1,
  V2,
}

class MyDio {
  final Dio _dio = Dio();

  MyDio() {
    _dio.options.baseUrl = Environment.baseUrl;
    // _dio.interceptors.add(CustomInterceptors(""));
  }

  // void updateToken(String token) {
  //   _dio.interceptors.clear();
  //   _dio.interceptors.add(CustomInterceptors(token));
  // }

  Future<dynamic> request({
    required RequestType requestType,
    required String path,
    bool requiresAuth = true,
    bool requiresDefaultParams = true,
    String? port,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    try {
      // if(requiresAuth) add token
      Response<dynamic> response;
      switch (requestType) {
        case RequestType.GET:
          response = await _dio.get(path, queryParameters: queryParameters);
          break;
        case RequestType.POST:
          response = await _dio.post(path, data: data);
          break;
        case RequestType.PATCH:
          response = await _dio.patch(path, data: data);
          break;
        case RequestType.DELETE:
          response = await _dio.delete(path);
          break;
        case RequestType.PUT:
          response = await _dio.put(path, data: data);
          break;
        default:
          throw "Request type not found";
      }
      return (response.data is String &&
              (((response.data).toString()).startsWith("{") ||
                  ((response.data).toString()).startsWith("[")))
          ? jsonDecode(response.data)
          : (((response.data).toString()).startsWith("{") ||
                  ((response.data).toString()).startsWith("["))
              ? response.data
              : {"status": response.statusCode};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      throw CustomDioError(
          code: e.response?.statusCode ?? 400,
          message: e.message,
          data: e.response?.data);
    }
  }

  Future<dynamic> requestMultipart(
      {required RequestType requestType,
      required String path,
      bool requiresAuth = true,
      bool requiresDefaultParams = true,
      bool requiredResponse = true,
      String? port,
      Map<String, dynamic>? queryParameters,
      FormData? data,
      Options? options}) async {
    try {
      // if(requiresAuth) add token
      // final options = Options(headers: {
      //   "Access-Control-Allow-Methods": "*",
      //   "Content-Type": "multipart/form-data"
      // });
      Response<dynamic> response;
      switch (requestType) {
        case RequestType.POST:
          response = await _dio.post(path, data: data);
          // response = await _dio.post(path, data: data, options: options);
          break;
        case RequestType.PATCH:
          response = await _dio.patch(path, data: data);
          // response = await _dio.patch(path, data: data, options: options);
          break;
        case RequestType.PUT:
          response = await _dio.put(path, data: data);
          // response = await _dio.put(path, data: data, options: options);
          break;
        default:
          throw "Request type not found";
      }
      if (!requiredResponse) return;
      return (response.data is String)
          ? jsonDecode(response.data)
          : response.data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("DioException: ${e.message}");
      }
      throw CustomDioError(
          code: e.response?.statusCode ?? 400,
          message: e.message,
          data: e.response?.data);
    }
  }
}

class CustomDioError extends Error {
  final int code;
  final String? message;
  final dynamic data;

  CustomDioError({
    required this.code,
    this.message,
    this.data,
  });

  @override
  String toString() =>
      'CustomDioError(code: $code, message: $message, data: $data)';
}
