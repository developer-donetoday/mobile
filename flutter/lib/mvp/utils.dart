class DateTimeFormatter {
  static String format(DateTime dateTime) {
    // Format the DateTime into a user-friendly string

    return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
  }

  static String formatWithTime(DateTime dateTime) {
    // Format the DateTime into a user-friendly string
    int hour = dateTime.hour % 12;
    if (hour == 0) {
      hour = 12;
    }
    return "${dateTime.month}/${dateTime.day}/${dateTime.year} $hour:${dateTime.minute.toString().padLeft(2, "0")} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }
}
