import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class BottomMenuBar extends StatefulWidget {
  const BottomMenuBar({Key? key}) : super(key: key);

  @override
  State<BottomMenuBar> createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.notification_add_outlined,
    Icons.menu_book,
    Icons.emoji_people,
    Icons.bar_chart,
  ];

  _buildIcon(int index) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        bool isSelected = appState.pageIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            switch (_selectedIndex) {
              case 0:
                appState.setpageIndex = 0;
                Navigator.pushReplacementNamed(context, '/Passport');
                break;
              case 1:
                appState.setpageIndex = 1;
                Navigator.pushReplacementNamed(context, '/Notifications');
                break;
              case 2:
                appState.setpageIndex = 2;
                Navigator.pushReplacementNamed(context, '/Home');
                break;
              case 3:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Próximamente'),
                    duration: Duration(seconds: 2),
                  ),
                );
                break;
              case 4:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Próximamente'),
                    duration: Duration(seconds: 2),
                  ),
                );
                break;
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40.0, // Ajusta la altura del contenedor del ícono
                width: 40.0, // Ajusta el ancho del contenedor del ícono
                child: Icon(
                  _icons[index],
                  size: isSelected
                      ? 30.0
                      : 25.0, // Agranda el ícono si está seleccionado
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              if (isSelected)
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      4.0), // Ajusta el radio de los bordes
                  child: Container(
                    width: 40.0,
                    height: 8.0,
                    color: Colors
                        .black, // Barra negra debajo del ícono seleccionado
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize:
          Size.fromHeight(40), // Ajusta la altura de la barra de navegación
      child: BottomAppBar(
        color: Colors.grey.withOpacity(0.9),
        elevation: 0.0,
        child: Container(
          // Asegura la altura del contenedor de la barra de navegación
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildIcon(0),
              _buildIcon(1),
              _buildIcon(2),
              _buildIcon(3),
              _buildIcon(4),
            ],
          ),
        ),
      ),
    );
  }
}
