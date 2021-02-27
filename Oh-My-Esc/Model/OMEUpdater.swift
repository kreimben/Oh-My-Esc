//
//  OMEUpdater.swift
//  Oh-My-Esc
//
//  Created by Aksidion Kreimben on 2/27/21.
//

import Cocoa
import Combine

class OMEUpdater: NSObject {
    
    let currentVersion: String
    let referURL: URL
    
    private
    var cancellable: Set<AnyCancellable>
    
    private
    var githubTag: OMETag?
    
    static let shared = OMEUpdater()
    
    private override
    init() {
        cancellable    = Set<AnyCancellable>()
        
        currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        referURL       = URL(string: "https://api.github.com/repos/kreimben/oh-my-esc/tags")!
    }
    
    private
    func fetchTags(completion: @escaping ([OMETag]) -> Void) {
        
        var tags = [OMETag]()
        
        URLSession(configuration: .default)
            .dataTaskPublisher(for: referURL)
            .tryMap() {
                guard $0.data.count > 0 else { throw URLError(.zeroByteResource) }
                return $0.data
            }
            .decode(type: [OMETag].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { (complete) in
                completion(tags)
                NSLog("Fetching JSON complete: \(complete)")
            } receiveValue: { (value) in
                NSLog("Fetching JSON value: \(value)")
                tags = value
            }
            .store(in: &cancellable)
    }
    
    public
    func getCurrentAppVersion() -> String { return self.currentVersion }
    
    public
    func isAvailableToUpdate(completion: @escaping (OMETag) -> Void) {
        
        var resultTag: OMETag?
        
        fetchTags {
            
            var biggest = [String.SubSequence]()
            
            for tag in $0 { // Select biggest version.
                
                let n = tag.name
                
                if !n.hasPrefix("v") { break }
                
                let version = n.split(separator: "v")[0].split(separator: ".")
                
                if biggest.isEmpty { biggest = version; resultTag = tag; continue }
                for index in 0 ..< 3 {
                    if version[index] > biggest[index] {
                        biggest = version
                        resultTag = tag
                        break
                    } else { break }
                }
            }
            
            let splittedNewVersion     = biggest
            let splittedCurrentVersion = self.currentVersion.split(separator: ".")
            
            for index in 0 ..< 3 where Int(splittedNewVersion[index])! > Int(splittedCurrentVersion[index])! {
                print("You have to upgrade!")
                completion(resultTag!)
            }
        }
    }
}
