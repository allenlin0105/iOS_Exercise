//
//  DataLoaderProtocol.swift
//  iOS Exercise
//
//  Created by allen on 2022/1/24.
//

import Foundation

enum APIError: Error {
    case requestFail
}

typealias APIResultType = Swift.Result<Data, APIError>

protocol DataLoaderProtocol {
    typealias resultCallback = (APIResultType) -> Void
    func loadData(requestUrl: URL, completionHandler: @escaping resultCallback)
}
