-- Datos de prueba para marcas
INSERT INTO "Marca" (
  nombre, estado, "logotipoUrl", genero, tipo, "claseNiza", "numeroRegistro",
  "fechaRegistro", "tramiteArealizar", "fechaExpiracionRegistro", 
  "fechaLimiteRenovacion", titular, apoderado
) VALUES 
-- Marcas con diferentes estados y fechas
(
  'Delisoft',
  'vigente',
  'https://via.placeholder.com/150x150/FF6B6B/FFFFFF?text=DS',
  'marca producto',
  'mixta',
  '30',
  '153423',
  '2020-03-15',
  'renovación de marca 2025',
  '2025-03-15',
  '2025-09-15',
  'DLZA Legal S.R.L.',
  'Dr. Juan Pérez'
),
(
  'Gelix',
  'renovada',
  'https://via.placeholder.com/150x150/4ECDC4/FFFFFF?text=GX',
  'marca producto',
  'figurativa',
  '29',
  '152310',
  '2019-06-20',
  'modificación de marca',
  '2024-06-20',
  '2024-12-20',
  'Productos Gelix S.A.',
  'Dra. María García'
),
(
  'Helado Copito',
  'registrada',
  'https://via.placeholder.com/150x150/45B7D1/FFFFFF?text=HC',
  'marca producto',
  'nominativa',
  '30',
  '153068',
  '2023-08-10',
  NULL,
  '2033-08-10',
  '2034-02-10',
  'Heladería Copito Ltda.',
  'Lic. Carlos Mamani'
),
(
  'TechSolutions',
  'vigente',
  'https://via.placeholder.com/150x150/96CEB4/FFFFFF?text=TS',
  'marca servicio',
  'mixta',
  '42',
  '154521',
  '2021-11-30',
  'renovación próxima',
  '2031-11-30',
  '2032-05-30',
  'TechSolutions Bolivia S.R.L.',
  'Ing. Ana Morales'
),
(
  'Sabor Andino',
  'caducada',
  'https://via.placeholder.com/150x150/FECA57/FFFFFF?text=SA',
  'marca producto',
  'denominativa',
  '29',
  '150987',
  '2015-02-14',
  'reactivación pendiente',
  '2020-02-14',
  '2020-08-14',
  'Alimentos Andinos S.A.',
  'Dr. Roberto Silva'
),
(
  'Express Delivery',
  'vigente',
  'https://via.placeholder.com/150x150/FF9FF3/FFFFFF?text=ED',
  'marca servicio',
  'figurativa',
  '39',
  '155432',
  '2022-01-25',
  NULL,
  '2032-01-25',
  '2032-07-25',
  'Servicios Express S.R.L.',
  'Lic. Patricia López'
),
(
  'EcoVerde',
  'vigente',
  'https://via.placeholder.com/150x150/54A0FF/FFFFFF?text=EV',
  'lema comercial',
  'mixta',
  '31',
  '156789',
  '2023-05-12',
  'expansión internacional',
  '2033-05-12',
  '2033-11-12',
  'EcoVerde Bolivia S.A.',
  'Dra. Laura Fernández'
),
(
  'Artesanías del Altiplano',
  'registrada',
  'https://via.placeholder.com/150x150/5F27CD/FFFFFF?text=AA',
  'marca producto',
  'tridimensional',
  '14',
  '157234',
  '2024-03-08',
  NULL,
  '2034-03-08',
  '2034-09-08',
  'Cooperativa Artesanal del Altiplano',
  'Lic. Miguel Quispe'
),
(
  'Digital Hub',
  'vigente',
  'https://via.placeholder.com/150x150/00D2D3/FFFFFF?text=DH',
  'marca servicio',
  'nominativa',
  '42',
  '158901',
  '2023-09-15',
  'ampliación de servicios',
  '2033-09-15',
  '2034-03-15',
  'Digital Hub Technologies S.R.L.',
  'Ing. Sofia Vargas'
),
(
  'Quinua Real',
  'renovada',
  'https://via.placeholder.com/150x150/FF6348/FFFFFF?text=QR',
  'marca producto',
  'mixta',
  '30',
  '159876',
  '2018-12-03',
  'certificación orgánica',
  '2023-12-03',
  '2024-06-03',
  'Productores de Quinua Real S.A.',
  'Dr. Eduardo Mamani'
);

-- Datos de renovaciones para las marcas
INSERT INTO "RenovacionMarca" (
  "estadoRenovacion", "numeroDeRenovacion", "fechaParaRenovacion",
  "numeroDeSolicitud", titular, apoderado, "procesoSeguidoPor", "marcaId"
) VALUES 
-- Renovaciones para Delisoft (marcaId: 1)
(
  'vigente',
  '153423-A',
  '2020-03-15',
  '2660-2020',
  'DLZA Legal S.R.L.',
  'Dr. Juan Pérez',
  'María González',
  1
),
-- Renovaciones para Gelix (marcaId: 2)
(
  'renovada',
  '152310-B',
  '2019-06-20',
  '3522-2019',
  'Productos Gelix S.A.',
  'Dra. María García',
  'Carlos Mendoza',
  2
),
(
  'vigente',
  '152310-C',
  '2024-06-20',
  '4125-2024',
  'Productos Gelix S.A.',
  'Dra. María García',
  'Ana Rodríguez',
  2
),
-- Renovaciones para TechSolutions (marcaId: 4)
(
  'vigente',
  '154521-A',
  '2021-11-30',
  '5789-2021',
  'TechSolutions Bolivia S.R.L.',
  'Ing. Ana Morales',
  'Roberto Castro',
  4
),
-- Renovaciones para Quinua Real (marcaId: 10)
(
  'renovada',
  '159876-A',
  '2018-12-03',
  '6543-2018',
  'Productores de Quinua Real S.A.',
  'Dr. Eduardo Mamani',
  'Patricia Flores',
  10
),
(
  'vigente',
  '159876-B',
  '2023-12-03',
  '7890-2023',
  'Productores de Quinua Real S.A.',
  'Dr. Eduardo Mamani',
  'Luis Herrera',
  10
);
