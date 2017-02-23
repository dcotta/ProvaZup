//
//  DetalhesController.swift
//  ProvaZup
//
//  Created by Diego on 21/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

import RealmSwift

class DetalhesController: UIViewController {
    
    
    var film : FilmDetails!
    var isAdd  = false
    let realm = try! Realm()
    var onDismiss : (() -> ())? // Will run when dismissed
    
    // MARK: - IBOutlet
    @IBOutlet var tvTitle: UITextView!
    @IBOutlet var ivAction: UIImageView!
    @IBOutlet var ivPoster: UIImageView!
    @IBOutlet var tvDescripion: UITextView!
    @IBOutlet weak var btYoutube: UIButton!
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //define um observador do tamanho da textview
        tvTitle.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        //arredonda o botão
        btYoutube.layer.cornerRadius = 10
        btYoutube.layer.borderWidth = 2
        btYoutube.layer.borderColor = UIColor(red:0.91, green:0.19, blue:0.08, alpha:1.0).cgColor
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //remove o observador do tamanho da textview
        tvTitle.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //definição para mostrar o topo do textview quando carregar a viewController
        self.tvDescripion!.setContentOffset(CGPoint.zero, animated: false)
        //usado para correção do scroll do textview
        self.tvDescripion!.isEditable = false
        
    }
    
    //faz o alinhamento vertical da textview
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var topCorrect = (tvTitle.bounds.size.height - tvTitle.contentSize.height * tvTitle.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        self.tvTitle.contentInset.top = topCorrect
    }
    
    
    
    // MARK: - IBAction
    
    @IBAction func backClick() {
        self.dismiss (animated: true , completion:  self.onDismiss)
    }
    
    @IBAction func ActionClick() {
        //verifica se o filme já está salvo no banco
        if isAdd {
            try! realm.write {
                //quando o objeto é excluído do realm o objeto também é destruído da memoria
                //por isso a necessidade de fazer uma copia
                let aux = FilmDetails.copyFilm(film)
                //remove o objeto do banco
                realm.delete(film)
                //muda a imagem da ação
                ivAction.image = UIImage(named: "Save")
                isAdd = false
                film = aux
                //mostra o alerta de filme removido
                let alert = UIAlertController(
                    title:  "Filme removido com sucesso!",
                    message: "",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        } else {
            try! realm.write {
                //adiciona o objeto ao banco realm
                realm.add(film)
                //muda a imagem da ação
                ivAction.image = UIImage(named: "Remove")
                isAdd = true
                //mostra o alerta de filme salvo
                let alert = UIAlertController(
                    title:  "Filme salvo com sucesso!",
                    message: "",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func posterClick() {
        //mostra o poster em fullscreen quando clica no poster
        let newImageView = UIImageView(image: self.ivPoster.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    @IBAction func searchYoutubeClick() {
        //monta a url de busca para o youtube
        var stringURL = "http://www.youtube.com/results?search_query=" ;
        let search = film.title!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil) + "+trailer"
        stringURL += search
        let url = URL(string: stringURL);
        UIApplication.shared.openURL(url!)
        
    }

    
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        //retorna do fullscreen
        sender.view?.removeFromSuperview()
    }
    
    // MARK: - Init Values
    func configureWithFilmDetails(f: FilmDetails, onDismiss : @escaping () -> () ) {
        //define o bloco para fazer o dismiss
        self.onDismiss = onDismiss
        film = f
        //verifica se o filme já está adicionado no banco
        let filmDb = realm.objects(FilmDetails.self).filter("id LIKE '\(film.id!)'")
        if filmDb.count == 1 {
            ivAction.image = UIImage(named: "Remove")
            isAdd = true
            film = filmDb.first
        }
        
        self.tvTitle!.text = "\(self.film.title!) (\(self.film.year!))"
        self.tvDescripion!.text = "\(film.runtime!) - \(film.gerne!.replacingOccurrences(of: ",", with: " |", options: .literal, range: nil))\n\n" +
            "\(film.plot!) \n\n" +
            "Diretor: \(film.director!)" +
            "Escritor: \(film.writer!)\n\n" +
        "Atores: \(film.actors!)"
        
        ImageUtils.cachedImage(path: film.poster!, onFinish: { (image) in
            if let image = image {
                self.ivPoster!.image = image
            }
        })
        
        
    }
    
}
