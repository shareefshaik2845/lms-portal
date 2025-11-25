class LeaveModel {
  final int? id;
  final String name;
  final String description;
  final bool status;
  final String leaveDate;
  final int userId;
  final int year;
  final int allocated;
  final int used;
  final int balance;
  final bool carryForward;
  final bool holiday;
  final String? createdAt;
  final String? updatedAt;

  LeaveModel({
    this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.leaveDate,
    required this.userId,
    required this.year,
    required this.allocated,
    required this.used,
    required this.balance,
    required this.carryForward,
    required this.holiday,
    this.createdAt,
    this.updatedAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] == true,
      leaveDate: json['leave_date'] ?? '',
      userId: json['user_id'] ?? 0,
      year: json['year'] ?? 0,
      allocated: json['allocated'] ?? 0,
      used: json['used'] ?? 0,
      balance: json['balance'] ?? 0,
      carryForward: json['carry_forward'] == true,
      holiday: json['holiday'] == true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'status': status,
      'leave_date': leaveDate,
      'user_id': userId,
      'year': year,
      'allocated': allocated,
      'used': used,
      'balance': balance,
      'carry_forward': carryForward,
      'holiday': holiday,
    };
  }
}
