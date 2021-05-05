//
//  AppHelper.swift
//  DOKKU
//
//  Created by Maritia Pangaribuan on 05/05/21.
//

import Foundation

class AppHelper {
    
    static let shared = AppHelper()
    
    private init(){}
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func saveDatatoUserDefault(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getDatafromUserUserDefaultByKey(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
}
