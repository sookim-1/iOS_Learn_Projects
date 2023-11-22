//
//  NewsTableViewController.swift
//  NewsAppMVVM
//
//  Created by sookim on 10/30/23.
//

import UIKit
import RxSwift

final class NewsTableViewController: UITableViewController {

    private var articleListVM: ArticleListViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "News App"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseID)
        
        populateNews()
    }
    
    private func populateNews() {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(NewsAPIKey.dummyKey)")!
        let resource = Resource<ArticlesList>(url: url)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { [weak self] result in
                guard let self
                else { return }
                
                let articles = result.articles
                self.articleListVM = ArticleListViewModel(articles)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0 : articleListVM.articlesVM.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseID, for: indexPath) as! NewsTableViewCell

        let articlesVM = self.articleListVM.articleAt(indexPath.row)
        
        articlesVM.title
            .asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articlesVM.description
            .asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
