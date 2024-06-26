# language: ru

Функционал: Вход в систему
  Как зарегистрированный пользователь
  Я хочу иметь возможность войти в систему
  Для того чтобы получить доступ к моему аккаунту

  Сценарий: Успешный вход в систему
    Допустим у меня есть зарегистрированный аккаунт
    Когда я вхожу с email "misha@livechat.com" и паролем "123456"
    Тогда я должен быть перенаправлен на главную страницу

  Сценарий: Неуспешный вход в систему
    Когда я вхожу с email "misha@livechat.com" и неверным паролем "123456."
    Тогда я должен быть перенаправлен на страницу новой сессии
