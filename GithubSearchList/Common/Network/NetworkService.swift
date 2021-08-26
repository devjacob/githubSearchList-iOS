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

fileprivate let baseURL: String = "https://developer.github.com/v3/"

enum NetworkService {

    private var method: HTTPMethod {
        return .get
    }

    private var path: String {
        return ""
    }

    private var parameters: Parameters {
        return Parameters()
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
