//
//  NonFiatTableViewCell.swift
//  cryptolists
//
//  Created by itemius on 17.06.2021.
//

import UIKit
import Kingfisher

class NonFiatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.backgroundColor = UIColor.lightGray
        iconImageView.layer.cornerRadius = 16.5
        iconImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateAsset(_ asset: Asset, darkMode: Bool) {
        nameLabel.text = asset.name
        
        let price = Double(asset.price)!
        let priceRounded = round(pow(10.0, Double(asset.precision))*price)/pow(10.0, Double(asset.precision))
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "eur"
        currencyFormatter.locale = Locale.current
        currencyFormatter.maximumFractionDigits = 2
        
        let priceString = currencyFormatter.string(from: NSNumber(value: priceRounded))!
        priceLabel.text = priceString

        iconImageView.kf.setImage(with: URL(string: darkMode ? asset.lightIcon : asset.icon), options: [.processor(SVGImgProcessor())])
    }
}
