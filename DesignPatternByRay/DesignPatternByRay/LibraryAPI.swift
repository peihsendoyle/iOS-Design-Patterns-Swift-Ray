//
//  LibraryAPI.swift
//  DesignPatternByRay
//
//  Created by Hiep Nguyen on 2/20/16.
//  Copyright © 2016 Zyncas. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    
    class var sharedInstance: LibraryAPI {
        
        struct Singleton {
            
            static let instance = LibraryAPI()
        }
        
        return Singleton.instance
    }
    
    private let persistencyManager: PersistencyManager
    
    private let httpClient: HTTPClient
    
    private let isOnline: Bool
    
    override init() {
        
        persistencyManager = PersistencyManager()
        
        httpClient = HTTPClient()
        
        isOnline = false
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "downloadImage:", name: "BLDownloadImageNotification", object: nil)
    }
    
    func getAlbums() -> [Album] {
        
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(album: Album, index: Int) {
        
        persistencyManager.addAlbum(album, index: index)
        
        if isOnline {
            
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbum(index: Int) {
        
        persistencyManager.deleteAlbumAtIndex(index)
        
        if isOnline {
            
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    func downloadImage(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        
        let imageView = userInfo["imageView"] as! UIImageView?
        
        let coverURL = userInfo["coverURL"] as! String
        
        if let imageViewUnwrapped = imageView {
            
            imageViewUnwrapped.image = persistencyManager.getImage(coverURL) //TODO: lastPathComponent
            
            if imageViewUnwrapped.image == nil {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    
                    let downloadedImage = self.httpClient.downloadImage(coverURL)
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        
                        imageViewUnwrapped.image = downloadedImage
                        
                        self.persistencyManager.saveImage(downloadedImage, filename: coverURL)
                    })
                })
            }
        }
    }
}

















