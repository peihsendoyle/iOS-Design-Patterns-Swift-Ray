//
//  PersistencyManager.swift
//  DesignPatternByRay
//
//  Created by Hiep Nguyen on 2/20/16.
//  Copyright © 2016 Zyncas. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    private var albums = [Album]()
    
    override init() {
        
        super.init()
        
        if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")) {
            
            let unarchivedAlbums = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Album]?
            
            if let unwrappedAlbum = unarchivedAlbums {
                
                albums = unwrappedAlbum
            }
        } else {
            
            createPlaceholderAlbum()
        }
        
    }
    
    func createPlaceholderAlbum() {
    
        //Dummy list of albums
        let album1 = Album(title: "Best of Bowie",
            artist: "David Bowie",
            genre: "Pop",
            coverURL: "http://i855.photobucket.com/albums/ab115/tieushinshin/IMG_1191_zps9xm3vfnv.jpg",
            year: "1992")
        
        let album2 = Album(title: "It's My Life",
            artist: "No Doubt",
            genre: "Pop",
            coverURL: "http://i855.photobucket.com/albums/ab115/tieushinshin/IMG_1191_zps9xm3vfnv.jpg",
            year: "2003")
        
        let album3 = Album(title: "Nothing Like The Sun",
            artist: "Sting",
            genre: "Pop",
            coverURL: "http://i855.photobucket.com/albums/ab115/tieushinshin/IMG_1191_zps9xm3vfnv.jpg",
            year: "1999")
        
        let album4 = Album(title: "Staring at the Sun",
            artist: "U2",
            genre: "Pop",
            coverURL: "http://i855.photobucket.com/albums/ab115/tieushinshin/IMG_1191_zps9xm3vfnv.jpg",
            year: "2000")
        
        let album5 = Album(title: "American Pie",
            artist: "Madonna",
            genre: "Pop",
            coverURL: "http://i855.photobucket.com/albums/ab115/tieushinshin/IMG_1191_zps9xm3vfnv.jpg",
            year: "2000")
        
        albums = [album1, album2, album3, album4, album5]
        
        saveAlbums()
    }
    
    func saveAlbums() {
        
        let filename = NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(albums)
        
        data.writeToFile(filename, atomically: true)
    }
    
    func getAlbums() -> [Album] {
        
        return albums
    }
    
    func addAlbum(album: Album, index: Int) {
        
        if albums.count >= index {
            
            albums.insert(album, atIndex: index)
        
        } else {
            
            albums.append(album)
        }
    }
    
    func deleteAlbumAtIndex(index: Int) {
        
        albums.removeAtIndex(index)
    }
    
    func saveImage(image: UIImage, filename: String) {
        
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        
        let data = UIImagePNGRepresentation(image)
        
        data?.writeToFile(path, atomically: true)
    }
    
    func getImage(filename: String) -> UIImage? {
        
        let path = NSHomeDirectory().stringByAppendingString("/DOcuments/\(filename)")
        
        let data: NSData?
        
        do {
            
        data = try NSData(contentsOfFile: path, options: .UncachedRead)
        
        } catch {
            
            return nil
            
        }
        
        return UIImage(data: data!)
    }
    
    
}































