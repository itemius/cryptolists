//
//  Asset.swift
//  cryptolists
//
//  Created by itemius on 17.06.2021.
//

import Foundation

enum AssetType {
    case cryptocoin
    case commodity
    case fiat
}

struct Asset {
    var id: String
    var type: AssetType
    var icon: String
    var darkIcon: String
    var name: String
    var symbol: String
    var price: String
    var precision: Int
    var precisionCoins: Int
    var hasWallet: Bool
}
