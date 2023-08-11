//
//  NextGameView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 11/8/2023.
//

import MapKit
import SwiftUI

struct NextGameView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.824556, longitude: 144.963211), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack() {
                    Text("Knox")
                        .fontWeight(.bold)
                        .padding(.top)
                    Text("vs")
                    Text("Melbourne High School Old Boys")
                        .fontWeight(.bold)
                    Divider()
                    Text("Sat 17 Jun 2023 15:30")
                    Text("Match starts in 2 days and 2 hours")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                Map(coordinateRegion: $region,
                    interactionModes: .all,
                    showsUserLocation: true
                )
                .ignoresSafeArea(edges: .all)
                HStack {
                    Image("groundTab2")
                    Text("KNX")
                }
                Text("Wantirna Reserve 61 Mountain Hwy, Wantirna VIC 3152")
                    .padding(.horizontal)
                    .padding(.bottom)

                
                
                .navigationBarTitleDisplayMode(.inline)
                
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Next Game").font(.headline)
                                .foregroundColor(Color("Gold"))
                            Text(myCompName + " : " + myGradeName).font(.subheadline)
                                .foregroundColor(Color("Gold"))
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image("logo")
                            .resizable()
                            .frame(minWidth: 40, idealWidth: 40, maxWidth: 40, minHeight: 40, idealHeight: 40, maxHeight: 40, alignment: .center)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(Color("Gold"))
                        }
                    }
                    
                }
                
                .toolbarBackground(Color("Maroon"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color("Maroon"), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
        }
    }
}

struct NextGameView_Previews: PreviewProvider {
    static var previews: some View {
        NextGameView()
    }
}
