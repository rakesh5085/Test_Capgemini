//
//  ServiceManager.swift
//

import Foundation

class ServiceManager {
    
    static let instance = ServiceManager()
    
    func getSearchRepo(url: String, onSuccess successCallback: ((_ responseData: [[String : Any]]) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        
        let verify: NSURL = NSURL(string: url)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            if error == nil {
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                if result?[Constants.Keys.items] != nil {
                    let repoDict = result?[Constants.Keys.items] as! [[String : Any]]
                    successCallback!(repoDict)
                }else{
                    failureCallback!(Constants.Messages.errMsg)
                }
            }
        }
        task.resume()
    }
    
    func getUserProfile(authCode: String, onSuccess successCallback: ((_ displayName: String) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        let postParams = "grant_type=" + Constants.GithubConstants.GRANTTYPE + "&code=" + authCode + "&client_id=" + Constants.GithubConstants.CLIENT_ID + "&client_secret=" + Constants.GithubConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: Constants.GithubConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: Constants.Keys.accept)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, _) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                let accessToken = results?[Constants.Keys.accessToken] as! String
                let loginUrl = Constants.GithubConstants.GITHUBLOGINURL
                let verify: NSURL = NSURL(string: loginUrl)!
                let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
                request.addValue("Bearer " + accessToken, forHTTPHeaderField: Constants.Keys.authorization)
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
                    if error == nil {
                        let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                        let githubDisplayName: String! = (result?[Constants.Keys.login] as! String)
                        successCallback!(githubDisplayName)
                    }
                }
                task.resume()
            }
        }
        task.resume()
    }
    
}
