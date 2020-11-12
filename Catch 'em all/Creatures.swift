//
//  Creatures.swift
//  Catch 'em all
//
//  Created by John Gallaugher on 8/15/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation

class Creatures {
    
    private struct Returned: Codable {
        var count: Int
        var next: String?
        var results: [Creature]
    }
    
    var count = 0
    var urlString = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20"
    var creatureArray: [Creature] = []
    var isFetching = false
    
    func getData(completed: @escaping ()->()) {
        // Do not get data if you're already fetching data - this avoids a "double fetch"
        guard !isFetching else {
            return
        }
        isFetching = true
        
        print("🕸 We are accessing the url \(urlString)")
        
        // create a url
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a url from \(urlString)")
            return
        }
        
        // create a session
        let session = URLSession.shared
        
        // get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
//                print("😎 Here is what was returned \(returned)")
                self.creatureArray = self.creatureArray + returned.results
                self.urlString = returned.next ?? ""
                self.count = returned.count
            } catch {
                print("😡 JSON ERROR: thrown when we tried to decode from Returned.self with data")
            }
            self.isFetching = false
            completed()
        }
        
        task.resume()
    }
}
