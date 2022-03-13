//
//  SojuModel.swift
//  SwiftlyNetworker_Example
//
//  Created by saeng lin on 2022/03/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

struct Model: Decodable {
    public private(set) var sojus: [Soju]?
    
    enum CodingKeys: String, CodingKey {
        case sojus = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sojus = try? container.decode([Model.Soju].self, forKey: .sojus)
    }
}

extension Model {
    struct Soju: Decodable {
        public private(set) var title: String?
        public private(set) var subTitle: String?
        public private(set) var image: URL?
        
        enum CodingKeys: String, CodingKey {
            case title = "title"
            case subTitle = "subTitle"
            case image = "image"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try? container.decode(String.self, forKey: .title)
            self.subTitle = try? container.decode(String.self, forKey: .subTitle)
            self.image = try? container.decode(URL.self, forKey: .image)
        }
    }
}
