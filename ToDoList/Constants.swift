//
//  Constants.swift
//  ToDoList
//
//  Created by Илья Лотник on 06.02.2024.
//

import Foundation


struct Constants {
    
    // MARK: - Networl Layer Literals
    static let scheme = "http"
    static let host = "195.43.142.226"
    static let fullURL = "\(scheme)://\(host)/"
    
    // MARK: - Common Literals
    static let dateFormat = "dd MMMM yyyy г. в HH:mm"
    static let secondsFromGMT = 10800
    static let locale = "ru_RU"
    
    static let okLiteral = "Хорошо"
    static let closeLiteral = "Закрыть"
    static let yesLiteral = "Да"
    static let noLiteral = "Нет"
    static let changeLiteral = "Изменить"
    static let deleteLiteral = "Удалить"
    static let cancelLiteral = "Отменить"
    static let saveLiteral = "Сохранить"
    static let addLiteral = "Добавить"
    static let newRecordLiteral = "Новая запись"
    static let editRecordLiteral = "Редактировать запись"
    
    
    static let authTextFieldUsernamePlaceHolder = "Имя пользователя"
    static let authTextFieldEmailPlaceHolder = "Ваш email"
    static let authTextFieldPasswordPlaceHolder = "Пароль"
    
    // MARK: - Main Screen Literals
    static let TodoDoesNotExistLiteral = "Здесь пока ничего нет.\n Создайте свою первую запись!"
    static let logoutConfirmationTitleLiteral = "Подтверждение выхода"
    static let logoutConfirmationMessageLiteral = "Вы действительно хотите выйти?"
    
    // MARK: - Validation Error Literals
    static let invalidEmailTitleLiteral = "Неправильный email"
    static let invalidEmailMessageLiteral = "Введите корректный email."
    
    static let invalidPasswordTitleLiteral = "Неправильный пароль"
    static let invalidPasswordMessageLiteral = "Введите корректный пароль"
    
    static let invalidUsernameTitleLiteral = "Неправильное имя пользователя"
    static let invalidUsernameMessageLiteral = "Введите корректное имя пользователя"
    
    // MARK: - Registration Screen Literals
    static let registrationHeaderTitle = "Регистрация"
    static let registrationHeaderSubTitle = "Создать учетную запись"
    static let registrationSignUpButtonTitle = "Создать"
    static let registrationSignInButtonTitle = "Уже есть учетная запись? Войдите."
    
    static let registrationTermsTextViewLiteral = "Создавая учетную запись, вы соглашаетесь с нашими Положениями и условиями и подтверждаете, что ознакомились с нашей Политикой конфиденциальности."
    static let registrationTermsTextViewTermsAndConditionsURLScheme = "terms"
    static let registrationTermsTextViewTermsAndConditionsURL = "https://policies.google.com/terms?hl=ru"
    static let registrationTermsTextViewTermsAndConditionsLinkLiteral = "terms://termsAndConditions"
    static let registrationTermsTextViewTermsAndConditionsLinkPositionLiteral = "Положениями и условиями"
    static let registrationTermsTextViewPrivacyPolicyURLScheme = "privacy"
    static let registrationTermsTextViewPrivacyPolicyURL = "https://policies.google.com/privacy?hl=ru"
    static let registrationTermsTextViewPrivacyPolicyLinkLiteral = "privacy://privacyPolicy"
    static let registrationTermsTextViewPrivacyPolicyLinkPositionLiteral = "Политикой конфиденциальности"
    
    static let registrationErrorTitleLiteral = "Ошибка при регистрации пользователя"
    
    // MARK: - Log In Screen Literals
    static let logInHeaderTitle = "Вход"
    static let logInHeaderSubTitle = "Войдите в свою учетную запись"
    static let logInSignInButtonTitle = "Войти"
    static let logInNewUserButtonTitle = "...или сначала создайте ее."
    static let logInForgotPasswordButtonTitle = "Забыли пароль?"
    
    static let logInErrorTitleLiteral = "Ошибка входа"
    static let logInErrorMessageLiteral = "Такого пользователя не существует"
    
    // MARK: - Reset Password Screen Literals
    static let resetPasswordHeaderTitle = "Забыли пароль?"
    static let resetPasswordHeaderSubTitle = "Забыли пароль?"
    static let resetPasswordButtonTitle = "Сбросить пароль"
    
    static let resetPasswordTitleLiteral = "Сброс пароля"
    static let resetPasswordMessageTitleLiteral = "Ссылка для сброса пароля была отправлена."
    
    // MARK: - Othre Errors
    static let unknownErrorLiteral = "Случилась неизвестная ошибка."
    static let dowloadingDataErrorLiteral = "Ошибка во время загрузки данных."
    
    // MARK: - Variable placeholders
    static let itemPlaceholders: [String] = ["Сделать зарядку", "Запланировать завтрак в красивом месте", "Пить воду в течении дня", "Проверить почту", "Проверить календарь", "Подготовиться к важной встрече", "Пообедать", "Прогуляться", "Продолжить работу над проектами", "Позвонить друзьям", "Позвонить семье", "Подготовиться к завтрашнему дню", "Поужинать", "Прочитать книгу", "Посмотреть фильм", "Посмотреть сериал", "Помыть посуду", "Убрать дом", "Почистить зубы", "Собрать вещи", "Слушать музыку", "Лечь спать до 23:00", "Собрать сумку в дорогу"]
}

