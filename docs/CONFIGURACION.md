# Configuración local

## Xcode y firma

Abre `DragonBallSwift.xcodeproj`, selecciona `DragonBallSwift` y espera a Swift Package Manager. Usa iOS 18 o posterior. Para un dispositivo físico, selecciona tu equipo de desarrollo en los dos targets y utiliza identificadores de bundle propios. La extensión debe usar el mismo prefijo que la app.

Una compilación sin firma se puede comprobar así:

```sh
xcodebuild -project DragonBallSwift.xcodeproj \
  -scheme DragonBallSwift -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath .build/xcode CODE_SIGNING_ALLOWED=NO build
```

Si falla la resolución de paquetes, distingue problemas de conexión, permisos de caché y productos inexistentes antes de cambiar versiones. No borres cachés compartidas ni actualices dependencias a ciegas.

## Vapor y Google

La app usa Google Sign-In para obtener una identidad y la envía al servidor Vapor por HTTPS. Firebase ya no se configura ni se enlaza en el target.

1. Configura un cliente OAuth iOS propio y su URL invertida en `DragonBallSwift/Info.plist`.
2. Configura `GIDClientID` y la misma audiencia en `GOOGLE_CLIENT_ID` del backend.
3. Pon la URL HTTPS de producción en `BackendBaseURL`; el valor de ejemplo no es un servidor publicado.
4. Sigue la [guía de Vercel y Neon](DESPLIEGUE_VERCEL.md) para preparar PostgreSQL y crear las tablas.
5. Comprueba acceso, cancelación, cierre y cambio de cuenta en dispositivo.

Los favoritos requieren sesión; la wiki y los juegos se pueden usar como invitado. Las credenciales del servidor no se incluyen en la app. Las sesiones se guardan en Keychain y caducan a los siete días. Los favoritos de Firebase no se migran automáticamente.

## Recursos

Las canciones se buscan por nombre en `Bundle.main`; `SongsModel` contiene los nombres esperados. Un nombre distinto, un archivo omitido del target o una extensión incorrecta puede impedir cargarlo. La lista vacía no debe cerrar la app.

Las imágenes están en `Tools/Assets.xcassets`; las fuentes y el audio se incluyen como recursos. Antes de quitar duplicados, revisa las referencias en código y las fases Resources de ambos targets. Antes de publicar, registra procedencia y permisos de cada recurso.

## API

La API actual es `https://dragonball-api.com/api`. El catálogo consulta `/characters` con `page` y `limit`; las fichas usan `/characters/{id}`. Estas consultas no incluyen autenticación en el código. El proveedor externo puede cambiar o dejar de responder, por lo que los errores se muestran en la interfaz y las pruebas usan respuestas controladas.
