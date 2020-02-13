# Просто, ЗОЖ


## Назначение и цели проекта
Система предназначается для быстрого и качественного обмена информацией между клиентами и собственниками БЦ «JapanHouse».



# Взаимодействие между пользователями и автором

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
