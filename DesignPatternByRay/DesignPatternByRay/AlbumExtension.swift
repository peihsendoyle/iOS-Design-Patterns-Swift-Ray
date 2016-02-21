//
//  AlbumExtension.swift
//  DesignPatternByRay
//
//  Created by Hiep Nguyen on 2/20/16.
//  Copyright © 2016 Zyncas. All rights reserved.
//

import Foundation

extension Album {
    
    func ae_tableRepresentation() -> (titles: [String], values: [String]) {
        
        return (["Artirst", "Album", "Genre", "Year"],[artist, title, genre, year])
    }
}
