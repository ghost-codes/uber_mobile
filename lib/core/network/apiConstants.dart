class ApiConstants {
  static const String API_URL = "http://localhost:8080/graphql";
  static String PLACES_API(String input, String lang, String apiKey, String sessionToken) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&key=$apiKey&sessiontoken=$sessionToken';
}
