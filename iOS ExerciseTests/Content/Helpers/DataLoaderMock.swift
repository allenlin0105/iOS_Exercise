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
    let imageUrl: String
    let image: UIImage?
    
    init(apiCondition: [APICondition] = [], imageUrl: String = "http://www.zoo.gov.tw/image.jpg", image: UIImage? = UIImage(named: "TestImage")) {
        self.apiCondition = apiCondition
        self.imageUrl = imageUrl
        self.image = image
    }

    func loadData(requestUrl: URL, completionHandler: @escaping resultCallback) {
        switch apiCondition[requestCount] {
        case .successWithJSON:
            let offsetString = URLComponents(url: requestUrl, resolvingAgainstBaseURL: true)?.queryItems?.first(where: { $0.name == "offset" })?.value ?? "0"
            let offset = (Int(offsetString) ?? 0) / 20
            let data = createValidationData(at: offset)
            completionHandler(.success(data))
            break
        case .successWithImage:
            completionHandler(.success(image!.pngData()!))
            break
        case .networkFailure:
            completionHandler(.failure(.requestFail))
            break
        case .decodeFailure:
            let data = createDecodeFailData()
            completionHandler(.success(data))
            break
        }
        
        requestCount += 1
    }
    
    private func createValidationData(at offset: Int) -> Data {
        let singleResult = """
             {
                "F_Location":"location\(String(describing: offset))",
                "F_Pic01_URL":"\(imageUrl)",
                "F_Name_Ch":"name\(String(describing: offset))",
                "F_Feature":"feature\(String(describing: offset))",
             },
        """
        var allResults = ""
        for _ in 0..<20 {
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
        let data: Data? = jsonString.data(using: .utf8)
        return data!
    }
    
    private func createDecodeFailData() -> Data {
        let jsonString = """
            {
               "result":{
                  "results":[]
               }
            }
        """
        let data: Data? = jsonString.data(using: .utf8)
        return data!
    }
}