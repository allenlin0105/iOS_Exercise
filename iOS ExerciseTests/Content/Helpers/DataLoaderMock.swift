//
//  DataLoaderMock.swift
//  iOS ExerciseTests
//
//  Created by allen on 2022/1/28.
//

import UIKit
@testable import iOS_Exercise

class DataLoaderMock: DataLoaderProtocol {
    
    private var requestCount: Int = 0
    private let apiCondition: [APICondition]
    let imageURL: String
    let image: UIImage?
    
    init(apiCondition: [APICondition], withImageURL: Bool, withImage: Bool) {
        self.apiCondition = apiCondition
        self.imageURL = withImageURL ? "http://www.zoo.gov.tw/image.jpg" : ""
        self.image = withImage ? UIImage(named: "TestImage") : nil
    }
    
    func loadData(requestURL: URL, completionHandler: @escaping resultCallback) {
        switch apiCondition[requestCount] {
        case .successWithJSON:
            let offset = (Int(requestURL.getQueryValue(for: "offset")) ?? 0) / 20
            let data = createValidationData(at: offset)
            completionHandler(.success(data))
        case .successWithImage:
            completionHandler(.success(image!.pngData()!))
        case .networkFailure:
            completionHandler(.failure(.requestFail))
        case .decodeFailure:
            let data = createValidationData(withDecodeFail: true)
            completionHandler(.success(data))
        }
        
        requestCount += 1
    }
    
    private func createValidationData(at offset: Int = 0, withDecodeFail: Bool = false) -> Data {
        let singleResult = """
             {
                "F_Location":"location\(String(describing: offset))",
                "F_Pic01_URL":"\(imageURL)",
                "F_Name_Ch":"name\(String(describing: offset))",
                "F_Feature":"feature\(String(describing: offset))",
             },
        """
        let totalDataCount = withDecodeFail ? 0 : 20
        var allResults = ""
        for _ in 0..<totalDataCount {
            allResults += singleResult
        }
        let jsonString = """
            {
               "result":{
                  "results":[
                     \(allResults)
                  ]
               }
            }
        """
        let data = jsonString.data(using: .utf8)
        
        return data!
    }
}

// MARK: - Private Extension of URL

private extension URL {
    
    func getQueryValue(for key: String) -> String {
        let value = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems?.first(where: { $0.name == key })?.value
        return value ?? "0"
    }
}
