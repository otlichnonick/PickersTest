//
//  GXPhotoPicker.swift
//  
//
//  Created by Anton on 27.07.2021.
//

import Foundation
import SwiftUI

/// Структура для отображения фото галереи, за раз можно выбрать только 1 изображение
public struct GXPhotoPicker: UIViewControllerRepresentable {
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: GXPhotoPicker
        var handlePickedImage: (URL) -> Void?
        
        /// Init
        /// - Parameters:
        ///   - parent: родитель для класса Coordinator
        ///   - handlePickedImage: обработчик, который передает свойства выбранной фотографии: url, размер и название файла
        init(parent: GXPhotoPicker, handlePickedImage: @escaping (URL) -> Void?) {
            self.parent = parent
            self.handlePickedImage = handlePickedImage
        }
        
        /// Функция для выбора медиафайла при помощи UIImagePickerController
        /// - Parameters:
        ///   - picker: Контроллер представления, который управляет системными интерфейсами для съемки фотографий, записи фильмов и выбора элементов из медиатеки пользователя.
        ///   - info: Ключи, которые вы используете для извлечения информации  из словаря о выбранном пользователем элементе (например фотографии).
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            }
            if let imageUrl = info[.imageURL] as? URL {
                handlePickedImage(imageUrl)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    /// Изображение, которое показывается при выборе медиафайла из библиотеки
    @Binding var image: Image?
    /// Урл файла, из которого при необходимости можно посмотреть интересующие свойства файла,
    /// воспользовавшись ImageUrlHelper (имя, размер, дата создания файла)
    var handlePickedImage: (URL) -> Void?
    
    /// Функция создает координатор для связи с контроллером
    /// - Returns: Координатор
    public func makeCoordinator() -> Coordinator {
        return GXPhotoPicker.Coordinator(parent: self, handlePickedImage: handlePickedImage)
    }
    
    /// Функция создает  объект  UIKit view controller и настраивает его, вызывается один раз при его создании
    /// - Parameter context: Контекст, содержащий информацию о текущем состоянии системы
    /// - Returns: настроенный UIKit view controller
    public func makeUIViewController(context: UIViewControllerRepresentableContext<GXPhotoPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    /// Функция вызывается каждый раз, когда от SwiftUI поступают изменения состояния для обновления view controller
    /// - Parameters:
    ///   - : Настроенный UIKit view controller
    ///   - : Контекст, содержащий информацию о текущем состоянии системы
    public func updateUIViewController(_: UIImagePickerController, context _: UIViewControllerRepresentableContext<GXPhotoPicker>) {}
}
