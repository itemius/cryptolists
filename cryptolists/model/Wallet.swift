//
//  Wallet.swift
//  cryptolists
//
//  Created by itemius on 17.06.2021.
//

import Foundation

enum WalletType {
    case commodity
    case wallet
    case fiat
}

struct Wallet {
    var type: WalletType
    var asset: Asset
    var name: String
    var balance: String
    var balanceEuro: Double
    var isDefault: Bool
    var isDeleted: Bool
}
