//
//  FilmDetails.swift
//  ProvaZup
//
//  Created by Diego on 20/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import Foundation
import RealmSwift

class FilmDetails : Object
{
    
    dynamic var id : String?
    dynamic var title : String?
    dynamic var year : String?
    dynamic var poster : String?
    dynamic var votes : String?
    dynamic var rating : String?
    dynamic var released : String?
    dynamic var runtime : String?
    dynamic var director : String?
    dynamic var writer : String?
    dynamic var actors : String?
    dynamic var plot : String?
    dynamic var gerne : String?
    
    
    // MARK: - Init
    convenience init(json : [String:AnyObject]) {
        self.init()
        
        self.id = json["imdbID"] as? String
        self.title = json["Title"] as? String
        self.poster = json["Poster"] as? String
        self.year = json["Year"] as? String
        self.votes = json["imdbVotes"] as? String
        self.rating = json["imdbRating"] as? String
        self.released = json["Released"] as? String
        self.runtime = json["Runtime"] as? String
        self.director = json["Director"] as? String
        self.writer = json["Writer"] as? String
        self.actors = json["Actors"] as? String
        self.plot = json["Plot"] as? String
        self.gerne = json["Genre"] as? String
        
    }
    
    
    // MARK: -
    // Apontando a chave Primaria para o Realm
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //função auxiliar para copiar um FilmDetails
    static func copyFilm(_ film: FilmDetails) -> FilmDetails {
        let copy = FilmDetails()
        copy.id = film.id
        copy.title = film.title
        copy.poster = film.poster
        copy.year = film.year
        copy.votes = film.votes
        copy.rating = film.rating
        copy.released = film.released
        copy.runtime = film.runtime
        copy.director = film.director
        copy.writer = film.writer
        copy.actors = film.actors
        copy.plot = film.plot
        copy.gerne = film.gerne
        
        return copy
    }
    
    
}
