//
//  TrackListTableVC.swift
//  AudioPlayer
//
//  Created by Лерочка on 08.09.22.
//

import Foundation
import UIKit

class TrackListTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var table: UITableView!
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        table.delegate = self
        table.dataSource = self
    }

    func configureSongs() {
        songs.append(Song(name: "Animals",
                          albumName: "Unknown",
                          artistName: "Maroon 5",
                          imageName: "cover1",
                          trackName: "song4"))
        songs.append(Song(name: "Gold",
                          albumName: "Unknown",
                          artistName: "Haris",
                          imageName: "cover2",
                          trackName: "song2"))
        songs.append(Song(name: "Beating Heart",
                          albumName: "Unknown",
                          artistName: "Элли Голдинг",
                          imageName: "cover4",
                          trackName: "song3"))
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let position = indexPath.row
        guard let playerVC = storyboard?.instantiateViewController(identifier: "PlayerVC") as? PlayerViewController else {
            return
        }
        playerVC.modalPresentationStyle = .fullScreen
        playerVC.modalTransitionStyle = .crossDissolve
        playerVC.songs = songs
        playerVC.position = position
        present(playerVC, animated: true)
    }
}

