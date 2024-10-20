import 'package:flutter/material.dart';

class NoNotifications extends StatelessWidget {
  const NoNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80),
          Container(
            width:
                MediaQuery.of(context).size.width * 0.8, // Ancho del contenedor
            padding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16), // Relleno vertical y horizontal
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Fondo gris claro
              border: Border.all(
                color: Colors.black, // Línea negra alrededor del contenedor
                width: 2, // Grosor de la línea
              ),
              borderRadius: BorderRadius.circular(10), // Bordes redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Color de la sombra
                  spreadRadius: 1, // Radio de expansión de la sombra
                  blurRadius: 8, // Radio de difuminado de la sombra
                  offset: Offset(0, 4), // Desplazamiento de la sombra
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Notificaciones',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Alineación del texto
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount:
                  3, // Número de notificaciones predeterminadas (puedes ajustar esto)
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Cambia la posición de la sombra
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/notification_image.png'), // Ruta de tu imagen
                        radius: 20, // Radio del círculo
                        backgroundColor:
                            Colors.transparent, // Fondo transparente
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notificación N°$index', // Ajusta según tu modelo
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Aviso de nuevas rutas creadas, Huánuco promueve.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.red), // Tacho de basura
                                  onPressed: () {
                                    // Acción al presionar el ícono
                                    // Puedes agregar la lógica para eliminar la notificación aquí
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
