# Проектная документация проекта «Просто, ЗОЖ»

> Находится в разработке. Может меняться до приёмки Автором

## Назначение и цели проекта
Система предназначается для быстрого и качественного обмена информацией между клиентами и собственниками БЦ «JapanHouse».



## Взаимодействие между пользователями и автором

```plantuml
@startuml
skinparam monochrome reverse
skinparam sequence {
    ArrowColor gray
	ActorBorderColor gray
	LifeLineBorderColor gray
    LifeLineBackgroundColor gray
    ActorFontColor gray
}

left to right direction
User <<Болеющий>>
Admin <<Автор проекта>>

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

## Диаграмма компонентов системы

```plantuml
@startuml
skinparam monochrome true

skinparam sequence {
    ArrowColor blue
	ActorBorderColor green
	LifeLineBorderColor blue
    LifeLineBackgroundColor #A9DCDF
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
app -> panel: Информация о компании, статический контент
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
app -> user : Заполнение формы регистрации
user -> app : Ввод регистрационных данных
app -> api : Отправка данных на сервер
app -> user : Спасибо за регистрацию
api -> panel : Размещение данных о пользователе в БД
panel -> app : Успешная регистрация
app -> user : Главный экран с началом анкеты
== Прохождение анкеты ==
app <- user : Начало заполнения анкеты
app -> api : Отправка каждого этапа анкеты на сервер
api -> panel : Сохранение данных по пользователю в бд
app <- user : Заполнил анкету
api -> panel : Сохранение данных по пользователю в бд
api <- panel : Результат о возможных тренировках
app <- api : Уведомляем пользователя о возможностях
app -> user : Направляем на раздел питание

== Раздел «Питание» ==

app -> user : Укажите ваш рацион питания
app <- user : Ввод данных по питанию в прошлом
app -> api : Сохранение на сервер данных по пользователю
panel <- api : Помещаем в БД инфо по питанию
panel -> api : Формируем правильный рацион по недостающим элементам
panel -> api : Формируем правильный кол-во воды на основе анкеты
app <- api : Отправка калькуляции пользователю
app -> user : Ваш рацион должен быть таким {-}
app -> user : Ваше объём воды в сутки = {-}
app <- user : Готов питаться правильно
app -> user : Укажите что кушали сегодня?
app <- user : Ел вот это и это, а еще немножко это
app -> panel : Сохраняем в БД
app <- panel : Указываем на ошибки
app -> user : Как вы спите?

== Раздел «Сон» ==
app -> user : Запрос в Google Fit / Apple Health
app <- user : Разрешение использовать данные
app -> api : Отправка всей истории по Fit сервисам
panel <- api : Сохраняем информацию о сне U в БД
panel -> api : Отправляем рекомендацию о необх.сне
app <- api : Уведомляем пользователя
app -> user : Ведём пользователя в раздел Активность

== Раздел «Тренировки» ==
app <- user : Каков уровень активности?
app -> user : Указывает показатель
app -> api : Сохраняются параметры кроме тех что взяты в Fit сервисах
panel <- api : Помещаем данные о пользователе в БД
panel -> api : Выдаем результаты достаточных/необходимых нагрузок для пользователя
panel -> api : Выдаем результаты достаточных/необходимых нагрузок
app <- api : Отображаем пользователю
app -> user : Вы готовы держаться этого темпа?
app <- user : Готов.
app -> user : Рекоммендуем вот такие тренировки для начала

app <- user : Хорошо, начну с них

app <- user : Зафиксировал результат тренировки

app -> user : Хочешь знать зачем всё это?
app <- user : Да.
app -> user : Переходи в Обучение

== Раздел «Обучение» ==

app <- user : Перейти в Обучение
app -> panel : Запрос персональной ленты
app <- panel : Выдача релевантных вариантов для пользователя
app -> user : Посмотрите ролики в 1-3 минуты
app <- user : Посмотрел. Как теперь жить?!
app -> user : Как раньше, только лучше. Потому что с нами!
app -> user : Посмотри вот ещё это
app <- user : Глянул. Потрясён.
app -> user : Хочешь ещё?
app <- user : Нет, дайте отдохнуть, я не готов все сразу
app -> user : Хорошо, просто следуйте нашим советам и всё станет легко
app -> panel : Фиксация сколько и какого контента посморел пользователь.

@enduml
```


## Алгоритм проверки в анкете пользователя:

```plantuml
@startuml
skinparam monochrome reverse

start
    :Регистрация в приложении]
    :Заполнение анкеты;
repeat
    :Terms&Conditions;
    :Врачебная тайна;
repeat while (Продолжаем?) is (нет)
->да;

:Расскажите о вашем здоровье]

if (Есть осложнения?) then (да)
    if (Хронические заб-я сердечно-сосудистой с-мы) then (нет)
        :переход проверки к нагруз;
    else (да)
        if (Инсулинозависимый сх.диаб.?) then (да)
        else
            if (Желчекаменная или почечнокаменная болезнь?) then (да)
            else
    endif
    
endif
:close file;

if (Гинеколога, в том числе по поводу беременности?) then (да)
    :Вам можно заниматься
    только под присмотром врача;
    :В разделы: еда, жизнь, учёба>
  stop
endif

:Укажите ваш пол;

  fork
	:Мужчины;
	:Укажите ваш вес;
    if (>35% жира) then (да)
        :Переход к оздоровительной программе;
    stop
    endif
  fork again
	:Женщины;
	:Укажите ваш вес;
  end fork
' тут нужна проверка на тренировочные и нагрузочные
:Идем дальше?;

@enduml
```



Яков Иссакиевич Емельянов. Тренер. Отец Ирины Масленниковой.Есть в википедии.
