//
//  ContentView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 10/8/2023.
//

import SwiftUI

public var myCompName = "Vets"
public var myCompID = "14682"
public var myGradeName = "Over 45 D East"
public var myGradeID = "26171"
public var myTeamID = "214624"
public var nextGameDetails = ""

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
            NextGameView()
                .tabItem {
                    Image("groundTab2")
                    Text("Next Game")
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
