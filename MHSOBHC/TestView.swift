//
//  TestView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 11/8/2023.
//

import SwiftUI

struct Pokemon {
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


struct TestView: View {
    var pokemonList = [Pokemon(id: 1, teamName: "Hawthorn", played: 13, wins: 11, draws: 0, losses: 2, forfeits: 0, byes: 0, scoreFor: 43, scoreAgainst: 21, diff: 22, points: 26, winRatio: 95), Pokemon(id: 2, teamName: "MHSOB", played: 13, wins: 9, draws: 1, losses: 3, forfeits: 0, byes: 0, scoreFor: 22, scoreAgainst: 24, diff: -2, points: 20, winRatio: 59)]
    
    var body: some View {
        List(pokemonList, id: \.id) { pokemon in
            HStack {
                VStack {
                    Text(pokemon.teamName)
                    Color(.green)
                        .frame(width: CGFloat(pokemon.wins))

                }
                
                
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
