class HttpResponse {
  bool isSuccessful;
  String? errorMessage;
  dynamic data;

  HttpResponse({this.isSuccessful = false, this.errorMessage, this.data});
}
