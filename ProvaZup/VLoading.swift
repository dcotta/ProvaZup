//
//  VLoading.swift
//  ProvaZup
//
//  Created by Diego on 20/02/17.
//  Copyright © 2016 Diego. All rights reserved.
//

import UIKit

// View mostrada quando está esperando o retorno da requisição
class VLoading: UIView {
    
    static var vLoading : VLoading! = nil
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    

    //Mosta a view de loading
    static func showLoading()
    {
        let win = UIApplication.shared.delegate?.window
        
        if (vLoading == nil)
        {
            vLoading = Bundle.main.loadNibNamed("VLoading", owner: nil, options: nil)?[0] as! VLoading
            vLoading.frame = win!!.bounds
            
        }
        
        vLoading.activityIndicatorView.startAnimating()
        win!!.addSubview(vLoading)
        
    }
    
    //esconde a view de loading
    static func hideLoading()
    {
        vLoading?.activityIndicatorView.stopAnimating()
        vLoading?.removeFromSuperview()
    }

}
