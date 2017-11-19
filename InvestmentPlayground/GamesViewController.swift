//
//  GamesViewController.swift
//  movie viewer tabbed
//
//  Created by Michelle Xu on 11/18/17.
//  Copyright © 2017 Michelle Xu. All rights reserved.
//

import UIKit
import FirebaseFirestore

class GamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let db = Firestore.firestore()
    
    // Maybe it would make sense to make an array of Game structs instead of a string, but for now just doing strings to show the concept
    var games: [String] = []
    @IBOutlet weak var gamesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gamesTable.dataSource = self
        gamesTable.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "clickedGame"){
            let  nextVC:LeadershipViewController = (segue.destination as?LeadershipViewController)!
        }
        
    }
    
    //EVERYTHING NEEDS TO BE CHANGED
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //help from https://www.ralfebert.de/tutorials/ios-swift-uitableviewcontroller/#data_swift_arrays
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as UITableViewCell
        cell1.textLabel?.text = games[indexPath.row]
        return cell1
    }
    
    func getGamesForUser(username: String) {
        db.collection("gameMembers").whereField("username", isEqualTo: username)
            .getDocuments() { [unowned self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let title = document.data()["title"] as? String {
                            self.games.append(title)
                        }
                    }
                    self.gamesTable.reloadData()
                }
        }
    }
}