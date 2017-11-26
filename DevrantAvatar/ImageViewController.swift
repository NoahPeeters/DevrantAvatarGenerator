//
//  ImageViewController.swift
//  DevrantAvatar
//
//  Created by Noah Peeters on 10/28/17.
//  Copyright © 2017 Noah Peeters. All rights reserved.
//

import Cocoa

class ImageViewController: NSViewController, AvatarLoaderDelegate {
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    
    var imageView: ImageView {
        return view as! ImageView
    }
    
    override func viewDidLoad() {
        AvatarLoader.default.delegate = self
        loadingIndicator.startAnimation(self)
    }
    
    func avatarLoader(_ avatarLoader: AvatarLoader, didStartedLoading avatar: Avatar) {
        loadingIndicator.isHidden = false
    }
    
    func avatarLoader(_ avatarLoader: AvatarLoader, didGetProgressUpdate progress: Progress) {
        loadingIndicator.doubleValue = progress.fractionCompleted
    }
    
    func avatarLoader(_ avatarLoader: AvatarLoader, didFinishedLoading avatar: Avatar, withError error: String) {
        loadingIndicator.isHidden = true
    }
    
    func avatarLoader(_ avatarLoader: AvatarLoader, didFinishLoading avatar: Avatar, withImage image: NSImage) {
        loadingIndicator.isHidden = true
        imageView.image = image
    }
}


