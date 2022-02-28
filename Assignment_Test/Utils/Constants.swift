//
//  Constants.swift
//

import Foundation

class Constants: NSObject{
    
    struct URL {
        static let searchUrl = "https://api.github.com/search/repositories?q="
    }
    
    struct Messages {
        static let errMsg = "Something went wrong, Please try again later"
    }
    
    struct GithubConstants {
        static let CLIENT_ID = "f182687fe46ddb787d1c"
        static let CLIENT_SECRET = "d4c410d7649a929167a51853e0009a7df28cc3b1"
        static let REDIRECT_URI = "https://assignment-f6165.firebaseapp.com/__/auth/handler"
        static let SCOPE = "read:user,user:email"
        static let TOKENURL = "https://github.com/login/oauth/access_token"
        static let AUTHBASEURL = "https://github.com/login/oauth/authorize?client_id="
        static let GITHUBLOGINURL = "https://api.github.com/user"
        static let GRANTTYPE = "authorization_code"
    }
    
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

    struct Identifiers {
        static let repoTableCell = "TableViewCustomCell"
    }
    
    struct Strings {
        static let login = "Login"
        static let logOut = "Log Out"
        static let githubTitle = "github.com"
    }

    
}
