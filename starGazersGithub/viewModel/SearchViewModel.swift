//
//  SearchViewModel.swift
//  starGazersGithub
//
//  Created by riccardo palumbo on 11/06/22.
//

import Foundation
import ProgressHUD
class SearchViewModel {

    var starGazers : [repoUser] = []
    var canLoadMore: Bool = false
    var nPagina: Int = 1
    
    @objc func loadData(startLoader: () -> Void, stopLoader: @escaping () -> Void, nomeUtente: String, nomeRepo: String, completion: ((Bool) -> Void)?){
        
        var apiUrl = ApiAddress.getReposByNameAndUser + nomeUtente
        apiUrl = apiUrl + "/" + nomeRepo
        apiUrl = apiUrl + "/stargazers?per_page=" + kRisultatiPerPagina
        
        startLoader()
        
        ApiManager.unAuthorizedGET(url_string: apiUrl, success: {(data) in
            if let stars = data.array {
                for item in stars{
#if DEBUG
                    print(item)
#endif
                    let s = takeRepoUserDataByJson(data: item)
                    self.starGazers.append(s)
                }
#if DEBUG
                print("--- Items = ", self.starGazers.count)
#endif
                if self.starGazers.count > 0 {
                    self.canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
                
            }
            stopLoader()
            completion?(true)
            
        }) { (error) in
            print(error)
            stopLoader()
            completion?(false)
        }
    }
    
    
    @objc func loadMoreData(startLoader: () -> Void, stopLoader: @escaping () -> Void, nomeUtente: String, nomeRepo: String, completion: ((Bool) -> Void)?){
        if self.canLoadMore {
            self.canLoadMore = false
            self.nPagina += 1
            
            var apiUrl = ApiAddress.getReposByNameAndUser + nomeUtente
            apiUrl = apiUrl + "/" + nomeRepo
            apiUrl = apiUrl + "/stargazers?per_page=" + kRisultatiPerPagina
            apiUrl = apiUrl + "&page=" + String(nPagina)
            startLoader()
            ApiManager.unAuthorizedGET(url_string: apiUrl, success: {
                
                (data) in
                
                if let stars = data.array{
                    
                    for item in stars{
                        let s = takeRepoUserDataByJson(data: item)
                        self.starGazers.append(s)
                    }
#if DEBUG
                    print("--- Items = ", self.starGazers.count)
#endif
                    if stars.count > 0{
                        self.canLoadMore = true
                    }else{
                        self.canLoadMore = false
                    }
                    stopLoader()
                    completion?(true)
                }
                
            }) { (error) in
                stopLoader()
                print(error)
                completion?(false)
            }
        }
    }
    
    func resetAllValues(){
        self.nPagina = 1
        self.canLoadMore = false
        self.starGazers = []
    }
}
