//
//  CoreDataHelp.swift
//  Pokemon-CloneAPP
//
//  Created by B0nty on 13/04/2017.
//  Copyright © 2017 B0nty. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    
    creatPokemon(name: "Mew", imageName: "mew")
    creatPokemon(name: "Meowth", imageName: "meowth")
    creatPokemon(name: "Caterpie", imageName: "caterpie")
    creatPokemon(name: "Eevee", imageName: "eevee")
    creatPokemon(name: "Pidgey", imageName: "pidgey")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func creatPokemon(name: String, imageName :String) {
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    
    pokemon.name = name
    pokemon.imageName = imageName
    
}

func getAllPokemon() -> [Pokemon] {
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        
        let pokemons =  try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
        }
        
        return pokemons
    } catch {}
    
    return[]
}

func getAllCaught() -> [Pokemon] {
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    
    fetchRequest.predicate = NSPredicate(format: "cought == %@", true as CVarArg)
    
    do {
        let pokemons =  try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {}
    
    return []
    
}

func getAllUnCaught() -> [Pokemon] {
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    
    fetchRequest.predicate = NSPredicate(format: "cought == %@", false as CVarArg)
    
    do {
        let pokemons =  try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {}
    
    return []
}
