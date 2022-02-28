//
//  GithubService.swift
//

import Foundation

class GithubService {
    
    func getUserProfile(authCode: String, onSuccess successCallback: ((_ displayName: String) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        ServiceManager.instance.getUserProfile(authCode: authCode) { displayName in
            successCallback?(displayName)
        } onFailure: { errorMessage in
            failureCallback?(errorMessage)
        }
    }
    
    func getSearchRepo(url: String, onSuccess successCallback: ((_ responseData: [[String : Any]]) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        ServiceManager.instance.getSearchRepo(url: url) { responseData in
            successCallback?(responseData)
        } onFailure: { errorMessage in
            failureCallback?(errorMessage)
        }
    }

}
