//
//  MapAssembly.swift
//  MapApp
//
//  Created by Kirill Selivanov on 07.09.2020.
//  Copyright © 2020 Kirill+Gleb. All rights reserved.
//

import UIKit

final class MapAssembly {
    
    static func create() -> UIViewController {
        let view = MapViewController()
        let presenter = MapPresenter()
        
        view.presenter = presenter
        presenter.view = view
        
        let interactor = MapInteractor()
        
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        let router = MapRouter()
        
        presenter.router = router
        router.view = view
        
        return view
    }

}
