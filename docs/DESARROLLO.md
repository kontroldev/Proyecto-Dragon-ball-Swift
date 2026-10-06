# Desarrollo y validación

## Criterios de código

- Utiliza nombres que indiquen la responsabilidad: catálogo, ficha, sesión o persistencia.
- Mantén el estado de interfaz en `MainActor`. No añadas `@unchecked Sendable` para ocultar un diagnóstico del compilador.
- Inicia cargas desde el ciclo de vida de la pantalla, con cancelación y comprobación de la sesión cuando corresponda.
- Conserva una fuente de verdad para favoritos y reproducción.
- Documenta decisiones y restricciones. Evita comentarios que repitan cada instrucción o relatos de correcciones anteriores.
- Conserva los créditos existentes y no atribuyas trabajo a personas que no lo hicieron.

Los nombres de tipos se han normalizado donde había errores de escritura. Algunos archivos conservan su nombre histórico para limitar cambios en Xcode. Una reorganización de carpetas debe actualizar también `project.pbxproj`.

## Pruebas de regresión

Ejecuta `./scripts/test.sh`. El script compila los archivos reales de red, catálogo, mapeo, favoritos y juegos con Swift 6. Usa dobles para las respuestas de red y la persistencia; no necesita credenciales ni realiza peticiones.

Se comprueban:

- Diferenciación de errores HTTP y propagación de cancelación.
- Fichas con planeta ausente y transformaciones presentes.
- Catálogo paginado con IDs repetidos.
- Búsqueda escrita antes de terminar la carga.
- Escrituras y eliminaciones fallidas, duplicados y respuestas de otra sesión.
- Selección repetida, tercera carta y reinicio durante una pareja pendiente.
- Límites de intentos según dificultad.
- Piezas de Tetrix fuera del borde superior y controles en pausa.

El adaptador HTTP real y PostgreSQL, Google Sign-In, el reproductor, la Live Activity y la interfaz necesitan verificación adicional. El script usa `-disable-sandbox` solo para el proceso de macros del compilador, porque algunos entornos ya aislados no permiten iniciar un segundo sandbox. No cambia la seguridad de la app compilada.

## Comprobaciones manuales

1. Abre la app como invitado; consulta la wiki, busca durante una carga y prueba una consulta sin resultados.
2. Desconecta la red y comprueba mensajes, imágenes fallidas y reintento.
3. Abre una ficha y comprueba que afiliación y planeta son campos distintos.
4. Inicia sesión, añade un favorito, cierra sesión y cambia de cuenta. La segunda cuenta no debe ver favoritos de la primera.
5. Ejecuta `swift test` en `Backend` y prueba migraciones, aislamiento y logout contra PostgreSQL de desarrollo.
6. Reproduce, pausa, cambia de canción, vuelve atrás y prueba un archivo ausente.
7. En dispositivo compatible, comprueba Live Activity, pausa, fin de canción y salida de la pantalla.
8. Reinicia memoria con dos cartas visibles, completa rondas y comprueba el tercer nivel.
9. Comprueba pausa, reinicio, borde superior y eliminación de filas en Tetrix.
10. Revisa VoiceOver, tamaños de texto de accesibilidad, modo oscuro e iPad.

## Validación de esta entrega

Comprobaciones realizadas el 5 de octubre de 2026:

- 23 comprobaciones de regresión aprobadas con Swift 6, incluyendo un archivo MP3 ausente.
- Compilación de los 75 archivos Swift del target principal mediante un paquete temporal de verificación, con el SDK de iOS y las versiones de dependencias fijadas en `Package.resolved`.
- Comprobación de tipos de los dos archivos de la extensión con Swift 6 y destino iOS 18.
- Validación del formato del proyecto de Xcode, referencias de fuentes existentes sin duplicados y diferencias sin errores de espacios.

El paquete temporal usa las fuentes reales y las dependencias reales; aporta el símbolo de imagen que Xcode genera desde el catálogo de assets. No sustituye la compilación y empaquetado de `DragonBallSwift.xcodeproj`: esa operación quedó bloqueada por la resolución de dependencias y los permisos del entorno. No se han probado firma, empaquetado de assets, instalación, inicio de sesión real ni interacción en dispositivo.

Las advertencias de dependencias antiguas deben revisarse en una actualización específica. No se han cambiado las versiones fijadas del proyecto, desplegado reglas, creado commits ni publicado cambios en GitHub.
