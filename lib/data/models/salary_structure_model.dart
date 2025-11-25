class SalaryStructureModel {
  final int? id;
  final int userId;
  final num basicSalaryAnnual;
  final num allowancesAnnual;
  final num deductionsAnnual;
  final num bonusAnnual;
  final String effectiveFrom;
  final String effectiveTo;
  final bool isActive;
  final num totalAnnual;
  final String? createdAt;
  final String? updatedAt;

  SalaryStructureModel({
    this.id,
    required this.userId,
    required this.basicSalaryAnnual,
    required this.allowancesAnnual,
    required this.deductionsAnnual,
    required this.bonusAnnual,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.isActive,
    required this.totalAnnual,
    this.createdAt,
    this.updatedAt,
  });

  factory SalaryStructureModel.fromJson(Map<String, dynamic> json) {
    return SalaryStructureModel(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      basicSalaryAnnual: json['basic_salary_annual'] ?? 0,
      allowancesAnnual: json['allowances_annual'] ?? 0,
      deductionsAnnual: json['deductions_annual'] ?? 0,
      bonusAnnual: json['bonus_annual'] ?? 0,
      effectiveFrom: json['effective_from'] ?? '',
      effectiveTo: json['effective_to'] ?? '',
      isActive: json['is_active'] ?? false,
      totalAnnual: json['total_annual'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'basic_salary_annual': basicSalaryAnnual,
      'allowances_annual': allowancesAnnual,
      'deductions_annual': deductionsAnnual,
      'bonus_annual': bonusAnnual,
      'effective_from': effectiveFrom,
      'effective_to': effectiveTo,
      'is_active': isActive,
    };
  }
}
