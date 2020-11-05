//
//  MainView.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import UIKit
import AVKit
import MediaPlayer
import os.log

final class MainView: UIView, ViewDelegate {
    
    // MARK: - Enums
    enum Ids : Int32, RawRepresentable {
        
        case playButton = 1
        case mainImage = 2
        case airplayButton = 3
        case volumeControl = 4
        case videoButton = 5
    }
    
    // MARK: - Members
    private let mainImage: UIImageView
    private let playButton: UIButton
    private let videoButton: UIButton
    private let airplayButton: AVRoutePickerView
    private let volumeSlider: MPVolumeView
    
    private var portraitConstraints: [NSLayoutConstraint]
    private var landscapeConstraints: [NSLayoutConstraint]
    
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("MainView init(coder:) is not implemented.")
    }
    
    override init(frame: CGRect) {
        mainImage = UIImageView(image: UIImage(named: "church-2")!.roundedImage())
        playButton = UIButton(type: .custom)
        videoButton = UIButton.systemButton(with: UIImage(systemName: "video.fill")!,
                                            target: nil,
                                            action: nil)
        airplayButton = AVRoutePickerView()
        volumeSlider = MPVolumeView()
        
        portraitConstraints = []
        landscapeConstraints = []
        
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    
    // MARK: - Private functions
    private func setupViews() {
        playButton.tintColor = .label
        playButton.contentVerticalAlignment = .fill
        playButton.contentHorizontalAlignment = .fill
        playButton.setImage(UIImage(systemName: "play.fill")!, for:.normal)
        
        videoButton.tintColor = .label
        videoButton.contentVerticalAlignment = .fill
        videoButton.contentHorizontalAlignment = .fill
                                               
        airplayButton.activeTintColor = .systemOrange
        airplayButton.tintColor = .label

        volumeSlider.showsVolumeSlider = true
        volumeSlider.setVolumeThumbImage(UIImage(systemName: "speaker.2")!, for: .normal)
        volumeSlider.showsRouteButton = false

        
        addSubview(mainImage)
        addSubview(playButton)
        addSubview(videoButton)
        addSubview(airplayButton)
        addSubview(volumeSlider)
        
        
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let guide = safeAreaLayoutGuide;
        let portraitFrame = UIScreen.screenSize
        let landscapeFrame = CGRect(origin: .zero,
                                    size: CGSize(width: portraitFrame.height, height: portraitFrame.width))
        let sixteenByNine: CGFloat  = 16.0 / 9.0;
        
        switch (UIDevice.current.userInterfaceIdiom) {
        case .phone:
            portraitConstraints = [
                mainImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor, multiplier: sixteenByNine),
                mainImage.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier:  0.9),
                mainImage.bottomAnchor.constraint(equalTo: guide.centerYAnchor),
                
                playButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
                playButton.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.06),
                playButton.topAnchor.constraint(equalTo: mainImage.centerYAnchor, constant: portraitFrame.height * 0.25),

                airplayButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                airplayButton.widthAnchor.constraint(equalTo: airplayButton.heightAnchor),
                airplayButton.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.025),
                airplayButton.leftAnchor.constraint(equalTo: volumeSlider.leftAnchor),

                videoButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                videoButton.widthAnchor.constraint(equalTo: airplayButton.heightAnchor),
                videoButton.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.025),
                videoButton.rightAnchor.constraint(equalTo: volumeSlider.rightAnchor),

                volumeSlider.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                volumeSlider.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier:  0.8),
                volumeSlider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: portraitFrame.height * 0.07),
                volumeSlider.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.2),
            ]
            landscapeConstraints = [
                mainImage.rightAnchor.constraint(equalTo: guide.centerXAnchor),
                mainImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor, multiplier: sixteenByNine),
                mainImage.widthAnchor.constraint(equalToConstant: landscapeFrame.size.width * 0.48),

                playButton.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
                playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
                playButton.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.06),
                playButton.leftAnchor.constraint(equalTo: guide.centerXAnchor, constant: landscapeFrame.size.width * 0.25),

                airplayButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                airplayButton.widthAnchor.constraint(equalTo: airplayButton.heightAnchor),
                airplayButton.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.025),
                airplayButton.leftAnchor.constraint(equalTo: volumeSlider.leftAnchor),

                videoButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                videoButton.widthAnchor.constraint(equalTo: airplayButton.heightAnchor),
                videoButton.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.025),
                videoButton.rightAnchor.constraint(equalTo: volumeSlider.rightAnchor),

                volumeSlider.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
                volumeSlider.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier:  0.4),
                volumeSlider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: landscapeFrame.size.height * 0.1),
                volumeSlider.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.2)
            ]
        case .pad:
            portraitConstraints = [
                mainImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor, multiplier: sixteenByNine),
                mainImage.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier:  0.95),
                mainImage.bottomAnchor.constraint(equalTo: guide.centerYAnchor),

                playButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
                playButton.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.06),
                playButton.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: portraitFrame.height * 0.2),

                airplayButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                airplayButton.widthAnchor.constraint(equalTo: airplayButton.heightAnchor),
                airplayButton.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.025),
                airplayButton.leftAnchor.constraint(equalTo: volumeSlider.leftAnchor),

                videoButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                videoButton.widthAnchor.constraint(equalTo: airplayButton.heightAnchor),
                videoButton.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.025),
                videoButton.rightAnchor.constraint(equalTo: volumeSlider.rightAnchor),

                volumeSlider.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                volumeSlider.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier:  0.4),
                volumeSlider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: portraitFrame.height * 0.07),
                volumeSlider.heightAnchor.constraint(equalToConstant: portraitFrame.height * 0.15)
            ]
            landscapeConstraints = [
                mainImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor, multiplier: sixteenByNine),
                mainImage.widthAnchor.constraint(equalToConstant: landscapeFrame.size.width * 0.8),
                mainImage.topAnchor.constraint(equalTo: guide.topAnchor, constant: landscapeFrame.size.height * 0.005),

                playButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
                playButton.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.06),
                playButton.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: landscapeFrame.size.height * 0.05),

                airplayButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                airplayButton.widthAnchor.constraint(equalTo: airplayButton.heightAnchor),
                airplayButton.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.025),
                airplayButton.leftAnchor.constraint(equalTo: volumeSlider.leftAnchor),

                videoButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
                videoButton.widthAnchor.constraint(equalTo: airplayButton.heightAnchor),
                videoButton.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.025),
                videoButton.rightAnchor.constraint(equalTo: volumeSlider.rightAnchor),

                volumeSlider.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                volumeSlider.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier:  0.4),
                volumeSlider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: landscapeFrame.size.height * 0.05),
                volumeSlider.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.15)
            ]
        default:
            fatalError("Constraints are not implemented for this device.")
        }
 
    }
    
    
    // MARK: - ViewDelegate Methods
    func setButtonTarget(
        _ target: Any?,
        action: Selector,
        for controlEvents: UIControl.Event,
        id buttonId: Int32
    ) {
        switch (buttonId) {
        case Ids.playButton.rawValue:
            playButton.addTarget(target, action: action, for: controlEvents)
        case Ids.videoButton.rawValue:
            videoButton.addTarget(target, action: action, for: controlEvents)
        default:
            OSLog.rakoda.log(type: .fault, "MainView::Got a wrong ID for button: %ld.", buttonId)
            break
        }
    }
    
    func activateLandscapeConstraints(_ isLandscape: Bool) {
        if isLandscape {
            NSLayoutConstraint.activate(landscapeConstraints)
            NSLayoutConstraint.deactivate(portraitConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
            NSLayoutConstraint.deactivate(landscapeConstraints)
        }
    }
    
    func viewWithTag(_ viewId: Int32) -> UIView? {
        switch (viewId) { 
        case Ids.playButton.rawValue:
            return playButton
        case Ids.mainImage.rawValue:
            return mainImage
        case Ids.videoButton.rawValue:
            return videoButton
        case Ids.airplayButton.rawValue:
            return airplayButton
        case Ids.volumeControl.rawValue:
            return volumeSlider
        default:
            return nil
        }
    }
}
