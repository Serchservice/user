/// This enum represents the different types of schedule time for a user's schedule in the system.
///
///This is an enum class called ScheduleTime which defines three different types of schedule times. The three types are thirtyMinutes, twentyMinutes, and tenMinutes.
///
/// Each type has a String value that represents the time in Minutes, and it is stored in the type field.
///
/// The const constructor is used to create a new instance of the enum class and it takes in a String parameter which is used to set the type field.
enum ScheduleTime{
  /// Represents a schedule time of 30 Minutes.
  thirtyMinutes("30 min"),

  /// Represents a schedule time of 20 Minutes.
  twentyMinutes("20 min"),

  /// Represents a schedule time of 10 Minutes.
  tenMinutes("10 min");

  /// The type of the schedule time as a string.
  final String type;

  /// Constructor for the ScheduleTime enum.
  const ScheduleTime(this.type);
}

/// ConvertScheduleTimeType: This is an extension class on the String class.
///
/// on String: This specifies that the extension applies to the String class. This function converts a string to a ScheduleTime enum.
///
/// switch (this): This is a switch statement on the String object that the function is being called on.
///
/// case `30 min`: return ScheduleTime.thirtyMinutes;: This maps the string value `30 min` to the ScheduleTime.thirtyMinutes enum.
///
/// case `20 min`: return ScheduleTime.twentyMinutes;: This maps the string value `20 min` to the ScheduleTime.twentyMinutes enum.
///
/// case `10 min`: return ScheduleTime.tenMinutes;: This maps the string value `10 min` to the ScheduleTime.tenMinutes enum.
///
/// default: return ScheduleTime.thirtyMinutes;: This is the default case that maps any other string value to the ScheduleTime.thirtyMinutes enum.
/// Extension on the `String` class to convert a string to a `ScheduleTime` enum.
extension StringToScheduleTime on String {
  /// Convert a string to a `ScheduleTime` enum.
  ScheduleTime toScheduleTime() {
    switch (this) {
      case "30 min":
        return ScheduleTime.thirtyMinutes;
      case "20 min":
        return ScheduleTime.twentyMinutes;
      case "10 min":
        return ScheduleTime.tenMinutes;
      default:
        return ScheduleTime.thirtyMinutes;
    }
  }
}