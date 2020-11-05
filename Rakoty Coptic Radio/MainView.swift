//
//  MainView.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import UIKit
import AVKit
import MediaPlayer

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
    
    private let portraitConstraints: [NSLayoutConstraint]
    private let landscapeConstraints: [NSLayoutConstraint]
    
    
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
        
        setupConstraints()
        
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
        
        //[self setupConstraints];
    }
    
    private func setupConstraints() {
        let guide = safeAreaLayoutGuide;
        let portraitFrame = UIScreen.screenSize
        let landscapeFrame = CGRect(origin: .zero,
                                    size: CGSize(width: portraitFrame.height, height: portraitFrame.width))
        let sixteenByNine  = 16.0 / 9.0;
        
        switch (UIDevice.current.userInterfaceIdiom) {
        case .phone:
            portraitConstraints = [
                mainImage.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                mainImage.widthAnchor.constraint(equalToAnchor: mainImage.heightAnchor, multiplier: sixteenByNine),
                mainImage.widthAnchor.constraint(equalToAnchor: guide.widthAnchor, multiplier:  0.9),
                mainImage.bottomAnchor.constraint(equalToAnchor: guide.centerYAnchor),
                
                playButton.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                playButton.widthAnchor.constraint(equalToAnchor: playButton.heightAnchor),
                playButton.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.06),
                playButton.topAnchor.constraint(equalToAnchor: mainImage.centerYAnchor, constant: portraitFrame.size.height * 0.25),

                airplayButton.centerYAnchor.constraint(equalToAnchor: playButton.centerYAnchor),
                airplayButton.widthAnchor.constraint(equalToAnchor: airplayButton.heightAnchor),
                airplayButton.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.025),
                airplayButton.leftAnchor.constraint(equalToAnchor: volumeSlider.leftAnchor),
                
                videoButton.centerYAnchor.constraint(equalToAnchor: playButton.centerYAnchor),
                videoButton.widthAnchor.constraint(equalToAnchor: airplayButton.heightAnchor),
                videoButton.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.025),
                videoButton.rightAnchor.constraint(equalToAnchor: volumeSlider.rightAnchor),

                volumeSlider.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                volumeSlider.widthAnchor.constraint(equalToAnchor: guide.widthAnchor, multiplier:  0.8),
                volumeSlider.topAnchor.constraint(equalToAnchor: playButton.bottomAnchor, constant: portraitFrame.size.height * 0.07),
                volumeSlider.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.2)
            ]
            landscapeConstraints = [
                mainImage.rightAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                mainImage.centerYAnchor.constraint(equalToAnchor: guide.centerYAnchor),
                mainImage.widthAnchor.constraint(equalToAnchor: mainImage.heightAnchor, multiplier: sixteenByNine),
                mainImage.widthAnchor.constraint(equalToConstant: landscapeFrame.size.width * 0.48),

                playButton.centerYAnchor.constraint(equalToAnchor: guide.centerYAnchor),
                playButton.widthAnchor.constraint(equalToAnchor: playButton.heightAnchor),
                playButton.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.06),
                playButton.leftAnchor.constraint(equalToAnchor: guide.centerXAnchor, constant: landscapeFrame.size.width * 0.25),

                airplayButton.centerYAnchor.constraint(equalToAnchor: playButton.centerYAnchor),
                airplayButton.widthAnchor.constraint(equalToAnchor: airplayButton.heightAnchor),
                airplayButton.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.025),
                airplayButton.leftAnchor.constraint(equalToAnchor: volumeSlider.leftAnchor),
                
                videoButton.centerYAnchor.constraint(equalToAnchor: playButton.centerYAnchor),
                videoButton.widthAnchor.constraint(equalToAnchor: airplayButton.heightAnchor),
                videoButton.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.025),
                videoButton.rightAnchor.constraint(equalToAnchor: volumeSlider.rightAnchor),

                volumeSlider.centerXAnchor.constraint(equalToAnchor: playButton.centerXAnchor),
                volumeSlider.widthAnchor.constraint(equalToAnchor: guide.widthAnchor, multiplier:  0.4),
                volumeSlider.topAnchor.constraint(equalToAnchor: playButton.bottomAnchor, constant: landscapeFrame.size.height * 0.1),
                volumeSlider.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.2)
            ]
        case .pad:
            portraitConstraints = [
                mainImage.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                mainImage.widthAnchor.constraint(equalToAnchor: mainImage.heightAnchor, multiplier: sixteenByNine),
                mainImage.widthAnchor.constraint(equalToAnchor: guide.widthAnchor, multiplier:  0.95),
                mainImage.bottomAnchor.constraint(equalToAnchor: guide.centerYAnchor),
                
                playButton.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                playButton.widthAnchor.constraint(equalToAnchor: playButton.heightAnchor),
                playButton.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.06),
                playButton.topAnchor.constraint(equalToAnchor: mainImage.bottomAnchor, constant: portraitFrame.size.height * 0.2),

                airplayButton.centerYAnchor.constraint(equalToAnchor: playButton.centerYAnchor),
                airplayButton.widthAnchor.constraint(equalToAnchor: airplayButton.heightAnchor),
                airplayButton.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.025),
                airplayButton.leftAnchor.constraint(equalToAnchor: volumeSlider.leftAnchor),
                
                videoButton.centerYAnchor.constraint(equalToAnchor: playButton.centerYAnchor),
                videoButton.widthAnchor.constraint(equalToAnchor: airplayButton.heightAnchor),
                videoButton.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.025),
                videoButton.rightAnchor.constraint(equalToAnchor: volumeSlider.rightAnchor),

                volumeSlider.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                volumeSlider.widthAnchor.constraint(equalToAnchor: guide.widthAnchor, multiplier:  0.4),
                volumeSlider.topAnchor.constraint(equalToAnchor: playButton.bottomAnchor, constant: portraitFrame.size.height * 0.07),
                volumeSlider.heightAnchor.constraint(equalToConstant: portraitFrame.size.height * 0.15)
            ]
            landscapeConstraints = [
                mainImage.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                mainImage.widthAnchor.constraint(equalToAnchor: mainImage.heightAnchor, multiplier: sixteenByNine),
                mainImage.widthAnchor.constraint(equalToConstant: landscapeFrame.size.width * 0.8),
                mainImage.topAnchor.constraint(equalToAnchor: guide.topAnchor, constant: landscapeFrame.size.height * 0.005),

                playButton.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                playButton.widthAnchor.constraint(equalToAnchor: playButton.heightAnchor),
                playButton.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.06),
                playButton.topAnchor.constraint(equalToAnchor: mainImage.bottomAnchor, constant: landscapeFrame.size.height * 0.05),

                airplayButton.centerYAnchor.constraint(equalToAnchor: playButton.centerYAnchor),
                airplayButton.widthAnchor.constraint(equalToAnchor: airplayButton.heightAnchor),
                airplayButton.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.025),
                airplayButton.leftAnchor.constraint(equalToAnchor: volumeSlider.leftAnchor),
                
                videoButton.centerYAnchor.constraint(equalToAnchor: playButton.centerYAnchor),
                videoButton.widthAnchor.constraint(equalToAnchor: airplayButton.heightAnchor),
                videoButton.heightAnchor.constraint(equalToConstant: landscapeFrame.size.height * 0.025),
                videoButton.rightAnchor.constraint(equalToAnchor: volumeSlider.rightAnchor),

                volumeSlider.centerXAnchor.constraint(equalToAnchor: guide.centerXAnchor),
                volumeSlider.widthAnchor.constraint(equalToAnchor: guide.widthAnchor, multiplier:  0.4),
                volumeSlider.topAnchor.constraint(equalToAnchor: playButton.bottomAnchor, constant: landscapeFrame.size.height * 0.05),
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
        id buttonId: UInt32) {}
    
    func activateLandscapeConstraints(_ isLandscape: Bool) {}
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
