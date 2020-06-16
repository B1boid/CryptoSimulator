//
//  NewsView.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 19.05.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//

import UIKit
import Lottie

class NewsView: UIView {
    
    private var resultAnimation:AnimationView?
    
    var infoLabel: UILabel = {
           let label = UILabel()
           label.textColor = .white
            label.numberOfLines = 2
           label.textAlignment = .center
           label.adjustsFontSizeToFitWidth = true
           return label
    }()
    
    var diff:Float?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       addSubview(infoLabel)
        
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupMainView()
        let h = frame.size.height
        let w = frame.size.width
        infoLabel.font = UIFont(name: "Futura", size: h/10)
        guard let diff = diff else { return }
        infoLabel.text = diff > 0.0 ? "Your full balance increased by \(diff)$":
        "Your full balance decreased by \(-diff)$"
        if diff < 0.0{
            resultAnimation = AnimationView(name: "down")
        }else{
             resultAnimation = AnimationView(name: "up")
        }
         guard let resultAnimation = resultAnimation else { return }
         setupLoadingAnimation()
          resultAnimation.frame = bounds
        addSubview(resultAnimation)
        
        infoLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft:10 , paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        resultAnimation.anchor(top: infoLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft:10 , paddingBottom: 0, paddingRight: 10, width: w/2, height: w/2, enableInsets: false)
        
    }
    
    private func setupMainView() {
         self.backgroundColor = .purple
         self.layer.cornerRadius = 10
         self.layer.masksToBounds = true
         self.layer.borderColor = UIColor.black.cgColor
         self.layer.borderWidth = 3
     }
    
    private func setupLoadingAnimation() {
           guard let resultAnimation = resultAnimation else { return }
        resultAnimation.loopMode = .loop
        resultAnimation.animationSpeed = 1.0
        resultAnimation.play()
    }

    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
}

