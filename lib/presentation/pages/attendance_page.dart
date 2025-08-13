import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:presen_see/core/constant/app_color.dart';
import 'package:presen_see/presentation/blocs/attendance_bloc/attendance_bloc.dart';
import 'package:presen_see/presentation/blocs/attendance_bloc/attendance_event.dart';
import 'package:presen_see/presentation/blocs/attendance_bloc/attendance_state.dart';
import 'package:presen_see/presentation/pages/history_page.dart';
import 'package:presen_see/presentation/widgets/button_con_text.dart';import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'dart:async';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  Position? _position;
  File? _photoFile;
  bool _loading = false;
  StreamSubscription<Position>? _positionStream;

  final officeLat = -7.73227;
  final officeLng = 110.41371;
  final maxDistance = 100.0;

  @override
  void initState() {
    super.initState();
    _initLocation();
    _initLocationStream();
    _initCamera();
  }

  void _initLocationStream() async {
    await Geolocator.requestPermission();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position pos) {
      setState(() {
        _position = pos;
      });
    });
  }

  Future<void> _initLocation() async {
    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() => _position = pos);
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
        _controller = CameraController(frontCamera, ResolutionPreset.medium);
        await _controller!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('[attendace_page] : [_initCamera][catch error => $e]');
    }
  }

  double _distance() {
    if (_position == null) return double.infinity;
    return Geolocator.distanceBetween(
      _position!.latitude,
      _position!.longitude,
      officeLat,
      officeLng,
    );
  }

  Future<void> _takePicture() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) return;
      final xfile = await _controller!.takePicture();
      setState(() => _photoFile = File(xfile.path));
    } catch (e) {
      print('[attendace_page] : [_takePicture][catch error => $e]');
    }
  }

  Future<void> _doAttendance() async {
    try {
      if (_position == null || _photoFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lokasi atau foto belum siap')),
        );
        return;
      }
      setState(() => _loading = true);

      final user = FirebaseAuth.instance.currentUser!;
      final now = DateTime.now();
      final id = const Uuid().v4();
      final date = DateFormat('yyyy-MM-dd').format(now);
      final time = DateFormat('HH:mm:ss').format(now);
      final status = _distance() <= maxDistance ? 'Valid' : 'Tidak Valid';

      final bloc = BlocProvider.of<AttendanceBloc>(context);
      bloc.add(
        AddAttendanceEvent(
          id: id,
          userId: user.uid,
          name: user.email ?? '',
          date: date,
          time: time,
          latitude: _position!.latitude,
          longitude: _position!.longitude,
          locationStatus: status,
          photoFile: _photoFile!,
        ),
      );

      StreamSubscription<AttendanceState>? sub;
      sub = bloc.stream.listen((state) {
        if (state is AttendanceAdded) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Absensi tersimpan')));
          sub?.cancel();
          setState(() {
            _photoFile = null;
            _loading = false;
          });
        } else if (state is AttendanceError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          sub?.cancel();
          setState(() => _loading = false);
        }
      });
    } catch (e) {
      print('[attendace_page] : [_doAttendance][catch error => $e]');
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dist = _distance();
    final canAttend = dist <= maxDistance && _photoFile != null && !_loading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Absensi'),
        actions: [
          Dismissible(
            key: UniqueKey(),
            onDismissed: (detail) {},
            confirmDismiss: (direction) async {
              bool confirm = false;
              await showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Are you sure you want to delete this item?'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        onPressed: () {
                          confirm = true;
                          Navigator.pop(context);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );

              if (confirm) {
                return Future.value(true);
              }
              return Future.value(false);
            },
            child: IconButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                  ),
              icon: const Icon(Icons.history),
            ),
          ),
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.surface,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'Jarak ke kantor: ${dist.isFinite ? dist.toStringAsFixed(1) : '-'} m',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  'Status: ${dist <= maxDistance ? 'Di dalam area' : 'Di luar area'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Lokasi saya: ${_position != null ? '${_position!.latitude.toStringAsFixed(5)}, ${_position!.longitude.toStringAsFixed(5)}' : '-'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child:
                  _controller != null && _controller!.value.isInitialized
                      ? CameraPreview(_controller!)
                      : const Text('Kamera belum siap'),
            ),
          ),
          if (_photoFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(_photoFile!, height: 120, fit: BoxFit.cover),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ButtonConText(
                    label: 'Ambil Foto',
                    onPressed: _takePicture,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonConText(
                    label: 'Absen',
                    onPressed: _doAttendance,
                    enabled: canAttend,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
