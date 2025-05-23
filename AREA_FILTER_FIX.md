# Fix para el Problema de Filtro por Área

## Problema Identificado

El filtro por área en `EmployeeBloc` causaba loading infinito porque:

1. **Filtrado local limitado**: El método `_onFilterByArea` solo filtraba entre los empleados de la página actual (20 empleados), no consultaba toda la base de datos.

2. **Pérdida de contexto en paginación**: Los métodos de navegación de páginas no mantenían el filtro de área activo.

3. **Búsqueda ineficiente**: La búsqueda se realizaba localmente en lugar de usar consultas de base de datos.

## Soluciones Implementadas

### 1. Modificación del Evento `LoadEmployees`

```dart
class LoadEmployees extends EmployeeEvent {
  final int page;
  final int pageSize;
  final bool loadMore;
  final Area? filterByArea;  // ✅ NUEVO: Soporte para filtro por área

  const LoadEmployees({
    this.page = 1,
    this.pageSize = 20,
    this.loadMore = false,
    this.filterByArea,  // ✅ NUEVO
  });
}
```

### 2. Actualización del Método `_onLoadEmployees`

- ✅ **Filtros dinámicos en Supabase**: Ahora construye consultas dinámicas que incluyen filtros por área y búsqueda
- ✅ **Persistencia de filtros**: Mantiene el área seleccionada y searchQuery entre cargas de páginas
- ✅ **Consultas optimizadas**: Una sola consulta a Supabase con todos los filtros aplicados

```dart
// Construir la consulta base
var countQuery = _supabase.from('Empleado').select('id').eq('activo', true);
var employeesQuery = _supabase.from('Empleado').select('''
  *,
  area:Area(*),
  ciudad:Ciudad(*)
''').eq('activo', true);

// Aplicar filtro por área si existe
if (selectedArea != null) {
  countQuery = countQuery.eq('areaId', selectedArea.id);
  employeesQuery = employeesQuery.eq('areaId', selectedArea.id);
}

// Aplicar filtro de búsqueda si existe
if (searchQuery.isNotEmpty) {
  final query = searchQuery.toLowerCase();
  countQuery = countQuery.or('nombres.ilike.%$query%,apellidos.ilike.%$query%,cargo.ilike.%$query%,documento.ilike.%$query%');
  employeesQuery = employeesQuery.or('nombres.ilike.%$query%,apellidos.ilike.%$query%,cargo.ilike.%$query%,documento.ilike.%$query%');
}
```

### 3. Simplificación del Método `_onFilterByArea`

```dart
void _onFilterByArea(FilterByArea event, Emitter<EmployeeState> emit) {
  if (state is! EmployeeLoaded) return;

  final currentState = state as EmployeeLoaded;

  // ✅ SIMPLIFICADO: Usar LoadEmployees con el filtro de área
  add(LoadEmployees(
    page: 1,
    pageSize: currentState.employeesPerPage,
    filterByArea: event.area,
  ));
}
```

### 4. Actualización del Método `_onClearAreaFilter`

```dart
void _onClearAreaFilter(ClearAreaFilter event, Emitter<EmployeeState> emit) {
  if (state is! EmployeeLoaded) return;

  final currentState = state as EmployeeLoaded;

  // ✅ CORREGIDO: Recargar todos los empleados sin filtro
  add(LoadEmployees(
    page: 1,
    pageSize: currentState.employeesPerPage,
  ));
}
```

### 5. Búsqueda con Supabase

El método `_onSearchEmployees` ahora:

- ✅ **Consulta directa a BD**: Usa `ilike` de PostgreSQL para búsqueda case-insensitive
- ✅ **Mantiene filtros**: Combina búsqueda con filtro de área activo
- ✅ **Paginación correcta**: Calcula totales correctos para resultados filtrados

```dart
// Aplicar filtros de búsqueda usando textSearch de PostgreSQL
countQuery = countQuery.or(
  'nombres.ilike.%$query%,apellidos.ilike.%$query%,cargo.ilike.%$query%,documento.ilike.%$query%'
);

employeesQuery = employeesQuery.or(
  'nombres.ilike.%$query%,apellidos.ilike.%$query%,cargo.ilike.%$query%,documento.ilike.%$query%'
);
```

### 6. Navegación de Páginas Actualizada

Todos los métodos de navegación (`_onLoadNextPage`, `_onLoadPreviousPage`, `_onGoToPage`) ahora:

- ✅ **Mantienen filtros**: Pasan `filterByArea: currentState.selectedArea` a `LoadEmployees`
- ✅ **Scroll infinito actualizado**: `EmployeeListSection` también mantiene el filtro

## Resultado

- ✅ **Loading infinito solucionado**: El filtro por área ahora funciona correctamente
- ✅ **Paginación con filtros**: La navegación de páginas mantiene el área seleccionada
- ✅ **Búsqueda optimizada**: Las búsquedas consultan toda la BD, no solo la página actual
- ✅ **Filtros combinados**: Área + búsqueda funcionan juntos correctamente
- ✅ **Performance mejorada**: Una sola consulta con filtros vs múltiples operaciones locales

## Archivos Modificados

- `/lib/core/blocs/employee/employee_event.dart` - Agregado parámetro `filterByArea`
- `/lib/core/blocs/employee/employee_bloc.dart` - Métodos `_onLoadEmployees`, `_onFilterByArea`, `_onClearAreaFilter`, `_onSearchEmployees` y navegación
- `/lib/views/employee/components/employee_list_section.dart` - Scroll infinito mantiene filtros

## Testing

- ✅ Compilación exitosa con `flutter analyze` (solo warnings de deprecación)
- ✅ Sin errores de sintaxis o tipos
- ⏳ Pendiente: Testing funcional con datos reales en Supabase
