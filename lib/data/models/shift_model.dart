class ShiftModel {
  final int? id;
  final String name;
  final String startTime;
  final String endTime;
  final String description;
  final String shiftCode;
  final String shiftName;
  final int workingMinutes;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  ShiftModel({
    this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.shiftCode,
    required this.shiftName,
    required this.workingMinutes,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'],
      name: json['name'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      description: json['description'] ?? '',
      shiftCode: json['shift_code'] ?? '',
      shiftName: json['shift_name'] ?? '',
      workingMinutes: json['working_minutes'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'start_time': startTime,
      'end_time': endTime,
      'description': description,
      'shift_code': shiftCode,
      'shift_name': shiftName,
      'working_minutes': workingMinutes,
      'status': status,
    };
  }
}
