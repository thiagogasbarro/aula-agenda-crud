//
//  Configuracao.swift
//  Agenda
//
//  Created by Thiago Gasbarro Jesus on 05/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class Configuracao: NSObject {
    
    func getUrlPadrao() -> String? {
        
        guard let caminhoParaPlist = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        guard let dicionario = NSDictionary(contentsOfFile: caminhoParaPlist) else { return nil }
        guard let urlPadrao = dicionario["UrlPadrao"] as? String else { return nil }
        
        return urlPadrao
    }

}
