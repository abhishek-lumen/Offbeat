//
//  FBHandler.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 03/04/25.
//
import FirebaseCore
import FirebaseFirestore


class FBHandler {
    var db: Firestore?
    
    init () {
        db = Firestore.firestore()
        
    }
    
    func getCityList() async -> [City] {
        guard let dbRef = db else {
            return []
        }
        var cityList: [City] = []
        do {
            let query = try await dbRef.collection("city").getDocuments()
            for document in query.documents {
                var data = document.data()
                            if let timestamp = data["createdAt"] as? Timestamp {
                                data["createdAt"] = timestamp.dateValue().timeIntervalSince1970
                            }
//                print(document)
//                print("\(document.documentID) => \(document.data())")
//                let jsonDecoder = JSONDecoder()
                do {
                    let json = try JSONSerialization.data(withJSONObject: data)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let cityData = try decoder.decode(City.self, from: json)
                    cityList.append(cityData)
                    
                } catch {
                    print(error)
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        return cityList.sorted { ($0.createdAt ?? Date.distantPast) > ($1.createdAt ?? Date.distantPast) }
    }
    
    
    func addCity(_ city: City) async -> Bool {
            guard let dbRef = db else {
                return false
            }
            do {
                try await dbRef.collection("city").addDocument(data: [
                    "id": city.id,
                    "name": city.name,
                    "createdAt": FieldValue.serverTimestamp(),
                    "imageName": city.name.lowercased()
                ])
                return true
            } catch {
                print("Error adding document: \(error)")
                return false
            }
        }
    
    
    
    func getPostList() async -> [Post] {
        guard let dbRef = db else {
            return []
        }
        var postList: [Post] = []
        do {
            let query = try await dbRef.collection("post").getDocuments()
            for document in query.documents {
                var data = document.data()
                if let timestamp = data["createdAt"] as? Timestamp {
                    data["createdAt"] = timestamp.dateValue().timeIntervalSince1970
                }
//                print(document)
//                print("\(document.documentID) => \(document.data())")
//                let jsonDecoder = JSONDecoder()
                do {
                    let json = try JSONSerialization.data(withJSONObject: data)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let postData = try decoder.decode(Post.self, from: json)
                    postList.append(postData)
                    
                } catch {
                    print(error)
                    print("Document data: \(data)")
                }
            }
        } catch {
            print("Error getting documents: \(error)")
            
        }
        return postList
    }
    
    
    
    func addPost(_ post: Post) async -> Bool {
            guard let dbRef = db else {
                return false
            }
            do {
                try await dbRef.collection("post").addDocument(data: [
                    "id": post.id,
                    "cityId": post.cityId,
                    "cityName": post.cityName,
                    "name": post.name,
                    "description": post.description,
                    "location": post.location,
                    "rating": post.rating,
                    "createdAt": FieldValue.serverTimestamp()
                ])
                return true
            } catch {
                print("Error adding document: \(error)")
                return false
            }
        }
    
    
    
}

