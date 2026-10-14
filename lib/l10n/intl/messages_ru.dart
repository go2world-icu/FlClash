// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(count, skipped) =>
      "Будет добавлено: ${count}, пропущено (уже есть): ${skipped}";

  static String m1(code) =>
      "Windows отказалась запускать FlClashCore.exe (ошибка ${code}). Политики контроля приложений, такие как Smart App Control или AppLocker, блокируют неподписанные программы; разрешите ToWorld в этой политике или отключите её и повторите попытку.";

  static String m2(name) =>
      "Приложение два раза подряд не смогло завершить запуск. Чтобы разорвать цикл, профиль ${name} снят с выбора, а автоматическая настройка пропущена. Вы можете выбрать его снова в любой момент.";

  static String m3(url) => "Создать профиль по ссылке ${url}?";

  static String m4(rate) => "Текущая ставка комиссии: ${rate}%";

  static String m5(count) =>
      "${Intl.plural(count, one: '${count} день назад', few: '${count} дня назад', many: '${count} дней назад', other: '${count} дня назад')}";

  static String m6(label) =>
      "Вы уверены, что хотите удалить выбранные элементы (${label})?";

  static String m7(label) => "Вы уверены, что хотите удалить «${label}»?";

  static String m8(label) => "Сведения: ${label}";

  static String m9(label) => "Поле «${label}» не может быть пустым";

  static String m10(count) => "${count} записей";

  static String m11(label) => "«${label}» уже существует";

  static String m12(name) => "${name}: уже последняя версия";

  static String m13(name) => "${name}: обновлено";

  static String m14(name) => "Обновление ${name}...";

  static String m15(action) =>
      "Уже используется для «${action}». При сохранении будет перенесено сюда.";

  static String m16(modifiers) =>
      "Добавьте хотя бы одну из клавиш: ${modifiers}";

  static String m17(count) =>
      "${Intl.plural(count, one: '${count} час назад', few: '${count} часа назад', many: '${count} часов назад', other: '${count} часа назад')}";

  static String m18(count) =>
      "${Intl.plural(count, one: '${count} час', few: '${count} часа', many: '${count} часов', other: '${count} часа')}";

  static String m19(target) => "${target} — недопустимая политика";

  static String m20(proxyName) => "${proxyName} — недопустимый прокси";

  static String m21(providerName) =>
      "${providerName} — недопустимый провайдер прокси";

  static String m22(ruleSet) => "${ruleSet} — недопустимый набор правил";

  static String m23(subRule) => "${subRule} — недопустимый SUB_RULE";

  static String m24(line, message) => "Строка ${line}: ${message}";

  static String m25(appName) =>
      "1. Откройте Системные настройки > Конфиденциальность и безопасность\n2. Выберите Службы геолокации\n3. Найдите и отметьте ${appName} в списке\n\nПосле настройки вернитесь в приложение и продолжайте работу. Спасибо за сотрудничество.";

  static String m26(error) => "Не удалось выйти: ${error}";

  static String m27(label, max) => "«${label}» — не более ${max} символов";

  static String m28(amount) => "Максимальный перевод: ¥${amount}";

  static String m29(size) => "Освобождено ${size}";

  static String m30(count) =>
      "${Intl.plural(count, one: '${count} минуту назад', few: '${count} минуты назад', many: '${count} минут назад', other: '${count} минуты назад')}";

  static String m31(count) =>
      "${Intl.plural(count, one: '${count} месяц назад', few: '${count} месяца назад', many: '${count} месяцев назад', other: '${count} месяца назад')}";

  static String m32(code) =>
      "Сервер запретил доступ (HTTP ${code}). Возможно, ссылка устарела или учётные данные неверны";

  static String m33(code) => "Сервер отклонил запрос (HTTP ${code})";

  static String m34(code) =>
      "По этому адресу ничего не найдено (HTTP ${code}). Проверьте правильность URL";

  static String m35(detail) => "Сетевой запрос не выполнен: ${detail}";

  static String m36(code) =>
      "На сервере произошла ошибка (HTTP ${code}). Повторите попытку позже";

  static String m37(label) => "Пока нет: ${label}";

  static String m38(label) => "Значение «${label}» должно быть числом";

  static String m39(statusCode) =>
      "Не удалось получить сообщения: ${statusCode}";

  static String m40(error) => "Не удалось выбрать изображения: ${error}";

  static String m41(method) => "Неподдерживаемый HTTP метод: ${method}";

  static String m42(error) => "Загрузка не удалась: ${error}";

  static String m43(amount) => "Сумма заказа: ${amount}";

  static String m44(orderNo) => "Заказ: ${orderNo}";

  static String m45(message) =>
      "Ядро не может разобрать этот прокси: ${message}";

  static String m46(name) =>
      "Имя ${name} уже занято другим прокси или группой прокси";

  static String m47(path) =>
      "Группы прокси ссылаются друг на друга по кругу: ${path}";

  static String m48(names) => "Эти провайдеры прокси не существуют: ${names}";

  static String m49(names) => "Эти прокси или политики не существуют: ${names}";

  static String m50(name) =>
      "${name} — встроенное имя политики, его нельзя использовать";

  static String m51(names) =>
      "Собственные группы прокси профиля ссылаются на прокси, которых больше нет среди пользовательских: ${names}";

  static String m52(count) =>
      "Проблем: ${count}, применение переопределения может завершиться ошибкой";

  static String m53(page) => "Страница ${page}";

  static String m54(label) =>
      "Значение «${label}» должно быть от 1024 до 49151";

  static String m55(label, profiles) =>
      "«${label}» всё ещё используется в пользовательских группах прокси или правилах профилей: ${profiles}. Сначала уберите его оттуда";

  static String m56(profiles, label) =>
      "В подписках профилей ${profiles} уже есть «${label}», и после переименования они будут использовать его. Выберите другое имя";

  static String m57(count) => "${count} прокси";

  static String m58(e) => "Не удалось зарегистрироваться: ${e}";

  static String m59(count) =>
      "${Intl.plural(count, one: '${count} правило', few: '${count} правила', many: '${count} правил', other: '${count} правила')}";

  static String m60(appName) => "${appName} (Безопасный режим)";

  static String m61(count) =>
      "${Intl.plural(count, one: '${count} секунда', few: '${count} секунды', many: '${count} секунд', other: '${count} секунды')}";

  static String m62(count) => "Выбрано: ${count}";

  static String m63(e) => "Не удалось отправить код подтверждения: ${e}";

  static String m64(time) => "Проверено в ${time}";

  static String m65(label) => "«${label}» — только одно значение";

  static String m66(date) =>
      "План истёк ${date}, пожалуйста продлите для продолжения использования";

  static String m67(days) =>
      "План истёк через ${days} дней, пожалуйста продлите вовремя";

  static String m68(days) => "Подписка истёк через ${days} дней";

  static String m69(count) => "Всего ${count} записей";

  static String m70(amount) => "Сумма перевода не может превышать ¥${amount}";

  static String m71(error) => "Не удалось выполнить перевод: ${error}";

  static String m72(amount) =>
      "Перевод успешен! Переведено ¥${amount} в кошелёк";

  static String m73(version) => "Текущая версия: ${version}";

  static String m74(version) => "Принудительное обновление: ${version}";

  static String m75(version) => "Найдена новая версия: ${version}";

  static String m76(statusCode) => "Сервер вернул код ошибки ${statusCode}";

  static String m77(label) => "Значение «${label}» должно быть URL";

  static String m78(email) =>
      "Код подтверждения отправлен на ${email}. Введите код и новый пароль";

  static String m79(amount) => "Доступно к выводу: ${amount}";

  static String m80(time) => "Время работы: ${time}";

  static String m81(count) =>
      "${Intl.plural(count, one: '${count} год назад', few: '${count} года назад', many: '${count} лет назад', other: '${count} года назад')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("О программе"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Контроль доступа"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Через VPN проходят только выбранные приложения",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "Выбор приложений, использующих прокси",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "Контроль доступа приложений отключён",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Выбранные приложения исключаются из VPN",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage(
      "Настройки контроля доступа",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Аккаунт"),
    "action": MessageLookupByLibrary.simpleMessage("Действие"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage(
      "Проверить все задержки",
    ),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("Прямой режим"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage(
      "Глобальный режим",
    ),
    "actionMode": MessageLookupByLibrary.simpleMessage("Переключить режим"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("Режим правил"),
    "actionStart": MessageLookupByLibrary.simpleMessage("Старт/Стоп"),
    "actionTun": MessageLookupByLibrary.simpleMessage("TUN"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage(
      "Обновить профили",
    ),
    "actionView": MessageLookupByLibrary.simpleMessage("Показать/Скрыть"),
    "action_mode": MessageLookupByLibrary.simpleMessage("Переключить режим"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "action_start": MessageLookupByLibrary.simpleMessage("Старт/Стоп"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("Показать/Скрыть"),
    "add": MessageLookupByLibrary.simpleMessage("Добавить"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("Добавить прокси"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage(
      "Добавить параметр",
    ),
    "addProfile": MessageLookupByLibrary.simpleMessage("Добавить профиль"),
    "addProxies": MessageLookupByLibrary.simpleMessage("Добавить прокси"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Добавить группу прокси",
    ),
    "addProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Добавить провайдеров прокси",
    ),
    "addRule": MessageLookupByLibrary.simpleMessage("Добавить правило"),
    "addSsid": MessageLookupByLibrary.simpleMessage("Добавить SSID"),
    "addWidget": MessageLookupByLibrary.simpleMessage("Добавить виджет"),
    "addedOriginRules": MessageLookupByLibrary.simpleMessage(
      "Добавить к оригинальным правилам",
    ),
    "addedRules": MessageLookupByLibrary.simpleMessage("Добавленные правила"),
    "additionalParameters": MessageLookupByLibrary.simpleMessage(
      "Дополнительные параметры",
    ),
    "address": MessageLookupByLibrary.simpleMessage("Адрес"),
    "addressHelp": MessageLookupByLibrary.simpleMessage("Адрес сервера WebDAV"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Введите корректный адрес WebDAV",
    ),
    "adminAutoLaunch": MessageLookupByLibrary.simpleMessage(
      "Автозапуск с правами администратора",
    ),
    "adminAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Запуск с правами администратора при загрузке системы",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Расширенная конфигурация",
    ),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Сеть, DNS, добавленные правила и скрипты",
    ),
    "ago": MessageLookupByLibrary.simpleMessage(" назад"),
    "agree": MessageLookupByLibrary.simpleMessage("Согласен"),
    "allApps": MessageLookupByLibrary.simpleMessage("Все приложения"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Разрешить приложениям обходить VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "Некоторые приложения могут обходить VPN при включении",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Разрешить LAN"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешить доступ к прокси через локальную сеть",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Уже есть аккаунт?",
    ),
    "answers": MessageLookupByLibrary.simpleMessage("Ответы"),
    "app": MessageLookupByLibrary.simpleMessage("Приложение"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "Контроль доступа приложений",
    ),
    "appDesc": MessageLookupByLibrary.simpleMessage(
      "Обработка настроек, связанных с приложением",
    ),
    "appIconDesign": MessageLookupByLibrary.simpleMessage(
      "Дизайн значка приложения",
    ),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Добавлять системный DNS",
    ),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage(
      "Принудительно добавить системный DNS к конфигурации",
    ),
    "application": MessageLookupByLibrary.simpleMessage("Приложение"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение настроек, связанных с приложением",
    ),
    "authentication": MessageLookupByLibrary.simpleMessage("Аутентификация"),
    "authenticationDesc": MessageLookupByLibrary.simpleMessage(
      "Требовать учётные данные для локального порта прокси, чтобы другие приложения не могли использовать его",
    ),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Не применяется, пока включена аутентификация",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("Разрешить"),
    "authorized": MessageLookupByLibrary.simpleMessage("Разрешено"),
    "auto": MessageLookupByLibrary.simpleMessage("Авто"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Автопроверка обновлений",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически проверять обновления при запуске приложения",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Автозакрытие соединений",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически закрывать соединения после смены узла",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Автозапуск"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Запускаться автоматически при старте системы",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("Автовключение"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Включаться автоматически при открытии приложения",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Автонастройка системного DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Автообновление"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал автообновления (минуты)",
    ),
    "availableCommission": MessageLookupByLibrary.simpleMessage("Доступно"),
    "back": MessageLookupByLibrary.simpleMessage("Назад"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Вернуться ко входу"),
    "backup": MessageLookupByLibrary.simpleMessage("Резервное копирование"),
    "backupAndRecovery": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование и восстановление",
    ),
    "backupAndRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Синхронизация данных через WebDAV или файл",
    ),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование и восстановление",
    ),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "Синхронизация данных через WebDAV или файлы",
    ),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "Резервная копия создана более новой версией приложения. Обновите приложение перед восстановлением",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage(
      "Резервная копия создана",
    ),
    "basicConfig": MessageLookupByLibrary.simpleMessage("Базовая конфигурация"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Глобальное изменение базовых настроек",
    ),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Основная информация"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("Базовые политики"),
    "batchAdd": MessageLookupByLibrary.simpleMessage("Массовое добавление"),
    "batchListInputTip": MessageLookupByLibrary.simpleMessage(
      "По одному значению на строку или через запятую",
    ),
    "batchMapInputTip": MessageLookupByLibrary.simpleMessage(
      "По одной записи на строку: ключ, пробел, значение",
    ),
    "batchPreviewTip": m0,
    "batteryOptimizationDesc": MessageLookupByLibrary.simpleMessage(
      "Чтобы приложение работало в фоне, отключите для него оптимизацию батареи. Нажмите, чтобы перейти к настройкам.",
    ),
    "batteryOptimizationStatusTip": MessageLookupByLibrary.simpleMessage(
      "Из-за системных ограничений во время работы невозможно корректно получить статус оптимизации батареи",
    ),
    "behavior": MessageLookupByLibrary.simpleMessage("Поведение"),
    "bind": MessageLookupByLibrary.simpleMessage("Привязать"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage(
      "Режим чёрного списка",
    ),
    "blockConnection": MessageLookupByLibrary.simpleMessage(
      "Заблокировать соединение",
    ),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Исключённые домены"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Действует только при включённом системном прокси",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("Кэш"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage("Алгоритм кэша"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "Кэш повреждён. Очистить его?",
    ),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("Размер кэша"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешите доступ к камере в системных настройках, чтобы сканировать QR-коды, или выберите изображение QR-кода из галереи.",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Требуется доступ к камере",
    ),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage(
      "Камера недоступна",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "cancelFilterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Отменить фильтрацию системных приложений",
    ),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("Снять выделение"),
    "cannotGetWebUrl": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить URL сайта, обратитесь в поддержку",
    ),
    "cannotOpenBrowser": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть браузер, посетите сайт вручную",
    ),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "Не удалось переключить прокси; восстановлен предыдущий выбор",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage(
      "Важные изменения",
    ),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("Новые функции"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("Исправления"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage(
      "Производительность",
    ),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("Откаты"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage(
      "Проверять TLS-сертификаты",
    ),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "Отклонять недоверенные сертификаты. Отключение подвергает подписки и резервные копии атаке «человек посередине»",
    ),
    "checkError": MessageLookupByLibrary.simpleMessage("Ошибка проверки"),
    "checkNetwork": MessageLookupByLibrary.simpleMessage(
      "Проверьте сеть и повторите попытку",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Проверить обновления"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "У вас уже последняя версия",
    ),
    "checking": MessageLookupByLibrary.simpleMessage("Проверка..."),
    "clearData": MessageLookupByLibrary.simpleMessage("Очистить данные"),
    "clearSearch": MessageLookupByLibrary.simpleMessage("Очистить поиск"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Экспорт в буфер обмена",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Импорт из буфера обмена",
    ),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось скопировать в буфер обмена. Возможно, выделение слишком велико",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
    "closeConnections": MessageLookupByLibrary.simpleMessage(
      "Закрыть соединения",
    ),
    "color": MessageLookupByLibrary.simpleMessage("Цвет"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("Цветовые схемы"),
    "columns": MessageLookupByLibrary.simpleMessage("Столбцы"),
    "commissionHistory": MessageLookupByLibrary.simpleMessage(
      "История комиссий",
    ),
    "commissionRate": MessageLookupByLibrary.simpleMessage("Ставка"),
    "commissionSettled": MessageLookupByLibrary.simpleMessage(
      "Комиссия начисляется после подписки друга",
    ),
    "compatible": MessageLookupByLibrary.simpleMessage("Режим совместимости"),
    "compatibleDesc": MessageLookupByLibrary.simpleMessage(
      "Включение приведет к потере части функциональности приложения, но обеспечит полную поддержку Clash.",
    ),
    "complete": MessageLookupByLibrary.simpleMessage("Завершить"),
    "completeWithdrawal": MessageLookupByLibrary.simpleMessage(
      "Веб-версия предоставляет полные функции вывода средств",
    ),
    "configDataDetected": MessageLookupByLibrary.simpleMessage(
      "В конфигурации обнаружены данные",
    ),
    "configurationError": MessageLookupByLibrary.simpleMessage(
      "Ошибка конфигурации приложения, обратитесь в службу поддержки",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить все данные?",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить эту группу прокси?",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите закрыть текущее окно?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принудительно завершить ядро со сбоем?",
    ),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Подтвердить выход"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Подтвердите новый пароль",
    ),
    "confirmOverwriteTip": MessageLookupByLibrary.simpleMessage(
      "После подтверждения существующие данные будут перезаписаны",
    ),
    "confirmTransfer": MessageLookupByLibrary.simpleMessage(
      "Подтвердить перевод",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Подключено"),
    "connecting": MessageLookupByLibrary.simpleMessage("Подключение…"),
    "connection": MessageLookupByLibrary.simpleMessage("Соединение"),
    "connections": MessageLookupByLibrary.simpleMessage("Соединения"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Просмотр текущих данных о соединениях",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("Подключение: "),
    "contactMe": MessageLookupByLibrary.simpleMessage("Свяжитесь со мной"),
    "contactSupport": MessageLookupByLibrary.simpleMessage(
      "Связаться с поддержкой",
    ),
    "content": MessageLookupByLibrary.simpleMessage("Содержимое"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Содержимое не может быть пустым",
    ),
    "contentScheme": MessageLookupByLibrary.simpleMessage("Контентная"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Управление глобальными добавленными правилами",
    ),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Скопировано в буфер обмена",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Копировать переменные окружения",
    ),
    "copyInviteLink": MessageLookupByLibrary.simpleMessage(
      "Скопировать ссылку",
    ),
    "copyLink": MessageLookupByLibrary.simpleMessage("Копировать ссылку"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Скопировано"),
    "core": MessageLookupByLibrary.simpleMessage("Ядро"),
    "coreBlockedByPolicyTip": m1,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Smart App Control в Windows заблокировал неподписанный FlClashCore.exe. Откройте Безопасность Windows → Управление приложениями и браузером → Параметры Smart App Control, выберите «Выкл.» и снова запустите ToWorld. Повторно включить Smart App Control без переустановки Windows нельзя.",
    ),
    "coreInfo": MessageLookupByLibrary.simpleMessage("Информация о ядре"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Статус ядра"),
    "country": MessageLookupByLibrary.simpleMessage("Регион"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("Обнаружен сбой"),
    "crashDetectedTip": m2,
    "crashTest": MessageLookupByLibrary.simpleMessage("Тест сбоя"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("Аналитика сбоев"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "При включении в случае сбоя приложения автоматически загружаются логи сбоя без конфиденциальной информации",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Создать"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Создать аккаунт"),
    "createProfile": MessageLookupByLibrary.simpleMessage("Create Profile"),
    "createProfileFromUrlTip": m3,
    "creationTime": MessageLookupByLibrary.simpleMessage("Время создания"),
    "credentialsSaved": MessageLookupByLibrary.simpleMessage(
      "Учётные данные сохранены",
    ),
    "currentCommissionRate": m4,
    "custom": MessageLookupByLibrary.simpleMessage("Вручную"),
    "customProxiesEmpty": MessageLookupByLibrary.simpleMessage(
      "Пользовательских прокси нет, поэтому используются прокси самого профиля",
    ),
    "cut": MessageLookupByLibrary.simpleMessage("Вырезать"),
    "dark": MessageLookupByLibrary.simpleMessage("Тёмная"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Панель"),
    "dataChangedSave": MessageLookupByLibrary.simpleMessage(
      "Обнаружены изменения данных. Сохранить их?",
    ),
    "dataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "Это приложение использует Firebase Crashlytics для сбора информации о сбоях, чтобы повысить стабильность.\nСобираемые данные включают сведения об устройстве и подробности сбоя и не содержат личных конфиденциальных данных.\nЭту функцию можно отключить в настройках.",
    ),
    "dataCollectionTip": MessageLookupByLibrary.simpleMessage(
      "Уведомление о сборе данных",
    ),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "Не удалось сохранить изменение; оно отменено",
    ),
    "days": MessageLookupByLibrary.simpleMessage("Дней"),
    "daysAgo": m5,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "Сервер имен по умолчанию",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Для разрешения DNS-сервера",
    ),
    "defaultSort": MessageLookupByLibrary.simpleMessage(
      "Сортировка по умолчанию",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("По умолчанию"),
    "delay": MessageLookupByLibrary.simpleMessage("Задержка"),
    "delaySort": MessageLookupByLibrary.simpleMessage("Сортировка по задержке"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Тест задержки"),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteMultipTip": m6,
    "deleteTip": m7,
    "desc": MessageLookupByLibrary.simpleMessage(
      "Многоплатформенный прокси-клиент на основе ClashMeta: простой и удобный, с открытым исходным кодом и без рекламы.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Назначение"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "GeoIP назначения",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage(
      "ASN IP назначения",
    ),
    "details": m8,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Использует сторонний API; только для справки",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Режим разработчика"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Режим разработчика включён.",
    ),
    "dialerProxy": MessageLookupByLibrary.simpleMessage(
      "Прокси для подключения",
    ),
    "dialerProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Исход, через который идёт обращение к NTP-серверу",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("Прямой"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("Отключить UDP"),
    "disabled": MessageLookupByLibrary.simpleMessage("Выключено"),
    "discardChanges": MessageLookupByLibrary.simpleMessage(
      "Отменить изменения?",
    ),
    "disclaimer": MessageLookupByLibrary.simpleMessage(
      "Отказ от ответственности",
    ),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "Устанавливая, копируя или используя Программу, вы подтверждаете, что прочитали и приняли это заявление полностью. Если вы не согласны с каким-либо его условием, немедленно прекратите использование и удалите Программу.",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage(
      "Принятие условий",
    ),
    "disclaimerAnalyticsContent": MessageLookupByLibrary.simpleMessage(
      "Вместе с Firebase автоматически собирается базовая статистика использования приложения.\n\nЧто собирается: базовые события, такие как первый запуск, открытие приложения и длительность сеанса, обновление приложения; идентификатор экземпляра приложения; модель устройства, версия ОС и язык системы; приблизительное местоположение на уровне страны или региона, определённое по IP-адресу.\n\nЦель: только оценка числа активных устройств, распределения версий и совместимости с ОС. Разработчики не используют эти данные для рекламы, не продают их и не связывают с вашими подписками или конфигурациями.",
    ),
    "disclaimerAnalyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Firebase Analytics (статистика использования)",
    ),
    "disclaimerAndroidOnly": MessageLookupByLibrary.simpleMessage(
      "Только Android",
    ),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "Разработчики могут изменять это заявление в любом выпуске; изменения вступают в силу с момента публикации выпуска. Продолжая пользоваться Программой после обновления, вы принимаете изменённое заявление.",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Изменения заявления",
    ),
    "disclaimerCrashlyticsContent": MessageLookupByLibrary.simpleMessage(
      "При сбое приложения отчёт о сбое отправляется автоматически.\n\nЧто собирается: трассировка стека и сообщение об ошибке, время сбоя, версия и номер сборки приложения, производитель и модель устройства, версия Android, ориентация экрана, свободная память и место в хранилище, наличие root-доступа, а также случайный идентификатор установки, который создаётся при установке и сбрасывается при переустановке.\n\nЦель: только поиск и исправление сбоев.\n\nВы можете отключить это в любой момент: «Инструменты > Общие > Аналитика сбоев».",
    ),
    "disclaimerCrashlyticsTitle": MessageLookupByLibrary.simpleMessage(
      "Firebase Crashlytics (аналитика сбоев)",
    ),
    "disclaimerDataProcessingContent": MessageLookupByLibrary.simpleMessage(
      "Эти данные обрабатываются и хранятся компанией Google от нашего имени, могут передаваться на серверы за пределами вашей страны или региона (например, в США) и регулируются Политикой конфиденциальности Google и документацией Firebase о конфиденциальности и безопасности. Отчёты о сбоях хранятся до 90 дней; статистика хранится в соответствии с политикой хранения Firebase по умолчанию.",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Перед использованием ToWorld (далее — «Программа») внимательно прочитайте это заявление и убедитесь, что понимаете его полностью. Нажимая «Согласен», вы подтверждаете, что прочитали, поняли и принимаете все приведённые ниже условия. Если вы не согласны, нажмите «Выход» и прекратите использование Программы.",
    ),
    "disclaimerFirebasePrivacy": MessageLookupByLibrary.simpleMessage(
      "Конфиденциальность и безопасность Firebase",
    ),
    "disclaimerGooglePrivacy": MessageLookupByLibrary.simpleMessage(
      "Политика конфиденциальности Google",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "В максимальной степени, допустимой применимым законодательством, ни разработчики, ни участники проекта не несут ответственности за любой прямой, косвенный, случайный, особый, штрафной или последующий ущерб, возникший в результате использования или невозможности использования Программы, включая, помимо прочего, потерю данных, повреждение устройства, сбои сети, прерывание деятельности, упущенную выгоду или связанные с этим правовые споры, даже если они были предупреждены о возможности такого ущерба.",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage(
      "Ограничение ответственности",
    ),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "Программа распространяется с открытым исходным кодом по лицензии GPL-3.0. Вы можете свободно использовать, изменять и распространять её при соблюдении этой лицензии: производные работы также должны распространяться по GPL-3.0 с сохранением уведомлений об авторских правах.\n\nСторонние компоненты Программы, включая ядро Clash.Meta, распространяются по своим собственным лицензиям. Авторы оригинала не несут ответственности за проблемы, возникшие в изменённых или распространяемых третьими лицами версиях.",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage(
      "Лицензия с открытым исходным кодом",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "Программа не собирает и не отправляет адреса ваших подписок, сведения об узлах, содержимое конфигураций, посещённые сайты, записи о подключениях, содержимое трафика и журналы. Эти данные хранятся только на вашем устройстве, и у разработчиков нет к ним доступа.\n\nПрограмма обращается к сети только при использовании соответствующих функций, например загружает указанный вами адрес подписки при обновлении профиля или обращается к GitHub при проверке обновлений.\n\nНастольные версии (Windows, macOS, Linux) не содержат никаких сервисов статистики или отчётов о сбоях. Версия для Android использует два сервиса Google Firebase для повышения стабильности:",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Сбор данных и конфиденциальность",
    ),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "Вы самостоятельно убеждаетесь, что использование Программы законно в вашей стране или регионе, и единолично несёте юридическую ответственность за все действия с ней и их последствия.\n\nПодписки, узлы и конфигурации, которые вы импортируете, выбираете вы сами. Законность их источника, безопасность содержимого и надёжность сервиса — вопрос между вами и их поставщиками.",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "Ваша ответственность",
    ),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "Программа — это клиент сетевого прокси с открытым исходным кодом на основе ядра Clash.Meta (mihomo). Она предоставляет только локальные инструменты: управление конфигурациями, маршрутизацию по правилам и пересылку трафика.\n\nСама Программа не предоставляет прокси-серверы, узлы, подписки или услуги доступа к сети и не состоит в партнёрских, агентских или гарантийных отношениях с поставщиками таких услуг.",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage(
      "Характер программы",
    ),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "Ссылки на подписки, файлы конфигурации, наборы правил, скрипты, внешние ресурсы и внешние ссылки предоставляются третьими лицами. Разработчики не могут проверять и не проверяют их законность, точность, безопасность и доступность и не дают на них никаких гарантий.\n\nУтечка данных, финансовые потери, блокировка аккаунта или иной ущерб, вызванные сторонним контентом, урегулируются между вами и третьим лицом; разработчики не несут за это никакой ответственности.",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Сторонний контент",
    ),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "Программа предназначена только для некоммерческого использования: обучения, обмена опытом и технических исследований. Любое коммерческое использование строго запрещено, включая, помимо прочего, платное распространение, продажу в комплекте, использование в составе коммерческого сервиса или ведение деятельности от имени Программы. Любая коммерческая деятельность не имеет отношения к Программе и её разработчикам.\n\nСтрого запрещено использовать Программу для действий, нарушающих законы вашей страны или региона, включая, помимо прочего, обход законно установленных ограничений доступа к сети, распространение незаконной информации, сетевые атаки и нарушение законных прав других лиц.",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage(
      "Ограничения использования",
    ),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "Программа предоставляется «как есть» и «по мере доступности», без каких-либо явных или подразумеваемых гарантий, включая, помимо прочего, гарантии товарной пригодности, пригодности для определённой цели, ненарушения прав, бесперебойной работы, отсутствия ошибок и уязвимостей.\n\nРазработчики не гарантируют, что Программа будет соответствовать вашим потребностям или работать без сбоев и ошибок.",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage(
      "Отсутствие гарантий",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Отключено"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Доступна новая версия",
    ),
    "discovery": MessageLookupByLibrary.simpleMessage(
      "Обнаружена новая версия",
    ),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "Обновление настроек, связанных с DNS",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("Перехват DNS"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("Режим DNS"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("DNS-запросы"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "Вы хотите пропустить",
    ),
    "docked": MessageLookupByLibrary.simpleMessage("Закреплённая"),
    "domain": MessageLookupByLibrary.simpleMessage("Домен"),
    "domainStatusAvailable": MessageLookupByLibrary.simpleMessage(
      "Сервис доступен",
    ),
    "domainStatusChecking": MessageLookupByLibrary.simpleMessage("Проверка..."),
    "domainStatusUnavailable": MessageLookupByLibrary.simpleMessage(
      "Сервис недоступен",
    ),
    "download": MessageLookupByLibrary.simpleMessage("Загрузка"),
    "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Редактировать глобальные правила",
    ),
    "editProxy": MessageLookupByLibrary.simpleMessage("Редактировать прокси"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Редактировать группу прокси",
    ),
    "editRule": MessageLookupByLibrary.simpleMessage("Редактировать правило"),
    "editSsid": MessageLookupByLibrary.simpleMessage("Изменить SSID"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage(
      "Редактор недоступен",
    ),
    "emailAddress": MessageLookupByLibrary.simpleMessage(
      "Адрес электронной почты",
    ),
    "emailVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения по email",
    ),
    "emptyTip": m9,
    "en": MessageLookupByLibrary.simpleMessage("Английский"),
    "enableOverride": MessageLookupByLibrary.simpleMessage(
      "Включить переопределение",
    ),
    "enabled": MessageLookupByLibrary.simpleMessage("Включено"),
    "enterEmailForReset": MessageLookupByLibrary.simpleMessage(
      "Введите адрес электронной почты, мы отправим код подтверждения на вашу почту",
    ),
    "enterTransferAmount": MessageLookupByLibrary.simpleMessage(
      "Введите сумму перевода",
    ),
    "enterTransferAmountError": MessageLookupByLibrary.simpleMessage(
      "Введите сумму перевода",
    ),
    "entries": MessageLookupByLibrary.simpleMessage(" записей"),
    "entriesCount": m10,
    "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
    "exclude": MessageLookupByLibrary.simpleMessage("Скрыть из недавних задач"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "Скрывать приложение из недавних задач, когда оно в фоне",
    ),
    "excludeProxyFilter": MessageLookupByLibrary.simpleMessage(
      "Фильтр исключения узлов",
    ),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("Исключённые SSID"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "При подключении к Wi-Fi с исключённым SSID состояние работы приложения переключается автоматически",
    ),
    "excludeType": MessageLookupByLibrary.simpleMessage("Исключаемые типы"),
    "existsTip": m11,
    "exit": MessageLookupByLibrary.simpleMessage("Выход"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage(
      "Выйти из полноэкранного режима",
    ),
    "expand": MessageLookupByLibrary.simpleMessage("Стандартный"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("Ожидаемый статус"),
    "expirationTime": MessageLookupByLibrary.simpleMessage("Время истечения"),
    "expireTime": MessageLookupByLibrary.simpleMessage("Срок действия"),
    "exportFile": MessageLookupByLibrary.simpleMessage("Экспорт файла"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Экспорт логов"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Экспорт выполнен"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("Экспрессивная"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "Внешний контроллер",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "При включении ядром Clash можно управлять через порт 9090",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("Внешнее получение"),
    "externalLink": MessageLookupByLibrary.simpleMessage("Внешняя ссылка"),
    "externalResources": MessageLookupByLibrary.simpleMessage(
      "Внешние ресурсы",
    ),
    "extraLarge": MessageLookupByLibrary.simpleMessage("Очень крупный"),
    "fade": MessageLookupByLibrary.simpleMessage("Растворение"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Фильтр Fake-IP"),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage(
      "Режим фильтра Fake-IP",
    ),
    "fakeipFilterModeDesc": MessageLookupByLibrary.simpleMessage(
      "blacklist исключает совпадения, whitelist — только их, rule — по правилам",
    ),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Диапазон Fake-IP"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage(
      "Диапазон Fake-IP (IPv6)",
    ),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("TTL Fake-IP"),
    "fallback": MessageLookupByLibrary.simpleMessage("Резервный"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Обычно используется оффшорный DNS",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Фильтр fallback"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("Точная передача"),
    "file": MessageLookupByLibrary.simpleMessage("Файл"),
    "fileDesc": MessageLookupByLibrary.simpleMessage(
      "Загрузить файл профиля напрямую",
    ),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "Файл изменён. Сохранить изменения?",
    ),
    "fillInfoToRegister": MessageLookupByLibrary.simpleMessage(
      "Заполните следующую информацию для завершения регистрации",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Фильтр"),
    "filterSystemApp": MessageLookupByLibrary.simpleMessage(
      "Фильтровать системные приложения",
    ),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Поиск процесса"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "При включении возможны небольшие потери производительности",
    ),
    "floating": MessageLookupByLibrary.simpleMessage("Плавающая"),
    "followProfile": MessageLookupByLibrary.simpleMessage("Как в профиле"),
    "followSystem": MessageLookupByLibrary.simpleMessage("Как в системе"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Шрифт"),
    "fontSize": MessageLookupByLibrary.simpleMessage("Размер"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принудительно перезапустить ядро?",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Забыли пароль?"),
    "format": MessageLookupByLibrary.simpleMessage("Формат"),
    "fourColumns": MessageLookupByLibrary.simpleMessage("Четыре столбца"),
    "friendInviteReward": MessageLookupByLibrary.simpleMessage(
      "Получайте комиссию, когда ваши приглашённые друзья тратят средства",
    ),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("Фруктовый микс"),
    "general": MessageLookupByLibrary.simpleMessage("Общие"),
    "generalDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение общих настроек",
    ),
    "generatingInviteCode": MessageLookupByLibrary.simpleMessage(
      "Генерация пригласительного кода...",
    ),
    "geoAutoUpdate": MessageLookupByLibrary.simpleMessage("Автообновление"),
    "geoAutoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал автообновления",
    ),
    "geoAutoUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "Интервал автообновления должен быть больше 0",
    ),
    "geoData": MessageLookupByLibrary.simpleMessage("Геоданные"),
    "geoOptions": MessageLookupByLibrary.simpleMessage("Настройки Geo"),
    "geoResources": MessageLookupByLibrary.simpleMessage("Ресурсы Geo"),
    "geoSkipped": m12,
    "geoUpdated": m13,
    "geoUpdating": m14,
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Geo: экономия памяти",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "Включение будет использовать загрузчик геоданных с низким потреблением памяти",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Код Geoip"),
    "getOriginRules": MessageLookupByLibrary.simpleMessage(
      "Получить оригинальные правила",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Глобальный"),
    "go": MessageLookupByLibrary.simpleMessage("Перейти"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Скачать"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Перейти к настройке скрипта",
    ),
    "goToWeb": MessageLookupByLibrary.simpleMessage("Перейти на сайт"),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Кэшировать изменения?",
    ),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Служба Helper недоступна, поэтому TUN-режим включить нельзя. Переустановите ToWorld.",
    ),
    "hideFromList": MessageLookupByLibrary.simpleMessage("Скрыть из списка"),
    "hideIp": MessageLookupByLibrary.simpleMessage("Скрыть IP"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("Скрыть пароль"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage(
      "Скрывать узлы с таймаутом",
    ),
    "hideTimeoutProxiesDesc": MessageLookupByLibrary.simpleMessage(
      "Не показывать узлы, у которых последний тест задержки завершился таймаутом",
    ),
    "host": MessageLookupByLibrary.simpleMessage("Хост"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("Добавить Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage(
      "Конфликт горячих клавиш",
    ),
    "hotkeyConflictWith": m15,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "Глобальные горячие клавиши работают, даже когда окно скрыто. Нажмите на действие, чтобы записать сочетание клавиш.",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("Горячие клавиши"),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "Использование клавиатуры для управления приложением",
    ),
    "hotkeyNeedsModifier": m16,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("Не задано"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "Не зарегистрировано: сочетание может быть занято другим приложением",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("часов"),
    "hoursAgo": m17,
    "hoursCount": m18,
    "iUnderstand": MessageLookupByLibrary.simpleMessage("Я понимаю"),
    "icon": MessageLookupByLibrary.simpleMessage("Значок"),
    "iconConfiguration": MessageLookupByLibrary.simpleMessage(
      "Конфигурация иконки",
    ),
    "iconRecords": MessageLookupByLibrary.simpleMessage("История значков"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Стиль значков"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("С подложкой"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("Скрыто"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("Без подложки"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("URL значка"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "Игнорировать оптимизацию батареи",
    ),
    "import": MessageLookupByLibrary.simpleMessage("Импорт"),
    "importFile": MessageLookupByLibrary.simpleMessage("Импорт из файла"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("Импорт из URL"),
    "importUrl": MessageLookupByLibrary.simpleMessage("Импорт по URL"),
    "inbound": MessageLookupByLibrary.simpleMessage("Входящие"),
    "includeAllProxies": MessageLookupByLibrary.simpleMessage(
      "Включить все прокси",
    ),
    "includeAllProxiesTip": MessageLookupByLibrary.simpleMessage(
      "Подключает все прокси вне групп; ниже можно добавить дополнительные группы прокси",
    ),
    "includeAllProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Включить всех провайдеров прокси",
    ),
    "includeAllProxyProvidersTip": MessageLookupByLibrary.simpleMessage(
      "При включении группа берёт всех провайдеров прокси этого профиля: собственных провайдеров подписки, а также профили и прокси-провайдеры приложения, которые использует любая группа прокси",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("Бессрочно"),
    "init": MessageLookupByLibrary.simpleMessage("Инициализация"),
    "initiator": MessageLookupByLibrary.simpleMessage("Инициатор"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите правильную горячую клавишу",
    ),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "Введите название группы прокси",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage(
      "Введите содержимое правила",
    ),
    "installedAppsPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Разрешение на список приложений отклонено, поэтому установленные приложения недоступны. Предоставьте его вручную в системных настройках.",
    ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Эта система не выдаёт список установленных приложений без разрешения. Предоставьте его, чтобы настроить прокси для отдельных приложений.",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Требуется разрешение на список приложений",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("Умный выбор"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("Имя интерфейса"),
    "interfaceNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сетевой интерфейс для исходящих соединений",
    ),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage(
      "Исходящий интерфейс",
    ),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("Очистить"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage("Вручную"),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage(
      "Как в конфигурации",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Интернет"),
    "interval": MessageLookupByLibrary.simpleMessage("Интервал"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Внутренний IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Недопустимый файл резервной копии",
    ),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "Метка DSCP не может превышать 63",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "Поддерживаются только tcp и udp",
    ),
    "invalidPolicy": m19,
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "Этот QR-код не содержит ссылку на профиль",
    ),
    "invalidProxy": m20,
    "invalidProxyProvider": m21,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "Введите числа или диапазоны, например 80 или 8000-9000, через /",
    ),
    "invalidRuleSet": m22,
    "invalidSubRule": m23,
    "invalidTransferAmount": MessageLookupByLibrary.simpleMessage(
      "Введите корректную сумму перевода",
    ),
    "invite": MessageLookupByLibrary.simpleMessage("Пригласить"),
    "inviteCode": MessageLookupByLibrary.simpleMessage("Пригласительный код"),
    "inviteCodeGenFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось сгенерировать пригласительный код",
    ),
    "inviteCodeIncorrect": MessageLookupByLibrary.simpleMessage(
      "Пригласительный код может быть неверным, проверьте и введите заново",
    ),
    "inviteCodeOptional": MessageLookupByLibrary.simpleMessage(
      "Пригласительный код (необязательно)",
    ),
    "inviteCodeRequired": MessageLookupByLibrary.simpleMessage(
      "Требуется пригласительный код",
    ),
    "inviteCodeRequiredMessage": MessageLookupByLibrary.simpleMessage(
      "Для регистрации требуется пригласительный код. Свяжитесь с зарегистрированным пользователем, чтобы получить его перед регистрацией.",
    ),
    "inviteLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Ссылка-приглашение скопирована, поделитесь с друзьями",
    ),
    "inviteRegisterReward": MessageLookupByLibrary.simpleMessage(
      "Приглашайте друзей регистрироваться и подписываться, чтобы получать комиссию",
    ),
    "inviteRules": MessageLookupByLibrary.simpleMessage("Правила приглашения"),
    "inviteStats": MessageLookupByLibrary.simpleMessage(
      "Статистика приглашений",
    ),
    "ipAddress": MessageLookupByLibrary.simpleMessage("IP-адрес"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("Злоупотребления"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("Прокси"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("Метки"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("Организация"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось определить тип IP",
    ),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("Хороший"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("Уровень"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("Обычный"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage("Проверить снова"),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("Рискованный"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("Источник ответа"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("Источники"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage(
      "Другой исходящий IP",
    ),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("Тип не определён"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage(
      "Лимит запросов",
    ),
    "ipType": MessageLookupByLibrary.simpleMessage("Тип"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("Бизнес"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("Дата-центр"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("Мобильная сеть"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Домашний"),
    "ipcidr": MessageLookupByLibrary.simpleMessage("IPCIDR"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "При включении можно принимать трафик IPv6",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешить входящий IPv6",
    ),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage("Тайм-аут IPv6 (мс)"),
    "ja": MessageLookupByLibrary.simpleMessage("Японский"),
    "just": MessageLookupByLibrary.simpleMessage("Только что"),
    "justNow": MessageLookupByLibrary.simpleMessage("Только что"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Интервал TCP keep-alive",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Ключ"),
    "language": MessageLookupByLibrary.simpleMessage("Язык"),
    "large": MessageLookupByLibrary.simpleMessage("Крупный"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Последнее обновление"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage(
      "Запуск не завершён",
    ),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "В прошлый раз приложение неожиданно завершилось во время запуска. Автоматическая настройка для этого запуска пропущена; вы можете запустить её вручную.",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("Макет"),
    "light": MessageLookupByLibrary.simpleMessage("Светлая"),
    "lineIssueTip": m24,
    "lineWrap": MessageLookupByLibrary.simpleMessage("Перенос строк"),
    "list": MessageLookupByLibrary.simpleMessage("Список"),
    "listen": MessageLookupByLibrary.simpleMessage("Прослушивание"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage(
      "Метка маршрутизации",
    ),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage(
      "Только Linux",
    ),
    "liveConnections": MessageLookupByLibrary.simpleMessage(
      "Активные соединения",
    ),
    "loadMore": MessageLookupByLibrary.simpleMessage("Загрузить ещё"),
    "loadTest": MessageLookupByLibrary.simpleMessage("Тест загрузки"),
    "loading": MessageLookupByLibrary.simpleMessage("Загрузка…"),
    "local": MessageLookupByLibrary.simpleMessage("Локально"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование локальных данных на локальный диск",
    ),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "Доступ к локальной сети запрещён: используется стек gvisor, локальная сеть недоступна.",
    ),
    "localRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Восстановление данных из файла",
    ),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Разрешение на геолокацию",
    ),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Разрешение на геолокацию отклонено, поэтому невозможно получить имя текущей сети Wi-Fi. Включите разрешение на геолокацию вручную в системных настройках.",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "По требованию системы для получения имени сети Wi-Fi необходимо разрешение на геолокацию. На Android выберите «Разрешить всегда», иначе имя сети Wi-Fi нельзя получить, пока приложение в фоне.",
    ),
    "locationPermissionGuide": m25,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Требуется разрешение на геолокацию",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Лог"),
    "logLevel": MessageLookupByLibrary.simpleMessage("Уровень логов"),
    "logcat": MessageLookupByLibrary.simpleMessage("Захват логов"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "При отключении раздел логов будет скрыт",
    ),
    "loggedOutSuccess": MessageLookupByLibrary.simpleMessage(
      "Вы вышли из системы",
    ),
    "loginNow": MessageLookupByLibrary.simpleMessage("Войти сейчас"),
    "logout": MessageLookupByLibrary.simpleMessage("Выйти"),
    "logoutConfirmMsg": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите выйти? Потребуется повторный вход.",
    ),
    "logoutFailed": m26,
    "logs": MessageLookupByLibrary.simpleMessage("Логи"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Логи и диагностика",
    ),
    "logsDesc": MessageLookupByLibrary.simpleMessage("Записи захвата логов"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Тест логов"),
    "loopback": MessageLookupByLibrary.simpleMessage(
      "Снятие ограничения loopback для UWP",
    ),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "Используется для разблокировки Loopback UWP",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Свободный"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage(
      "Сопоставлять IP источника",
    ),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage(
      "Макс. число неудач",
    ),
    "maxLengthTip": m27,
    "maxTransferable": m28,
    "maximize": MessageLookupByLibrary.simpleMessage("Развернуть"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage(
      "Резидентная память",
    ),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage(
      "Приложение и общая",
    ),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage(
      "Свободная куча",
    ),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage(
      "Используемая куча",
    ),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage(
      "Ядро не запущено",
    ),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage(
      "Накладные расходы среды",
    ),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage("Стеки горутин"),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "Оценка по резидентной памяти процессов; может отличаться от данных системы.",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "Ядро работает в процессе приложения. Его доля оценивается по статистике среды выполнения, остальное относится к приложению и общей памяти.",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Память"),
    "memoryReleased": MessageLookupByLibrary.simpleMessage(
      "Память освобождена",
    ),
    "memoryReleasedSize": m29,
    "messageTest": MessageLookupByLibrary.simpleMessage("Тест сообщения"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("Это сообщение."),
    "min": MessageLookupByLibrary.simpleMessage("Минимальный"),
    "minimize": MessageLookupByLibrary.simpleMessage("Свернуть"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage(
      "Сворачивать при выходе",
    ),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "Изменить стандартное событие выхода из системы",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("Минут"),
    "minutesAgo": m30,
    "mixedPort": MessageLookupByLibrary.simpleMessage("Смешанный порт"),
    "mode": MessageLookupByLibrary.simpleMessage("Режим"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Монохром"),
    "months": MessageLookupByLibrary.simpleMessage("Месяцев"),
    "monthsAgo": m31,
    "more": MessageLookupByLibrary.simpleMessage("Ещё"),
    "myInviteQr": MessageLookupByLibrary.simpleMessage(
      "Мой QR-код приглашения",
    ),
    "name": MessageLookupByLibrary.simpleMessage("Название"),
    "nameSort": MessageLookupByLibrary.simpleMessage("Сортировка по имени"),
    "nameserver": MessageLookupByLibrary.simpleMessage("Сервер имен"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Для разрешения домена",
    ),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "Политика сервера имен",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Указать соответствующую политику сервера имен",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage("Нижняя панель"),
    "network": MessageLookupByLibrary.simpleMessage("Сеть"),
    "networkAccessDeniedError": m32,
    "networkBadResponseError": m33,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage(
      "Запрос отменён",
    ),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "Не удалось подключиться к серверу. Проверьте подключение к сети или настройки прокси",
    ),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение настроек, связанных с сетью",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage("Проверка сети"),
    "networkException": MessageLookupByLibrary.simpleMessage(
      "Ошибка сети, проверьте соединение и попробуйте еще раз",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "Не удалось определить адрес сервера. Проверьте правильность URL и работу DNS",
    ),
    "networkNotFoundError": m34,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "Слишком много запросов (HTTP 429). Подождите немного и повторите попытку",
    ),
    "networkRequestFailed": m35,
    "networkServerError": m36,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Скорость сети"),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "Время ожидания запроса истекло. Проверьте сеть или прокси и повторите попытку",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "Не удалось установить защищённое соединение. Сертификат сервера может быть недействителен, или соединение перехватывается",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("Тип сети"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("Нейтральная"),
    "newMessageFromSupport": MessageLookupByLibrary.simpleMessage(
      "Новое сообщение от поддержки",
    ),
    "newPassword": MessageLookupByLibrary.simpleMessage("Новый пароль"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("Следующее совпадение"),
    "no": MessageLookupByLibrary.simpleMessage("Нет"),
    "noCommissionRecord": MessageLookupByLibrary.simpleMessage(
      "Нет записей о комиссиях",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("Нет данных"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("Нет горячей клавиши"),
    "noIcon": MessageLookupByLibrary.simpleMessage("Нет иконки"),
    "noInfo": MessageLookupByLibrary.simpleMessage("Нет информации"),
    "noInvitationData": MessageLookupByLibrary.simpleMessage(
      "Нет данных о приглашениях",
    ),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Больше не напоминать",
    ),
    "noMoreInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Нет дополнительной информации",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("Нет сети"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("Приложения без сети"),
    "noProxy": MessageLookupByLibrary.simpleMessage("Нет прокси"),
    "noProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, создайте профиль или добавьте действительный профиль",
    ),
    "noRecords": MessageLookupByLibrary.simpleMessage("Записей пока нет"),
    "noResolve": MessageLookupByLibrary.simpleMessage("Не разрешать IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage(
      "Не разрешать имя хоста",
    ),
    "noSearchResults": MessageLookupByLibrary.simpleMessage(
      "Ничего не найдено",
    ),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage(
      "Этот внешний ресурс не является текстовым файлом",
    ),
    "none": MessageLookupByLibrary.simpleMessage("Нет"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "Текущую группу прокси нельзя выбрать",
    ),
    "ntpInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал синхронизации (минуты)",
    ),
    "ntpStatusDesc": MessageLookupByLibrary.simpleMessage(
      "Брать время с NTP-сервера, а не из системных часов",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Добавьте профиль, чтобы начать",
    ),
    "nullTip": m37,
    "numberTip": m38,
    "onDemand": MessageLookupByLibrary.simpleMessage("По условию"),
    "onDemandDesc": MessageLookupByLibrary.simpleMessage(
      "Настройте состояние работы приложения для определённых сценариев",
    ),
    "oneColumn": MessageLookupByLibrary.simpleMessage("Один столбец"),
    "onlineSupport": MessageLookupByLibrary.simpleMessage("Онлайн поддержка"),
    "onlineSupportAddMore": MessageLookupByLibrary.simpleMessage(
      "Добавить еще",
    ),
    "onlineSupportApiConfigNotFound": MessageLookupByLibrary.simpleMessage(
      "Конфигурация API онлайн поддержки не найдена, проверьте настройки",
    ),
    "onlineSupportCancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "onlineSupportClearHistory": MessageLookupByLibrary.simpleMessage(
      "Очистить историю",
    ),
    "onlineSupportClearHistoryConfirm": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите очистить всю историю чата? Это действие нельзя отменить.",
    ),
    "onlineSupportClickToSelect": MessageLookupByLibrary.simpleMessage(
      "Нажмите для выбора изображений",
    ),
    "onlineSupportConfirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "onlineSupportConnected": MessageLookupByLibrary.simpleMessage(
      "Успешно подключено к системе поддержки",
    ),
    "onlineSupportConnecting": MessageLookupByLibrary.simpleMessage(
      "Подключение...",
    ),
    "onlineSupportConnectionError": MessageLookupByLibrary.simpleMessage(
      "Ошибка подключения",
    ),
    "onlineSupportDisconnected": MessageLookupByLibrary.simpleMessage(
      "Отключено",
    ),
    "onlineSupportGetMessagesFailed": m39,
    "onlineSupportInputHint": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите ваш вопрос...",
    ),
    "onlineSupportNoMessages": MessageLookupByLibrary.simpleMessage(
      "Пока нет сообщений, отправьте сообщение для начала консультации",
    ),
    "onlineSupportSelectImages": MessageLookupByLibrary.simpleMessage(
      "Выбрать изображения",
    ),
    "onlineSupportSelectImagesFailed": m40,
    "onlineSupportSend": MessageLookupByLibrary.simpleMessage("Отправить"),
    "onlineSupportSendImage": MessageLookupByLibrary.simpleMessage(
      "Отправить изображение",
    ),
    "onlineSupportSendMessageFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить сообщение: Невозможно получить токен аутентификации",
    ),
    "onlineSupportSupportedFormats": MessageLookupByLibrary.simpleMessage(
      "Поддерживает JPG, PNG, GIF, WebP, BMP\nМакс 10МБ",
    ),
    "onlineSupportTitle": MessageLookupByLibrary.simpleMessage(
      "Онлайн поддержка",
    ),
    "onlineSupportTokenNotFound": MessageLookupByLibrary.simpleMessage(
      "Токен аутентификации не найден",
    ),
    "onlineSupportUnsupportedHttpMethod": m41,
    "onlineSupportUploadFailed": m42,
    "onlineSupportWebSocketConfigNotFound": MessageLookupByLibrary.simpleMessage(
      "Конфигурация WebSocket онлайн поддержки не найдена, проверьте настройки",
    ),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("Только иконка"),
    "onlyOtherApps": MessageLookupByLibrary.simpleMessage(
      "Только сторонние приложения",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Учитывать только трафик прокси",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "При включении будет учитываться только трафик прокси",
    ),
    "openWebFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть сайт, посетите его вручную",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("Необязательно"),
    "options": MessageLookupByLibrary.simpleMessage("Опции"),
    "orderAmount": m43,
    "orderNumber": m44,
    "other": MessageLookupByLibrary.simpleMessage("Другое"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Другие участники",
    ),
    "outboundIp": MessageLookupByLibrary.simpleMessage("Исходящий IP"),
    "outboundMode": MessageLookupByLibrary.simpleMessage(
      "Режим исходящего трафика",
    ),
    "override": MessageLookupByLibrary.simpleMessage("Переопределение"),
    "overrideDesc": MessageLookupByLibrary.simpleMessage(
      "Переопределить конфигурацию, связанную с прокси",
    ),
    "overrideDns": MessageLookupByLibrary.simpleMessage("Переопределить DNS"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "Включение переопределит настройки DNS в профиле",
    ),
    "overrideEntries": MessageLookupByLibrary.simpleMessage(
      "Переопределяемые параметры",
    ),
    "overrideInvalidTip": MessageLookupByLibrary.simpleMessage(
      "В скриптовом режиме не действует",
    ),
    "overrideMode": MessageLookupByLibrary.simpleMessage(
      "Режим переопределения",
    ),
    "overrideNtp": MessageLookupByLibrary.simpleMessage("Переопределить NTP"),
    "overrideOriginRules": MessageLookupByLibrary.simpleMessage(
      "Переопределить оригинальное правило",
    ),
    "overrideScript": MessageLookupByLibrary.simpleMessage(
      "Скрипт переопределения",
    ),
    "overwriteIssueCoreRejected": m45,
    "overwriteIssueDuplicateName": m46,
    "overwriteIssueEmptyName": MessageLookupByLibrary.simpleMessage(
      "Имя не задано",
    ),
    "overwriteIssueGroupLoop": m47,
    "overwriteIssueMissingProviders": m48,
    "overwriteIssueMissingProxies": m49,
    "overwriteIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "Не выбраны ни прокси, ни провайдеры прокси, поэтому ядро отклонит эту группу",
    ),
    "overwriteIssueReservedName": m50,
    "overwriteIssueSubscriptionGroupMissingProxies": m51,
    "overwriteIssuesSummary": m52,
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage(
      "Пользовательский",
    ),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "Пользовательский режим: полная настройка прокси, групп прокси и правил",
    ),
    "pageNumber": m53,
    "palette": MessageLookupByLibrary.simpleMessage("Палитра"),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "passwordMin8Chars": MessageLookupByLibrary.simpleMessage(
      "Пароль должен содержать не менее 8 символов",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Пароль должен содержать не менее 6 символов",
    ),
    "passwordMismatch": MessageLookupByLibrary.simpleMessage(
      "Пароли не совпадают",
    ),
    "passwordResetFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось сбросить пароль",
    ),
    "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
      "Пароль успешно сброшен! Войдите с новым паролем",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Пароли не совпадают",
    ),
    "paste": MessageLookupByLibrary.simpleMessage("Вставить"),
    "pendingCommission": MessageLookupByLibrary.simpleMessage("Ожидает"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("Выбрать из галереи"),
    "pinWindow": MessageLookupByLibrary.simpleMessage(
      "Закрепить поверх всех окон",
    ),
    "plans": MessageLookupByLibrary.simpleMessage("Планы"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Привяжите WebDAV",
    ),
    "pleaseConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Повторите новый пароль",
    ),
    "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Подтвердите пароль",
    ),
    "pleaseEnterAtLeast8CharsPassword": MessageLookupByLibrary.simpleMessage(
      "Введите пароль не менее 8 символов",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Введите адрес электронной почты",
    ),
    "pleaseEnterEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Введите адрес электронной почты",
    ),
    "pleaseEnterEmailVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Введите код подтверждения по email",
    ),
    "pleaseEnterInviteCode": MessageLookupByLibrary.simpleMessage(
      "Введите пригласительный код",
    ),
    "pleaseEnterNewPassword": MessageLookupByLibrary.simpleMessage(
      "Введите новый пароль",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Введите пароль",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Введите название скрипта",
    ),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Введите корректный адрес электронной почты",
    ),
    "pleaseEnterValidEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Введите корректный адрес электронной почты",
    ),
    "pleaseEnterValidVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Введите корректный код подтверждения",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Введите код подтверждения по email",
    ),
    "pleaseEnterYourEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Введите ваш адрес электронной почты",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите пароль администратора",
    ),
    "pleaseReEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Повторите пароль",
    ),
    "pleaseUploadFile": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, загрузите файл",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Загрузите корректный QR-код",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Порт"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Введите другой порт",
    ),
    "portTip": m54,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "Приоритетное использование HTTP/3 для DOH",
    ),
    "prerequisites": MessageLookupByLibrary.simpleMessage(
      "Предварительные условия",
    ),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Нажмите сочетание клавиш",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Предпросмотр"),
    "previousMatch": MessageLookupByLibrary.simpleMessage(
      "Предыдущее совпадение",
    ),
    "process": MessageLookupByLibrary.simpleMessage("Процесс"),
    "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("Введите корректный интервал"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("Введите интервал автообновления"),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "Профиль изменён. Отключить автообновление?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Введите название профиля",
    ),
    "profileParseErrorDesc": MessageLookupByLibrary.simpleMessage(
      "ошибка разбора профиля",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Введите корректный URL профиля",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Введите URL профиля",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Профили"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Сортировка профилей"),
    "project": MessageLookupByLibrary.simpleMessage("Проект"),
    "providerInUse": m55,
    "providerRenameShadowed": m56,
    "providerSourceSubscription": MessageLookupByLibrary.simpleMessage(
      "Подписка",
    ),
    "providerUrlTip": MessageLookupByLibrary.simpleMessage(
      "Поддерживаются только удалённые ресурсы",
    ),
    "providers": MessageLookupByLibrary.simpleMessage("Внешние ресурсы"),
    "proxies": MessageLookupByLibrary.simpleMessage("Прокси"),
    "proxiesCount": m57,
    "proxiesEmpty": MessageLookupByLibrary.simpleMessage("Список прокси пуст"),
    "proxiesSetting": MessageLookupByLibrary.simpleMessage("Настройка прокси"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("Цепочка прокси"),
    "proxyDefinition": MessageLookupByLibrary.simpleMessage(
      "Полная конфигурация",
    ),
    "proxyDefinitionNotMap": MessageLookupByLibrary.simpleMessage(
      "Конфигурация должна быть YAML-словарём с полями name и type",
    ),
    "proxyDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Обнаружена аномалия выбранных прокси",
    ),
    "proxyFilter": MessageLookupByLibrary.simpleMessage("Фильтр узлов"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Группа прокси"),
    "proxyGroupDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Обнаружена аномалия текущей группы прокси",
    ),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage(
      "Группа прокси пуста",
    ),
    "proxyGroupNameDuplicate": MessageLookupByLibrary.simpleMessage(
      "Название группы прокси уже используется",
    ),
    "proxyGroupNameEmpty": MessageLookupByLibrary.simpleMessage(
      "Имя группы прокси не может быть пустым",
    ),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage(
      "Прокси-сервер имен",
    ),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Домен для разрешения прокси-узлов",
    ),
    "proxyNode": MessageLookupByLibrary.simpleMessage("Прокси-узел"),
    "proxyPort": MessageLookupByLibrary.simpleMessage("Порт прокси"),
    "proxyPortDesc": MessageLookupByLibrary.simpleMessage(
      "Установить порт прослушивания Clash",
    ),
    "proxyProviderDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Обнаружена аномалия выбранных провайдеров прокси",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Провайдеры прокси"),
    "proxyProvidersEmpty": MessageLookupByLibrary.simpleMessage(
      "Список провайдеров прокси пуст",
    ),
    "proxyProvidersNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Провайдеры прокси не могут быть пустыми",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("Тип прокси"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Очистить кэш"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("Чисто чёрный"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Чисто чёрный режим"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR-код"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Сканируйте QR-код, чтобы получить профиль",
    ),
    "quickAdd": MessageLookupByLibrary.simpleMessage("Быстрое добавление"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("Быстрое редактирование"),
    "quickFill": MessageLookupByLibrary.simpleMessage("Быстрое заполнение"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("Радуга"),
    "recentRequests": MessageLookupByLibrary.simpleMessage("Последние запросы"),
    "recordType": MessageLookupByLibrary.simpleMessage("Тип записи"),
    "recovery": MessageLookupByLibrary.simpleMessage("Восстановление"),
    "recoveryAll": MessageLookupByLibrary.simpleMessage(
      "Восстановить все данные",
    ),
    "recoveryProfiles": MessageLookupByLibrary.simpleMessage(
      "Только восстановление профилей",
    ),
    "recoveryStrategy": MessageLookupByLibrary.simpleMessage(
      "Стратегия восстановления",
    ),
    "recoveryStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Совместимый",
    ),
    "recoveryStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Переопределение",
    ),
    "recoverySuccess": MessageLookupByLibrary.simpleMessage(
      "Восстановление успешно",
    ),
    "redirPort": MessageLookupByLibrary.simpleMessage("Порт Redir"),
    "redo": MessageLookupByLibrary.simpleMessage("Повторить"),
    "refresh": MessageLookupByLibrary.simpleMessage("Обновить"),
    "regExp": MessageLookupByLibrary.simpleMessage("Регулярное выражение"),
    "registerAccount": MessageLookupByLibrary.simpleMessage(
      "Зарегистрировать аккаунт",
    ),
    "registerSuccessSaveCredentials": MessageLookupByLibrary.simpleMessage(
      "Регистрация успешна - Сохранение учётных данных:",
    ),
    "registrationFailed": m58,
    "releaseMemory": MessageLookupByLibrary.simpleMessage("Освободить память"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось освободить память",
    ),
    "rememberPassword": MessageLookupByLibrary.simpleMessage(
      "Запомнить пароль?",
    ),
    "remote": MessageLookupByLibrary.simpleMessage("Удалённо"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование локальных данных на WebDAV",
    ),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Удалённое назначение",
    ),
    "remoteRecoveryDesc": MessageLookupByLibrary.simpleMessage(
      "Восстановление данных с WebDAV",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Убрать"),
    "rename": MessageLookupByLibrary.simpleMessage("Переименовать"),
    "replace": MessageLookupByLibrary.simpleMessage("Заменить"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("Заменить все"),
    "request": MessageLookupByLibrary.simpleMessage("Запрос"),
    "requests": MessageLookupByLibrary.simpleMessage("Запросы"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage(
      "Запросы и обновления",
    ),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "Просмотр последних записей запросов",
    ),
    "resendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Отправить код подтверждения повторно",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Сброс"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "На этой странице есть изменения. Вы уверены, что хотите выполнить сброс?",
    ),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Сбросить пароль"),
    "resetTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите выполнить сброс?",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("Ресурсы"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "Информация, связанная с внешними ресурсами",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("Соблюдать правила"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS-соединения следуют правилам; требуется Proxy Server Nameserver",
    ),
    "responseCode": MessageLookupByLibrary.simpleMessage("Код ответа"),
    "restart": MessageLookupByLibrary.simpleMessage("Перезапустить"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите перезапустить ядро?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Восстановить"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage(
      "Восстановить все данные",
    ),
    "restoreException": MessageLookupByLibrary.simpleMessage(
      "Ошибка восстановления",
    ),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage(
      "Восстановить данные из файла",
    ),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "Восстановить данные через WebDAV",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Восстановить только профили",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage(
      "Стратегия восстановления",
    ),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage(
      "Совместимость",
    ),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage(
      "Перезапись",
    ),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Совместимый",
    ),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Перезаписать",
    ),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage(
      "Восстановление выполнено",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Адреса маршрутов"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "Настройка адреса прослушивания маршрутизации",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("Режим маршрутизации"),
    "routeModeBypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Обходить частные адреса",
    ),
    "routeModeConfig": MessageLookupByLibrary.simpleMessage(
      "Использовать конфигурацию",
    ),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Обход частных адресов маршрутизации",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage(
      "Использовать конфигурацию",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("Русский"),
    "rule": MessageLookupByLibrary.simpleMessage("Правило"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило AND",
    ),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить полный домен",
    ),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ключевое слово в домене",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по регулярному выражению домена",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить суффикс домена",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставление по маске; поддерживаются только * и ?",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить метку DSCP (только для входящих tproxy UDP)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон портов назначения",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить код страны IP-адреса",
    ),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить домены из Geosite",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить имя входящего подключения",
    ),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить входящий порт",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить тип входящего подключения",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить имя пользователя входящего подключения; несколько имён разделяются /",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ASN, которой принадлежит IP",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон IP-адресов; IP-CIDR6 — просто псевдоним",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон IP-адресов",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон суффиксов IP",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставляет все запросы, условия не нужны",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить TCP или UDP",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило NOT",
    ),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило OR",
    ),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по имени процесса; на Android соответствует имени пакета",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по регулярному выражению имени процесса; на Android соответствует имени пакета",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по маске имени процесса; поддерживаются только * и ?",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по полному пути процесса",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по регулярному выражению пути процесса",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по маске пути процесса; поддерживаются только * и ?",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить имя повторного сопоставления; несколько имён разделяются /",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "Ссылка на набор правил; требуется настроить rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить код страны IP источника",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ASN IP источника",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон IP-адресов источника",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон суффиксов IP источника",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон портов источника",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "Переход к подправилу; обратите внимание на скобки",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить Linux USER ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("Правило пусто"),
    "ruleName": MessageLookupByLibrary.simpleMessage("Название правила"),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BitTorrent напрямую",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "Блокировать DNS over TLS",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage(
      "Блокировать QUIC",
    ),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage(
      "Блокировать STUN",
    ),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage(
      "Локальная сеть напрямую",
    ),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple и Microsoft напрямую",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Провайдеры правил"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("Набор правил"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Цель правила"),
    "rules": MessageLookupByLibrary.simpleMessage("Правила"),
    "rulesCount": m59,
    "runTime": MessageLookupByLibrary.simpleMessage("Время работы"),
    "safeMode": MessageLookupByLibrary.simpleMessage("Безопасный режим"),
    "safeModeAppTitle": m60,
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Сохранить изменения?"),
    "saveQr": MessageLookupByLibrary.simpleMessage("Сохранить QR"),
    "saveQrCodeFeature": MessageLookupByLibrary.simpleMessage(
      "Функция сохранения QR скоро появится",
    ),
    "saveTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите сохранить?",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Скрипт"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Режим скрипта: использует внешние скрипты-расширения для переопределения конфигурации в один клик",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage(
      "Прокрутить к выбранному",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "seconds": MessageLookupByLibrary.simpleMessage("секунд"),
    "secondsCount": m61,
    "selectAll": MessageLookupByLibrary.simpleMessage("Выбрать всё"),
    "selectProxies": MessageLookupByLibrary.simpleMessage("Выбрать прокси"),
    "selectProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Выбрать провайдеров прокси",
    ),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage(
      "Выберите набор правил",
    ),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "Выберите стратегию распределения",
    ),
    "selectSubRule": MessageLookupByLibrary.simpleMessage(
      "Выберите подправило",
    ),
    "selectTheme": MessageLookupByLibrary.simpleMessage("Выбрать тему"),
    "selected": MessageLookupByLibrary.simpleMessage("Выбрано"),
    "selectedCountTitle": m62,
    "sendCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить код подтверждения",
    ),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Отправить код подтверждения",
    ),
    "sendVerificationCodeFailed": m63,
    "server": MessageLookupByLibrary.simpleMessage("Сервер"),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("Доступен"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("Заблокировано"),
    "serviceCheck": MessageLookupByLibrary.simpleMessage("Проверить"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("Проверить все"),
    "serviceCheckedAt": m64,
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("Скоро появится"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage(
      "Недопустимый провайдер",
    ),
    "serviceFailed": MessageLookupByLibrary.simpleMessage("Ошибка проверки"),
    "serviceManage": MessageLookupByLibrary.simpleMessage(
      "Управление сервисами",
    ),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage(
      "Только оригиналы",
    ),
    "servicePending": MessageLookupByLibrary.simpleMessage("Не проверено"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage(
      "Доступ ограничен",
    ),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("Состояние сервисов"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("Недоступен"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage(
      "Регион не поддерживается",
    ),
    "setNewPassword": MessageLookupByLibrary.simpleMessage(
      "Задать новый пароль",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "show": MessageLookupByLibrary.simpleMessage("Показать"),
    "showLess": MessageLookupByLibrary.simpleMessage("Свернуть"),
    "showMore": MessageLookupByLibrary.simpleMessage("Развернуть"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "Кнопка остановки в уведомлении",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("Показать пароль"),
    "shrink": MessageLookupByLibrary.simpleMessage("Компактный"),
    "sidebarBlur": MessageLookupByLibrary.simpleMessage(
      "Размытие боковой панели",
    ),
    "sidebarBlurDesc": MessageLookupByLibrary.simpleMessage(
      "Показывать сквозь боковую панель размытый рабочий стол за окном",
    ),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("Тихий запуск"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Запускаться без показа окна",
    ),
    "singleAdd": MessageLookupByLibrary.simpleMessage("По одному"),
    "singleValueTip": m65,
    "size": MessageLookupByLibrary.simpleMessage("Размер"),
    "slide": MessageLookupByLibrary.simpleMessage("Сдвиг"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Порт SOCKS"),
    "sort": MessageLookupByLibrary.simpleMessage("Сортировка"),
    "source": MessageLookupByLibrary.simpleMessage("Источник"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("IP источника"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Специальный прокси"),
    "specialRules": MessageLookupByLibrary.simpleMessage("Специальные правила"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage(
      "Статистика скорости",
    ),
    "splitStrategy": MessageLookupByLibrary.simpleMessage(
      "Стратегия распределения",
    ),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Стратегия распределения не может быть пустой",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("Список SSID пуст"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Режим стека"),
    "standard": MessageLookupByLibrary.simpleMessage("Стандартный"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Стандартный режим: переопределяет базовую конфигурацию и позволяет просто добавлять правила",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Старт"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage("С нуля"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Запуск VPN…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage(
      "Запуск и фоновая работа",
    ),
    "status": MessageLookupByLibrary.simpleMessage("Статус"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "При отключении используется системный DNS",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Стоп"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Остановка VPN…"),
    "strategy": MessageLookupByLibrary.simpleMessage("Стратегия"),
    "style": MessageLookupByLibrary.simpleMessage("Стиль"),
    "subRule": MessageLookupByLibrary.simpleMessage("Подправило"),
    "subRuleEmpty": MessageLookupByLibrary.simpleMessage("Подправило пусто"),
    "subRuleNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Подправило не может быть пустым",
    ),
    "submit": MessageLookupByLibrary.simpleMessage("Отправить"),
    "subscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "Подписка истекла",
    ),
    "subscriptionExpiredDetail": m66,
    "subscriptionExpiresToday": MessageLookupByLibrary.simpleMessage(
      "Подписка истекает сегодня",
    ),
    "subscriptionExpiresTodayDetail": MessageLookupByLibrary.simpleMessage(
      "План истёк сегодня, пожалуйста немедленно продлите чтобы избежать прерывания сервиса",
    ),
    "subscriptionExpiringInDays": MessageLookupByLibrary.simpleMessage(
      "Подписка скоро истекает",
    ),
    "subscriptionExpiringInDaysDetail": m67,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Информация о подписке",
    ),
    "subscriptionNoSubscription": MessageLookupByLibrary.simpleMessage(
      "Нет подписки",
    ),
    "subscriptionNoSubscriptionDetail": MessageLookupByLibrary.simpleMessage(
      "Не найдено доступных планов подписок, пожалуйста купите план для использования",
    ),
    "subscriptionNotLoggedIn": MessageLookupByLibrary.simpleMessage(
      "Не авторизован",
    ),
    "subscriptionNotLoggedInDetail": MessageLookupByLibrary.simpleMessage(
      "Сначала войдите в систему",
    ),
    "subscriptionTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "Трафик исчерпан",
    ),
    "subscriptionTrafficExhaustedDetail": MessageLookupByLibrary.simpleMessage(
      "Трафик плана использован полностью, пожалуйста купите больше трафика или обновите план",
    ),
    "subscriptionValid": MessageLookupByLibrary.simpleMessage(
      "Подписка действительна",
    ),
    "subscriptionValidDetail": m68,
    "suspended": MessageLookupByLibrary.simpleMessage("Приостановлено…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("Сменить профиль"),
    "switchTheme": MessageLookupByLibrary.simpleMessage("Переключить тему"),
    "sync": MessageLookupByLibrary.simpleMessage("Синхронизация"),
    "system": MessageLookupByLibrary.simpleMessage("Система"),
    "systemApp": MessageLookupByLibrary.simpleMessage("Системные приложения"),
    "systemFont": MessageLookupByLibrary.simpleMessage("Системный шрифт"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Прикрепить HTTP-прокси к VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Вкладки"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Анимация вкладок"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "Действительно только в мобильном виде",
    ),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы разрешить",
    ),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("Параллельный TCP"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "Включение позволит использовать параллелизм TCP",
    ),
    "testInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал тестирования",
    ),
    "testUrl": MessageLookupByLibrary.simpleMessage("URL для теста"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage(
      "Тестировать при использовании",
    ),
    "textScale": MessageLookupByLibrary.simpleMessage("Масштаб текста"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage(
      "Так будет выглядеть текст в приложении",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Тема"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Цвет темы"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "Тёмный режим и настройка цветов",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Режим темы"),
    "threeColumns": MessageLookupByLibrary.simpleMessage("Три столбца"),
    "tight": MessageLookupByLibrary.simpleMessage("Плотный"),
    "time": MessageLookupByLibrary.simpleMessage("Время"),
    "timeout": MessageLookupByLibrary.simpleMessage("Тайм-аут"),
    "tip": MessageLookupByLibrary.simpleMessage("Подсказка"),
    "toggle": MessageLookupByLibrary.simpleMessage("Переключить"),
    "tolerance": MessageLookupByLibrary.simpleMessage("Допуск"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("Тональный акцент"),
    "tools": MessageLookupByLibrary.simpleMessage("Инструменты"),
    "torch": MessageLookupByLibrary.simpleMessage("Фонарик"),
    "total": MessageLookupByLibrary.simpleMessage("Всего"),
    "totalCommission": MessageLookupByLibrary.simpleMessage("Заработок"),
    "totalInvites": MessageLookupByLibrary.simpleMessage("Приглашения"),
    "totalRecords": m69,
    "totalTraffic": MessageLookupByLibrary.simpleMessage("Общий трафик"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Порт TProxy"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Статистика трафика"),
    "transfer": MessageLookupByLibrary.simpleMessage("Перевод"),
    "transferAmount": MessageLookupByLibrary.simpleMessage("Сумма перевода"),
    "transferAmountExceeded": m70,
    "transferFailed": m71,
    "transferNote": MessageLookupByLibrary.simpleMessage(
      "Переведённый баланс можно использовать для покупок в приложении",
    ),
    "transferSuccess": MessageLookupByLibrary.simpleMessage(
      "Перевод выполнен успешно!",
    ),
    "transferSuccessMsg": m72,
    "transferToWallet": MessageLookupByLibrary.simpleMessage(
      "Перевести в кошелёк",
    ),
    "transferring": MessageLookupByLibrary.simpleMessage("Перевод..."),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "Работает только в режиме администратора",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Выключить"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Включить"),
    "twoColumns": MessageLookupByLibrary.simpleMessage("Два столбца"),
    "unableToUpdateCurrentProfileDesc": MessageLookupByLibrary.simpleMessage(
      "невозможно обновить текущий профиль",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("Отменить"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Единая задержка"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "Убрать дополнительные задержки, такие как рукопожатие",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Неизвестно"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Неизвестная сетевая ошибка",
    ),
    "unmaximize": MessageLookupByLibrary.simpleMessage("Свернуть в окно"),
    "unnamed": MessageLookupByLibrary.simpleMessage("Без названия"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("Открепить окно"),
    "update": MessageLookupByLibrary.simpleMessage("Обновить"),
    "updateCheckAllServersUnavailable": MessageLookupByLibrary.simpleMessage(
      "Все настроенные серверы обновлений недоступны",
    ),
    "updateCheckCurrentVersion": m73,
    "updateCheckForceUpdate": m74,
    "updateCheckMustUpdate": MessageLookupByLibrary.simpleMessage(
      "Необходимо обновить",
    ),
    "updateCheckNewVersionFound": m75,
    "updateCheckNoServerUrlsConfigured": MessageLookupByLibrary.simpleMessage(
      "URL серверов обновлений не настроены, проверьте конфигурацию",
    ),
    "updateCheckReleaseNotes": MessageLookupByLibrary.simpleMessage(
      "Примечания к выпуску:",
    ),
    "updateCheckServerError": m76,
    "updateCheckServerTemporarilyUnavailable":
        MessageLookupByLibrary.simpleMessage(
          "Сервер временно недоступен, попробуйте позже",
        ),
    "updateCheckServerUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "URL сервера обновлений не настроен, проверьте конфигурацию",
    ),
    "updateCheckUpdateLater": MessageLookupByLibrary.simpleMessage(
      "Обновить позже",
    ),
    "updateCheckUpdateNow": MessageLookupByLibrary.simpleMessage(
      "Обновить сейчас",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("Отдача"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage("Получить профиль по URL"),
    "urlTip": m77,
    "useHosts": MessageLookupByLibrary.simpleMessage("Использовать hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage(
      "Использовать системный hosts",
    ),
    "usedTraffic": MessageLookupByLibrary.simpleMessage(
      "Использованный трафик",
    ),
    "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
    "userCenter": MessageLookupByLibrary.simpleMessage("Личный кабинет"),
    "value": MessageLookupByLibrary.simpleMessage("Значение"),
    "verificationCode": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения",
    ),
    "verificationCode6Digits": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения должен содержать 6 цифр",
    ),
    "verificationCodeSent": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения отправлен на вашу почту, проверьте",
    ),
    "verificationCodeSentCheckEmail": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения отправлен, проверьте вашу почту",
    ),
    "verificationCodeSentTo": m78,
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("Яркая"),
    "view": MessageLookupByLibrary.simpleMessage("Просмотр"),
    "viewHistory": MessageLookupByLibrary.simpleMessage("Просмотреть историю"),
    "visitWebVersion": MessageLookupByLibrary.simpleMessage(
      "Для вывода средств посетите веб-версию",
    ),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "Обнаружено изменение настроек VPN",
    ),
    "vpnDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение настроек, связанных с VPN",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически направляет весь системный трафик через VpnService",
    ),
    "vpnSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Прикрепить HTTP-прокси к VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "Изменения вступят в силу после перезапуска VPN",
    ),
    "walletBalance": MessageLookupByLibrary.simpleMessage("Баланс"),
    "walletDetails": MessageLookupByLibrary.simpleMessage("Детали кошелька"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "Настройка WebDAV",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage(
      "Режим белого списка",
    ),
    "withdraw": MessageLookupByLibrary.simpleMessage("Вывести"),
    "withdrawCommission": MessageLookupByLibrary.simpleMessage(
      "Вывести комиссию",
    ),
    "withdrawableAmount": m79,
    "withdrawalAvailable": MessageLookupByLibrary.simpleMessage(
      "Доступную комиссию можно вывести",
    ),
    "writeToSystem": MessageLookupByLibrary.simpleMessage(
      "Записывать в систему",
    ),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "Также устанавливать системные часы; Android это игнорирует",
    ),
    "xboard": MessageLookupByLibrary.simpleMessage("Мой"),
    "xboard24HourCustomerService": MessageLookupByLibrary.simpleMessage(
      "24-часовая поддержка клиентов",
    ),
    "xboardAccountBalance": MessageLookupByLibrary.simpleMessage(
      "Баланс счёта",
    ),
    "xboardAddLinkToConfig": MessageLookupByLibrary.simpleMessage(
      "Добавьте эту ссылку подписки в вашу конфигурацию",
    ),
    "xboardAddingToConfigList": MessageLookupByLibrary.simpleMessage(
      "Добавление в список конфигураций",
    ),
    "xboardAfterPurchasingPlan": MessageLookupByLibrary.simpleMessage(
      "После покупки плана вы получите:",
    ),
    "xboardApiUrlNotConfigured": MessageLookupByLibrary.simpleMessage(
      "URL API не настроен",
    ),
    "xboardAutoCheckEvery5Seconds": MessageLookupByLibrary.simpleMessage(
      "Система проверяет каждые 5 секунд, автоматически перенаправит после оплаты",
    ),
    "xboardAutoDetectPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "Автоопределение статуса оплаты",
    ),
    "xboardAutoOpeningPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Автоматически открывается страница оплаты, вернитесь в приложение после оплаты",
    ),
    "xboardAutoTesting": MessageLookupByLibrary.simpleMessage(
      "Автоматическое тестирование",
    ),
    "xboardBack": MessageLookupByLibrary.simpleMessage("Назад"),
    "xboardBrowserNotOpenedTip": MessageLookupByLibrary.simpleMessage(
      "Если браузер не открылся автоматически, нажмите \\\"Открыть заново\\\" или скопируйте ссылку вручную",
    ),
    "xboardBuyMoreTrafficOrUpgrade": MessageLookupByLibrary.simpleMessage(
      "Купите больше трафика или обновите план",
    ),
    "xboardBuyNow": MessageLookupByLibrary.simpleMessage("Купить сейчас"),
    "xboardBuyoutPlan": MessageLookupByLibrary.simpleMessage("План выкупа"),
    "xboardCancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "xboardCancelPayment": MessageLookupByLibrary.simpleMessage(
      "Отменить платёж",
    ),
    "xboardCheckPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось проверить статус оплаты",
    ),
    "xboardCheckStatus": MessageLookupByLibrary.simpleMessage(
      "Проверить статус",
    ),
    "xboardChecking": MessageLookupByLibrary.simpleMessage("Проверка"),
    "xboardCleaningOldConfig": MessageLookupByLibrary.simpleMessage(
      "Очистка старой конфигурации",
    ),
    "xboardClearError": MessageLookupByLibrary.simpleMessage("Очистить ошибку"),
    "xboardClickToCopy": MessageLookupByLibrary.simpleMessage(
      "Нажмите для копирования",
    ),
    "xboardClickToSetupNodes": MessageLookupByLibrary.simpleMessage(
      "Нажмите для настройки узлов",
    ),
    "xboardCompletePaymentInBrowser": MessageLookupByLibrary.simpleMessage(
      "2. Завершите оплату в браузере",
    ),
    "xboardConfigDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "Загрузка конфигурации не удалась, проверьте ссылку подписки",
    ),
    "xboardConfigFormatError": MessageLookupByLibrary.simpleMessage(
      "Ошибка формата конфигурации, обратитесь к поставщику услуг",
    ),
    "xboardConfigSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Сохранение конфигурации не удалось, проверьте место на диске",
    ),
    "xboardConfigurationError": MessageLookupByLibrary.simpleMessage(
      "Ошибка конфигурации",
    ),
    "xboardConfirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "xboardConfirmAction": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "xboardConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Подтверждение пароля",
    ),
    "xboardConfirmPurchase": MessageLookupByLibrary.simpleMessage(
      "Подтвердить покупку",
    ),
    "xboardCongratulationsSubscriptionActivated":
        MessageLookupByLibrary.simpleMessage(
          "Поздравляем! Ваша подписка была успешно приобретена и активирована",
        ),
    "xboardConnectGlobalQualityNodes": MessageLookupByLibrary.simpleMessage(
      "Подключитесь к глобальным качественным узлам",
    ),
    "xboardConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Таймаут соединения, проверьте сетевое подключение",
    ),
    "xboardCopyFailed": MessageLookupByLibrary.simpleMessage(
      "Копирование не удалось",
    ),
    "xboardCopyLink": MessageLookupByLibrary.simpleMessage(
      "Скопировать ссылку",
    ),
    "xboardCopyPaymentLink": MessageLookupByLibrary.simpleMessage(
      "Скопировать ссылку",
    ),
    "xboardCopySubscriptionLinkAbove": MessageLookupByLibrary.simpleMessage(
      "Скопируйте ссылку на подписку выше",
    ),
    "xboardCouponExpired": MessageLookupByLibrary.simpleMessage(
      "Срок действия купона истёк",
    ),
    "xboardCouponNotYetActive": MessageLookupByLibrary.simpleMessage(
      "Купон ещё не активен",
    ),
    "xboardCouponOptional": MessageLookupByLibrary.simpleMessage(
      "Купон (опционально)",
    ),
    "xboardCreatingOrder": MessageLookupByLibrary.simpleMessage(
      "Создание заказа",
    ),
    "xboardCreatingOrderPleaseWait": MessageLookupByLibrary.simpleMessage(
      "Мы создаём новый заказ для вас, пожалуйста, подождите",
    ),
    "xboardCurrentNode": MessageLookupByLibrary.simpleMessage("Текущий узел"),
    "xboardCurrentVersion": MessageLookupByLibrary.simpleMessage(
      "Текущая версия",
    ),
    "xboardDays": MessageLookupByLibrary.simpleMessage("дней"),
    "xboardDeductibleDuringPayment": MessageLookupByLibrary.simpleMessage(
      "Вычитается при оплате",
    ),
    "xboardDiscounted": MessageLookupByLibrary.simpleMessage("Со скидкой"),
    "xboardDownloadingConfig": MessageLookupByLibrary.simpleMessage(
      "Загрузка файла конфигурации",
    ),
    "xboardEmail": MessageLookupByLibrary.simpleMessage("Электронная почта"),
    "xboardEnableTun": MessageLookupByLibrary.simpleMessage("Включить TUN"),
    "xboardEnjoyFastNetworkExperience": MessageLookupByLibrary.simpleMessage(
      "Наслаждайтесь быстрым сетевым опытом",
    ),
    "xboardEnterCouponCode": MessageLookupByLibrary.simpleMessage(
      "Введите код купона",
    ),
    "xboardExcellent": MessageLookupByLibrary.simpleMessage("Отлично"),
    "xboardExpiryTime": MessageLookupByLibrary.simpleMessage("Время истечения"),
    "xboardFailedToCheckPaymentStatus": MessageLookupByLibrary.simpleMessage(
      "Не удалось проверить статус оплаты",
    ),
    "xboardFailedToGetSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить информацию о подписке",
    ),
    "xboardFailedToOpenPaymentLink": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть ссылку оплаты",
    ),
    "xboardFailedToOpenPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть страницу оплаты",
    ),
    "xboardFair": MessageLookupByLibrary.simpleMessage("Удовлетворительно"),
    "xboardForceUpdate": MessageLookupByLibrary.simpleMessage(
      "Принудительное обновление",
    ),
    "xboardForgotPassword": MessageLookupByLibrary.simpleMessage(
      "Забыли пароль",
    ),
    "xboardGettingIP": MessageLookupByLibrary.simpleMessage("Получение..."),
    "xboardGlobalNodes": MessageLookupByLibrary.simpleMessage(
      "Глобальные узлы",
    ),
    "xboardGood": MessageLookupByLibrary.simpleMessage("Хорошо"),
    "xboardGroup": MessageLookupByLibrary.simpleMessage("Группа"),
    "xboardHalfYearlyPayment": MessageLookupByLibrary.simpleMessage(
      "Полугодично",
    ),
    "xboardHandleLater": MessageLookupByLibrary.simpleMessage(
      "Обработать позже",
    ),
    "xboardHandlingFee": MessageLookupByLibrary.simpleMessage(
      "Комиссия за операцию",
    ),
    "xboardHighSpeedNetwork": MessageLookupByLibrary.simpleMessage(
      "Высокоскоростная сеть",
    ),
    "xboardHome": MessageLookupByLibrary.simpleMessage("Главная"),
    "xboardImportFailed": MessageLookupByLibrary.simpleMessage(
      "Импорт не удался",
    ),
    "xboardImportSuccess": MessageLookupByLibrary.simpleMessage(
      "Импорт успешен",
    ),
    "xboardInsufficientBalance": MessageLookupByLibrary.simpleMessage(
      "Недостаточный баланс",
    ),
    "xboardInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Неверное имя пользователя или пароль",
    ),
    "xboardInvalidOrExpiredCoupon": MessageLookupByLibrary.simpleMessage(
      "Недействительный или просроченный код купона",
    ),
    "xboardInvalidResponseFormat": MessageLookupByLibrary.simpleMessage(
      "Неверный формат ответа от сервера",
    ),
    "xboardInviteCode": MessageLookupByLibrary.simpleMessage("Код приглашения"),
    "xboardKeepSubscriptionLinkSafe": MessageLookupByLibrary.simpleMessage(
      "Храните ссылку на подписку в безопасности и не делитесь ею с другими",
    ),
    "xboardLater": MessageLookupByLibrary.simpleMessage("Позже"),
    "xboardLoadingFailed": MessageLookupByLibrary.simpleMessage(
      "Загрузка не удалась",
    ),
    "xboardLoadingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Загрузка страницы оплаты",
    ),
    "xboardLocalIP": MessageLookupByLibrary.simpleMessage("Локальный IP"),
    "xboardLoggedIn": MessageLookupByLibrary.simpleMessage("Авторизован"),
    "xboardLogin": MessageLookupByLibrary.simpleMessage("Вход"),
    "xboardLoginExpired": MessageLookupByLibrary.simpleMessage(
      "Срок входа истёк, войдите снова",
    ),
    "xboardLoginFailed": MessageLookupByLibrary.simpleMessage("Ошибка входа"),
    "xboardLoginSuccess": MessageLookupByLibrary.simpleMessage("Успешный вход"),
    "xboardLoginToViewSubscription": MessageLookupByLibrary.simpleMessage(
      "Войдите в систему для просмотра использования подписки",
    ),
    "xboardLogout": MessageLookupByLibrary.simpleMessage("Выход"),
    "xboardLogoutConfirmContent": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите выйти? Вам потребуется повторно ввести данные для входа.",
    ),
    "xboardLogoutConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Подтверждение выхода",
    ),
    "xboardLogoutFailed": MessageLookupByLibrary.simpleMessage("Ошибка выхода"),
    "xboardLogoutSuccess": MessageLookupByLibrary.simpleMessage(
      "Успешный выход",
    ),
    "xboardMissingRequiredField": MessageLookupByLibrary.simpleMessage(
      "Отсутствует обязательное поле",
    ),
    "xboardMonthlyPayment": MessageLookupByLibrary.simpleMessage("Ежемесячно"),
    "xboardMonthlyRenewal": MessageLookupByLibrary.simpleMessage(
      "Ежемесячное продление",
    ),
    "xboardMustUpdate": MessageLookupByLibrary.simpleMessage(
      "Необходимо обновить",
    ),
    "xboardNetworkConnectionFailed": MessageLookupByLibrary.simpleMessage(
      "Сетевое соединение не удалось, проверьте настройки сети",
    ),
    "xboardNewVersionFound": MessageLookupByLibrary.simpleMessage(
      "Найдена новая версия",
    ),
    "xboardNext": MessageLookupByLibrary.simpleMessage("Следующий"),
    "xboardNoAvailableNodes": MessageLookupByLibrary.simpleMessage(
      "Нет доступных узлов",
    ),
    "xboardNoAvailablePlan": MessageLookupByLibrary.simpleMessage(
      "Нет доступных планов",
    ),
    "xboardNoAvailableSubscription": MessageLookupByLibrary.simpleMessage(
      "Нет доступных подписок",
    ),
    "xboardNoInternetConnection": MessageLookupByLibrary.simpleMessage(
      "Нет интернет-соединения, проверьте настройки сети",
    ),
    "xboardNoSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Нет информации о подписке",
    ),
    "xboardNoSubscriptionPlans": MessageLookupByLibrary.simpleMessage(
      "Нет планов подписки",
    ),
    "xboardNodeName": MessageLookupByLibrary.simpleMessage("Имя узла"),
    "xboardNone": MessageLookupByLibrary.simpleMessage("Нет"),
    "xboardNotLoggedIn": MessageLookupByLibrary.simpleMessage("Не авторизован"),
    "xboardOneTimePayment": MessageLookupByLibrary.simpleMessage("Однократно"),
    "xboardOpenPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть страницу оплаты",
    ),
    "xboardOpenPaymentLinkFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть ссылку на оплату",
    ),
    "xboardOperationFailed": MessageLookupByLibrary.simpleMessage(
      "Операция не удалась",
    ),
    "xboardOperationTips": MessageLookupByLibrary.simpleMessage(
      "Советы по операциям",
    ),
    "xboardOrderCreationFailed": MessageLookupByLibrary.simpleMessage(
      "Создание заказа не удалось",
    ),
    "xboardOrderNotFound": MessageLookupByLibrary.simpleMessage(
      "Заказ не найден",
    ),
    "xboardOrderNumber": MessageLookupByLibrary.simpleMessage("Номер заказа"),
    "xboardOrderStatusPending": MessageLookupByLibrary.simpleMessage(
      "Статус заказа: Ожидает оплаты",
    ),
    "xboardPassword": MessageLookupByLibrary.simpleMessage("Пароль"),
    "xboardPaymentCancelled": MessageLookupByLibrary.simpleMessage(
      "Платёж отменён",
    ),
    "xboardPaymentComplete": MessageLookupByLibrary.simpleMessage(
      "Оплата завершена",
    ),
    "xboardPaymentCompleted": MessageLookupByLibrary.simpleMessage(
      "Оплата завершена!",
    ),
    "xboardPaymentFailed": MessageLookupByLibrary.simpleMessage(
      "Платёж не удался",
    ),
    "xboardPaymentGateway": MessageLookupByLibrary.simpleMessage(
      "Платёжный шлюз",
    ),
    "xboardPaymentInfo": MessageLookupByLibrary.simpleMessage(
      "Информация об оплате",
    ),
    "xboardPaymentInstructions1": MessageLookupByLibrary.simpleMessage(
      "1. Страница оплаты открыта автоматически",
    ),
    "xboardPaymentInstructions2": MessageLookupByLibrary.simpleMessage(
      "2. Пожалуйста, завершите оплату в браузере",
    ),
    "xboardPaymentInstructions3": MessageLookupByLibrary.simpleMessage(
      "3. Вернитесь в приложение после оплаты, система автоматически определит это",
    ),
    "xboardPaymentLink": MessageLookupByLibrary.simpleMessage(
      "Ссылка на оплату",
    ),
    "xboardPaymentLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Ссылка на оплату скопирована в буфер обмена",
    ),
    "xboardPaymentMethodVerified": MessageLookupByLibrary.simpleMessage(
      "Способ оплаты подтверждён",
    ),
    "xboardPaymentMethodVerifiedPreparing": MessageLookupByLibrary.simpleMessage(
      "Способ оплаты подтверждён, готовимся к перенаправлению на страницу оплаты",
    ),
    "xboardPaymentPageAutoOpened": MessageLookupByLibrary.simpleMessage(
      "1. Страница оплаты была открыта автоматически",
    ),
    "xboardPaymentPageOpenedCompleteAndReturn":
        MessageLookupByLibrary.simpleMessage(
          "Страница оплаты открыта, завершите оплату и вернитесь в приложение",
        ),
    "xboardPaymentPageOpenedInBrowser": MessageLookupByLibrary.simpleMessage(
      "Страница оплаты открыта в браузере, вернитесь в приложение после оплаты",
    ),
    "xboardPaymentSuccess": MessageLookupByLibrary.simpleMessage(
      "Платёж успешен",
    ),
    "xboardPaymentSuccessful": MessageLookupByLibrary.simpleMessage(
      "🎉 Платёж успешен!",
    ),
    "xboardPlanInfo": MessageLookupByLibrary.simpleMessage(
      "Информация о плане",
    ),
    "xboardPlanNotFound": MessageLookupByLibrary.simpleMessage(
      "План не найден",
    ),
    "xboardPlans": MessageLookupByLibrary.simpleMessage("Планы"),
    "xboardPleaseSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "Выберите период оплаты",
    ),
    "xboardPoor": MessageLookupByLibrary.simpleMessage("Плохо"),
    "xboardPreparingImport": MessageLookupByLibrary.simpleMessage(
      "Подготовка импорта",
    ),
    "xboardPreparingPaymentPage": MessageLookupByLibrary.simpleMessage(
      "Подготовка страницы оплаты, скоро перенаправим",
    ),
    "xboardPrevious": MessageLookupByLibrary.simpleMessage("Предыдущий"),
    "xboardProcessing": MessageLookupByLibrary.simpleMessage("Обработка..."),
    "xboardProfessionalSupport": MessageLookupByLibrary.simpleMessage(
      "Профессиональная поддержка",
    ),
    "xboardProfile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "xboardProtectNetworkPrivacy": MessageLookupByLibrary.simpleMessage(
      "Защитите вашу сетевую конфиденциальность",
    ),
    "xboardProxy": MessageLookupByLibrary.simpleMessage("Прокси"),
    "xboardProxyMode": MessageLookupByLibrary.simpleMessage("Режим прокси"),
    "xboardProxyModeDirectDescription": MessageLookupByLibrary.simpleMessage(
      "Все соединения прямые, без использования прокси",
    ),
    "xboardProxyModeGlobalDescription": MessageLookupByLibrary.simpleMessage(
      "Весь трафик проходит через прокси-сервер",
    ),
    "xboardProxyModeRuleDescription": MessageLookupByLibrary.simpleMessage(
      "Автоматически выбирать прямое соединение или прокси на основе правил",
    ),
    "xboardPurchasePlan": MessageLookupByLibrary.simpleMessage("Купить план"),
    "xboardPurchaseSubscription": MessageLookupByLibrary.simpleMessage(
      "Купить подписку",
    ),
    "xboardPurchaseSubscriptionToUse": MessageLookupByLibrary.simpleMessage(
      "Купите подписку для использования",
    ),
    "xboardPurchaseTraffic": MessageLookupByLibrary.simpleMessage(
      "Купить трафик",
    ),
    "xboardQuarterlyPayment": MessageLookupByLibrary.simpleMessage(
      "Ежеквартально",
    ),
    "xboardRefresh": MessageLookupByLibrary.simpleMessage("Обновить"),
    "xboardRefreshStatus": MessageLookupByLibrary.simpleMessage(
      "Обновить статус",
    ),
    "xboardRegister": MessageLookupByLibrary.simpleMessage("Регистрация"),
    "xboardRegisterFailed": MessageLookupByLibrary.simpleMessage(
      "Ошибка регистрации",
    ),
    "xboardRegisterSuccess": MessageLookupByLibrary.simpleMessage(
      "Регистрация успешна! Перенаправление на страницу входа...",
    ),
    "xboardReload": MessageLookupByLibrary.simpleMessage("Перезагрузить"),
    "xboardRelogin": MessageLookupByLibrary.simpleMessage("Войти снова"),
    "xboardRememberPassword": MessageLookupByLibrary.simpleMessage(
      "Запомнить пароль",
    ),
    "xboardRenewPlan": MessageLookupByLibrary.simpleMessage("Продлить план"),
    "xboardRenewToContinue": MessageLookupByLibrary.simpleMessage(
      "Продлите подписку для продолжения использования",
    ),
    "xboardReopen": MessageLookupByLibrary.simpleMessage("Открыть заново"),
    "xboardReopenPayment": MessageLookupByLibrary.simpleMessage(
      "Повторно открыть оплату",
    ),
    "xboardReopenPaymentPageTip": MessageLookupByLibrary.simpleMessage(
      "Для повторного открытия нажмите кнопку \\\"Открыть заново\\\" ниже",
    ),
    "xboardRetry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "xboardRetryGet": MessageLookupByLibrary.simpleMessage("Повторить"),
    "xboardReturn": MessageLookupByLibrary.simpleMessage("Вернуться"),
    "xboardReturnAfterPaymentAutoDetect": MessageLookupByLibrary.simpleMessage(
      "3. Вернитесь в приложение после оплаты, система автоматически определит",
    ),
    "xboardRunningTime": m80,
    "xboardSecureEncryption": MessageLookupByLibrary.simpleMessage(
      "Безопасное шифрование",
    ),
    "xboardSelectPaymentMethod": MessageLookupByLibrary.simpleMessage(
      "Выберите способ оплаты",
    ),
    "xboardSelectPaymentPeriod": MessageLookupByLibrary.simpleMessage(
      "Выберите период оплаты",
    ),
    "xboardSelectPeriod": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, выберите период покупки",
    ),
    "xboardSendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Отправить код подтверждения",
    ),
    "xboardServerError": MessageLookupByLibrary.simpleMessage("Ошибка сервера"),
    "xboardSetup": MessageLookupByLibrary.simpleMessage("Настройка"),
    "xboardSixMonthCycle": MessageLookupByLibrary.simpleMessage(
      "6-месячный цикл",
    ),
    "xboardSpeedLimit": MessageLookupByLibrary.simpleMessage(
      "Ограничение скорости",
    ),
    "xboardStartProxy": MessageLookupByLibrary.simpleMessage(
      "Запустить прокси",
    ),
    "xboardStartProxyToSelectNode": MessageLookupByLibrary.simpleMessage(
      "Запустите прокси, чтобы выбрать узлы",
    ),
    "xboardStop": MessageLookupByLibrary.simpleMessage("Остановить"),
    "xboardStopProxy": MessageLookupByLibrary.simpleMessage(
      "Остановить прокси",
    ),
    "xboardSubscription": MessageLookupByLibrary.simpleMessage("Подписка"),
    "xboardSubscriptionCopied": MessageLookupByLibrary.simpleMessage(
      "Ссылка на подписку скопирована в буфер обмена",
    ),
    "xboardSubscriptionExpired": MessageLookupByLibrary.simpleMessage(
      "Срок подписки истёк",
    ),
    "xboardSubscriptionHasExpired": MessageLookupByLibrary.simpleMessage(
      "Подписка истекла",
    ),
    "xboardSubscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Информация о подписке",
    ),
    "xboardSubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Ссылка на подписку",
    ),
    "xboardSubscriptionLinkCopied": MessageLookupByLibrary.simpleMessage(
      "Ссылка на подписку скопирована в буфер обмена",
    ),
    "xboardSubscriptionPurchase": MessageLookupByLibrary.simpleMessage(
      "Покупка подписки",
    ),
    "xboardSubscriptionStatus": MessageLookupByLibrary.simpleMessage(
      "Статус подписки",
    ),
    "xboardSwitch": MessageLookupByLibrary.simpleMessage("Переключить"),
    "xboardTesting": MessageLookupByLibrary.simpleMessage("Тестирование"),
    "xboardThirtySixMonthCycle": MessageLookupByLibrary.simpleMessage(
      "36-месячный цикл",
    ),
    "xboardThreeMonthCycle": MessageLookupByLibrary.simpleMessage(
      "3-месячный цикл",
    ),
    "xboardThreeYearPayment": MessageLookupByLibrary.simpleMessage(
      "Трёхлетний",
    ),
    "xboardTimeout": MessageLookupByLibrary.simpleMessage("Таймаут"),
    "xboardTokenExpiredContent": MessageLookupByLibrary.simpleMessage(
      "Срок вашей сессии истёк. Пожалуйста, войдите снова для продолжения.",
    ),
    "xboardTokenExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Срок входа истёк",
    ),
    "xboardTraffic": MessageLookupByLibrary.simpleMessage("Трафик"),
    "xboardTrafficExhausted": MessageLookupByLibrary.simpleMessage(
      "Трафик исчерпан",
    ),
    "xboardTrafficUsedUp": MessageLookupByLibrary.simpleMessage(
      "Трафик исчерпан",
    ),
    "xboardTunEnabled": MessageLookupByLibrary.simpleMessage("TUN включён"),
    "xboardTwelveMonthCycle": MessageLookupByLibrary.simpleMessage(
      "12-месячный цикл",
    ),
    "xboardTwentyFourMonthCycle": MessageLookupByLibrary.simpleMessage(
      "24-месячный цикл",
    ),
    "xboardTwoYearPayment": MessageLookupByLibrary.simpleMessage("Двухлетний"),
    "xboardUnauthorizedAccess": MessageLookupByLibrary.simpleMessage(
      "Неавторизованный доступ, сначала войдите в систему",
    ),
    "xboardUnknownErrorRetry": MessageLookupByLibrary.simpleMessage(
      "Неизвестная ошибка, повторите попытку",
    ),
    "xboardUnknownUser": MessageLookupByLibrary.simpleMessage(
      "Неизвестный пользователь",
    ),
    "xboardUnlimited": MessageLookupByLibrary.simpleMessage("Неограниченно"),
    "xboardUnselected": MessageLookupByLibrary.simpleMessage("Не выбрано"),
    "xboardUnsupportedCouponType": MessageLookupByLibrary.simpleMessage(
      "Неподдерживаемый тип купона",
    ),
    "xboardUpdateContent": MessageLookupByLibrary.simpleMessage(
      "Содержание обновления:",
    ),
    "xboardUpdateLater": MessageLookupByLibrary.simpleMessage("Обновить позже"),
    "xboardUpdateNow": MessageLookupByLibrary.simpleMessage("Обновить сейчас"),
    "xboardUpdateSubscription": MessageLookupByLibrary.simpleMessage(
      "Обновить подписку",
    ),
    "xboardUpdateSubscriptionRegularly": MessageLookupByLibrary.simpleMessage(
      "Регулярно обновляйте подписку для получения последних узлов",
    ),
    "xboardUsageInstructions": MessageLookupByLibrary.simpleMessage(
      "Инструкции по использованию",
    ),
    "xboardUsed": MessageLookupByLibrary.simpleMessage("Использовано"),
    "xboardUsedTraffic": MessageLookupByLibrary.simpleMessage("Использовано"),
    "xboardValidatingConfigFormat": MessageLookupByLibrary.simpleMessage(
      "Проверка формата конфигурации",
    ),
    "xboardValidationFailed": MessageLookupByLibrary.simpleMessage(
      "Проверка не удалась",
    ),
    "xboardValidityPeriod": MessageLookupByLibrary.simpleMessage(
      "Период действия",
    ),
    "xboardVerify": MessageLookupByLibrary.simpleMessage("Проверить"),
    "xboardVeryPoor": MessageLookupByLibrary.simpleMessage("Очень плохо"),
    "xboardWaitingForPayment": MessageLookupByLibrary.simpleMessage(
      "Ожидание оплаты",
    ),
    "xboardWaitingPaymentCompletion": MessageLookupByLibrary.simpleMessage(
      "Ожидание завершения оплаты",
    ),
    "xboardYearlyPayment": MessageLookupByLibrary.simpleMessage("Ежегодно"),
    "years": MessageLookupByLibrary.simpleMessage("Лет"),
    "yearsAgo": m81,
    "yes": MessageLookupByLibrary.simpleMessage("Да"),
    "zhCN": MessageLookupByLibrary.simpleMessage("Упрощённый китайский"),
    "zh_CN": MessageLookupByLibrary.simpleMessage("Упрощенный китайский"),
  };
}
