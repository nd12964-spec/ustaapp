import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'icons.dart';
import 'theme.dart';

String fmtRating(double r) => r.toStringAsFixed(1).replaceAll('.', ',');

String plural(int n, String one, String few, String many) {
  final n10 = n % 10;
  final n100 = n % 100;
  if (n10 == 1 && n100 != 11) return one;
  if (n10 >= 2 && n10 <= 4 && (n100 < 12 || n100 > 14)) return few;
  return many;
}

void showSoon(BuildContext context, String text) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(text, style: ts(14, color: C.white, h: 1.35)),
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Нажимаемый блок со скруглением и эффектом нажатия.
class Tap extends StatelessWidget {
  const Tap({
    super.key,
    required this.child,
    this.onTap,
    this.color = Colors.transparent,
    this.radius = 14,
    this.border,
    this.shadow,
    this.padding = EdgeInsets.zero,
    this.minHeight = 0,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final double radius;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
  final EdgeInsetsGeometry padding;
  final double minHeight;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(radius);
    Widget result = Container(
      decoration: BoxDecoration(color: color, borderRadius: br, border: border, boxShadow: shadow),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: br,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
    if (semanticLabel != null) {
      result = Semantics(button: true, label: semanticLabel, excludeSemantics: true, child: result);
    }
    return result;
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(
    this.title, {
    super.key,
    this.subtitle,
    this.action,
    this.onAction,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(header: true, child: Text(title, style: ts(20, w: 600, ls: -0.2))),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(subtitle!, style: ts(13, color: C.muted)),
                  ),
              ],
            ),
          ),
          if (action != null)
            Tap(
              onTap: onAction,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                height: 44,
                child: Center(widthFactor: 1, child: Text(action!, style: ts(15, w: 600))),
              ),
            ),
        ],
      ),
    );
  }
}

/// Место под фото: штриховка и линейная иконка.
class PhotoBox extends StatelessWidget {
  const PhotoBox({
    super.key,
    required this.height,
    required this.icon,
    this.iconSize = 42,
    this.stroke = 1.3,
  });

  final double height;
  final String icon;
  final double iconSize;
  final double stroke;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: const HatchPainter(),
        child: Center(child: Ic(icon, size: iconSize, color: C.ink50, stroke: stroke)),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 9, 4),
      decoration: BoxDecoration(color: C.white, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: online
            ? [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: C.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('в сети', style: ts(12, w: 600, color: C.greenText)),
              ]
            : [Text('был сегодня', style: ts(12, w: 500, color: C.muted))],
      ),
    );
  }
}

class RatingLine extends StatelessWidget {
  const RatingLine({super.key, required this.rating, this.reviews, this.place, this.size = 13});

  final double rating;
  final int? reviews;
  final String? place;
  final double size;

  @override
  Widget build(BuildContext context) {
    final r = reviews;
    final p = place;
    return Row(
      children: [
        Ic('star', size: size + 1, color: C.orange, filled: true),
        const SizedBox(width: 4),
        Text(fmtRating(rating), style: ts(size, w: 600)),
        if (r != null)
          Flexible(
            child: Text(
              ' ($r ${plural(r, 'отзыв', 'отзыва', 'отзывов')})',
              style: ts(size, color: C.muted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (p != null) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Text(p, style: ts(size, color: C.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ],
    );
  }
}

class PlaceLine extends StatelessWidget {
  const PlaceLine(this.place, {super.key, this.icon = 'pin', this.size = 13});

  final String place;
  final String icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Ic(icon, size: size + 1, color: C.muted),
        const SizedBox(width: 4),
        Flexible(
          child: Text(place, style: ts(size, color: C.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class MasterCard extends StatelessWidget {
  const MasterCard({super.key, required this.m});

  final Master m;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      child: Tap(
        color: C.white,
        radius: 16,
        border: Border.all(color: C.line),
        onTap: () => showMasterSheet(context, m),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  PhotoBox(height: 116, icon: m.icon),
                  Positioned(top: 10, left: 10, child: StatusPill(online: m.online)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.name, style: ts(15, w: 600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(m.trade, style: ts(13, color: C.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    RatingLine(rating: m.rating, reviews: m.reviews),
                    const SizedBox(height: 6),
                    PlaceLine(m.district),
                    const SizedBox(height: 8),
                    Text(m.price, style: ts(15, w: 700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatCard extends StatelessWidget {
  const MatCard({super.key, required this.it});

  final MatItem it;

  @override
  Widget build(BuildContext context) {
    return Tap(
      color: C.white,
      radius: 16,
      border: Border.all(color: C.line),
      onTap: () => showSoon(context, 'Карточка товара появится в следующей версии'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                PhotoBox(height: 118, icon: it.icon, iconSize: 46, stroke: 1.2),
                if (it.belowAvg)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: C.greenTint, borderRadius: BorderRadius.circular(999)),
                      child: Text('ниже средней цены', style: ts(11.5, w: 600, color: C.greenText)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 36),
                    child: Text(
                      it.name,
                      style: ts(14, w: 500, h: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: it.price, style: ts(18, w: 700)),
                        TextSpan(text: ' / ${it.unit}', style: ts(13, color: C.muted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(it.seller, style: ts(12.5, color: C.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  RatingLine(rating: it.rating, place: it.district, size: 12.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EquipCard extends StatelessWidget {
  const EquipCard({super.key, required this.e});

  final Equip e;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 204,
      child: Tap(
        color: C.white,
        radius: 16,
        border: Border.all(color: C.line),
        onTap: () => showSoon(context, 'Бронирование техники появится в следующей версии'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PhotoBox(height: 120, icon: e.icon, iconSize: 52, stroke: 1.15),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.name, style: ts(15, w: 600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    RatingLine(rating: e.rating, place: e.district),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: e.price, style: ts(16, w: 700)),
                          TextSpan(text: ' / ${e.unit}', style: ts(13, color: C.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Горизонтальная лента карточек одинаковой высоты.
class Carousel extends StatelessWidget {
  const Carousel({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// Сетка материалов в 2 колонки.
class MatGrid extends StatelessWidget {
  const MatGrid({super.key, required this.items});

  final List<MatItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i += 2) ...[
            if (i > 0) const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: MatCard(it: items[i])),
                  const SizedBox(width: 12),
                  Expanded(child: i + 1 < items.length ? MatCard(it: items[i + 1]) : const SizedBox()),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Ic(icon, size: 14, color: C.muted),
        const SizedBox(width: 4),
        Text(text, style: ts(13, color: C.muted)),
      ],
    );
  }
}

class OrderTile extends StatefulWidget {
  const OrderTile({super.key, required this.o});

  final JobOrder o;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.o;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(o.title, style: ts(15, w: 600, h: 1.35)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              _IconText(icon: 'pin', text: o.place),
              _IconText(icon: 'clock', text: o.ago),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text(o.budget, style: ts(15, w: 700))),
              if (_sent)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Ic('check', size: 18, color: C.greenText, stroke: 2.4),
                    const SizedBox(width: 6),
                    Text('Отклик отправлен', style: ts(14, w: 600, color: C.greenText)),
                  ],
                )
              else
                Tap(
                  color: C.ink,
                  radius: 12,
                  minHeight: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() => _sent = true);
                  },
                  child: Center(
                    widthFactor: 1,
                    child: Text('Откликнуться', style: ts(14, w: 600, color: C.white)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class UrgentButton extends StatelessWidget {
  const UrgentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tap(
      color: C.orangeTint,
      radius: 18,
      border: Border.all(color: C.orangeBorder, width: 1.5),
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      onTap: () {
        HapticFeedback.mediumImpact();
        showSoon(context, 'Срочный заказ появится вместе с созданием заказов');
      },
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: C.orange, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Ic('zap', size: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Срочный заказ', style: ts(16, w: 700)),
                const SizedBox(height: 2),
                Text('Мастера рядом получат уведомление сразу', style: ts(13, color: C.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Ic('chevRight', size: 20),
        ],
      ),
    );
  }
}

/// Главный ИИ-блок: «синька» с белой сеткой.
class AiPanel extends StatefulWidget {
  const AiPanel({super.key});

  @override
  State<AiPanel> createState() => _AiPanelState();
}

class _AiPanelState extends State<AiPanel> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _ask(String mode) {
    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();
    showAiSheet(context, query: _ctrl.text.trim(), mode: mode);
  }

  @override
  Widget build(BuildContext context) {
    const faint = Color(0xB8FFFFFF);
    return Container(
      decoration: BoxDecoration(
        color: C.ink,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x4713284D), blurRadius: 32, offset: Offset(0, 14))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CustomPaint(
          painter: const GridPainter(color: Color(0x0FFFFFFF), step: 20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Сфотографируй или расскажи, что нужно',
                    style: ts(22, w: 600, h: 1.24, ls: -0.2, color: C.white, display: true),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ИИ определит работу, подскажет цену и материалы',
                  style: ts(15, h: 1.45, color: const Color(0xCCFFFFFF)),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
                  decoration: BoxDecoration(color: C.white, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          style: ts(16),
                          cursorColor: C.ink,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _ask('text'),
                          decoration: InputDecoration(
                            hintText: 'Например: трещина над окном',
                            hintStyle: ts(16, color: C.muted),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tap(
                        color: C.ink,
                        radius: 12,
                        semanticLabel: 'Отправить',
                        onTap: () => _ask('text'),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(child: Ic('arrowUp', size: 20, color: C.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Tap(
                        color: C.orange,
                        radius: 16,
                        onTap: () => _ask('photo'),
                        child: SizedBox(
                          height: 54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Ic('camera', size: 22),
                              const SizedBox(width: 8),
                              Text('Фото', style: ts(16, w: 600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Tap(
                        color: const Color(0x1AFFFFFF),
                        radius: 16,
                        border: Border.all(color: const Color(0x52FFFFFF)),
                        onTap: () => _ask('voice'),
                        child: SizedBox(
                          height: 54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Ic('mic', size: 22, color: C.white),
                              const SizedBox(width: 8),
                              Text('Голос', style: ts(16, w: 600, color: C.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Ic('info', size: 15, color: faint),
                    const SizedBox(width: 6),
                    Text('Оценки ИИ приблизительные', style: ts(12.5, color: faint)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Линия этапов в виде размерной линии с чертежа.
class StageLine extends StatefulWidget {
  const StageLine({super.key, required this.current, this.selected, this.onTap});

  final int current;
  final int? selected;
  final ValueChanged<int>? onTap;

  @override
  State<StageLine> createState() => _StageLineState();
}

class _StageLineState extends State<StageLine> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _pulse.stop();
      _pulse.value = 0;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = stages.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        final col = constraints.maxWidth / n;
        return SizedBox(
          height: 76,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _DimLinePainter(current: widget.current, count: n)),
              ),
              Row(
                children: [
                  for (var i = 0; i < n; i++) SizedBox(width: col, child: _item(i)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _item(int i) {
    final s = stages[i];
    final done = i < widget.current;
    final now = i == widget.current;
    final strong = now || i == widget.selected;
    final status = done ? 'готово' : (now ? 'сейчас' : 'впереди');
    final label = OverflowBox(
      maxWidth: 140,
      child: Text(
        s.name,
        maxLines: 1,
        softWrap: false,
        style: ts(
          now ? 12.5 : 12.0,
          w: strong ? 700 : (done ? 500 : 400),
          color: (done || strong) ? C.ink : C.muted,
        ),
      ),
    );
    final top = i.isEven;

    Widget node;
    if (done) {
      node = Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(color: C.ink, shape: BoxShape.circle),
        child: const Center(child: Ic('check', size: 13, color: C.white, stroke: 3)),
      );
    } else if (now) {
      node = AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          final t = _pulse.value;
          return Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: C.orange,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: C.ink, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: C.orange.withAlpha((128 * (1 - t)).round()),
                    spreadRadius: 11 * t,
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      node = Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: C.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x7313284D), width: 1.5),
        ),
      );
    }

    final onTap = widget.onTap;
    return Semantics(
      button: onTap != null,
      label: 'Этап ${i + 1}, ${s.name}, $status',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onTap(i);
              },
        child: Column(
          children: [
            SizedBox(height: 18, child: top ? label : null),
            const SizedBox(height: 6),
            SizedBox(height: 28, child: Center(child: node)),
            const SizedBox(height: 6),
            SizedBox(height: 18, child: top ? null : label),
          ],
        ),
      ),
    );
  }
}

class _DimLinePainter extends CustomPainter {
  _DimLinePainter({required this.current, required this.count});

  final int current;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    const y = 38.0;
    final w = size.width;
    final faint = Paint()
      ..color = C.ink38
      ..strokeWidth = 1.5;
    for (double x = 0; x < w; x += 8) {
      canvas.drawLine(Offset(x, y), Offset(math.min(x + 4, w), y), faint);
    }
    final solid = Paint()
      ..color = C.ink
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final endX = (current + 0.5) * w / count;
    canvas.drawLine(const Offset(0, y), Offset(endX, y), solid);
    final ext = Paint()
      ..color = C.ink
      ..strokeWidth = 1.5;
    canvas.drawLine(const Offset(0.75, y - 10), const Offset(0.75, y + 10), ext);
    canvas.drawLine(const Offset(-5, y + 5), const Offset(5, y - 5), ext);
    canvas.drawLine(Offset(w - 0.75, y - 10), Offset(w - 0.75, y + 10), faint);
    canvas.drawLine(Offset(w - 5, y + 5), Offset(w + 5, y - 5), faint);
  }

  @override
  bool shouldRepaint(covariant _DimLinePainter oldDelegate) =>
      oldDelegate.current != current || oldDelegate.count != count;
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(painter: HDashPainter()),
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.onOpenStage});

  final ValueChanged<int> onOpenStage;

  @override
  Widget build(BuildContext context) {
    final s = stages[app.currentStage];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(app.projectName, style: ts(18, w: 700, ls: -0.2)),
                    const SizedBox(height: 3),
                    Text(
                      '${app.projectMeta}, этап ${app.currentStage + 1} из ${stages.length}',
                      style: ts(14, color: C.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${app.percent}%', style: ts(22, w: 600, h: 1, display: true)),
                  const SizedBox(height: 5),
                  Text('готово', style: ts(12.5, color: C.muted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          StageLine(current: app.currentStage, onTap: onOpenStage),
          const SizedBox(height: 14),
          const DashedDivider(),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Сейчас: ${s.name.toLowerCase()}', style: ts(15, w: 600)),
                    const SizedBox(height: 2),
                    Text(app.statusLine, style: ts(13, color: C.muted)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Tap(
                color: C.ink,
                radius: 14,
                minHeight: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                onTap: () => onOpenStage(app.currentStage),
                child: Center(
                  widthFactor: 1,
                  child: Text('Открыть этап', style: ts(15, w: 600, color: C.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StartProjectCard extends StatelessWidget {
  const StartProjectCard({super.key, required this.onPick});

  final ValueChanged<String> onPick;

  static const List<(String, String)> _types = [
    ('house', 'Дом'),
    ('apart', 'Ремонт квартиры'),
    ('fence', 'Забор'),
    ('banya', 'Баня'),
    ('garage', 'Гараж'),
    ('dots', 'Другое'),
  ];

  Widget _tile((String, String) t) {
    return Tap(
      color: C.tile,
      radius: 14,
      border: Border.all(color: C.line),
      minHeight: 92,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      onTap: () => onPick(t.$2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Ic(t.$1, size: 28, stroke: 1.5),
          const SizedBox(height: 8),
          Text(t.$2, textAlign: TextAlign.center, style: ts(13.5, w: 600, h: 1.2)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Начать проект', style: ts(20, w: 700, ls: -0.2)),
          const SizedBox(height: 6),
          Text(
            'Выберите, что строите или ремонтируете. Мы разобьём работу на этапы и подберём мастеров на каждый.',
            style: ts(14, h: 1.45, color: C.muted),
          ),
          const SizedBox(height: 16),
          for (var r = 0; r < 2; r++) ...[
            if (r > 0) const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var c = 0; c < 3; c++) ...[
                  if (c > 0) const SizedBox(width: 8),
                  Expanded(child: _tile(_types[r * 3 + c])),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class ExecutorBanner extends StatelessWidget {
  const ExecutorBanner({super.key, required this.onEnable});

  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: const DashedRRectPainter(radius: 20, color: Color(0x5213284D)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: C.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: C.inkTint, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Ic('briefcase', size: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Вы мастер или продаёте материалы?', style: ts(16, w: 600, h: 1.3)),
                  const SizedBox(height: 6),
                  Text(
                    'Включите профиль исполнителя: будете видеть заказы рядом и получать отзывы.',
                    style: ts(13.5, h: 1.45, color: C.muted),
                  ),
                  const SizedBox(height: 12),
                  Tap(
                    color: C.white,
                    radius: 12,
                    border: Border.all(color: C.ink, width: 1.5),
                    minHeight: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    onTap: onEnable,
                    child: Center(
                      widthFactor: 1,
                      child: Text('Предложить свои услуги', style: ts(14, w: 600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarningBox extends StatelessWidget {
  const WarningBox({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.orangeTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: C.orangeBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 1), child: Ic('alert', size: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: ts(13.5, h: 1.45))),
        ],
      ),
    );
  }
}

class ReportButton extends StatelessWidget {
  const ReportButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tap(
      minHeight: 44,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Ic('flag', size: 16),
          const SizedBox(width: 6),
          Text('Сообщить об ошибке', style: ts(13.5, w: 600)),
        ],
      ),
    );
  }
}

class AiTipCard extends StatelessWidget {
  const AiTipCard({super.key, required this.stage});

  final Stage stage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: C.ink, borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Ic('spark', size: 18, color: C.white, stroke: 2)),
              ),
              const SizedBox(width: 10),
              Text('Подсказка ИИ', style: ts(16, w: 600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(stage.tip, style: ts(15, h: 1.5)),
          if (stage.responsible) ...[
            const SizedBox(height: 12),
            const WarningBox(text: kResponsibleWarning),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text('Оценки ИИ приблизительные', style: ts(12.5, color: C.muted))),
              ReportButton(
                onTap: () => showSoon(context, 'Спасибо! Жалобы начнём сохранять, когда подключим сервер'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

ShapeBorder _sheetShape() => const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    );

Future<void> showMasterSheet(BuildContext context, Master m) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: C.white,
    shape: _sheetShape(),
    builder: (ctx) {
      void soon(String text) {
        Navigator.of(ctx).pop();
        showSoon(context, text);
      }

      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(width: 72, height: 72, child: PhotoBox(height: 72, icon: m.icon, iconSize: 32)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: ts(20, w: 700)),
                        const SizedBox(height: 2),
                        Text(m.trade, style: ts(14, color: C.muted)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: m.online ? C.green : C.line,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              m.online ? 'в сети' : 'был сегодня',
                              style: ts(13, w: 600, color: m.online ? C.greenText : C.muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              RatingLine(rating: m.rating, reviews: m.reviews, size: 14),
              const SizedBox(height: 8),
              PlaceLine('${m.district}, Бишкек', size: 14),
              const SizedBox(height: 10),
              Text(m.price, style: ts(18, w: 700)),
              const SizedBox(height: 20),
              Tap(
                color: C.ink,
                radius: 16,
                minHeight: 54,
                onTap: () => soon('Чат появится на следующем этапе'),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Ic('chat', size: 20, color: C.white),
                      const SizedBox(width: 8),
                      Text('Написать в чате', style: ts(16, w: 600, color: C.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Tap(
                      color: C.white,
                      radius: 16,
                      minHeight: 50,
                      border: Border.all(color: C.line, width: 1.5),
                      onTap: () => soon('Связь через WhatsApp подключим вместе с чатом'),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Ic('phone', size: 18),
                            const SizedBox(width: 8),
                            Text('WhatsApp', style: ts(15, w: 600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Tap(
                      color: C.white,
                      radius: 16,
                      minHeight: 50,
                      border: Border.all(color: C.line, width: 1.5),
                      onTap: () => soon('Связь через Telegram подключим вместе с чатом'),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Ic('send', size: 18),
                            const SizedBox(width: 8),
                            Text('Telegram', style: ts(15, w: 600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _AiRow extends StatelessWidget {
  const _AiRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: ts(12.5, w: 600, color: C.muted)),
          const SizedBox(height: 3),
          Text(value, style: ts(15, h: 1.4)),
        ],
      ),
    );
  }
}

Future<void> showAiSheet(BuildContext context, {String query = '', String mode = 'text'}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: C.white,
    shape: _sheetShape(),
    builder: (ctx) {
      final maxHeight = MediaQuery.of(ctx).size.height * 0.88;
      void soon(String text) {
        Navigator.of(ctx).pop();
        showSoon(context, text);
      }

      final intro = switch (mode) {
        'photo' => 'Камера заработает вместе с настоящим ИИ. Так будет выглядеть ответ на фото трещины:',
        'voice' => 'Голосовой ввод заработает вместе с настоящим ИИ. Так будет выглядеть ответ:',
        _ => 'Настоящий ИИ подключим на следующем этапе. Так будет выглядеть ответ:',
      };

      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('ИИ-помощник', style: ts(22, w: 600, display: true)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: C.inkTint, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Ic('info', size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(intro, style: ts(14, h: 1.45))),
                    ],
                  ),
                ),
                if (query.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('Ваш запрос: «$query»', style: ts(14, h: 1.4, color: C.muted)),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: C.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: C.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Пример ответа', style: ts(12.5, w: 600, color: C.muted)),
                      const SizedBox(height: 6),
                      Text('Трещина в штукатурке над окном', style: ts(18, w: 700, h: 1.3)),
                      const SizedBox(height: 14),
                      const _AiRow('Какая работа', 'Расшивка трещины, армирование сеткой-серпянкой и ремонт штукатурки'),
                      const _AiRow('Ориентировочно', '3 000–6 000 сом за работу'),
                      const _AiRow('Материалы', 'Штукатурная смесь, серпянка, грунтовка'),
                      const WarningBox(
                        text: 'Трещины над проёмами бывают связаны с перемычкой или осадкой дома. $kResponsibleWarning',
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: Text('Оценки ИИ приблизительные', style: ts(12.5, color: C.muted))),
                          ReportButton(
                            onTap: () => soon('Спасибо! Жалобы начнём сохранять, когда подключим сервер'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Tap(
                  color: C.ink,
                  radius: 16,
                  minHeight: 54,
                  onTap: () => soon('Создание заказа за 3 шага — следующий этап разработки'),
                  child: Center(
                    child: Text('Создать заказ по этому ответу', style: ts(16, w: 600, color: C.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
