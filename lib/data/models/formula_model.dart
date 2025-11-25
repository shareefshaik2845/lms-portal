class FormulaModel {
  final int? id;
  final String componentCode;
  final String componentName;
  final String formulaExpression;
  final String formulaType;
  final bool isActive;
  final String? description;
  final int salaryStructureId;
  final String? createdAt;
  final String? updatedAt;

  FormulaModel({
    this.id,
    required this.componentCode,
    required this.componentName,
    required this.formulaExpression,
    required this.formulaType,
    required this.isActive,
    this.description,
    required this.salaryStructureId,
    this.createdAt,
    this.updatedAt,
  });

  factory FormulaModel.fromJson(Map<String, dynamic> json) {
    return FormulaModel(
      id: json['id'],
      componentCode: json['component_code'] ?? '',
      componentName: json['component_name'] ?? '',
      formulaExpression: json['formula_expression'] ?? '',
      formulaType: json['formula_type'] ?? '',
      isActive: json['is_active'] ?? false,
      description: json['description'],
      salaryStructureId: json['salary_structure_id'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'component_code': componentCode,
      'component_name': componentName,
      'formula_expression': formulaExpression,
      'formula_type': formulaType,
      'is_active': isActive,
      'description': description,
      'salary_structure_id': salaryStructureId,
    };
  }
}
