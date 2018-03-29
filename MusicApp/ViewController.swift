//
//  ViewController.swift
//  MusicApp
//
//  Created by Fathik Ahmed on 3/23/18.
//  Copyright © 2018 mxc. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController,MPMediaPickerControllerDelegate {
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var seekSlider: UISlider!
    var seekValue: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayMediaPickerAndPlayItem()
 
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        myMusicPlayer = MPMusicPlayerController()
        
        if let player = myMusicPlayer{
            player.beginGeneratingPlaybackNotifications()
            
            player.setQueue(with: mediaItemCollection)
            player.prepareToPlay()
            player.play()
            
            self.updateNowPlayingItem()
            
            mediaPicker.dismiss(animated: true, completion: nil)
        }
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    func displayMediaPickerAndPlayItem(){
        mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        
        if let picker = mediaPicker{
            
            print("Successfully instantiated a media picker")
            picker.delegate = self
            picker.prompt = "Select songs to play"
            picker.allowsPickingMultipleItems = true
            view.addSubview(picker.view)
            present(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
            notification.userInfo![key] as? NSString
        
        if let id = persistentID{
            print("Persistent ID = \(id)")
        }
        
    }
    
    func volumeIsChanged(notification: NSNotification){
        print("Volume Is Changed")
    }
    @IBAction func nextAction(_ sender: Any) {
        seekValue = 0.0
        seekSlider.setValue(0.0, animated: true)
        myMusicPlayer?.skipToNextItem()
        self.updateNowPlayingItem()

    }
    @IBAction func trackChanged(_ sender: Any) {
        let slider: UISlider = sender as! UISlider
        let changedValue: Float = slider.value
        
        if changedValue > seekValue
        {
            myMusicPlayer?.beginSeekingForward()
        }
        else
        {
            myMusicPlayer?.beginSeekingBackward()
        }
        seekValue = changedValue
        
        //self.updateNowPlayingItem()

    }
    
    @IBAction func previousAction(_ sender: Any) {
        seekValue = 0.0
        seekSlider.setValue(0.0, animated: true)

        myMusicPlayer?.skipToPreviousItem()
        self.updateNowPlayingItem()

    }
    @IBAction func PlayPauseAction(_ sender: Any) {
        
        let btn: UIButton = sender as! UIButton
        if btn.isSelected
        {
            myMusicPlayer?.play()
            btn.setImage(UIImage.init(named: "Pause"), for: .normal)
            btn.isSelected = false
            
            
        }
        else
        {
             myMusicPlayer?.pause()
            btn.setImage(UIImage.init(named: "Play"), for: .normal)
            btn.isSelected = true
        }
        
    }
    
    
    
    func updateNowPlayingItem(){
        if let nowPlayingItem=self.myMusicPlayer!.nowPlayingItem{
            let nowPlayingTitle=nowPlayingItem.title!
            
            print("title is \(String(describing: nowPlayingTitle))")
            print("track time is \(nowPlayingItem.playbackDuration/60)")
            self.nowPlayingLabel.text=String(describing: nowPlayingTitle)
        }else{
            self.nowPlayingLabel.text="Nothing Played"
        }
    }
    
    
    @IBAction func openItunesLibraryTapped(sender: AnyObject) {
         displayMediaPickerAndPlayItem()
    }


}

