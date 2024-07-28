//
//  NoInternetView.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 7/11/24.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        ContentUnavailableView(
            "Network connection seems to be offline.",
            systemImage: "wifi.exclamationmark",
            description: Text("Please check your connection and try again.")
        )
    }
}

#Preview {
    NoInternetView()
}
