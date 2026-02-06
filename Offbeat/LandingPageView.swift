//
//  LandingPageView.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 28/03/25.
//

import SwiftUI
import FirebaseFirestore

struct City: Identifiable, Codable, Equatable {
    var id : String
    let name: String
    var imageName: String?
    var latitude: String?
    var longitude: String?
    var location: String?
    var createdAt: Date?
}

struct LandingPageView: View {
    @ObservedObject var viewModel = LandingPageViewModel()
    @State private var showAddDestination = false
    @State private var showProfileView = false
    @State private var posts: [Post] = []
    @State private var selectedPost: Post? = nil
    @State private var showAddCity = false
    @State private var showAlert = false
//    @State private var cities: [City] = [
//        City(name: "Bangalore", imageName: "bangalore"),
//        City(name: "Mumbai", imageName: "mumbai"),
//        City(name: "Delhi-NCR", imageName: "delhi"),
//        City(name: "Kolkata", imageName: "kolkata"),
//        City(name: "Hyderabad", imageName: "hyderabad"),
//        City(name: "Jaipur", imageName: "jaipur"),
//        City(name: "Pune", imageName: "pune"),
//        City(name: "Chennai", imageName: "chennai")
//    ]
    @State private var newCityName: String = ""
    @State private var newCityImageName: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.yellow.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0) {
                    HStack {
                        Text("Off Beat")
                            .font(.largeTitle)
                            .fontWeight(.light)
                            .foregroundColor(.brown)
                        Spacer()
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [.orange.opacity(0.3), .yellow.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                                .cornerRadius(10)
                            Image("map")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    showAddDestination = true
                                }
                        }
                        .frame(width: 50, height: 50)
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [.orange.opacity(0.3), .yellow.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                                .cornerRadius(10)
                            Image("profile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    showProfileView = true
                                }
                        }
                        .frame(width: 50, height: 50)
                    }
                    
                    Divider()
                        .background(Color.brown)
                        .padding(.top)
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(Array(stride(from: 0, to: viewModel.cities.count, by: 2)), id: \.self) { index in
                                HStack(spacing: 15) {
                                    CitiesCardView(cityName: viewModel.cities[index].name, destination: CityView(showAddDestination: $showAddDestination, cityName: viewModel.cities[index].name, cityId: viewModel.cities[index].id, cities: viewModel.cities), imageName: viewModel.cities[index].imageName ?? "", showAddDestination: $showAddDestination){
                                        viewModel.cities.remove(at: index)
                                    }
                                    if index + 1 < viewModel.cities.count {
                                        CitiesCardView(cityName: viewModel.cities[index + 1].name, destination: CityView(showAddDestination: $showAddDestination, cityName: viewModel.cities[index + 1].name, cityId: viewModel.cities[index + 1].id, cities: viewModel.cities), imageName: viewModel.cities[index + 1].imageName ?? "", showAddDestination: $showAddDestination){
                                            viewModel.cities.remove(at: index + 1)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .onAppear {
                        Task {
                            viewModel.cities =  await FBHandler().getCityList()
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding()
                
                if !showAddCity {
                    ZStack {
                        Color.white
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        Color.yellow.opacity(0.4)
                            .cornerRadius(15)
                        Text("Add City")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundStyle(.brown)
                    }
                    .frame(width: 85, height: 45)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    
                    .padding()
                    .onTapGesture {
                        showAddCity = true
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(""), message: Text("City name is required to add a new city"),
                              dismissButton: .default(Text("Ok")))
                    }
                } else {
                    GeometryReader { geometry in
                        ZStack {
                            Color.black.opacity(0.2)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    showAddCity = false
                                }
                            ZStack {
                                VStack {
                                    TextField("Enter city name", text: $newCityName)
                                        .padding()
                                        .foregroundColor(.brown)
                                        .background(Color.white.opacity(0.4))
                                        .cornerRadius(10)
                                    
                                    Button(action: {
                                        if newCityName.isEmpty {
                                            showAlert = true
                                        } else {
                                            let newCity = City(id: "\(UUID())", name: newCityName)
                                            Task {
                                                let success = await FBHandler().addCity(newCity)
                                                if success {
                                                    viewModel.cities.insert(newCity, at: 0)
                                                }
                                                newCityName = ""
                                            }
                                        }
                                        showAddCity = false
                                    }) {
                                        Text("Add City")
                                            .padding(15)
                                            .font(.headline)
                                            .fontWeight(.light)
                                            .background(Color.brown)
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                    }
                                    .padding(.top, 10)
                                }
                                .padding()
                            }
                            .background(Color.yellow.opacity(0.4))
                            .background(Color.white)
                            .cornerRadius(15)
                            .frame(width: 250)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .shadow(radius: 10)
                            .offset(x: showAddCity ? 0 : -geometry.size.width)
                        }
                    }
                }
                
                if showProfileView {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Color.black.opacity(0.2)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    showProfileView = false
                                }
                            ProfileView(showProfileView: $showProfileView)
                                .frame(width: 280)
                                .offset(x: showProfileView ? 0 : -geometry.size.width)
                        }
                    }
                }
                
                if showAddDestination {
                    AddDestinationView(showAddDestination: $showAddDestination, posts: $posts, postToEdit: $selectedPost, cities: viewModel.cities)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    private func saveCitiesToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(viewModel.cities) {
            UserDefaults.standard.set(encoded, forKey: "cities")
        }
    }
    
    private func loadCitiesFromUserDefaults() {
        if let savedCities = UserDefaults.standard.data(forKey: "cities"),
           let decodedCities = try? JSONDecoder().decode([City].self, from: savedCities) {
            viewModel.cities = decodedCities
        }
    }
}

struct CitiesCardView<Destination: View>: View {
    var cityName: String
    var destination: Destination
    var imageName: String
    @Binding var showAddDestination: Bool
    var onDelete: () -> Void
    
    var body: some View {
        NavigationLink(destination: destination.navigationBarBackButtonHidden(true).toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                DismissButton(cityName: cityName, showAddDestination: $showAddDestination)
            }
        }) {
            ZStack(alignment: .top) {
                LinearGradient(gradient: Gradient(colors: [.orange.opacity(0.3), .yellow.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                    .cornerRadius(15)
                VStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(15)
                        .padding(.top, 10)
                    
                    Divider()
                        .background(Color.brown)
                        .padding(.horizontal, 10)
                    
                    Text(cityName)
                        .font(.title2)
                        .fontWeight(.light)
                        .foregroundColor(.brown)
                        .padding(.bottom, 15)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .contextMenu {
            Button(action: onDelete) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
}

struct DismissButton: View {
    @Environment(\.presentationMode) var presentationMode
    var cityName: String
    @Binding var showAddDestination: Bool
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                ZStack {
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .frame(width: 35, height: 35)
                .background(Color.yellow.opacity(0.6))
                .cornerRadius(20)
            }
            Text(showAddDestination ? "" : cityName)
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(.brown)
        }
    }
}


#Preview {
    LandingPageView()
}

//extension Color {
//    static let yellow = Color.blue
//}

//Notes
//for images and icons
//https://iconscout.com/free-icon-pack/heritage-places-indian-cities_3319


