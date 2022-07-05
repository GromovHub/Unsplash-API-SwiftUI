//
//  OneListCode.swift
//  way2
//
//  Created by Vitaly Gromov on 7/5/22.
//

import SwiftUI

struct OneListCode: View {
    @State private var currentSession: Model = Model()
    var body: some View {
        NavigationView {
            AsyncImage(url: currentSession.getURL(), scale: 2)
            Text(currentSession.getDescription())
            Button("Get Photo") {
                currentSession = Model()
            }
        }
        .navigationTitle(Text("Unsplash"))
    }
}

class Model {
    let currentSession: Model.First
    init() {
        // I can't do it now
        currentSession = decodedData()
    }
    struct First: Codable {
        let description: String
        let urls: Second
    }
    struct Second: Codable {
        let small: String
    }
    private let myURL: URL? = URL(string: "https://api.unsplash.com/photos/random/?client_id=1_RusPERzdidJ_akL0iHjgf03x1ivIjhp7algRGIPzM")
   
   
    private func createSession() -> Data? {
        var result: Data?
        URLSession.shared.dataTask(with: myURL!) { data, response, error in
            result = data
        }
        return result
    }
    private func decodedData() -> Model.First {
        let data: Data? = createSession()
        let decoder = JSONDecoder()
        let result = try? decoder.decode(First.self, from: data!)
        guard result != nil else {
            print("invalid decoding")
            return result!
        }
        return result!
    }
    

    func getURL() -> URL {
        let url = URL(string: currentSession.urls.small)
        guard url != nil else {
            print("invalid url")
            return url!
        }
        return url!
    }
    func getDescription() -> String {
        currentSession.description
    }
    
}





























struct OneListCode_Previews: PreviewProvider {
    static var previews: some View {
        OneListCode()
    }
}
