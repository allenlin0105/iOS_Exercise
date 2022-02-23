//
//  DataLoaderMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/28.
//

import UIKit
import XCTest
@testable import iOS_Exercise

class DataLoaderMock: DataLoaderProtocol {
    
    var runLoadData: Bool = true
    var apiStatuses: [APIStatus] = [.success]
    var expectations: [XCTestExpectation]?
    private var apiIndex = 0
    
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback) {
        if !runLoadData { return }
        
        switch apiStatuses[apiIndex] {
        case .loading:
            break
        case .success:
            let offset = (Int(requestURL.getQueryValue(for: "offset")) ?? 0) / 20
            let data = makeJSONData(at: offset)
            completionHandler(.success(data))
        case .noData:
            let data = "{\"result\":{\"results\":[]}}".data(using: .utf8)!
            completionHandler(.success(data))
        case .requestFail:
            let error = NSError(domain: "TestingError", code: 1, userInfo: nil)
            completionHandler(.failure(error))
        case .decodeFail:
            let data = "{results: []}".data(using: .utf8)!
            completionHandler(.success(data))
        }
        expectations?[apiIndex].fulfill()
        apiIndex += 1
    }
}

// MARK: - Private Extension of URL

private extension URL {
    
    func getQueryValue(for key: String) -> String {
        let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems
        let value = queryItems?.first(where: { $0.name == key })?.value
        return value ?? ""
    }
}
