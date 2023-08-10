//
//  LadderView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 10/8/2023.
//

import SwiftUI

struct Shape: Identifiable {
    var color: String
    var type: String
    var count: Int
    var id = UUID()
}

struct Ladder: Codable {
    var ladder: [LadderItem]
}

struct LadderItem: Codable {
    var id: Int
    var teamName: String
    var played: Int
    var wins: Int
    var draws: Int
    var losses: Int
    var forfeits: Int
    var byes: Int
    var scoreFor: Int
    var scoreAgainst: Int
    var diff: Int
    var points: Int
    var winRatio: Int
}

struct LadderView: View {
    @State private var ladder = [LadderItem]()
    @State var winRat: Int = 0
    
    var body: some View {
        
        NavigationStack {
            List(ladder, id: \.id) { item in
                VStack {
                    HStack {
                        Text("\(item.id)")
                        Text(item.teamName)
                            .fontWeight(.heavy)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Text("Wins: \(item.wins)")
                            Text("Loss: \(item.losses)")
                        }
                        Spacer()
                        VStack {
                            Text("Draw: \(item.draws)")
                            Text("Forf: \(item.forfeits)")
                        }
                        Spacer()
                        VStack {
                            Text("For: \(item.scoreFor)")
                            Text("Agst: \(item.scoreAgainst)")
                        }
                        Spacer()
                        VStack {
                            Text("Pts: \(item.points)")
                            Text("WR: \(item.winRatio)%")
                        }
                        Spacer()
                    }
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
        var teamName: String = ""
        var played: Int = 0
        var wins: Int = 0
        var draws: Int = 0
        var losses: Int = 0
        var forfeits: Int = 0
        var byes: Int = 0
        var scoreFor: Int = 0
        var scoreAgainst: Int = 0
        var diff: Int = 0
        var points: Int = 0
        var winRatio: Int = 0
        ladder = []
        guard let url = URL(string: "https://www.hockeyvictoria.org.au/pointscores/" + competition + "/&d=" + selGrade) else {
            print("Invalid URL")
            return
        }
        do {
            let html = try String.init(contentsOf: url)
            let line = html.split(whereSeparator: \.isNewline)
            for i in 0 ..< line.count {
                if line[i].contains("hockeyvictoria.org.au/teams/") {
                    id += 1
                    teamName = String(line[i].replacingOccurrences(of: "<", with: ">").split(separator: ">")[2].replacingOccurrences(of: " Hockey Club", with: "").replacingOccurrences(of: " Hockey Association", with: "").replacingOccurrences(of: " Hockey Organisation", with: ""))
                    let lineArray = line[i+2].replacingOccurrences(of: ">", with: "<").split(separator: "<")
                    played = Int(lineArray[2]) ?? 0
                    wins = Int(lineArray[5]) ?? 0
                    draws = Int(lineArray[8]) ?? 0
                    losses = Int(lineArray[11]) ?? 0
                    forfeits = Int(lineArray[14]) ?? 0
                    byes = Int(lineArray[17]) ?? 0
                    scoreFor = Int(lineArray[20]) ?? 0
                    scoreAgainst = Int(lineArray[23]) ?? 0
                    diff = Int(lineArray[26]) ?? 0
                    points = Int(lineArray[29]) ?? 0
                    winRatio = Int(lineArray[33]) ?? 0
                    ladder.append(LadderItem(id: id, teamName: teamName, played: played, wins: wins, draws: draws, losses: losses, forfeits: forfeits, byes: byes, scoreFor: scoreFor, scoreAgainst: scoreAgainst, diff: diff, points: points, winRatio: winRatio))
                    
                }
            }
            print(competition)
            print(selGrade)
        } catch {
            print("Invalid data")
            
        }
    }
}

struct LadderView_Previews: PreviewProvider {
    static var previews: some View {
        LadderView()
    }
}
