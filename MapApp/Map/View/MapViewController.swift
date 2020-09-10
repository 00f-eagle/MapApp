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
    private var allCoordinates: [CLLocationCoordinate2D]!
    
    // Line
    private var lineShape: MGLShapeSource!
    private var lineWay: MGLLineStyleLayer!
    
    // Animate
    private var animateLineWay: MGLLineStyleLayer!
    private var animateShape: MGLShapeSource!
    private var timer: Timer!
    private var currentIndex = 1
    private var count = 1
    
    
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
        mapView.isHidden = true
        view.addSubview(mapView)
        
        allCoordinates = Coordinates.friendCoordinates
    }
    
    private func configureCreateUserButton() {
        
        createUserButton.translatesAutoresizingMaskIntoConstraints = false
        createUserButton.setTitle("C", for: .normal)
        createUserButton.setTitleColor(.blue, for: .normal)
        createUserButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        createUserButton.layer.borderWidth = 1
        createUserButton.layer.cornerRadius = Constants.sizeButton/2
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
        addPolyline()
    }
    
    private func addPolyline() {
        let polyline = MGLPolylineFeature(coordinates: allCoordinates, count: UInt(allCoordinates.count))
        lineShape.shape = polyline
        currentIndex = 1
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(animatePolyline), userInfo: nil, repeats: true)
    }
    
    @objc private func animatePolyline() {
        if currentIndex > allCoordinates.count {
            timer?.invalidate()
            timer = nil
            if count < 3 {
                count += 1
                addPolyline()
            }
            return
        }
        
        let coordinates = Array(allCoordinates[0..<currentIndex])
        
        let polyline = MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
        
        animateShape.shape = polyline
        
        currentIndex += 1
    }
    
}


// MARK: - MGLMapViewDelegate
extension MapViewController: MGLMapViewDelegate {
    
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
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        lineShape = MGLShapeSource(identifier: "line", shape: nil, options: nil)
        style.addSource(lineShape)
        animateShape = MGLShapeSource(identifier: "animateLine", shape: nil, options: nil)
        style.addSource(animateShape)
        
        lineWay = MGLLineStyleLayer(identifier: "line", source: lineShape)
        lineWay.lineColor = NSExpression(forConstantValue: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3))
        lineWay.lineWidth = NSExpression(forConstantValue: 5)
        lineWay.lineCap = NSExpression(forConstantValue: "round")
        animateLineWay = MGLLineStyleLayer(identifier: "animateLine", source: animateShape)
        animateLineWay.lineColor = NSExpression(forConstantValue: UIColor.black)
        animateLineWay.lineWidth = NSExpression(forConstantValue: 5)
        animateLineWay.lineCap = NSExpression(forConstantValue: "round")
        
        style.addLayer(lineWay)
        style.insertLayer(animateLineWay, below: lineWay)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.isHidden = false
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
}


// MARK: - MapViewControllerInput
extension MapViewController: MapViewControllerInput {
    
}
