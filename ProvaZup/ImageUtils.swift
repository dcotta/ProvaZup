//
//  ImageUtils.swift
//  ProvaZup
//
//  Created by Diego on 20/02/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import Foundation

class ImageUtils {
    
    static func cachedImage(path : String, onFinish: @escaping (_ image : UIImage?)->() ) {
        //código executa assíncrono
        DispatchQueue.global(qos: .background).async {
            let fileName = path.components(separatedBy: "/").last	
            let documentsURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let pictureURL = documentsURL.appendingPathComponent(fileName!)
            // verifica se o arquivo existe localmente
            if FileManager().fileExists(atPath: pictureURL.path)
            {
                //retorna a imagem da cache
                let imageData = try! Data(contentsOf: pictureURL)
                let profileImage = UIImage(data: imageData)!
                
                DispatchQueue.main.async {
                    onFinish(profileImage)
                }
            } else {
                do {
                    // baixa o arquivo
                    let imageData = try Data(contentsOf: URL(string: path)!)
                    
                    // salva o arquivo
                    try imageData.write(to: pictureURL)
                    
                    //retorna a imagem baixada
                    let image = UIImage(data: imageData)!
                    DispatchQueue.main.async {
                        onFinish(image)
                    }
                } catch {
                    DispatchQueue.main.async {
                        onFinish(nil) // download falhou
                    }
                }
            }
        }
        
    }
    
    
}
