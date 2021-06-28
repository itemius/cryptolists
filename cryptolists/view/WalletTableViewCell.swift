//
//  WalletTableViewCell.swift
//  cryptolists
//
//  Created by itemius on 18.06.2021.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceEuroLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.backgroundColor = UIColor.lightGray
        iconImageView.layer.cornerRadius = 16.5
        iconImageView.clipsToBounds = true
        defaultLabel.layer.cornerRadius = 3
        defaultLabel.layer.borderWidth = 1
        defaultLabel.layer.borderColor = UIColor.black.cgColor
        defaultLabel.clipsToBounds = true
        defaultLabel.backgroundColor = UIColor.yellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWallet(_ wallet: Wallet, darkMode: Bool) {
        nameLabel.text = wallet.name
        
        let balance = Double(wallet.balance)!
        let balanceRounded = round(pow(10.0, Double(wallet.asset.precisionCoins))*balance)/pow(10.0, Double(wallet.asset.precisionCoins))
                
        defaultLabel.isHidden = !wallet.isDefault

        balanceLabel.text = balanceRounded.description + " " + wallet.asset.symbol
        
        if wallet.balanceEuro >= 0 {
            balanceEuroLabel.isHidden = false
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencyCode = "eur"
            currencyFormatter.locale = Locale.current
            currencyFormatter.maximumFractionDigits = 2
            
            let priceString = currencyFormatter.string(from: NSNumber(value: wallet.balanceEuro))!
            balanceEuroLabel.text = priceString
        } else {
            balanceEuroLabel.isHidden = true
        }

        iconImageView.kf.setImage(with: URL(string: darkMode ? wallet.asset.darkIcon : wallet.asset.icon), options: [.processor(SVGImgProcessor())])
    }
    
}
