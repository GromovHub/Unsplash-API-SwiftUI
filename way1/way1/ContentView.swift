//
//  ContentView.swift
//  way1
//
//  Created by Vitaly Gromov on 6/26/22.
//

import SwiftUI
import UnsplashSwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            UnsplashRandom(clientId: "1_RusPERzdidJ_akL0iHjgf03x1ivIjhp7algRGIPzM")
            UnsplashRandom(clientId: "1_RusPERzdidJ_akL0iHjgf03x1ivIjhp7algRGIPzM")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
