//
//  Data+extension.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/4/24.
//

import Foundation

extension Data {
    var prettyJson: String {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object,
                                                     options: [.prettyPrinted]) else { return "" }
        return String(decoding: data, as: UTF8.self)
    }
}
