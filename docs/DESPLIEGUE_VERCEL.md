# Desplegar Vapor en Vercel sin un plan de pago

## Estado

El código se prepara para Vercel Container Images, una función en beta. La publicación y prueba real necesitan tu cuenta Vercel y una base Neon. No se ha creado un proyecto remoto ni añadido una tarjeta. No es posible garantizar que las condiciones gratuitas de terceros se mantengan indefinidamente.

## 1. Crear PostgreSQL en Neon

1. Regístrate en [Neon](https://console.neon.tech/) y conserva el plan **Free**, sin añadir tarjeta.
2. Crea un proyecto. Elige una región cercana al despliegue de Vercel.
3. Copia la conexión PostgreSQL desde **Connect** con SSL requerido.
4. Usa la conexión con pool (`-pooler` en el host) para `DATABASE_URL` en Vercel.
5. Conserva también la conexión directa para ejecutar las migraciones. No pegues ninguna conexión en chats ni archivos públicos.

El plan gratuito tiene límites de almacenamiento y cómputo. Comprueba los que aparecen en tu cuenta. Exporta copias de PostgreSQL a tu equipo; no se incluye una copia externa automática. No usamos la base gratuita de Render que caduca a los treinta días.

## 2. Configurar Google

En [Google Cloud Console](https://console.cloud.google.com/), configura OAuth para tu app iOS y su bundle ID. Puedes conservar el cliente OAuth existente si eres su propietario y la configuración corresponde a la app. No necesitas activar Firebase.

- Pon el ID del cliente iOS en `GIDClientID` de `DragonBallSwift/Info.plist`.
- Ajusta `CFBundleURLSchemes` con el ID invertido de ese mismo cliente.
- En el servidor, `GOOGLE_CLIENT_ID` debe coincidir con ese ID. Si añades otras plataformas, deberán validarse sus audiencias expresamente.
- Si la pantalla de consentimiento está en modo de prueba, añade las cuentas autorizadas de prueba.

Los IDs incluidos se heredan del proyecto original: no prueban que tengas acceso a su cuenta Google. Configura los tuyos antes de probar el login.

## 3. Crear tablas

En `Backend`, crea `.env` desde `.env.example` con la conexión **directa** y el ID de Google. Con Swift 6.2 o posterior:

```sh
cd Backend
swift test
swift run Run migrate --yes
```

Haz esto antes de desplegar. Para futuras migraciones, guarda una copia y ejecuta cada cambio una vez. No ejecutes `migrate --revert` sobre datos que quieras conservar. `AUTO_MIGRATE` permanece en `false` en Vercel.

## 4. Publicar en Vercel Hobby

El paquete entregado no se ha subido a GitHub. Puedes desplegar la carpeta `Backend` desde tu equipo con Vercel CLI, o publicar tú el código en un repositorio e importarlo. No importes el repositorio original esperando que contenga estos cambios locales.

1. Mantén el plan **Hobby**. No actives una prueba Pro ni complementos de pago.
2. Selecciona `Backend` como carpeta raíz del proyecto; Framework Preset: **Other**.
3. El archivo `Dockerfile.vercel` se detecta automáticamente. El servidor escucha `0.0.0.0` en `PORT` (8080 por defecto).
4. Configura estas variables para Production y, si las utilizas, Preview:

| Variable | Valor |
|---|---|
| `DATABASE_URL` | Conexión privada de Neon con pool y `sslmode=require` |
| `GOOGLE_CLIENT_ID` | ID OAuth de la app iOS |
| `AUTO_MIGRATE` | `false` |
| `PORT` | `8080` |

5. Despliega y consulta `/health`. No debe requerir autenticación.
6. Si el registro pide tarjeta o un plan de pago, detente: no cumple el requisito de este proyecto.

Con CLI, desde `Backend`:

```sh
vercel login
vercel link
vercel env add DATABASE_URL production
vercel env add GOOGLE_CLIENT_ID production
vercel env add AUTO_MIGRATE production
vercel env add PORT production
vercel deploy --prod
```

Introduce secretos en los prompts privados. Las variables Preview pueden apuntar a una base de pruebas distinta; no compartas producción con pruebas destructivas. No desactives globalmente protecciones de Vercel. El endpoint de producción debe poder recibir las peticiones de la app sin una sesión del navegador.

## 5. Conectar el iPhone

Pon `https://TU_PROYECTO.vercel.app` en `BackendBaseURL` de `DragonBallSwift/Info.plist`, sin añadir `/v1`. El ejemplo deliberado `YOUR_PROJECT` provoca un mensaje de configuración, en lugar de enviar credenciales a un destino inventado. La app acepta únicamente HTTPS.

Comprueba en dispositivo:

1. Navegar como invitado.
2. Cancelar el acceso de Google.
3. Iniciar sesión y guardar un favorito.
4. Cerrar y volver a abrir la app: se restaura la sesión desde Keychain.
5. Cerrar sesión y comprobar que el token anterior obtiene 401.
6. Entrar con otra cuenta y verificar que no aparecen favoritos ajenos.
7. Probar sin red y tras un arranque en frío del servidor.

## Datos antiguos de Firebase

Los favoritos antiguos permanecen en Firestore; no se han leído, eliminado ni migrado. La nueva base comienza vacía. Para importarlos hay que vincular el usuario Firebase a su identidad Google verificada y conservar los IDs de personaje. No se deben vincular cuentas solo por un email enviado por el cliente. Esta importación requiere acceso autorizado al proyecto antiguo y una copia de sus datos.

## Límites y mantenimiento

- Hobby es para proyectos personales no comerciales. Si monetizas la app, revisa la elegibilidad antes de hacerlo.
- Las instancias pueden detenerse; no guardes partidas, archivos o sesiones solo en memoria o en disco del contenedor.
- Neon puede suspender cómputo inactivo y tiene cuotas. La app tolera tiempos de arranque mayores con un plazo de petición de 90 segundos, sin reintentos automáticos que multipliquen escrituras.
- Revisa cuotas, errores y actualizaciones de dependencias. No mantengas el servicio artificialmente despierto para eludir límites.
- Las funciones beta, una cuenta gratuita o la ausencia de tarjeta no equivalen a un compromiso de disponibilidad permanente.

Fuentes: [Container Images](https://vercel.com/docs/functions/container-images), [Vercel Hobby](https://vercel.com/docs/plans/hobby), [Neon Free](https://neon.com/pricing).
