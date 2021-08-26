//
//  NetworkAPI.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import RxSwift

class NetworkAPI {
    static func requestSearch(text: String, page: Int) -> Observable<Repository> {
        return NetworkService.search(text: text, page: page)
            .requset()
            .retry(3)
            .debug()
            .compose(NetworkUtils.transformerMainThread())
            .mapObject(type: Repository.self)
    }
}

