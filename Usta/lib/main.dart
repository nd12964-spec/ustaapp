import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'icons.dart';
import 'screens.dart';
import 'theme.dart';
import 'widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const UstaApp());
}

class UstaApp extends StatelessWidget {
  const UstaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usta',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tab = 0;

  void _go(int index) {
    if (index == _tab) return;
    HapticFeedback.selectionClick();
    setState(() => _tab = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.paper,
      body: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: GridPainter(color: C.grid))),
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _tab,
              children: [
                const HomeScreen(),
                const ProjectScreen(),
                const SizedBox.shrink(),
                ChatsScreen(onFindMaster: () => _go(0)),
                const ProfileScreen(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AiFab(
        onTap: () {
          HapticFeedback.mediumImpact();
          showAiSheet(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(index: _tab, onSelect: _go),
    );
  }
}

/// Центральная круглая оранжевая кнопка ИИ.
class AiFab extends StatelessWidget {
  const AiFab({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'ИИ-помощник',
      excludeSemantics: true,
      child: Container(
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: C.orange,
          border: Border.all(color: C.white, width: 5),
          boxShadow: const [BoxShadow(color: Color(0x61FF6A13), blurRadius: 20, offset: Offset(0, 8))],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: const Center(child: Ic('spark', size: 26, stroke: 2)),
          ),
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  Widget _item(int i, String icon, String label) {
    final active = i == index;
    final color = active ? C.ink : C.muted;
    return Expanded(
      child: Semantics(
        button: true,
        selected: active,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          onTap: () => onSelect(i),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ic(icon, size: 24, color: color, stroke: active ? 2.1 : 1.75),
              const SizedBox(height: 4),
              Text(label, style: ts(11.5, w: active ? 700 : 500, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: C.white,
      child: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.line))),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(
              children: [
                _item(0, 'home', 'Главная'),
                _item(1, 'setsquare', 'Проект'),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: ExcludeSemantics(child: Text('ИИ', style: ts(11.5, w: 700))),
                    ),
                  ),
                ),
                _item(3, 'chat', 'Чаты'),
                _item(4, 'user', 'Профиль'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
