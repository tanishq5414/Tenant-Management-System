
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:tenantmgmnt/core/providers/apikeys.dart';

final supabaseAuthProvider = Provider((ref) => supabase.SupabaseAuth.instance);
final supabaseProvider = Provider((ref) => supabase.SupabaseClient(supabaseApiURL,supabaseApiPublicKey));
final authProvider = Provider((ref) => FirebaseAuth.instance);

