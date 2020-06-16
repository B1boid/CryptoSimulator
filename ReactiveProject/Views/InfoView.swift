//
//  InfoView.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 15.05.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Foundation

class InfoView: UIView, UITextFieldDelegate {
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Amount:"
        return label
    }()
    
    var costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Cost:"
        return label
    }()
    
    var amountTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 8
        textField.backgroundColor  = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        textField.autocorrectionType = .no
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    var costTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 8
        textField.backgroundColor  = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        textField.autocorrectionType = .no
        textField.adjustsFontSizeToFitWidth = true
        return textField
    }()
    
    var slider: CustomSlider = {
        let slider = CustomSlider()
        slider.minimumValue = 0.0
        slider.value = 0.0
        slider.minimumTrackTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return slider
    }()
    
    
    let buttonBuy:UIButton =  {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Buy", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.addTarget(self, action: #selector(doAction), for: .touchUpInside )
        return button
    }()
    
    let buttonChangeMode:UIButton =  {
        let button = UIButton(type: .roundedRect)
        button.setTitle("To selling screen", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.layer.borderWidth = 3
        button.tintColor = .white
        button.addTarget(self, action: #selector(changeMode), for: .touchUpInside )
        return button
    }()
    
    
    
    var id:Int?
    var vc:ViewController?
    var sellAvailable = false
    var isBuyViewNow = true
    var curEl:Crypto?
    var maxValue:Float?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
        let subviews = [
            nameLabel,slider,buttonBuy,amountTextField,costTextField,buttonChangeMode,amountLabel,costLabel
        ]
        subviews.forEach { self.addSubview($0) }
        
        amountTextField.delegate = self
        costTextField.delegate = self
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = frame.size.width
        let h = frame.size.height
        nameLabel.font = UIFont(name: "Futura", size: h/10)
        amountLabel.font = UIFont(name: "DIN Alternate", size: h/20)
        costLabel.font = UIFont(name: "DIN Alternate", size: h/20)
        buttonBuy.titleLabel?.font =  UIFont(name: "DIN Alternate", size:  w/16)
        buttonChangeMode.titleLabel?.font =  UIFont(name: "DIN Alternate", size:  w/16)
        
        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft:10 , paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        slider.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft:10 , paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        amountLabel.anchor(top: slider.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft:0 , paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        amountTextField.anchor(top: amountLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft:w/6 , paddingBottom: 0, paddingRight:w/6, width: 0, height: 0, enableInsets: false)
        costLabel.anchor(top: amountTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft:0 , paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        costTextField.anchor(top: costLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft:w/6 , paddingBottom: 0, paddingRight:w/6, width: 0, height: 0, enableInsets: false)
        
        buttonBuy.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft:w/12 , paddingBottom: 10, paddingRight:0, width: w/3, height: h/8, enableInsets: false)

        buttonChangeMode.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft:0 , paddingBottom: 10, paddingRight:w/12, width: w/3, height: h/8, enableInsets: false)
     
        
        guard let id = id else {return}
        curEl = viewModel.cryptoArray[id]
        guard let curEl = curEl else {return}
        let curCost = curEl.cost
        maxValue = viewModel.getMaxAvailable(index: id)
        guard let maxValue = maxValue else {return}
        nameLabel.text = String(curEl.name)
        slider.maximumValue = maxValue
        buttonChangeMode.isEnabled = curEl.num > 0
        
        slider.rx.value.map{$0}.bind(to: viewModel.amountBuy).disposed(by: disposeBag)
        
        amountTextField.rx.controlEvent([.editingDidEnd])
            .asObservable().subscribe(onNext:{
                self.bindToAmount(textField: self.amountTextField, maxValue: maxValue, isCost: false, curCost: curCost)
            }).disposed(by: disposeBag)
        
        costTextField.rx.controlEvent([.editingDidEnd])
            .asObservable().subscribe(onNext:{
                self.bindToAmount(textField: self.costTextField, maxValue: maxValue, isCost: true, curCost: curCost)
            }).disposed(by: disposeBag)
        
        viewModel.amountBuy.subscribe(onNext:{ amount in
            self.amountTextField.text =  String(format: "%.6f", amount)
            self.costTextField.text =  String(format: "%.6f", curCost*amount)
            self.slider.value = amount
            self.buttonBuy.isEnabled = amount > 0
        }).disposed(by: disposeBag)
        
        
    }
    
    
    func bindToAmount(textField:UITextField,maxValue:Float,isCost:Bool,curCost:Float){
        let amountStr = textField.text
        guard let amountStrUn = amountStr else{
            viewModel.amountBuy.onNext(0.0)
            return
        }
        guard amountStrUn != "" else{
            viewModel.amountBuy.onNext(0.0)
            return
        }
        if var value = amountStrUn.float{
            value = isCost ? value/curCost : value
            if maxValue < value{
                self.viewModel.amountBuy.onNext(maxValue)
            }else{
                self.viewModel.amountBuy.onNext(value)
            }
        }else{
            self.viewModel.amountBuy.onNext(0.0)
        }
    }
    
    private func setupMainView() {
        self.backgroundColor = .purple
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
    }
    
    @objc func doAction(){
        self.viewModel.transactionWithItem(index: id, isBuy: isBuyViewNow)
        vc?.closeInfoView()
    }
    
    @objc func changeMode(){
        if isBuyViewNow {
              UIView.transition(with: self, duration: 1.0, options: .transitionFlipFromRight, animations: nil, completion: nil)
             buttonBuy.setTitle("Sell", for: .normal)
              buttonChangeMode.setTitle("To buying screen", for: .normal)
            guard let curEl = curEl else {return}
            slider.maximumValue = curEl.num
        }else{
              UIView.transition(with: self, duration: 1.0, options: .transitionFlipFromLeft, animations: nil, completion: nil)
             buttonBuy.setTitle("Buy", for: .normal)
            buttonChangeMode.setTitle("To selling screen", for: .normal)
            guard let maxValue = maxValue else {return}
            slider.maximumValue = maxValue
        }
        viewModel.amountBuy.onNext(0.0)
        isBuyViewNow = !isBuyViewNow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for txt in self.subviews {
            if txt.isKind(of: UITextField.self) && txt.isFirstResponder {
                txt.resignFirstResponder()
            }
        }
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          switch textField {
          case amountTextField:
              amountTextField.resignFirstResponder()
          default:
              costTextField.resignFirstResponder()
          }
          return true
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StringProtocol {
    var float: Float? { Float(self) }
}

@IBDesignable
class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 10))
    }
    
}



