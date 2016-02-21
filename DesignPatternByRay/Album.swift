//
//  Album.swift
//  DesignPatternByRay
//
//  Created by Hiep Nguyen on 2/20/16.
//  Copyright © 2016 Zyncas. All rights reserved.
//

import Foundation

class Album: NSObject {
    
    var title: String!
    
    var artist: String!
    
    var genre: String!
    
    var coverURL: String!
    
    var year: String!
    
    init(title: String, artist: String, genre: String, coverURL: String, year: String) {
        
        super.init()
        
        self.title = title
        
        self.artist = artist
        
        self.genre = genre
        
        self.coverURL = coverURL
        
        self.year = year
    }
    
    override var description: String {
        
        return "Title: \(title)" + "Artist: \(artist)" + "Genre: \(genre)" + "CoverURL: \(coverURL)" + "Year: \(year)"
    }
}


