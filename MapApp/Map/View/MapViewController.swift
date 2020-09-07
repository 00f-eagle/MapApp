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

    private enum Locals {
        static let loc = CLLocationCoordinate2D(latitude: 55.642654, longitude: 37.477162)
        static let loc2 = CLLocationCoordinate2D(latitude: 55.606319, longitude: 37.735656)
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
        let ann1 = createAnnotation(title: "Вы здесь", coordinate: Locals.loc)
        let ann2 = createAnnotation(title: "Друг здесь", coordinate: Locals.loc2)
        mapView.addAnnotation(ann1)
        mapView.addAnnotation(ann2)
    }
    
    private func createAnnotation(title: String, coordinate: CLLocationCoordinate2D) -> MGLPointAnnotation {
        let ann = MGLPointAnnotation()
        ann.coordinate = coordinate
        ann.title = title
        return ann
    }
}


// MARK: - MGLMapViewDelegate
extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let reuseIdentifier = "\(annotation.coordinate.longitude)"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)

            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        
        return annotationView
    }
}


// MARK: - MapViewControllerInput
extension MapViewController: MapViewControllerInput {
    
}
