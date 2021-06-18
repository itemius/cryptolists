//
//  AssetsViewController.swift
//  cryptolists
//
//  Created by itemius on 17.06.2021.
//

import UIKit
import SwiftyJSON
import CollapsibleTableSectionViewController
import Kingfisher

class AssetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typeSwitch: UISegmentedControl!
    var cryptocoins: [Asset] = []
    var commodities: [Asset] = []
    var fiats: [Asset] = []
    
    var showAll: Bool = true
    var selectedType: AssetType = .cryptocoin

    @IBAction func switchValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showAll = true
        case 1:
            showAll = false
            selectedType = .cryptocoin
        case 2:
            showAll = false
            selectedType = .commodity
        case 3:
            showAll = false
            selectedType = .fiat
        default:
            showAll = true
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FiatTableViewCell", bundle: nil), forCellReuseIdentifier: "FiatCell")
        tableView.register(UINib(nibName: "NonFiatTableViewCell", bundle: nil), forCellReuseIdentifier: "NonFiatCell")

        tableView.delegate = self
        tableView.dataSource = self
        
        cryptocoins = getCryptocoins(getJSON())
        commodities = getCommodities(getJSON())
        fiats = getFiats(getJSON())

        tableView.reloadData()
    }
}

extension AssetsViewController: UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        if showAll {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showAll {
            switch section {
            case 0:
                return cryptocoins.count
            case 1:
                return commodities.count
            case 2:
                return fiats.count
            default:
                return 0
            }
        } else {
            switch selectedType {
            case .cryptocoin:
                return cryptocoins.count
            case .commodity:
                return commodities.count
            case .fiat:
                return fiats.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if showAll {
            switch section {
            case 0:
                return "cryptocoins"
            case 1:
                return "commodities"
            case 2:
                return "fiats"
            default:
                return ""
            }
        } else {
            switch selectedType {
            case .cryptocoin:
                return "cryptocoins"
            case .commodity:
                return "commodities"
            case .fiat:
                return "fiats"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
                
        if showAll {
            switch indexPath.section {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NonFiatCell") as? NonFiatTableViewCell {
                    cell.updateAsset(cryptocoins[indexPath.row], darkMode: isDarkMode)
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NonFiatCell") as? NonFiatTableViewCell {
                    cell.updateAsset(commodities[indexPath.row], darkMode: isDarkMode)
                    return cell
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "FiatCell") as? FiatTableViewCell {
                    cell.updateAsset(fiats[indexPath.row], darkMode: isDarkMode)
                    return cell
                }
            default:
                return UITableViewCell()
            }
        } else {
            switch selectedType {
            case .cryptocoin:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NonFiatCell") as? NonFiatTableViewCell {
                    cell.updateAsset(cryptocoins[indexPath.row], darkMode: isDarkMode)
                    return cell
                }
            case .commodity:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NonFiatCell") as? NonFiatTableViewCell {
                    cell.updateAsset(commodities[indexPath.row], darkMode: isDarkMode)
                    return cell
                }
            case .fiat:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "FiatCell") as? FiatTableViewCell {
                    cell.updateAsset(fiats[indexPath.row], darkMode: isDarkMode)
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
}

