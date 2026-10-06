# Proyecto colaborativo de una app de Dragon Ball en Swift

¡Bienvenido al Proyecto Colaborativo de Dragon Ball! Este es un proyecto abierto en el que todos pueden contribuir. Si eres fan de Dragon Ball y tienes experiencia o ganas de aprender Swift, nos encantará contar con tu ayuda.

También puedes consultar [la versión del proyecto en Kotlin](https://github.com/juanppdev/dragon-ball-app).

## Funcionalidades principales

- Wiki de personajes organizada con los filtros públicos disponibles: todos, Guerreros Z, villanos, Saiyans y androides.
- Buscador de personajes y sección de favoritos.
- Inicio de sesión con Google y favoritos guardados en un backend propio escrito en Swift con Vapor.
- Reproductor de música con Live Activity.
- Minijuegos de memoria, Tetris y **Cartas Dragon Ball**, un juego de cartas por turnos inspirado en la mecánica de UNO, contra la máquina u online con salas privadas.
- Interfaz creada con SwiftUI y adaptada a los modos claro y oscuro.

## Novedades: backend Vapor, partidas online y Cartas Dragon Ball

La rama `refactor-vapor-vercel` sustituye Firebase por un servidor propio y añade el nuevo juego de cartas. La documentación detallada está en la carpeta [`docs`](docs).

### Preparación del proyecto para el servidor Vapor

- Nueva carpeta [`Backend`](Backend) con un paquete Swift 6.2 basado en Vapor, Fluent y PostgreSQL (Neon en producción).
- Firebase Authentication y Firestore dejan de usarse: se eliminan `GoogleService-Info.plist`, `FirebaseAuthServices` y `FavoriteCharacterDataService`, y Firebase ya no se enlaza en el target.
- La app obtiene el ID token con Google Sign-In y lo envía a `POST /v1/auth/google`. El servidor verifica firma, emisor, audiencia y caducidad, y emite una sesión aleatoria de siete días; en PostgreSQL solo se guarda su hash SHA-256.
- `BackendClient` (en `Service/BackendServices`) centraliza las peticiones HTTPS al servidor, guarda la sesión en Keychain e invalida solo la sesión que recibe un 401.
- `APIFavoriteStore` implementa `FavoriteCharacterStoring` contra `/v1/favorites`, de modo que `FavoritesViewModel` no depende de la persistencia concreta.
- La URL del servidor se configura en la clave `BackendBaseURL` de `Info.plist`. El valor incluido (`https://YOUR_PROJECT.vercel.app`) es un ejemplo, no un servidor publicado.
- El despliegue se prepara para Vercel Container Images mediante `Backend/Dockerfile.vercel` y `Backend/vercel.json`. Las variables necesarias están en `Backend/.env.example` (`DATABASE_URL`, `GOOGLE_CLIENT_ID`, `PORT`, `AUTO_MIGRATE`).
- Las migraciones crean las tablas `users`, `sessions`, `favorites` y `card_rooms`.

Rutas principales del servidor (las privadas requieren `Authorization: Bearer <token>`):

| Método | Ruta | Función |
| --- | --- | --- |
| GET | `/health` | Comprobación del proceso |
| POST | `/v1/auth/google` | Inicia sesión con un ID token de Google |
| GET | `/v1/me` | Usuario de la sesión actual |
| DELETE | `/v1/auth/session` | Cierra y revoca la sesión |
| GET / PUT / DELETE | `/v1/favorites[/:id]` | Consulta, añade y elimina favoritos |
| POST | `/v1/rooms` | Crea una sala de cartas |
| GET | `/v1/rooms/:code` | Estado privado de la sala para un miembro |
| POST | `/v1/rooms/:code/join` | Unirse o reconectar |
| POST | `/v1/rooms/:code/start` | Iniciar la partida (solo anfitrión) |
| POST | `/v1/rooms/:code/actions` | Jugar una carta o robar |

Consulta [Backend/README.md](Backend/README.md), [la configuración local](docs/CONFIGURACION.md) y [la guía de despliegue en Vercel y Neon](docs/DESPLIEGUE_VERCEL.md).

### Partidas online

- Salas privadas de cuatro jugadores humanos identificadas por un código de diez caracteres. El anfitrión crea la sala, comparte el código y la inicia cuando están los cuatro.
- El servidor es la autoridad de la partida: comprueba pertenencia, turno, versión del estado, posesión de la carta y legalidad de la jugada.
- Cada jugador recibe solo su mano, el número de cartas de los rivales, la carta superior del descarte y el color activo; nunca el orden del mazo.
- Cada modificación bloquea la fila de la sala con `SELECT FOR UPDATE` dentro de una transacción, por lo que varias instancias de Vercel comparten la misma partida sin conflictos. El número de versión evita duplicar una jugada si una petición se repite.
- La app consulta el estado cada dos segundos mientras la pantalla está activa (sin WebSockets en esta versión).
- Las salas caducan a las 24 horas y cada usuario puede tener como máximo cinco salas activas. Para reconectar basta con introducir el mismo código con la misma cuenta.

### Cartas Dragon Ball

- Nuevas entradas en Juegos: **Cartas Dragon Ball · Contra la máquina** y **Cartas Dragon Ball · Online**.
- Baraja de 108 cartas en cuatro colores (rojo, amarillo, verde y azul), siete cartas por jugador y cuatro jugadores. Se juega por color o valor, con cartas de salto, reversa, +2, comodín de color y +4.
- Variantes deliberadas: +4 solo si no se tiene el color activo, penalizaciones no acumulables, robar termina el turno, aviso automático de «¡Una carta!» y gana quien vacía su mano. Las reglas se pueden consultar desde el botón Reglas.
- El motor de reglas (`Backend/Sources/CardRules/BattleCards.swift` y `OnlineCards.swift`) es independiente de SwiftUI y del transporte. Xcode compila esos mismos archivos dentro de la app y Vapor los importa como módulo `CardRules`, así que no hay dos versiones de las reglas.
- Los rivales locales eligen siempre jugadas legales.

Interfaz (`ViewModel/GamesViews/BattleCardsView.swift`):

- Pantalla de preparación para elegir el logotipo de las cartas y el personaje de cada asiento.
- Mesa con los rivales alrededor, mazo y descarte en el centro, plataforma con flechas que indican el sentido del turno y la mano del jugador abajo.
- Caras de carta ilustradas con personajes de `Assets.xcassets` y reversos con GokuPeque.
- Animaciones de cartas en vuelo al repartir y jugar, destello al jugar una carta y pantalla de ganador.
- Adaptada a orientación vertical y horizontal: hasta doce cartas se ajustan al ancho y una mano mayor se desplaza horizontalmente.
- La vista online permite crear una sala, unirse con un código, esperar a los jugadores y jugar sobre la misma mesa.

El nombre, el logotipo y el diseño de UNO tienen protección de marca, por lo que el juego no los utiliza. Antes de distribuir la app hay que revisar también los derechos de Dragon Ball (consulta [ROADMAP](docs/ROADMAP.md)).

### Estado de validación

- El backend compila y sus pruebas pasan con SQLite en memoria: autenticación, expiración y revocación de sesiones, aislamiento de favoritos y salas, privacidad del estado, cartas especiales, jugadas rechazadas y 100 partidas completas conservando las 108 cartas.
- `./scripts/test.sh` ejecuta las pruebas de regresión de la app (red, catálogo, favoritos, memoria y Tetrix) con dobles de prueba.
- **Pendiente:** el servidor no está publicado. Faltan crear la base en Neon, ejecutar las migraciones, desplegar en Vercel, configurar un cliente OAuth propio, sustituir `BackendBaseURL` por la URL real y probar los bloqueos de PostgreSQL y el flujo completo `join/start/actions` contra una base real. Detalles en [VALIDACION_VAPOR](docs/VALIDACION_VAPOR.md) y [CARTAS](docs/CARTAS.md).

## Refactorización anterior

La rama `refactorizacion` moderniza la obtención de datos y corrige varios problemas de estabilidad sin eliminar las funcionalidades existentes del proyecto.

### Cambios del 19 de septiembre de 2026

- Se sustituyen los endpoints antiguos que habían dejado de responder por la API pública `https://dragonball-api.com/api/characters`.
- Las cartas de personajes y los favoritos comparten ahora el mismo servicio de red y el mismo mapeo de modelos.
- Las categorías anteriores por saga se reemplazan por filtros compatibles con el JSON actual: todos los personajes, Guerreros Z, villanos, Saiyans y androides.
- Se corrige el buscador para que una consulta sin coincidencias no vuelva a mostrar automáticamente todos los personajes.
- Se añade un estado de error visible con una acción para reintentar la descarga de las cartas.
- Las imágenes de la vista de detalle conservan su proporción original mediante `.scaledToFit()`, evitando que aparezcan ensanchadas o aplastadas.
- Se actualiza este README para documentar la migración y las correcciones realizadas.

### Red, modelos y favoritos

- Se incorpora un cliente de red reutilizable basado en protocolos para desacoplar las peticiones de `URLSession`.
- Los errores de URL, conexión, respuesta HTTP y decodificación se conservan y se traducen en mensajes comprensibles para la interfaz.
- La wiki y la carga de favoritos utilizan una única petición al listado de personajes de [Dragon Ball API](https://dragonball-api.com).
- Los filtros de la wiki se aplican sobre los campos `affiliation` y `race` del JSON actual, sin depender de las antiguas rutas por saga.
- `CharacterMapping.swift` adapta el modelo recibido desde la API al modelo que ya utilizan las vistas, manteniendo compatible la interfaz existente.
- `FavoritesViewModel` admite inyección del servicio de personajes, lo que reduce el acoplamiento y facilita futuras pruebas.
- Los nuevos servicios, modelos y archivos de red se han incorporado correctamente al target principal de Xcode.

### Interfaz, búsqueda y rendimiento

- La búsqueda de personajes ignora mayúsculas, minúsculas y espacios innecesarios.
- Los errores de carga dejan de mostrarse únicamente en la consola y pasan a estar disponibles para la interfaz.
- Se elimina un fondo duplicado en la vista principal y se corrige el texto de la pestaña «Opciones».
- Las imágenes de la vista de detalle conservan ahora su proporción original mediante `.scaledToFit()`, evitando que los personajes aparezcan ensanchados o aplastados.
- El análisis de colores de las imágenes evita accesos forzados que podían cerrar la app.
- El procesamiento intensivo de píxeles se ejecuta fuera del actor principal usando datos seguros para concurrencia, mientras las actualizaciones visuales permanecen en el actor principal.

## APIs utilizadas

La wiki y los favoritos consumen `https://dragonball-api.com/api/characters`, una API pública que devuelve JSON mediante peticiones GET y no requiere clave para estas consultas.

La sesión, los IDs de los favoritos y las salas online se gestionan con el backend Vapor del propio proyecto, en la dirección configurada en `BackendBaseURL`.

El código conserva algunas implementaciones históricas comentadas que hacen referencia a `www.dragonballapi.com` y `apidragonball.vercel.app`, pero ya no forman parte del flujo utilizado por las cartas.

## Organización del proyecto

- `Model`: modelos de personajes, audio y juegos.
- `Service`: acceso a las APIs, red, Google Sign-In y cliente del backend Vapor.
- `View`: vistas SwiftUI de la wiki, favoritos, reproductor, perfil y juegos.
- `ViewModel`: estado y lógica de presentación, incluidas las vistas de los juegos.
- `Tools`: protocolos, extensiones, recursos, fuentes y utilidades compartidas.
- `Backend`: servidor Vapor (`Sources/App`), motor de reglas compartido de las cartas (`Sources/CardRules`) y sus pruebas.
- `docs`: arquitectura, configuración, desarrollo, despliegue, cartas y próximas ampliaciones.
- `Tests` y `scripts`: pruebas de regresión de la app y el script que las ejecuta.

## Requisitos

- iOS 18 o posterior.
- Swift 6 para la app y Swift 6.2 o posterior para el backend.
- Xcode con soporte para Swift 6 e iOS 18.
- Conexión a internet para resolver las dependencias y consultar las APIs.
- Para el modo online: PostgreSQL (Neon), una cuenta de Vercel y un cliente OAuth de Google propio.

La app utiliza Swift Package Manager para resolver Google Sign-In y Kingfisher. El backend depende de Vapor, Fluent, el driver de PostgreSQL y JWTKit.

## Abrir y compilar el proyecto

1. Clona el repositorio.
2. Abre `DragonBallSwift.xcodeproj` con Xcode.
3. Espera a que Swift Package Manager resuelva las dependencias.
4. Selecciona el esquema `DragonBallSwift` y un simulador compatible con iOS 18.
5. Compila el proyecto con **Product > Build**.

La rama `refactorizacion` se ha comprobado con Xcode 26.6, Swift 6 y el simulador iPhone 17 Pro Max. El proyecto completó correctamente la compilación del esquema `DragonBallSwift` el 8 de septiembre de 2026.

Para el backend:

```sh
cd Backend
swift test                     # pruebas con SQLite en memoria
cp .env.example .env           # configura DATABASE_URL y GOOGLE_CLIENT_ID
swift run Run migrate --yes    # crea las tablas una sola vez
swift run Run serve
```

Para probar el login, los favoritos o el modo online desde la app, apunta `BackendBaseURL` en `DragonBallSwift/Info.plist` a tu servidor.

## Cómo contribuir

1. Haz un **fork** de este repositorio en tu cuenta de GitHub.
2. **Clona** el repositorio en tu máquina local.
3. Crea una rama para tus cambios.
4. Implementa la corrección o funcionalidad y comprueba que el proyecto compila.
5. Haz **commit** y **push** de tus cambios en tu repositorio.
6. Crea una **Pull Request (PR)** desde tu rama hacia este repositorio.

## Herramientas y tecnologías

- **Xcode**: entorno de desarrollo principal.
- **Swift 6**: lenguaje de programación.
- **SwiftUI**: interfaz de usuario.
- **Swift Package Manager**: gestión de dependencias.
- **Vapor y Fluent**: backend en Swift para sesiones, favoritos y salas online.
- **PostgreSQL (Neon)**: base de datos del backend.
- **Vercel**: despliegue del backend como imagen de contenedor.
- **Google Sign-In**: acceso mediante cuenta de Google.
- **Kingfisher**: carga y caché de imágenes remotas.
- **Git y GitHub**: control de versiones y colaboración.
- **Trello**: seguimiento y organización del proyecto.

## Seguimiento del proyecto

Utilizamos Trello para organizar el trabajo. Puedes consultar [el tablero del proyecto](https://trello.com/b/M1vlLvRz/proyecto-dragon-ball-app). Si quieres colaborar, solicita acceso al Kanban en el grupo de estudio.

## Contacto

Si tienes alguna pregunta o sugerencia, puedes escribir en el grupo de estudio de la comunidad MoureDev: [Proyecto colaborativo Apps Swift y Kotlin](https://discord.com/channels/729672926432985098/1244617601729171496).

¡Esperamos ver tus contribuciones pronto!

## Capturas de pantalla

<img width="273" alt="Captura de pantalla 2024-07-27 a las 21 46 332" src="https://github.com/user-attachments/assets/5286b8ce-85df-4679-99de-fb63c737d107">
<img width="273" alt="Captura de pantalla 2024-07-27 a las 21 46 41" src="https://github.com/user-attachments/assets/8f7cd693-d9fe-4b27-a541-8b10a0945f04">
<img width="273" alt="Captura de pantalla 2024-07-27 a las 21 46 52" src="https://github.com/user-attachments/assets/43ca5a4b-678c-48d9-baab-55864e2b189d">

### Versión de iOS y Android

<img width="427" alt="Captura de pantalla 2024-07-27 a las 21 42 28" src="https://github.com/user-attachments/assets/9fe61197-023d-4c17-8ab6-35eb0bff5551">
