//
//  SureView.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 22.05.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//

import UIKit

class SureView: UIView {
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Are you sure?"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let buttonYes:UIButton =  {
        let button = UIButton(type: .roundedRect)
        button.setTitle(" Yes ", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.addTarget(self, action: #selector(resetAcc), for: .touchUpInside )
        return button
    }()
    
    let buttonNo:UIButton =  {
        let button = UIButton(type: .roundedRect)
        button.setTitle(" No ", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside )
        return button
    }()
    
    var vc:ViewController?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainView()
        self.addSubview(questionLabel)
        self.addSubview(buttonYes)
        self.addSubview(buttonNo)
        
    }
    
    private func setupMainView() {
        self.backgroundColor = .purple
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let font_h = frame.height/5
        let button_w = frame.width/3
        questionLabel.font = UIFont(name: "Futura", size: font_h)
        buttonYes.titleLabel?.font = UIFont(name: "Futura", size: font_h)
        buttonNo.titleLabel?.font = UIFont(name: "Futura", size: font_h)
        questionLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft:10 , paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        buttonYes.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft:20 , paddingBottom: 10, paddingRight: 0, width: button_w, height: 0, enableInsets: false)
        buttonNo.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft:0 , paddingBottom: 10, paddingRight: 20, width: button_w, height: 0, enableInsets: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self {
            closeView()
        }
        
    }
    
    @objc func resetAcc(){
        vc?.resetAccount()
    }
    
    @objc func closeView(){
        vc?.closeSureView()
    }
}

