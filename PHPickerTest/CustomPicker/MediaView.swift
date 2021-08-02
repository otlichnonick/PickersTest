//
//  MediaView.swift
//  PHPickerTest
//
//  Created by Anton on 30.07.2021.
//

import SwiftUI
import PhotosUI

struct MediaView: View {
    var mediaType = PHAssetMediaType.image
    var widthMultiplier: CGFloat = 1
    var heightMultiplier: CGFloat = 1
    @State var selectedMedia: [SelectedMedia] = []
    @State private var grid: [[MediaModel]] = []
    @Binding var showView: Bool
    @State private var disabled = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if !grid.isEmpty {
                    // TODO сюда прокинуть вьюбилдер
                    HStack {
                        Text("Выбери файл")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(grid, id: \.self) { i in
                                HStack(spacing: 8) {
                                    ForEach(i, id: \.self) { j in
                                        MediaCard(data: j, selected: $selectedMedia)
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    // TODO сюда прокинуть вьюбилдер
                    Button(action: {
                        showView.toggle()
                    }) {
                        Text("Выбрать")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 2)
                    }
                    .background(Color.red.opacity(selectedMedia.isEmpty ? 0.5 : 1))
                    .clipShape(Capsule())
                    .padding(.bottom)
                    .disabled(selectedMedia.isEmpty ? true : false)
                    
                } else {
                    if self.disabled {
                        Text("Нужно разрешить доступ к хранилищу")
                        Button(action: {
                            goToAppPrivacySettings()
                        }, label: {
                            Text("Перейти в настройки")
                        })
                    }
                    if self.grid.count == 0 {
                        ProgressView()
                    }
                }
            }
            .frame(width: geometry.size.width * widthMultiplier, height: geometry.size.height * heightMultiplier)
            .background((Color.white))
            .cornerRadius(12)
        }
        .onAppear() {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    getAllFiles()
                    disabled = false
                } else {
                    disabled = true
                }
            }
        }
    }
    
    private func goToAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func getAllFiles() {
        debugPrint("getAllFiles")
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        let request = PHAsset.fetchAssets(with: mediaType, options: opt)
        debugPrint("request: \(request.countOfAssets(with: mediaType))")
        // кэшируем объекты из библиотеки
        DispatchQueue.global(qos: .userInitiated).async {
            for i in stride(from: 0, to: request.count, by: 3) {
                var iteration: [MediaModel] = []
                for j in i..<i + 3 {
                    if j < request.count {
                        let data = MediaModel(selected: false, asset: request[j])
                        iteration.append(data)
                    }
                }
                grid.append(iteration)
            }
        }
    }
}

struct MediaView_Previews: PreviewProvider {
    static var previews: some View {
        MediaView(showView: .constant(true))
    }
}
