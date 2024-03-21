//
//  GithubService.swift
//
//  This file contains the GithubService class, which is responsible for handling GitHub-related API calls.
//  It provides two methods: getUserProfile and getSearchRepo, which are used to fetch user profile and search repository data respectively.
//

import Foundation

class GithubService {
    
    // Method to fetch user profile data using the provided authCode.
    // Upon successful completion, the displayName is passed to the successCallback.
    // If an error occurs, the error message is passed to the failureCallback.
    func getUserProfile(authCode: String, onSuccess successCallback: ((_ displayName: String) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        // Delegates the API call to the ServiceManager singleton instance.
        ServiceManager.instance.getUserProfile(authCode: authCode) { displayName in
            // Calls the successCallback with the displayName upon successful completion.
            successCallback?(displayName)
        } onFailure: { errorMessage in
            // Calls the failureCallback with the errorMessage in case of an error.
            failureCallback?(errorMessage)
        }
    }
    
    // Method to search for repositories using the provided URL.
    // Upon successful completion, the responseData is passed to the successCallback.
    // If an error occurs, the error message is passed to the failureCallback.
    func getSearchRepo(url: String, onSuccess successCallback: ((_ responseData: [[String : Any]]) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        // Delegates the API call to the ServiceManager singleton instance.
        ServiceManager.instance.getSearchRepo(url: url) { responseData in
            // Calls the successCallback with the responseData upon successful completion.
            successCallback?(responseData)
        } onFailure: { errorMessage in
            // Calls the failureCallback with the errorMessage in case of an error.
            failureCallback?(errorMessage)
        }
    }

}
