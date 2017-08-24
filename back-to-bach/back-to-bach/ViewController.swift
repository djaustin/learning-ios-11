//
//  ViewController.swift
//  back-to-bach
//
//  Created by Dan Austin on 24/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        // Stop playback
        player.stop()
        
        // Reset song to start
        player.currentTime = 0
        
        // Ensure play button is displayed
        var barItems = toolbar.items!
        barItems.remove(at: 1)
        barItems.insert(playButton, at: 1)
        toolbar.setItems(barItems, animated: true)
        
    }
    @IBOutlet weak var scrobbler: UISlider!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBAction func volumeSliderMoved(_ sender: UISlider!) {
        // Adjust player volume to that of volume slider
        player.volume = sender.value
    }
    @IBAction func scrobblerMoved(_ sender: Any) {
        // Skip time to current value of scrobbler. Max value is the duration of the song
        player.currentTime = Double(scrobbler.value)
    }
    var playButton = UIBarButtonItem()
    var pauseButton = UIBarButtonItem()
    
    var player: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize button objcts so they can be dynamically added to and removed from toolbar
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonPressed))
        pauseButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseButtonPressed))
        
        // Place play button on toolbar to begin with
        var barItems = toolbar.items!
        barItems.insert(playButton, at: 1)
        toolbar.setItems(barItems, animated: false)
        
        // Attempt to get the music file to play
        guard let filePath = Bundle.main.path(forResource: "bach", ofType: "mp3") else {
            print("Unable to find audio file bach.mp3")
            return
        }
        
        // Monitor the music track position and adjust the scrobbler to match it ever .5s
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
            self.scrobbler.value = Float(self.player.currentTime)
        }
        
        // Initialise audiplayer with song
        let url = URL(fileURLWithPath: filePath)
        do{
            try player = AVAudioPlayer(contentsOf: url)
        }catch {
            print("Error occurred:", error)
            player = AVAudioPlayer()
        }
        // Configure max value on scrobbler to equal the lenght of the song
        scrobbler.maximumValue = Float(player.duration)
        
        
    }
    
    // Play the song and display the pause button
    @objc func playButtonPressed(){
        if player.play(){
            var barItems = toolbar.items!
            barItems.remove(at: 1)
            barItems.insert(pauseButton, at: 1)
            toolbar.setItems(barItems, animated: true)
        }
        
    }
    
    // Pause the song and display the play button
    @objc func pauseButtonPressed(){
        player.pause()
        var barItems = toolbar.items!
        barItems.remove(at: 1)
        barItems.insert(playButton, at: 1)
        toolbar.setItems(barItems, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

