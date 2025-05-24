import 'dart:convert';
import 'package:dlza_legal_app/core/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  static const String _userKey = 'user_data';
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Login del usuario
  Future<Usuario> login(String username, String password) async {
    try {
      // Buscar usuario por username
      final response =
          await _supabaseClient
              .from('Usuario')
              .select()
              .eq('username', username)
              .eq(
                'password',
                password,
              ) // En producción, esto debería ser hasheado
              .single();

      final usuario = Usuario.fromJson(response);

      // Verificar si el usuario está activo
      if (!usuario.activo) {
        throw Exception('Usuario inactivo. Contacte al administrador.');
      }

      // Guardar datos básicos en localStorage
      await _saveUserToLocal(usuario);

      return usuario;
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw Exception('Credenciales incorrectas');
      }
      throw Exception('Error al iniciar sesión: ${e.message}');
    } catch (e) {
      if (e.toString().contains('Usuario inactivo')) {
        rethrow;
      }
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  // Guardar usuario en localStorage
  Future<void> _saveUserToLocal(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode(usuario.toBasicJson());
    await prefs.setString(_userKey, userData);
  }

  // Obtener usuario desde localStorage
  Future<Usuario?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);

      if (userData == null) return null;

      final userMap = jsonDecode(userData) as Map<String, dynamic>;
      return Usuario.fromBasicJson(userMap);
    } catch (e) {
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Verificar si hay una sesión activa
  Future<bool> hasActiveSession() async {
    final user = await getCurrentUser();
    return user != null;
  }

  // Actualizar datos del usuario en localStorage
  Future<void> updateUserLocal(Usuario usuario) async {
    await _saveUserToLocal(usuario);
  }
}
