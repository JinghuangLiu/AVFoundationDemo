//
//  AudioPlayerVC.swift
//  AVFoundationDemo
//
//  Created by 刘靖煌 on 2022/7/15.
//

import UIKit
import AVFoundation

class AudioPlayerVC: UIViewController {

    var player:AVAudioPlayer?
    
    lazy var playB:UIButton = {
        let b = UIButton()
        b.setTitle("播放", for: .normal)
        b.backgroundColor = .yellow
        b.addTarget(self, action: #selector(action), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.defaultToSpeaker,.allowBluetooth,.interruptSpokenAudioAndMixWithOthers,.allowAirPlay])

        // Do any additional setup after loading the view.
        view.addSubview(playB)
        playB.translatesAutoresizingMaskIntoConstraints = false
        playB.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        playB.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        playB.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playB.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func action() {
        let resource = Bundle.main.path(forResource: "audio", ofType: "wav")
        player = try? AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: resource!))
        player?.play()
    }
    

}
