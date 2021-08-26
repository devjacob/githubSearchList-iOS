//
//  ObservableType.swift
//  GithubSearchList
//
//  Created by jacob on 2021/08/26.
//

import Foundation
import RxSwift

enum DecodeError: Error {
    case failDecode
    case doNothaveData

    var message: String {
        switch self {
        case .failDecode:
            return "Could not decode object"
        case .doNothaveData:
            return "Do not have Data"
        }
    }
}

extension ObservableType {
    func mapObject<T: Decodable>(type: T.Type) -> Observable<T> {
        return flatMap { data -> Observable<T> in
            let responseTuple = data as? (HTTPURLResponse, Data)

            guard let jsonData = responseTuple?.1 else { return Observable.error(DecodeError.failDecode) }

            do {
                print(jsonData.debugDescription)
                let object = try self.decoder().decode(T.self, from: jsonData)

                return Observable.just(object)
            } catch {
                return Observable.error(DecodeError.failDecode)
            }
        }
    }

    private func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
