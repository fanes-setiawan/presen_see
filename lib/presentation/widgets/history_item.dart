import 'package:flutter/material.dart';
import 'package:presen_see/core/constant/app_color.dart';
import '../../domain/entities/attendance.dart';

class HistoryItemWidget extends StatelessWidget {
  final Attendance attendance;
  const HistoryItemWidget({required this.attendance, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.surface,
          backgroundImage: attendance.photoUrl.isNotEmpty ? NetworkImage(attendance.photoUrl) : null,
          child: attendance.photoUrl.isEmpty ? const Icon(Icons.camera_alt) : null,
        ),
        title: Text('${attendance.date} ${attendance.time}'),
        subtitle: Text('Lokasi: ${attendance.locationStatus}'),
        trailing: attendance.synced ? const Icon(Icons.cloud_done, color: Colors.green) : const Icon(Icons.cloud_off, color: Colors.red),
      ),
    );
  }
}
