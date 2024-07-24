//
//  ImageLoader.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/25/24.
//

import Combine
import UIKit

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private(set) var isLoading = false
    private let url: URL
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing", qos: .background)
    private let throttleInterval: TimeInterval = 0.2
    private var throttleWorkItem: DispatchWorkItem?
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
        cancellable = NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink { [weak self] _ in self?.clearCache() }
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }

        if let cachedImage = cache?[url] {
            self.image = cachedImage
            return
        }
        
        throttleWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.startLoad()
        }
        throttleWorkItem = workItem
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + throttleInterval, execute: workItem)
    }
    
    func startLoad() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() } )
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
        throttleWorkItem?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
    
    private func clearCache() {
        cache = nil
    }
}
