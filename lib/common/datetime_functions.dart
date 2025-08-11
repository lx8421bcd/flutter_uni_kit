import 'package:intl/intl.dart';

// 用于运算的以毫秒计数的时间单位
const int msSecond = 1000;
const int msMinute = msSecond * 60;
const int msHour = msMinute * 60;
const int msDay = msHour * 24;
// 用于运算的以秒计数的时间单位
const int secMinute = 60;
const int secHour = secMinute * 60;
const int secDay = secHour * 24;

/// 获取今日0点的DateTime对象
DateTime getZeroTimeOfToday() {
  var now = DateTime.now();
  return DateTime(
      now.year,
      now.month,
      now.day,
      0,
      0,
      0,
      0,
      0);
}

/// 计算给定年、月的最大天数
/// 通过拿到下月1号的前一天是几号得出
int maxDaysOfMonth({
  required int year,
  required int month
}) {
  if (month < 1 || month > 12) {
    return -1;
  }
  year = year != 0 ? year : DateTime
      .now()
      .year;
  var dayCount = DateTime(year, month + 1, 0).day;
  return dayCount;
}

/// 将给定时间日期字符串转换为DateTime对象
///
/// [format] 日期字符串格式，默认为 yyyy-MM-dd HH:mm:ss <br/>
/// [locale] 时区/地区，默认为当前地区
DateTime dateStringToDateTime(String dateString, {
  String format = "yyyy-MM-dd HH:mm:ss",
  String? locale
}) {
  return DateFormat(format, locale).parse(dateString);
}

/// 毫秒转时间字符串
/// [format] 日期字符串格式，默认为 yyyy-MM-dd HH:mm:ss <br/>
/// [timeMs] 时间
String timeMsToDateString({
  required int timeMs,
  String format = "yyyy-MM-dd HH:mm:ss",
}) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(timeMs);
  return DateFormat(format).format(dateTime);
}

/// 秒转时间字符串
/// [format] 日期字符串格式，默认为 yyyy-MM-dd HH:mm:ss <br/>
/// [timeSec] 时间
String timeSecToDateString({
  required int timeSec,
  String format = "yyyy-MM-dd HH:mm:ss",
}) {
  return timeMsToDateString(timeMs: timeSec * 1000);
}

/// 给丁出生日期和成年年龄，判断是否成年
bool isAdult({
  required DateTime birthDate,
  int adultAge = 18,
}) {
  final currentDate = DateTime.now();
  final age = currentDate.year - birthDate.year;
  final isBeforeBirthdayThisYear = (currentDate.month < birthDate.month) ||
      (currentDate.month == birthDate.month && currentDate.day < birthDate.day);

  if (isBeforeBirthdayThisYear) {
    return age > adultAge;
  }
  return age >= adultAge;
}