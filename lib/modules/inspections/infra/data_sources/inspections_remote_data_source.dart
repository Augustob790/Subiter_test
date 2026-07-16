import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../../../../core/errors/app_exception.dart';
import '../data_models/inspection_data_model.dart';

abstract interface class InspectionsRemoteDataSource {
  Future<List<InspectionDataModel>> getInspections();
}

class JsonInspectionsRemoteDataSource implements InspectionsRemoteDataSource {
  const JsonInspectionsRemoteDataSource(this._assetBundle, {this.assetPath = 'assets/mocks/inspections.json'});

  final AssetBundle _assetBundle;
  final String assetPath;

  @override
  Future<List<InspectionDataModel>> getInspections() async {
    try {
      final String source = await _assetBundle.loadString(assetPath);
      final Object? decoded = jsonDecode(source);
      if (decoded is! Map<String, dynamic>) throw const DataException();

      final Object? statusCode = decoded['statusCode'];
      if (statusCode is! int || statusCode < 200 || statusCode >= 300) {
        throw DataException('Resposta simulada retornou status $statusCode.');
      }

      final Object? data = decoded['data'];
      if (data is! Map<String, dynamic>) throw const DataException();
      final Object? inspections = data['inspections'];
      if (inspections is! List<dynamic>) throw const DataException();

      return inspections
          .map((Object? item) {
            if (item is! Map<String, dynamic>) throw const DataException();
            return InspectionDataModel.fromJson(item);
          })
          .toList(growable: false);
    } on AppException {
      rethrow;
    } on FormatException {
      throw const DataException('JSON de inspeções inválido.');
    } on Object {
      throw const DataException('Não foi possível ler a API simulada.');
    }
  }
}

class DioInspectionsRemoteDataSource implements InspectionsRemoteDataSource {
  const DioInspectionsRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<InspectionDataModel>> getInspections() async {
    try {
      final Response<dynamic> response = await _dio.get('/inspections');

      final Object? data = response.data;
      if (data is! Map<String, dynamic>) throw const DataException();

      final Object? statusCode = data['statusCode'];
      if (statusCode is! int || statusCode < 200 || statusCode >= 300) {
        throw DataException('Resposta simulada retornou status $statusCode.');
      }

      final Object? responseData = data['data'];
      if (responseData is! Map<String, dynamic>) throw const DataException();

      final Object? inspections = responseData['inspections'];
      if (inspections is! List<dynamic>) throw const DataException();

      return inspections
          .map((Object? item) {
            if (item is! Map<String, dynamic>) throw const DataException();
            return InspectionDataModel.fromJson(item);
          })
          .toList(growable: false);
    } on DioException catch (e) {
      throw DataException('Erro na requisição da API: ${e.message}');
    } on AppException {
      rethrow;
    } on Object {
      throw const DataException('Não foi possível ler a API simulada.');
    }
  }
}
