//
//  SimpleTableViewController.swift
//  RxPractice
//
//  Created by 박준우 on 2/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SimpleTableViewController: UIViewController {

    private let tableView: UITableView = UITableView()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.id)
        
        // 옵저버블 생성
        let tableViewObservable = Observable.just(
            Array(0...20).map { "\($0 * 2)" }
        )
        
        // 옵저버 구독
        // TODO: Cell 만드는 걸 bind말고 subscribe으로 구현한다면?
        tableViewObservable
            .bind(to: tableView.rx.items(cellIdentifier: SimpleTableViewCell.id, cellType: SimpleTableViewCell.self)) { (row, value, cell) in
                cell.textLabel?.text = "Row: \(row) / Value \(value)"
            }
            .disposed(by: disposeBag)
        
        // TODO: itemSelected vs modelSelected
        self.tableView.rx
            .itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.presentAlert(message: "Cell \(indexPath)")
            } onError: { owner, error in
                print("itemSelected onError", error)
            } onCompleted: { owner in
                print("itemSelected onCompleted")
            } onDisposed: { owner in
                print("itemSelected onDisposed")
            }
            .disposed(by: disposeBag)

        self.tableView.rx.itemAccessoryButtonTapped
            .subscribe(with: self) { owner, indexPath in
                owner.presentAlert(message: "Accessory \(indexPath)")
            } onError: { owner, error in
                print("itemAccessoryButtonTapped onError", error)
            } onCompleted: { owner in
                print("itemAccessoryButtonTapped onCompleted")
            } onDisposed: { owner in
                print("itemAccessoryButtonTapped onDisposed")
            }
            .disposed(by: disposeBag)
            
    }
}

extension SimpleTableViewPracticeViewController {
    func presentAlert(message: String) {
        let ac = UIAlertController(title: "Cell Selected", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)
        ac.addAction(okAction)
        self.present(ac, animated: true)
    }
}

