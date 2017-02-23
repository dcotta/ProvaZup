//
//  Film.swift
//  ProvaZup
//
//  Created by Diego on 20/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import Foundation

class FilmSearch
{
    
    var id : String?
    var title : String?
    var year : String?
    var poster : String?
    
    // MARK: - Init
    convenience init(json : [String:AnyObject]) {
        self.init()
        
        self.id = json["imdbID"] as? String
        
        self.title = json["Title"] as? String
        
        self.year = json["Year"] as? String
        
        self.poster = json["Poster"] as? String
        
    }
    
}
