//
//  Album.swift
//  DesignPatternByRay
//
//  Created by Hiep Nguyen on 2/20/16.
//  Copyright © 2016 Zyncas. All rights reserved.
//

import Foundation

class Album: NSObject, NSCoding {
    
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
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.title = aDecoder.decodeObjectForKey("title") as! String
        
        self.artist = aDecoder.decodeObjectForKey("artist") as! String
        
        self.genre =  aDecoder.decodeObjectForKey("genre") as! String
        
        self.coverURL = aDecoder.decodeObjectForKey("cover_URL") as! String
        
        self.year = aDecoder.decodeObjectForKey("year") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(title, forKey: "title")
        
        aCoder.encodeObject(artist, forKey: "artist")
        
        aCoder.encodeObject(genre, forKey: "genre")
        
        aCoder.encodeObject(coverURL, forKey: "cover_URL")
        
        aCoder.encodeObject(year, forKey: "year")
    }
    
    override var description: String {
        
        return "Title: \(title)" + "Artist: \(artist)" + "Genre: \(genre)" + "CoverURL: \(coverURL)" + "Year: \(year)"
    }
}


