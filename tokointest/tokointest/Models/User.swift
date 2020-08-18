//
//  User.swift
//  tokointest
//
//  Created by Macintosh HD on 8/18/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//
import UIKit

class User: Codable {
    var userName: String?
    var keyword: String?
    
    static func getUserProfile() -> User {
        var user : User
        let userDefaults = UserDefaults.standard
        do {
            user = try userDefaults.getObject(forKey: "UserProfile", castTo: User.self)
        } catch {
            print(error.localizedDescription)
            user = User()
            user.userName = ""
            user.keyword = ""
        }
        return user
    }
}
