import 'package:equatable/equatable.dart';

class FundEntity extends Equatable {
  final String id;
  final String name;
  final double currentBalance;
  final double availableBalance;
  final Map<String, double> breakdown;
  final List<double> performanceData;

  const FundEntity({
    required this.id,
    required this.name,
    required this.currentBalance,
    required this.availableBalance,
    required this.breakdown,
    required this.performanceData,
  });
  FundEntity copyWith({
    String? id,
    String? name,
    double? currentBalance,
    double? availableBalance,
    Map<String, double>? breakdown,
    List<double>? performanceData,
  }) {
    return FundEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      currentBalance: currentBalance ?? this.currentBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      breakdown: breakdown ?? this.breakdown,
      performanceData: performanceData ?? this.performanceData,
    );
  }

  @override
  List<Object> get props =>
      [id, name, currentBalance, availableBalance, breakdown, performanceData];
}
