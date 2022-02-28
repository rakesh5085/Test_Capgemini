//
//  RepoPresenter.swift
//

import Foundation

protocol RepositoryView: NSObjectProtocol {
    func setRepositoryList(repositoryList: [Repository])
    func setEmptyRepositoryList()
    func updateView(displayName: String)
}

class RepositoryPresenter {
    private let githubService: GithubService
    weak private var repositoryView: RepositoryView?
    
    init(githubService: GithubService) {
        self.githubService = githubService
    }
    
    func attachView(view: RepositoryView) {
        repositoryView = view
    }
    
    func detachView() {
        repositoryView = nil
    }
    
    func getRepositoryList(searchText : String) {
        let repoUrl =  Constants.URL.searchUrl + "" + searchText
        githubService.getSearchRepo(url: repoUrl,
            onSuccess: { [weak self] repoList in
                guard let ws = self else { return }
                if (repoList.count == 0){
                    ws.repositoryView?.setEmptyRepositoryList()
                } else {
                    var respositoryList = [Repository]()
                    for item in repoList {
                        let single = Repository.build(item)
                        respositoryList.append(single)
                    }
                    ws.repositoryView?.setRepositoryList(repositoryList: respositoryList)
                }
            },
            onFailure: { [weak self] errorMessage in
                self?.repositoryView?.setEmptyRepositoryList()
            }
        )
    }
    
    func getUserProfile(authCode: String){
        githubService.getUserProfile(authCode: authCode) { displayName in
            self.repositoryView?.updateView(displayName: displayName)
        } onFailure: { errorMessage in }
    }
}
