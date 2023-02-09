import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:tenantmgmnt/core/error_text.dart';
import 'package:tenantmgmnt/core/providers/apikeys.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/auth/signin_main.dart';
import 'package:tenantmgmnt/features/components/snack_bar.dart';
import 'package:tenantmgmnt/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await supabase.Supabase.initialize(
    url: supabaseApiURL,
    anonKey: supabaseApiPublicKey,
  );
  runApp(ProviderScope(child: const MyApp()));
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
                  // getData(ref, data!);
                  if (data != null) {
                    initialization() async {
                      var u = await ref
                          .read(authControllerProvider.notifier)
                          .getOwnerData(data.uid).first;
                      ref.read(ownerDataProvider.notifier).update((state) => u);
                      
                      // await getData(ref, data);
                      // FlutterNativeSplash.remove();
                    }

                    initialization();
                    return loggedinpages;
                    // if (userModel != null) {
                    //   return loggedInPages;
                    // }
                  }
                  // FlutterNativeSplash.remove();
                  return loggedoutpages;
                },
              ),
            );
          },
        );
  }
}
