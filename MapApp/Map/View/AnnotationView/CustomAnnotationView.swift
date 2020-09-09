//
//  CustomAnnotationView.swift
//  MapApp
//
//  Created by Kirill Selivanov on 07.09.2020.
//  Copyright © 2020 Kirill+Gleb. All rights reserved.
//

import UIKit
import Mapbox

final class CustomAnnotationView: MGLAnnotationView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        layer.backgroundColor = UIColor.green.cgColor
    }
}
