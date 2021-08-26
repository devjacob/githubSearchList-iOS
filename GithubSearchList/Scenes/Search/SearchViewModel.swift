//
//  SearchViewModel.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import Foundation
import RxSwift

class SearchViewModel {
    private var disposeBag: DisposeBag = DisposeBag()
    
    var repositories: [Item] = Array()
    private var totalCount: Int = 0

    var networkStatus: NetworkStatus = .none

    weak var delegate: SearchDelegate?

    var text: String = ""
    private var page: Int = 1

    func request() {
        if !text.isEmpty, networkStatus == .none {
            networkStatus = .loading
            NetworkAPI.requestSearch(text: text, page: page)
                .asObservable()
                .debug()
                .subscribe(onNext: { [weak self] model in
                    guard let self = self else { return }

                    self.totalCount = model.totalCount ?? 0
                    if let items = model.items, items.count > 0 {
                        self.repositories.append(contentsOf: items)
                        self.networkStatus = .none
                        self.page += 1
                        self.delegate?.reloadData()
                    } else {
                        self.networkStatus = .finished
                    }
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    self.delegate?.error(error: error)
                    self.networkStatus = .error
                }).disposed(by: disposeBag)
        }
    }

    func reset() {
        totalCount = 0
        repositories.removeAll()
        page = 1
    }
}

protocol SearchDelegate: AnyObject {
    func reloadData()
    func error(error: Error)
}
