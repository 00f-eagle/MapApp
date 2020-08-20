//
//  MapViewController.swift
//  MapApp
//
//  Created by Kirill Selivanov on 20.08.2020.
//  Copyright © 2020 Kirill+Gleb. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
    
    // MARK: - Constants
    
    // Пока константа, надо будет сделать LocationManager
    private enum Locals {
        static let loc = CLLocationCoordinate2DMake(55.642654, 37.477162)
        static let zoom: Double = 15
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
    }
    
    // MARK: - Configurations
    
    private func configureMap() {
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.setCenter(Locals.loc, zoomLevel: Locals.zoom, animated: false)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let ann = MGLPointAnnotation()
        ann.coordinate = Locals.loc
        ann.title = "Вы здесь"
        mapView.addAnnotation(ann)
        
        view.addSubview(mapView)
    }

}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
