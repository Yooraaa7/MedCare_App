class TimeRange {
  final String open;
  final String close;

  const TimeRange({required this.open, required this.close});

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    return TimeRange(
      open: json['open'] as String,
      close: json['close'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'open': open,
    'close': close,
  };
}

class WorkDay {
  final String dayOfWeek;
  final List<TimeRange> shifts;
  final bool isClosed;

  const WorkDay({
    required this.dayOfWeek,
    this.shifts = const [],
    this.isClosed = false,
  });

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    return WorkDay(
      dayOfWeek: json['dayOfWeek'] as String,
      isClosed: json['isClosed'] as bool? ?? false,
      // Map the list of shifts into TimeRange objects
      shifts: (json['shifts'] as List<dynamic>?)
        ?.map((e) => TimeRange.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'dayOfWeek': dayOfWeek,
    'isClosed': isClosed,
    'shifts': shifts.map((e) => e.toJson()).toList(),
  };
}