//
//  Utils.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 18.05.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//
import UIKit


struct Utils{
    
    public static func getImage(name:String)->UIImage?{
        var imageName = ""
        switch name {
        case "ETH Ethereum":
            imageName = "ethereum"
        case "LTC Litecoin":
            imageName = "litecoin"
        case "BCH Bitcoin Cash":
            imageName = "bitcoin-cash"
        case "ETC Ethereum Classic":
            imageName = "ethereum-classic"
        case "ZEC Zcash":
            imageName = "zcash"
        case "EOS EOS":
            imageName = "eos"
        case "DASH Dash":
            imageName = "dash"
        case "BNB Binance Coin":
            imageName = "binance-coin"
        case "BSV Bitcoin SV":
            imageName = "bitcoin-sv"
        case "NEO Neo":
            imageName = "neo"
        case "XTZ Tezos":
            imageName = "tezos"
        case "LINK ChainLink":
            imageName = "chainlink"
        default:
            imageName = "bitcoin"
        }
        return UIImage(named: imageName)
    }
}
