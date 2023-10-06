# Bomberman X

Bomberman X (¿o era Megaman X?). Implementación en Elixir de la lógica de propagación de explociones del clasico juego Bomberman.

## Funcionalidad


- [x] Lee un laberinto a partir de un `String`.
- [x] Lo carga en memoria, siendo representado con estructuras propias.
- [ ] Detona una bomba en particular.
- [ ] Calcula el estado final del laberinto tras detonar la bomba.
- [x] Lo vuelve a convertir en `String`.

## Laberintos

Los laberintos se representan como una matriz separada por lineas y espacios, donde cada posición contiene un elemento particular. Los elementos són:

- `"Br`: Bomba regular, donde `d` indica el rango
- `"Sr`: Bomba de traspaso, donde `d` indica el rango
- `"Fh`: Enemigo, donde `h` indica la vida
- `"Dd`: Desvio, donde `d` indica una dirección entre `U`, `D`, `L`, `R` (arriba, abajo, izquierda, derecha, respectivamente).
- `"R"`: Roca
- `"W"`: Muro

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