class UserModel {
  final int? id;
  final String name;
  final String email;
  final int roleId;
  final int? branchId;
  final int? organizationId;
  final String? address;
  final String? designation;
  final String? dateOfBirth;
  final String? joiningDate;
  final String? relievingDate;
  final bool inactive;
  final String? createdAt;
  final String? updatedAt;
  final String? roleName;
  final String? branchName;
  final String? organizationName;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.roleId,
    this.branchId,
    this.organizationId,
    this.address,
    this.designation,
    this.dateOfBirth,
    this.joiningDate,
    this.relievingDate,
    this.inactive = false,
    this.createdAt,
    this.updatedAt,
    this.roleName,
    this.branchName,
    this.organizationName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roleId: json['role_id'],
      branchId: json['branch_id'],
      organizationId: json['organization_id'],
      address: json['address'],
      designation: json['designation'],
      dateOfBirth: json['date_of_birth'],
      joiningDate: json['joining_date'],
      relievingDate: json['relieving_date'],
      inactive: json['inactive'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      roleName: json['role_name'],
      branchName: json['branch_name'],
      organizationName: json['organization_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'role_id': roleId,
      if (branchId != null) 'branch_id': branchId,
      if (organizationId != null) 'organization_id': organizationId,
      if (address != null) 'address': address,
      if (designation != null) 'designation': designation,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (joiningDate != null) 'joining_date': joiningDate,
      if (relievingDate != null) 'relieving_date': relievingDate,
      'inactive': inactive,
    };
  }
}