# Backend de Dragon Ball Swift

API escrita en Swift con Vapor. Sustituye Firebase Authentication y Firestore en el flujo de sesión y favoritos. Incluye salas privadas para el juego de cartas; el motor de reglas se comparte con la app. El catálogo sigue consultando la API externa desde la app. Super continúa pendiente. Consulta [el estado de las cartas](../docs/CARTAS.md) antes de publicar el modo online.

## Requisitos

- Swift 6.2 o posterior.
- PostgreSQL. Para internet, una cuenta gratuita de Neon.
- Cuenta Vercel Hobby para uso personal no comercial.
- Credenciales OAuth de Google para la app iOS.

## Ejecutar y probar

```sh
cd Backend
swift test
```

Las pruebas usan SQLite en memoria; no requieren cuentas externas. Cubren autenticación, expiración, revocación y aislamiento de favoritos. No sustituyen una prueba contra PostgreSQL ni el despliegue real.

Para arrancar, copia `.env.example` a `.env` y configura tus valores. Vapor lee `.env` en desarrollo; no lo publiques. Crea las tablas una sola vez:

```sh
swift run Run migrate --yes
swift run Run serve
```

En producción las variables se configuran en Vercel. `AUTO_MIGRATE=false` evita que varias instancias intenten migrar a la vez. Las migraciones deben ejecutarse con una conexión directa a Neon antes de publicar. Para una prueba local se puede usar `AUTO_MIGRATE=true`.

## Contrato HTTP

Todas las respuestas con datos usan JSON. Las rutas privadas requieren `Authorization: Bearer <token>`.

| Método | Ruta | Comportamiento |
|---|---|---|
| GET | `/health` | Comprueba el proceso, sin despertar PostgreSQL |
| POST | `/v1/auth/google` | Recibe `{"idToken":"..."}` y crea una sesión |
| GET | `/v1/me` | Devuelve el ID del usuario autenticado |
| DELETE | `/v1/auth/session` | Revoca la sesión actual; responde 204 |
| GET | `/v1/favorites` | Devuelve `[{"characterID":7}]` de la cuenta actual |
| PUT | `/v1/favorites/7` | Añade el favorito de forma idempotente; responde 204 |
| DELETE | `/v1/favorites/7` | Elimina el favorito de forma idempotente; responde 204 |

La respuesta de login contiene `userID`, `token` y `expiresAt` (segundos Unix). Una sesión dura siete días. No se almacenan contraseñas, email ni el token de Google. La app vuelve a ofrecer login cuando la sesión deja de ser válida.

## Seguridad y persistencia

El servidor verifica la firma de Google con sus claves públicas, el emisor, la caducidad y la audiencia OAuth configurada. Las claves se mantienen en caché y se renuevan periódicamente. Las sesiones usan 32 bytes aleatorios y solo su hash SHA-256 se guarda en PostgreSQL; cerrar sesión elimina ese hash. Nunca registres tokens ni URLs con contraseñas.

Cada consulta privada obtiene el usuario de la sesión, nunca de un ID enviado por el cliente. Una restricción única impide favoritos duplicados. El ID del personaje se valida como entero positivo; no se verifica su existencia en la API externa. La base conserva los datos al detenerse el contenedor. No hay SQLite local en producción.

El código no incorpora un límite distribuido de peticiones. Antes de abrir el servicio a tráfico amplio, configura y verifica la protección disponible en Vercel, limita intentos de login y revisa el consumo. No actives complementos de pago para ello. La lista de favoritos no está paginada; es una ampliación necesaria para cuentas con colecciones grandes.

## Vercel y coste

`Dockerfile.vercel` compila el ejecutable en una imagen de Swift 6.2 y lo ejecuta como usuario sin privilegios. Se usa la misma imagen en ambas etapas para conservar las bibliotecas del runtime. Puede optimizarse su tamaño después de verificar el primer despliegue.

Vercel documenta Container Images en beta para todos los planes. La dirección HTTPS y el certificado los facilita Vercel. Los datos deben vivir en Neon. El plan Hobby es solo para uso personal no comercial; gratis significa dentro de las cuotas vigentes, no disponibilidad ilimitada garantizada.

No se ha contratado ningún servicio ni publicado una instancia. Sigue la [guía de despliegue](../docs/DESPLIEGUE_VERCEL.md).
