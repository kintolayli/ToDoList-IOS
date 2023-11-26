//
//  AlertManager.swift
//  ToDoList
//
//  Created by Илья Лотник on 06.02.2024.
//

import UIKit


class AlertManager {
    
    private static func showOneButtonAlert(on vc: UIViewController, title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    private static func showOneButtonAlertWithCompletion(on vc: UIViewController, title: String, message: String?, completion: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    private static func showTwoButtonAlert(on vc: UIViewController, title: String?, message: String? = nil, button1: UIAlertAction, button2: UIAlertAction) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(button1)
        alert.addAction(button2)
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    struct AlertAction {
        let title: String
        let style: UIAlertAction.Style
        let handler: (([String]) -> Void)
    }
    
    private static func showTextFieldAlertWithReturnFieldValue(on vc: UIViewController, title: String, message: String? = nil, textFields: [(UITextField) -> Void], actions: [AlertAction]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        textFields.forEach({ alert.addTextField(configurationHandler: $0) })
        
        actions.forEach({ action in
            alert.addAction(UIAlertAction(title: action.title, style: action.style, handler: { _ in
                let strings = (alert.textFields ?? []).compactMap { $0.text?.isEmpty == false ? $0.text : nil }
                action.handler(strings)
            }))
        })
        
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
}


// MARK: - TextField Alerts
extension AlertManager {

    static func addNewItemAlert(on vc: UIViewController, titleButton1: String, titleButton2: String, titleAlert: String, oldTodoName: String, completion: @escaping ([String]) -> Void) {
        var textFields: [(UITextField) -> ()] = []
        
        textFields.append { (textField) in
            textField.placeholder = Constants.itemPlaceholders.randomElement()
            textField.text = oldTodoName
        }
        
        let actions: [AlertAction] = [
            AlertAction(title: titleButton1, style: .destructive, handler: { _ in completion([""]) }),
            AlertAction(title: titleButton2, style: .default, handler: completion)
        ]
        
        self.showTextFieldAlertWithReturnFieldValue(on: vc, title: titleAlert, message: nil, textFields: textFields, actions: actions)
    }
}


// MARK: - Logout Alerts
extension AlertManager {
    
    public static func showLogoutConfirmation(on vc: UIViewController, completion: @escaping (Bool) -> Void) {
        
        let button1 = UIAlertAction(title: "Нет", style: .cancel) { _ in completion(false) }
        let button2 = UIAlertAction(title: "Да", style: .destructive) { _ in
            completion(true)
        }
        self.showTwoButtonAlert(on: vc, title: "Подтверждение выхода", message: "Вы действительно хотите выйти?", button1: button1, button2: button2)
    }
    
    public static func showEditOrDeleteConfirmation(on vc: UIViewController, titleCell: String, messageCell: String, completion: @escaping (Bool) -> Void) {
        
        let button1 = UIAlertAction(title: "Изменить", style: .cancel) { _ in completion(false) }
        let button2 = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            completion(true)
        }
        self.showTwoButtonAlert(on: vc, title: titleCell, message: messageCell, button1: button1, button2: button2)
    }
}


// MARK: - Validation Error Alerts
extension AlertManager {
        
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showOneButtonAlert(on: vc, title: "Неправильный email", message: "Введите корректный email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showOneButtonAlert(on: vc, title: "Неправильный пароль", message: "Введите корректный пароль")
    }
    
    public static func showInvalidUsernameAlert(on vc: UIViewController) {
        self.showOneButtonAlert(on: vc, title: "Неправильное имя пользователя", message: "Введите корректное имя пользователя")
    }
}


// MARK: - Registration Error Alerts
extension AlertManager {
    
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showOneButtonAlert(on: vc, title: "Ошибка при регистрации пользователя", message: nil)
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: String) {
        self.showOneButtonAlert(on: vc, title: "Ошибка при регистрации пользователя", message: "\(error)")
    }
    
}


// MARK: - Log In Errors Alerts
extension AlertManager {
    
    public static func showUserDoesNotExist(on vc: UIViewController, completion: @escaping (Bool) -> Void) {
        self.showOneButtonAlertWithCompletion(on: vc, title: "Ошибка входа", message: "Такого пользователя не существует", completion: { _ in })
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showOneButtonAlert(on: vc, title: "Ошибка входа", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: String) {
        self.showOneButtonAlert(on: vc, title: "Ошибка входа", message: "\(error)")
    }
}


// MARK: - Forgot Password Error Alerts
extension AlertManager {
    
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showOneButtonAlert(on: vc, title: "Сброс пароля", message: "Ссылка для сброса пароля была отправлена.")
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        self.showOneButtonAlert(on: vc, title: "Ошибка сброса пароля", message: "\(error.localizedDescription)")
    }
}
