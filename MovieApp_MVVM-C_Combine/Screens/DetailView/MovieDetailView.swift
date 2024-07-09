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
            ResultView(state: viewModel.viewState, retry: {
                viewModel.fetchMovieDetail()
            }) { movieDetail in
                VStack(alignment: .leading, spacing: 0) {
                    PosterView(poster: movieDetail.poster!,
                               proxy: proxy, cache: cache)
                    DetailView(movie: movieDetail)
                }
            }
            .onAppear { viewModel.fetchMovieDetail() }
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
        }
        .ignoresSafeArea(edges: .all)
        .preferredColorScheme(.dark)
    }
}

extension MovieDetailView {
    struct PosterView: View {
        let poster: URL
        let proxy: GeometryProxy
        let cache: ImageCache
        
        init(poster: URL, proxy: GeometryProxy, cache: ImageCache) {
            self.poster = poster
            self.proxy = proxy
            self.cache = cache
        }
        
        var body: some View {
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
    }
    
    struct DetailView: View {
        let movie: MovieDetail
        
        var body: some View {
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
}

#Preview {
    Coordinator().build(page: .detail(MockData.movie.id))
}
