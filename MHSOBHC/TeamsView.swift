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
    let value: String
}

struct TeamsView: View {
    @State var myComp = competition
    @State var myValue = value
    
    
    let teams = [
        Team(name: "Vic League 2", section: "Womens", competition: "14518", grade: "25985", value: "210764"),
        Team(name: "Metro 1 East", section: "Womens", competition: "14518", grade: "26248", value: "216042"),
        Team(name: "Vic League 2", section: "Mens", competition: "14518", grade: "25980", value: "210719"),
        Team(name: "Vic League 2 Reserves", section: "Mens", competition: "14518", grade: "25981", value: "210728"),
        Team(name: "Metro 1", section: "Mens", competition: "14518", grade: "26236", value: "216041"),
        Team(name: "Over 45 B SE", section: "vets", competition: "14682", grade: "26168", value: "214605"),
        Team(name: "Over 45 D East", section: "vets", competition: "14682", grade: "26171", value: "214624")]
    
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
                                
                                if team.competition == myComp && team.value == myValue {
                                Image(systemName: "checkmark")
                            }
                            Text(team.name)
                            }
                            .gesture(TapGesture(count: 2).onEnded({
                                competition = team.competition
                                value = team.value
                                selTeam = team.name
                                selSection = team.section.capitalized
                                selGrade = team.grade
                                myComp = competition
                                myValue = value
                            }))
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("MHSOB Teams")
            .navigationBarTitleDisplayMode(.inline)
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
    


}

struct TeamsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsView()
    }
}
