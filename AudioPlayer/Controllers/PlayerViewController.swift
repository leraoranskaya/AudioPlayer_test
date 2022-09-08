//
//  PlayerViewController.swift
//  AudioPlayer
//
//  Created by Лерочка on 08.09.22.
//

import Foundation
import AVFoundation
import UIKit

class PlayerViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var currenTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var fullPlayerPlayPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    //MARK: Properties
    var player: AVAudioPlayer?
    var position: Int = 0
    var songs: [Song] = []
    
    //MARK:  Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTrack()
        durationSlider.maximumValue = Float(player?.duration ?? 0)
        durationTime()
        var timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        var timerAudio = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
    
    //MARK: IBActions
    @IBAction func didTapPlayPauseButton(_ sender: Any) {
        player?.play()
        updatePlayButton()
    }
    
    @IBAction func tapNextSong(_ sender: Any) {
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
        }
        loadTrack()
    }
    
    @IBAction func tapPreviousSong(_ sender: Any) {
        if position > 0 {
            position = position - 1
            player?.stop()
        }
        loadTrack()
    }
    
        @IBAction func volumeSliderAction(_ sender: Any) {
            self.player?.volume = self.volumeSlider.value
        }
    
    @IBAction func durationSliderAction(_ sender: UISlider) {
        player?.stop()
        self.player?.currentTime = TimeInterval(durationSlider.value)
        player?.prepareToPlay()
        player?.play()
    }
    
    //MARK:  Methods
    func setupUI() {
        albumArtImageView.layer.cornerRadius = 15
        // albumArtImageView.clipsToBounds = true
        albumArtImageView.layer.masksToBounds = true
        durationSlider.setThumbImage(UIImage(named: "circle"), for: UIControl.State())
        albumArtImageView.layer.shadowColor = UIColor.black.cgColor
        albumArtImageView.layer.shadowOpacity = 0.5
        albumArtImageView.layer.shadowOffset = CGSize(width: 10, height: 10)
        albumNameLabel.layer.shadowColor = UIColor.black.cgColor
        albumNameLabel.layer.shadowOpacity = 1
        albumNameLabel.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        songNameLabel.layer.shadowColor = UIColor.black.cgColor
        songNameLabel.layer.shadowOpacity = 1
        songNameLabel.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        nextButton.layer.shadowColor = UIColor.white.cgColor
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        previousButton.layer.shadowColor = UIColor.white.cgColor
        previousButton.layer.shadowOpacity = 1
        previousButton.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
        
        fullPlayerPlayPauseButton.layer.shadowColor = UIColor.white.cgColor
        fullPlayerPlayPauseButton.layer.shadowOpacity = 1
        fullPlayerPlayPauseButton.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        let color1 = UIColor(named: "mainViewColorOne")?.cgColor
        let color2 = UIColor(named: "mainViewColorTwo")?.cgColor
        let color3 = UIColor(named: "mainViewColorThree")?.cgColor
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [color1 ?? UIColor.systemPink,
                           color2 ?? UIColor.purple,
                           color3 ?? UIColor.cyan]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        
    }
    
    func durationTime() {
        let duration = Int(((player?.duration ?? 0) - (player?.currentTime ?? 0)))
        let minutes2 = duration/60
        let seconds2 = duration - minutes2 * 60
        durationLabel.text = NSString(format: "%02d:%02d", minutes2,seconds2) as String
    }
    
    @objc func updateSlider() {
        durationSlider.value = Float(player?.currentTime ?? 0)
    }
    
    @objc func updateAudioTime() {
        let currentTime1 = Int((player?.currentTime)!)
        let minutes = currentTime1/60
        let seconds = currentTime1 - minutes * 60
        currenTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    func setPlayButtonIconToPause() {
        fullPlayerPlayPauseButton.setImage(UIImage(named:"MPPause"), for: UIControl.State())
    }
    
    func setPlayButtonIconToPlay() {
        fullPlayerPlayPauseButton.setImage(UIImage(named: "MPPlay"), for: UIControl.State())
    }
    
    func updatePlayButton() {
        if fullPlayerPlayPauseButton.imageView?.image == UIImage(named: "MPPlay") {
            fullPlayerPlayPauseButton.setImage(UIImage(named: "MPPause"), for: UIControl.State())
            playSong()
        } else {
            fullPlayerPlayPauseButton.setImage(UIImage(named: "MPPlay"), for: UIControl.State())
            pauseSong()
        }
    }
    
    @objc func pauseSong() {
        player?.pause()
        setPlayButtonIconToPlay()
    }
    
    @objc func playSong() {
        player?.play()
        setPlayButtonIconToPause()
    }
    
    //MARK:  Private methods
    private func loadTrack() {
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType:"mp3")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.ambient
            )
            
            guard let urlString = urlString  else {
                print("urlstring is nil")
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                print("player is nil")
                return
            }
            player.volume = 0.5
            
             player.play()
           // player.stop()
        }
        catch {
            print("error occurred")
        }
        songNameLabel.text = song.name
        albumNameLabel.text = song.artistName
        albumArtImageView.image = UIImage(named: song.imageName)
    }
}
