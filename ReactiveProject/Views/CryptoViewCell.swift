//
//  CryptoViewCell.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 24.04.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//

import UIKit


class CryptoViewCell: UITableViewCell {
    
    let imageCrypto = UIImageView()
    var curNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var curCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var curAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var data: CellCrypto? {
        didSet{
            guard let data = data else {
                return
            }
            curNameLabel.text = data.name
            imageCrypto.image = Utils.getImage(name: data.name)
            curCostLabel.text = "\(data.cost ?? 0.0)$"
            curAmountLabel.text = "You have \(data.amount ?? 0.0)"
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let w = bounds.size.width
        let subviews = [
                 imageCrypto,curNameLabel,curCostLabel,curAmountLabel
        ]
        subviews.forEach { addSubview($0) }
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
      
        curNameLabel.font = UIFont(name: "Futura", size: w/14)
        curCostLabel.font = UIFont(name: "DIN Alternate", size: w/20)
        curAmountLabel.font = UIFont(name: "DIN Alternate", size: w/20)
        
      
        imageCrypto.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: w/4, height: w/4, enableInsets: false)
        curNameLabel.anchor(top: topAnchor, left: imageCrypto.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 3*w/4, height: 0, enableInsets: false)
        curCostLabel.anchor(top: curNameLabel.bottomAnchor, left: imageCrypto.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 3*w/4, height: 0, enableInsets: false)
        curAmountLabel.anchor(top: curCostLabel.bottomAnchor, left: imageCrypto.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width:  3*w/4, height: 0, enableInsets: false)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct CellCrypto {
    var name: String!
    var cost: Float!
    var amount: Float!
}
