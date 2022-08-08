//
//  DatePickerViewController.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation
import UIKit

class DatePickerViewController: UINavigationController {
    var selectedSeason: ((StandingsData) -> Void)?
    
    private let tableView = UITableView()
    private var seasonDataSource: SeasonsData
    
    init(dataSource: SeasonsData) {
        seasonDataSource = dataSource
        super.init(nibName: nil, bundle: nil)
        setUpTableView()
        loadTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func loadTableView() {
        navigationItem.title = "Pick Season"
        
        tableView.register(SeasonCell.self, forCellReuseIdentifier: "SeasonCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension DatePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let data = seasonDataSource.seasons[indexPath.row].
        //selectedSeason?(data)
        self.dismiss(animated: true)
    }
}

extension DatePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasonDataSource.seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonCell") as! SeasonCell
        let data = seasonDataSource.seasons[indexPath.row]
        cell.setUpWith(data: data)
        
        return cell
    }
}
