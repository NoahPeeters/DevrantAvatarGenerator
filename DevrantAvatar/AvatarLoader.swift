//
//  AvatarLoader.swift
//  DevrantAvatar
//
//  Created by Noah Peeters on 10/28/17.
//  Copyright © 2017 Noah Peeters. All rights reserved.
//

import Cocoa
import Alamofire

class AvatarLoader {
    static let `default`: AvatarLoader = AvatarLoader()
    private init() {}
    
    public weak var delegate: AvatarLoaderDelegate?
    private var request: Request?
    private let baseURL = URL(string: "https://avatars.devrant.com")!
    
    func loadAvatar(_ avatar: Avatar, withFileType fileType: AvatarFileType = .png) {
        let url = avatar.url(withBaseURL: baseURL, withFileType: fileType)
        
        request?.cancel()
        request = Alamofire.request(url)
            .downloadProgress { [weak self] progress in
                guard let unwrappedSelf = self else { return }
                unwrappedSelf.delegate?.avatarLoader(unwrappedSelf, didGetProgressUpdate: progress)
            }
            .responseData { [weak self] response in
                guard let unwrappedSelf = self else { return }
                
                guard let imageData = response.result.value else {
                    unwrappedSelf.delegate?.avatarLoader(unwrappedSelf,
                         didFinishedLoading: avatar, withError: "Request failed!"
                    )
                    return
                }
                
                guard let image = NSImage(data: imageData) else {
                    unwrappedSelf.delegate?.avatarLoader(unwrappedSelf,
                         didFinishedLoading: avatar, withError: "Image conversion failed!"
                    )
                    return
                }
                
                unwrappedSelf.delegate?.avatarLoader(unwrappedSelf, didFinishLoading: avatar, withImage: image)
            }
        
        delegate?.avatarLoader(self, didStartedLoading: avatar)
    }
}

protocol AvatarLoaderDelegate: class {
    func avatarLoader(_ avatarLoader: AvatarLoader, didStartedLoading avatar: Avatar)
    func avatarLoader(_ avatarLoader: AvatarLoader, didGetProgressUpdate progress: Progress)
    func avatarLoader(_ avatarLoader: AvatarLoader, didFinishedLoading avatar: Avatar, withError error: String)
    func avatarLoader(_ avatarLoader: AvatarLoader, didFinishLoading avatar: Avatar, withImage image: NSImage)
}
