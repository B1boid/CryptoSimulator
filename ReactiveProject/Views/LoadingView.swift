//
//  LoadingView.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 24.04.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//


import UIKit
import Lottie

class LoadingView: UIView {
    
    private let loadingAnimation = AnimationView(name: "preload")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.addSubview(loadingAnimation)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLoadingAnimation() {
        loadingAnimation.loopMode = .loop
        loadingAnimation.animationSpeed = 1.0
        loadingAnimation.play()
    }
    
    func startLoadingAnimation() {
        loadingAnimation.play()
    }
    
    func stopLoadingAnimation() {
        loadingAnimation.stop()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingAnimation.frame = bounds
        setupLoadingAnimation()
    }
}
