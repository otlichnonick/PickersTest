//
//  GXMediaPicker.swift
//  PHPickerTest
//
//  Created by Anton on 28.07.2021.
//

import Foundation
import SwiftUI
import PhotosUI

struct GXMediaPicker: UIViewControllerRepresentable {
    var filesCount: Int
    var pickerFilter: [PHPickerFilter]
    @Binding var imageResult: [UIImage]
    @Binding var livePhotoResult: [PHLivePhoto]
    @Binding var videoResult: [URL]
    @Binding var isPresented: Bool
    
    init(
        filesCount: Int = 0,
        pickerFilter: [PHPickerFilter] = [.images],
        imageResult: Binding<[UIImage]> = .constant([]),
        livePhotoResult: Binding<[PHLivePhoto]> = .constant([]),
        videoResult: Binding<[URL]> = .constant([]),
        isPresented: Binding<Bool>) {
        self.filesCount = filesCount
        self.pickerFilter = pickerFilter
        _imageResult = imageResult
        _livePhotoResult = livePhotoResult
        _videoResult = videoResult
        _isPresented = isPresented
    }
    
    func configurePicker() -> PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .any(of: pickerFilter)
        configuration.selectionLimit = filesCount
        return configuration
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let photoPickerViewController = PHPickerViewController(configuration: configurePicker())
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: GXMediaPicker
        
        init(_ parent: GXMediaPicker) {
            self.parent = parent
        }
        
        fileprivate func getFiles(from results: [PHPickerResult]) {
            for mediaItem in results {
                if mediaItem.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        if let error = error {
                            print("Can't load image \(error.localizedDescription)")
                        } else if let image = newImage as? UIImage {
                                self?.parent.imageResult.append(image)
                        }
                    }
                } else if mediaItem.itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
                    mediaItem.itemProvider.loadObject(ofClass: PHLivePhoto.self) { [weak self] newLivePhoto, error in
                        if let error = error {
                            print("Can't load live photo \(error.localizedDescription)")
                        } else if let livePhoto = newLivePhoto as? PHLivePhoto {
                            self?.parent.livePhotoResult.append(livePhoto)
                        }
                    }
                } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier("com.apple.quicktime-movie") {
                    mediaItem.itemProvider.loadItem(forTypeIdentifier: "com.apple.quicktime-movie", options: nil) { [weak self] url, error in
                        if let error = error {
                            print("Can't load video \(error.localizedDescription)")
                        } else if let videoUrl = url as? URL {
                            self?.parent.videoResult.append(videoUrl)
                        }
                    }
                } else {
                    print("Can't load asset")
                }
            }
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            getFiles(from: results)
            parent.isPresented = false
        }
    }
}
