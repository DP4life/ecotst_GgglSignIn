//
//  EcoMapViewController.swift
//  Eco
//
//  Created by Porcescu Artiom on 9/13/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseStorage

class EcoMapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var ecoMapButton: UITabBarItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ecoImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let regionInMeters: Double = 10000
    var selectedAnnotation: MKPointAnnotation?
//    MapMarker(coordinate: place.coordinate, tint: .green)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocationServices()
        locationManager.delegate = self
        mapView.delegate = self
        
        let db = Firestore.firestore()
        
        db.collection("locations").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let coords = document.get("pinLocation") {
                        let point = coords as! GeoPoint
                        let lat = point.latitude
                        let lon = point.longitude
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    @IBAction func plusPressed(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
        
//        guard let currLoc = locationManager.location else { return }
        
        ////Uncomment this code below
        
//        guard let currentLocation = locationManager.location else { return }
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//        mapView.addAnnotation(annotation)
        
////////////////////////////////////////////                   UPLOAD TO FIREBASE          /////////////////////////////////////////
        
//        let db = Firestore.firestore()
//        let doc = db.collection("locations").document()
//
//        let ecoPin = GeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        doc.setData(["uid": uid, "pinLocation": ecoPin]) { (error) in
//            if error != nil {
//                print(error?.localizedDescription)
//                return
//            } else {
//                print("Pin saved")
//            }
//        }

        
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//                if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
//                    return nil  //Default is to let the system handle it.
//                }
//
//                if !annotation.isKind(of: ImageAnnotation.self) {  //Handle non-ImageAnnotations..
//                    var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
//                    if pinAnnotationView == nil {
//                        pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
//                    }
//                    return pinAnnotationView
//                }
//
//                //Handle ImageAnnotations..
//                var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
//                if view == nil {
//                    view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
//                }
//
//                let annotation = annotation as! ImageAnnotation
//                view?.image = annotation.image
//                view?.annotation = annotation
//
//                return view
//            }
        
    }
    
    @IBAction func refreshPressed(_ sender: UIButton) {
        let db = Firestore.firestore()
        
        db.collection("locations").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let coords = document.get("pinLocation") {
                        let point = coords as! GeoPoint
                        let lat = point.latitude
                        let lon = point.longitude
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        mapView.addAnnotation(annotation)
                    }
                }
            }
        }
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        let ref = storageRef.child("pins/")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

extension EcoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let ecoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        guard let currentLocation = locationManager.location else { return }

//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//        mapView.addAnnotation(annotation)
        
        let db = Firestore.firestore()
        let doc = db.collection("locations").document()

        let ecoPin = GeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)

        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let time = Date().timeIntervalSince1970
        
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        let timeData = dateFormatter.string(from: date)
        
        let storage = Storage.storage().reference()
        guard  let imageData = ecoImage.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        storage.child("pins/\(uid)").listAll { (res, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            for item in res.items {
                print(item)
            }
        }
        
        
            
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        
        let imageTime = NSUUID().uuidString
            
            storage.child("pins/\(imageTime)").putData(imageData, metadata: metaData) { (meta, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    storage.child("pins/\(imageTime)").downloadURL { (url, err) in
                        if let e = err {
                            print(e.localizedDescription)
                        } else {
                            let urlString = url?.absoluteString
                            doc.setData(["uid": uid, "pinLocation": ecoPin, "time": timeData, "url": urlString!]) { (error) in
                                if error != nil {
                                    print(error?.localizedDescription)
                                    return
                                } else {
                                    print("Saved")
                                }
                            }
                        }
                    }
                }
                 print("Image sent")
            }
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        view.tintColor = UIColor.systemGreen
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var coord = self.selectedAnnotation
        coord = view.annotation as? MKPointAnnotation
        let codeLat = coord?.coordinate.latitude
        let codeLon = coord?.coordinate.longitude
//        print("\(coord?.coordinate.latitude)")
//        print("\(coord?.coordinate.longitude)")
        
        let db = Firestore.firestore()
        
        db.collection("locations").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if let coords = document.get("pinLocation") {
                        let point = coords as! GeoPoint
                        let lat = point.latitude
                        let lon = point.longitude
                        if codeLat == lat && codeLon == lon {
                            let imageUrl = document.data()["url"]
                            print(imageUrl!)
                            let er = "not found"
                            let url = URL(string: "\(imageUrl ?? er)")!
                            DispatchQueue.global().async {
                                if let data = try? Data(contentsOf: url) {
                                    DispatchQueue.main.async {
                                        self.ecoImageView.image = UIImage(data: data)
                                        ecoImageView.layer.cornerRadius = 10
                                        ecoImageView.clipsToBounds = true
                                        ecoImageView.layer.borderColor = UIColor.systemGreen.cgColor
                                        ecoImageView.layer.borderWidth = 3
                                    }
                                }
                            }
                        }
//                        let annotation = MKPointAnnotation()
//                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//                        mapView.addAnnotation(annotation)
                    }
                }
            }
        }
        
//        db.collection("locations").whereField("pinLocation", isEqualTo: actual!).getDocuments { (documentsFir, error) in
//            if let err = error {
//                        print("Error getting documents: \(err)")
//                    } else {
//                        for document in documentsFir!.documents {
//                            if let coords = document.get("pinLocation") {
//                                let point = coords as! GeoPoint
//                                let coord = point.c
//                            }
//                            let imageUrl = document.data()["url"]
//                            print(imageUrl!)
//                        }
//                    }
//        }
        
    }

}

//class ImageAnnotation : NSObject, MKAnnotation {
//    var coordinate: CLLocationCoordinate2D
//    var image: UIImage
//
//    init(coordinate: CLLocationCoordinate2D, image: UIImage) {
//        self.coordinate = coordinate
//        self.image = image
//        self.imageEco = image
//        self.imageView.image = image
//        self.imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        self.imageView.addSubview(self.imageView)
//
//        self.imageView.layer.cornerRadius = 25
//        self.imageView.layer.masksToBounds = true
//    }
//}

//    var image: UIImage? {
//        get {
//            return self.imageView.image
//        }
//
//        set {
//            self.imageView.image = newValue
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//class ImageAnnotationView: MKAnnotationView {
//    private var imageView: UIImageView!
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//
//        self.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        self.addSubview(self.imageView)
//
//        self.imageView.layer.cornerRadius = 25
//        self.imageView.layer.masksToBounds = true
//    }
//
//    override var image: UIImage? {
//        get {
//            return self.imageView.image
//        }
//
//        set {
//            self.imageView.image = newValue
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
