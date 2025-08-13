import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/constant/app_color.dart';
import 'presentation/blocs/auth_bloc/auth_bloc.dart';
import 'presentation/blocs/auth_bloc/auth_event.dart';
import 'presentation/blocs/attendance_bloc/attendance_bloc.dart';
import 'presentation/pages/splash_page.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final di = await InjectionContainer.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthStarted())),
        BlocProvider(
          create:
              (_) => AttendanceBloc(
                addAttendance: di.addUsecase,
                getAttendances: di.getUsecase,
                syncAttendances: di.syncUsecase,
                uploadImage: di.uploadImageUsecase,
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PresenSee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFFF6F9FF),
      ),
      home: const SplashPage(),
    );
  }
}
