//
//  AlbumView.swift
//  DesignPatternByRay
//
//  Created by Hiep Nguyen on 2/20/16.
//  Copyright © 2016 Zyncas. All rights reserved.
//

import Foundation

import UIKit

class AlbumView: UIView {
    
    private var coverImage: UIImageView!
    
    private var indicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    init(frame: CGRect, albumCover: String) {
        
        super.init(frame: frame)
        
        commonInit()
        
        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self, userInfo: ["imageView": coverImage, "coverURL": albumCover])
        
        coverImage.addObserver(self, forKeyPath: "image", options: .Prior, context: nil)
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        coverImage.removeObserver(self, forKeyPath: "image")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "image" {
            
            indicator.stopAnimating()
        }
    }
    
    func commonInit() {
        
        backgroundColor = UIColor.blackColor()
        
        coverImage = UIImageView(frame: CGRect(x: 5.0, y: 5.0, width: frame.size.width - 10, height: frame.size.height - 10))
        
        addSubview(coverImage)
        
        indicator = UIActivityIndicatorView()
        
        indicator.center = center
        
        indicator.activityIndicatorViewStyle = .WhiteLarge
        
        indicator.startAnimating()
        
        addSubview(indicator)
    }
    
    func highlightAlbum (didHighlightView: Bool) {
        
        if didHighlightView == true {
            
            backgroundColor = UIColor.whiteColor()
        
        } else {
            
            backgroundColor = UIColor.blackColor()
        }
    }
}













