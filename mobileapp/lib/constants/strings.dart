const developmentText = 'Раздел в разработке';
const requestWaitingText = 'Пожалуйста подождите';
const selectionScreenTitle = 'Выберите значение(я)';
const selectionScreenSingleTitle = 'Выберите значение';
const debugTitle = 'Дебаг инфо';

const alphabet = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';

// refresh control
const idleRefreshText = '';
const releaseRefreshText = '';
const activeRefreshText = '';
const completedRefreshText = '';

// errors
const errorGenericText = 'Что то пошло не так';
const connectionExceptionText = 'Ошибка соединения';
const noDataText = 'Нет данных';
const formatExceptionText = 'Неверный ответ сервера';
const timeoutExceptionText =
    'Сервер не ответил после {duration} секунд, попробуйте позже';

const errorNotAuthorized = 'Errors::Auth';
const errorTrainingLimitExceeded = 'Errors::MicrocycleWeekTrainingLimit';
const errorGoalNotSelected = 'Errors::GoalNotSelected';

// validation
const errorRequiredText = 'Обязательно к заполнению';
const errorNumericText = 'Поле должно быть числом';
const errorMinLengthText = 'Поле должно содержать менее {min} символов';
const errorExactLengthText = 'Поле должно содержать {length} символов';
const errorDateText = 'Поле должно быть датой в формате {format}';
const errorTypeText = 'Поле должно быть типа {type}';
const errorEmailText = 'Поле должно быть корректным e-mail';
// const errorEmailUniqueText = 'Поле должно быть уникальным e-mail';
const errorPhoneText = 'Поле должно быть корректным номером';
const errorFormText = 'Исправьте ошибки';
// const errorImageText = 'Загрузите изображение';
const errorEmailOrPhoneText =
    'Введите корректную электронную почту или телефон';

// slider
const slide1Text = 'Сохранить и приумножить\nздоровье';
const slide2Text = 'Тестирование вашего текущего состояния по 100+ параметрам. '
    'Контроль прогресса, коррекция плана на рост.';
const slide3Text = 'Автоматизированный персональный просчёт рациона питания по '
    'полному биохимическому составу для 1000+ продуктов';
const slide4Text =
    'Целевые тренировки для всех возрастов с любым уровнем здоровья. '
    'Более 30 программ от оздоровительных, до силовых';
const slide5Text =
    'Постоянно обновляемая база рейтинга продуктов от Роскачества '
    'и другие полезные для вашего здоровья инструменты';
const slide6Text =
    '300+ ответов на все вопросы о здоровом образе жизни. Простым '
    'языком, коротко.';
const slide7Text = 'Поехали!';

// auth screens
const authLoginLabel = 'Телефон/e-mail';
const authPasswordLabel = 'Пароль';
const authRegisterButtonLabel = 'Регистрация';
const authLoginButtonLabel = 'Вход';
const authPasswordForgotLabel = 'Забыли пароль?';
const authReset1Text = 'Введите свою электронную\nпочту или телефон';
const authReset2Text = 'Мы отправим вам ссылку для\nсброса пароля';

// otp screens
const otpPhoneLabel = 'Телефон';
const otpCodeLabel = 'Последние 6 цифр';

// chat
const chatWelcomeTitle = 'Приветствие';
const chatTypingText = 'HLS печатает';
const chatNutritionTitle = 'Питание. Тест.';
const chatLifestyleTitle = 'Режим.Тест.';
const chatMedicalTitle = 'Движение. Тест.';
const chatPhysicalTitle = 'Движение.Тест.';
const chatInputLabel = 'Ответ';

// timer
const timerStart = 'СТАРТ';
const timerStop = 'СТОП';
const timerRestart = 'РЕСТАРТ';
const timerInputLabel = 'Результат';

// drawer
const drawerFavouriteLabel = 'Избранное';
const drawerStatisticsLabel = 'Статистика';
const drawerMeasuresLabel = 'Мои замеры';
const drawerInstrumentsLabel = 'Полезные инструменты';
const drawerSettingsLabel = 'Настройки';
const drawerLogoutLabel = 'Выйти';

// profile
const ageProfileText = 'лет';
const heightProfileText = 'рост';
const weightProfileText = 'вес';
const testingResultsProfileLabel = 'Результаты тестирования';
const restartTestProfileLabel = 'Пройти тест заново';
const progressProfileText = 'ПРОГРЕСС НА ПУТИ К ЦЕЛИ';
const trainingDayText = 'ДНИ ТРЕНИРОВОК';
const microCycleText = 'ТРЕНИРОВКИ МИКРОЦИКЛА';
const microCyclePeriod1Text = '1 мес.';
const microCyclePeriod2Text = '2 мес.';
const trainingStoryText =
    'Одна тренировка исчерпывает запасы гликогена в организме.  '
    'Чтобы восстановить его потребуется  2-3 дня на отдых. Когда энергозапасы '
    'восстановятся и превысят исходный уровень.\n\nНаступит суперкомпенсация — прирост. '
    'На пике суперкомпенсации необходимо провести следующую тренировку, чтобы добиться '
    'следующей волны ее подъема.';
const healthDynamicText = 'ДИНАМИКА В ТЕЧЕНИИ ГОДА';
const healthLevelLabel = 'Ваш уровень здоровья';
const healthMassIndexLabel = 'Индекс массы тела';
const healthRobensonIndexLabel = 'Индекс Робенсона';
const healthRuffierIndexLabel = 'Проба Руфье';
const healthFunctionalStateLabel = 'Индекс функционального состояния';
const healthAdaptationPotentialLabel = 'Адаптационный потенциал';
const healthHLSApplicationLabel = 'Приложение ЗОЖ за 2 месяца';
const macroCycleText = 'МАКРОЦИКЛ — ПЛАН НА ЖИЗНЬ';
const macroHLSLabel = 'с ЗОЖ';
const macroNoHLSLabel = 'без ЗОЖ';
const macroStatisticalLabel = 'по статистике';

// profile form
const nameProfileLabel = 'Имя';
const dateProfileLabel = 'Дата рождения';
const heightProfileLabel = 'Рост, см';
const weightProfileLabel = 'Вес, кг';
const emailProfileLabel = 'Эл. почта';

// hub
const hubScreenTitle = 'ЗОЖ — это просто';
const statsScreenTitle = 'Банк здоровья';
const nutritionTitle = 'Питание';
const exerciseTitle = 'Движение';
const modeTitle = 'Режим';
const dreamTitle = 'Сон';
const goalTitle = 'Цель';
const macrocycleTitle = 'Макроцикл';
const microcycleTitle = 'Микроцикл';
const weekTitle = 'Неделя';
const trainingTitle = 'Тренировки';

const categoryScreenTitle = 'Каталог';


// food items
const nutritionScreenTitle = 'Продукты';
const productsScreenHeaderTitle = '';
const productsScreenHeaderDescription = '';
const nutritionSearchLabel = 'Название';
const nutritionFilterLabel = 'Выбрать нутриенты продукта';
const foodScreenTitle = 'Продукт';
const foodCarbLabel = 'углев.';
const foodEmptyTitle = 'Продукт не найден в системе';
const foodEmptySubtitle =
    'Вы можете отправить запрос системе для добавления продукта в список';
const foodEmptyAlreadyRequestedText =
    'Вы уже отправили запрос для добавления данного продукта';
const foodEmptyRequestSentTitle = 'Спасибо за запрос';
const foodEmptyRequestSentText =
    'Продукт будет добавлен в систему после рассмотрения';
const foodAddPortionTitle = 'Каков размер порции?';
const foodAddValueLabel = 'Количество';
const foodAddTimeTitle = 'В какое время?';
const foodNeedScheduleText =
    'Для внесения данных о питании необходимо сначала сформировать режим';

// food filter
const foodFilterScreenTitle = 'Выбрать нутриенты';
const backButtonTitle = 'Назад';
const submitButtonTitle = 'Готово';
const clearButtonTitle = 'СБРОС';
const filterFromLabel = 'от';
const filterToLabel = 'до';

// schedule
const scheduleScreenTitle = 'Режим дня';
const scheduleNightTabTitle = 'Ночь';
const scheduleDayTabTitle = 'День';
const scheduleNightText =
    'Отметьте на суточных часах время сна. Отбой и подъем.';
const scheduleNightText1 =
    'Отметьте на суточных часах, во сколько удалось заснуть';
const scheduleNightText2 = 'Отметьте на суточных часах, во сколько был подъём';
const scheduleNightText3 = 'Скорректируйте значения и подтвердите выбор';
//const scheduleSwitchTitle = 'Выберите время отбоя/подъема';
const scheduleDayText =
    'Отметьте предполагаемое время тренировки на суточных часах, '
    'и приложение выстроит вам оптимальный режим дня и питания.';
const scheduleDayText1 = 'Сегодня есть тренировка, во сколько начнём?';
const scheduleAsleepLabel = 'отбой';
const scheduleAwakeLabel = 'подъем';
const scheduleMainFoodLabel = 'основная еда';
const scheduleAdditionalFoodLabel = 'перекус';
const scheduleProteinFoodLabel = 'доп. белок';
const scheduleExerciseLabel = 'тренировка';
const scheduleNightTriviaTitle1 = 'Вы недоспали';
const scheduleNightTriviaText1 =
    'Дипазан нормы сна для человека от 7 до 9 часов в сутки. '
    'Следовательно,  за неделю,  суммарно, это время составит от 49 до 63 часов. '
    'Разовое недосыпание можно "погасить" в последующие 3-4 дня без последствий для здоровья. '
    'Не накапливайте “недосып” более этого срока. '
    'Ситематическая депривация сна наносит необратимый вред здоровью.*';
const scheduleNightTriviaTitle2 = 'Вы рано/позно легли';
const scheduleNightTriviaText2 =
    'Сдвиг времени сна в любую сторону, не соответствующую естественным биологическим ритмам '
    'нарушает синхронизацию в работе органов и систем, и вредит нашему здоровью.'
    '\nЛучше придерживаться циркадных ритмов!';
const scheduleDayTriviaTitle1 = 'Рекомендуемый режим дня';
const scheduleDayWakeupLabel = 'Подъем после сна';
const scheduleDayAsleepLabel = 'Сон';
const scheduleDayBreakfastLabel = 'Завтрак';
const scheduleDayLunchLabel = 'Обед';
const scheduleDayDinnerLabel = 'Ужин';
const scheduleDaySnackLabel = 'Доп. прием пищи';
const scheduleDayProteinLabel = 'Доп. белок';
const scheduleDayExerciseLabel = 'Тренировка';

// exercise
const exerciseCatalogScreenTitle = 'Движение';
const exerciseScreenTitle = 'Добавить данные';
const exerciseTypeTitle = 'Выберите параметр';
const exerciseNeedScheduleText =
  'Для внесения данных о тренировках необходимо сначала сформировать режим';
const exerciseNeedTypeText = 'Выберите тип данных тренировки';
const exerciseNeedValueText = 'Внесите данные тренировки';
const exerciseStartTitle = 'Начать тренировку';
const exerciseZoneTitle = 'Рекомендуемая пульсовая зона';
const heartRateLabel = 'Пульс';
const exerciseAlert = 'Вы уверены, что хотите закончить тренировку?';

const cardioInputTypeManualTitle = 'Вручную';
const cardioInputTypeMonitorTitle = 'Bluetooth кардиомонитор';
const cardioInputAppleHealthTitle = 'Apple Health';
const cardioInputGoogleHealthTitle = 'Google fit';

const heartRateGraphTitle = 'Пульс график тренировки';
const heartRateAbscissaLabel = 'мин.';
const exerciseResultButtonTitle = 'Перейти в итоги дня';