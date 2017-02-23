//
//  ServiceResponse.swift
//  ProvaZup
//
//  Created by Diego on 20/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import Foundation

//Classe genérica responsável pelo armazenamento dados de resposta do serviço
class ServiceResponse<T>
{
    var errorCode : Int?
    var errorMessage : String?
    var data : T?
    
    init( data : T ){
        self.data = data
    }
    
    init(errorCode : Int, errorMessage : String){
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}
