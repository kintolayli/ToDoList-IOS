//
//  Model.swift
//  ToDoList
//
//  Created by User on 26.11.2023.
//

import Foundation
import UserNotifications
import UIKit

var ToDoItems: [[String: Any]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
        UserDefaults.standard.synchronize()
    }
    
    get {
        if let array = UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
    }
}

func addItem(nameItem: String, isCompleted: Bool = false) {
    let tempDictionary: [String: Any] = ["name": nameItem, "isCompleted": isCompleted]
    ToDoItems.append(tempDictionary)
    setBadge()
}

func removeItem(at index: Int) {
    ToDoItems.remove(at: index)
    setBadge()
}

func moveItem(fromIndex: Int, toIndex: Int) {
    let from = ToDoItems[fromIndex]
    ToDoItems.remove(at: fromIndex)
    ToDoItems.insert(from, at: toIndex)
}

func changeState(at item: Int) ->  Bool {
    ToDoItems[item]["isCompleted"] = !(ToDoItems[item]["isCompleted"] as! Bool)
    setBadge()
    return ToDoItems[item]["isCompleted"] as! Bool
}

func requestForNotificcation() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { isEnabled, error in
        if isEnabled {
            print("Пользователь согласен")
        } else {
            print("Пользователь не согласен")
        }
    }
}

func setBadge() {
    var totalBadgeCount = 0
    for item in ToDoItems {
        if !(item["isCompleted"] as! Bool) {
            totalBadgeCount += 1
        }
    }
    
    UNUserNotificationCenter.current().setBadgeCount(totalBadgeCount)
}
