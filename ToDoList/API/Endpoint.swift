//
//  Endpoints.swift
//  ToDoList
//
//  Created by Илья Лотник on 06.02.2024.
//

import Foundation


enum Endpoint {
    
    case createAccount(path: String = "auth/users/", userRequest: RegisterUserRequest)
    case requestToken(path: String = "auth/jwt/create/", userRequest: SignInUserRequest)
    case refreshToken(path: String = "auth/jwt/refresh/", userRequest: RefreshToken)
    case getAllTodosFromUser(path: String = "api/v1/users/")
    case addNewTodo(path: String = "api/v1/todos/", userRequest: AddNewTodoUserRequest)
    case editTodo(path: String = "api/v1/todos/", id: Int, userRequest: AddNewTodoUserRequest)
    case removeTodo(path: String = "api/v1/todos/", id: Int)
    case changeState(path: String = "api/v1/todos/", id: Int, userRequest: ChangeStateUserRequest)
    
    case getData(path: String = "auth/users/me")
    
    var request: URLRequest? {
        guard let url = URL(string: "\(Constants.fullURL)\(self.path)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.addValues(for: self)
        request.httpBody = self.httpBody
        return request
    }

    private var path: String {
        switch self {
            
        case .createAccount(let path, _),
                .getData(let path),
                .requestToken(let path, _),
                .refreshToken(let path, _),
                .addNewTodo(let path, _):
            return path
        case .getAllTodosFromUser(path: let path):
            if let username = User.shared.username {
                return "\(path)\(username)/"
            }
            return ""
        case .removeTodo(path: let path, id: let id),
                .changeState(path: let path, id: let id, _),
                .editTodo(path: let path, id: let id, _):
            return "\(path)\(id)/"
        }
    }
    
    private var httpMethod: String {
        switch self {
            
        case .createAccount, .requestToken, .refreshToken, .addNewTodo:
            return HTTP.Method.post.rawValue
        case .getData, .getAllTodosFromUser:
            return HTTP.Method.get.rawValue
        case .removeTodo:
            return HTTP.Method.delete.rawValue
        case .changeState, .editTodo:
            return HTTP.Method.patch.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
            
        case .createAccount(_, let userRequest):
            return try? JSONEncoder().encode(userRequest)
        case .getData, .getAllTodosFromUser, .removeTodo:
            return nil
        case .requestToken(_, let userRequest):
            return try? JSONEncoder().encode(userRequest)
        case .refreshToken(_, let userRequest):
            return try? JSONEncoder().encode(userRequest)
        case .addNewTodo(_, let userRequest), .editTodo(_, _, let userRequest):
            return try? JSONEncoder().encode(userRequest)
        case .changeState(_, _, let userRequest):
            return try? JSONEncoder().encode(userRequest)
        }
    }
}

extension URLRequest {
    
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {

        case .createAccount, .getData, .requestToken, .refreshToken:
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
        case .getAllTodosFromUser, .addNewTodo, .removeTodo, .changeState, .editTodo:
            let token = TokenManager.shared.getToken()
            guard let token = token else { return }
            
            self.setValue(HTTP.Headers.Value.applicationJson.rawValue,
                          forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue)
            self.setValue(HTTP.Headers.Value.token.rawValue + token,
                          forHTTPHeaderField: HTTP.Headers.Key.authorization.rawValue)
        }
    }
}
