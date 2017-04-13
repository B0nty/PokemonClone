//
//  PokeDexViewController.swift
//  Pokemon-CloneAPP
//
//  Created by B0nty on 13/04/2017.
//  Copyright © 2017 B0nty. All rights reserved.
//

import UIKit

class PokeDexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var coughtPokemons : [Pokemon] = []
    var uncoughtPokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coughtPokemons = getAllCaught()
        uncoughtPokemons = getAllUnCaught()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {   // How many sections are in table view
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {  // Define names of section
        if section == 0 {
            return "CAUGHT"
        } else {
            return "UNCAUGHT"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //Define rows in differente section
        if section == 0 {
            return coughtPokemons.count
        } else {
            return uncoughtPokemons.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let pokemon : Pokemon
        
        if indexPath.section == 0 {
            pokemon = coughtPokemons[indexPath.row]
        } else {
            pokemon = uncoughtPokemons[indexPath.row]
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        return cell
    }
    
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
