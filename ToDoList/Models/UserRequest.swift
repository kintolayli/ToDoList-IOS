//
//  UserRequest.swift
//  ToDoList
//
//  Created by Илья Лотник on 06.02.2024.
//

import Foundation

struct RegisterUserRequest: Codable {
    let email: String
    let username: String
    let password: String
}

struct SignInUserRequest: Codable {
    let username: String
    let password: String
}

struct AddNewTodoUserRequest: Codable {
    let name: String
}

struct ChangeStateUserRequest: Codable {
    let is_completed: Bool
}

class DataArray: Decodable {
    let email: String
    let username: String
    let id: Int
}

struct AccessToken: Codable {
    let access: String
}

struct RefreshToken: Codable {
    let refresh: String
}
