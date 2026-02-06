//
//  PhotoDetailView.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 28/03/25.
//

import SwiftUI

struct PhotoItemView: View {
    let photo: UIImage
    let photoList: [UIImage]
    @Binding var selectedPhotoIndex: Int?
    @Binding var showPhotoDetailView: Bool

    var body: some View {
        Image(uiImage: photo)
            .resizable()
            .scaledToFill()
            //.frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(10)
            .onTapGesture {
                selectedPhotoIndex = photoList.firstIndex(of: photo)
                showPhotoDetailView = true
            }
    }
}

struct PhotoDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex: Int
    @State private var scale: CGFloat = 1.0
    var photos: [UIImage]
    var selectedPhotoIndex: Int
    var name: String
    init(name: String, photos: [UIImage], selectedPhotoIndex: Int) {
        self.name = name
        self.photos = photos
        self.selectedPhotoIndex = selectedPhotoIndex
        self._currentIndex = State(initialValue: selectedPhotoIndex)
    }

    var body: some View {
        VStack {
            Text(name)
                .font(.title2)
                .fontWeight(.regular)
                .foregroundColor(.brown)
                .padding()
                .padding(.horizontal, 30)
            
            TabView(selection: $currentIndex) {
                ForEach(photos.indices, id: \.self) { index in
                    Image(uiImage: photos[index])
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .background(
                Image(uiImage: photos[currentIndex])
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 20)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .background(Color.yellow.opacity(0.1))
        .overlay(
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                    .padding(.top, 20)
            },
            alignment: .topLeading
        )
    }
}
