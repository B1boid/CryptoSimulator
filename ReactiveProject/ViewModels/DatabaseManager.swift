//
//  DBManager.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 26.04.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    lazy var realm:Realm = { return try! Realm()}()
    lazy var dataWallet: Results<CryptoItem> = { self.realm.objects(CryptoItem.self) }()
    lazy var myProfile: MyProfile? = { self.realm.object(ofType: MyProfile.self, forPrimaryKey: MyProfile.profileID)}()
    var names = [String]()
    
    private init() {
        //clearDB()
        names = readNames().1
    }
    
    func createRealmData(){
        guard dataWallet.count == 0 else { return }
        do {
            try realm.write{
                let newUser = MyProfile()
                realm.add(newUser, update: .modified)
                for name in names {
                    let tmpCrypt = CryptoItem()
                    tmpCrypt.name = name
                    realm.add(tmpCrypt)
                }
            }
        } catch let error {
            print("Creating data error:\(error.localizedDescription)")
        }
    }
    
    
    func updateAfterPurchase(index:Int,curCost:Float,amount:Float,cryptoBalance:Float) -> (Bool,Float) {
        var enoughMoney = false
        if let userInfo = myProfile {
            print(userInfo.balance)
            do {
                if (curCost <= userInfo.balance){
                    try realm.write{
                        enoughMoney = true
                        dataWallet[index].num+=amount
                        myProfile?.lastFullBalance = (myProfile?.balance ?? 0.0) + cryptoBalance
                        myProfile?.balance -= curCost
                    }
                }
            } catch let error {
                print("Buying error:\(error.localizedDescription)")
            }
        }
        for item in dataWallet{
            print(item.name,item.num)
        }
        return (enoughMoney,myProfile?.balance ?? 0)
    }
    
    func readNames() -> (String?,[String]) {
        var parseUrl:String?
        if let path = Bundle.main.path(forResource: "AvailableCryptoList", ofType: .none){
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                names = data.split{ $0.isNewline }.map{ String($0) }
                parseUrl = names[0]
                names.remove(at: 0)
            }catch let error {
                print("Reading file error:\(error.localizedDescription)")
            }
        }
        return (parseUrl,names)
    }
    
    func getBalance() -> Float {
        return myProfile?.balance ?? 0
    }
    
    func getLastFullBalance() -> Float {
        return myProfile?.lastFullBalance ?? 0
    }
    
    func fillArray() -> [Crypto]{
        var tmpArr = [Crypto]()
        for item in realm.objects(CryptoItem.self) {
            tmpArr.append(Crypto(name: item.name, cost: 0, num: item.num))
        }
        return tmpArr
    }
    
    func updateLastFullBalance(curFullBalance:Float){
        do {
            try realm.write{
                myProfile?.lastFullBalance = curFullBalance
            }
        } catch let error {
            print("Full balance updating error:\(error.localizedDescription)")
        }
        
    }
    
    
    func resetAccount(){
        do{
            try realm.write {
                myProfile?.lastFullBalance = 5000
                myProfile?.balance = 5000
                realm.delete(dataWallet)
            }
        }catch let error {
            print("Deleting error:\(error.localizedDescription)")
        }
    }
    
    
    func clearDB(){
        do{
            try realm.write {
                realm.deleteAll()
            }
        }catch let error {
            print("Deleting error:\(error.localizedDescription)")
        }
    }
    
    
    
    
    
}

