//
//  ApiManager.swift
//  starGazersGithub
//
//  Created by riccardo palumbo on 11/06/22.
//

import UIKit
import Alamofire
import SwiftyJSON

let sessionManager = SessionManager (
    configuration: URLSessionConfiguration.default
)

class ApiManager: NSObject {
    
    //GET
    class func unAuthorizedGET(url_string: String, success:@escaping(JSON) -> Void, failure:@escaping (NSError) -> Void){
        sessionManager.request(url_string, method: .get).responseJSON { (responseObject) in
            
            if responseObject.result.isSuccess{
                let resJson = JSON(responseObject.result.value!)
                
                success(resJson)
            }
            if responseObject.result.isFailure{
                let error : NSError = responseObject.result.error! as NSError
                failure(error)
            }
        }
    }
    
}
