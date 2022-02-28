//
//  Repository.swift
//

import Foundation

class Repository {
    var id: Int?
    var name: String?
    var url: String?
    
    func loadFromDictionary(_ dict: [String: Any]) {
        if let data = dict[Constants.Keys.id] as? Int {
            self.id = data
        }
        if let data = dict[Constants.Keys.fullName] as? String {
            self.name = data
        }
        if let data = dict[Constants.Keys.htmlUrl] as? String {
            self.url = data
        }
    }
    
    class func build(_ dict: [String: Any]) -> Repository {
        let repository = Repository()
        repository.loadFromDictionary(dict)
        return repository
    }
}

