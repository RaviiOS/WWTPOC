//
//  String+Feature.swift
//  Swifterviewing
//
//  Created by Ravi Kumar Yaganti on 25/07/20.
//  Copyright © 2020 World Wide Technology Application Services. All rights reserved.
//

import Foundation

extension String {
    
    func remoceCharacter() -> String {
        return replacingOccurrences(of: "[e]", with: "", options: [.regularExpression, .caseInsensitive])
    }
    
}
