class UserDataFormatter {
  static Map<String, dynamic> extractValues(String token) {
    // removing curly braces
    String tokenData = token.replaceAll('{', '').replaceAll('}', '');

    // splitting token into individual key-value pairs
    List<String> keyValuePairs = tokenData.split(',');

    // creating a map to store the extracted values
    Map<String, dynamic> extractedData = {};

    // extracting the values from each key-value pair
    for (String pair in keyValuePairs) {
      // splitting the pair into key and value
      List<String> parts = pair.split(':');

      // removing leading and trailing whitespaces from the key and value
      String key = parts[0].trim();
      String value = parts[1].trim();

      // removing any leading or trailing quotation marks from the value
      if (value.startsWith("'") && value.endsWith("'")) {
        value = value.substring(1, value.length - 1);
      }

      // storing the key-value pair in the extracted data map
      extractedData[key] = value;
    }
    return extractedData;
  }
}
