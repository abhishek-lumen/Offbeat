//
//  LandingPageViewModel.swift
//  Offbeat
//
//  Created by Gupta, Abhishek on 03/04/25.
//

import SwiftUI

class LandingPageViewModel : ObservableObject {
    @Published  var cities: [City] = []
    
    init() {
    }
  
    func fetchCities() async {
        cities =  await FBHandler().getCityList()
    }
    
}
