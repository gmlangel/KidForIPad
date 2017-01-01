//  可以接受拖拽内容的面板
//  DropView.swift
//  KidForIPad
//
//  Created by guominglong on 16/12/30.
//  Copyright © 2016年 KidForMac. All rights reserved.
//

import Foundation
class DropView: NSView {
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        self.register(forDraggedTypes: [NSFilenamesPboardType])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.copy;
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true;
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let arr = sender.draggingPasteboard().propertyList(forType: NSFilenamesPboardType) as? [String];
        if arr != nil && arr!.count > 0{
            let dicPath = arr![0];
            
            NSLog(dicPath)
        }
        return true;
    }
}
