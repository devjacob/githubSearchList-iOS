//
//  NetworkUtils.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import Foundation
import RxSwift

struct NetworkUtils {
    static func transformerMainThread<T>() -> ComposeTransformer<T, T> {
        return ComposeTransformer<T, T> { upstream in
            upstream
                .subscribe(on: SerialDispatchQueueScheduler(qos: .default))
                .observe(on: MainScheduler.instance)
        }
    }
}

