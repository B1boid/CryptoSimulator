//
//  ViewModel.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 11.04.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftSoup
import RealmSwift

class ViewModel{
    
    var myBalance = BehaviorSubject<Float>(value: 0)
    var cryptoBalance = BehaviorSubject<Float>(value: 0)
    var isLoaded = BehaviorSubject<(Bool,Bool)>(value: (false,true))
    var allCrypts = BehaviorSubject<[Crypto]>(value: [])
    var amountBuy = BehaviorSubject<Float>(value: 0)
    
    var isLoadedPageSource = false
    var isLoadedBalance = false
    var isFirst = true
    var urlParse: String?
    var names = [String]()
    var cryptoArray = [Crypto]()
    
    func getCryptoBalance() -> Float{
        return cryptoArray
            .filter{$0.num > 0}
            .reduce(0){(sum,element) in sum+element.cost*element.num}
    }
    
    func loadData(){
        isLoadedPageSource = false
        let res = DatabaseManager.shared.readNames()
        urlParse = res.0
        names = res.1
        if let urlParse = urlParse {
            getPageSource(from: urlParse)
        }
    }
    
    func getPageSource(from url:String) {
        print("Start crawling")
        guard let curURL = URL(string: url) else { return }
        cryptoArray = DatabaseManager.shared.fillArray()
        DispatchQueue.global(qos: .utility).async {
            do {
                let htmlString = try String(contentsOf: curURL, encoding: .utf8)
                let doc = try SwiftSoup.parse(htmlString)
                let elements = try doc.select("td")
                var count = 0
                for i in stride(from: 2, to: elements.count, by: 1) {
                    guard count < self.cryptoArray.count else { break }
                    let curName = try elements[i-1].text()
                    guard let curInd = self.names.firstIndex(of: curName) else { continue }
                    guard let curCost = Float((try elements[i].text()).components(separatedBy: " ")[1].replacingOccurrences(of: ",", with: "")) else { break }
                    self.cryptoArray[curInd].cost = curCost
                    count+=1
                }
                self.isLoadedPageSource = true
                self.allCrypts.onNext(self.cryptoArray)
                DispatchQueue.main.async {
                    self.cryptoBalance.onNext(self.getCryptoBalance())
                    self.isLoaded.onNext((self.isLoadedPageSource && self.isLoadedBalance,self.isFirst))
                }
                
            } catch let error{
                print("Reading html error:\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.loadData()
                }
                return
            }
        }
    }
    
    func getProfileData(){
        myBalance.onNext(DatabaseManager.shared.getBalance())
        isLoadedBalance = true
        isLoaded.onNext((isLoadedPageSource && isLoadedBalance,isFirst))
    }
    
    
    func getRealmData(){
        DatabaseManager.shared.createRealmData()
        getProfileData()
    }
    
    func transactionWithItem(index:Int?,isBuy:Bool){
        guard let index = index else {return}
        var curCost = cryptoArray[index].cost
        do{
            var amount = Float(try amountBuy.value())
            amount = isBuy ? amount: -amount
            curCost *= amount
            let res = DatabaseManager.shared.updateAfterPurchase(index: index, curCost: curCost,amount: amount,cryptoBalance: getCryptoBalance())
            if res.0 || !isBuy {
                cryptoArray[index].num += amount
                myBalance.onNext(res.1)
                cryptoBalance.onNext(getCryptoBalance())
            }
        }catch let error{
            print("Buying error:\(error.localizedDescription)")
            return
        }
    }
    
    
    func getMaxAvailable(index:Int) -> Float{
        let curCost = cryptoArray[index].cost
        return DatabaseManager.shared.getBalance() / curCost
    }
    
    func compareFullBalances() -> Float{
//        let lastFullBalance = DatabaseManager.shared.getLastFullBalance()
//        let curFullBalance = DatabaseManager.shared.getBalance()+getCryptoBalance()
//        guard curFullBalance != lastFullBalance else {return 0.0}
//        DatabaseManager.shared.updateLastFullBalance(curFullBalance: curFullBalance)
    //    return curFullBalance-lastFullBalance
        return 10.21
    }
    
    func resetAccount(){
        isFirst = false
        isLoadedPageSource = false
        DatabaseManager.shared.resetAccount()
        getRealmData()
        loadData()
    }
    
    
    
    
}
