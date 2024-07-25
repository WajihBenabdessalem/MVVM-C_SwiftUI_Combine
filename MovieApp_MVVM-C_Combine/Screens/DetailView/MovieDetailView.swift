//
//  MovieDetailView.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/7/24.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.imageCache) private var cache: ImageCache
    
    var body: some View {
        GeometryReader { proxy in
            ResultView(state: viewModel.state, request: {
                viewModel.fetchMovieDetail()
            }) { movieDetail in
                VStack(alignment: .leading, spacing: 0) {
                    posterView(poster: movieDetail.poster!,
                               proxy: proxy, cache: cache)
                    detailView(movie: movieDetail)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.coordinator.pop()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.gray)
                .clipShape(Circle())
        })
        .ignoresSafeArea(edges: .all)
        .preferredColorScheme(.dark)
    }
}

extension MovieDetailView {
    @ViewBuilder
    func posterView(poster: URL, proxy: GeometryProxy, cache: ImageCache) -> some View {
        AsyncImageView(
            url: poster,
            cache: cache,
            placeholder: {
                Spinner(isAnimating: true, style: .medium)
            },image: {
                Image(uiImage: $0)
                    .resizable()
                    .renderingMode(.original)
            }
        )
        .frame(height: proxy.size.height / 2)
        .overlay {
            LinearGradient(gradient: Gradient(colors:  [.black, .clear]),
                           startPoint: .bottom,
                           endPoint: .center)
            .frame(height: proxy.size.height / 2)
        }
    }
    
    @ViewBuilder
    func detailView(movie: MovieDetail) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                    .font(.largeTitle)
                    .bold()
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Release Date")
                            .fontWeight(.bold)
                        Text(movie.release_date ?? "N/A")
                            .font(.headline)
                    }
                }
                Text(movie.overview ?? "N/A")
                    .font(.custom(AppFont.InterRegular, size: 17, relativeTo: .headline))
            }.padding()
        }
    }
}

#Preview {
    Coordinator().build(page: .detail(MockData.movie.id))
}
