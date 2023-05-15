//
//  Connectivity.swift
//  movie from URL
//
//  Created by Mac on 10/05/2023.
//

import Foundation
import Reachability

class Connectivity {
    static let sharedInstance = Connectivity()
    
    var reachability: Reachability? {
        do {
            return try Reachability()
        } catch {
            print("Unable to create Reachability")
            return nil
        }
    }
    
    func isConnectedToInternet() -> Bool {
        return reachability?.isReachable ?? false
    }
    
    private init() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
