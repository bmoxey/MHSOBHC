//
//  TeamsView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 10/8/2023.
//

import SwiftUI


struct Team: Identifiable {
    let id = UUID()
    let name: String
    let section: String
    let competition: String
    let grade: String
    let teamID: String
}

struct TeamsView: View {
    @State var myComp = myCompID
    @State var myValue = myTeamID
    
    
    let teams = [
        Team(name: "Vic League 2", section: "Womens", competition: "14518", grade: "25985", teamID: "210764"),
        Team(name: "Metro 1 East", section: "Womens", competition: "14518", grade: "26248", teamID: "216042"),
        Team(name: "Vic League 2", section: "Mens", competition: "14518", grade: "25980", teamID: "210719"),
        Team(name: "Vic League 2 Reserves", section: "Mens", competition: "14518", grade: "25981", teamID: "210728"),
        Team(name: "Metro 1", section: "Mens", competition: "14518", grade: "26236", teamID: "216041"),
        Team(name: "Over 45 B SE", section: "vets", competition: "14682", grade: "26168", teamID: "214605"),
        Team(name: "Over 45 D East", section: "vets", competition: "14682", grade: "26171", teamID: "214624")]
    
    func groupBySection(_ teams: [Team]) -> [(String, [Team])] {
        let grouped = Dictionary(grouping: teams, by: { $0.section })
        return grouped.sorted(by: { $0.key < $1.key })
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupBySection(teams), id:\.0) { pair in
                    Section(header:
                                Text(pair.0))
                    {
                        ForEach(pair.1) {team in
                            HStack {
                                
                                if team.competition == myComp && team.teamID == myValue {
                                Image(systemName: "checkmark")
                            }
                            Text(team.name)
                            }
                            .gesture(TapGesture(count: 1).onEnded({
                                myCompID = team.competition
                                myTeamID = team.teamID
                                myGradeName = team.name
                                myCompName = team.section.capitalized
                                myGradeID = team.grade
                                myComp = myCompID
                                myValue = myTeamID
                                Task  {
                                    do {
                                        let _ = try await loadData()
                                    }
                                    catch {
                                        print(error)
                                    }
                                }
                                
                            }))
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("MHSOBHC Teams").font(.headline)
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
    func loadData() async throws -> String {
        var score: String = ""
        var result: String = ""
        nextGameDetails = ""
        guard let url = URL(string: "https://www.hockeyvictoria.org.au/teams/" + myCompID + "/&t=" + myTeamID) else {
            return("Invalid URL")
        }
        
        do {
            let html = try String.init(contentsOf: url)
            let line = html.split(whereSeparator: \.isNewline)
            for i in 0 ..< line.count {
                if line[i].contains("col-lg-3 pb-3 pb-lg-0 text-center") {
                        
                    score = String(line[i+2].replacingOccurrences(of: "<div class=\"badge badge-danger\">FF</div>", with: "").replacingOccurrences(of: "<", with: ">").split(separator: ">")[5])
                    if score == "div" {
                        score = ""
                        result = ""
                    } else {
                        result = String(line[i+2].replacingOccurrences(of: "<div class=\"badge badge-danger\">FF</div>", with: "").replacingOccurrences(of: "<", with: ">").split(separator: ">")[9])
                    }
                    
                }
                if line[i].contains("btn btn-outline-primary btn-sm") {
                    if nextGameDetails == "" && result == "" {
                        nextGameDetails = String(line[i].split(separator: "\"")[3])
                    }
                }
            }
            // more to come
        } catch {
            return("Invalid data")
        }
        return("")
    }

}

struct TeamsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsView()
    }
}
