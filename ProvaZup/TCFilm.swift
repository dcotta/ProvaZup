//
//  TCFilm.swift
//  ProvaZup
//
//  Created by Diego on 21/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class TCFilm: UITableViewCell {

    var film : FilmSearch!
    
    // MARK: - IBOutlet
    @IBOutlet var tvTitle: UITextView!
    @IBOutlet var ivPoster: UIImageView!
    
    // MARK: - Init Values
    func configureWithFilme(f: FilmSearch) {
        film = f
        //define o titulo da label
        tvTitle.text = "\(film.title!) (\(film.year!))"
        
        //faz o download da imagem ou carrega da cache
        ImageUtils.cachedImage(path: film.poster!, onFinish: { (image) in
            //testa se a imagem foi baixado corretamente
            if let image = image {
                //define a imagem da view apos ser carregada
                self.ivPoster!.image = image
            }
        })

    }
    
}
