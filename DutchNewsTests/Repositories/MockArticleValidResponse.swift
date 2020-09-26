//
//  MockArticleValidResponse.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
@testable import DutchNews

struct MockArticleValidResponse: NetworkValidResponse {
    var statusCodes: Set<Int> {
        Set((200..<300).map { $0 } + [400, 422, 429, 401])
    }
    var contentTypes: [String] { ["application/json"] }
}
