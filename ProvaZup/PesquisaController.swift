//
//  PesquisaController.swift
//  ProvaZup
//
//  Created by Diego on 20/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class PesquisaController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var films : [FilmSearch]!
    var page = 0
    var numpages = 0
    var lastSearch = ""
    var year = ""
    
    // MARK: - IBOutlet
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var tvTutorial: UITextView!
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        films = [FilmSearch]()
        
    }
    
    // MARK: - TableTiew
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return films.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //cria uma UITableViewCell para a tableview
        let cellId = "TCFilm"
        
        //pegaga uma célula caso ja tenha sido alocada
        var cell : TCFilm! = tableView.dequeueReusableCell(withIdentifier: cellId) as? TCFilm
        
        //verifica se precisa alocar uma nova célula
        if (cell == nil)
        {
            cell = Bundle.main.loadNibNamed("TCFilm", owner: nil, options: nil)?[0] as! TCFilm
        }
        
        //chama a função responsável por popular os dados da célula
        cell.configureWithFilme(f: films[indexPath.row])
        
        //caso tenha um scroll para o final da tableview tenta carregar mais resultados da API
        if  indexPath.row == self.films.count - 1
        {
            //verifica se existem mais resposta para chamar novamente a API
            if self.page < self.numpages{
                //chama o serviço de pesquisa com o texto pesquisado e a pagina que deseja buscar
                Service.SearchFilm(text: lastSearch,page: self.page+1, year: year, success: { result in
                    //define a pagina atual
                    self.page = self.page+1
                    //define numero máximo de paginas
                    self.numpages = result.1
                    //adiciona os novos filmes retornados da API
                    self.films! += result.0
                    //recarrega a tabela com os novos dados
                    self.tableView.reloadData()
                }, failure: { error in
                    //Mostra um alerta de erro na tela caso tenha ocorrido
                    let alert = UIAlertController(
                        title:  "\(error.domain)",
                        message: "",
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
        
        return cell
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //Mostra tela de Loading
        VLoading.showLoading()
        //chama o serviço de pesquisa dos dados do filme
        Service.SearchFilmDetails(id: films[indexPath.row].id!, success: { result in
            //Esconde a tela de loading
            VLoading.hideLoading()
            //carrega o novo ViewController
            let  vc =  DetalhesController(nibName:  "DetalhesController" , bundle:  nil )
            vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            //Mostra o Modal de detalhes do filme
            self.present (vc, animated:  true , completion:  nil)
            //Popula os dados do ViewController
            vc.configureWithFilmDetails(f: result, onDismiss: {})
        }, failure: { error in
            //esconde a tela de loading
            VLoading.hideLoading()
            //Mostra um alerta de erro na tela caso tenha ocorrido
            let alert = UIAlertController(
                title:  "\(error.domain)",
                message: "",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        })
        
        
    }
    // define o tamanho de cada célula da tableview
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    // MARK: - SearchBar
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //realiza a pesquisa somente se tenha algo digitado searchbar
        if((searchBar.text?.characters.count)! > 0){
            //esconde o teclado
            self.SearchBar.endEditing(true)
            //mostra tela de loading
            VLoading.showLoading()
            year = ""
            //define o texto da pesquisa
            lastSearch = searchBar.text!
            //verifica se existem parênteses no texto
            if let match = lastSearch.range(of: "\\(.+\\)", options: .regularExpression) {
                //pega a substring do que está contido nos parênteses
                year = lastSearch.substring(with: match)
                //remove os parênteses da esquerda e da direita
                year = String(year.characters.dropFirst().dropLast())
                //pega o valor do ano para a pesquisa
                year = year.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                //acha no texto a aonde começa o (
                let index = lastSearch.characters.index(of: "(")
                let indexTo = lastSearch.index(after: index!)
                //pega a substring contendo somente o texto da pesquisa
                lastSearch = lastSearch.substring(to: indexTo)
                // remove o caráter ( da string de pesquisa
                lastSearch = String(lastSearch.characters.dropLast())
            }
            //remove os espaços em branco do texto de pesquisa
            lastSearch = lastSearch.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //monta o texto de pesquisa subistituindo espaço por +
            lastSearch = lastSearch.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            //chama o serviço de pesquisa dos dados do filme
            Service.SearchFilm(text: lastSearch,page: 1,year: year, success: { result in
                //mostra a view de loading
                VLoading.hideLoading()
                //esconde o texto de tutorial
                self.tvTutorial.isHidden = true
                //mostra a tablewview
                self.tableView.isHidden = false
                //define a pagina atual
                self.page = 1
                //define numero máximo de paginas
                self.numpages = result.1
                //adiciona os filmes retornados da API
                self.films = result.0
                //recarrega a tabela com os novos dados
                self.tableView.reloadData()
            }, failure: { error in
                 //Mostra um alerta de erro na tela caso tenha ocorrido
                VLoading.hideLoading()
                let alert = UIAlertController(
                    title:  "\(error.domain)",
                    message: "",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else {
             //Mostra um alerta de aviso
            let alert = UIAlertController(
                title:  "Aviso",
                message: "A pesquisa deve conter algum caráter",
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
    
    //Caso o foco esteja no searchBar mostra o botão de cancelar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: false)
    }
    //Caso o foco saia do searchBar esconde o botão de cancelar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
    }
    
    //esconde o teclado e redefine o texto de pesquisa
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = lastSearch
        searchBar.resignFirstResponder()
    }
}
