//
//  ViewController.swift
//  Rakoty Coptic Radio
//
//  Created by Samuel Aysser on 05.11.20.
//

import UIKit
import AVKit
import MediaPlayer
import os.log

class MainViewController: UIViewController, AVPlayerViewControllerDelegate {

    // MARK: - Members
    
    private var mainView: MainView?     = nil
    private var isPlaying: Bool         = false {
        didSet {
            guard let playButton = playButton,
                  let playImage = UIImage(systemName: "play.fill"),
                  let pauseImage = UIImage(systemName: "pause.circle.fill"),
                  let player = audioPlayer
                  else {
                OSLog.rakoda.log(type: .fault, "MainViewController::isPlaying::didSet::one of the needed objects is nil.")
                return
            }
            
            if isPlaying {
                playButton.setImage(pauseImage, for: .normal)
                player.play()
            } else {
                playButton.setImage(playImage, for: .normal)
                player.pause()
            }
        }
    }
    private var audioPlayer: AVPlayer?   = nil
    
    private weak var playButton: UIButton?  = nil
    private var currentImageIndex: Int32 = 0
    private var timer: DispatchSourceTimer? = nil
    
    private var churchImages: ContiguousArray<UIImage> = []
    private let churchImageTransition = CATransition()
    
    private var videoVC: AVPlayerViewController? = nil
    private var isPlayingVideo = false
    
    
    
    // MARK: - Constants
    
    private static let rakotyAudioUrl = "http://sc-e1.streamcyclone.com:1935/rakoty_live/rakotyaudio/playlist.m3u8"
    private static let rakotyVideoUrl = "http://sc-e1.streamcyclone.com/rakoty_live/rakoty/playlist.m3u8"
    
    
    // MARK: - View Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OSLog.rakoda.log(type: .debug, "MainViewController::Entered did load.")
        
        // ---------------------------------------------------------------------
        // CREATE IMAGES ON OTHER THREAD
        // ---------------------------------------------------------------------
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else {
                OSLog.rakoda.log(type: .fault, "MainViewController::DQ::self is nil.")
                return
            }
            
            
            strongSelf.churchImageTransition.duration = 1.0
            strongSelf.churchImageTransition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            strongSelf.churchImageTransition.type = .fade
            
            
            for i in 1... {
                guard let image = UIImage(named:"church-\(i)") else {
                    OSLog.rakoda.log(type: .debug, "MainViewController::DQ::i reached %@.", i)
                    return
                }
                
                strongSelf.churchImages.append(image.roundedImage())
            }
        }
        
        // ---------------------------------------------------------------------
        // GENERAL SETUP
        // ---------------------------------------------------------------------
        view.backgroundColor = .systemBackground;
        
        navigationItem.title                  = "Rakoty";
        navigationItem.largeTitleDisplayMode  = .always;
        
        if let navigationController = navigationController {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        
        
        // ---------------------------------------------------------------------
        // MAIN VIEW SETUP
        // ---------------------------------------------------------------------
        let myMainView = MainView(frame: view.frame)
        
        myMainView.translatesAutoresizingMaskIntoConstraints = false
        myMainView.setButtonTarget(self,
                                   action: #selector(MainViewController.playButtonPressed),
                                   for: UIControl.Event.touchDown,
                                   id: MainView.Ids.playButton.rawValue)
        myMainView.setButtonTarget(self,
                                   action: #selector(MainViewController.videoButtonPressed),
                                   for: UIControl.Event.touchDown,
                                   id: MainView.Ids.videoButton.rawValue)
        
        stampSubview(subview: myMainView)
        myMainView.activateLandscapeConstraints(UIApplication.isCurrentInterfaceLandscape())
        if let myPlayButton = myMainView.viewWithId(MainView.Ids.playButton.rawValue) as? UIButton {
            playButton = myPlayButton
        } else {
            OSLog.rakoda.log(type: .fault, "MainViewController::Failed to get play button of MainView.")
        }
        
        mainView = myMainView
        
        // ---------------------------------------------------------------------
        // MEDIA PLAYING SETUP
        // ---------------------------------------------------------------------
        //isPlaying = false
        if let rakotyUrl = URL(string: MainViewController.rakotyAudioUrl) {
            let playerItem = AVPlayerItem(url: rakotyUrl)
            audioPlayer = AVPlayer()
            audioPlayer!.replaceCurrentItem(with: playerItem)
        } else {
            OSLog.rakoda.log(type: .fault, "MainViewController::Failed to create audio streaming url for rakoty.")
        }
        
        if let rakotyUrl2 = URL(string: MainViewController.rakotyVideoUrl) {
            let player = AVPlayer(url: rakotyUrl2)
            
            videoVC = AVPlayerViewController()
            videoVC!.player = player
            videoVC!.delegate = self
        } else {
            OSLog.rakoda.log(type: .fault, "MainViewController::Failed to create video streaming url for rakoty.")
        }
        
        setupRemoteCommandCenter()
        
        OSLog.rakoda.log(type: .debug, "MainViewController::viewDidLoad() is done.")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let timer = timer {
            if !timer.isCancelled {
                timer.cancel()
            }
            
            self.timer = nil
        }
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global(qos: .background))
        
        //OSLog.rakoda.log(type: .debug, "MainViewController::ViewWillAppear::Start.")
        
//        timer?.schedule(wallDeadline: DispatchWallTime.now() + .seconds(5),
//                        repeating: .seconds(5), leeway: .seconds(1))
        

        timer?.setRegistrationHandler() { OSLog.rakoda.log(type: .debug, "MainViewController::TimerEventHandler::from register handler.") }
        timer?.setCancelHandler() { OSLog.rakoda.log(type: .debug, "MainViewController::TimerEventHandler::from cancellation handler.") }
        
        timer?.schedule(wallDeadline: DispatchWallTime.now() + .seconds(15),
                        repeating: .seconds(20), leeway: .seconds(1))
        
        
        timer?.setEventHandler() { [weak self] in
            
            //OSLog.rakoda.log(type: .debug, "MainViewController::TimerEventHandler::from event.")
            
            guard let strongSelf = self else {
                OSLog.rakoda.log(type: .fault, "MainViewController::TimerEventHandler::self is nil.")
                return
            }
            
            if strongSelf.churchImages.isEmpty {
                OSLog.rakoda.log(type: .debug, "MainViewController::TimerEventHandler::No church images were found.")
                return
            }
            
            var cancelTimer = false
            defer {
                if cancelTimer {
                    strongSelf.timer?.cancel()
                }
            }
            guard let imageView = strongSelf.mainView?.viewWithId(MainView.Ids.mainImage.rawValue) as? UIImageView else {
                OSLog.rakoda.log(type: .fault, "MainViewController::TimerEventHandler::imageView is nil.")
                cancelTimer = true
                
                return
            }
            
            let churchImagesCount = strongSelf.churchImages.count
            let newIndex = strongSelf.currentImageIndex + 1
            
            strongSelf.currentImageIndex =
                newIndex >= churchImagesCount ? 0 : newIndex
            
            let images = strongSelf.churchImages
            let i = Int(strongSelf.currentImageIndex)
            let transition = strongSelf.churchImageTransition
            
            //OSLog.rakoda.log(type: .debug, "MainViewController::TimerEventHandler::Before DQ.")
            DispatchQueue.main.sync { [weak imageView,
                                       weak transition,
                                       weak strongSelf] in
                //OSLog.rakoda.log(type: .debug, "MainViewController::TimerEventHandler::DQ::From DQ.")
                
                guard let imageView = imageView,
                      let transition = transition,
                      let isPlayingVideo = strongSelf?.isPlayingVideo
                      else {
                    OSLog.rakoda.log(type: .fault, "MainViewController::TimerEventHandler::DQ::imageView or transition or self is nil.")
                    
                    return
                }
                
                if isPlayingVideo {
                    OSLog.rakoda.log(type: .fault,
                                     "MainViewController::TimerEventHandler::DQ::isPlayingVideo is true.")
                    return
                }
                
                imageView.image = images[i]
                imageView.layer.add(transition, forKey:nil)
            }
            //OSLog.rakoda.log(type: .debug, "MainViewController::TimerEventHandler::After DQ.")
            /*
            var nullableNewImage = UIImage(named: "church-\(strongSelf.currentImageIndex)")
            if nullableNewImage == nil {
                strongSelf.currentImageIndex = 1
                nullableNewImage = UIImage(named: "church-1")
            }
            
            strongSelf.currentImageIndex += 1
            
            guard let newImage = nullableNewImage else {
                OSLog.rakoda.log(type: .fault, "MainViewController::TimerEventHandler::Couldn't get new image.")
                cancelTimer = true
                
                return
            }
            
            imageView.image = newImage.roundedImage()
            
            let transition = CATransition()
            transition.duration = 1.0
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.type = .fade;

            imageView.layer.add(transition, forKey:nil)
            */
        }
        
        OSLog.rakoda.log(type: .debug, "MainViewController::ViewWillAppear::End.")
        
        /*
         self.currentImageIndex = 3;
         if (self.imageChangerTimer) {
             if (dispatch_source_testcancel(self.imageChangerTimer) == 0)
                 dispatch_source_cancel(self.imageChangerTimer);
             self.imageChangerTimer = nil;
         }
         
         self.imageChangerTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                         0,
                                                         0,
                                                         dispatch_get_main_queue());
         dispatch_source_set_timer(self.imageChangerTimer,
                                   dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC),
                                   //DISPATCH_TIME_NOW,
                                   60 * NSEC_PER_SEC,
                                   NSEC_PER_SEC);
         
         dispatch_source_set_event_handler(self.imageChangerTimer,
                                           ^() {
             
             UIView *const imageGenericView = [self.audioPlayerView viewFromId:SBSAudioSubviewMainImage];
             
             if (![imageGenericView isKindOfClass:[UIImageView class]]) {
                 dispatch_source_cancel(self.imageChangerTimer);
                 return;
             }
             
             UIImageView *const imageView = (UIImageView *)imageGenericView;
             NSString *const imageName = [NSString stringWithFormat:@"church-%lu", self.currentImageIndex];
             UIImage *newImage = [UIImage imageNamed:imageName];
             
             if (!newImage) {
                 self.currentImageIndex = 2;
                 newImage = [UIImage imageNamed:@"church-1"];
             }
             else {
                 self.currentImageIndex += 1;
             }
             
             if (!newImage) {
                 dispatch_source_cancel(self.imageChangerTimer);
                 return;
             }
             
             imageView.image = [newImage roundedImage] ;

             CATransition *const transition = [CATransition animation];
             transition.duration = 1.0f;
             transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
             transition.type = kCATransitionFade;

             [imageView.layer addAnimation:transition forKey:nil];
         });
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        OSLog.rakoda.log(type: .debug, "MainViewController::viewDidAppear::Called.")
        
        currentImageIndex = 0
        isPlayingVideo = false
        
        timer?.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        OSLog.rakoda.log(type: .debug, "MainViewController::viewWillDisappear::Called.")
        
        timer?.cancel()
        timer = nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with: coordinator)
        
        OSLog.rakoda.log(type: .debug, "MainViewController::viewWillTransition::Called.")
        
        mainView?.activateLandscapeConstraints(size.width > size.height)
    }
    
    
    // MARK: - Stream Methods
    private func playStream(_ yesOrNo: Bool) {
        if yesOrNo == isPlaying {
            return
        }
        
        isPlaying = yesOrNo
    }

    
    // MARK: - Button Methods
    
    @objc func playButtonPressed() {
        OSLog.rakoda.log(type: .debug, "MainViewController::playButtonPressed::Pressed.")
        playStream(!isPlaying)
        //MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
    }
    @objc func videoButtonPressed() {
        OSLog.rakoda.log(type: .debug, "MainViewController::videoButtonPressed::Pressed.")
        guard let videoVC = videoVC else {
            OSLog.rakoda.log(type: .fault, "MainViewController::videoButtonPressed::videoVC is nil.")
            return
        }
        
        present(videoVC,
                animated: true) { [weak self] in
            self?.isPlayingVideo = true
            OSLog.rakoda.log(type: .fault, "MainViewController::videoVC::videoVC presented.")
        }
    }
    
    
    // MARK: - MediaPlayer Methods
    
    @objc func handleMediaPlayerCommand(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        let commandCenter: MPRemoteCommandCenter = MPRemoteCommandCenter.shared()
        
        if event.command === commandCenter.playCommand {
            OSLog.rakoda.log(type: .debug, "MainViewController::MediaPlayer play command.")
            playStream(true)
        } else if event.command === commandCenter.pauseCommand {
            OSLog.rakoda.log(type: .debug, "MainViewController::MediaPlayer pause command.")
            playStream(false)
        } else {
            OSLog.rakoda.log(type: .fault, "MainViewController::Unknown MediaPlayer command.")
            //return .noActionableNowPlayingItem
        }
        
        return .success
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        
        commandCenter.playCommand.addTarget(self, action: #selector(handleMediaPlayerCommand(_:)))
        commandCenter.pauseCommand.addTarget(self, action: #selector(handleMediaPlayerCommand(_:)))
        
        /*
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .moviePlayback,
                options: [] //[.duckOthers, .mixWithOthers]
            )
            os_log("Setup of AVAudioSession succedded.",
                   log: OSLog.rakodaLog,
                   type: .debug)
        } catch {
            os_log("Setup of AVAudioSession Failed.\nError: %@",
                   log: OSLog.rakodaLog,
                   type: .error,
                   error.localizedDescription)
            
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            os_log("AVAudioSession is now set to active.",
                   log: OSLog.rakodaLog,
                   type: .debug)
        } catch {
            os_log("Failed to set AVAudioSession to active.\nError: %@",
                   log: OSLog.rakodaLog,
                   type: .error,
                   error.localizedDescription)
        }
        */
        
        setupNowPlaying()
    }
    
    private func setupNowPlaying() {
        let image = UIImage(named: "church-1")
        var artwork: MPMediaItemArtwork? = nil
        if let image = image {
            artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                image
            }
        } else {
            OSLog.rakoda.log(type: .fault, "MainViewController::Image for MPPlayer was not found.")
        }
        
        let nowPlayingInfo: [String : Any] = [
            MPMediaItemPropertyTitle : "Rakoty",
            MPMediaItemPropertyArtist : "St. George Church",
            MPNowPlayingInfoPropertyElapsedPlaybackTime : 0.0,
            MPMediaItemPropertyPlaybackDuration : 0.0,
            MPNowPlayingInfoPropertyPlaybackRate : 0.0,
            MPMediaItemPropertyArtwork : artwork as Any
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    // MARK: - AVPlayerViewControllerDelegate Method
}

