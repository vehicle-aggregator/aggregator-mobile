
import 'package:intl/intl.dart';


abstract class DateTimeHelper{
  static String getTime(DateTime date){
    return (DateFormat('HH:mm').format(date));
  }

  static String getDuration(int minutes){
    return '${minutes ~/ 60} ч ${minutes % 60} м';
  }
}