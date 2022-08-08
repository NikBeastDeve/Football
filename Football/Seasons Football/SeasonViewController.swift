//
//  SeasonViewController.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation

import UIKit

class SeasonViewController: UIViewController {
    
    private var titleLabel = UILabel()
    
    // MARK: - Properties
    private let overlayView = OverlayView(errorMessage: "Couldn't load the data", state: .loading)
    private let tableView = UITableView()
    private var presenter: SeasonsManager
    fileprivate var dataSource: SeasonsData? = nil
    
    init(dataService: FootballDataService, id: String) {
        presenter = SeasonsPresenter(dataService: dataService, id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setUpView()
        setUpConstraints()
        load()
        
        overlayView.reload = {
            self.presenter.loadSeasons(id: self.presenter.selectedId) {
                self.reloadData()
            }
        }
        
        tableView.register(SeasonCell.self, forCellReuseIdentifier: "SeasonCell")
        tableView.delegate = self
        tableView.dataSource = self
        title = "Seasons"
//        self.navigationItem.titleView = titleLabel
//
//        titleLabel.text = "Seasons"
//        titleLabel.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(SeasonViewController.tapFunction))
//        self.navigationItem.titleView?.addGestureRecognizer(tap)
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
    }
    
    func setUpView() {
        view.addSubview(tableView)
        view.addSubview(overlayView)
    }
    
    func setUpConstraints() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func load() {
        presenter.loadSeasons(id: presenter.selectedId) {
            self.reloadData()
        }
    }
    
    private func reloadData() {
        switch presenter.leaguesDataState {
        case .initial, .loading:
            overlayView.setState(state: .loading)
        case .failed, .unavailable:
            overlayView.setState(state: .error)
        case .loaded(let seasonsData):
            tableView.isHidden = false
            overlayView.setState(state: .hideView)
            self.dataSource = seasonsData
            
            tableView.reloadData()
        }
    }
}

extension SeasonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataS = dataSource else { return }
        let data = dataS.seasons[indexPath.row]
        let title = data.displayName
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = StandingsViewController(dataService: FootballDataService(), id: presenter.selectedId, title: title, seasonDataSource: dataS)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SeasonViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataS = dataSource else { return 0 }
        return dataS.seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataS = dataSource else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonCell") as! SeasonCell
        let data = dataS.seasons[indexPath.row]
        cell.setUpWith(data: data)
        
        return cell
    }
}
