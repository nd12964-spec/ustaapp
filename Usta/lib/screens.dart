import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'icons.dart';
import 'theme.dart';
import 'widgets.dart';

void openStage(BuildContext context, int index) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => StageScreen(index: index)));
}

void startDemoProject(BuildContext context, String type) {
  HapticFeedback.mediumImpact();
  app.startProject(type);
  showSoon(context, 'Проект «${app.projectName}» создан. Это демо: этапы пока как у дома');
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Салам, Диас', style: ts(26, w: 700, h: 1.2, ls: -0.5)),
                Tap(
                  minHeight: 40,
                  onTap: () => showSoon(context, 'Пока работаем только в Бишкеке'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Ic('pin', size: 18, color: C.muted),
                      const SizedBox(width: 6),
                      Text('Бишкек', style: ts(15, w: 500, color: C.muted)),
                      const SizedBox(width: 4),
                      const Ic('chevDown', size: 16, color: C.muted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Tap(
            color: C.white,
            radius: 16,
            border: Border.all(color: C.line),
            semanticLabel: 'Уведомления',
            onTap: () => showSoon(context, 'Уведомления появятся вместе с заказами'),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                children: [
                  const Center(child: Ic('bell', size: 22)),
                  Positioned(
                    top: 10,
                    right: 11,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: C.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: C.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        final stage = stages[app.currentStage];
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeader(),
              const Padding(padding: EdgeInsets.fromLTRB(20, 14, 20, 0), child: AiPanel()),
              const SizedBox(height: 28),
              if (app.hasProject) ...[
                const SectionHeader('Мой проект'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ProjectCard(onOpenStage: (i) => openStage(context, i)),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StartProjectCard(onPick: (t) => startDemoProject(context, t)),
                ),
              const SizedBox(height: 32),
              SectionHeader(
                'Мастера рядом',
                action: 'Все',
                onAction: () => showSoon(context, 'Полный список мастеров появится в следующей версии'),
              ),
              const SizedBox(height: 12),
              Carousel(children: [for (final m in nearbyMasters) MasterCard(m: m)]),
              const SizedBox(height: 14),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: UrgentButton()),
              if (app.hasProject) ...[
                const SizedBox(height: 32),
                SectionHeader(
                  'Материалы для ${stage.forWhat}',
                  action: 'Все',
                  onAction: () => openStage(context, app.currentStage),
                ),
                const SizedBox(height: 12),
                MatGrid(items: stage.materials.take(4).toList()),
              ],
              const SizedBox(height: 32),
              SectionHeader(
                'Аренда техники',
                action: 'Все',
                onAction: () => showSoon(context, 'Каталог техники появится в следующей версии'),
              ),
              const SizedBox(height: 12),
              Carousel(children: [for (final e in homeEquipment) EquipCard(e: e)]),
              if (app.executorMode) ...[
                const SizedBox(height: 32),
                SectionHeader(
                  'Новые заказы рядом',
                  subtitle: 'По вашей специальности: каменщик',
                  action: 'Все',
                  onAction: () => showSoon(context, 'Все заказы появятся вместе с сервером'),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      for (var i = 0; i < nearbyOrders.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        OrderTile(o: nearbyOrders[i]),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ExecutorBanner(
                    onEnable: () {
                      HapticFeedback.mediumImpact();
                      app.setExecutor(true);
                      showSoon(context, 'Профиль исполнителя включён. Новые заказы рядом — внизу экрана');
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({required this.done, required this.now});

  final bool done;
  final bool now;

  @override
  Widget build(BuildContext context) {
    if (done) {
      return Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(color: C.ink, shape: BoxShape.circle),
        child: const Center(child: Ic('check', size: 15, color: C.white, stroke: 3)),
      );
    }
    if (now) {
      return Transform.rotate(
        angle: 0.785398,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: C.orange,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: C.ink, width: 2),
          ),
        ),
      );
    }
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: C.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0x7313284D), width: 1.5),
      ),
    );
  }
}

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(app.hasProject ? 'Мой проект' : 'Проект', style: ts(26, w: 700, ls: -0.5)),
              const SizedBox(height: 16),
              if (!app.hasProject)
                StartProjectCard(onPick: (t) => startDemoProject(context, t))
              else ...[
                ProjectCard(onOpenStage: (i) => openStage(context, i)),
                const SizedBox(height: 28),
                Text('Все этапы', style: ts(20, w: 600, ls: -0.2)),
                const SizedBox(height: 12),
                for (var i = 0; i < stages.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  _StageRow(index: i),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final s = stages[index];
    final done = index < app.currentStage;
    final now = index == app.currentStage;
    final status = done ? 'Готово' : (now ? 'Идут работы' : 'Впереди');
    return Tap(
      color: C.white,
      radius: 16,
      border: Border.all(color: now ? C.orangeBorder : C.line, width: now ? 1.5 : 1),
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      onTap: () => openStage(context, index),
      child: Row(
        children: [
          SizedBox(width: 30, height: 30, child: Center(child: _StageNode(done: done, now: now))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${index + 1}. ${s.name}', style: ts(16, w: 600)),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: ts(13, w: (done || now) ? 600 : 400, color: (done || now) ? C.greenText : C.muted),
                ),
              ],
            ),
          ),
          const Ic('chevRight', size: 20, color: C.muted),
        ],
      ),
    );
  }
}

class StageScreen extends StatelessWidget {
  const StageScreen({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final s = stages[index];
    final cur = app.currentStage;
    String statusText;
    Color fg;
    Color bg;
    bool dot;
    if (index < cur) {
      statusText = 'Готово';
      fg = C.greenText;
      bg = C.greenTint;
      dot = true;
    } else if (index == cur) {
      statusText = 'Идут работы';
      fg = C.greenText;
      bg = C.greenTint;
      dot = true;
    } else {
      statusText = 'Впереди';
      fg = C.muted;
      bg = C.inkTint;
      dot = false;
    }

    return Scaffold(
      backgroundColor: C.paper,
      body: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: GridPainter(color: C.grid))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      children: [
                        Tap(
                          color: C.white,
                          radius: 16,
                          border: Border.all(color: C.line),
                          semanticLabel: 'Назад',
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const SizedBox(
                            width: 48,
                            height: 48,
                            child: Center(child: Ic('chevLeft', size: 22)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            app.projectName,
                            style: ts(15, color: C.muted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Этап ${index + 1} из ${stages.length}', style: ts(14, color: C.muted)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Semantics(
                                header: true,
                                child: Text(s.name, style: ts(30, w: 600, h: 1.1, ls: -0.4, display: true)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
                              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (dot) ...[
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(color: C.green, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(statusText, style: ts(13, w: 600, color: fg)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                      decoration: BoxDecoration(
                        color: C.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: softShadow,
                      ),
                      child: StageLine(
                        current: cur,
                        selected: index,
                        onTap: (i) {
                          if (i == index) return;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(builder: (_) => StageScreen(index: i)),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Tap(
                      color: C.ink,
                      radius: 16,
                      minHeight: 56,
                      shadow: const [BoxShadow(color: Color(0x3813284D), blurRadius: 20, offset: Offset(0, 8))],
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        showSoon(context, 'Создание заказа за 3 шага — следующий этап разработки');
                      },
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Ic('plus', size: 20, color: C.white, stroke: 2.2),
                            const SizedBox(width: 8),
                            Text('Создать заказ на этот этап', style: ts(16, w: 600, color: C.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SectionHeader(
                    s.mastersTitle,
                    action: 'Все',
                    onAction: () => showSoon(context, 'Полный список мастеров появится в следующей версии'),
                  ),
                  const SizedBox(height: 12),
                  Carousel(children: [for (final m in s.masters) MasterCard(m: m)]),
                  const SizedBox(height: 32),
                  SectionHeader(
                    'Материалы',
                    action: 'Все',
                    onAction: () => showSoon(context, 'Каталог материалов появится в следующей версии'),
                  ),
                  const SizedBox(height: 12),
                  MatGrid(items: s.materials),
                  const SizedBox(height: 32),
                  SectionHeader(
                    'Техника',
                    action: 'Все',
                    onAction: () => showSoon(context, 'Каталог техники появится в следующей версии'),
                  ),
                  const SizedBox(height: 12),
                  Carousel(children: [for (final e in s.equipment) EquipCard(e: e)]),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AiTipCard(stage: s),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key, required this.onFindMaster});

  final VoidCallback onFindMaster;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Чаты', style: ts(26, w: 700, ls: -0.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: C.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: C.line),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(color: C.inkTint, shape: BoxShape.circle),
                  child: const Center(child: Ic('chat', size: 28)),
                ),
                const SizedBox(height: 16),
                Text('Пока нет переписок', style: ts(18, w: 700)),
                const SizedBox(height: 6),
                Text(
                  'Здесь появятся чаты с мастерами и продавцами. Связаться можно и через WhatsApp или Telegram из карточки мастера.',
                  textAlign: TextAlign.center,
                  style: ts(14, h: 1.45, color: C.muted),
                ),
                const SizedBox(height: 18),
                Tap(
                  color: C.ink,
                  radius: 14,
                  minHeight: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: onFindMaster,
                  child: Center(
                    widthFactor: 1,
                    child: Text('Найти мастера', style: ts(15, w: 600, color: C.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.line),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 128, child: Text(label, style: ts(13.5, h: 1.4, color: C.muted))),
          Expanded(child: Text(value, style: ts(14, w: 500, h: 1.4))),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: ts(16, w: 600)),
              const SizedBox(height: 3),
              Text(subtitle, style: ts(13.5, h: 1.4, color: C.muted)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: (v) {
            HapticFeedback.selectionClick();
            onChanged(v);
          },
        ),
      ],
    );
  }
}

class _LangRow extends StatelessWidget {
  const _LangRow({required this.label, this.selected = false, this.note});

  final String label;
  final bool selected;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final n = note;
    return Tap(
      minHeight: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onTap: selected ? null : () => showSoon(context, 'Кыргызский интерфейс добавим на следующем этапе'),
      child: Row(
        children: [
          Expanded(child: Text(label, style: ts(15, w: selected ? 600 : 400))),
          if (n != null) Text(n, style: ts(13, color: C.muted)),
          if (selected) const Ic('check', size: 20, stroke: 2.4),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(color: C.ink, shape: BoxShape.circle),
                    child: Center(child: Text('Д', style: ts(24, w: 600, color: C.white, display: true))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Диас', style: ts(22, w: 700)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Ic('shield', size: 16, color: C.greenText),
                            const SizedBox(width: 5),
                            Text('Номер подтверждён', style: ts(13.5, w: 500, color: C.greenText)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _Card(
                children: [
                  _SwitchRow(
                    title: 'Предложить свои услуги',
                    subtitle: app.executorMode
                        ? 'Профиль исполнителя включён: вы видите заказы рядом и получаете отзывы'
                        : 'Для мастеров, бригад, продавцов материалов и владельцев техники',
                    value: app.executorMode,
                    onChanged: app.setExecutor,
                  ),
                  if (app.executorMode) ...[
                    const SizedBox(height: 14),
                    const DashedDivider(),
                    const SizedBox(height: 14),
                    const _InfoRow('Специальность', 'Каменщик'),
                    const _InfoRow('Район', 'Кок-Жар'),
                    const _InfoRow('Знак «Проверенный»', 'Телефон подтверждён. Документы — в следующей версии'),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              _Card(
                children: [
                  _SwitchRow(
                    title: 'Пример проекта',
                    subtitle: 'Показывать на главной проект «Дом в Кок-Жаре». Выключите, чтобы увидеть экран нового пользователя',
                    value: app.hasProject,
                    onChanged: app.setHasProject,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Card(
                children: [
                  Row(
                    children: [
                      const Ic('globe', size: 20),
                      const SizedBox(width: 8),
                      Text('Язык', style: ts(16, w: 600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const _LangRow(label: 'Русский', selected: true),
                  const _LangRow(label: 'Кыргызча', note: 'скоро'),
                ],
              ),
              const SizedBox(height: 20),
              Text('Usta 0.1, тестовая сборка', textAlign: TextAlign.center, style: ts(13, color: C.muted)),
            ],
          ),
        );
      },
    );
  }
}
