//
//  ContentView.swift
//  way2
//
//  Created by Vitaly Gromov on 6/26/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var logic = Logic()
    @State var url = "click to random"
    var body: some View {
        VStack {
            Text(url)
            Button("go") {
                url = Logic.getDogUrl()
                print("this is url ---> \(url)")
            }
            AsyncImage(url: URL(string: url)) { image in
                image.resizable()
                    
            } placeholder: {
                ProgressView()
            }
            .frame(width: 300, height: 500)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UnsplashResponseObject: Codable {
    let id: String
    let description: String
    let urls: UnsplashURLs
}
struct UnsplashURLs: Codable {
    let small: String
}

class Logic: ObservableObject{
//    let url: String
//    init() {
//        self.url = Logic.getRandomImageUrl()
//    }
    
    // https:\/\/i.imgflip.com\/30b1gx.jpg
    
    static func getRandomImageUrl() -> String {
        var stringURL: String = "nothing"
        URLSession(configuration: .default).dataTask(with: URL(string: "https://api.unsplash.com/photos/random/?client_id=1_RusPERzdidJ_akL0iHjgf03x1ivIjhp7algRGIPzM")!) { data, response, error in
            print("MESSAGE FROM SESSION")
            let decoding = try? JSONDecoder().decode(UnsplashResponseObject.self, from: data!)
            
            guard decoding?.urls.small != nil else {
                stringURL = "https://images.unsplash.com/photo-1656513014654-420af5aa6896?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNDEyMDl8MHwxfHJhbmRvbXx8fHx8fHx8fDE2NTcwNDExNTI&ixlib=rb-1.2.1&q=80&w=400"
                return
            }
            print(decoding!.id, decoding!.urls.small)
            stringURL = decoding!.urls.small
        }.resume()
        return stringURL
    }
    
    static func getDogUrl() -> String {
        struct dogObj: Decodable {
            let fileSizeBytes: Int
            let url: String
        }
        var toReturn: String = ""
        URLSession.shared.dataTask(with: URL(string: "https://random.dog/woof.json")!) { data, response, error in
            toReturn = (try? JSONDecoder().decode(dogObj.self, from: data!))!.url
        }.resume()
        sleep(2)
        return toReturn
    }
}
