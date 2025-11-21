import '../../domain/entities/fund.dart';

class FundModel extends FundEntity {
  const FundModel({
    required super.id,
    required super.name,
    required super.currentBalance,
    required super.availableBalance,
    required super.breakdown,
    required super.performanceData,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) {
    return FundModel(
      id: json['id'],
      name: json['name'],
      currentBalance: json['currentBalance'].toDouble(),
      availableBalance: json['availableBalance'].toDouble(),
      breakdown: json['breakdown'],
      performanceData: List<double>.from(json['performanceData']),
    );
  }

  @override
  FundModel copyWith({
    String? id,
    String? name,
    double? currentBalance,
    double? availableBalance,
    Map<String, double>? breakdown,
    List<double>? performanceData,
  }) {
    return FundModel(
      id: id ?? this.id,
      name: name ?? this.name,
      currentBalance: currentBalance ?? this.currentBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      breakdown: breakdown ?? this.breakdown,
      performanceData: performanceData ?? this.performanceData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currentBalance': currentBalance,
      'availableBalance': availableBalance,
      'breakdown': breakdown,
      'performanceData': performanceData,
    };
  }
}
