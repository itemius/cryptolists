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

func getCryptocoins(_ json: JSON) -> [Asset] {
    var cryptocoins: [Asset] = []
    let cryptocoinsJSON = json["data"]["attributes"]["cryptocoins"].array!
    for coin in cryptocoinsJSON {
        cryptocoins.append(Asset(id: coin["id"].string ?? "", type: .cryptocoin,
                                    icon: coin["attributes"]["logo"].string ?? "",
                                    lightIcon: coin["attributes"]["logo_dark"].string ?? "",
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
                                     lightIcon: coin["attributes"]["logo_dark"].string ?? "",
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
                                    lightIcon: coin["attributes"]["logo_white"].string ?? "",
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

func getWallets(_ json: JSON) -> [Wallet] {
    var wallets: [Wallet] = []
    let walletsJSON = json["data"]["attributes"]["wallets"].array!
    for wallet in walletsJSON {
        if wallet["attributes"]["deleted"].bool ?? false {
            
        } else {
            let coins = getCryptocoins(json)
            for coin in coins {
                if coin.id == wallet["attributes"]["cryptocoin_id"].string {
                    wallets.append(Wallet(type: .wallet,
                                            asset: coin,
                                            name: wallet["attributes"]["name"].string ?? "",
                                            balance: wallet["attributes"]["balance"].string ?? "",
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
            let coins = getCommodities(json)
            for coin in coins {
                if coin.id == wallet["attributes"]["cryptocoin_id"].string {
                    wallets.append(Wallet(type: .commodity,
                                            asset: coin,
                                            name: wallet["attributes"]["name"].string ?? "",
                                            balance: wallet["attributes"]["balance"].string ?? "",
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
            let coins = getFiats(json)
            for coin in coins {
                if coin.id == wallet["attributes"]["fiat_id"].string {
                    wallets.append(Wallet(type: .commodity,
                                            asset: coin,
                                            name: wallet["attributes"]["name"].string ?? "",
                                            balance: wallet["attributes"]["balance"].string ?? "",
                                            isDefault: wallet["attributes"]["is_default"].bool ?? false,
                                            isDeleted: false
                                        ))
                }

        }
    }
    return wallets
}

