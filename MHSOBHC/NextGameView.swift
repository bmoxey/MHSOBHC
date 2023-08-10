//
//  NextGameView.swift
//  MHSOBHC
//
//  Created by Brett Moxey on 11/8/2023.
//

import SwiftUI

struct NextGameView: View {
    var body: some View {
        NavigationStack {
            Text("\(nextGameDetails)")
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

struct NextGameView_Previews: PreviewProvider {
    static var previews: some View {
        NextGameView()
    }
}
