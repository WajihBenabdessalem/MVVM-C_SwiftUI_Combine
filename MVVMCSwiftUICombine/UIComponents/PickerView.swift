//
//  PickerView.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 6/5/24.
//

import SwiftUI

struct PickerView: View {
    @Binding var selected: MovieType
    @State var frames = [CGRect](repeating: .zero, count: 4)
    //
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 3) { tabListView() }
            .background(backgroundView(), alignment: .leading)
            .padding(.vertical, 7)
            .scrollTargetLayout()
        }
        .background(
            Capsule().foregroundStyle(.clear.opacity(0.3))
        )
        .scrollPosition(id: .constant(selected), anchor: .center)
        .frame(height: 50)
    }
}

extension PickerView {
    @ViewBuilder
    func tabListView() -> some View {
        ForEach(MovieType.allCases, id: \.self) { tab in
            Text(tab.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.horizontal, 11)
                .padding(.vertical, 7)
                .onTapGesture { withAnimation(.linear(duration: 0.15)) { selected = tab } }
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
    //
    @ViewBuilder
    func backgroundView() -> some View {
        Capsule()
            .fill(Color.titleTintColor)
            .frame(width: self.frames[indexOf(tab: selected)].width,
                   height: self.frames[indexOf(tab: selected)].height,
                   alignment: .topLeading)
            .offset(x: self.frames[indexOf(tab: selected)].minX - self.frames[0].minX)
    }
    //
    func setFrame(index: Int, frame: CGRect) {
        self.frames[index] = frame
    }
    //
    func indexOf(tab: MovieType) -> Int {
        return MovieType.allCases.firstIndex(of: tab)!
    }
}

#Preview {
    @Previewable @State var type: MovieType = .popular
    PickerView(selected: $type)
}
