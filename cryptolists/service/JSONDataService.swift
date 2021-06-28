//
//  JSONDataService.swift
//  cryptolists
//
//  Created by itemius on 17.06.2021.
//

import Foundation
import SwiftyJSON

func getJSON() -> JSON {
    var json = JSON()
    if let path = Bundle.main.path(forResource: "Mastrerdata", ofType: "json") {
        if let data = NSData(contentsOfFile: path) {
            json = try! JSON(data: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
        }
    }
    return json
}

func getAssets(_ json: JSON, type: AssetType) -> [Asset] {
    var assets: [Asset] = []
    var assetTypeString = ""
    switch type {
    case .cryptocoin:
        assetTypeString = "cryptocoins"
    case .commodity:
        assetTypeString = "commodities"
    case .fiat:
        assetTypeString = "fiats"
    }
    let assetsJSON = json["data"]["attributes"][assetTypeString].array!
    for asset in assetsJSON {
            if type != .fiat || (asset["attributes"]["has_wallets"].bool ?? false) {
                
                assets.append(Asset(id: asset["id"].string ?? "", type: type,
                                    icon: asset["attributes"]["logo"].string ?? "",
                                    darkIcon: asset["attributes"]["logo_dark"].string ?? "",
                                    name: asset["attributes"]["name"].string ?? "",
                                    symbol: asset["attributes"]["symbol"].string ?? "",
                                    price: asset["attributes"]["avg_price"].string ?? "",
                                    precision: asset["attributes"]["precision_for_fiat_price"].int ?? 0,
                                    precisionCoins: asset["attributes"]["precision_for_coins"].int ?? 0,
                                    hasWallet: asset["attributes"]["has_wallets"].bool ?? false))
            }
        }
    return assets
}

func getCryptocoins(_ json: JSON) -> [Asset] {
    var cryptocoins: [Asset] = []
    let cryptocoinsJSON = json["data"]["attributes"]["cryptocoins"].array!
    for coin in cryptocoinsJSON {
        cryptocoins.append(Asset(id: coin["id"].string ?? "", type: .cryptocoin,
                                    icon: coin["attributes"]["logo"].string ?? "",
                                    darkIcon: coin["attributes"]["logo_dark"].string ?? "",
                                    name: coin["attributes"]["name"].string ?? "",
                                    symbol: coin["attributes"]["symbol"].string ?? "",
                                    price: coin["attributes"]["avg_price"].string ?? "",
                                    precision: coin["attributes"]["precision_for_fiat_price"].int ?? 0,
                                    precisionCoins: coin["attributes"]["precision_for_coins"].int ?? 0,
                                    hasWallet: false))
        }
    return cryptocoins
}

func getCommodities(_ json: JSON) -> [Asset] {
    var commodities: [Asset] = []
    let commoditiesJSON = json["data"]["attributes"]["commodities"].array!
    for coin in commoditiesJSON {
        commodities.append(Asset(id: coin["id"].string ?? "", type: .commodity,
                                     icon: coin["attributes"]["logo"].string ?? "",
                                     darkIcon: coin["attributes"]["logo_dark"].string ?? "",
                                     name: coin["attributes"]["name"].string ?? "",
                                     symbol: coin["attributes"]["symbol"].string ?? "",
                                     price: coin["attributes"]["avg_price"].string ?? "",
                                     precision: coin["attributes"]["precision_for_fiat_price"].int ?? 0,
                                     precisionCoins: coin["attributes"]["precision_for_coins"].int ?? 0,
                                     hasWallet: false))
        }
    return commodities
}

func getFiats(_ json: JSON) -> [Asset] {
    var fiats: [Asset] = []
    let fiatsJSON = json["data"]["attributes"]["fiats"].array!
    for coin in fiatsJSON {
        if coin["attributes"]["has_wallets"].bool ?? false {
            fiats.append(Asset(id: coin["id"].string ?? "", type: .fiat,
                                    icon: coin["attributes"]["logo"].string ?? "",
                                    darkIcon: coin["attributes"]["logo_white"].string ?? "",
                                    name: coin["attributes"]["name"].string ?? "",
                                    symbol: coin["attributes"]["symbol"].string ?? "",
                                    price: "",
                                    precision: 0,
                                    precisionCoins: 0,
                                    hasWallet: true))
            }
        }
    return fiats
}

func getWallets(_ json: JSON, type: WalletType) -> [Wallet] {
    var wallets: [Wallet] = []
    var walletTypeString = ""
    var assetIdString = ""
    var assetType: AssetType = .cryptocoin
    switch type {
    case .wallet:
        walletTypeString = "wallets"
        assetIdString = "cryptocoin_id"
        assetType = .cryptocoin
    case .commodity:
        walletTypeString = "commodity_wallets"
        assetIdString = "cryptocoin_id"
        assetType = .commodity
    case .fiat:
        walletTypeString = "fiatwallets"
        assetIdString = "fiat_id"
        assetType = .fiat
    }
    let walletsJSON = json["data"]["attributes"][walletTypeString].array!
    for wallet in walletsJSON {
        if wallet["attributes"]["deleted"].bool ?? false {
            
        } else {
            let coins = getAssets(json, type: assetType)
            for coin in coins {
                if coin.id == wallet["attributes"][assetIdString].string {
                    let balanceEuro = (Double(wallet["attributes"]["balance"].string ?? "0.0") ?? 0.0) * (Double(coin.price) ?? -1.0)
                    let balanceEuroRounded = Double(round(100*balanceEuro)/100)
                    wallets.append(Wallet(type: .wallet,
                                            asset: coin,
                                            name: wallet["attributes"]["name"].string ?? "",
                                            balance: wallet["attributes"]["balance"].string ?? "",
                                            balanceEuro: balanceEuroRounded,
                                            isDefault: wallet["attributes"]["is_default"].bool ?? false,
                                            isDeleted: false
                                        ))
                }
            }
        }
    }
    return wallets
}

func getWallets(_ json: JSON) -> [Wallet] {
    var wallets: [Wallet] = []
    let walletsJSON = json["data"]["attributes"]["wallets"].array!
    for wallet in walletsJSON {
        if wallet["attributes"]["deleted"].bool ?? false {
            
        } else {
            let coins = getAssets(json, type: .cryptocoin)
            for coin in coins {
                if coin.id == wallet["attributes"]["cryptocoin_id"].string {
                    let balanceEuro = (Double(wallet["attributes"]["balance"].string ?? "0.0") ?? 0.0) * (Double(coin.price) ?? 0.0)
                    let balanceEuroRounded = Double(round(100*balanceEuro)/100)
                    wallets.append(Wallet(type: .wallet,
                                            asset: coin,
                                            name: wallet["attributes"]["name"].string ?? "",
                                            balance: wallet["attributes"]["balance"].string ?? "",
                                            balanceEuro: balanceEuroRounded,
                                            isDefault: wallet["attributes"]["is_default"].bool ?? false,
                                            isDeleted: false
                                        ))
                }
            }
        }
    }
    return wallets
}

func getCommodityWallets(_ json: JSON) -> [Wallet] {
    var wallets: [Wallet] = []
    let walletsJSON = json["data"]["attributes"]["commodity_wallets"].array!
    for wallet in walletsJSON {
        if wallet["attributes"]["deleted"].bool ?? false {
            
        } else {
            let coins = getAssets(json, type: .commodity)
            for coin in coins {
                if coin.id == wallet["attributes"]["cryptocoin_id"].string {
                    let balanceEuro = (Double(wallet["attributes"]["balance"].string ?? "0.0") ?? 0.0) * (Double(coin.price) ?? 0.0)
                    let balanceEuroRounded = Double(round(100*balanceEuro)/100)
                    wallets.append(Wallet(type: .commodity,
                                            asset: coin,
                                            name: wallet["attributes"]["name"].string ?? "",
                                            balance: wallet["attributes"]["balance"].string ?? "",
                                            balanceEuro: balanceEuroRounded,
                                            isDefault: wallet["attributes"]["is_default"].bool ?? false,
                                            isDeleted: false
                                        ))
                }
            }

        }
    }
    return wallets
}

func getFiatWallets(_ json: JSON) -> [Wallet] {
    var wallets: [Wallet] = []
    let walletsJSON = json["data"]["attributes"]["fiatwallets"].array!
    for wallet in walletsJSON {
            let coins = getAssets(json, type: .fiat)
            for coin in coins {
                if coin.id == wallet["attributes"]["fiat_id"].string {
                    wallets.append(Wallet(type: .commodity,
                                            asset: coin,
                                            name: wallet["attributes"]["name"].string ?? "",
                                            balance: wallet["attributes"]["balance"].string ?? "",
                                            balanceEuro: -1.0,
                                            isDefault: wallet["attributes"]["is_default"].bool ?? false,
                                            isDeleted: false
                                        ))
                }

        }
    }
    return wallets
}

