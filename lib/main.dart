import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir interfaces gráficas.
import 'dart:async'; // Importa la biblioteca para manejar temporizadores.
import 'dart:math'; // Importa la biblioteca para generar números aleatorios.

void main() => runApp(MyApp()); // Función principal que ejecuta la aplicación.

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor de la clase MyApp.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de "debug".
      home: HomePage(), // Define la pantalla principal de la aplicación.
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor de la clase HomePage.

  @override
  HomePageState createState() =>
      HomePageState(); // Crea el estado asociado a HomePage.
}

class HomePageState extends State<HomePage> {
  static List<int> snakePosition = [
    45,
    65,
    85,
    105,
    125
  ]; // Lista con las posiciones iniciales de la serpiente.
  int numberOfSquares = 760; // Número total de cuadros en la cuadrícula.

  static var randomNumber =
      Random(); // Instancia para generar números aleatorios.
  int food =
      randomNumber.nextInt(700); // Posición inicial aleatoria de la comida.

  // Genera una nueva posición aleatoria para la comida.
  void generateNewFood() {
    food = randomNumber.nextInt(700);
  }

  // Inicia el juego.
  void startGame() {
    snakePosition = [
      45,
      65,
      85,
      105,
      125
    ]; // Restablece la posición de la serpiente.
    const duration = Duration(
        milliseconds: 300); // Intervalo de actualización de la serpiente.

    // Crea un temporizador que ejecuta la función updateSnake periódicamente.
    Timer.periodic(duration, (Timer timer) {
      updateSnake(); // Mueve la serpiente.

      if (gameOver()) {
        // Verifica si el juego ha terminado.
        timer.cancel(); // Detiene el temporizador.
        _showGameOverScreen(); // Muestra la pantalla de Game Over.
      }
    });
  }

  var direction = 'down'; // Dirección inicial de la serpiente.

  // Actualiza la posición de la serpiente.
  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 740) {
            // Si llega al borde inferior, reaparece en la parte superior.
            snakePosition.add(snakePosition.last + 20 - 760);
          } else {
            snakePosition.add(snakePosition.last + 20); // Mueve hacia abajo.
          }
          break;

        case 'up':
          if (snakePosition.last < 20) {
            // Si llega al borde superior, reaparece abajo.
            snakePosition.add(snakePosition.last - 20 - 760);
          } else {
            snakePosition.add(snakePosition.last - 20); // Mueve hacia arriba.
          }
          break;

        case 'left':
          if (snakePosition.last % 20 == 0) {
            // Si llega al borde izquierdo, reaparece en el derecho.
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition
                .add(snakePosition.last - 1); // Mueve hacia la izquierda.
          }
          break;

        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            // Si llega al borde derecho, reaparece en el izquierdo.
            snakePosition.add(snakePosition.last + 1 + 20);
          } else {
            snakePosition
                .add(snakePosition.last + 1); // Mueve hacia la derecha.
          }
          break;
      }

      if (snakePosition.last == food) {
        // Si la serpiente come la comida.
        generateNewFood(); // Genera nueva comida.
      } else {
        snakePosition.removeAt(
            0); // Elimina el último segmento para simular el movimiento.
      }
    });
  }

  // Verifica si el juego ha terminado.
  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count +=
              1; // Cuenta las veces que un segmento de la serpiente ocupa la misma posición.
        }
        if (count == 2) {
          return true; // Si un segmento colisiona con otro, el juego termina.
        }
      }
    }
    return false;
  }

  // Muestra una alerta cuando el juego termina.
  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('YOU DIED'), // Título de la alerta.
            content: Text(
                'Your score: ${snakePosition.length}'), // Muestra la puntuación.
            actions: <Widget>[
              TextButton(
                child: Text('Play Again'), // Botón para reiniciar el juego.
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo.
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro de la pantalla principal.
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction =
                      'down'; // Cambia la dirección hacia abajo si no estaba yendo hacia arriba.
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction =
                      'up'; // Cambia la dirección hacia arriba si no estaba yendo hacia abajo.
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction =
                      'right'; // Cambia la dirección hacia la derecha si no estaba yendo hacia la izquierda.
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction =
                      'left'; // Cambia la dirección hacia la izquierda si no estaba yendo hacia la derecha.
                }
              },
              child: GridView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Evita que la cuadrícula sea desplazable.
                  itemCount:
                      numberOfSquares, // Número total de cuadros en la cuadrícula.
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          20), // Define la cantidad de columnas en la cuadrícula.
                  itemBuilder: (BuildContext context, int index) {
                    if (snakePosition.contains(index)) {
                      // Si la posición actual es parte de la serpiente.
                      return Center(
                        child: Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors
                                  .white, // Dibuja la serpiente en color blanco.
                            ),
                          ),
                        ),
                      );
                    }
                    if (index == food) {
                      // Si la posición actual es la comida.
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors
                                  .green, // Dibuja la comida en color verde.
                            )),
                      );
                    } else {
                      // Cuadrícula vacía.
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.grey[
                                  900], // Dibuja el fondo de la cuadrícula.
                            )),
                      );
                    }
                  }),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap:
                      startGame, // Inicia el juego cuando se toca el texto "start".
                  child: Text(
                    's t a r t',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Text(
                  '@ c r e a t e d b y k o k o',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
