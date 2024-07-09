//
//  PickerViewPreview.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/7/24.
//

import SwiftUI

struct PickerViewPreview: View {
    
    @State private var selected: MovieType?
    
    var body: some View {
        PickerView(selected: $selected)
    }
}
