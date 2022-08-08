//
//  StandingsViewController.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation
import UIKit

class StandingsViewController: UIViewController {
    
    // MARK: - Properties
    private let titleView = UILabel()
    private let overlayView = OverlayView(errorMessage: "Couldn't load the data", state: .loading)
    private let tableView = UITableView()
    private var presenter: StandingsManager
    fileprivate var dataSource: StandingsData? = nil
    fileprivate var seasonDataSource: SeasonsData
    
    init(dataService: FootballDataService, id: String, title: String, seasonDataSource: SeasonsData) {
        presenter = StandingsPresenter(dataService: dataService, id: id)
        self.seasonDataSource = seasonDataSource
        self.titleView.text = title
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
            self.presenter.loadStandings(id: self.presenter.selectedId) {
                self.reloadData()
            }
        }
        
        tableView.register(StandingsCell.self, forCellReuseIdentifier: "StandingsCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Calendar",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(titleWasTapped))
    }
    
    @objc
    private func titleWasTapped() {
        let vc = DatePickerViewController(dataSource: seasonDataSource)
        vc.selectedSeason = { season in
            self.load()
        }
        vc.view.backgroundColor = .white
        navigationController?.present(vc, animated: true)
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
        dataSource = nil
        tableView.reloadData()
        presenter.loadStandings(id: presenter.selectedId) {
            self.reloadData()
        }
    }
    
    private func reloadData() {
        switch presenter.leaguesDataState {
        case .initial, .loading:
            overlayView.setState(state: .loading)
        case .failed, .unavailable:
            overlayView.setState(state: .error)
        case .loaded(let standingsData):
            tableView.isHidden = false
            overlayView.setState(state: .hideView)
            self.dataSource = standingsData
            
            tableView.reloadData()
        }
    }
}

extension StandingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StandingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataS = dataSource else { return 0 }
        return dataS.standings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataS = dataSource else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsCell") as! StandingsCell
        let data = dataS.standings[indexPath.row]
        cell.setUpWith(data: data)
        
        return cell
    }
}
