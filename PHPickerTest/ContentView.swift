//
//  ContentView.swift
//  PHPickerTest
//
//  Created by Anton on 28.07.2021.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                NavigationLink(destination: PickersList()) {
                    Text("Тестить стандартные пикеры")
                }
                
                NavigationLink(destination: CustomPickerDemoView()) {
                    Text("Тестить мой кастомный пикер")
                }
                
                NavigationLink(
                    destination: RootScreen()) {
                        Text("Тестить пример из Media SPM")
                }
                
                NavigationLink(
                    destination: Text("Сделай свой пикер!")) {
                        Text("Тестить свой пикер из Media SPM")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
