//
//  repoUser.swift
//  starGazersGithub
//
//  Created by riccardo palumbo on 10/06/22.
//

import SwiftyJSON
import UIKit

class repoUser {
    var login               : String
    var id                  : Int
    var node_id             : String
    var avatar_url          : String
    var url                 : String
    var html_url            : String
    var type                : String

    init(_login: String, _id:Int, _node_id:String, _avatar_url:String, _url:String, _html_url:String, _type: String) {
        login = _login
        id = _id
        node_id = _node_id
        avatar_url = _avatar_url
        url = _url
        html_url = _html_url
        type = _type
    }
}

//parsing object repoUser
func takeRepoUserDataByJson(data: JSON) -> repoUser{
    var login               : String = ""
    var id                  : Int = 0
    var node_id             : String = ""
    var avatar_url          : String = ""
    var url                 : String = ""
    var html_url            : String = ""
    var type                : String = ""
    
    if let _nodeId = data["node_id"].string {
        node_id = _nodeId
    }
    
    if let _html_url = data["html_url"].string {
        html_url = _html_url
    }
    if let _id = data["id"].int {
        id = _id
    }
    if let _url = data["url"].string {
        url = _url
    }
    if let _avatar_url = data["avatar_url"].string {
        avatar_url = _avatar_url
    }
    if let _login = data["login"].string {
        login = _login
    }
    
    if let _type = data["type"].string {
        type = _type
    }
    
    return repoUser(_login: login, _id: id, _node_id: node_id, _avatar_url: avatar_url, _url: url, _html_url: html_url, _type: type)
    
}
