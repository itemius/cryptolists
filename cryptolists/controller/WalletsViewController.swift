//
//  WalletsViewController.swift
//  cryptolists
//
//  Created by itemius on 17.06.2021.
//

import UIKit

class WalletsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var wallets: [Wallet] = []
    var commodityWallets: [Wallet] = []
    var fiatWallets: [Wallet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json = getJSON()
        wallets = getWallets(json, type: .wallet)
        wallets.sort {
            $0.balanceEuro > $1.balanceEuro
        }
        commodityWallets = getWallets(json, type: .commodity)
        commodityWallets.sort {
            $0.balanceEuro > $1.balanceEuro
        }
        fiatWallets = getWallets(json, type: .fiat)

        tableView.register(UINib(nibName: "WalletTableViewCell", bundle: nil), forCellReuseIdentifier: "WalletCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WalletsViewController: UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return wallets.count
            case 1:
                return commodityWallets.count
            case 2:
                return fiatWallets.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return "wallets"
            case 1:
                return "commodity wallets"
            case 2:
                return "fiat wallets"
            default:
                return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isDarkMode = traitCollection.userInterfaceStyle == .dark

        if let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell") as? WalletTableViewCell {
            switch indexPath.section {
                case 0:
                    cell.updateWallet(wallets[indexPath.row], darkMode: isDarkMode)
                case 1:
                    cell.updateWallet(commodityWallets[indexPath.row], darkMode: isDarkMode)
                case 2:
                    cell.updateWallet(fiatWallets[indexPath.row], darkMode: isDarkMode)
                default:
                    cell.updateWallet(wallets[indexPath.row], darkMode: isDarkMode)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

