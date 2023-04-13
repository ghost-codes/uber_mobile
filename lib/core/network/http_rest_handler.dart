import 'package:dio/dio.dart';
import 'package:uber_mobile/core/network/http_client.dart';
import 'package:uber_mobile/core/network/http_response.dart';

class ApiRestHandler {
  final HttpClient _httpClient;

  ApiRestHandler({required HttpClient httpClient}) : _httpClient = httpClient;

  Future<HttpResponse> getDataWithNoQuery(String path) async {
    final response = await _httpClient.execute(path: path, method: "GET");
    return response;
  }

  Future<HttpResponse> getData(String path, Map<String, dynamic> queryParams) async {
    final response = await _httpClient.execute(
      path: path,
      method: "GET",
      query: queryParams,
    );
    return response;
  }

  Future<HttpResponse> postData(String path, Map<String, dynamic> data) async {
    final response = await _httpClient.execute(
      method: "POST",
      path: path,
      data: data,
    );
    return response;
  }

  Future<HttpResponse> postImage(String path, FormData data) async {
    final response = await _httpClient.execute(
      method: "POST",
      path: path,
      data: data,
      contentType: "multipart/form-data",
    );
    return response;
  }

  Future<HttpResponse> putData(String path, Map<String, dynamic> data) async {
    final response = await _httpClient.execute(
      method: "PUT",
      path: path,
      data: data,
    );
    return response;
  }

  Future<HttpResponse> deleteData(String path, Map<String, dynamic> data) async {
    final response = await _httpClient.execute(
      method: "DELETE",
      path: path,
    );
    return response;
  }
}
