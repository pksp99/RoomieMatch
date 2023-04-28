//
//  ContentMainView.swift
//  RoomieMatch
//
//  Created by Preet Karia on 4/28/23.
//

import SwiftUI

struct ContentMainView: View {
   
    var body: some View {
        NavigationView {
            TabView {
               
                SearchListView()
                    .tabItem {
                        Image("ic-search")
                            .renderingMode(.template)
                        Text("Search")
                    }
        
                Text("Second View")
                    .tabItem {
                        Image("ic-messages")
                            .renderingMode(.template)
                        Text("Messages")
                    }
                Text("Third View")
                    .tabItem {
                        Image("ic-account")
                            .renderingMode(.template)
                        Text("Accounts")
                    }
            }

        }

    }
}
struct ContentMainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMainView()
    }
}
