import 'package:intl/intl.dart';
import 'package:universities_map/view/settings_page/view_settings.dart';

final DateFormat _dayFormatterDayFirst = DateFormat("dd/MM/yyyy");
final DateFormat _dayFormatterMonthFirst = DateFormat("MM/dd/yyyy");

DateFormat get dateFormatter =>
    viewSettings.getPropertyValue<bool>(
      ViewSettings.displayMonthBeforeDayProperty,
    )
    ? _dayFormatterMonthFirst
    : _dayFormatterDayFirst;

final timeFormatterTwentyFourHour = DateFormat('HH:mm');
final timeFormatterTwelveHour = DateFormat('h:mm a');

DateFormat get timeFormatter =>
    viewSettings.getPropertyValue<bool>(ViewSettings.use24HoursProperty)
    ? timeFormatterTwentyFourHour
    : timeFormatterTwelveHour;
