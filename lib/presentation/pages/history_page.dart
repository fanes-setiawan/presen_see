import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presen_see/presentation/blocs/attendance_bloc/attendance_bloc.dart';
import 'package:presen_see/presentation/blocs/attendance_bloc/attendance_event.dart';
import 'package:presen_see/presentation/blocs/attendance_bloc/attendance_state.dart';
import '../widgets/history_item.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final bloc = BlocProvider.of<AttendanceBloc>(context);
    bloc.add(LoadAttendances(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Absensi')),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) return const Center(child: CircularProgressIndicator());
          if (state is AttendanceLoaded) {
            if (state.attendances.isEmpty) return const Center(child: Text('Belum ada riwayat'));
            return ListView.builder(
              itemCount: state.attendances.length,
              itemBuilder: (ctx, i) => HistoryItemWidget(attendance: state.attendances[i]),
            );
          }
          if (state is AttendanceError) return Center(child: Text('Error: ${state.message}'));
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
