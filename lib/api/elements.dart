class APIElements{
  static Map<String, String> headers(String token) => {
    'accept': 'application/json',
    'Authorization':'Bearer $token'
  };
}