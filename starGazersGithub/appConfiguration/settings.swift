//
//  settings.swift
//  starGazersGithub
//
//  Created by riccardo palumbo on 10/06/22.
//
import Foundation
import UIKit


//results for page (max 100)
let kRisultatiPerPagina = "10"
//url api Github
let api_main = "https://api.github.com/"

//settings for demo mode
let demoMode: Bool = true

struct ApiAddress{
    static let getReposByNameAndUser = api_main + "repos/"
}

//Language Function
func L(_ key: String) -> String {
    var s = NSLocalizedString(key, comment: "")
    if s == key { // try to fallback
        if let path = Bundle.main.path(forResource: "en", ofType: "lproj") {
            let languageBundle = Bundle(path: path)
            s = languageBundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        }
        
    }
    return s
}
