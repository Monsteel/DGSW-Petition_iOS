//
//  Int.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/06/08.
//

import Foundation

extension Int {
    func toDecimalString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: self))!
        
        return result
    }
}
