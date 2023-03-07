import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:tenantmgmnt/core/error_text.dart';
import 'package:tenantmgmnt/core/providers/apikeys.dart';
import 'package:tenantmgmnt/core/providers/providerobserver.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/snack_bar.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/router.dart';

void main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  await supabase.Supabase.initialize(
    url: supabaseApiURL,
    anonKey: supabaseApiPublicKey,
  );
  runApp(ProviderScope(
      observers: [
        Logger(),
      ],
      child:
          DevicePreview(enabled: false, builder: (context) => const MyApp())));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateProvider).when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          data: (data) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: Utils.messengerKey,
              routeInformationParser: const RoutemasterParser(),
              routerDelegate: RoutemasterDelegate(
                routesBuilder: (context) {
                  if (data != null) {
                    initialization() async {
                      var a = await ref
                          .read(authControllerProvider.notifier)
                          .tenantorowner(data.uid);
                      ref.read(userTypeProvider.notifier).update((state) => a);
                      print(ref.read(userTypeProvider)!.id);
                      FlutterNativeSplash.remove();
                    }

                    initialization();
                    return loggedinpages;
                  }
                  FlutterNativeSplash.remove();
                  return loggedoutpages;
                },
              ),
            );
          },
        );
  }
}
