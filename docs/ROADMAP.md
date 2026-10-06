# Próximas ampliaciones

Este documento describe trabajo propuesto. No añade Super ni un nuevo juego al código actual.

## Dragon Ball Super

Primero debe existir una clasificación editorial de contenido, independiente de raza y afiliación. El catálogo de la API no basta para decidir qué personajes pertenecen a una serie o a un arco.

Propuesta de modelos:

- `Series`: serie y continuidad.
- `StoryArc`: serie, nombre y orden.
- `Appearance`: relación personaje–arco, papel y transformaciones presentes.
- `AssetReference`: imagen, procedencia, atribución y permiso de uso.

Un personaje puede aparecer en varios arcos sin duplicar su identidad o favoritos. Se deben distinguir anime, manga y películas.

Para la primera entrega, comprobar cobertura y datos de Beerus, Whis, Champa, Vados, Hit, Cabba, Caulifla, Kale, Goku Black, Zamasu, Jiren y Toppo, además de las apariciones de personajes existentes. Los datos que falten pueden venir de un paquete JSON editorial versionado con IDs internos estables y una correspondencia explícita con la API.

La interfaz propuesta es **Series → Super → Arcos**, con filtros por universo. Antes de importar datos de otra API, hay que definir cómo migrar IDs y favoritos. Conviene añadir un repositorio compartido con caché y un estado offline.

## Juego de cartas: Duelo de energía

Nombre provisional, pendiente de comprobar disponibilidad. El objetivo es crear un juego sencillo por turnos con decisiones propias, sin reproducir literalmente UNO.

- Primera versión: jugador contra bot.
- Mano inicial de cinco cartas y dos puntos de energía; máximo de seis.
- Cada turno se roba una carta, se recupera energía y se elige cargar o desplegar una técnica.
- Tres zonas de combate con objetivos. Las técnicas tienen coste y efectos de ataque, defensa o apoyo.
- Tras tres turnos por jugador se resuelven las zonas. Controlar dos concede un punto; tres puntos ganan la partida.
- Vaciar la mano no termina la partida. Las transformaciones mejoran cartas desplegadas y los combos tienen límites.

El motor debe ser independiente de SwiftUI y el backend: `CardDefinition`, `CardInstance`, `GameState`, `GameAction`, `RulesEngine` y `BotStrategy`. Usará aleatoriedad con semilla, validación de acciones y versión de reglas. Primero se probarán legalidad de jugadas, conservación de cartas, costes, desempates y fin de partida. El multijugador necesitaría una autoridad que valide acciones y mantenga ocultas las manos rivales.

La ilustración es una capa temática reemplazable. Las estadísticas se equilibran para el juego, sin convertir directamente el Ki de la API en poder de carta.

## Derechos y publicación

El acceso a la API no concede una licencia sobre personajes, imágenes o música. Los [créditos de Toei](https://www.toei-animation.com/copyrights/) identifican derechos de la franquicia; hay que comprobar autorizaciones adecuadas antes de distribuir.

UNO tiene protección de marca y elementos de presentación. No se propone usar su nombre, logo, diseño de cartas ni texto de reglas. La [OMPI](https://www.wipo.int/en/web/copyright/protection) distingue las ideas de su expresión concreta, pero una mecánica diferenciada no elimina los derechos sobre Dragon Ball. La alternativa publicable sin esas licencias sería una temática y arte originales. Apple también exige respetar [propiedad intelectual, apartado 5.2](https://developer.apple.com/app-store/review/guidelines/).

## Orden sugerido

1. Validar sesión, favoritos y fichas con el backend de desarrollo.
2. Completar accesibilidad y pruebas de interfaz; revisar recursos duplicados y sus permisos.
3. Añadir caché compartida e identidad estable de contenido.
4. Implementar series y arcos de Super con datos verificados.
5. Prototipar y equilibrar el juego local.
6. Evaluar publicación y multijugador cuando el prototipo esté validado.
