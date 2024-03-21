//  Repository.swift
//
//  This file contains the definition of the Repository class, which represents a repository in a version control system.
//
//  The Repository class has three properties: id, name, and url, which represent the unique identifier, name, and URL of the repository, respectively.
//
//  The loadFromDictionary(_:) method is used to initialize a Repository object with data from a dictionary. It checks if the dictionary contains keys for the id, fullName, and htmlUrl properties, and sets their values accordingly.
//
//  The build(_:) class method is a convenience initializer that creates and initializes a new Repository object with the given dictionary.

import Foundation

class Repository {
    // The unique identifier of the repository.
    var id: Int?

    // The name of the repository.
    var name: String?

    // The URL of the repository.
    var url: String?

    // Initializes a new Repository object with data from a dictionary.
    func loadFromDictionary(_ dict: [String: Any]) {
        if let data = dict[Constants.Keys.id] as? Int {
            self.id = data
        }
        // The fullName key is used instead of name to avoid confusion with the name property.
        if let data = dict[Constants.Keys.fullName] as? String {
            self.name = data
        }
        if let data = dict[Constants.Keys.htmlUrl] as? String {
            self.url = data
        }
    }

    // A class method that creates and initializes a new Repository object with the given dictionary.
    class func build(_ dict: [String: Any]) -> Repository {
        let repository = Repository()
        repository.loadFromDictionary(dict)
        return repository
    }
}
