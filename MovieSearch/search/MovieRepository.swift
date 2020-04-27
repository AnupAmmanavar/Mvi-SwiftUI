//
//  MovieRepository.swift
//  MovieSearch
//
//  Created by porter on 13/04/20.
//  Copyright © 2020 kinley. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class MovieRepository {
    
    func createRequest<T: Codable>(url: String) -> Observable<T> {
        
        let observable = Observable<T>.create { observer -> Disposable in
            
            Alamofire.request(url)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            // if no error provided by alamofire return .notFound error instead.
                            // .notFound should never happen here?
                            observer.onError(response.error ?? MyError.runtimeError("random message"))
                            return
                        }
                        do {
                            let projects = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(projects)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
        observable
            .observeOn(MainScheduler.instance)
        
        return observable
    }
    
    func searchMovies(query: String) -> Observable<MoviesResult> {
        return createRequest(url: "https://api.themoviedb.org/3/search/movie?api_key=02e40a2424558958a9d91847362b03ae&query=\(query)")
    }
}
