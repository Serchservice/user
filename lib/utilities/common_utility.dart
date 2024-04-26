import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:user/library.dart';

class CommonUtility {
  static void copy(String text, {String? message}) {
    try {
      final data = ClipboardData(text: text);
      Clipboard.setData(data);
      SnackBars.top(message: message ?? "Copied", type: Snackbar.info);
    } on Exception catch (e) {
      SnackBars.top(message: e.toString(), type: Snackbar.error,);
    }
  }

  static String greeting(String? data) {
    var hour = DateTime.now().hour;
    if(hour < 12) {
      return 'Good Morning, ${data ?? ""}';
    }
    if(hour < 16) {
      return 'Good Afternoon, ${data ?? ""}';
    }
    if(hour < 20) {
      return 'Good Evening, ${data ?? ""}';
    }
    return 'Got any fixing issue, ${data ?? ""}';
  }

  static String statements() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'What provider can we get for you?';
    }
    if (hour < 16) {
      return 'Sunny or rainy, we always got your back.';
    }
    if(hour < 20) {
      return 'While the moon is out, we never say bye!';
    }
    return 'Service made easy whenever you need it.';
  }

  static String getAmount(String amount) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
    );
    if(amount.isNotEmpty && amount is double) {
      return currencyFormatter.format(double.parse(amount));
    } else if(amount.isNotEmpty) {
      return "₦$amount";
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
}