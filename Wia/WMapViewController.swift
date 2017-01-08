//
//  WMapViewController.swift
//  Wia
//
//  Created by Abbin Varghese on 07/01/17.
//  Copyright © 2017 Abbin Varghese. All rights reserved.
//

import UIKit
import GoogleMaps

class WMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var closeContainerView: UIView!
    @IBOutlet weak var selectContainerView: UIView!
    
    let locationManager = CLLocationManager()
    var didFinishFirstLocationUpdate = false
    var currentLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        closeContainerView.layer.shadowOpacity = 1.0
        closeContainerView.layer.shadowOffset = CGSize.zero
        closeContainerView.layer.shadowRadius = 1.0
        closeContainerView.layer.cornerRadius = 22
        
        selectContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        selectContainerView.layer.shadowOpacity = 1.0
        selectContainerView.layer.shadowOffset = CGSize.zero
        selectContainerView.layer.shadowRadius = 1.0
        selectContainerView.layer.cornerRadius = 25
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .notDetermined {
            locationManager.delegate = self;
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - @IBAction
    
    @IBAction func cancelMap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneWithMap(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            _ = self.mapView.camera.target
        })
    }
    
    @IBAction func goToCurrentLocation(_ sender: Any) {
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude), zoom: 15.0)
        mapView.animate(to: camera)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if didFinishFirstLocationUpdate == false {
            currentLocation = locations.last
            let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude), zoom: 15.0)
            mapView.animate(to: camera)
            didFinishFirstLocationUpdate = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }

}
