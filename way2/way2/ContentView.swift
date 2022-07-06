//
//  ContentView.swift
//  way2
//
//  Created by Vitaly Gromov on 6/26/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var controller = SearchObject.shared
    var body: some View {
        VStack {
            Text(controller.getDesc())
            Button("go") {
                controller.search()
            }
            .buttonStyle(.borderedProminent)
            AsyncImage(url: URL(string: controller.getLink()), scale: 2)
            Spacer()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class SearchObject: ObservableObject {
    static let shared = SearchObject()
    private init(){}

    struct Results: Codable {
        var total: Int
        var results: [Result]
    }
    struct Result: Codable {
        var id: String
        var description: String?
        var urls: URLs
    }
    struct URLs: Codable {
        var small: String
    }


    @Published var results = [Result]()
    let token = "1_RusPERzdidJ_akL0iHjgf03x1ivIjhp7algRGIPzM"
    @Published var query = "cats"

                
                func search() {
                    let url = URL(string: "https://api.unsplash.com/search/photos?page=1&query=\(query)")
                    var request = URLRequest(url: url!)
                    request.httpMethod = "GET"
                    request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
                    let task = URLSession.shared.dataTask(with: request) { data, res, error in
                        guard let data = data else {
                            return
                        }
                        do {
                            let res = try JSONDecoder().decode(Results.self, from: data)
                            self.results.append(contentsOf: res.results)
                        } catch {
                            print(error)
                        }
                    }
                    task.resume()
                }
    func getLink() -> String {
        var result: String = "empty"
        for i in self.results {
            result = i.urls.small
        }
        return result
                }
    func getDesc() -> String {
        var result: String = "empty"
        for i in self.results {
            result = i.description ?? "no description"
        }
        return result
    }
            }
