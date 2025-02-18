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
}
