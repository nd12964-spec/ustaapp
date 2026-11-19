import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'theme.dart';

/// Линейные иконки в одном стиле (сетка 24×24).
const Map<String, String> _paths = {
  'pin': '<path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/>',
  'chevDown': '<path d="m6 9 6 6 6-6"/>',
  'chevRight': '<path d="m9 18 6-6-6-6"/>',
  'chevLeft': '<path d="m15 18-6-6 6-6"/>',
  'bell': '<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/>',
  'arrowUp': '<path d="m5 12 7-7 7 7"/><path d="M12 19V5"/>',
  'camera': '<path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/>',
  'mic': '<rect x="9" y="2" width="6" height="12" rx="3"/><path d="M19 10v1a7 7 0 0 1-14 0v-1"/><path d="M12 18v4"/>',
  'info': '<circle cx="12" cy="12" r="9"/><path d="M12 11v5"/><path d="M12 8h.01"/>',
  'star': '<path d="M12 2.5l2.9 5.9 6.5.9-4.7 4.6 1.1 6.5L12 17.3l-5.8 3.1 1.1-6.5-4.7-4.6 6.5-.9z"/>',
  'zap': '<path d="M13 2 4 14h7l-1 8 9-12h-7l1-8z"/>',
  'check': '<path d="M20 6 9 17l-5-5"/>',
  'clock': '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
  'home': '<path d="M3 10.5 12 3l9 7.5"/><path d="M5 9v12h14V9"/><path d="M10 21v-6h4v6"/>',
  'setsquare': '<path d="M4 20V4l16 16z"/><path d="M8 16v-4.5l4.5 4.5z"/><path d="M4 8h2M4 12h2"/>',
  'spark': '<path d="M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8z"/><path d="M19 15.5l.7 1.8 1.8.7-1.8.7-.7 1.8-.7-1.8-1.8-.7 1.8-.7z"/>',
  'chat': '<path d="M21 15a2 2 0 0 1-2 2H8l-5 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>',
  'user': '<circle cx="12" cy="8" r="4"/><path d="M4 21v-1a6 6 0 0 1 6-6h4a6 6 0 0 1 6 6v1"/>',
  'plus': '<path d="M12 5v14M5 12h14"/>',
  'alert': '<path d="M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0z"/><path d="M12 9v4M12 17h.01"/>',
  'flag': '<path d="M5 21V4"/><path d="M5 4h12l-2 4 2 4H5"/>',
  'shield': '<path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z"/><path d="m9 12 2 2 4-4"/>',
  'send': '<path d="M22 2 11 13"/><path d="M22 2 15 22l-4-9-9-4z"/>',
  'phone': '<path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1.9.4 1.8.7 2.7a2 2 0 0 1-.5 2.1L8 9.8a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.4c.9.3 1.8.6 2.7.7a2 2 0 0 1 1.7 2z"/>',
  'globe': '<circle cx="12" cy="12" r="9"/><path d="M3 12h18"/><path d="M12 3a14 14 0 0 1 0 18a14 14 0 0 1 0-18"/>',
  'briefcase':'<rect x="3" y="7" width="18" height="13" rx="2"/><path d="M9 7V5a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2M3 13h18"/>',
  // Типы проектов
  'house': '<path d="M3 11 12 4l9 7"/><path d="M5 9.5V20h14V9.5"/><path d="M10 20v-5h4v5"/>',
  'apart': '<rect x="5" y="3" width="14" height="18" rx="1"/><path d="M9 7h1M14 7h1M9 11h1M14 11h1M9 15h1M14 15h1"/><path d="M10.5 21v-3h3v3"/>',
  'fence': '<path d="M4 21V8l2-3 2 3v13M10 21V8l2-3 2 3v13M16 21V8l2-3 2 3v13"/><path d="M2 11h20M2 17h20"/>',
  'banya': '<path d="M3 10.5 12 4l9 6.5"/><path d="M5 12h14M5 15.5h14M5 19h14"/><path d="M6 12v7M18 12v7"/>',
  'garage': '<path d="M3 21V9l9-5 9 5v12"/><path d="M7 21v-9h10v9"/><path d="M7 15h10M7 18h10"/>',
  'dots': '<circle cx="5" cy="12" r="1.2"/><circle cx="12" cy="12" r="1.2"/><circle cx="19" cy="12" r="1.2"/>',
  // Мастера, материалы, техника
  'brickwall': '<rect x="3" y="4" width="18" height="16" rx="1"/><path d="M3 9.3h18M3 14.7h18M9 4v5.3M15 4v5.3M6 9.3v5.4M12 9.3v5.4M18 9.3v5.4M9 14.7V20M15 14.7V20"/>',
  'brick': '<path d="M3 9l5-3h13l-5 3z"/><path d="M3 9h13v8H3z"/><path d="M16 9l5-3v8l-5 3"/>',
  'bag': '<path d="M7 3h10l2 4-1 14H6L5 7z"/><path d="M5 7h14"/><path d="M9.5 12h5M9.5 15.5h5"/>',
  'cube': '<path d="M3 7.5 12 3l9 4.5v9L12 21l-9-4.5z"/><path d="M3 7.5 12 12l9-4.5M12 12v9"/>',
  'rebar': '<path d="M4 18 18 4M7 21 21 7"/><path d="M6 14l2 2M10 10l2 2M14 6l2 2M9 17l2 2M13 13l2 2M17 9l2 2"/>',
  'mixer': '<path d="M5.5 11.5c-1-3 1.5-6.5 5.5-7.8s7.8.2 8.8 3.2-1.5 6.5-5.5 7.8-7.8-.2-8.8-3.2z"/><path d="M9 15l-3 6M16 14l2 7M4 21h16"/>',
  'excavator': '<rect x="2" y="16" width="12" height="4" rx="2"/><path d="M4 16v-5h6l1.5 5"/><path d="M5.5 11V7.5h3L10 11"/><path d="M11 12l5-6 4 4"/><path d="M20 10l1 4h-4"/>',
  'crane': '<path d="M7 21V3"/><path d="M4 21h6"/><path d="M7 3l13 3H7"/><path d="M7 3 4 6h3"/><path d="M17 6v6"/><rect x="15" y="12" width="4" height="3"/><path d="M7 9l3-3M7 13l3-3M7 17l3-3"/>',
  'scaffold': '<path d="M4 3v18M20 3v18M4 7h16M4 13h16M4 19h16M4 7l16 6M20 13 4 19"/>',
  'mesh': '<rect x="3" y="3" width="18" height="18" rx="1"/><path d="M9 3v18M15 3v18M3 9h18M3 15h18"/>',
  'lintel': '<rect x="2" y="9" width="20" height="5" rx="1"/><path d="M5 14v6M19 14v6"/>',
  'wrench': '<path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>',
  'shovel': '<path d="M14 4l6 6"/><path d="M17 7l-6.5 6.5"/><path d="M10.5 13.5 6 18a2.1 2.1 0 0 1-3-3l4.5-4.5z"/>',
  'coil': '<circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="5"/><circle cx="12" cy="12" r="2"/>',
  'roll': '<circle cx="8" cy="9" r="5"/><circle cx="8" cy="9" r="1.5"/><path d="M8 4h12v15H8"/>',
  'roof': '<path d="M3 8l3-3 3 3 3-3 3 3 3-3 3 3v11H3z"/>',
  'beam': '<rect x="2" y="9" width="20" height="6" rx="1"/><path d="M6 9v6M18 9v6"/>',
  'cable': '<path d="M4 4v4a4 4 0 0 0 4 4h8a4 4 0 0 1 4 4v4"/><path d="M2 4h4M18 20h4"/>',
  'breaker': '<rect x="7" y="3" width="10" height="18" rx="1.5"/><rect x="10" y="8" width="4" height="6" rx="1"/>',
  'socket': '<circle cx="12" cy="12" r="9"/><circle cx="9" cy="12" r="1"/><circle cx="15" cy="12" r="1"/>',
  'panel': '<rect x="4" y="3" width="16" height="18" rx="1.5"/><path d="M4 9h16M4 15h16M8 6h1M8 12h1M8 18h1"/>',
  'pipe': '<path d="M3 9h12a3 3 0 0 1 3 3v9"/><path d="M3 15h9v6"/>',
  'faucet': '<path d="M4 10h10a4 4 0 0 1 4 4v1"/><path d="M8 10V6h4v4M6 6h8"/><path d="M18 18v.01M18 21v.01"/>',
  'toilet': '<path d="M6 3h6v7H6z"/><path d="M4 10h14a5 5 0 0 1-5 5H9l1 6H6l1-6"/>',
  'valve': '<path d="M3 13h18"/><circle cx="12" cy="13" r="3"/><path d="M12 10V5M9 5h6"/>',
  'roller': '<rect x="4" y="3" width="14" height="6" rx="1.5"/><path d="M18 6h2v5h-8v3"/><rect x="10.5" y="14" width="3" height="7" rx="1"/>',
  'tile': '<rect x="3" y="3" width="8" height="8" rx="1"/><rect x="13" y="3" width="8" height="8" rx="1"/><rect x="3" y="13" width="8" height="8" rx="1"/><rect x="13" y="13" width="8" height="8" rx="1"/>',
  'bucket': '<path d="M5 8h14l-1.5 12h-11z"/><path d="M5 8a7 3 0 0 1 14 0"/>',
  'tool': '<path d="M15 12 6.5 20.5a2.1 2.1 0 0 1-3-3L12 9"/><path d="M17.6 15 22 10.6"/><path d="M20.9 11.7 19.7 10.5c-.6-.6-.9-1.4-.9-2.3v-.9L16 4.6A5.6 5.6 0 0 0 12.1 3H9l.9.8A6.2 6.2 0 0 1 12 8.4V10l2 2h2.5l2.3 1.9"/>',
};

class Ic extends StatelessWidget {
  const Ic(
    this.name, {
    super.key,
    this.size = 24,
    this.color = C.ink,
    this.stroke = 1.75,
    this.filled = false,
  });

  final String name;
  final double size;
  final Color color;
  final double stroke;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final body = _paths[name] ?? '';
    final attrs = filled
        ? 'fill="#000000" stroke="none"'
        : 'fill="none" stroke="#000000" stroke-width="$stroke" stroke-linecap="round" stroke-linejoin="round"';
    final svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" $attrs>$body</svg>';
    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
  }
}
