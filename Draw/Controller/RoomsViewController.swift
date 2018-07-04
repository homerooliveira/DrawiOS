//
//  RoomsViewController.swift
//  Draw
//
//  Created by Eduardo Fornari on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class RoomsViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!

    private var rooms: [Room] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        DatabaseAcess.share.fetchRoomsObservable { (rooms) in
            if let rooms = rooms {
                self.rooms = rooms
                self.tableview.reloadData()
            }
        }
    }

    @IBAction func addRoomAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Criar sala", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Nome da sala"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let alert = alert, let textField = alert.textFields?.first {
                guard let name = textField.text else { return }
                
                if name.isEmpty {
                    
                } else {
                    let room = Room(identifier: UUID().uuidString, name: textField.text!)
                    DatabaseAcess.share.save(with: room, completion: { (error) in
                        if error == nil {
                            
                        }
                    })
                }
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DrawViewController.gotoDrawViewControllerIdentifier {
            if let room = sender as? Room {
                if let destination = segue.destination as? DrawViewController {
                    destination.room = room
                }
            }
        }
    }

}

extension RoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomUITableViewCell", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: DrawViewController.gotoDrawViewControllerIdentifier, sender: rooms[indexPath.row])
    }
}
