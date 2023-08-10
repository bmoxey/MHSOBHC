//
//  GamesView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 10/8/2023.
//

import SwiftUI

struct Games: Codable {
    var games: [Game]
}

struct Game: Codable {
    var id: Int
    var roundID: String
    var dateTime: String
    var venue: String
    var opponent: String
    var score: String
    var starts: String
    var result: String
}

struct GamesView: View {
    @State private var games = [Game]()
    
    var body: some View {
        NavigationStack {
            List(games, id: \.id) { item in
                HStack {
                    Text(item.roundID)
                        .frame(width: 18)
                    Spacer()
                    VStack {
                        Text("\(item.opponent) @ \(item.venue)")
                            .fontWeight(.bold)
                        Text("\(item.dateTime)")
                            .font(.subheadline)
                        if item.starts != "" {
                            Text("\(item.starts)")
                                .foregroundColor(Color.red)
                        }
                    }
                    Spacer()
                    VStack {
                        Text(item.score)
                        if item.result == "Win" {
                            Text("\(item.result)")
                                .background(.green)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                        } else if item.result == "Loss" {
                            Text("\(item.result)")
                                .background(.red)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                        } else if item.result == "Draw" {
                            Text("\(item.result)")
                                .background(.gray)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                        } else  {
                            Text("\(item.result)")
                                .background(.cyan)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                        }
                    }
                    .frame(width: 48)
                }
            }
            .background(Color("Green"))
            .scrollContentBackground(.hidden)
            .listStyle(GroupedListStyle())
            .task {
                await loadData()
            }
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Game Schedule")
                            .foregroundColor(Color("Gold"))
                            .fontWeight(.bold)
                        Text("\(myCompName) - \(myGradeName)")
                            .foregroundColor(Color("Gold"))
                            .font(.subheadline)
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
    
    func loadData() async {
        var id: Int = 0
        var round: String = ""
        var dateTime: String = ""
        var venue: String = ""
        var opponent: String = ""
        var score: String = ""
        var starts: String = ""
        var result: String = ""
        games = []
        guard let url = URL(string: "https://www.hockeyvictoria.org.au/teams/" + myCompID + "/&t=" + myTeamID) else {
            print("Invalid URL")
            return
        }
        
        do {
            let html = try String.init(contentsOf: url)
            let line = html.split(whereSeparator: \.isNewline)
            for i in 0 ..< line.count {
                if line[i].contains("col-md pb-3 pb-lg-0 text-center text-md-left") {
                    id += 1
                    round = String(line[i+1].replacingOccurrences(of: "<", with: ">").split(separator: ">")[2]).replacingOccurrences(of: "Round ", with: "")
                    dateTime = String(line[i+2].replacingOccurrences(of: "      ", with: "").replacingOccurrences(of: "<br />", with: " @ "))
                    let dateFormatter = DateFormatter()
                    let today = Date.now
                    dateFormatter.dateFormat = "E dd MMM yyyy @ HH:mm"
                    let startDate = dateFormatter.date(from: dateTime)!
                    let diffComponents = Calendar.current.dateComponents([.day, .hour, .minute], from: today, to: startDate)
                    let days = diffComponents.day
                    let hrs = diffComponents.hour
                    if days! > 0 || (days! == 0 && hrs! > 0){
                        starts = "Starts in \(days!) days and \(hrs!) hours"
                    } else {
                        starts = ""
                    }
                    
                }
                if line[i].contains("col-md pb-3 pb-lg-0 text-center text-md-right text-lg-left") {
                    venue = String(line[i+2].replacingOccurrences(of: "<", with: ">").split(separator: ">")[2])
                }
                if line[i].contains("col-lg-3 pb-3 pb-lg-0 text-center") {
                    if venue == "/div" {
                        venue = "BYE"
                        opponent = "BYE"
                        score = "BYE"
                    } else {
                        
                        opponent = String(line[i+2].replacingOccurrences(of: "<", with: ">").split(separator: ">")[2].replacingOccurrences(of: " Hockey Club", with: "").replacingOccurrences(of: " Hockey Association", with: "").replacingOccurrences(of: " Hockey Organisation", with: ""))
                        score = String(line[i+2].replacingOccurrences(of: "<div class=\"badge badge-danger\">FF</div>", with: "").replacingOccurrences(of: "<", with: ">").split(separator: ">")[5])
                        if score == "div" {
                            score = ""
                            result = ""
                        } else {
                            result = String(line[i+2].replacingOccurrences(of: "<div class=\"badge badge-danger\">FF</div>", with: "").replacingOccurrences(of: "<", with: ">").split(separator: ">")[9])
                        }
                    }
                    games.append(Game(id: id, roundID: round, dateTime: dateTime, venue: venue, opponent: opponent, score: score, starts: starts, result: result))
                    
                }
                if line[i].contains("btn btn-outline-primary btn-sm") {
                    if nextGameDetails == "" && result == "" {
                        nextGameDetails = String(line[i].split(separator: "\"")[3])
                    }
                }
            }
            // more to come
        } catch {
            print("Invalid data")
            
        }
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
