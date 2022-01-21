//
//  MultipleCalTableVC.swift
//  fsCal
//
//  Created by odikk on 21/01/22.
//

import UIKit



class MultipleCalTableVC: UITableViewController {
    
    @IBOutlet var mainTableView: UITableView!
    let type = [
        "simpleMultipleSelection",
        "disableBefore",
        "disableNext"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return type.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "mainCell")
        cell.textLabel?.text = type[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: type[indexPath.row], sender: self)
    }
}
