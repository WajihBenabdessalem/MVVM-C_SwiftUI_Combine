//
//  PopularityBadge.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/5/24.
//

import SwiftUI

struct PopularityBadge: View {
    let score: Int
    let textColor: Color
    @State private var isDisplayed = false
    //
    init(score: Int, textColor: Color = .primary) {
        self.score = score
        self.textColor = textColor
    }
    //
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2))
                .foregroundColor(.gray.opacity(0.3))
                .frame(width: 40)
                .overlay(overlay)
            Text("\(score)%")
                .font(Font.system(size: 10))
                .bold()
                .foregroundColor(textColor)
        }
        .frame(width: 40, height: 40)
    }
    //
    var scoreColor: Color {
        if score == 0 {
            return .gray
        } else if score < 40 {
            return .red
        } else if score < 60 {
            return .orange
        } else if score < 75 {
            return .yellow
        }
        return .green
    }
    //
    var overlay: some View {
        ZStack {
            Circle()
                .trim(from: 0,
                      to: isDisplayed ? CGFloat(score) / 100 : 0)
                .stroke(style: StrokeStyle(lineWidth: 2))
                .foregroundColor(scoreColor)
        }
        .rotationEffect(.degrees(-90))
        .onAppear {
            self.isDisplayed = true
        }
    }
}

#Preview {
    VStack {
        PopularityBadge(score: 80)
    }
}
