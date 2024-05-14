//
//  VideoPlayer.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 27.02.2024.
//

import UIKit
import YouTubePlayerKit

class VideoPlayerViewController: UIViewController {
    
    var movie = Movie()
    
    var link = ""
    var video_link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        playerSettings()
        constraints()
    }
    
    let videoPlayer = YouTubePlayerHostingView()
    
    func playerSettings() {
        videoPlayer.backgroundColor = .black
        videoPlayer.player.source = .video(id: video_link, startSeconds: nil, endSeconds: nil)
    }
    
        func constraints(){
            view.addSubview(videoPlayer)
    
            videoPlayer.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
    
        }

 }

