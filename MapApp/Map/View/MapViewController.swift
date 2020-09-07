//
//  MapViewController.swift
//  MapApp
//
//  Created by Kirill Selivanov on 20.08.2020.
//  Copyright © 2020 Kirill+Gleb. All rights reserved.
//

import UIKit
import Mapbox

final class MapViewController: UIViewController {
    
    // MARK: - Constants
    
    // Пока константа, надо будет сделать LocationManager
    private enum Locals {
        static let loc = CLLocationCoordinate2DMake(55.642654, 37.477162)
        static let zoom: Double = 15
    }
    
    // MARK: - Properties
    
    var presenter: MapViewControllerOutput!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
    }
    
    // MARK: - Configurations
    
    private func configureMap() {
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.centerCoordinate = Locals.loc
        mapView.zoomLevel = Locals.zoom
        mapView.delegate = self
        view.addSubview(mapView)

        let ann = MGLPointAnnotation()
        ann.coordinate = Locals.loc
        ann.title = "Вы здесь"
        mapView.addAnnotation(ann)
    }
    
}


// MARK: - MGLMapViewDelegate
extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
    // This example is only concerned with point annotations.
    guard annotation is MGLPointAnnotation else {
    return nil
    }
     
    // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
    let reuseIdentifier = "\(annotation.coordinate.longitude)"
     
    // For better performance, always try to reuse existing annotations.
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
     
    // If there’s no reusable annotation view available, initialize a new one.
    if annotationView == nil {
    annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
    annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
     
    // Set the annotation view’s background color to a value determined by its longitude.
    let hue = CGFloat(annotation.coordinate.longitude) / 100
    annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
    }
     
    return annotationView
    }
    
}


// MARK: - MapViewControllerInput
extension MapViewController: MapViewControllerInput {
    
}
