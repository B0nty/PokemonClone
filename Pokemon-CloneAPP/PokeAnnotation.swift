//
//  PokeAnnotation.swift
//  Pokemon-CloneAPP
//
//  Created by B0nty on 13/04/2017.
//  Copyright © 2017 B0nty. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {

        self.coordinate = coord
        self.pokemon = pokemon
    }
}
