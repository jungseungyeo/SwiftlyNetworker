//
//  SojuAPI.swift
//  SwiftlyNetworker_Example
//
//  Created by saeng lin on 2022/03/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SwiftlyNetworker

enum SojuAPI {
    case list
}

extension SojuAPI: APIable {
    var params: [String : Any]? {
        nil
    }
    
    var path: String {
        "/TestJSONfile/main/JSON/Test.json"
    }
    
    var method: HttpMethod {
        .get
    }
    
    var log: Bool { return false }
}
