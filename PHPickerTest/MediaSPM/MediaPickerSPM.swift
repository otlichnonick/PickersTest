//
//  MediaPickerSPM.swift
//  PHPickerTest
//
//  Created by Anton on 02.08.2021.
//

import SwiftUI
import MediaCore
import MediaSwiftUI

struct MediaPickerSPM: View {
    @State private var isPresented = false
    var body: some View {
        PHPicker(isPresented: $isPresented)
    }
}

struct MediaPickerSPM_Previews: PreviewProvider {
    static var previews: some View {
        MediaPickerSPM()
    }
}
