//  Constants.swift
//
//  This file contains various constants used throughout the application.
//  These constants are organized into structs for better code organization.

import Foundation

// Constants related to URLs used in the application.
class Constants: NSObject{
    
    // The base URL for searching GitHub repositories.
    struct URL {
        static let searchUrl = "https://api.github.com/search/repositories?q="
    }
    
    // Error messages displayed to the user.
    struct Messages {
        static let errMsg = "Something went wrong, Please try again later"
    }
    
    // Constants related to GitHub API.
    struct GithubConstants {
        // Client ID and Client Secret for OAuth authentication.
        static let CLIENT_ID = "f182687fe46ddb787d1c"
        static let CLIENT_SECRET = "d4c410d7649a929167a51853e0009a7df28cc3b1"
        
        // Redirect URI for OAuth authentication.
        static let REDIRECT_URI = "https://assignment-f6165.firebaseapp.com/__/auth/handler"
        
        // Scopes for OAuth authentication.
        static let SCOPE = "read:user,user:email"
        
        // Token URL for OAuth authentication.
        static let TOKENURL = "https://github.com/login/oauth/access_token"
        
        // Authorization base URL for OAuth authentication.
        static let AUTHBASEURL = "https://github.com/login/oauth/authorize?client_id="
        
        // GitHub login URL.
        static let GITHUBLOGINURL = "https://api.github.com/user"
        
        // Grant type for OAuth authentication.
        static let GRANTTYPE = "authorization_code"
    }
    
    // Keys used in UserDefaults to store application data.
    struct Keys {
        static let loginStatus = "loggedInStatus"
        static let id = "id"
        static let login = "login"
        static let repoData = "RepoData"
        static let name = "name"
        static let url = "url"
        static let readStatus = "readStatus"
        static let accessToken = "access_token"
        static let accept = "Accept"
        static let authorization = "Authorization"
        static let items = "items"
        static let fullName = "full_name"
        static let htmlUrl = "html_url"
    }

    // Identifiers for custom table view cells.

