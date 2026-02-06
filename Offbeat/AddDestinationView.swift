//
//  AddDestinationView.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 28/03/25.
//

import SwiftUI
import PhotosUI

struct AddDestinationView: View {
    @Binding var showAddDestination: Bool
    @Binding var posts: [Post]
    @Binding var postToEdit: Post?
    //@State private var cityId: UUID = UUID()
    @State private var cityId: String = ""
    @State private var cityName: String = ""
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var rating: Int = 5
    @State private var ratingInput: String = "5"
    @State private var showAlert = false
    @State private var showImagePicker = false
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var photoList: [UIImage] = []
    var cities: [City]
    var selectedCity: String?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    Text(postToEdit == nil ? "Add Destination" : "Edit Destination")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(.brown)
                    
                    Divider()
                        .background(Color.brown)
                    
                    ScrollView {
                        VStack {
                            HStack {
                                if let selectedCity = selectedCity {
//                                    if let city = cities.first(where: { $0.name == selectedCity }) {
//                                            cityId = city.id
//                                        }
                                    
                                    Text("City : " + selectedCity)
                                        .font(.headline)
                                        .foregroundColor(.brown)
                                    
                                    Spacer()
                                } else {
                                    Text("City")
                                        .font(.headline)
                                        .foregroundColor(.brown)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Picker(selection: $cityName, label: Text("Select City").foregroundColor(.brown)) {
                                        Text("Select City").tag("")
                                        ForEach(cities, id: \.id) { city in
                                            Text(city.name).tag(city.name)
                                        }
                                    }
                                    .onChange(of: cityName) {
                                        if let selectedCity = cities.first(where: { $0.name == cityName }) {
                                            cityId = selectedCity.id
                                        }
                                    }
                                    .frame(width: 200, height: 40)
                                    .pickerStyle(MenuPickerStyle())
                                    .accentColor(.brown)
                                    .background(Color.white.opacity(0.4))
                                    .cornerRadius(10)
                                }
                            }
                            
                            Text("Destination")
                                .font(.headline)
                                .foregroundColor(.brown)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                            TextField("Enter offbeat name", text: $name)
                                .foregroundColor(.brown)
                                .padding()
                                .background(Color.white.opacity(0.4))
                                .cornerRadius(10)
                            
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.brown)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                            TextEditor(text: $description)
                                .foregroundColor(.brown)
                                .padding(.horizontal, 5)
                                .background(Color.white)
                                .cornerRadius(10)
                                .frame(height: 100)
                                .scrollIndicators(.hidden)
                            
                            HStack {
                                Text("Location")
                                    .font(.headline)
                                    .foregroundColor(.brown)
                                Image(systemName: "location.circle")
                                    .foregroundColor(.brown)
                                Spacer()
                            }
                            .padding(.top, 10)
                            TextField("Enter Map Link", text: $location)
                                .foregroundColor(.brown)
                                .padding()
                                .background(Color.white.opacity(0.4))
                                .cornerRadius(10)
                            
                            HStack {
                                Text("Add Shots")
                                    .font(.headline)
                                    .foregroundColor(.brown)
                                
                                ZStack(alignment: .center) {
                                    Color.brown
                                        .cornerRadius(15)
                                    Image("plus")
                                        .resizable()
                                        .scaledToFit()
                                        .colorInvert()
                                        .frame(width: 15, height: 15)
                                        .onTapGesture {
                                            selectedImages.removeAll()
                                            showImagePicker = true
                                        }
                                }
                                .frame(width: 25, height: 25)
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
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                                        ForEach(photoList, id: \.self) { image in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 45, height: 45)
                                                    .cornerRadius(5)
                                                
                                                Button(action: {
                                                    withAnimation {
                                                        if let index = photoList.firstIndex(of: image) {
                                                            photoList.remove(at: index)
                                                        }
                                                    }
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 15, height: 15)
                                                        .background(Color.white)
                                                        .foregroundColor(.brown)
                                                        .clipShape(Circle())
                                                }
                                                .offset(x: 3, y: 0)
                                            }
                                        }
                                    }
                                }
                                .padding(.leading, 10)
                            }
                            .padding(.top, 20)
                            
                            HStack {
                                Text("Rate Offbeat")
                                    .font(.headline)
                                    .foregroundColor(.brown)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Text("\(rating)")
                                        .foregroundColor(.brown)
                                        .padding()
                                    Stepper("", value: $rating, in: 1...5)
                                        .padding(.trailing, 10)
                                        .onChange(of: rating) { oldValue, newValue in
                                            ratingInput = "\(newValue)"
                                        }
                                }
                                .frame(width: 160, height: 50)
                                .background(Color.white.opacity(0.4))
                                .cornerRadius(10)
                            }
                            .padding(.top, 10)
                            
//                            let newCity = City(id: "\(UUID())", name: newCityName)
//                            Task {
//                                let success = await FBHandler().addCity(newCity)
//                                if success {
//                                    viewModel.cities.insert(newCity, at: 0)
//                                }
//                                newCityName = ""
//                            }
//                            
                            
                            
                            
                            Button(action: {
                                if cityName.isEmpty || location.isEmpty  {
                                    showAlert = true
                                } else {
                                    if let postToEdit = postToEdit {
                                        updatePost(postToEdit)
                                    } else {
                                        //savePost()
                                        let newPost = Post(id: "\(UUID())", cityId: cityId, cityName: cityName, name: name, description: description, location: location, rating: rating
                                                           //, photoList: photoList
                                        )
                                        Task {
                                            let success = await FBHandler().addPost(newPost)
                                            if success {
                                               // viewModel.cities.posts.insert(newPost, at: 0)
                                            }
                                        }
                                    }
                                    showAddDestination = false
                                }
                            }) {
                                Text(postToEdit == nil ? "Add" : "Update")
                                    .padding()
                                    .frame(width: 120, height: 40)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium))
                                    .background(Color.brown)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 20)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text(""), message: Text(cityName.isEmpty && location.isEmpty ? "City and Location are required" : (cityName.isEmpty ? "City is required" : "Location is required")),
                                      dismissButton: .default(Text("Ok")))
                            }
                        }
                        .padding()
                    }
                    .scrollIndicators(.hidden)
                }
                .padding()
                .frame(width: 360, height: 500)
                .background(Color.yellow.opacity(0.3))
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .overlay(
                    Button(action: {
                        showAddDestination = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.brown)
                            .font(.title)
                            .padding()
                    },
                    alignment: .topTrailing
                )
            }
        }
        .onAppear {
            if let selectedCity = selectedCity {
                cityName = selectedCity
            }
            if let postToEdit = postToEdit {
                cityName = postToEdit.cityName
                name = postToEdit.name
                description = postToEdit.description
                location = postToEdit.location
                rating = postToEdit.rating
               // photoList = postToEdit.photoList
            }
        }
    }
    
//    private func savePost() {
//        if let city = cities.first(where: { $0.name == selectedCity }) {
//                cityId = city.id
//            }
//        let newPost = Post(id: "\(UUID())", cityId: cityId, cityName: cityName, name: name, description: description, location: location, rating: rating
//                           //, photoList: photoList
//        )
//        posts.append(newPost)
//        var savedPosts = UserDefaults.standard.array(forKey: "posts") as? [[String: Any]] ?? []
//       // let imagePaths = saveImagesToDocumentsDirectory(images: photoList)
//        let newPostDict: [String: Any] = [
//            "id": newPost.id,
//            "cityId": cityId,
//            "cityName": cityName,
//            "name": name,
//            "description": description,
//            "location": location,
//            "rating": rating,
//           // "photoList": imagePaths
//        ]
//        savedPosts.append(newPostDict)
//        UserDefaults.standard.set(savedPosts, forKey: "posts")
//    }
    
    private func updatePost(_ post: Post) {
        if let selectedCity = cities.first(where: { $0.name == cityName }) {
            cityId = selectedCity.id
        }
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index] = Post(id: post.id, cityId: cityId, cityName: cityName, name: name, description: description, location: location, rating: rating
                               // , photoList: photoList
            )
            var savedPosts = UserDefaults.standard.array(forKey: "posts") as? [[String: Any]] ?? []
            if let savedIndex = savedPosts.firstIndex(where: { ($0["id"] as? String) == post.id }) {
               // let imagePaths = saveImagesToDocumentsDirectory(images: photoList)
                let updatedPostDict: [String: Any] = [
                    "id": post.id,
                    "cityId": cityId,
                    "cityName": cityName,
                    "name": name,
                    "description": description,
                    "location": location,
                    "rating": rating,
                   // "photoList": imagePaths
                ]
                savedPosts[savedIndex] = updatedPostDict
                UserDefaults.standard.set(savedPosts, forKey: "posts")
            }
        }
    }
    
    private func saveImagesToDocumentsDirectory(images: [UIImage]) -> [String] {
        var imagePaths: [String] = []
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        for (_, image) in images.enumerated() {
            if let imageData = image.pngData() {
                let fileName = "image_\(UUID().uuidString).png"
                let fileURL = documentsURL.appendingPathComponent(fileName)
                do {
                    try imageData.write(to: fileURL)
                    imagePaths.append(fileURL.path)
                } catch {
                    print("Error saving image: \(error.localizedDescription)")
                }
            }
        }
        return imagePaths
    }
}

//#Preview {
//    AddDestinationView(
//        showAddDestination: .constant(true),
//        posts: .constant([]),
//        postToEdit: .constant(nil),
//        cities: [
//            City(name: "Bangalore", imageName: "bangalore"),
//            City(name: "Mumbai", imageName: "mumbai"),
//            City(name: "Delhi-NCR", imageName: "delhi"),
//            City(name: "Kolkata", imageName: "kolkata"),
//            City(name: "Hyderabad", imageName: "hyderabad"),
//            City(name: "Jaipur", imageName: "jaipur"),
//            City(name: "Pune", imageName: "pune"),
//            City(name: "Chennai", imageName: "chennai")
//        ],
//        selectedCity: nil
//        //for Edit Destination
//        //postToEdit: .constant(Post(id: UUID(), cityName: "", name: "", description: "", location: "", rating: 0, photoList: [])),
//        //selectedCity: "nil"
//    )
//}
