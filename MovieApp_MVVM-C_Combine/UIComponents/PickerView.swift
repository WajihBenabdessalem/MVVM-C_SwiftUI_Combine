//
//  PickerView.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/5/24.
//

import SwiftUI

struct PickerView: View {
    @Binding var selected: MovieType?
    @State var frames = Array<CGRect>(repeating: .zero, count: 4)
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 3) { TabListView() }
            .background(BackgroundView(), alignment: .leading)
            .animation(.linear(duration: 0.15), value: selected)
            .padding(7)
            .scrollTargetLayout()
        }
        .background(
            Capsule().foregroundStyle(.gray.opacity(0.3))
        )
        .scrollPosition(id: .constant(selected), anchor: .center)
        .padding(.horizontal, 10)
    }
}

extension PickerView {
    @ViewBuilder
    func TabListView() -> some View {
        ForEach(MovieType.allCases, id: \.self) { tab in
            Text(tab.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.horizontal, 11)
                .padding(.vertical, 7)
                .onTapGesture { withAnimation { selected = tab } }
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        self.setFrame(index: indexOf(tab: tab),
                                      frame: geo.frame(in: .global))
                    }
                }
            )
        }
    }
    
    @ViewBuilder
    func BackgroundView() -> some View {
        Capsule()
            .fill(Color.titleTintColor)
            .frame(width: self.frames[indexOf(tab: selected ?? .popular)].width,
                   height: self.frames[indexOf(tab: selected ?? .popular)].height,
                   alignment: .topLeading)
            .offset(x: self.frames[indexOf(tab: selected ?? .popular)].minX - self.frames[0].minX)
    }
    
    func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
    
    func indexOf(tab: MovieType) -> Int {
        return MovieType.allCases.firstIndex(of: tab)!
    }
}

#Preview {
    PickerViewPreview()
}
