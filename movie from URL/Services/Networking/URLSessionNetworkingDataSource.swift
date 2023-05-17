//
//  NetworkingDataSource.swift
//  movie from URL
//
//  Created by Mac on 17/05/2023.
//

import Foundation

protocol NetworkingDataSource {
    
    func loadDataFromAPI<T : Decodable>(compilitionHandler: @escaping (T?) -> Void)
}


class URLSessionNetworkingDataSource : NetworkingDataSource{
    
    private var url : URL!
    
    init (url : String){
        self.url = URL(string: url)
    }

    func loadDataFromAPI<T : Decodable>(compilitionHandler: @escaping (T?) -> Void){
        guard let urlFinal = url else {
            return
        }
        let request = URLRequest(url: urlFinal)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                return
            }
            do{
           
                let result = try JSONDecoder().decode(T.self, from: data)
               
                compilitionHandler(result)
                
            }catch let error{
                print(error.localizedDescription)
                compilitionHandler(nil)
            }
        }
    
        task.resume()
        
    }
}
