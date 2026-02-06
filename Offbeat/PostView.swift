//
//  PostView.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 28/03/25.
//

import SwiftUI

struct Post: Identifiable, Codable, Equatable {
    let id: String
    let cityId: String
    let cityName: String
    let name: String
    let description: String
    let location: String
    let rating: Int
    //let photoList: [UIImage]?
    
    static func loadPosts() -> [Post] {
        guard let savedPosts = UserDefaults.standard.array(forKey: "posts") as? [[String: Any]] else { return [] }
        return savedPosts.compactMap { dict in
            guard let idString = dict["id"] as? String,
                  let id = dict["id"] as? String,
                  let cityId = dict["cityId"] as? String,
                  let cityName = dict["cityName"] as? String,
                  let name = dict["name"] as? String,
                  let description = dict["description"] as? String,
                  let location = dict["location"] as? String,
                  let rating = dict["rating"] as? Int
                    //,let photoPaths = dict["photoList"] as? [String]
            else { return nil }
            
//            let photoList = photoPaths.compactMap { path -> UIImage? in
//                let fileURL = URL(fileURLWithPath: path)
//                guard let imageData = try? Data(contentsOf: fileURL) else { return nil }
//                return UIImage(data: imageData)
//            }
            return Post(id: id, cityId: cityId, cityName: cityName, name: name, description: description, location: location, rating: rating
                        //, photoList: photoList
            )
        }
    }
}

struct PostView: View {
    @Binding var selectedPost: Post?
    @Binding var showAddDestination: Bool
    @State private var selectedPhotoIndex: Int? = nil
    @State private var showPhotoDetailView = false
    @State private var likedImage: String = "like"
    @State private var likedCount: Int = 0
    @State private var showAlert = false
    @State private var showPopover = false
    var post: Post
    var deleteAction: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack(alignment: .top) {
                        Text(post.name)
                            .font(.title2)
                            .fontWeight(.regular)
                            .foregroundColor(.brown)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .padding(.top, 5)
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showPopover.toggle()
                                }
                            }) {
                                Image(systemName: showPopover ? "xmark" : "ellipsis")
                                    .padding()
                                    .foregroundColor(.brown)
                            }
                        }
                    }
//                    if post.photoList.isEmpty {
//                        Divider()
//                            .background(Color.brown)
//                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
//                if !post.photoList.isEmpty {
//                    TabView {
//                        ForEach(post.photoList, id: \.self) { photo in
//                            PhotoItemView(photo: photo, photoList: post.photoList, selectedPhotoIndex: $selectedPhotoIndex, showPhotoDetailView: $showPhotoDetailView)
//                        }
//                    }
//                    .frame(height: 350)
//                    .tabViewStyle(.page)
//                    .sheet(isPresented: $showPhotoDetailView) {
//                        PhotoDetailView(name: post.name, photos: post.photoList, selectedPhotoIndex: selectedPhotoIndex ?? 0)
//                    }
//                }
                
                VStack {
                    if !post.description.isEmpty {
                        Text(post.description)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(.brown)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        Text("Location")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.brown)
                        Image(systemName: "location.circle")
                            .foregroundColor(.brown)
                        Spacer()
                    }
                    .padding(.top, !post.description.isEmpty ? 10 : 0)
                    if let url = URL(string: post.location) {
                        Link(destination: url) {
                            Text(post.location)
                                .font(.caption)
                                .fontWeight(.regular)
                            //.foregroundColor(.brown)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                        }
                        .onTapGesture {
                            if let url = URL(string: post.location) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    
                    //                    ScrollView(.horizontal, showsIndicators: false) {
                    //                        HStack(spacing: 10) {
                    //                            ForEach(post.photoList, id: \.self) { photo in
                    //                                PhotoItemView(photo: photo, photoList: post.photoList, selectedPhotoIndex: $selectedPhotoIndex, showPhotoDetailView: $showPhotoDetailView)
                    //                            }
                    //                        }
                    //                    }
                    //                    .sheet(isPresented: $showPhotoDetailView) {
                    //                        PhotoDetailView(name: post.name, photos: post.photoList, selectedPhotoIndex: selectedPhotoIndex ?? 0)
                    //                    }
                    //                    .padding(.top, 10)
                    
                    HStack() {
                        Text("Rating:")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.brown)
                        Text("\(post.rating)/5")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.brown)
                        
                        Spacer()
                        
                        Image(likedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .onTapGesture {
                                likedImage = "liked"
                                likedCount += 1
                            }
                        Text("\(likedCount)")
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(.brown)
                    }
                    .padding(.top, 10)
                }
                .padding()
                .padding(.horizontal)
                .padding(.bottom)
            }
            //.padding()
            .frame(width: 360)
            .background(Color.yellow.opacity(0.3))
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(""),
                    message: Text("Are you sure you want to delete this post?"),
                    primaryButton: .default(Text("Cancel")),
                    secondaryButton: .default(Text("Delete")) {
                        deleteAction()
                    })
            }
            .overlay(
                EditDeleteView(
                    showPopover: $showPopover,
                    post: post,
                    selectedPost: $selectedPost,
                    showAddDestination: $showAddDestination,
                    showAlert: $showAlert
                )
                .padding(.top, 50)
                .padding(.trailing, 25),
                alignment: .topTrailing
            )
        }
    }
}

struct EditDeleteView: View {
    @Binding var showPopover: Bool
    var post: Post
    var selectedPost: Binding<Post?>
    var showAddDestination: Binding<Bool>
    var showAlert: Binding<Bool>
    
    var body: some View {
        if showPopover {
            VStack {
                Button(action: {
                    withAnimation {
                        showPopover.toggle()
                    }
                    selectedPost.wrappedValue = post
                    showAddDestination.wrappedValue = true
                }) {
                    Text("Edit")
                        .foregroundColor(.brown)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
                Divider()
                    .foregroundColor(.brown)
                Button(action: {
                    withAnimation {
                        showPopover.toggle()
                    }
                    showAlert.wrappedValue = true
                }) {
                    Text("Delete")
                        .foregroundColor(.brown)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }
            }
            .frame(width: 100)
            .background(Color.yellow.opacity(0.2))
            .background(Color.white)
            .cornerRadius(10)
            .transition(.move(edge: .trailing))
            .animation(.easeInOut, value: showPopover)
        }
    }
}

//#Preview {
//    PostView(selectedPost: .constant(nil), showAddDestination: .constant(false), post: Post(id: UUID(), cityName: "Sample City", name: "Sample Post Samp  ", description: "Sample Post SampSample Post SampSample Post SampSample Post SampSample Post SampleSample Post SampSample Post SampSample Post SampSample Post SampSample Post SampleSample Post SampSample Post SampSample Post SampSample Post SampSample Post SampleSample Post SampSample Post SampSample Post SampSample Post SampSample Post Sample", location: "Sample Location Sample Location Sample Location Sample Location Sample Location Sample LocationSample Location", rating: 5, photoList: [UIImage(named: "Image")!,UIImage(named: "Image")!]), deleteAction: {})
//}

#Preview {
    LandingPageView()
}

