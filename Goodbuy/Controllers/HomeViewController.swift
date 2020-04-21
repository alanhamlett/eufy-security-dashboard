//
//  HotlinesViewController.swift
//  Hotline
//
//  Created by James Mudgett on 1/12/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

import UIKit
import SnapKit
import Realm
import RealmSwift

class HomeViewController: UIViewController {
    fileprivate let searchBar = SearchBarView(frame: CGRect.zero)
    fileprivate var searchBarTopConstraint: Constraint!
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    fileprivate var listingsNotificationToken: NotificationToken? = nil
    
    fileprivate var listings: Results<Listing>?
    
    deinit {
        listingsNotificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        title = ""
        view.backgroundColor = UIColor(hex: 0xF2F2F2)
        
        let window = KeyWindow
        let height = window?.safeAreaInsets.top ?? 0.0
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 50
        tableView.sectionFooterHeight = 5
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: BarHeight, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        
        view.addSubview(searchBar)
        
        searchBar.delegate = self
        searchBar.snp.makeConstraints {
            searchBarTopConstraint = $0.top.equalTo(0).constraint
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).priority(.medium)
            $0.height.equalTo(BarHeight + height)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        let realm = try? Realm()
        
        listings = realm?.objects(Listing.self)
        listingsNotificationToken = listings?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        searchBar.updateStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension HomeViewController: SearchBarViewDelegate {
    func tappedSettings() {
        
    }
    
    func search(text: String?) {
        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = Listing()
        
        let vc = ListingViewController(listing: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as UITableViewCell
        return cell
    }
}
