class TransactionFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? type; 
  final String? status; 

  TransactionFilter({
    this.startDate,
    this.endDate,
    this.type,
    this.status,
  });

  TransactionFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? status,
  }) {
    return TransactionFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'type': type,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'TransactionFilter(startDate: $startDate, endDate: $endDate, type: $type, status: $status)';
  }
}
