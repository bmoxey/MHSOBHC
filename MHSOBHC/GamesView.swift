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
}

struct GamesView: View {
    @State private var games = [Game]()

    var body: some View {
        NavigationStack {
            List(games, id: \.id) { item in
                HStack {
                    Text(item.roundID)
                        .frame(width: 32)
                    Spacer()
                    VStack {
                        Text("\(item.opponent) @ \(item.venue)")
                            .fontWeight(.heavy)
                        Text("\(item.dateTime)")
                        if item.starts != "" {
                            Text("\(item.starts)")
                                .foregroundColor(Color.red)
                        }
                    }
                    Spacer()
                    Text(item.score)
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
                        Text("Game Schedule").font(.headline)
                            .foregroundColor(Color("Gold"))
                        Text(selSection + " : " + selTeam).font(.subheadline)
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
        games = []
        guard let url = URL(string: "https://www.hockeyvictoria.org.au/teams/" + competition + "/&t=" + value) else {
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
                    score = String(line[i+2].replacingOccurrences(of: "<", with: ">").split(separator: ">")[5])
                    if score == "div" { score = "" }
                    }
                    games.append(Game(id: id, roundID: round, dateTime: dateTime, venue: venue, opponent: opponent, score: score, starts: starts))
                    
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
