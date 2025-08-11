import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/widgets/wheel_view.dart';

typedef TimeSelectCallback = void Function(DateTime selected);

typedef DateTimeItemBuilder = Widget Function(BuildContext context, int dateTime, bool selected);

enum WheelDateTimePickerMode {
  dateAndTime,
  date,
  time,
  monthYear,
  dayMonth,
  hourMinute,
  minuteSecond,
  year,
  month,
  day,
  hour,
  minute,
  second,
}

class WheelDateTimePicker extends StatefulWidget {

  static const defaultItemTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static const defaultItemSelectedTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static DateTimeItemBuilder get defaultDateItemBuilder => (context, dateTime, selected) {
    var textStyle = selected ? defaultItemSelectedTextStyle : defaultItemTextStyle;
    return Text(dateTime.toString(), style: textStyle);
  };

  static DateTimeItemBuilder get defaultTimeItemBuilder => (context, dateTime, selected) {
    var textStyle = selected ? defaultItemSelectedTextStyle : defaultItemTextStyle;
    return Text(dateTime.toString().padLeft(2, '0'), style: textStyle);
  };


  final double width;
  final double height;
  final WheelDateTimePickerMode mode;
  final DateTime? selectedDateTime;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;
  final double itemHeight;
  final TextStyle itemTextStyle;
  final Widget? wheelIndicator;
  final TimeSelectCallback? onDateTimeSelected;

  final DateTimeItemBuilder? yearBuilder;
  final DateTimeItemBuilder? monthBuilder;
  final DateTimeItemBuilder? dayBuilder;
  final DateTimeItemBuilder? hourBuilder;
  final DateTimeItemBuilder? minuteBuilder;
  final DateTimeItemBuilder? secondBuilder;

  const WheelDateTimePicker({
    super.key,
    this.width = double.infinity,
    this.height = 280,
    this.mode = WheelDateTimePickerMode.date,
    this.selectedDateTime,
    this.minDateTime,
    this.maxDateTime,
    this.itemHeight = 50,
    this.itemTextStyle = defaultItemTextStyle,
    this.wheelIndicator,
    this.onDateTimeSelected,
    this.yearBuilder,
    this.monthBuilder,
    this.dayBuilder,
    this.hourBuilder,
    this.minuteBuilder,
    this.secondBuilder,
  });

  @override
  State<WheelDateTimePicker> createState() => _WheelDateTimePickerState();
}

class _WheelDateTimePickerState extends State<WheelDateTimePicker> {

  final years = <int>[];
  final months = <int>[];
  final days = <int>[];
  final hours = <int>[];
  final minutes = <int>[];
  final seconds = <int>[];

  int selectedYear = 0;
  int selectedMonth = 0;
  int selectedDay = 0;
  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSecond = 0;

  @override
  void initState() {
    var selectedDateTime = widget.selectedDateTime ?? DateTime.now();
    selectedYear = selectedDateTime.year;
    selectedMonth = selectedDateTime.month;
    selectedDay = selectedDateTime.day;
    selectedHour = selectedDateTime.hour;
    selectedMinute = selectedDateTime.minute;
    selectedSecond = selectedDateTime.second;
    _updateYear();
    _updateMonth();
    _updateDay();
    _updateHours();
    _updateMinutes();
    _updateSeconds();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var wheelList = <Widget>[];
    addDateTimeWheel({
      required List<int> list,
      required int selectedDateTime,
      required void Function(int selected) onSelected,
      required DateTimeItemBuilder itemBuilder,
    }) {
      wheelList.add(Expanded(
          child: WheelView(
            indicator: widget.wheelIndicator,
            initialItem: list.indexOf(selectedDateTime),
            onSelectedItemChanged: (index) {
              onSelected.call(list[index]);
              _updateMonth();
              _updateDay();
              _updateHours();
              _updateMinutes();
              _updateSeconds();
              setState(() {
                widget.onDateTimeSelected?.call(DateTime(
                    selectedYear,
                    selectedMonth,
                    selectedDay,
                    selectedHour,
                    selectedMinute,
                    selectedSecond
                ));
              });
            },
            children: list.map((dateTime) {
              bool selected = dateTime == selectedDateTime;
              return Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: itemBuilder.call(context, dateTime, selected),
              );
            }).toList(),
          )
      ));
    }
    if ([
      WheelDateTimePickerMode.dateAndTime,
      WheelDateTimePickerMode.date,
      WheelDateTimePickerMode.monthYear,
      WheelDateTimePickerMode.year,
    ].contains(widget.mode)) {
      addDateTimeWheel(
          list: years,
          selectedDateTime: selectedYear,
          itemBuilder: widget.yearBuilder ?? WheelDateTimePicker.defaultDateItemBuilder,
          onSelected: (selected) { selectedYear = selected; }
      );
    }
    if ([
      WheelDateTimePickerMode.dateAndTime,
      WheelDateTimePickerMode.date,
      WheelDateTimePickerMode.monthYear,
      WheelDateTimePickerMode.dayMonth,
      WheelDateTimePickerMode.month,
    ].contains(widget.mode)) {
      addDateTimeWheel(
          list: months,
          selectedDateTime: selectedMonth,
          itemBuilder: widget.monthBuilder ?? WheelDateTimePicker.defaultDateItemBuilder,
          onSelected: (selected) {selectedMonth = selected;}
      );
    }
    if ([
      WheelDateTimePickerMode.dateAndTime,
      WheelDateTimePickerMode.date,
      WheelDateTimePickerMode.dayMonth,
      WheelDateTimePickerMode.day,
    ].contains(widget.mode)) {
      addDateTimeWheel(
          list: days,
          selectedDateTime: selectedDay,
          itemBuilder: widget.dayBuilder ?? WheelDateTimePicker.defaultDateItemBuilder,
          onSelected: (selected) {selectedDay = selected;}
      );
    }
    if ([
      WheelDateTimePickerMode.dateAndTime,
      WheelDateTimePickerMode.time,
      WheelDateTimePickerMode.hourMinute,
      WheelDateTimePickerMode.hour,
    ].contains(widget.mode)) {
      addDateTimeWheel(
          list: hours,
          selectedDateTime: selectedHour,
          itemBuilder: widget.hourBuilder ?? WheelDateTimePicker.defaultTimeItemBuilder,
          onSelected: (selected) {selectedHour = selected;}
      );
    }
    if ([
      WheelDateTimePickerMode.dateAndTime,
      WheelDateTimePickerMode.time,
      WheelDateTimePickerMode.hourMinute,
      WheelDateTimePickerMode.minuteSecond,
      WheelDateTimePickerMode.minute,
    ].contains(widget.mode)) {
      addDateTimeWheel(
          list: minutes,
          selectedDateTime: selectedMinute,
          itemBuilder: widget.minuteBuilder ?? WheelDateTimePicker.defaultTimeItemBuilder,
          onSelected: (selected) {selectedMinute = selected;}
      );
    }
    if ([
      WheelDateTimePickerMode.dateAndTime,
      WheelDateTimePickerMode.time,
      WheelDateTimePickerMode.minuteSecond,
      WheelDateTimePickerMode.second,
    ].contains(widget.mode)) {
      addDateTimeWheel(
          list: seconds,
          selectedDateTime: selectedSecond,
          itemBuilder: widget.secondBuilder ?? WheelDateTimePicker.defaultTimeItemBuilder,
          onSelected: (selected) {selectedSecond = selected;}
      );
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(children: wheelList),
    );
  }

  void _updateYear() {
    var yearStart = widget.minDateTime?.year ?? 1900;
    var yearEnd = widget.maxDateTime?.year ?? 2100;
    yearStart = min(yearStart, yearEnd);
    yearEnd = max(yearStart, yearEnd);
    years.clear();
    for (var year = yearStart; year <= yearEnd; year++) {
      years.add(year);
    }
    var yearCurrent = DateTime.now().year;
    if (selectedYear == 0) {
      selectedYear = yearCurrent;
    }
    if (!years.contains(selectedYear)) {
      var startToCurrent = (yearCurrent - yearStart).abs();
      var endToCurrent = (yearCurrent - yearEnd).abs();
      selectedYear = startToCurrent < endToCurrent ? yearStart : yearEnd;
    }
  }

  void _updateMonth() {
    if (selectedYear == 0 || years.isEmpty) {
      _updateYear();
    }
    var monthStart = 1;
    var monthEnd = 12;
    if (selectedYear == years.first) {
      monthStart = widget.minDateTime?.month ?? 1;
    }
    if (selectedYear == years.last) {
      monthEnd = widget.maxDateTime?.month ?? 12;
    }
    months.clear();
    for (var month = monthStart; month <= monthEnd; month++) {
      months.add(month);
    }
    selectedMonth = months.contains(selectedMonth) ? selectedMonth : months.first;
  }

  void _updateDay() {
    if (selectedMonth == 0 || months.isEmpty) {
      _updateMonth();
    }
    var maxDayOfMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    var dayStart = 1;
    var dayEnd = maxDayOfMonth;

    if (selectedYear == years.first && selectedMonth == months.first) {
      dayStart = widget.minDateTime?.day ?? 1;
    }
    if (selectedYear == years.last && selectedMonth == months.last) {
      dayEnd = widget.maxDateTime?.day ?? maxDayOfMonth;
    }
    days.clear();
    for (var day = dayStart; day <= dayEnd; day++) {
      days.add(day);
    }
    selectedDay = days.contains(selectedDay) ? selectedDay : days.first;
  }

  void _updateHours() {
    if (selectedDay == 0 || days.isEmpty) {
      _updateDay();
    }
    var hourStart = 0;
    var hourEnd = 23;
    if (selectedYear == years.first &&
        selectedMonth == months.first &&
        selectedDay == days.first
    ) {
      hourStart = widget.minDateTime?.hour ?? 0;
    }
    if (selectedYear == years.last &&
        selectedMonth == months.last &&
        selectedDay == days.last
    ) {
      hourEnd = widget.maxDateTime?.hour ?? 23;
    }
    hours.clear();
    for (var hour = hourStart; hour <= hourEnd; hour++) {
      hours.add(hour);
    }
    selectedHour = hours.contains(selectedHour) ? selectedHour : hours.first;
  }

  void _updateMinutes() {
    if (hours.isEmpty) {
      _updateHours();
    }
    var minuteStart = 0;
    var minuteEnd = 59;
    if (selectedYear == years.first &&
        selectedMonth == months.first &&
        selectedDay == days.first &&
        selectedHour == hours.first
    ) {
      minuteStart = widget.minDateTime?.minute ?? 0;
    }
    if (selectedYear == years.last &&
        selectedMonth == months.last &&
        selectedDay == days.last &&
        selectedHour == hours.last
    ) {
      minuteEnd = widget.maxDateTime?.minute ?? 59;
    }
    minutes.clear();
    for (var minute = minuteStart; minute <= minuteEnd; minute++) {
      minutes.add(minute);
    }
    selectedMinute = minutes.contains(selectedMinute) ? selectedMinute : minutes.first;
  }

  void _updateSeconds() {
    if (minutes.isEmpty) {
      _updateMinutes();
    }
    var secondStart = 0;
    var secondEnd = 59;
    if (selectedYear == years.first &&
        selectedMonth == months.first &&
        selectedDay == days.first &&
        selectedHour == hours.first &&
        selectedMinute == minutes.first
    ) {
      secondStart = widget.minDateTime?.second ?? 0;
    }
    if (selectedYear == years.last &&
        selectedMonth == months.last &&
        selectedDay == days.last &&
        selectedHour == hours.last &&
        selectedMinute == minutes.last
    ) {
      secondEnd = widget.maxDateTime?.second ?? 59;
    }
    seconds.clear();
    for (var second = secondStart; second <= secondEnd; second++) {
      seconds.add(second);
    }
    selectedSecond = seconds.contains(selectedSecond) ? selectedSecond : seconds.first;
  }
}
