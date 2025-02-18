//
//  SimpleTableViewPracticeViewController.swift
//  RxPractice
//
//  Created by 박준우 on 2/18/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SimpleTableViewPracticeViewController: UIViewController {

    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

