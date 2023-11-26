//
//  AuthService.swift
//  ToDoList
//
//  Created by Илья Лотник on 06.02.2024.
//

import Foundation


func formatServerResponseToString(stringArray: [String]) -> String {
    var newResponse = ""
    
    for line in stringArray {
        newResponse += "\n\(line)\n"
    }
    return newResponse
}

enum ServiceError: Error {
    case serverError(String)
    case unknown(String = "Случилась неизвестная ошибка.")
    case decodingError(String = "Ошибка во время загрузки данных.")
}

class AuthService {
    
    static func fetch(request: URLRequest, completion: @escaping
                              (Result<SuccessResponse, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    print(response.statusCode)
                case 204:
                    print(response.statusCode)
                default:
                    print(response.statusCode)
                }
            }
            
            guard let data = data else {
                if let error = error {
                    completion(.failure(ServiceError.serverError(error.localizedDescription)))
                } else {
                    completion(.failure(ServiceError.unknown()))
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            if let successMessage = try? decoder.decode(SuccessResponse.self, from: data) {
                completion(.success(successMessage))
                return
            }
            else if let errorUsernameMessage = try? decoder.decode(ErrorUsernameResponse.self, from: data) {
                completion(.failure(ServiceError.serverError(
                    formatServerResponseToString(stringArray: errorUsernameMessage.username))))
                return
            }
            else if let errorPasswordMessage = try? decoder.decode(ErrorPasswordResponse.self, from: data) {
                completion(.failure(ServiceError.serverError(
                    formatServerResponseToString(stringArray: errorPasswordMessage.password))))
                return
            }
            else {
                completion(.failure(ServiceError.decodingError()))
                return
            }
        }.resume()
    }
}
