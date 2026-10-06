# Cartas Dragon Ball — primera implementación

## App

En Juegos aparecen «Cartas Dragon Ball · Contra la máquina» y «Cartas Dragon Ball · Online».
La mesa tiene rivales alrededor, mazo y descarte centrales, y la mano abajo. Los reversos
usan GokuPeque y las caras utilizan los personajes ya incluidos en Assets.xcassets.
Se adapta a orientación vertical y horizontal; una mano de hasta doce cartas se ajusta
al ancho y una mano mayor se desplaza horizontalmente. Es una primera interpretación
del ejemplo visual, sin sus decorados 3D ni animaciones de reparto.

## Reglas

Baraja de 108 cartas, cuatro colores, siete cartas por jugador y cuatro jugadores.
Coincide color o valor; hay salto, reversa, +2, comodín y +4. +4 solo es legal cuando
no se tiene el color activo. Penalizaciones no acumulables. Robar una carta termina
el turno. El aviso de una carta es automático, sin penalización por no pulsar UNO.
Gana quien vacía su mano; no hay puntuación por rondas. Estas variantes son deliberadas
y aparecen en el botón Reglas. Los rivales locales eligen solo cartas legales.

## Motor compartido

Backend/Sources/CardRules contiene BattleCards.swift y OnlineCards.swift. Xcode compila
estos mismos archivos como parte de la app. Vapor importa el módulo CardRules. No hay
dos versiones de las reglas que deban sincronizarse manualmente.

## Salas online

Requieren sesión Google del backend. El anfitrión crea una sala y comparte su código
de diez caracteres; otros tres usuarios distintos se unen. Solo el anfitrión inicia.
Es una versión de cuatro humanos, sin emparejamiento público ni máquinas online.

| Método | Ruta | Función |
| --- | --- | --- |
| POST | /v1/rooms | Crear sala |
| GET | /v1/rooms/:code | Estado privado para un miembro |
| POST | /v1/rooms/:code/join | Unirse o reconectar |
| POST | /v1/rooms/:code/start | Iniciar, solo anfitrión |
| POST | /v1/rooms/:code/actions | Jugar o robar |

La acción contiene version, cardID y color, o draw=true. El servidor comprueba
pertenencia, turno, versión, posesión y legalidad de la carta. Un token de otro usuario
no permite leer la sala. Se envía solo la mano propia, las cantidades de las otras
manos, el descarte y el color; no se expone el orden del mazo.

PostgreSQL conserva la partida completa. Cada modificación bloquea la fila con
SELECT FOR UPDATE dentro de una transacción: las instancias comparten la misma
autoridad de juego. Las versiones evitan duplicar una jugada si se repite una petición.
La app consulta el estado cada dos segundos mientras está en primer plano y deja de
consultar al finalizar. No utiliza WebSockets en esta primera versión.

Las salas caducan a las 24 horas; se limpian al crear otras nuevas. El usuario puede
reconectar introduciendo el mismo código con la misma cuenta. El límite inicial es
cinco salas activas por creador; aún se requiere protección distribuida de tráfico
antes de abrirlo a uso público. No hay sustitución de jugadores desconectados,
temporizador por turno ni expulsión: si alguien se va, debe volver a entrar para
continuar. No hay chat, historial, revancha online ni persistencia de la partida local.

## Configuración y validación pendiente

Ejecutar migraciones añade card_rooms a las tablas anteriores. No se han ejecutado
migraciones contra Neon, configurado secretos ni desplegado esta copia. BackendBaseURL
sigue siendo un ejemplo. Para probar online hacen falta DATABASE_URL, GOOGLE_CLIENT_ID
y una URL HTTPS real en la app. El Dockerfile incluye el módulo CardRules al copiar Sources.

Se verificó compilación del backend y ocho pruebas XCTest: login/favoritos, expiración
y aislamiento de salas, privacidad y persistencia del estado, cartas especiales,
jugadas rechazadas y 100 partidas completas conservando las 108 cartas.
Los tests HTTP usan SQLite y verifican creación y lectura: NO validan los bloqueos
PostgreSQL ni todo el flujo join/start/actions. Esto exige una base de prueba real.

La nueva pantalla y los modelos compartidos pasan comprobación de tipos contra el
SDK iOS 18 (servicios de la app sustituidos por dobles de prueba para esa comprobación).
El proyecto Xcode es un plist válido y registra todos los archivos nuevos.
La compilación completa se bloqueó por permisos en la caché de dependencias de Xcode;
CoreSimulator tampoco estuvo disponible. No se afirma que la app completa haya
compilado ni que la interfaz se haya probado en un iPhone.

Vercel documenta Container Images en beta para todos los planes y detección de
Dockerfile.vercel. Es compatible con este planteamiento de peticiones HTTP y estado
externo, pero el despliegue concreto aún no se ha comprobado.
Fuente revisada: https://vercel.com/docs/functions/container-images
