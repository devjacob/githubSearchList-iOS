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

    weak var delegate: SearchDelegate?

    var text: String = ""
    private var page: Int = 1

    func request() {
        if !text.isEmpty {
            NetworkAPI.requestSearch(text: text, page: page)
                .asObservable()
                .debug()
                .subscribe(onNext: { [weak self] model in
                    guard let self = self else { return }

                    self.totalCount = model.totalCount ?? 0
                    if let items = model.items {
                        self.repositories.append(contentsOf: items)
                    }

                    self.page += 1
                    self.delegate?.reloadData()
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    self.delegate?.error(error: error)
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
