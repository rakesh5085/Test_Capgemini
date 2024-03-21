//  ServiceManager.swift
//

import Foundation

// ServiceManager class to handle API requests
class ServiceManager {
    
    // Singleton instance of ServiceManager
    static let instance = ServiceManager()
    
    // Function to fetch search results from a given URL
    func getSearchRepo(url: String, onSuccess successCallback: ((_ responseData: [[String : Any]]) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        
        // Verify the URL
        let verify: NSURL = NSURL(string: url)!
        // Create a mutable URL request
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        // Create a data task using the shared URL session
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            // If there is no error
            if error == nil {
                // Parse the JSON data
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                // If the 'items' key exists in the JSON
                if result?[Constants.Keys.items] != nil {
                    // Convert the 'items' value to an array of dictionaries
                    let repoDict = result?[Constants.Keys.items] as! [[String : Any]]
                    // Call the success callback with the parsed data
                    successCallback?(repoDict)
                }else{
                    // Call the failure callback with an error message
                    failureCallback?(Constants.Messages.errMsg)
                }
            }
        }
        // Start the data task
        task.resume()
    }
    
    // Function to fetch user profile using an authorization code
    func getUserProfile(authCode: String, onSuccess successCallback: ((_ displayName: String) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        // Prepare the POST parameters
        let postParams = "grant_type=" + Constants.GithubConstants.GRANTTYPE + "&code=" + authCode + "&client_id=" + Constants.GithubConstants.CLIENT_ID + "&client_secret=" + Constants.GithubConstants.CLIENT_SECRET
        // Convert the parameters to data
        let postData = postParams.data(using: String.Encoding.utf8)
        // Create a mutable URL request
        let request = NSMutableURLRequest(url: URL(string: Constants.GithubConstants.TOKENURL)!)
        // Set the HTTP method to POST
        request.httpMethod = "POST"
        // Set the HTTP body to the POST data
        request.httpBody = postData
        // Set the 'Accept' header to 'application/json'
        request.addValue("application/json", forHTTPHeaderField: Constants.Keys.accept)
        // Create a URL session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        // Create a data task using the URL session
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, _) -> Void in
            // Get the status code from the response
            let statusCode = (response as! HTTPURLResponse).statusCode
            // If the status code is 200
            if statusCode == 200 {
                // Parse the JSON data
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                // Extract the access token from the JSON
                let accessToken = results?[Constants.Keys.accessToken] as! String
                // Prepare the URL for fetching user profile
                let loginUrl = Constants.GithubConstants.GITHUBLOGINURL
                // Verify the URL
                let verify: NSURL = NSURL(string: loginUrl)!
                // Create a mutable URL request
                let request: NSMutableURLRequest = NSMutableRequest(url: verify as URL)
                // Add the 'Authorization' header with the access token
                request.addValue("Bearer " + accessToken, forHTTPHeaderField: Constants.Keys.authorization)
                // Create a data task using the shared URL session
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
                    // If there is no error
                    if error == nil {
                        // Parse the JSON data
                        let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                        // Extract the display name from the JSON
                        let githubDisplayName: String! = (result?[Constants.Keys.login] as! String)
                        // Call the success callback with the display name
                        successCallback?(githubDisplayName)
                    }
                }
                // Start the data task
                task.resume()
            }
        }
        // Start the data task
        task.resume()
    }
    
}

