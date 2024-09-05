//
//  NavBarView.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 9/5/24.
//

import SwiftUI

struct NavBarView<Content: View>: View {
    var title: String
    var content: Content
    //
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    //
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 75)
                    .padding([.leading, .bottom], 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground).shadow(radius: 3))
            }
            .background(Color(.systemBackground))
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    NavBarView(title: "Top Rate") {
        Color.blue.ignoresSafeArea()
    }
}
