//
//  TodoItem.swift
//  ToDoList
//
//  Created by Илья Лотник on 09.02.2024.
//

import Foundation


struct TodoItem: Codable, Comparable {
    
    let id: Int
    let name: String
    var isCompleted: Bool
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case isCompleted = "is_completed"
        case created
    }
    
    static func < (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.created < rhs.created
    }
    
    mutating func toggleCompletion() {
        isCompleted = !isCompleted
    }
}
