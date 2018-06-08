//
//  SecondWayBindDataVC.swift
//  RxBindUI
//
//  Created by Stanly Shiyanovskiy on 08.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SecondWayBindDataVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let model = Model()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Contributor>>(configureCell: { _, tableView, indexPath, contributor in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = contributor.image
        cell.textLabel?.text = contributor.name
        cell.detailTextLabel?.text = contributor.gitHubID
        return cell
    },
                                                                                             titleForHeaderInSection: { dataSource, sectionIndex in
                                                                                                return dataSource[sectionIndex].model
    }                                                  )
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = self.dataSource
        
        model.data
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension SecondWayBindDataVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(96) + 32)
    }
}


