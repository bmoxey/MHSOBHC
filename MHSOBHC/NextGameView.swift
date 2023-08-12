//
//  NextGameView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 11/8/2023.
//

import MapKit
import SwiftUI
import CoreLocation

struct NextGameView: View {
    @State private var team1 = ""
    @State private var team2 = ""
    @State private var dateTime = ""
    @State private var starts = ""
    @State private var venue = ""
    @State private var field = ""
    @State private var isGame: Bool = false
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.824556, longitude: 144.963211), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    var body: some View {
        NavigationStack {
            
            VStack {
                if isGame {
                    Text(team1)
                        .fontWeight(.bold)
                        .padding(.top)
                    Text("vs")
                    Text(team2)
                        .fontWeight(.bold)
                    Divider()
                    Text(dateTime)
                    if starts != "" {
                        Text(starts)
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
                        Text(field)
                    }
                    Text(venue)
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
            }.task {
                await loadData()
            }
            
        }
    }
    
    func loadData() async {
        if nextGameDetails != "" {
            isGame = true
            guard let url = URL(string: nextGameDetails) else {
                print("Invalid URL")
                return
            }
            
            do {
                var count = 0
                let html = try String.init(contentsOf: url)
                let line = html.split(whereSeparator: \.isNewline)
                for i in 0 ..< line.count {
                    if line[i].contains("www.hockeyvictoria.org.au/teams/") {
                        count += 1
                        if count == 1 {
                            team1 = String(line[i].replacingOccurrences(of: ">", with: "<").replacingOccurrences(of: " Hockey Club", with: "").replacingOccurrences(of: " Hockey Association", with: "").replacingOccurrences(of: " Hockey Organisation", with: "").split(separator: "<")[4])
                            team2 = String(line[i].replacingOccurrences(of: ">", with: "<").replacingOccurrences(of: " Hockey Club", with: "").replacingOccurrences(of: " Hockey Association", with: "").replacingOccurrences(of: " Hockey Organisation", with: "").split(separator: "<")[10])
                        }
                    }
                    if line[i].contains("Date &amp; time") {
                        dateTime = String(line[i+1].replacingOccurrences(of: "      ", with: ""))
                        let dateFormatter = DateFormatter()
                        let today = Date.now
                        dateFormatter.dateFormat = "E dd MMM yyyy HH:mm"
                        let startDate = dateFormatter.date(from: dateTime)!
                        let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: today, to: startDate)
                        let days = diffComponents.day
                        let hrs = diffComponents.hour
                        let mins = diffComponents.minute
                        if days! > 0 || (days! == 0 && hrs! > 0) {
                            starts = "Starts in \(days!) days, \(hrs!) hours, \(mins!) minutes"
                        } else {
                            starts = ""
                        }
                    }
                    if line[i].contains("Venue") {
                        venue = String(line[i+1].replacingOccurrences(of: "      ", with: "").replacingOccurrences(of: "<div class=\"font-size-sm\">", with: " ").replacingOccurrences(of: "</div>", with: ""))
                        Task  {
                            do {
                                try await lookupCoordinates(venue: venue)
                            }
                            catch {
                                print(error)
                            }
                        }
                        
                    }
                    if line[i].contains(">Field<") {
                        field = String(line[i+1].replacingOccurrences(of: "      ", with: ""))
                    }
                }
            }
            catch {
                print("Invalid data")
            }
        } else {
            isGame = false
        }
    }
    
    struct NextGameView_Previews: PreviewProvider {
        static var previews: some View {
            NextGameView()
        }
    }
    
    func getCoordinate(from address: String) async throws -> CLLocationCoordinate2D {
        let geocoder = CLGeocoder()

        guard let location = try await geocoder.geocodeAddressString(address)
            .compactMap( { $0.location } )
            .first(where: { $0.horizontalAccuracy >= 0 } )
        else {
            throw CLError(.geocodeFoundNoResult)
        }

        return location.coordinate
    }
    
    func lookupCoordinates(venue: String) async throws {
        let coordinate = try await getCoordinate(from: venue)
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    }
    
    
}

