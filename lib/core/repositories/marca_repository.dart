import 'package:dlza_legal_app/core/models/marca.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarcaRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Obtiene una lista paginada de marcas con búsqueda opcional
  Future<List<Marca>> getMarcas({
    int page = 0,
    int limit = 20,
    String? searchQuery,
  }) async {
    try {
      var query = _supabase
          .from('Marca')
          .select('*')
          .order('createdAt', ascending: false);

      // Obtener datos de la base de datos
      final response = await query.range(page * limit, (page + 1) * limit - 1);

      List<Marca> marcas =
          (response as List).map((json) => Marca.fromJson(json)).toList();

      // Filtro simple por nombre de marca
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final searchLower = searchQuery.toLowerCase().trim();
        marcas =
            marcas
                .where(
                  (marca) => marca.nombre.toLowerCase().contains(searchLower),
                )
                .toList();
      }

      return marcas;
    } catch (e) {
      throw Exception('Error al cargar marcas: $e');
    }
  }

  /// Obtiene una marca específica por ID con sus renovaciones
  Future<Marca> getMarcaById(int id) async {
    try {
      final response =
          await _supabase
              .from('Marca')
              .select('''
            *,
            renovaciones:RenovacionMarca(*)
          ''')
              .eq('id', id)
              .single();

      return Marca.fromJson(response);
    } catch (e) {
      throw Exception('Error al cargar marca: $e');
    }
  }

  /// Obtiene las renovaciones de una marca específica
  Future<List<RenovacionMarca>> getRenovacionesByMarcaId(int marcaId) async {
    try {
      final response = await _supabase
          .from('RenovacionMarca')
          .select('*')
          .eq('marcaId', marcaId)
          .order('createdAt', ascending: false);

      return (response as List)
          .map((json) => RenovacionMarca.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar renovaciones: $e');
    }
  }

  /// Obtiene el total de marcas para la paginación
  Future<int> getTotalMarcas({String? searchQuery}) async {
    try {
      var query = _supabase.from('Marca').select('*');

      final response = await query;
      List<Marca> marcas =
          (response as List).map((json) => Marca.fromJson(json)).toList();

      // Aplicar filtro simple por nombre de marca
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final searchLower = searchQuery.toLowerCase().trim();
        marcas =
            marcas
                .where(
                  (marca) => marca.nombre.toLowerCase().contains(searchLower),
                )
                .toList();
      }

      return marcas.length;
    } catch (e) {
      throw Exception('Error al obtener total de marcas: $e');
    }
  }
}
