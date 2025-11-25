class PayrollModel {
  final int? id;
  final int userId;
  final int salaryStructureId;
  final String month;
  final num basicSalary;
  final num allowances;
  final num deductions;
  final num bonus;
  final num grossSalary;
  final num netSalary;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? userName;
  final String? salaryStructureName;

  PayrollModel({
    this.id,
    required this.userId,
    required this.salaryStructureId,
    required this.month,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.bonus,
    required this.grossSalary,
    required this.netSalary,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.salaryStructureName,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      salaryStructureId: json['salary_structure_id'] ?? 0,
      month: json['month'] ?? '',
      basicSalary: json['basic_salary'] ?? 0,
      allowances: json['allowances'] ?? 0,
      deductions: json['deductions'] ?? 0,
      bonus: json['bonus'] ?? 0,
      grossSalary: json['gross_salary'] ?? 0,
      netSalary: json['net_salary'] ?? 0,
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userName: json['user_name'],
      salaryStructureName: json['salary_structure_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'salary_structure_id': salaryStructureId,
      'month': month,
      'basic_salary': basicSalary,
      'allowances': allowances,
      'deductions': deductions,
      'bonus': bonus,
      'gross_salary': grossSalary,
      'net_salary': netSalary,
      if (status != null) 'status': status,
    };
  }
}
