//
//  APIService.swift
//  tokointest
//
//  Created by Macintosh HD on 8/12/20.
//  Copyright © 2020 Macintosh HD. All rights reserved.
//

import Foundation
import Alamofire

public let API_KEY: String = "c1b901d3091b4cb7a601b6f487b49fda"

struct URLConstant {
static let allArticles = "https://newsapi.org/v2/everything?q=bitcoin&from=2020-08-10&sortBy=publishedAt&apiKey=" + API_KEY
}

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchAllArticles( complete: @escaping ( _ success: Bool, _ articles: [Article], _ error: APIError? )-> Void )
}

class APIService: APIServiceProtocol {
    func fetchAllArticles(complete: @escaping (_ success:Bool, _ articles:[Article],_ error: APIError?) -> Void) {
        guard let url = URL(string:URLConstant.allArticles) else {
        complete(false, [], nil)
        return
        }
    
        AF.request(url,
                          method: .get,
                          parameters: nil)
        .responseJSON { response in
            switch response.result {
                   case .success:
                       print("Validation Successful")
                       guard let value  = response.value as? [String: Any],
                           let rows = value["articles"] as? [[String: Any]] else {
                             print("Malformed data received from fetchAllArticles service")
                             complete(false, [], nil)
                            return
                         }

                       let articles = rows.compactMap { roomDict in
                        return Article(dict: roomDict)
                       }
                         complete(true, articles, nil)
                        return
                   case let .failure(error):
                       print(error)
                    return
                   }
        }
    }
}
