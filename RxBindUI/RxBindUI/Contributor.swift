//
//  Contributor.swift
//  RxBindUI
//
//  Created by Stanly Shiyanovskiy on 07.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
struct Contributor {
    
    let name: String
    let gitHubID: String
    var image: UIImage?
    
    init(name: String, gitHubID: String) {
        self.name = name
        self.gitHubID = gitHubID
        image = UIImage(named: gitHubID)
    }
    
}

extension Contributor: CustomStringConvertible {
    
    var description: String {
        return "\(name): github.com/\(gitHubID)"
    }
    
}
