//
//  ServerResponses.swift
//  ToDoList
//
//  Created by Илья Лотник on 06.02.2024.
//

import Foundation

struct SuccessTokenResponse: Decodable {
    let refresh: String
    let access: String
}

class SuccessResponse: DataArray {}

struct ErrorUsernameResponse: Decodable {
    let username: [String]
}

struct ErrorPasswordResponse: Decodable {
    let password: [String]
}

struct Token: Decodable {
    let refresh: String
    let access: String
}

struct UserModel: Codable {
    let id: Int
    let username, firstName, lastName: String
    let todos: [TodoItem]

    enum CodingKeys: String, CodingKey {
        case id, username
        case firstName = "first_name"
        case lastName = "last_name"
        case todos
    }
}
