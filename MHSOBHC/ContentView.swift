//
//  ContentView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 10/8/2023.
//

import SwiftUI

public var competition = "14682"
public var value = "214624"
public var selTeam = "Over 45 D East"
public var selSection = "Vets"
public var selGrade = "26171"

struct ContentView: View {
    var body: some View {
        TabView {
            GamesView()
                .tabItem {
                    Image("hockeyTab0")
                    Text("Games")
                }
            LadderView()
                .tabItem {
                    Image("ladderTab1")
                    Text("Ladder")
                }
            Text("Hello")
                .tabItem {
                    Image(systemName: "house")
                }
            TeamsView()
                .tabItem {
                    Image( "unicornTab3")
                    Text("Teams")
                    
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
