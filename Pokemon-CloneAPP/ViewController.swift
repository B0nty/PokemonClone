//
//  ViewController.swift
//  Pokemon-CloneAPP
//
//  Created by B0nty on 13/04/2017.
//  Copyright © 2017 B0nty. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    var pokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        
        // Get premission from the user to use location service only once not every time when close and open the app
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            setUP()
            
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            setUP()
        }
    }
    
    func setUP() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        manager.startUpdatingLocation()
        
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            
            //Spwan a random Pokemon location
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                
                let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                let randoLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randoLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLon
                
                self.mapView.addAnnotation(anno)
                
            }
        })
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            annoView.image = UIImage(named: "player")   // declare picture instead of dot user location
            
            var frame = annoView.frame  // set size of the picture
            frame.size.height = 40
            frame.size.width = 40
            
            annoView.frame = frame
            
            return annoView
        }
        
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        annoView.image = UIImage(named: pokemon.imageName!)   // declare picture instead of pin of pokemon
        
        var frame = annoView.frame  // set size of the picture
        frame.size.height = 50
        frame.size.width = 50
        
        annoView.frame = frame
        
        return annoView
    }
    
    
    
    //Func to update current location of the user
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 3 {   //Get 3 times update location of the user then stop updating
            
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200 , 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { // Select Pokomon if is close enought to user
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {  // Exclude player from possibilities to be catch
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
            
            if let coord = self.manager.location?.coordinate {  // Select Pokomon if is close enought to catch by user
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                    pokemon.cought = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)  //Remove Pokemon from the map when it is catched
                    
                    let alertVC = UIAlertController(title: "Congrat!", message: "You caught the \(pokemon.name!). Great JOB :-)", preferredStyle: .alert)
                    
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: {(action) in
                        
                        self.performSegue(withIdentifier: "pkedaxsegue", sender: nil)
                        
                    })
                    
                    alertVC.addAction(pokedexAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                    
                } else { // Show alert that pokemon is to far away to catch
                    let alertVC = UIAlertController(title: "WARRNING", message: "You are too far waay to catch the \(pokemon.name!). Move closer 😲", preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alertVC.addAction(OKAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
            
        })
        
        
    }
    
    @IBAction func centerTapped(_ sender: Any) {   // Button action to center the current location of user
        
        if let coord = manager.location?.coordinate {
            
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
}


