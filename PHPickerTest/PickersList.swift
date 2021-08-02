//
//  PickersList.swift
//  PHPickerTest
//
//  Created by Anton on 30.07.2021.
//

import SwiftUI
import PhotosUI

struct PickersList: View {
    @State private var photoPickerIsPresented = false
    @State private var cameraIsPresented = false
    @State private var documentPickerIsPresented = false
    @State private var documentsUrl: [URL] = []
    @State private var imagesResult: [UIImage] = []
    @State private var livePhoto: [PHLivePhoto] = []
    @State private var videoUrls: [URL] = []
    @State private var newPhoto: Image?
    var body: some View {
        VStack {
            Button(action: {
                photoPickerIsPresented.toggle()
            }, label: {
                Text("Тестить PHPickerViewController")
            })
            .padding(.bottom, 40)
            
            Button(action: {
                cameraIsPresented.toggle()
            }) {
                Text("Тестить UIImagePickerController тип \"Камера\"")
            }
            .padding(.bottom, 40)
            
            Button(action: {
                documentPickerIsPresented.toggle()
            }) {
                Text("Тестить UIDocumentPickerViewController")
            }
            
            ScrollView {
                if !imagesResult.isEmpty {
                    Text("Выбранные картинки из галереи")
                }
                ForEach(imagesResult, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200, alignment: .center)
                }
                
                if !videoUrls.isEmpty {
                    Text("Урлы выбранных выдео из галереи")
                }
                ForEach(videoUrls, id: \.self) { url in
                    Text(url.absoluteString)
                }
                
                if newPhoto != nil {
                    Text("Фотография с камеры")
                }
                newPhoto?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
                
                if !documentsUrl.isEmpty {
                    Text("Урлы выбранных документов")
                }
                ForEach(documentsUrl, id: \.self) { url in
                    Text("File name: \(url.fileName)")
                    Text("File size: \(url.fileSizeString)")
                }
            }
        }
        .onChange(of: imagesResult, perform: { _ in
            print("imagesResult count = \(imagesResult.count)")
        })
        .padding()
        .sheet(isPresented: $photoPickerIsPresented, content: {
            GXMediaPicker(filesCount: 0,
                        pickerFilter: [.images, .livePhotos, .videos],
                        imageResult: $imagesResult,
                        videoResult: $videoUrls,
                        isPresented: $photoPickerIsPresented)
        })
        .sheet(isPresented: $cameraIsPresented) {
            GXPhotoPicker(image: $newPhoto) { _ in }
        }
        .sheet(isPresented: $documentPickerIsPresented) {
            GXDocumentPicker(showPicker: $documentPickerIsPresented,
                           contentTypes: [.pdf, .text, .gif, .png]) { urls in
                self.documentsUrl = urls
            }
        }
    }
}

struct PickersList_Previews: PreviewProvider {
    static var previews: some View {
        PickersList()
    }
}
