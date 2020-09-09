//
//  CustomUserLocationAnnotationView.swift
//  MapApp
//
//  Created by Kirill Selivanov on 08.09.2020.
//  Copyright © 2020 Kirill+Gleb. All rights reserved.
//

import UIKit
import Mapbox

final class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let size: CGFloat = 20
    }
    
    // MARK: - Properties
    
    private var dot: CALayer!
    
    // MARK: - Update
    
    override func update() {
        setupLayers()
    }
    
    // MARK: - Private func
    
    private func setupLayers() {
        if dot == nil {
            dot = CALayer()
            dot.bounds = CGRect(x: 0, y: 0, width: Constants.size, height: Constants.size)
            dot.cornerRadius = Constants.size / 2
            dot.backgroundColor = UIColor.red.cgColor
            dot.borderWidth = 2
            dot.borderColor = UIColor.white.cgColor
            layer.addSublayer(dot)
        }
    }
}
