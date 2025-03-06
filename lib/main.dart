import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interns_talk_mobile/data/datasources/language_service.dart';
import 'package:interns_talk_mobile/di/injection.dart';
import 'package:interns_talk_mobile/ui/bloc/auth_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/chat_room_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/conversation_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/profile_bloc.dart';
import 'package:interns_talk_mobile/ui/bloc/splash_bloc.dart';
import 'package:interns_talk_mobile/ui/pages/splash_screen.dart';
import 'package:interns_talk_mobile/utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<ProfileBloc>()),
        BlocProvider(create: (context) => getIt<ChatRoomBloc>()),
        BlocProvider(create: (context) => getIt<SplashBloc>()),
        BlocProvider(create: (context) => getIt<ConversationBloc>())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, String languageCode) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(languageCode);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  final LanguageService languageService = getIt<LanguageService>();

  setLocale(String languageCode) {
    languageService.setLocale(languageCode);
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  void didChangeDependencies() {
    languageService
        .getLocale()
        .then((locale) => setLocale(locale.languageCode));
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      theme: ThemeData(
        textTheme: TextTheme(
            titleLarge: TextStyle(
              fontSize: 32,
              color: kTextColor,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w300, color: kTextColor)),
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          onSurface: kAppBlack,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
