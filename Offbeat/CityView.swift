//
//  CityView.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 28/03/25.
//

import SwiftUI

struct CityView: View {
    //@State private var posts: [Post] = []
//    func fetchPosts() {
//        let posts = viewModel.posts
//        print("Fetched \(posts.count) posts.")
//    }
    
    @ObservedObject var viewModel = CityViewModel()
    @Binding var showAddDestination: Bool
    @State private var selectedPost: Post? = nil
    var cityName: String
    var cityId: String
    
    var cities: [City]
    
    var body: some View {
        NavigationStack {
            if !showAddDestination {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 0, alignment: .top)
                    .edgesIgnoringSafeArea(.all)
            }
            ZStack {
                Color.yellow.opacity(0.1).edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(viewModel.posts) { post in
                            if post.cityId == cityId {
                                PostView(selectedPost: $selectedPost,
                                         showAddDestination: $showAddDestination,
                                         post: post,
                                         deleteAction: {
                                    deletePost(post)
                                })
                                .padding()
                            }
                        }
                    }
                }
                .onAppear {
                    //posts = Post.loadPosts().reversed()
                    Task {
                        viewModel.posts = await FBHandler().getPostList()
                    }
                }
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.white)
                        .fill(Color.yellow.opacity(0.2))
                        .frame(height: 40)
                    Capsule()
                        .fill(Color.white)
                        .fill(Color.yellow.opacity(0.2))
                        .frame(width: 75, height: 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    Color.white
                        .cornerRadius(35)
                    Color.yellow.opacity(0.6)
                        .cornerRadius(35)
                    
                    Image("plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            selectedPost = nil
                            showAddDestination = true
                        }
                }
                .frame(width: 60, height: 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                if showAddDestination {
                    AddDestinationView(showAddDestination: $showAddDestination,
                                       posts: $viewModel.posts,
                                       postToEdit: $selectedPost,
                                       cities: cities, selectedCity: cityName)
                }
            }
//            .onAppear {
//                //posts = Post.loadPosts().reversed()
//                Task {
//                    viewModel.posts = await FBHandler().getPostList().reversed()
//                }
//            }
//            .onChange(of: showAddDestination) {
//                //posts = Post.loadPosts().reversed()
//                Task {
//                    viewModel.posts = await FBHandler().getPostList().reversed()
//                }
//            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func deletePost(_ post: Post) {
        viewModel.posts.removeAll { $0.id == post.id }
        var savedPosts = UserDefaults.standard.array(forKey: "posts") as? [[String: Any]] ?? []
        savedPosts.removeAll { ($0["id"] as? String) == post.id }
        UserDefaults.standard.set(savedPosts, forKey: "posts")
    }
}

//#Preview {
//    CityView(showAddDestination: Binding.constant(true), cityName: "Bangalore")
//}


class CityViewModel : ObservableObject {
    @Published  var posts: [Post] = []
    
    init() {
    }
  
    func fetchPosts() async {
        posts =  await FBHandler().getPostList()
    }
    
}
