//
//  AddPhotoView.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 29/03/25.
//

import SwiftUI
import PhotosUI

struct AddPhotoView: View {
    @State private var showImagePicker = false
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var photoList: [UIImage] = []

    var body: some View {
        VStack {
            Button("Select Photos") {
                showImagePicker = true
            }
            .photosPicker(isPresented: $showImagePicker, selection: $selectedImages, matching: .images)
            .onChange(of: selectedImages) {
                for newItem in selectedImages {
                    newItem.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data, let uiImage = UIImage(data: data) {
                                self.photoList.append(uiImage)
                            }
                        case .failure(let error):
                            print("Error loading image: \(error.localizedDescription)")
                        }
                    }
                }
            }
            List(photoList, id: \.self) { photo in
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
        }
    }
}


//struct AddPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPhotoView()
//    }
//}
