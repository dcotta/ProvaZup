//
//  Service.swift
//  ProvaZup
//
//  Created by Diego on 20/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import Foundation

//Classe responsável por fazer as chamadas ao serviço
class Service
{
    
   //URL base do serviço
    fileprivate static let BASE_URL = "http://www.omdbapi.com/"
    
    // MARK: - Calls
    //Função que faz a pesquisa a partir dos filmes, retorna a uma array de FilmSearch e o numero máximo de paginas que podem ser pesquisados na API
    static func SearchFilm( text : String, page : Int, year : String, success : @escaping (([FilmSearch], Int)) -> () , failure : @escaping (NSError) -> () ) {
        //Parâmetros da pesquisa
        var params : [String:Any] = [ "s" : text, "type" : "movie", "page" : page]
        if year != "" {
            params["y"] = year
        }
        //Chama função get para receber a resposta do serviço
            Service.get (
            params,
            success: { (response ) -> () in
                
                let responseJSON = response
                //Verifica se não houve erro do serviço
                if (responseJSON["Response"] as! String).lowercased() == "true"
                {
                    var films = [FilmSearch]()
                    //realiza o parse do json
                    for film in responseJSON["Search"] as! [[String:AnyObject]]
                    {
                        films.append( FilmSearch(json: film ))
                
                    }
                    //maximo de paginas pela API é 100
                    var numPages = Int((responseJSON["totalResults"] as? String)!)! / 10
                    if numPages > 100 {
                        numPages = 100
                    }
                    
                    success( (films, numPages) )
                }
                
        },
            
            failure: failure )
    }
    
    //Função que faz a pesquisa dos dados de um Filme, retorna FilmDetails 
    static func SearchFilmDetails( id : String, success : @escaping (FilmDetails) -> () , failure : @escaping (NSError) -> () ) {
        //Parâmetro necessário para a pesquisa
        let params : [String:Any] = [ "i" : id]
        //Chama função get para receber a resposta do serviço
        Service.get (
            params,
            success: { (response ) -> () in
                
                let responseJSON = response
                //Verifica se não houve erro do serviço
                if (responseJSON["Response"] as! String).lowercased() == "true"
                {
                    //realiza o parse do json
                    let film = FilmDetails(json: responseJSON)
                    success( (film) )
                }
                
        },
            failure: failure )
    }
    
    
    // MARK: - Generic requests
    
    fileprivate static func get( _ params : [String:Any] , success : @escaping ([String:AnyObject]) -> () , failure : @escaping (NSError) -> () ){
        var completeUrl : String = BASE_URL
        //faz a montagem da query do http get
        if( params.count > 0 ){
            completeUrl += "?"
            for (key,value) in params {
                //                let customAllowedSet =  CharacterSet(charactersIn:"=\"#%/<>?@\\^`{|}. \n").inverted
                
                if !(value is NSArray)
                {
                    
                    completeUrl += "\(key)=\(String(describing: value).addingPercentEscapes(using: String.Encoding.utf8)!)&"
                } else if let array = value as? Array<AnyObject> // Treat arrays
                {
                    completeUrl += key + "="
                    for arrayEntry in array
                    {
                        completeUrl += "\(String(describing: arrayEntry).addingPercentEscapes(using: String.Encoding.utf8)!),"
                    }
                    completeUrl = completeUrl.substring( to: completeUrl.characters.index(before: completeUrl.endIndex) ) + "&"// Cut off ,
                }
            }
            completeUrl = completeUrl.substring( to: completeUrl.characters.index(before: completeUrl.endIndex) ) // Cut off &
        }
        
        
        let nsurl = URL(string: completeUrl)!
        //define a url de requisição
        let request = ASIHTTPRequest(url: nsurl)
        request?.timeOutSeconds = 60
        request?.userInfo = params
        //define o bloco de resposta caso a requisição retorne alguma falha
        request?.setFailedBlock({
            if let err = request?.error
            {
                let error = NSError(domain: err.localizedDescription, code: 2, userInfo: [:])
                failure( error )
            }
        })
        //define o bloco de exeução quando os dados são retornados da API
        request?.setCompletionBlock {
            //verifica se a API retornou um erro
            if let err = request?.error
            {
                failure( err as NSError )
            } else {
                
                do {
                    //transforma os dados em um JSON
                    let jsonResponse = try JSONSerialization.jsonObject(with: (request?.responseData())!, options: []) as! [String:AnyObject]
                    
                    //Verifica se retornou algum erro
                    if let errorCode = jsonResponse["Error"] as? String
                    {
                        let error = NSError(domain: errorCode, code: 401, userInfo: [:])
                            failure( error )
                    } else {
                        success( jsonResponse )
                    }
                } catch let err as NSError {
                    if let eString = err.userInfo.first?.value as? String
                    {
                        let error = NSError(domain: eString, code: 123, userInfo: [:])
                        failure( error )
                    } else {
                        failure( err )
                    }
                    
                }
            }
        }
        
        //realiza a requisição ao servidor
        request?.startAsynchronous()
    }
    
}
