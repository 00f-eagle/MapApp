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
    
    private enum Constants {
        static let center = CLLocationCoordinate2D(latitude: 55.642718, longitude: 37.476868)
        static let locFriend = CLLocationCoordinate2D(latitude: 55.641772, longitude: 37.479769)
        static let zoom: Double = 15
        static let sizeButton: CGFloat = 40
    }
    
    // MARK: - Properties
    
    var presenter: MapViewControllerOutput!
    
    private let mapView = MGLMapView()
    private let createUserButton = UIButton()
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var timer: Timer?
    var allCoordinates: [CLLocationCoordinate2D]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureCreateUserButton()
    }
    
    // MARK: - Configurations
    
    private func configureMap() {
        
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(Constants.center, zoomLevel: Constants.zoom, animated: false)
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        allCoordinates = Coordinates.myCoordinates
    }
    
    private func configureCreateUserButton() {
        
        createUserButton.translatesAutoresizingMaskIntoConstraints = false
        createUserButton.setTitle("C", for: .normal)
        createUserButton.setTitleColor(.blue, for: .normal)
        createUserButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        createUserButton.layer.borderWidth = 1
        createUserButton.layer.cornerRadius = Constants.sizeButton/2
        createUserButton.isHidden = true
        mapView.addSubview(createUserButton)
        
        NSLayoutConstraint.activate([
            createUserButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: view.bounds.height/2 - Constants.sizeButton/2),
            createUserButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -1),
            createUserButton.widthAnchor.constraint(equalToConstant: Constants.sizeButton),
            createUserButton.heightAnchor.constraint(equalToConstant: Constants.sizeButton),
        ])
    }
    
    private func createAnnotation(title: String, coordinate: CLLocationCoordinate2D) -> MGLPointAnnotation {
        let ann = MGLPointAnnotation()
        ann.coordinate = coordinate
        ann.title = title
        return ann
    }
    
    // MARK: - Active
    
    @objc private func createUser() {
        let ann = createAnnotation(title: "Друг здесь", coordinate: Constants.locFriend)
        mapView.addAnnotation(ann)
    }
    
}


// MARK: - MGLMapViewDelegate
extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        switch annotation {
        case is MGLPointAnnotation:
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
            
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) {
                return annotationView
            } else {
                let annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
                annotationView.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
                return annotationView
            }
            
        case is MGLUserLocation:
            return CustomUserLocationAnnotationView()
        default:
            return nil
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        createUserButton.isHidden = false
        //addPolyline(to: mapView.style!)
        //animatePolyline()
    }
    
    func addPolyline(to style: MGLStyle) {
        // Add an empty MGLShapeSource, we’ll keep a reference to this and add points to this later.
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source
        
        let polyline = MGLPolylineFeature(coordinates: allCoordinates, count: UInt(allCoordinates.count))
        polylineSource?.shape = polyline
        //         Add a layer to style our polyline.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineColor = NSExpression(forConstantValue: UIColor.black)
        layer.lineWidth = NSExpression(forConstantValue: 5)
        //        style.addLayer(layer)
    }
    
    func animatePolyline() {
        currentIndex = 1
        
        // Start a timer that will simulate adding points to our polyline. This could also represent coordinates being added to our polyline from another source, such as a CLLocationManagerDelegate.
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        if currentIndex > allCoordinates.count {
            timer?.invalidate()
            timer = nil
            return
        }
        
        // Create a subarray of locations up to the current index.
        let coordinates = Array(allCoordinates[0..<currentIndex])
        
        // Update our MGLShapeSource with the current locations.
        updatePolylineWithCoordinates(coordinates: coordinates)
        
        currentIndex += 1
    }
    
    func updatePolylineWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        
        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSource?.shape = polyline
    }
}


// MARK: - MapViewControllerInput
extension MapViewController: MapViewControllerInput {
    
}
