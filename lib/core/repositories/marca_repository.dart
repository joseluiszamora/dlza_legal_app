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

      // Obtener un rango más amplio para permitir filtrado local
      final rangeMultiplier =
          searchQuery != null && searchQuery.isNotEmpty ? 5 : 1;
      final response = await query.range(
        page * limit,
        ((page + 1) * limit * rangeMultiplier) - 1,
      );

      List<Marca> marcas =
          (response as List).map((json) => Marca.fromJson(json)).toList();

      // Implementar filtro local por nombre
      if (searchQuery != null && searchQuery.isNotEmpty) {
        marcas =
            marcas
                .where(
                  (marca) => marca.nombre.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                )
                .toList();

        // Tomar solo los elementos necesarios para esta página
        final startIndex = 0;
        final endIndex = limit;
        marcas = marcas.skip(startIndex).take(endIndex).toList();
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

      // Aplicar mismo filtro de búsqueda que en getMarcas
      if (searchQuery != null && searchQuery.isNotEmpty) {
        marcas =
            marcas
                .where(
                  (marca) => marca.nombre.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                )
                .toList();
      }

      return marcas.length;
    } catch (e) {
      throw Exception('Error al obtener total de marcas: $e');
    }
  }
}
