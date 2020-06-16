//
//  ViewController.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 11.04.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    private var viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    fileprivate var cells = [CellCrypto]()
    private var w: CGFloat?
    private var h: CGFloat?
    
    var balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var cryptoBalanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var fullBalanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var closeNewsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(closeNewsView), for: .touchUpInside)
        return button
    }()
    
    var closeInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(closeInfoView), for: .touchUpInside)
        return button
    }()
    
    var closeSureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(closeSureView), for: .touchUpInside)
        return button
    }()
    
    
    let buttonUpdate:UIButton =  {
        let button = UIButton(type: .roundedRect)
        button.setTitle(" Update costs ", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.addTarget(self, action: #selector(updateCosts), for: .touchUpInside )
        return button
    }()
    
    let buttonReset:UIButton =  {
        let button = UIButton(type: .roundedRect)
        button.setTitle(" Reset account ", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.addTarget(self, action: #selector(openQuestionView), for: .touchUpInside )
        return button
    }()
    
    var loadingAnimationView:LoadingView?
    var infoView:InfoView?
    var newsView:NewsView?
    var sureView:SureView?
    var safeArea: UILayoutGuide!
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        w = view.bounds.width
        h = view.bounds.height
        viewModel.getRealmData()
        viewModel.loadData()
        addAnimationView()
        let subviews = [
            balanceLabel,fullBalanceLabel,cryptoBalanceLabel,buttonUpdate,buttonReset
        ]
        subviews.forEach { view.addSubview($0) }
        setupUI()
        
        
        viewModel.isLoaded.subscribe(onNext:{ isLoaded,isFirst in
            guard isLoaded else { return }
            print("Data is loaded")
            self.cells = []
            for curCrypto in self.viewModel.cryptoArray{
                self.cells.append(CellCrypto(name: curCrypto.name, cost: curCrypto.cost, amount:curCrypto.num))
            }
            self.tableView.reloadData()
            if let loadingAnimationView = self.loadingAnimationView{
                loadingAnimationView.removeFromSuperview()
            }
            if isFirst{
                self.openNews(diff: self.viewModel.compareFullBalances())
            }
            
        }).disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.animateCellTouch(indexPath: indexPath)
            self.openInfo(index: indexPath[1])
        }).disposed(by: disposeBag)
        
        viewModel.myBalance.subscribe(onNext:{ balance in
            do{
                print("Balance changed to \(balance)")
                self.balanceLabel.text = "Balance: \(String(format: "%.3f", balance))$"
                self.fullBalanceLabel.text = "Full Balance: \(String(format: "%.3f",try self.viewModel.cryptoBalance.value()+balance))$"
            }catch let error {
                print("Balance error:\(error.localizedDescription)")
            }
        }).disposed(by: disposeBag)
        
        viewModel.cryptoBalance.subscribe(onNext:{ balance in
            do{
                print("Crypto balance changed to \(balance)")
                self.cryptoBalanceLabel.text = "Crypto Cost: \(String(format: "%.3f", balance))$"
                self.fullBalanceLabel.text = "Full Balance: \(String(format: "%.3f",try self.viewModel.myBalance.value()+balance))$"
            }catch let error {
                print("Balance error:\(error.localizedDescription)")
            }
        }).disposed(by: disposeBag)
        
        
        
        
    }
    
    
    
    func setupUI() {
        guard let h = h else { return }
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .purple
        balanceLabel.anchor(top: safeArea.topAnchor, left: view.leftAnchor, bottom:  nil, right:  nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        balanceLabel.font = UIFont(name: "Futura", size: h/50)
        
        cryptoBalanceLabel.anchor(top: balanceLabel.bottomAnchor, left: view.leftAnchor, bottom:  nil, right:  nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        cryptoBalanceLabel.font = UIFont(name: "Futura", size: h/50)
        
        fullBalanceLabel.anchor(top: cryptoBalanceLabel.bottomAnchor, left: view.leftAnchor, bottom:  nil, right:  nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        fullBalanceLabel.font = UIFont(name: "Futura", size: h/50)
        
        buttonReset.anchor(top: safeArea.topAnchor, left: nil, bottom:  nil, right:  view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        buttonReset.titleLabel?.font = UIFont(name: "Futura", size: h/50)
        
        buttonUpdate.anchor(top: buttonReset.bottomAnchor, left: nil, bottom:  nil, right:  view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        buttonUpdate.titleLabel?.font = UIFont(name: "Futura", size: h/50)
        setupTableView()
    }
    
    
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 10
        tableView.bounces = false
        tableView.anchor(top: fullBalanceLabel.bottomAnchor, left: view.leftAnchor, bottom:  safeArea.bottomAnchor, right:  view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0, enableInsets: true)
        tableView.register(CryptoViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CryptoViewCell
        myCell.data = self.cells[indexPath.row]
        return myCell
    }
    
    
    func addAnimationView(){
        loadingAnimationView = LoadingView(frame: view.bounds)
        loadingAnimationView?.layer.zPosition = 1
        if let loadingAnimationView = loadingAnimationView {
            view.addSubview(loadingAnimationView)
        }
    }
    
    func animateCellTouch(indexPath:IndexPath){
        UIView.animate(withDuration: 0.1,
                       animations: {if let cell = self.tableView.cellForRow(at: indexPath) as? CryptoViewCell {
                        cell.transform = .init(scaleX: 0.8, y: 0.8)
                        }},completion: { (success) in
                            UIView.animate(withDuration: 0.1){
                                if let cell = self.tableView.cellForRow(at: indexPath) as? CryptoViewCell {
                                    cell.transform = .init(scaleX: 1, y: 1)
                                    
                                }
                            }})
    }
    
    func animateViewAppearing(appearingView: UIView?, mainView: UIView,button:UIButton?) {
        if let appearingView = appearingView {
            appearingView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            if let button = button{
                mainView.insertSubview(button, aboveSubview: mainView)
                mainView.insertSubview(appearingView, aboveSubview: button)
            }else {
                
                mainView.insertSubview(appearingView, aboveSubview: mainView)
            }
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: { appearingView.transform = .identity },
                           completion: nil)
        }
    }
    
    
    func openInfo(index:Int){
        guard let h = h, let w = w else { return }
        infoView = InfoView(frame: CGRect(x: w/2-3*w/8, y: h/4, width: 3*w/4, height: h/2))
        infoView?.id = index
        infoView?.viewModel = viewModel
        infoView?.vc = self
        closeInfoButton.frame = self.view.bounds
        self.animateViewAppearing(appearingView: infoView, mainView: self.view, button: closeInfoButton)
    }
    
    func openNews(diff:Float){
        guard diff != 0 else { return }
        guard let h = h, let w = w else { return }
        newsView = NewsView(frame: CGRect(x: w/2-3*w/8, y: h/3, width: 3*w/4, height: 5*h/12))
        newsView?.diff = diff
        closeNewsButton.frame = self.view.bounds
        self.animateViewAppearing(appearingView: newsView, mainView: self.view, button: closeNewsButton)
        
    }
    
    
    @objc func closeInfoView(){
        guard let id = infoView?.id else {return}
        cells[id].amount = viewModel.cryptoArray[id].num
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.2,
                       animations: { self.infoView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) },
                       completion: { (success) in
                        self.infoView?.removeFromSuperview()
                        self.closeInfoButton.removeFromSuperview()
        })
    }
    
    @objc func closeNewsView(){
        UIView.animate(withDuration: 0.2,
                       animations: { self.infoView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) },
                       completion: { (success) in
                        self.newsView?.removeFromSuperview()
                        self.closeNewsButton.removeFromSuperview()
        })
    }
    
    @objc func closeSureView(){
           UIView.animate(withDuration: 0.2,
                          animations: { self.sureView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) },
                          completion: { (success) in
                           self.sureView?.removeFromSuperview()
                           self.closeSureButton.removeFromSuperview()
           })
       }
    
    @objc func openQuestionView(){
        guard let h = h, let w = w else { return }
        sureView = SureView(frame: CGRect(x: w/6, y: h/3, width: 2*w/3, height: h/6))
        sureView?.vc = self
        closeSureButton.frame = self.view.bounds
        self.animateViewAppearing(appearingView: sureView, mainView: self.view, button: closeSureButton)
        
    }
    
    @objc func updateCosts(){
        addAnimationView()
        viewModel.loadData()
    }
    
    func resetAccount(){
        closeSureView()
         addAnimationView()
        viewModel.resetAccount()
    }
    
    
    
}

