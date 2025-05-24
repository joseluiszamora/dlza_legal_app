-- Script SQL para insertar usuarios de prueba en la tabla Usuario de Supabase
-- Ejecutar este script en el SQL Editor de Supabase

-- Crear usuario administrador
INSERT INTO "Usuario" (
    username, 
    password, 
    email, 
    nombres, 
    apellidos, 
    documento, 
    "imagenUrl", 
    area, 
    cargo, 
    role, 
    activo
) VALUES (
    'admin',
    'admin123',  -- En producción esto debe estar hasheado
    'admin@dlzalegal.com',
    'Juan Carlos',
    'Administrador',
    '12345678',
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    'Dirección General',
    'Director General',
    'admin',
    true
);

-- Crear usuario regular
INSERT INTO "Usuario" (
    username, 
    password, 
    email, 
    nombres, 
    apellidos, 
    documento, 
    "imagenUrl", 
    area, 
    cargo, 
    role, 
    activo
) VALUES (
    'jsolo',
    'password123',
    'juan.solo@dlzalegal.com',
    'Juan',
    'Solo',
    '87654321',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    'Área Jurídica',
    'Abogado Senior',
    'user',
    true
);

-- Crear otro usuario regular
INSERT INTO "Usuario" (
    username, 
    password, 
    email, 
    nombres, 
    apellidos, 
    documento, 
    "imagenUrl", 
    area, 
    cargo, 
    role, 
    activo
) VALUES (
    'mgarcia',
    'password123',
    'maria.garcia@dlzalegal.com',
    'María',
    'García',
    '11223344',
    'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-1.2.1&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    'Recursos Humanos',
    'Especialista en RRHH',
    'user',
    true
);

-- Crear usuario inactivo para probar validación
INSERT INTO "Usuario" (
    username, 
    password, 
    email, 
    nombres, 
    apellidos, 
    documento, 
    area, 
    cargo, 
    role, 
    activo
) VALUES (
    'inactivo',
    'password123',
    'inactivo@dlzalegal.com',
    'Usuario',
    'Inactivo',
    '99999999',
    'Contabilidad',
    'Contador',
    'user',
    false  -- Usuario inactivo
);

-- Verificar la inserción
SELECT * FROM "Usuario";
