//
//  ContentView.swift
//  way2
//
//  Created by Vitaly Gromov on 6/26/22.
//

import SwiftUI

struct ContentView: View {
    @State var url: String = UnsplashGet.unwrapper(UnsplashGet.getRandom())
    var body: some View {
        VStack {
            Text(url)
            Button("go") {
                url = UnsplashGet.unwrapper(UnsplashGet.getRandom())
                print("this is url ---> \(url)")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            AsyncImage(url: URL(string: url)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            Spacer(minLength: 10)
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

class Logic {
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

class UnsplashGet {
    struct JSONObj: Codable {
        let description: String
        let urls: URLObj
    }
    struct URLObj: Codable {
        let small: String
    }
    static let decoder = JSONDecoder()
    static func getRandom() -> JSONObj? {
        var result: JSONObj?
           let mainURl = URL(string: "https://api.unsplash.com/photos/random/?client_id=1_RusPERzdidJ_akL0iHjgf03x1ivIjhp7algRGIPzM")
            URLSession.shared.dataTask(with: mainURl!) { data, resp, error in
               try? result = decoder.decode(JSONObj.self, from: data!)
                print(String(decoding: data!, as: UTF8.self))
            }
            .resume()
          sleep(2)
            return result
       
    }
    static func unwrapper(_ obj: JSONObj?) -> String {
        obj?.urls.small ?? "fail"
    }
}
