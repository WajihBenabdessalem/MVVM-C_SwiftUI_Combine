//
//  SearchBar.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 6/4/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    //
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(.systemGray2))
                TextField("Search for movie...", text: $text)
                    .tint(.white)
                    .submitLabel(.search)
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(.systemGray2))
                        .padding(.trailing, 0)
                }
            }
            .padding(10)
            .background(
                Capsule()
                .strokeBorder(.gray.opacity(0.41), lineWidth: 2)
                .fill(.gray.opacity(0.35))
            )
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Text("Cancel").bold().tint(.gray)
                }
            }
        }.padding(10)
    }
}