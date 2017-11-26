//
//  ImageView.swift
//  DevrantAvatar
//
//  Created by Noah Peeters on 10/29/17.
//  Copyright © 2017 Noah Peeters. All rights reserved.
//

import Cocoa
import AVFoundation

class ImageView: NSView {

    var image: NSImage? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var backgroundColor: NSColor? = nil
    
    override func draw(_ dirtyRect: NSRect) {
        if let backgroundColor = backgroundColor {
            backgroundColor.setFill()
            dirtyRect.fill()
        }
        
        guard let image = image else {
            super.draw(dirtyRect)
            return
        }
        
        let drawRect = AVMakeRect(aspectRatio: image.size, insideRect: bounds)
        image.draw(in: drawRect)
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let image = image else {
            return
        }
        
        let draggingItem = NSDraggingItem(pasteboardWriter: image)
        let draggingFrame = AVMakeRect(aspectRatio: image.size, insideRect: bounds)

        draggingItem.setDraggingFrame(draggingFrame, contents: image)

        draggingItem.imageComponentsProvider = {
            let component = NSDraggingImageComponent(key: NSDraggingItem.ImageComponentKey.icon)
            component.contents = image
            component.frame = NSRect(origin: NSPoint(), size: draggingFrame.size)
            return [component]
        }

        let session = self.beginDraggingSession(with: [draggingItem], event: event, source: self)

        session.draggingFormation = .stack
        
    }
}

extension ImageView: NSDraggingSource {
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .copy
    }
}
