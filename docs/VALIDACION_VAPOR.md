# Validación de la adaptación a Vapor y Vercel

Validación local del 5 de octubre de 2026. El backend no está publicado.

## Comprobado

- Las 23 comprobaciones de regresión de la app pasan con el adaptador de persistencia en memoria.
- Las 75 fuentes del target principal compilan para arm64 iOS 18 mediante un paquete temporal de verificación, con Google Sign-In y Kingfisher reales. Firebase no interviene.
- El backend Vapor y su ejecutable compilan con Swift 6.4; sus dependencias resueltas requieren Swift 6.2 como mínimo.
- Tres pruebas del backend pasan, con SQLite en memoria: aislamiento y revocación, claims y firmas JWT, y creación/reutilización del usuario y emisión de sesiones. El intercambio Google usa un verificador simulado en la prueba de rutas; la prueba JWT sí firma y verifica criptográficamente.
- El ejecutable arranca y `/health` responde HTTP 200 y `{"status":"ok"}` en una prueba local sin abrir conexión a PostgreSQL.
- El proyecto de Xcode, Info.plist y el diff no presentan errores de formato estructural.

## Límites de esta validación

La compilación completa de Xcode quedó bloqueada por permisos de sus cachés de Swift Package Manager; la comprobación de fuentes mediante el paquete temporal sí terminó. El entorno incorpora metadatos de Finder que impedían firmar el bundle de pruebas: se copió únicamente el bundle generado a un directorio temporal, se firmó allí y se ejecutaron las tres pruebas con XCTest.

No hay Docker disponible en este entorno. No se ha construido ni desplegado la imagen Linux de Vercel, conectado PostgreSQL real, comprobado el login real de Google en un dispositivo ni generado un archivo para App Store. Las migraciones se han probado con SQLite, no con Neon.

## Pendiente para publicar

1. Crear Neon Free y preparar la conexión privada.
2. Configurar un cliente Google OAuth propio o verificar acceso al existente.
3. Crear las tablas en PostgreSQL mediante las migraciones.
4. Configurar Vercel Hobby y desplegar el contenedor.
5. Sustituir `BackendBaseURL` en la app por la dirección HTTPS real.
6. Ejecutar las comprobaciones de dispositivo de la guía de despliegue.

Los favoritos existentes en Firestore no se han modificado. No se han hecho commits, pushes, contrataciones ni cambios a cuentas externas.
