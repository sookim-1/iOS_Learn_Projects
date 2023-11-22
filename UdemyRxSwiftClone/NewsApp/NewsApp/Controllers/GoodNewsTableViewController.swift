//
//  GoodNewsTableViewController.swift
//  NewsApp
//
//  Created by sookim on 10/24/23.
//

import UIKit
import RxSwift
import RxCocoa

final class GoodNewsTableViewController: UITableViewController {

    private let disposeBag = DisposeBag()
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Good News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.register(GoodNewsTableViewCell.self, forCellReuseIdentifier: GoodNewsTableViewCell.reuseID)
        self.refactorPopulateNews()
    }
    
    private func populateNews() {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(NewsAPIKey.dummyNewsAPIKey)")!
        
        Observable.just(url)
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                
                return URLSession.shared.rx.data(request: request)
            }
            .map { data -> [Article]? in
                return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
            }
            .subscribe(onNext: { [weak self] articles in
                guard let self
                else { return }
                
                if let articles {
                    self.articles = articles
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    // URLRequest+Extension 활용
    private func refactorPopulateNews() {
        URLRequest.load(resource: ArticlesList.all)
            .subscribe(onNext: { [weak self] result in
                guard let self
                else { return }
                
                if let result {
                    self.articles = result.articles
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoodNewsTableViewCell.reuseID, for: indexPath) as! GoodNewsTableViewCell
        
        let item = articles[indexPath.row]
        cell.configureUI(article: item)

        return cell
    }

}
