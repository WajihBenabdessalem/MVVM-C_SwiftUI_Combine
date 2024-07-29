//
//  AsyncImageView.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/25/24.
//

import SwiftUI

struct AsyncImageView<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    //
    init(
        url: URL,
        cache: ImageCache,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: cache))
    }
    //
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    //
    private var content: some View {
        Group {
            if let img = loader.image {
               image(img)
            } else {
                placeholder
            }
        }
    }
}
