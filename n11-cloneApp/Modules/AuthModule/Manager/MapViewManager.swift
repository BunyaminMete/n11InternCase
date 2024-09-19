//
//  MapViewManager.swift
//  n11-cloneApp
//
//  Created by Bünyamin Mete on 5.09.2024.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewManagerDelegate: AnyObject {
    func mapViewManagerTest(_ manager: MapViewManager, didSelectLocationWith address: String)
}

class MapViewManager: NSObject, CLLocationManagerDelegate, MKMapViewDelegate, MKLocalSearchCompleterDelegate {

    private let mapView: MKMapView
    private let locationManager: CLLocationManager
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchResults: [MKLocalSearchCompletion] = []
    private var isInitialLocationUpdate = true // Kullanıcı konumuna yalnızca bir kez odaklanmak için

    weak var delegate: MapViewManagerDelegate?

    init(mapView: MKMapView) {
        self.mapView = mapView
        self.locationManager = CLLocationManager()
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager.requestWhenInUseAuthorization()
                }
            } else {
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .restricted, .denied:
            mapView.showsUserLocation = false
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first, isInitialLocationUpdate {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            DispatchQueue.main.async {
                self.mapView.setRegion(region, animated: true)
            }
            isInitialLocationUpdate = false // İlk konum güncellemesi yapıldıktan sonra bu değişken false yapılıyor
        }
    }

    func searchLocations(for query: String) {
        if searchCompleter == nil {
            searchCompleter = MKLocalSearchCompleter()
            searchCompleter?.delegate = self
        }
        searchCompleter?.queryFragment = query
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }

    func selectLocation(with completion: MKLocalSearchCompletion, completionHandler: @escaping (UserAddressModel) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)

        search.start { [weak self] response, error in
            guard let self = self, let response = response else {
                print("Error searching for location: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let coordinate = response.mapItems.first?.placemark.coordinate
            let region = MKCoordinateRegion(center: coordinate ?? self.mapView.centerCoordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            DispatchQueue.main.async {
                self.mapView.setRegion(region, animated: true)

                // Remove existing annotations
                self.mapView.removeAnnotations(self.mapView.annotations)

                // Add new annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate ?? self.mapView.centerCoordinate
                annotation.title = completion.title
                self.mapView.addAnnotation(annotation)

                // Get the address from the selected placemark and create UserAddressModel
                if let placemark = response.mapItems.first?.placemark {
                    let userAddress = UserAddressModel(
                        userCountry: placemark.country ?? "No Country",
                        userCity: placemark.administrativeArea ?? "No City",
                        userPostCode: placemark.postalCode ?? "No Postal Code",
                        userStreet: placemark.thoroughfare ?? "No Street",
                        userDistrict: placemark.locality ?? "No Administrative Area",
                        userStructureNo: placemark.subThoroughfare ?? "No Structure Number"
                    )
                    completionHandler(userAddress)
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            DispatchQueue.main.async {
                mapView.setRegion(region, animated: true)
            }
        }
    }
}
