//
//  MediaCard.swift
//  PHPickerTest
//
//  Created by Anton on 30.07.2021.
//

import SwiftUI
import PhotosUI

struct MediaCard: View {
    @State var data: MediaModel
    @State var uiImage: UIImage?
    @Binding var selected: [SelectedMedia]
    
    var body: some View {
        ZStack {
            // сюда вставить картинку из data.image
            Image(uiImage: uiImage ?? UIImage())
                .resizable()
            
            if data.selected {
                ZStack {
                    Color.black.opacity(0.5)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: (UIScreen.main.bounds.width - 80) / 3, height: 90)
        .onTapGesture {
            if !data.selected {
                data.selected = true
                selected.append(SelectedMedia(asset: data.asset, image: uiImage ?? UIImage()))
            } else {
                for i in 0..<selected.count {
                    if selected[i].asset == data.asset {
                        selected.remove(at: i)
                        data.selected = false
                        return
                    }
                }
            }
        }
        .onAppear {
            getImage(from: data)
        }
    }
    
    private func getImage(from media: MediaModel) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        PHCachingImageManager.default().requestImage(for: media.asset, targetSize: .init(width: 150, height: 150), contentMode: .aspectFill, options: options) { (image, _) in
            self.uiImage = image
        }
    }
}

struct MediaCard_Previews: PreviewProvider {
    static var previews: some View {
        MediaCard(data: MediaModel(selected: false, asset: PHAsset()), selected: .constant([]))
    }
}
