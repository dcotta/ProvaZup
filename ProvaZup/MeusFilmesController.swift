//
//  MeusFilmesController.swift
//  ProvaZup
//
//  Created by Diego on 21/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit
import RealmSwift

class MeusFilmesController: UIViewController, UITableViewDelegate, UITableViewDataSource, iCarouselDelegate,iCarouselDataSource {

    
    var films = [FilmDetails]()
    let realm = try! Realm()
    
    // MARK: - IBOutlet
    @IBOutlet weak var carrossel: iCarousel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lNoFilms: UILabel!
    
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //define o tipo do carrossel
        carrossel.type = .coverFlow
        carrossel.centerItemWhenSelected = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //chamada de função para recarregar a tableview e o carrossel
        self.reloadViews()
    }
    
    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //pegaga uma célula caso ja tenha sido alocada
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        //verifica se precisa criar uma nova célula
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        
        let film = films[indexPath.row]
        //define o texto da label
        cell!.textLabel?.text = "\(film.title!) (\(film.year!))"
        //define o formato da font
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        //define o estilo de quando a célula é selecionada
        cell?.selectionStyle = .default
        return cell!

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //carrega o novo ViewController
        let  vc =  DetalhesController(nibName:  "DetalhesController" , bundle:  nil )
        vc.modalPresentationStyle = .overCurrentContext
        //Mostra o Modal de detalhes do filme
        self.tabBarController?.present(vc, animated:  true , completion:  nil)
        //Popula os dados do ViewController e passa um bloco como parâmetro para quando retorna do modal
        vc.configureWithFilmDetails(f: films[indexPath.row], onDismiss: {
            //chamada de função para recarregar a tableview e o carrossel quando o modal desaparece
            self.reloadViews()
        })
        //definição para mostrar o topo do textview quando carregar a viewController
        vc.tvDescripion!.setContentOffset(CGPoint.zero, animated: true)
        //seleciona o a imagem do carrossel
        self.carrossel!.currentItemIndex = indexPath.row
        
    }
    
    // MARK: - iCarousel
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return films.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        //cria a imagem de um poster para o carrossel
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 130, height: 180))
        //faz o download da imagem ou carrega da cache
        ImageUtils.cachedImage(path: films[index].poster!, onFinish: { (image) in
            //testa se a imagem foi baixado corretamente
            if let image = image {
                //define a imagem da view apos ser carregada
                view.image = image
            }
        })
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        //define o espaço entre as views do carrossel
        if option == iCarouselOption.spacing {
            return value * 1.2
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        //seleciona o item da tableviw correspondente ao que foi selecionado no carrossel
        if films.count > 0 {  
            tableview.selectRow(at: IndexPath(row: carousel.currentItemIndex, section: 0), animated: true, scrollPosition: .middle)
        }
    }
    
    //quando clica na view do carrossel selecionado
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        //carrega o novo ViewController
        let  vc =  DetalhesController(nibName:  "DetalhesController" , bundle:  nil )
        vc.modalPresentationStyle = .overCurrentContext
        //Mostra o Modal de detalhes do filme
        self.tabBarController?.present(vc, animated:  true , completion:  nil)
        //Popula os dados do ViewController e passa um bloco como parâmetro para quando retorna do modal
        vc.configureWithFilmDetails(f: films[index], onDismiss: {
            //chamada de função para recarregar a tableview e o carrossel quando o modal desaparece
            self.reloadViews()
        })
        
    }
    
    // MARK: - Functions
    
    func reloadViews(){
        //busca os filmes salvos no banco do realm e retorna ordenado pelo titulo
        self.films = Array(self.realm.objects(FilmDetails.self).sorted(byKeyPath: "title"))
        //verifica se existe itens salvos
        if self.films.count > 0
        {
            //mostra o carrossel e a tableview e esconde a mensagem de nenhum item salvo
            self.tableview.isHidden = false
            self.carrossel.isHidden = false
            self.lNoFilms.isHidden = true
            //recarrega a tableview e o carrossel e definindo como selecionado o primeiro elemento
            self.carrossel.reloadData()
            self.tableview.selectRow(at: IndexPath(row: self.carrossel.currentItemIndex, section: 0), animated: true, scrollPosition: .middle)
            self.tableview.reloadData()
            tableview.selectRow(at: IndexPath(row: self.carrossel.currentItemIndex, section: 0), animated: false, scrollPosition: .middle)
        } else {
            //esconde a tableview e o carrossel e mostra a mensagem de nehum item salvo
            self.tableview.isHidden = true
            self.carrossel.isHidden = true
            self.lNoFilms.isHidden = false
        }

    }
    
    
}
