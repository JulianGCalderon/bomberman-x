# Bomberman X

Bomberman X (¿o era Megaman X?). Implementación en Elixir de la lógica de propagación de explosiones del clasico juego Bomberman.

## Ejecución

Para ejecutarlo, utilizaremos MIX

```bash
$ mix run main.ex INPUT_BOARD OUTPUT_BOARD BOMB_X BOMB_Y
```

Como entrada, podemos utilizar los tableros de la carpeta `boards`. Por ejemplo,
podriamos ejecutar:

```bash
$ mix run main.ex ./boards/detour.txt ./output.txt 0 0
```

## Funcionalidad


- Lee un laberinto a partir de un `String`.
- Lo carga en memoria, siendo representado con estructuras propias.
- Detona una bomba en particular.
- Calcula el estado final del laberinto tras detonar la bomba.
- Lo vuelve a convertir en `String`.

Nota: en el juego original las rocas pueden ser destruidas con bombas. Aquí no ocurre.

## Laberintos

Los laberintos se representan como una matriz separada por lineas y espacios, donde cada posición contiene un elemento particular. Los elementos són:

- `_`: Vacío
- `R`: Roca
- `W`: Muro
- `Br`: Bomba regular, donde `r` indica el rango.
- `Sr`: Bomba de traspaso, donde `r` indica el rango.
- `Fh`: Enemigo, donde `h` indica la vida.
- `Dd`: Desvio, donde `d` indica una dirección entre `U`, `D`, `L`, `R`.


Luego, los tableros pueden verse como:

```
B2 R R _ F1 _ _
_ W R W _ W _
B5 _ _ _ B2 _ _
_ W _ W _ W _
DR _ DU _ _ _ _
S3 W _ W _ W _
_ _ _ _ _ _ _
```
