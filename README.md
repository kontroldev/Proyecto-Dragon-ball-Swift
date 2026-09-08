# Proyecto colaborativo de una app de Dragon Ball en Swift

¡Bienvenido al Proyecto Colaborativo de Dragon Ball! Este es un proyecto abierto en el que todos pueden contribuir. Si eres fan de Dragon Ball y tienes experiencia o ganas de aprender Swift, nos encantará contar con tu ayuda.

También puedes consultar [la versión del proyecto en Kotlin](https://github.com/juanppdev/dragon-ball-app).

## Funcionalidades principales

- Wiki de personajes organizada por sagas: Dragon Ball, Dragon Ball Z, Dragon Ball GT, Dragon Ball Super y Dragones.
- Buscador de personajes y sección de favoritos.
- Autenticación y persistencia de favoritos mediante Firebase.
- Reproductor de música.
- Minijuegos de memoria y Tetris.
- Interfaz creada con SwiftUI y adaptada a los modos claro y oscuro.

## Refactorización actual

La rama `refactorizacion` moderniza la obtención de datos y corrige varios problemas de estabilidad sin eliminar las funcionalidades existentes del proyecto.

### Red, modelos y favoritos

- Se incorpora un cliente de red reutilizable basado en protocolos para desacoplar las peticiones de `URLSession`.
- Los errores de URL, conexión, respuesta HTTP y decodificación se conservan y se traducen en mensajes comprensibles para la interfaz.
- La carga de favoritos deja de realizar cinco peticiones, una por saga, y utiliza una única petición al listado de personajes de [Dragon Ball API](https://dragonball-api.com).
- `CharacterMapping.swift` adapta el modelo recibido desde la API al modelo que ya utilizan las vistas, manteniendo compatible la interfaz existente.
- `FavoritesViewModel` admite inyección del servicio de personajes, lo que reduce el acoplamiento y facilita futuras pruebas.
- Los nuevos servicios, modelos y archivos de red se han incorporado correctamente al target principal de Xcode.

### Interfaz, búsqueda y rendimiento

- La búsqueda de personajes ignora mayúsculas, minúsculas y espacios innecesarios.
- Los errores de carga dejan de mostrarse únicamente en la consola y pasan a estar disponibles para la interfaz.
- Se elimina un fondo duplicado en la vista principal y se corrige el texto de la pestaña «Opciones».
- El análisis de colores de las imágenes evita accesos forzados que podían cerrar la app.
- El procesamiento intensivo de píxeles se ejecuta fuera del actor principal usando datos seguros para concurrencia, mientras las actualizaciones visuales permanecen en el actor principal.

## APIs utilizadas

Actualmente conviven dos formatos de datos:

- El nuevo flujo de favoritos utiliza `https://dragonball-api.com/api/characters`.
- Las vistas organizadas por saga conservan temporalmente la integración anterior mediante rutas como `https://www.dragonballapi.com/dragonball` y `https://www.dragonballapi.com/dragonballz`.

La API de comunidad documentada originalmente por el proyecto puede consultarse en [www.dragonballapi.com](https://www.dragonballapi.com) y se atribuye a [Juan Pablo](https://github.com/juanppdev).

El repositorio también conserva implementaciones históricas que hacen referencia a `https://apidragonball.vercel.app`. No forman parte del nuevo flujo de favoritos y deberán revisarse si se completa la migración de todas las sagas a una única API.

## Organización del proyecto

- `Model`: modelos de personajes, audio y juegos.
- `Service`: acceso a las APIs, red, Firebase Authentication y Firestore.
- `View`: vistas SwiftUI de la wiki, favoritos, reproductor, perfil y juegos.
- `ViewModel`: estado y lógica de presentación.
- `Tools`: protocolos, extensiones, recursos, fuentes y utilidades compartidas.

## Requisitos

- iOS 18 o posterior.
- Swift 6.
- Xcode con soporte para Swift 6 e iOS 18.
- Conexión a internet para resolver las dependencias y consultar las APIs.

El proyecto utiliza Swift Package Manager para resolver, entre otras dependencias, Firebase, Google Sign-In y Kingfisher.

## Abrir y compilar el proyecto

1. Clona el repositorio.
2. Abre `DragonBallSwift.xcodeproj` con Xcode.
3. Espera a que Swift Package Manager resuelva las dependencias.
4. Selecciona el esquema `DragonBallSwift` y un simulador compatible con iOS 18.
5. Compila el proyecto con **Product > Build**.

La rama `refactorizacion` se ha comprobado con Xcode 26.6, Swift 6 y el simulador iPhone 17 Pro Max. El proyecto completó correctamente la compilación del esquema `DragonBallSwift` el 8 de septiembre de 2026.

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
- **Firebase**: autenticación, Firestore y almacenamiento.
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
