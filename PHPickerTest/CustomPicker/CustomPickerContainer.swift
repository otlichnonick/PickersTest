//
//  CustomPickerContainer.swift
//  PHPickerTest
//
//  Created by Anton on 30.07.2021.
//

import SwiftUI

struct CustomPickerContainer: View {
    var pickerType: PickerType
    @Binding var showView: Bool
    
    var body: some View {
            switch pickerType {
            case .document:
                DocumentView()
            case .camera:
                CameraView()
            case .media:
                MediaView(showView: $showView)
            }
    }
}

struct CustomPiicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPickerContainer(pickerType: .media, showView: .constant(true))
    }
}
