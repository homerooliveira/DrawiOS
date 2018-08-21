//
//  RoomsViewController.swift
//  Draw
//
//  Created by Eduardo Fornari on 04/07/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import UIKit

class RoomsViewController: UIViewController {

    private var tableview = UITableView(frame: .zero, style: .plain)

    private var rooms: [Room] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Rooms"

        setControls()

        setTableView()

        DataAcess.shared.fetchRoomsObservable { (rooms) in
            if let rooms = rooms {
                self.rooms = rooms
                self.tableview.reloadData()
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Controls

    private func setControls() {
        let createRoomButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(addRoomButtonDidTapped))
        navigationItem.rightBarButtonItems = [createRoomButton]
    }

    // MARK: - Add Romm

    @objc func addRoomButtonDidTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Criar sala", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Nome da sala"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let alert = alert, let textField = alert.textFields?.first, let name = textField.text {
                if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    DataAcess.shared.fetchRoom(with: name, completion: { (rooms) in
                        if rooms?.first != nil {
                            let alert = Alerts.simpleAlert(with: "Sala já existe", and: "A sala \"\(name)\" já existe.")
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let room = Room(identifier: UUID().uuidString, name: textField.text!)
                            DataAcess.shared.save(with: room, completion: { (error) in
                                if error == nil {
                                    
                                }
                            })
                        }
                    })
                }
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation
    // TO-DO

}

// MARK: - UITableViewDelegate
extension RoomsViewController: UITableViewDelegate, UITableViewDataSource {

    internal func setTableView() {
        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableview.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
            ])
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "RoomUITableViewCell")
    }

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
        if let navigationController = navigationController {
            let drawViewController = DrawViewController()
            drawViewController.room = rooms[indexPath.row]
            navigationController.pushViewController(drawViewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let room = rooms[indexPath.row]
            DataAcess.shared.deleteRoom(with: room.identifier!) { (error) in
                if error == nil {
                    let drawPathViewModel = DrawPathViewModel(room: room)
                    drawPathViewModel.clearPath(completion: { (error) in })
                }
            }
            
        }
    }
}
