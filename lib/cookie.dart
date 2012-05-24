#library('cookie');

#import('dart:json');

class Cookie {
  static String stringify(Map options) {
    if (options['value'] is Map) {
      options['value'] = 'j:' + JSON.stringify(options['value']);
    }
    var pairs = ["${options['name']}=${options['value']}"];

    if (options.containsKey('domain')) {
      pairs.add("domain=${options['domain']}");
    }
    if (!options.containsKey('path')) {
      options['path'] = '/';
    }
    pairs.add("path=${options['path']}");
    if (options.containsKey('expires')) {
      pairs.add("expires=${options['expires']}");
    }
    if (options.containsKey('max-age')) {
      String expires = stringifyDate(new Date.now().add(new Duration(seconds:options['max-age'])));
      pairs.add("expires=${expires}");
    }
    if (options.containsKey('httpOnly')) {
      pairs.add('httpOnly');
    }
    if (options.containsKey('secure')) {
      pairs.add('secure');
    }
    return Strings.join(pairs, '; ');
  }

  static Map parse(String cookie) {
    Map cookies = {};
    List pairs = cookie.split(';');
    pairs.forEach((pair) {
      int eqIndex = pair.indexOf('=');
      String key = pair.substring(0, eqIndex).trim();
      String value = pair.substring(eqIndex+1).trim();
      cookies[key] = value;
    });
    return cookies;
  }

  static String stringifyDate(Date date) {
    String weekday = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][date.weekday];
    String month = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Now','Dec'][date.month-1];
    String hour = ('00' + date.hours);
    hour = hour.substring(hour.length-2);
    String minute = ('00' + date.minutes);
    minute = minute.substring(minute.length-2);
    String second = ('00' + date.seconds);
    second = second.substring(second.length-2);
    return "${weekday}, ${date.day}-${month}-${date.year} ${hour}:${minute}:${second} UTC";
  }
}
