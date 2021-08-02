//
//  CustomPickerDemoView.swift
//  PHPickerTest
//
//  Created by Anton on 30.07.2021.
//

import SwiftUI

struct CustomPickerDemoView: View {
    @State private var showMedia = false
    @State private var showCamera = false
    @State private var showDocument = false
    @State private var pickerType: PickerType = .media
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showMedia = false
                }
            
            VStack(spacing: 40) {
            Button(action: {
                showMedia = true
                pickerType = .media
            }) {
                Text("Тестить кастомный медиа-пикер \n (лучше на симуляторе)")
            }
            
            Button(action: {
                showCamera = true
                pickerType = .camera
            }) {
                Text("Тестить кастомную камеру \n(еще нет)")
            }
            
            Button(action: {
                showCamera = true
                pickerType = .document
            }) {
                Text("Тестить кастомный дока-пикер \n(еще нет)")
            }
            }
            
            if showMedia {
                    CustomPickerContainer(pickerType: pickerType, showView: $showMedia)
            }
        }
    }
}

struct CustomPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPickerDemoView()
    }
}
