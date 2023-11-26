//
//  TokenManager.swift
//  ToDoList
//
//  Created by Илья Лотник on 08.02.2024.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()

    private var accessToken: String?
    private var keyAccessToken: String? {
        guard let user = User.shared.username else { return nil }
        return "\(user)_accessToken"
    }
    private var refreshToken: String?
    private var keyRefreshToken: String? {
        guard let user = User.shared.username else { return nil }
        return "\(user)_refreshToken"
    }
    
    var isTokenExist: Bool {
        if self.accessToken != nil {
            return true
        }
        return false
    }
    
    private var expirationToken: Date? {
        guard let tokenAccess = self.accessToken else { return nil }
        let tokenDecode = decodeJwt(tokenAccess: tokenAccess)
        let exp = tokenDecode?["exp"] as? TimeInterval

        if let intValue = exp {
            let date = Date(timeIntervalSince1970: intValue)
            print(date)
            return date
        }
        return nil
    }


    private init() {
        setup()
    }
    
    func setup() {
        guard let keyAccessToken = keyAccessToken else { return }
        guard let keyRefreshToken = keyRefreshToken else { return }
        
        if let accessTokenSaved = UserDefaults.standard.string(forKey: keyAccessToken),
           let refreshTokenSaved = UserDefaults.standard.string(forKey: keyRefreshToken) {
            self.accessToken = accessTokenSaved
            self.refreshToken = refreshTokenSaved
            
            let newexp = expirationToken!
            let today = Date()
            print(newexp < today)
            
            guard let exp = expirationToken, exp < Date() else { return }
            tokenRefresh()
        }
    }
        
    func saveToken(_ token: Token?) {
        if let token = token {
            self.accessToken = token.access
            self.refreshToken = token.refresh
            saveTokenToUserDefaults()
        }
    }
        
    private func saveTokenToUserDefaults() {
        // Сохранение токена и времени истечения в UserDefaults
        guard let keyAccessToken = keyAccessToken else { return }
        guard let keyRefreshToken = keyRefreshToken else { return }
        UserDefaults.standard.set(accessToken, forKey: keyAccessToken)
        UserDefaults.standard.set(refreshToken, forKey: keyRefreshToken)
    }
    
    func deleteDataFromUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        accessToken = nil
        refreshToken = nil
    }
    
    func getToken() -> String? {        
        guard let expiration = expirationToken, expiration > Date() else {
            tokenRefresh()
            return accessToken
        }
        return accessToken
    }
    
    func requestAndSaveJWTToken(userRequest: SignInUserRequest, completion: @escaping (Int) -> Void) {
        guard let request = Endpoint.requestToken(userRequest: userRequest).request else { return }
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response type")
                return
            }
            
            let statusCode = httpResponse.statusCode
            print("Status code: \(statusCode)")
            
            switch statusCode {
            case 200:
                User.shared.isAccessAllowed = true
                print(statusCode)
                let token = try? JSONDecoder().decode(Token.self, from: data)
                self.saveToken(token)
                completion(statusCode)
            case 401:
                User.shared.isAccessAllowed = false
                print(statusCode)
                completion(statusCode)
            default:
                print("Unknown status code: \(statusCode)")
            }
        }
        session.resume()
    }
    
    private func tokenRefresh() {
        
        let refreshToken = RefreshToken(refresh: refreshToken ?? "")
        guard let request = Endpoint.refreshToken(userRequest: refreshToken).request else { return }

        let _: Void = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            guard let newAccessToken = try? JSONDecoder().decode(AccessToken.self, from: data) else { return }
            self.accessToken = newAccessToken.access
            self.saveTokenToUserDefaults()
            
        }.resume()
    }
}
    
    
func decodeJwt(tokenAccess: String) -> [String: Any]? {
    let segments = tokenAccess.components(separatedBy: ".")
    guard segments.count == 3 else { return nil }
    
    // Декодируем вторую часть (payload) из base64
    if let payloadData = base64UrlDecode(segments[1]),
       let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
       let payload = json as? [String: Any] {
        return payload
    } else {
        return nil
    }
}

private func base64UrlDecode(_ value: String) -> Data? {
    var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    
    let length = Double(base64.lengthOfBytes(using: .utf8))
    let requiredLength = 4 * ceil(length / 4.0)
    let paddingLength = requiredLength - length
    
    if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
    }
    
    return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
}
