import 'package:flutter/foundation.dart';

// Тестовые данные. Имена, цены и продавцы выдуманы.
// Неразрывный пробел ( ) не даёт цене разорваться на две строки.

class Master {
  const Master(
    this.name,
    this.trade,
    this.rating,
    this.reviews,
    this.district,
    this.price, {
    this.online = true,
    this.icon = 'brickwall',
  });

  final String name;
  final String trade;
  final double rating;
  final int reviews;
  final String district;
  final String price;
  final bool online;
  final String icon;
}

class MatItem {
  const MatItem(
    this.name,
    this.price,
    this.unit,
    this.seller,
    this.rating,
    this.district,
    this.icon, {
    this.belowAvg = false,
  });

  final String name;
  final String price;
  final String unit;
  final String seller;
  final double rating;
  final String district;
  final String icon;
  final bool belowAvg;
}

class Equip {
  const Equip(this.name, this.price, this.unit, this.rating, this.district, this.icon);

  final String name;
  final String price;
  final String unit;
  final double rating;
  final String district;
  final String icon;
}

class JobOrder {
  const JobOrder(this.title, this.place, this.ago, this.budget);

  final String title;
  final String place;
  final String ago;
  final String budget;
}

class Stage {
  const Stage({
    required this.name,
    required this.forWhat,
    required this.mastersTitle,
    required this.tip,
    required this.responsible,
    required this.masters,
    required this.materials,
    required this.equipment,
  });

  final String name;
  final String forWhat;
  final String mastersTitle;
  final String tip;

  /// Ответственная тема: фундамент, несущие конструкции, щит и т.п.
  /// Для таких этапов ИИ всегда показывает предупреждение.
  final bool responsible;
  final List<Master> masters;
  final List<MatItem> materials;
  final List<Equip> equipment;
}

const String kResponsibleWarning =
    'Это ориентировочная рекомендация. Для ответственных решений проконсультируйтесь с инженером и проверьте по действующим нормам.';

const _azamat = Master('Азамат Т.', 'Каменщик, бригада из 4', 4.9, 86, 'Аламедин-1', 'от 650 сом/м²');
const _nurlan = Master('Нурлан Б.', 'Электрик', 4.8, 142, 'Джал', 'от 350 сом/точка', icon: 'zap');
const _ermek = Master('Эрмек С.', 'Сантехник', 4.7, 64, 'Восток-5', 'от 1 000 сом', online: false, icon: 'wrench');
const _timur = Master('Тимур Р.', 'Кровельщик', 4.9, 95, 'Джал', 'от 450 сом/м²', icon: 'roof');

const _brick = MatItem('Кирпич красный М-150', '14 сом', 'шт', 'Курулуш Маркет', 4.8, 'Тунгуч', 'brick', belowAvg: true);
const _rebar = MatItem('Арматура Ø12 А500С', '78 сом', 'м', 'Металлобаза «Темир»', 4.9, 'Аламедин-1', 'rebar');
const _mixer = Equip('Бетономешалка 180 л', '700 сом', 'сутки', 4.8, 'Тунгуч', 'mixer');
const _scaffold = Equip('Леса рамные', '25 сом', 'м² в сутки', 4.6, 'Джал', 'scaffold');
const _excavator = Equip('Экскаватор-погрузчик', '2 800 сом', 'час', 4.9, 'Кок-Жар', 'excavator');
const _crane = Equip('Автокран 25 т', '4 500 сом', 'час', 4.7, 'Ак-Орго', 'crane');

const List<Stage> stages = [
  Stage(
    name: 'Фундамент',
    forWhat: 'фундамента',
    mastersTitle: 'Мастера для фундамента',
    responsible: true,
    tip: 'Марку бетона, размеры фундамента и схему армирования берут из проекта. Перед заливкой проверьте опалубку и расстояние от арматуры до края бетона.',
    masters: [
      Master('Самат А.', 'Бетонщик, бригада из 5', 4.8, 73, 'Кок-Жар', 'от 3 500 сом/м³', icon: 'mixer'),
      Master('Улан М.', 'Земляные работы', 4.6, 29, 'Тунгуч', 'от 900 сом/м³', online: false, icon: 'shovel'),
    ],
    materials: [
      MatItem('Бетон М300 с доставкой', '4 900 сом', 'м³', 'Бетонный узел «Курулуш»', 4.7, 'Кок-Жар', 'mixer'),
      MatItem('Арматура Ø12 А500С', '78 сом', 'м', 'Металлобаза «Темир»', 4.9, 'Аламедин-1', 'rebar', belowAvg: true),
      MatItem('Проволока вязальная 1,2 мм', '160 сом', 'кг', 'Металлобаза «Темир»', 4.9, 'Аламедин-1', 'coil'),
      MatItem('Гидроизоляция рулонная', '1 600 сом', 'рулон', 'Ала-Тоо Стройснаб', 4.6, 'Ак-Орго', 'roll'),
    ],
    equipment: [
      _excavator,
      Equip('Автобетононасос', '6 000 сом', 'час', 4.7, 'Тунгуч', 'crane'),
    ],
  ),
  Stage(
    name: 'Стены',
    forWhat: 'стен',
    mastersTitle: 'Мастера для стен',
    responsible: true,
    tip: 'Бишкек в зоне высокой сейсмичности. Кладку стен здесь обычно армируют и связывают с сейсмопоясом. Шаг армирования и размеры пояса берут из проекта.',
    masters: [
      _azamat,
      Master('Бакыт Ж.', 'Каменщик', 4.8, 57, 'Тунгуч', 'от 600 сом/м²'),
      Master('Эрлан К.', 'Бригада, газоблок', 4.6, 38, 'Кок-Жар', 'от 550 сом/м²', online: false, icon: 'cube'),
    ],
    materials: [
      _brick,
      MatItem('Цемент М400, мешок 50 кг', '560 сом', 'мешок', 'Ала-Тоо Стройснаб', 4.6, 'Ак-Орго', 'bag'),
      MatItem('Газоблок D500, 600×300×200', '165 сом', 'шт', 'Блок-Сервис', 4.7, 'Кок-Жар', 'cube'),
      _rebar,
      MatItem('Клей для газоблока, 25 кг', '390 сом', 'мешок', 'Блок-Сервис', 4.7, 'Кок-Жар', 'bag'),
      MatItem('Кладочная сетка, лист 0,5×2 м', '160 сом', 'шт', 'Металлобаза «Темир»', 4.9, 'Аламедин-1', 'mesh'),
    ],
    equipment: [_mixer, _scaffold],
  ),
  Stage(
    name: 'Крыша',
    forWhat: 'крыши',
    mastersTitle: 'Мастера для крыши',
    responsible: true,
    tip: 'Сечение стропил и шаг обрешётки зависят от снеговой нагрузки и пролёта, их берут из проекта. Кровлю удобнее монтировать в сухую безветренную погоду.',
    masters: [
      _timur,
      Master('Канат О.', 'Кровля, бригада из 3', 4.7, 41, 'Ак-Орго', 'от 400 сом/м²', online: false, icon: 'roof'),
    ],
    materials: [
      MatItem('Профнастил С21, 0,45 мм', '520 сом', 'м²', 'Кровля-Маркет', 4.6, 'Джал', 'roof', belowAvg: true),
      MatItem('Металлочерепица 0,5 мм', '610 сом', 'м²', 'Кровля-Маркет', 4.6, 'Джал', 'roof'),
      MatItem('Брус 50×150, 6 м', '650 сом', 'шт', 'Лесобаза «Арча»', 4.5, 'Тунгуч', 'beam'),
      MatItem('Мембрана ветрозащитная', '2 300 сом', 'рулон', 'Ала-Тоо Стройснаб', 4.6, 'Ак-Орго', 'roll'),
    ],
    equipment: [_crane, _scaffold],
  ),
  Stage(
    name: 'Электрика',
    forWhat: 'электрики',
    mastersTitle: 'Электрики',
    responsible: true,
    tip: 'Сначала составьте схему розеток, выключателей и мощных приборов: по ней считают кабель и автоматы. Сборку и подключение щита доверьте электрику с допуском.',
    masters: [
      _nurlan,
      Master('Руслан Д.', 'Электрик, сборка щитов', 4.9, 58, 'Восток-5', 'от 400 сом/точка', online: false, icon: 'panel'),
    ],
    materials: [
      MatItem('Кабель ВВГнг 3×2,5', '85 сом', 'м', 'Электромир', 4.7, 'Восток-5', 'cable'),
      MatItem('Автомат 16 А', '250 сом', 'шт', 'Электромир', 4.7, 'Восток-5', 'breaker'),
      MatItem('Розетка с заземлением', '180 сом', 'шт', 'Электромир', 4.7, 'Восток-5', 'socket', belowAvg: true),
      MatItem('Щит на 24 модуля', '1 900 сом', 'шт', 'Электромир', 4.7, 'Восток-5', 'panel'),
    ],
    equipment: [
      Equip('Штроборез', '600 сом', 'сутки', 4.6, 'Джал', 'tool'),
    ],
  ),
  Stage(
    name: 'Сантехника',
    forWhat: 'сантехники',
    mastersTitle: 'Сантехники',
    responsible: false,
    tip: 'Перед тем как закрывать трубы в стенах и полу, сделайте опрессовку: так протечку найдут до отделки, а не после.',
    masters: [
      Master('Айбек Н.', 'Сантехник, отопление', 4.8, 37, 'Аламедин-1', 'от 1 200 сом', icon: 'pipe'),
      _ermek,
    ],
    materials: [
      MatItem('Труба ППР 20 мм', '60 сом', 'м', 'Аква-Строй', 4.6, 'Тунгуч', 'pipe'),
      MatItem('Кран шаровой ½ дюйма', '350 сом', 'шт', 'Аква-Строй', 4.6, 'Тунгуч', 'valve'),
      MatItem('Смеситель для кухни', '2 400 сом', 'шт', 'Аква-Строй', 4.6, 'Тунгуч', 'faucet', belowAvg: true),
      MatItem('Унитаз-компакт', '6 500 сом', 'шт', 'Аква-Строй', 4.6, 'Тунгуч', 'toilet'),
    ],
    equipment: [
      Equip('Аппарат для пайки ППР', '300 сом', 'сутки', 4.7, 'Тунгуч', 'tool'),
    ],
  ),
  Stage(
    name: 'Отделка',
    forWhat: 'отделки',
    mastersTitle: 'Отделочники',
    responsible: false,
    tip: 'Штукатурку и стяжку начинают, когда в стенах и полу закончены электрика и сантехника. Перед покраской стены должны полностью высохнуть.',
    masters: [
      Master('Жылдыз К.', 'Штукатур-маляр', 4.9, 112, 'Джал', 'от 350 сом/м²', icon: 'roller'),
      Master('Марат Э.', 'Плиточник', 4.7, 66, 'Тунгуч', 'от 700 сом/м²', online: false, icon: 'tile'),
    ],
    materials: [
      MatItem('Штукатурка гипсовая, 30 кг', '520 сом', 'мешок', 'Курулуш Маркет', 4.8, 'Тунгуч', 'bag'),
      MatItem('Шпаклёвка финишная, 20 кг', '650 сом', 'мешок', 'Курулуш Маркет', 4.8, 'Тунгуч', 'bag'),
      MatItem('Керамогранит 60×60', '950 сом', 'м²', 'Плитка-Центр', 4.6, 'Восток-5', 'tile', belowAvg: true),
      MatItem('Краска интерьерная, 10 л', '2 900 сом', 'шт', 'Курулуш Маркет', 4.8, 'Тунгуч', 'bucket'),
    ],
    equipment: [
      Equip('Штукатурная станция', '3 500 сом', 'сутки', 4.5, 'Ак-Орго', 'roller'),
    ],
  ),
];

const List<Master> nearbyMasters = [_azamat, _nurlan, _ermek, _timur];

const List<Equip> homeEquipment = [_excavator, _mixer, _crane];

const List<JobOrder> nearbyOrders = [
  JobOrder('Кладка перегородок из газоблока, 40 м²', 'Кок-Жар, 2 км', '12 мин назад', 'до 24 000 сом'),
  JobOrder('Сейсмопояс и перемычки, дом 10×12 м', 'Арча-Бешик, 6 км', '1 ч назад', 'Цена договорная'),
  JobOrder('Ремонт кирпичного забора, 18 м', 'Джал, 4 км', '3 ч назад', 'до 15 000 сом'),
];

/// Состояние демо: есть ли проект и включён ли профиль исполнителя.
class AppState extends ChangeNotifier {
  bool hasProject = true;
  bool executorMode = true;
  String projectName = 'Дом в Кок-Жаре';
  String projectMeta = '120 м²';
  int currentStage = 1;
  int percent = 30;
  String statusLine = 'Идёт кладка, на объекте 2 мастера';

  void setExecutor(bool value) {
    executorMode = value;
    notifyListeners();
  }

  void setHasProject(bool value) {
    hasProject = value;
    if (value) {
      projectName = 'Дом в Кок-Жаре';
      projectMeta = '120 м²';
      currentStage = 1;
      percent = 30;
      statusLine = 'Идёт кладка, на объекте 2 мастера';
    }
    notifyListeners();
  }

  void startProject(String type) {
    hasProject = true;
    projectName = type == 'Дом' ? 'Мой дом' : type;
    projectMeta = 'Новый проект';
    currentStage = 0;
    percent = 0;
    statusLine = 'Подберите мастеров для первого этапа';
    notifyListeners();
  }
}

final AppState app = AppState();
