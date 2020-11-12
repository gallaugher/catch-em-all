//
//  ListViewController.swift
//  Catch 'em all
//
//  Created by John Gallaugher on 8/15/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    var creatures = Creatures()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupActivityIndicator()
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        creatures.getData {
            DispatchQueue.main.async {
                self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = UIColor.red
        view.addSubview(activityIndicator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.creature = creatures.creatureArray[selectedIndexPath.row]
        }
    }
    
    func loadAll() {
        if creatures.urlString.hasPrefix("http") {
            creatures.getData {
                DispatchQueue.main.async {
                    self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                    self.tableView.reloadData()
                }
                self.loadAll()
            }
        } else {
            DispatchQueue.main.async {
                print("All done - all loaded. Total Pokemon = \(self.creatures.creatureArray.count)")
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func loadAllButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        loadAll()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatures.creatureArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == creatures.creatureArray.count-1 && creatures.urlString.hasPrefix("http") {
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            print("📣 indexPath.row = \(indexPath.row) and creatures.creatureArray.count = \(creatures.creatureArray.count) We are calling getData for URL \(creatures.urlString)")
            creatures.getData {
                DispatchQueue.main.async {
                    self.navigationItem.title = "\(self.creatures.creatureArray.count) of \(self.creatures.count) Pokemon"
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
        cell.textLabel?.text = "\(indexPath.row+1). \(creatures.creatureArray[indexPath.row].name)"
        return cell
    }
}
