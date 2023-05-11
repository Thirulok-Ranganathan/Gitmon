//
//  ContentView.swift
//  gitmon
//
//  Created by RITSJC-004 on 29/04/23.
//

import SwiftUI

struct ContentView: View {
    @State private var owner = ""
    @State private var repo = ""
    @State private var details: RepoDetails?
    
    var body: some View {
        VStack {
            HStack {
                Text("Owner:")
                TextField("Enter owner name", text: $owner)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("Repository:")
                TextField("Enter repo name", text: $repo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button("Get Details") {
                loadDetails()
            }
            if let details = details {
                RepoDetailsView(details: details)
            }
        }
        .padding()
    }
    
    func loadDetails() {
            guard let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)") else {
                return
            }
            var request = URLRequest(url: url)
            request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let details = try? JSONDecoder().decode(RepoDetails.self, from: data) {
                        DispatchQueue.main.async {
                            self.details = details
                        }
                    }
                }
            }.resume()
        }
    }

struct RepoDetailsView: View {
    let details: RepoDetails
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(details.name)")
            Text("Description: \(details.description ?? "")")
            Text("Commits: \(details.commits_url)")
            Text("Stars: \(details.stargazers_count)")
            Text("Forks: \(details.forks_count)")
            Text("Subscribers: \(details.subscribers_count)")
            Text("Watchers: \(details.watchers_count)")
        }
        .padding()
    }
}

struct RepoDetails: Codable {
    let name: String
    let description: String?
    let commits_url: String
    let stargazers_count: Int
    let forks_count: Int
    let subscribers_count: Int
    let watchers_count: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
