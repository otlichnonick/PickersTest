//
//  DocumentPicker.swift
//  PHPickerTest
//
//  Created by Anton on 30.07.2021.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct GXDocumentPicker: UIViewControllerRepresentable {
    @Binding var showPicker: Bool
    var contentTypes: [UTType] = [.text]
    var handlePickedDocument: ([URL]) -> Void
    
    func makeCoordinator() -> Coordinator {
        return GXDocumentPicker.Coordinator(parent: self, handlePickedDocument: handlePickedDocument)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<GXDocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes, asCopy: true)
        picker.allowsMultipleSelection = true
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
            uiViewController.allowsMultipleSelection = true
        }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: GXDocumentPicker
        var handlePickedDocument: ([URL]) -> Void
        
        public init(parent: GXDocumentPicker, handlePickedDocument: @escaping ([URL]) -> Void) {
            self.parent = parent
            self.handlePickedDocument = handlePickedDocument
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            debugPrint("urls: \(urls)")
            handlePickedDocument(urls)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.showPicker = false
        }
    }
}
