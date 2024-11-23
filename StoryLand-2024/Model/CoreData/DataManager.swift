//
//  DataManager.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 24/11/2024.
//

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var userData: UserData {
        didSet {
            saveUserData()
        }
    }

    private let tokenKey = "TokenKey"
    private let purchaseItemsKey = "PurchaseItemsKey"

    private init() {
        let token = UserDefaults.standard.integer(forKey: tokenKey)
        let purchasedItems = UserDefaults.standard.stringArray(forKey: purchaseItemsKey) ?? []
        self.userData = UserData(token: token == 0 ? 100 : token, purchasedItems: purchasedItems)
    }

    private func saveUserData() {
        UserDefaults.standard.set(userData.token, forKey: tokenKey)
        UserDefaults.standard.set(userData.purchasedItems, forKey: purchaseItemsKey)
    }
    
    func addToken(token: Int) {
        userData.token += token
        saveUserData()
    }
    
    func purchaseItem(item: Shop) {
        userData.purchasedItems.append(item.itemName)
        userData.token -= item.price
        saveUserData()
    }
}
