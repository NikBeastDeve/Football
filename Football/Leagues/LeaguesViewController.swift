//
//  LeaguesViewController.swift
//  Football
//
//  Created by Nikita Galaganov on 07/08/2022.
//

import UIKit

class LeaguesViewController: UIViewController {
    
    // MARK: - Properties
    private let overlayView = OverlayView(errorMessage: "Couldn't load the data", state: .loading)
    private let tableView = UITableView()
    private var presenter: LeaguesManager
    fileprivate var dataSource: [League] = []
    
    init(dataService: FootballDataService) {
        presenter = LeaguesPresenter(dataService: dataService)
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
            self.presenter.loadLeagues {
                self.reloadData()
            }
        }
        
        tableView.register(LeagueCell.self, forCellReuseIdentifier: "LeagueCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Leagues"
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
        presenter.loadLeagues {
            self.reloadData()
        }
    }
    
    private func reloadData() {
        switch presenter.leaguesDataState {
        case .initial, .loading:
            overlayView.setState(state: .loading)
        case .failed, .unavailable:
            overlayView.setState(state: .error)
        case .loaded(let leaguesData):
            tableView.isHidden = false
            overlayView.setState(state: .hideView)
            self.dataSource = leaguesData.data
            
            tableView.reloadData()
        }
    }
}

extension LeaguesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        let selectedId = data.id
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = SeasonViewController(dataService: FootballDataService(), id: selectedId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LeaguesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell") as! LeagueCell
        let data = dataSource[indexPath.row]
        cell.setUpWith(data: data)
        
        return cell
    }
}
