//
//  ToothlessDancing.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 22.01.2024.
//

import Foundation
import UIKit
import AVFoundation
import Gifu

protocol BlinkingViewDelegate: AnyObject {
    func startBlinking(_ blinkingView: BlinkingView)
    func stopBlinking(_ blinkingView: BlinkingView)
    func blinkingViewDidToggle(_ blinkingView: BlinkingView)
}

class ToothlessDancing: UIViewController, BlinkingViewDelegate {
    
    var timer = Timer()
    var isTimerRunning = false
    
    var arrayPlayList:[String] = ["Toothless Dance Meme", "Arfa sms", "Al Bano - Felicita", "Phelisium - Searching you"]
    var queuePlayer: AVQueuePlayer?
    var playerItems: [AVPlayerItem] = []
    
    lazy var player = queuePlayer
    var currentIndex: Int = 0
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPlayer()
        UISetup()
        
        blinkingView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
        audioSlider.addGestureRecognizer(tapGesture)
        
    }
    // MARK: AudioPlayer
    func setupPlayer() {
        for trackName in arrayPlayList {
            guard let url = Bundle.main.url(forResource: trackName, withExtension: "mp3") else {
                print("Error: File \(trackName).mp3 not found.")
                continue
            }
            let playerItem = AVPlayerItem(url: url)
            playerItems.append(playerItem)
        }
        queuePlayer = AVQueuePlayer(items: playerItems)
        
//        queuePlayer?.actionAtItemEnd = .pause
        
//        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
//    @objc func playerDidFinishPlaying(note: NSNotification) {
//        // Проверка, что плеер имеет элементы в очереди
//        guard let queuePlayer = queuePlayer, !playerItems.isEmpty else {
//            return
//        }
//
//        isPlaying = true
//
//            // Проверяем, достигли ли последнего элемента в массиве
//            if currentIndex == playerItems.count - 1 {
//                // Устанавливаем текущий индекс на первый трек
//                currentIndex = 0
//                queuePlayer.removeAllItems()
//                for index in currentIndex..<playerItems.count {
//                    queuePlayer.insert(playerItems[index], after: nil)
//                }
//            } else {
//                // Увеличиваем текущий индекс на 1
//                currentIndex += 1
//            }
//        
//        // Устанавливаем текущий индекс для плеера
////        queuePlayer.removeAllItems()
////        for index in currentIndex..<playerItems.count {
////            queuePlayer.insert(playerItems[index], after: nil)
////        }
//        queuePlayer.seek(to: .zero)
//        queuePlayer.play()
//        
//        // Сброс флага воспроизведения после небольшой задержки
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.isPlaying = false
//            }
//    }
    
    //MARK: UISetup
    var isGifAnimating = false
    
    lazy var gifImageView: GIFImageView = {
        let imageView = GIFImageView()
        imageView.animate(withGIFNamed: "Toothless dancing")
//        imageView.layer.borderWidth = 1
        imageView.stopAnimatingGIF()
        isGifAnimating = false
        imageView.prepareForAnimation(withGIFNamed: "Toothless dancing")
        return imageView
    }()
    let blinkingView: BlinkingView = {
        let blview = BlinkingView()
        
        return blview
    }()
    let playStopBtn = {
        let button = UIButton()
        button.setImage(UIImage(named: "Play"), for: .normal)
        button.addTarget(self, action: #selector(playStopPressed), for: .touchUpInside)
        
        return button
    }()
    let nextTrackBtn = {
        let button = UIButton()
        button.setImage(UIImage(named: "Next Track"), for: .normal)
        button.addTarget(self, action: #selector(nextTrackPressed), for: .touchUpInside)

        return button
    }()
    let previousTrackBtn = {
        let button = UIButton()
        button.setImage(UIImage(named: "Previous Track"), for: .normal)
        button.addTarget(self, action: #selector(previousTrackPressed), for: .touchUpInside)
        
        return button
    }()
    lazy var audioSlider = {
        let slider = UISlider()
//        slider.maximumValue = Float(player.duration)
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(audioSliderValueDidChanged), for: .valueChanged)
        slider.isHidden = true
        
        return slider
    }()
    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    lazy var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
   
    // MARK: Constraints
    func UISetup() {
        view.addSubview(blinkingView)
        view.addSubview(gifImageView)
//        view.addSubview(playBtn)
//        view.addSubview(stopBtn)
        view.addSubview(playStopBtn)
        view.addSubview(nextTrackBtn)
        view.addSubview(previousTrackBtn)
        view.addSubview(audioSlider)
        view.addSubview(currentTimeLabel)
        view.addSubview(totalTimeLabel)
        
        blinkingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(gifImageView)
        }
        gifImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        playStopBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(50)
        }
        nextTrackBtn.snp.makeConstraints { make in
            make.left.equalTo(playStopBtn.snp.right).offset(15)
            make.centerY.equalTo(playStopBtn)
            make.size.equalTo(40)
        }
        previousTrackBtn.snp.makeConstraints { make in
            make.right.equalTo(playStopBtn.snp.left).offset(-15)
            make.centerY.equalTo(playStopBtn)
            make.size.equalTo(40)
        }
        audioSlider.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(playStopBtn.snp.top).offset(-35)
        }
        currentTimeLabel.snp.makeConstraints { make in
            make.right.equalTo(audioSlider.snp.left).offset(-10)
            make.left.equalToSuperview().inset(10)
            make.centerY.equalTo(audioSlider.snp.centerY)
        }
        totalTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(audioSlider.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.centerY.equalTo(audioSlider.snp.centerY)
        }
        
    }
    
    func blinkingViewDidToggle(_ blinkingView: BlinkingView) {
        print("Blinking")
    }
    func startBlinking(_ blinkingView: BlinkingView) {
        print("Start Blinking")
    }
    func stopBlinking(_ blinkingView: BlinkingView) {
        print("Stop Blinking")
    }
    // MARK: AudioSlider
    @objc func audioSliderValueDidChanged() {
        guard let player = queuePlayer else {
            return
        }
        let totalTime = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
        let newTime = Double(audioSlider.value) * totalTime
        let timeToSeek = CMTime(seconds: newTime, preferredTimescale: 1)
        player.seek(to: timeToSeek)
    }
    
    @objc func updatingSliderValue() {
        guard let player = queuePlayer else {
            return
        }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let totalTime = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
        
        audioSlider.value = Float(currentTime / totalTime)
        currentTimeLabel.text = timeFormat(player.currentTime())
        totalTimeLabel.text = timeFormat(player.currentItem?.duration ?? CMTime.zero)
        
        print("\(timeFormat(player.currentTime()))")
    }
    
    @objc func sliderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        // Получаем координаты касания
        let pointTapped: CGPoint = gestureRecognizer.location(in: audioSlider)
        // Вычисляем процентное положение касания относительно ширины слайдера
        let percentage = pointTapped.x / audioSlider.bounds.size.width
        // Устанавливаем новое значение слайдера в соответствии с процентом
        let newValue = Float(percentage) * (audioSlider.maximumValue - audioSlider.minimumValue) + audioSlider.minimumValue
        audioSlider.setValue(newValue, animated: true)
        DispatchQueue.main.async {
               self.audioSliderValueDidChanged()
           }
    }
    
    func setupAudioSlider() {
        guard let queuePlayer = queuePlayer,
            let currentItem = queuePlayer.currentItem else {
            return
        }
        let duration = CMTimeGetSeconds(currentItem.duration)
        audioSlider.maximumValue = Float(duration)
    }
    
    func timeFormat(_ time: CMTime) -> String {
        let timeInSeconds = CMTimeGetSeconds(time)
        guard !timeInSeconds.isNaN && !timeInSeconds.isInfinite else {
                return "00:00"
            }
        let seconds = Int(CMTimeGetSeconds(time)) % 60
        let minutes = Int(CMTimeGetSeconds (time) / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    // MARK: Buttons
    @objc func playStopPressed() {
        if let player = player {
            if player.timeControlStatus == .playing {
                stopPressed()
            } else {
                playPressed()
            }
        }
    }
    
    @objc func playPressed() {
        player?.play()
        
        gifImageView.startAnimatingGIF()
        gifImageView.isHidden = false
        
        blinkingView.startBlinking()
        
        audioSlider.isHidden = false
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatingSliderValue), userInfo: nil, repeats: true)
       
        currentTimeLabel.isHidden = false
        totalTimeLabel.isHidden = false
        
        playStopBtn.setImage(UIImage(named: "Stop"), for: .normal)
    }

    @objc func stopPressed() {
        player?.pause()
        player?.seek(to: CMTime.zero)
        
        gifImageView.stopAnimatingGIF()
        gifImageView.prepareForAnimation(withGIFNamed: "Toothless dancing")
        gifImageView.isHidden = true
        
        blinkingView.stopBlinking()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.timer.invalidate()
            self.isTimerRunning = false
        }
        playStopBtn.setImage(UIImage(named: "Play"), for: .normal)
    }
    
    @objc func nextTrackPressed() {
        guard let queuePlayer = queuePlayer else { return }
            guard !arrayPlayList.isEmpty else { return }
                queuePlayer.advanceToNextItem()
                queuePlayer.seek(to: .zero)
    }
    
    @objc func previousTrackPressed() {
        guard let queuePlayer = queuePlayer else { return }
        guard !arrayPlayList.isEmpty else { return }
        if let currentIndex = playerItems.firstIndex(where: { $0 == queuePlayer.currentItem }), currentIndex > 0 {
            let previousIndex = currentIndex - 1
            let previousItem = playerItems[previousIndex]
            queuePlayer.removeAllItems()
            for index in previousIndex..<playerItems.count {
                        queuePlayer.insert(playerItems[index], after: nil)
                    }
            queuePlayer.seek(to: .zero)
            player?.play()
        }
    }
}

// MARK: BlinkingView
class BlinkingView: UIView {
    
    weak var delegate: BlinkingViewDelegate?
    var blinkTimer = Timer()
    var isBlinkingRunning = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func startBlinking() {
        if isBlinkingRunning {
            return
        }
        blinkTimer = Timer.scheduledTimer(timeInterval: 0.46, target: self, selector: #selector(toggleBackgroundColor), userInfo: nil, repeats: true)
        isBlinkingRunning = true
        delegate?.startBlinking(self)
    }
    func stopBlinking() {
        blinkTimer.invalidate()
        isBlinkingRunning = false
        self.backgroundColor = .white
        delegate?.stopBlinking(self)
        }
    @objc func toggleBackgroundColor() {
        UIView.animate(withDuration: 0) {
            self.backgroundColor = self.backgroundColor == UIColor.red ? UIColor.blue : UIColor.red
      
        }
    }
}
