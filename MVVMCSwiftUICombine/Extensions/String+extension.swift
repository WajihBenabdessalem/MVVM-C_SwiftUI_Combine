//
//  String+extension.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 6/5/24.
//

import Foundation

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self) ?? Date()
    }
}
