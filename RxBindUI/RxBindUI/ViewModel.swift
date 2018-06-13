//
//  ViewModel.swift
//  RxBindUI
//
//  Created by Stanly Shiyanovskiy on 11.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ViewModel {
    
    let searchText = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()
    
    lazy var data: Driver<[Repository]> = { 
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { 
                    API.getRepositories(gitHubID: $0)                    
        }
            .asDriver(onErrorJustReturn: [])
    }()
}

class API: NSObject {
    static func getRepositories(gitHubID: String) -> Observable<[Repository]> {
        guard !gitHubID.isEmpty, let url = URL(string: "https://api.github.com/users/\(gitHubID)/repos") else { return Observable.just([]) }
        
        return URLSession.shared
            .rx.json(url: url)
            .retry(3)
            //            .catchErrorJustReturn([])
            //        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map {
                var repositories = [Repository]()
                
                if let items = $0 as? [[String: AnyObject]] {
                    items.forEach {
                        guard let name = $0["name"] as? String, let url = $0["html_url"] as? String else { return }
                        repositories.append(Repository(name: name, url: url))
                    }
                }
                
                return repositories
        }
    }
}

