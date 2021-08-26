//
//  NetworkService.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

fileprivate let baseURL: String = "https://api.github.com/"

enum NetworkService {
    case search(text: String, page: Int)

    private var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }

    private var path: String {
        switch self {
        case .search:
            return "search/repositories"
        }
    }

    private var parameters: Parameters {
        switch self {
        case let .search(text, page):
            var parameters = Parameters()
            parameters.updateValue(text, forKey: "q")
            parameters.updateValue(page, forKey: "page")

            return parameters
        }
    }
}

extension NetworkService {
    func requset(headers: [String: String]? = nil) -> Observable<(HTTPURLResponse, Data)> {
        do {
            let url = try baseURL.asURL().appendingPathComponent(path)
            return Session.default.rx.responseData(method,
                                                          url,
                                                          parameters: parameters,
                                                          encoding: URLEncoding.default,
                                                          headers: nil).timeout(DispatchTimeInterval.seconds(15), scheduler: MainScheduler.instance)
        } catch {
            var url = baseURL
            url.append(path)
            return Observable.error(AFError.invalidURL(url: url))
        }
    }
}
