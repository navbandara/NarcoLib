/// Utility to handle human-readable DateTime formatting.
class DateFormatter {
  /// Formats a DateTime object into a standard string presentation.
  /// Example output: "2026-06-27 18:36"
  static String formatToDateTime(DateTime dateTime) {
    // TODO: Connect the intl package or construct direct formatting blocks.
    return dateTime.toIso8601String();
  }

  /// Calculates elapsed duration and outputs relative string labels.
  /// Example: "5 mins ago", "2 hours ago", "yesterday"
  static String formatToRelativeTime(DateTime dateTime) {
    // TODO: Compare timestamp against DateTime.now() and translate difference.
    return 'Just now';
  }
}
