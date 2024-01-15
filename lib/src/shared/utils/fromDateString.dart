String fromDateStringToIsoString(String dateString) {
  final date = dateString.split("/");
  final day = int.parse(date[0]);
  final month = int.parse(date[1]);
  final year = int.parse(date[2]);
  return DateTime(year, month, day).toIso8601String();
}
