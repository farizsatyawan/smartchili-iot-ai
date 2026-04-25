class DateFormatter {
  DateFormatter._();

  static String formatWIB(DateTime dateTime) {
    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  static String formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  static String formatChartLabel(int hourIndex) {
    return '${hourIndex.toString().padLeft(2, '0')}:00';
  }

  static String formatFromIso(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return formatWIB(dateTime);
    } catch (e) {
      return '-';
    }
  }
}