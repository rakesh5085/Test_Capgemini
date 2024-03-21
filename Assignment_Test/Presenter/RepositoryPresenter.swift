//  RepoPresenter.swift
//

import Foundation

// Define a protocol for the RepositoryView, which outlines the required methods for the view to implement
protocol RepositoryView: NSObjectProtocol {
    func setRepositoryList(repositoryList: [Repository]) // Set the list of repositories
    func setEmptyRepositoryList() // Set the list of repositories to empty
    func updateView(displayName: String) // Update the view with the user's display name
}

// RepositoryPresenter class, which acts as the intermediary between the GithubService and the RepositoryView
class RepositoryPresenter {
    private let githubService: GithubService // A reference to the GithubService instance
    weak private var repositoryView: RepositoryView? // A weak reference to the RepositoryView instance
    
    init(githubService: GithubService) {
        self.githubService = githubService
    }
    
    // Attach the view to the presenter
    func attachView(view: RepositoryView) {
        repositoryView = view
    }
    
    // Detach the view from the presenter
    func detachView() {
        repositoryView = nil
    }
    
    // Fetch the repository list based on the search text
    func getRepositoryList(searchText : String) {
        let repoUrl =  Constants.URL.searchUrl + "" + searchText // Construct the search URL
        githubService.getSearchRepo(url: repoUrl, // Call the GithubService's getSearchRepo method
            onSuccess: { [weak self] repoList in // On success
                guard let ws = self else { return }
                if (repoList.count == 0){ // If the list is empty
                    ws.repositoryView?.setEmptyRepositoryList() // Notify the view to set the empty list
                } else {
                    var respositoryList = [Repository]() // Initialize an empty list
                    for item in repoList { // Iterate through the received list
                        let single = Repository.build(item) // Create a Repository instance from the item
                        respositoryList.append(single) // Add the Repository instance to the list
                    }
                    ws.repositoryView?.setRepositoryList(repositoryList: respositoryList) // Notify the view to set the list
                }
            },
            onFailure: { [weak self] errorMessage in // On failure
                self?.repositoryView?.setEmptyRepositoryList() // Notify the view to set the empty list
            }
        )
    }
    
    // Fetch the user's profile based on the auth code
    func getUserProfile(authCode: String){
        githubService.getUserProfile(authCode: authCode) { displayName in // Call the GithubService's getUserProfile method
            self.repositoryView?.updateView(displayName: displayName) // Notify the view to update with the
