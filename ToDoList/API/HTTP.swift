//
//  HTTP.swift
//  ToDoList
//
//  Created by Илья Лотник on 06.02.2024.
//

import Foundation


enum HTTP {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum Headers {
        
        enum Key: String {
            case contentType = "Content-Type"
            case authorization = "Authorization"
        }
        
        enum Value: String {
            case applicationJson = "application/json"
            case token = "Bearer "
        }
    }
}
