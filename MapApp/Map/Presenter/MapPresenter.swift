//
//  MapPresenter.swift
//  MapApp
//
//  Created by Kirill Selivanov on 07.09.2020.
//  Copyright © 2020 Kirill+Gleb. All rights reserved.
//

import UIKit

final class MapPresenter {
    
    // MARK: - Properties
    
    weak var view: MapViewControllerInput!
    var interactor: MapInteractorInput!
    var router: MapRouterInput!

}


// MARK: - MapViewControllerOutput
extension MapPresenter: MapViewControllerOutput {
    
}


// MARK: - MapInteractorOutput
extension MapPresenter: MapInteractorOutput {
    
}
