//
//  BindCollectionViewVC.swift
//  RxBindUI
//
//  Created by Stanly Shiyanovskiy on 07.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

//extension String: IdentifiableType {
//    public typealias Identity = String
//    public var identity: Identity { return self }
//}

struct AnimatedSectionModel {
    let title: String
    var data: [String]
}

extension AnimatedSectionModel: AnimatableSectionModelType {
    typealias Item = String
    typealias Identity = String
    var identity: Identity { return title }
    var items: [Item] { return data }
    
    init(original: AnimatedSectionModel, items: [String]) {
        self = original
        data = items
    }
}

class BindCollectionViewVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    let disposeBag = DisposeBag()
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatedSectionModel>(configureCell: { (_,_,_,_) in fatalError()}, configureSupplementaryView: { (_,_,_,_) in fatalError()})
    
    let data = Variable([
        AnimatedSectionModel(title: "Section 0", data: ["0-0"]),
        AnimatedSectionModel(title: "Section 1", data: ["0-1"])
        ])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configureCell = { _, collectionView, indexPath, title in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
            cell.titleLabel.text = title
            return cell
        }
        
        dataSource.configureSupplementaryView = { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! Header
            header.titleLabel.text = dataSource.sectionModels[indexPath.section].title
            return header
        }
        
        data.asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        addBarButtonItem.rx.tap.asDriver()
            .drive(onNext: { _ in
                let section = self.data.value.count
                let items: [String] = {
                    var items = [String]()
                    let random = Int(arc4random_uniform(6)) + 1
                    (0...random).forEach({ value in
                        items.append("\(section)-\(value)")
                    })
                    
                    return items
                }()
                
                self.data.value += [AnimatedSectionModel(title: "Section: \(section)", data: items)] 
                self.scrollToBottom()
            })
            .disposed(by: disposeBag)
        
        longPressGestureRecognizer.rx.event
            .subscribe(onNext: { value in
                switch value.state {
                case .began:
                    guard let selectedIndexPath = self.collectionView.indexPathForItem(at: value.location(in: self.collectionView)) else { break }
                    self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                case .changed:
                    self.collectionView.updateInteractiveMovementTargetPosition(value.location(in: value.view!))
                case .ended:
                    self.collectionView.endInteractiveMovement()
                default:
                    self.collectionView.cancelInteractiveMovement()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: (self.data.value.last?.items.count)!-1, section: self.data.value.count-1)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }

}
