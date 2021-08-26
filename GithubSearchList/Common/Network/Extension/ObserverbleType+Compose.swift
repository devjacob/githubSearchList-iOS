//
//  ObserverbleType+Compose.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import RxSwift

struct ComposeTransformer<T, R> {
    let transformer: (Observable<T>) -> Observable<R>
    init(transformer: @escaping (Observable<T>) -> Observable<R>) {
        self.transformer = transformer
    }

    func call(_ observable: Observable<T>) -> Observable<R> {
        return transformer(observable)
    }
}

extension ObservableType {
    func compose<T>(_ transformer: ComposeTransformer<Element, T>) -> Observable<T> {
        return transformer.call(asObservable())
    }
}
