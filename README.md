# Проектная документация проекта «Просто, ЗОЖ»

>Приёмка первой части чистового дизайна 29.04.2020.
>Пометки:

1. На экране Help1
   - убрать многоточие
   - выделить размером слово ЗОЖ
   - можно подумать в сторону увеличения размера описания текста к хелпу, если позволяет пространство для конкретного экрана
2. Экран Help2
   - неверная иллюстрация
   - Символы тестирования:
     - сантиметровая лента
     - секундомер
     - тонометр
     - опросник с галочками
     - фигура полная и худая
3. Экран 0.15.fuctional_test
   - иконка пользователя и ЗОЖ сносится, облака ЗОЖ и пользователя выделяются цветом
   - корректировка текста у первого абзаца
   - таймер нужно сделать вертикальной полосой, в стиле материал песочных часов
4. Dashboard
   - текст прогресса делаем более акцентированным(BOLD/BLACK) или цвет, сейчас нижние выбиваются относительно надписей на диаграмме
   - перенос текста в конец после завершения полосы, так как это мешает внутреннему перфекционисту Антонины
   - нужно сделать кнопки серыми под фон, бордер толщиной с полосу на диаграмме, под эквивалентный цвет
   - текст на диаграмме весь белый, без лишнего опасити
5. Экран добавления зонтик
   - проверить цвета и кнопки на фоне под блюром
   - фиолетовый цвет для режима_сна
6. Экран добавления еды
   - для каждого контейнера не нужно выводить воду, вода должна быть отдельным контейнером может быть как такая бутылочка вверху. и все приемы пищи и воды вливаются в одну «канистру»
   - также нужно выделить отдельно нутриенты, как и вода
   - калории вообще не нужны, сносим их везде кроме экрана просмотра продуктов в каталоге продуктов
   - у говядины нужно переместить местами. Т.е. группа это красное мясо, и подвид в виде говядины/или свинины/ или баранины
   - 

## Назначение и цели проекта
Целями проекта является обучение теоретическим основам и практическим навыкам:
- здорового образа жизни и его организации;
- правильного планирования физической нагрузки  для получения оздоровительного эффекта на организм;
- исключения факторов риска сердечнососудистых  и онкологических заболеваний;
- рационального питания;
- методам предупреждения психических перенапряжений;

Всё вместе это является инструментом профилактики здоровья людей и увеличения его количества.

### Автор проекта

Масленникова Антонина.
Масленникова Ирина.

### Прототипы ключевых экранов приложения

![](/i/proto/proto.svg)

<!-- > Вдохновлены достижениями Якова Иссакиевича Емельянова. Заслуженный тренер. Отец Автора, Ирины Масленниковой. Детали о деятельности Я. И. Емельянове есть в Википедии. -->

## Сценарии использования пользователем
### Взаимодействие между пользователями и автором

```plantuml
@startuml
skinparam monochrome false
'skinparam backgroundColor #282828

skinparam sequence {
	ArrowColor #A6E32D
	ActorBorderColor #A6E32D
	LifeLineBorderColor #A6E32D
	LifeLineBackgroundColor #A9DCDF
	
	ParticipantBorderColor #A6E32D
	ParticipantBackgroundColor #A6E32D
'	ParticipantFontName Impact
'	ParticipantFontSize 17
'	ParticipantFontColor #A9DCDF
	
	ActorBackgroundColor #A6E32D
	ActorFontColor #A6E32D
'	ActorFontSize 17
'	ActorFontName Aapex
}
left to right direction
User <<Потребитель>>
Admin <<Автор>>

rectangle {

    agent "iOS/Android" as phone
    cloud "Push" as push 
    agent "Приложение" as app

    User <--> app
    phone .> app
    (push) ..> phone
    app .> [Панель управления]
    [Панель управления] .> (push) :   Onesignal API
    [Панель управления] <--> Admin
}
@enduml
```

## Роли пользователей-потребителей в системе


1. «Наблюдатель»
2. «Регуляция режима и питания»
3. «Регуляция режима, питания и оздоровительных тренировок»
4. «Регуляция режима, питания, нагрузочных и круговых тренировок»

## Диаграмма компонентов системы

```plantuml
@startuml
skinparam monochrome false
'skinparam backgroundColor #282828

skinparam sequence {
	ArrowColor #A6E32D
	ActorBorderColor #A6E32D
	LifeLineBorderColor #A6E32D
	LifeLineBackgroundColor #A6E32D
	
	ParticipantBorderColor #A6E32D
	ParticipantBackgroundColor #A6E32D
'	ParticipantFontName Impact
'	ParticipantFontSize 17
'	ParticipantFontColor #A9DCDF
	
	ActorBackgroundColor #A6E32D
	ActorFontColor #A6E32D
'	ActorFontSize 17
'	ActorFontName Aapex
}

    user <<Болеющий>>
    admin <<Автор-врач-тренер>>

package "Фронтенд" {
    [Приложения iOS и Android] as app
    frame "Внешние сервисы" as integration {
        [Apple Health]
        [Google Fit]
        [Google Firebase]
        [Apple push servers]
        [One signal API]
        [YAM/FBSDK]
    }
}

cloud {
    [REST FULL API] as api
}

package "Backend" as panel {

    database "Контент" as content {
    [Тренировки]
    [Продукты и рацион]
    }
    database "Пользователи" as users {
    [Активные] 
    [Спящие] 
    [Удалённые] 
    [Заблокированные]
    }
    frame "Пуш-уведомления" as push {
        [О тренировках]
        [О питании]
        [О показателях]
        [О периоде(неделя/месяц/etc)]
        [О новых материалах]
'        [С днём рожденья]
        [Персональные рассылки]
    }
    node "Весы алгоритма" as alg {
        [Параметры для тренировок]
        [Параметры для рациона]
    }
} 

' Связки для администратора
    admin -> content
    admin -> users
    admin -> alg
    admin ---> push


' Связки для пользователя
    app <--> api 
    api --> panel
    app <--- integration
    app <- user
    app -> user

@enduml

```

## Количество оказываемых услуг

Количество оказываемых услуг: 1 (одна) услуга по поставке и интеграции IT-комплекса в инфраструктуру Заказчика, включающая в себя:
1. Разработку проектной документации IT-комплекса
2. Интеграция с системами сбора фитнес данных через API Google Fit/Apple Health
3. Подготовка дизайна мобильных приложений согласно требований Apple и Google
4. Программирование и вёрстка мобильного нативного приложения для Android под смартфоны
5. Программирование и вёрстка мобильного нативного приложения для iOS под смартфоны
6. Интеграция с системами Remote Push-уведомлений от Apple и Google (**new**)
7. Внедрение статистических инструментов
8. Публикация мобильных приложений в AppStore и Google Play в аккаунте Заказчика
9. Сдачу IT-комплекса на стендах находящихся на территории Заказчика


### Плановые сроки выполнения работ
Сроки начала и окончания работ определяются Договором с Исполнителем, но не более 3 месяцев с включенным периодом тестирования для начальной версии и не более 7 месяцев для расширенной версии.

### Порядок оформления и предъявления результатов работ

Исполнитель:
1. Готовит документацию по приёмке и методике тестирования
2. Проводит тестирование на своей технической базе
3. Передает на ознакомление документацию по приёмке Заказчику
4. Проводит совместно с заказчиком приёмку и тестирование на территории Заказчика

Заказчик:
1. Принимает и изучает документацию методики тестирования
2. Проводит тестирование совместно с Исполнителем на территории Заказчика
3. Принимает продукт и подписывает акт приёмки

Приемочные испытания Мобильных приложений проводятся в соответствии с разрабатываемым Исполнителем документом «Программа и методика испытаний», который должен устанавливать необходимый и достаточный объем испытаний, обеспечивающий достоверность получаемых результатов.
Цель приемочных испытаний — проверка соответствия реализации мобильных приложений требованиям, определенным в технической документации.

Приемочные испытания должны состоять из следующих проверок:
- проверка комплектности эксплуатационной документации;
- проверка соответствия технических характеристик МП требованиям настоящей документации.

Процесс разработки и контроля разработки может быть разбит на этапы, указанные в разделе График запуска, включающую в себя перечень этапов, объем работ по каждому этапу, входящие информационные материалы, исходящие материалы, предъявляемые по окончанию соответствующих этапов.

Методы испытаний МП должны включать перечень действий проверки мобильных приложений и описание условий успешности проверки, соответствующих требованиям Технического задания.

Методы испытаний МП должны быть включены Исполнителем в документ «Программа и методика испытаний».

Заказчик назначает дату проведения приемочных испытаний и формирует приемочную комиссию, состоящую из представителей Заказчика. В приемочную комиссию включаются представители Исполнителя.

Заказчик совместно с Исполнителем проводит необходимые подготовительные мероприятия для проведения приемочных испытаний на территории Заказчика. Заказчик предоставляет помещение и технические средства для проведения приемочных испытаний.

Приемочные испытания завершаются подписанием комиссией акта приемочных испытаний.
В случае выявления несоответствий МП отправляется на доработку, которая производится Исполнителем не более чем за 7 рабочих дней, но с корректировкой на сложность необходимых изменений.


### Требования к составу и содержанию работ по подготовке к вводу в эксплуатацию
Перечень работ, выполняемых при подготовке разрабатываемых МП к вводу в эксплуатацию:

1. Представителем со стороны Заказчика должны быть подготовлены и добавлены в систему управления контентом информационные материалы, предназначенные для наполнения информационных разделов мобильных приложений. Информационные материалы и изображения должны быть адаптированы для корректного отображения на экранах мобильных устройств. Совместно с Исполнителем определяются параметры информационных материалов.
2. В случае если представитель Заказчика не имеет возможности подготовить материалы в административной панели сайта, то подготавливается отдельным этапом и ресурсоёмкостью после разработки REST API, подготовка материалов Исполнителем.
3. Перед вводом в эксплуатацию МП Исполнитель оказывает содействие в регистрирации аккаунтов для размещения МП на площадках:
  * Apple Store
  * Google Play

На площадках по дистрибуции приложения размещаются Исполнителем. Аккаунты для площадок приобретаются Заказчиком или арендуются у Исполнителя.

### Требования к документированию

Исполнитель разрабатывает и передает Заказчику следующую документацию:
- программа и методика испытаний;
- регламент эксплуатации мобильных приложений;
- руководство администратора мобильных приложений через Админ-панель;
- общее описание системы

Документы должны быть переданы Заказчику на электронном носителе.

### Гарантийные обязательства и техническое сопровождение
Гарантийный срок на работы не ограничен и исчисляется с даты подписания акта сдачи-приемки работ. В течение указанного периода Исполнитель осуществляет полную бесплатную техническую поддержку МП, оперативно устраняет сбои и ошибки в работе МП в случае отсутствия влияния на систему третьих сторон.

Исполнитель в течение гарантийного периода осуществляет подготовку и публикацию обновлений МП.

В случае если после сдачи IT-комплекса Заказчику, третьи стороны не влияли на продукт, то гарантия IT-комплекса со стороны Исполнителя — бессрочна.

Дополнительное техническое обслуживание МП может осуществляться Исполнителем по отдельному договору.

## Окружение и операционные системы
### Стационарные ОС
Не подразумеваются в рамках выполнения работ.
### Мобильные ОС
* Android v8+
* iOS v12+

# Интеграция с внешними сервисами

## Требования к разработке API к взаимному обмену данными по API

1. Синхронизация работы приложения с серверной частью Админ-панель управления контентом
2. Синхронизация приложения с Админ-панелью сайта происходит при каждом подключении приложения (при условии наличии подключения к сети Интернет).

Каждый раз, когда пользователь в приложении вносит какие-либо изменения в личные данные или запрашивает обновления, каталог информации приложения уведомляет об этом сервер и передает или получает данные о внесенных изменениях.


### Технические принципы работы с API
Приложение обменивается информацией с сервером — поставщиком данных. На сервере хранится информация о статусах и действиях пользователя. Получая данную информацию с сервера, приложение сохраняет её в свою внутреннюю базу данных и файловое хранилище, при необходимости обновляя путем соответствующего запроса к серверу.

### Схема обмена информацией
Приложение обращается к серверу через защищенный протокол https (при этом сервер имеет действующий SSL-сертификат). Точкой обращения является конкретный адрес, например: https://domain.ru/api/. Все запросы на сервер отправляются соответстующими методами, при этом данные запросов и ответов передаются в формате JSON.

### Формат API

Подготовкой API занимается Исполнитель.
API должно обеспечить реализацию всего оговоренного в данном документе функционала.

Требования к разрабатываемому API:
- отображение информационных экранов для неавторизованных пользователей
- отображение и обработка экранов для авторизованных пользователей
- реализация методов для remote push notifications

Коды ответов сервера:

**200** OK — это ответ на успешные GET, PUT, PATCH или DELETE. Этот код также используется для POST, который не приводит к созданию.

**201** Created — этот код состояния является ответом на POST, который приводит к созданию.

**204** Нет содержимого. Это ответ на успешный запрос, который не будет возвращать тело (например, запрос DELETE)

**304** Not Modified — используйте этот код состояния, когда заголовки HTTP-кеширования находятся в работе

**400** Bad Request — этот код состояния указывает, что запрос искажен, например, если тело не может быть проанализировано

**401** Unauthorized — Если не указаны или недействительны данные аутентификации. Также полезно активировать всплывающее окно auth, если приложение используется из браузера

**403** Forbidden — когда аутентификация прошла успешно, но аутентифицированный пользователь не имеет доступа к ресурсу

**404** Not found — если запрашивается несуществующий ресурс

**405** Method Not Allowed — когда запрашивается HTTP-метод, который не разрешен для аутентифицированного пользователя

**410** Gone — этот код состояния указывает, что ресурс в этой конечной точке больше не доступен. Полезно в качестве защитного ответа для старых версий API

**415** Unsupported Media Type. Если в качестве части запроса был указан неправильный тип содержимого

**422** Unprocessable Entity — используется для проверки ошибок

**429** Too Many Requests — когда запрос отклоняется из-за ограничения скорости


**Типы запросов:**

**GET** — для получения данных с сервера

**POST** — для добавления новых данных на сервер

**PUT** — для редактирования данных

**PATCH** — для частичного обновления данных на сервер : например для обновления 1 поля объекта

**DELETE** — для удаления данных на сервере : например, для удаления избранного у пользователя локально

**OPTIONS** — для сложных случаев, когда нельзя предсказать возможные варианты использования после действия пользователя

### Требования к надежности и безопасности приложения
При разработке приложения необходимо предусмотреть защиту от взлома приложения на всех этапах его функционирования:
- локальная работа приложения без связи с сервером;
- работа приложения при синхронизации сервером;

Если пользователь не имеет доступа к сети Интернет, то прилоежние отображет ему окно «Пожалуйста, подключитесь к Интернету» и кнопка «ОК» / «Перейти в Настройки».

Если пользователь забанен или отключен из системы, то его авторизационная сессия на мобильном клиенте завершается.

# Push-notifications в мобильных приложениях

> Раздел в доработке

![Уведомления](i/notifications.svg)

Для пользователя мобильного приложения с ролью **«Наблюдатель»**:
- Наименование и тип уведомления

Для пользователя мобильного приложения с ролью **«Соблюдение сна и еды»**:
- Наименование и тип уведомления
  
Для пользователя мобильного приложения с ролью **«Соблюдение сна, еды, оздоровляющих тренировок»**:
- Наименование и тип уведомления
  

Для пользователя мобильного приложения с ролью **«Соблюдение сна, еды, нагрузочных и круговых тренировок»**:
- Наименование и тип уведомления
  

Предлагается провайдер уведомлений: **OneSignal**

Для веб-админ-панели сайта потребуется интеграция через документацию описанную [по ссылке](https://documentation.onesignal.com/docs/web-push-quickstart) </br>
Для мобильных приложений интеграция через flutter sdk  [по ссылке](https://documentation.onesignal.com/docs/flutter-sdk-setup)


## Сбор статистики

1. Сколько прочитанных Push-уведомлений
2. Сколько раз пользователь в течении дня открывает приложение
3. Сколько времени пользователь в течении дня проводит в приложении
4. На каждый экран при открытии добавляется событие об открытии экрана пользователем
5. Другие события согласованные с Автором, но не более 10 пользовательских событий
6. Выбранные сервисы для сбора: YandexAppMetricaSDK и FacebookSDK


## Диаграмма последовательностей пользователей приложения

```plantuml

@startuml
'hide footbox
autonumber
!pragma teoz true

skinparam monochrome reverse
'skinparam backgroundColor #272822

actor Пользователь as user
entity Приложения as app
control Протокол as api
database Админка as panel

== Инициализация==
user -> app : Установка из GooglePlay/AppStore
app -> panel: Информация о проекте, статический контент
user <-- app : Запрос на авторизацию
activate app
user -> app : Логин и пароль
app -> api : Проверка авторизации
activate api
api -> panel : Передача параметров сессии
activate panel
api <- panel : Успешная авторизация
api -> app : Подтверждение входа
app -> user : Объекты данных главного экрана приложения
deactivate app
api <-- panel : Нет пользовтеля в базе
destroy panel
api --> app : Пользователь не найден
deactivate api
activate app
app -> user: «Проверьте правильность логина/пароля»
deactivate app

== Прохождение регистрации ==
user -> app : Регистрация в системе
app -> user : Регистрация в виде общения в чате с ботом/помощником
user -> app : Ввод регистрационных данных
app -> api : Отправка данных на сервер
app -> user : Спасибо за регистрацию
api -> panel : Размещение данных о пользователе в БД
panel -> app : Успешная регистрация
app -> user : Продолжение диалога с чат-ботом, для анкетирования

== Прохождение анкеты ==
app <- user : Начало вопросов по подготовленному сценарию
app -> api : Отправка каждого ответа пользователя на сервер
api -> panel : Сохранение данных по пользователю в бд
app <- user : Заполнил анкету
api -> panel : Сохранение данных по пользователю в бд
app <- panel : Результат и следующий вопрос сценария чатбота
app -> user : Вывод краткого ответа, варианты ответа на новый вопрос
api <- panel : Результат анкетирования с приглашением получить отчёт на почту

app -> user : Направляем на поле ввода email для полного отчёта
app -> user : Отображаем пример страницы отчёта(мотивация)

== Действия активного пользователя ==

user -> app : ввод данных о питании, режиме, тренировках
app -> panel : сохранение данных о пользователе
app <- panel : рекоммендации на основе полученных данных
app -> user : советы и подсказки на основе ввода
app -> user : приглашение на экраны просмотра сторис, каталогов
app -> panel : запрос на получение контента
app -> user : интерфейс для просмотра контента
user -> app : прохождение тренировок через приложение
app <- user : обратная связь по работе с приложением
app -> panel : уведомление авторов по полученной обратной связи от пользователя

@enduml
```


### Git flow и релизная политика
Процедура деплоя после релиза должна работать через согласованный git flow:
1. Разработчики инициируют новую фичу путём создания ветки [myfeature] от ветки `develop`<br>. Для начала разработки фичи выполняется:
`git flow feature start MYFEATURE `. Это действие создаёт новую ветку фичи, основанную на ветке "develop", и переключается на неё.
2. После заверешния работ с новой функциональностью разработчик отправляет ветку на тестирование.  Окончание разработки фичи. Это действие выполняется так:
    - Слияние ветки MYFEATURE в "develop"
    - Удаление ветки фичи
    - Переключение обратно на ветку "develop"

  Команда: `git flow feature finish MYFEATURE`

1. В случае успешно пройденного тестирования, разработчик после валидации от тимлида или продюсера делает слияние с веткой `develop`
2. Ветка `develop` проходит новую итерацию тестирования
3. Для начала работы над релизом используйте команду `git flow release` Она создаёт ветку релиза, ответляя от ветки "develop".
4. После прохождения тестирования релиза, происходит слияние ветки `staging` в ветку `release x.x.x.x`, где x = номер релиза. Важное требование: сразу публиковать ветку релиза после создания, чтобы позволить другим разработчиками выполнять коммиты в ветку релиза.
5. После успешного релиза — нужно делать слияние в ветку `master`
  * *Ветка релиза сливается в ветку "master*"
  * Релиз помечается тегом равным его имени
  * Ветка релиза сливается обратно в ветку "develop"
  * Ветка релиза удаляется
    
    Команда `git flow release finish RELEASE `

# Доставка на рынок

### Размещение в Appstore & Google Play
#### Подготовка к публикации
1. Необходимо использовать приобретенный или купить новый аккаунт разработчика для Apple = 100$ ежегодная плата, Google = 25$ с неиссякаемой лицензией. 
2. Подготовка всех скриншотов необходимы к публикации
3. Генерация ключей для подписи приложения перед публикацией в Appstore
4. Генерация `keystore ` должна осуществляться прямо в репозитории проекта. 
5. Необходимо сохранить информацию о паролях и alias-ах в репозитории проекта. 

#### Загрузка в магазины сборок приложений
1. Заполняется информация о будущих мобильных приложениях
2. Загрузка скриншотов и промо-материалов для страницы
3. Загрузка сборки в alpha-channel Google Play и Testflight
4. После тестирования из alpha & Testflight публикация в полную валидацию и релиз в магазины
5. После тестов отправка в продакшн модерацию от Apple и Google

# Требования к дизайну
1. Логотип по ссылке: [psd](#), [eps, вектор](#).
2. Из логотипа необходимо сделать иконку. Фон для иконки [ ]. Код цвета фона #808080, можно [увидеть по ссылке](#).
3. Фирменные шрифты компании по ссылке: [bold](#), [medium](#), [reuglar](#)
4. Фирменные цвета: [ ] буквы на [ ] или [ ] фоне. Без определенных требований к комбинаторике.


# Мультиязычность проекта

Первая версия только на русском языке.

# Интерфейсы пользователя

## Экран «Логина»
![](/i/login.svg)

**Тип экрана:** динамический контент, получение API

**Бизнес-логика:**
Экран подразумевает отбражение кратких возможностей в приложении.
Возможность перехода на экран авторизации.
Возможность перехода на экраны с контентом.

**Отображение данных:**

| Наименование | Тип | Формат| Поставщик | Примечание |
| :--------- | :-----------: | :-----------: | :-----------: | :----------- |
|  |  |  | | |

**Навигация, события, переходы:**

| Элемент | Действие | Статус | Назначение |
| :------ | :--------: | :--------: |:----------- |
|  | Tap | Success | Экран « » |


**Методы REST API:**

| Метод | Тип запроса  | Формат ответа  | Параметры запроса | Дополнительно |
| :--------- | :-----------: | :----------- |:-----------  |:----------- |


## Экраны «Welcome!»
![](/i/welcome.svg)

Хелп экраны на котрых вкратце рассказывется, что может приложение и для чего оно в целом.

## «Авторизация регистрация»
      1. Экран загрузки приложения с анимацией
      2. Регистрация
      3. Авторизация
      4. Восстановление пароля
      5. Переход на экран «О проекте»

## Экраны «Анкеты»
Валидация того, какие разделы пользователю будут доступны. Какую роль он получит после прохождения анкеты.

1. Экран Общие вопросы о пользователе
   1. Пол
   2. Возраст
2. Экран Вопросы об ограничениях медицинских
3. Экран Вопросы о питании
   1. Перечень продуктов и частотность употребления
4. Экран Вопросы по качеству жизни
   1.   Вы курите?
        - эпизодически
        - регулярно
   2. Бывает ли что Вы:
      - страдаете бессонницей?
      - часто пребываете в состоянии стресса?
      - легко раздражаетесь и выходите из себя в житейских ситуациях?
      - чувствуете беспричинную тревогу?
      - опасаетесь за своё здоровье?
      - быстро утомляетесь?
      - с трудом входите в необходимый рабочий режим?
    1. Сколько часов вы спите обычно?
       1. Нарисовать часы, выбора стрелки начала и стрелки конца сна
       2. Информация о сне, инфографика
          ![](i/dream.jpg)
          ![](i/dreamclock.png)
    2. Пользуетесь ли вы будильникам?
       1. Часто
       2. Иногда
       3. Не пользуюсь будильником
    3. Регулярный(ежедневный) ли у вас стул?
       1. Да
          1. В какое время?
             1. Утром
             2. Днём
             3. Вечером
       2. Нет
5. Экран «Вопросы об активности»
   1. Укажите свой вес в КГ
   2. Кол-во упражнений в период времени
      1. Цели которые ставит пользователь перед собой (множественный выбор)
         1. Похудеть
            1. Какой у вас процент жиротложения? ![](i/body.png)
            2. Какая у вас тип жироотложения? ![](i/fat.jpg)
         2. Увеличить мышечную массу(множественный выбор)
            1. Верх
            2. Низ
            3. Сделайте замеры вашего организма ![](i/check.jpg)
               1. Следующий замер будет через 2 месяца
         3. Повысить уровень здоровья
   3. Функциональный тест
      1. Если пользователь не может его пройти, он пропускает
      2. Не рекомендуем проходить тест, если вы недавно покурили
      3. *Flow*:
         1. Замерьте пульс в покое *15 секунд * 4, и укажите в приложении*
         2. Измерьте давление в покое *после 2-3х минут в покое* (ссылка на видео, как это делать)
         3. Сделайте 20 приседаний, в темпе 1 секунда 1 движение(вниз) 1 секунда(вверх)
         4. Измерьте пульс
         5. Измерьте давление
         6. В конце каждой минуты восстановления после теста, замеряйте пульс и давление до момента полного восстановления
            1. Запуск секундомера для ввода значений
            2. Каждую минуту указывайте пульс
            3. Каждую минуту указывайте верхнее давление
            4. Каждую минуту указывайте нижнее давление
      4. Если пользователь понимает, что прошёл функциональный тест неправильно, то у него есть кнопка прохождения функционального теста «Заново»

## Экраны «Отчёт и доступы к разделам»
Проходим анкету на предмет выявления. В конце просим мыло, чтобы отправить на него PDF отчёт.
Для пущей мотивации можно запустить таймер обратного отсчёта со словами: «Мы трепетно относимся к персональным данным. Ваш отчёт самоуничтожится через 3 минуты 59 секунд. Если хотите сохранить полезные советы, мы можем отправить вам это на почту, укажите её ниже:»
   1. Краткая сводка: показатели вашего организма
   2. Полный отчёт-анализ с рекоммендациями, будет отправлен вам на почту/телефон (если укажет эти данные)
      1. Вместе с отчётом передаются данные для входа в систему:логин и пароль на указанный канал связи
      2. Пример иллюстрации отчёта(это просто пример из другой сферы):
      3. Отчёт уходящий на почту
         ![](i/report2.jpg)
         ![](i/report.png)
         1. Напоминание о том, как выявлять онкологию ![](i/report.jpg)
         2. Рекомендуем пройти диспансеризацию  ![](i/disp.jpg)
        

## Экраны «Общей навигация в приложении»
Сквозные таббары, меню вызовов, уведомления внутри экранов, ссылки переходов.

## Экраны «Дашборд пользователя»
Три столпа здоровья: режим, еда, движение.
По каждому столпу сегодняшние показатели.

Необходима общая шкала состояния на **СЕГОДНЯ** ![](i/health.jpg)
*Нужно получить материалы о том, как конкретный спидометр называется, какая шкала у каждого из них от Авторов*

- для **Режима** учитываются точка подъёма и точка ухода в сон.
- для **Питание** учитывается кол-во, объём и тип принятой еды и жидкости.
- для **Движения** учитывается кол-во шагов, тренировок

При тапе на каждый столп, можно перейти в детали конкретного раздела.

Для экранов **Режим «Жить»**:

   1. Запрос на получение данных о сне из Apple Health, Google Fit
   2. Укажи сколько было сна сегодня?
      1. На стрелках часов, выбор старт сна
      2. На стрелках часов указать конец сна![dreamclock](i/dreamclock.png)
   3. Был ли сон у вас дневной 15 минутный сон?
      1. Да
      2. Нет
   4. Качество вашего сна сегодня:
   5. Опрос по сну, каждый день(качество и здоровье сна)
      1. *Вопросы будут предоставлены от Авторов*
   6. Рекоммендации по режиму дня(их 3 вида: простой, похудение, силовой)
      1. Подъем
      2. Завтрак
      3. Перекус
      4. Обед
      5. Обеденный перерыв
      6. 15 минутный сон
      7. Тренировки
      8. Ужин
      9. Второй ужин, простокваша мечниковская :-)
      10. Сон

Для экранов **«Питание»**:
- Кнопка «Чего сегодня съедено/выпито?»
   - Ввод названия продукта с автоподсказкой из каталога
   - Ввод кол-ва порций употребленного продукта
- Помощь с пояснениями на экране «Отображение сетки элементов и частотности приёма»
![Рацион питания](i/ration.png)
   - На основе выбранной задачи Пользователя, построение таблицы происходит из программы
      - Для похудения сокращение объема употребляемой еды
      - Для поддержания по норме
      - Для увеличения мышечной массы
   - Параметры питания задаются из административной панели
- Если пользователь где-то упускает или переедает, отображается параметр «ОЙ» на шкале-сетке элементов
   - Как пить воду
      ![](i/water.jpg)


Для экранов **«Движение»**:
  1. Повседневная нагрузка, моцион
  2. Необходимо указать шагов пройденных
  3. Если не знаете кол-во шагов, укажите сколько времени вы шли пешком. *Приложение автоматически считает кол-во расстояния/шагов из общей средней скорости человка.*
  4. Сколько «двигательных переменок» в течении дня? *Напоминание в течении рабочего дня*
  5. Это могут быть минимум 12-15 минут
     1. Пешком пройтись, размеренно, чтобы не вспотеть
     2. Пешком пройтись, чтобы стало тепло
     3. Желательно на улице
     4. Или размеренно по лестнице в течении 12 минут, чтобы не вспотеть
     5. И не менее 30 минут на свежем воздухе, для получения ультрафиолета
  6. Специальная нагрузка, тренировка ![](i/drils.jpg)
  7. Зоны ![](i/pano.png) ![](i/trainer.jpg)
     1. Определение зоны по формуле: *220-возраст * 0.7* = нужная пульсовая зона
  8. Указать свою тренировку(поставить галочку)
  9.  Выбрать тренировку в приложении
     1. Пройти тренировку в приложении


## Экраны «Лента знаний, инсайты»

Полезные факты, справочник — динамическая лента с лонгридами, видео, фильмами и краткими сторис.

### Перечень элементов на экранах

   1. Сторис
      1. Много изображений
      2. Мало текста
      3. Анимации
      4. Смайлы, обилие
   2. Посты
      1. Статья на 2-3 абзаца
      2. 1-2 изображений
   3. Детальные материалы(лонгриды)
      1. Статья на ∞ абзацев
      2. Обилие изображений
      3. Анимация элементов
      4. Вставки видороликов/2-3 мин
   4. Инфографика
      1. Обилие статистики
      2. Красивая упаковка плоского дизайна, отрисовка в векторе
   5. Видеоролики
      1. Снятые у нас в студии
      2. Найденные и согласованные с авторами в Сети
      3. Видеоролики — не больше 5 минут
   6. Обучающие фильмы
      1. Научные
      2. Познавательные
      3. Фильмы — видеоролик свыше 5 минут уже фильм

## Экраны «Справочинк продуктов»

Перечень продуктов с фильтрацией и динамическим поиском с автоподстановкой во время ввода.
Каждый продукт в себе содержит: перечень состава и кол-во каждого элемента в составе.

Элементы экранов:
   1. Поиск глобальный (автокомлиты)
   2. Фильтрация/сортировка результатов поиска
   3. Категории продуктов
      1. Подкатегории продуктов
   4. Категории необх. элементов
      1. Перечень всех элементов
         1. Просмотр продуктов по элементу
   5. Экран просмотра продукта
      1. Название
      2. Необходимая порция на 1 день
         1. Ладонь
         2. Принцип 4х
         3. Ложки
      3. Вес. Значение динамическое, вычисляется на основе веса указаного пользователем, гендера, роста. В исходной БД лежит всегда по 100гр.
      4. Содержание элементов в указанном весе
         1. Элемент, г
         2. Нутриент, г
         3. Микро, г
         4. Макро, г
         5. Вода, г
   6. Экран «Справочник E-элементов в продуктах»
      1. Ввод в поисковое поле
         1. Автоподсказки
      2. Отображение деталей по E-консерванту-элементу
         1. Статус запрещено, разрешено, допустимо
         2. Влияние на организм человека
         3. Влияние на системы организма(если есть детали)
         4. Влияние на орган человека(если есть детали)

## Экраны «Справочник упражнений»

1. Аэробные упражнения для девушек
2. Аэробные упражнения для юношей
3. Силовые и круговые упражнения для юношей
4. Силовые и круговые упражнения для девушек

### Перечень элементов на экранах

1. Поиск глобальный(автокомплиты)
2. Фильтрация и сортировка
3. По типу задач
  1. Набор мышечной массы
  2. Похудение
  3. Сохранение и поддержание здоровья
  4. Оздоровительные(ЛФК)
4. По принципу построения тренировки
  1. Аэробная
   1. Сверху-вниз
   2. Проблемные зоны
   3. Круговая
  2. Силовая
   4. Верх+середина тела
   5. Низ+середина тела
   6. Круговая
5. Просмотр тренировки
6. Название тренировки
7. Видеоматериал тренировки
8. Краткое описание тренировки
9. Включить трекинг пульса
  1. Через съём данных с пульсометра
   1. Работа с API/Bluetooth считывание напрямую к производителю
  2. Снимать не реже чем 1 раз в 5 минут
  3. Проверить считывание через AppleHealth/GoogleFit или других приложений
10. Выдача результатов и рекомендаций на основе графика динамики пульса в течении тренировки.

Просмотр и запуск тренировок происходит на основе Роли пользователя к уровню сложности.

## Экраны «Профиль и настройки»
Персональные данные пользователя и настройки приложения. В настройках приложения будут возможность отключения звуков, пуш-уведомлений, удаление профиля, удаление из системы, сброс данных.

## Экраны «Статистика»
Информация о прогрессе пользователя.
Параметры прогресса: вес, сон, режимность, постоянство в тренировках, полноценность питания.

## Экраны «Системные»
Сюда входят все служебные экраны с информацией об авторах, о методиках, о используемой литературе, о разработчиках, о проекте в целом, о планах развития проекта, о инвесторах проекта(если они хотят), юридическая информация, контакты, реквизиты, форма обратной связи с Авторами проекта.

### Экраны «Настроек»
1. Отключение пуш-уведомлений(в т.ч. на главном экране): отключение по разным типам пуш-уведомлений
2. Тема: светлая/тёмная
3. Звук: отключение звуковых схем при нажатии на элементы в разных экранах
4. Выбор интересующих тем для экрана Ленты
5. Профиль: редактирование
6. Доступ по 4х-значному коду: ВКЛ/ВЫКЛ

### Экран «О проекте»
1. Общее описание
2. Контакты авторов
3. Информация о разработке проекта

### Экраны «Юридической/правовая информации»
1. Документы по обработке персональных данных
2. Ссылки на литературу и исследования, которые

### Экраны «Технической поддержки»
1. Форма обратной связи
2. Контакты разработки

## Страницы интерфейса «Лендинг посадочная страница»
Одностраничный сайт, на котором в кратце перечисляются возможности приложений и всего комплекса, реквизиты организации, контакты, краткие данные по методикам работы.
Может иметь ссылку вида: *promo.domain.ru*

## Страницы интерфейса «Административная панель»
На первый взгляд там будет след. перечень:
1. Логин
2. Управление пользователями
3. Управление лентой инсайтов
4. Управление справочником продуктов
5. Управление справочником тренировок
6. Управление параметрами влияния на анкету
7. Управление контентом лендинга посадочной страницы

Может иметь ссылку: *admin.domain.ru*