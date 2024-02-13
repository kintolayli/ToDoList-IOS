//
//  User.swift
//  ToDoList
//
//  Created by Илья Лотник on 07.02.2024.
//

import Foundation


struct User {
    static var shared = User()
    
    var username: String?
    var password: String?
    var email: String?
    
    var isAccessAllowed = false
    
    private init() {
        setup()
    }
    
    private func saveUserData() {
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    mutating func initData(username: String, password: String, inputEmail: String) {
        self.username = username
        self.password = password
        
        if self.email == nil {
            self.email = inputEmail
        }
        saveUserData()
    }
    
    mutating func setup() {
        if let username = UserDefaults.standard.string(forKey: "username"),
           let password = UserDefaults.standard.string(forKey: "password"),
           let email = UserDefaults.standard.string(forKey: "email") {
            self.username = username
            self.password = password
            self.email = email
        }
    }
}
