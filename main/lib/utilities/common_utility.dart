import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class CommonUtility {
  static void copy(String text, {String? message, bool withNotification = true}) {
    try {
      final data = ClipboardData(text: text);
      Clipboard.setData(data);

      if(withNotification) {
        notify.info(message: message ?? "Copied");
      }
    } on Exception catch (e) {
      if(withNotification) {
        notify.error(message: e.toString());
      }
    }
  }

  static int increment(int value) {
    return value + 1;
  }

  static int decrement(int value) {
    return value - 1;
  }

  static String getAmount(String amount) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
    );
    if(double.tryParse(amount) != null) {
      return currencyFormatter.format(double.parse(amount));
    } else if(int.tryParse(amount) != null) {
      return currencyFormatter.format(int.parse(amount));
    } else if(num.tryParse(amount) != null) {
      return currencyFormatter.format(num.parse(amount));
    } else {
      return amount;
    }
  }

  static String capitalizeWords(String input) {
    if (input.isEmpty) {
      return input;
    }

    List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        words[i] = '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
      }
    }

    return words.join(' ');
  }

  static void unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static StreamSubscription<dynamic> fetch({required Function action, int durationInSeconds = 10}) {
    return Stream.periodic(Duration(seconds: durationInSeconds)).listen((_) {
      Future<void>.delayed(const Duration(milliseconds: 500), () async {
        action.call();
      });
    });
  }

  static String textWithAorAn(String text) {
    if(text.startsWith(RegExp('[aeiouAEIOU]'))) {
      return "an ${text.toLowerCase()}";
    } else {
      return "a ${text.toLowerCase()}";
    }
  }

  static bool hasEmojis(String text) {
    final emojiRegExp = RegExp(
      // Range of Unicode characters that represent emojis
      r'[\u{1F600}-\u{1F64F}' // Emoticons
      r'\u{1F300}-\u{1F5FF}' // Miscellaneous Symbols and Pictographs
      r'\u{1F680}-\u{1F6FF}' // Transport and Map Symbols
      r'\u{2600}-\u{26FF}' // Miscellaneous Symbols
      r'\u{2700}-\u{27BF}' // Dingbats
      r'\u{1F900}-\u{1F9FF}' // Supplemental Symbols and Pictographs
      r'\u{1F1E0}-\u{1F1FF}' // Flags (iOS flags are represented by two characters)
      ']+',
      unicode: true,
    );

    return emojiRegExp.hasMatch(text);
  }

  static bool containsOnlyEmojis(String text) {
    // Regular expression pattern to match emojis
    final emojiPattern = RegExp(
      r'[^\x00-\x7F]|(?:[.]{3})|[\uD83C-\uD83E][\uDDE0-\uDDFF]|[\uD83C-\uD83E][\uDC00-\uDFFF]'
      '|[\uD83F-\uD87F][\uDC00-\uDFFF]|[\u2600-\u26FF]|[\u2700-\u27BF]'
    );

    // Remove all emojis from the text and check if any non-emoji characters are left
    final textWithoutEmojis = text.replaceAll(emojiPattern, '');
    return textWithoutEmojis.isEmpty;
  }

  static bool containsOnlyOneEmoji(String text) {
    // Regular expression pattern to match emojis
    final emojiPattern = RegExp(
      r'[^\x00-\x7F]|(?:[.]{3})|[\uD83C-\uD83E][\uDDE0-\uDDFF]|[\uD83C-\uD83E]'
      '[\uDC00-\uDFFF]|[\uD83F-\uD87F][\uDC00-\uDFFF]|[\u2600-\u26FF]|[\u2700-\u27BF]'
    );

    // Remove all emojis from the text and check if any non-emoji characters are left
    final textWithoutEmojis = text.replaceAll(emojiPattern, '');

    // Check if there is only one emoji left and no other characters
    return textWithoutEmojis.isEmpty && emojiPattern.allMatches(text).length == 1;
  }

  static String formatTime(DateTime dateTime) {
    // You can customize this function to format the time part as needed
    return DateFormat('h:mm a').format(dateTime);
  }

  static String formatDay(DateTime? dateTime, {bool showTime = true}) {
    if (dateTime != null) {
      DateTime currentDateTime = DateTime.now();

      if(showTime) {
        if (isSameDate(dateTime, currentDateTime)) {
          return 'Today, ${formatTime(dateTime)}';
        } else if (isSameDate(dateTime, currentDateTime.subtract(const Duration(days: 1)))) {
          return 'Yesterday, ${formatTime(dateTime)}';
        } else {
          DateFormat formatter = DateFormat('EEEE, d MMMM yyyy');
          return formatter.format(dateTime);
        }
      } else {
        DateFormat formatter = DateFormat('EEEE, d MMMM yyyy');
        return formatter.format(dateTime);
      }
    } else {
      return '';
    }
  }

  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static Color lightenColor(Color color, double percent) {
    assert(0 <= percent && percent <= 100, 'Percent must be between 0 and 100');

    HSLColor hsl = HSLColor.fromColor(color);
    double lightness = (hsl.lightness + percent / 100).clamp(0.0, 1.0);

    // Return a new color with the adjusted lightness
    return hsl.withLightness(lightness).toColor();
  }

  static List<int> generateList(int count) {
    return List.generate(count, (index) => index);
  }

  static String formatAudioTimer(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  static DateTime parseScheduleTime(String time) {
    // Get the current date
    DateTime now = DateTime.now();

    // Parse the time string using DateFormat
    DateFormat timeFormat = DateFormat.jm(); // 'jm' for "9:00 AM"
    DateTime parsedTime = timeFormat.parse(time.toUpperCase());

    // Combine the parsed time with the current date
    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  }
}