//
//  MovieSearchFilter.swift
//  MovieGallery
//
//  Created by andrew on 2022/12/18.
//

import UIKit
class movieTableViewCell:UITableViewCell{
    
    @IBOutlet weak var contentHolder: UIView!
    @IBOutlet weak var UpperView: UIView!
    @IBOutlet weak var stackLabels: UIStackView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelRelease: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var popularity: UILabel!
    
}

class MovieSearchController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    var resultAPI:[APIResults] = []
    var resultMovies:[Movie] = []
    var resultImages:[UIImage] = []
    var searchTask: DispatchWorkItem?
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! movieTableViewCell
        if(resultMovies.count<0){
            cell.contentHolder = nil
        }else{
            cell.textView.text = resultMovies[indexPath.row].overview
            cell.movieImage.image = resultImages[indexPath.row]
            cell.labelTitle.text = resultMovies[indexPath.row].title
            cell.labelRelease.text = resultMovies[indexPath.row].release_date
            cell.voteAverage.text = String(format: "%.2f", resultMovies[indexPath.row].vote_average)
            cell.popularity.text = String(format: "%.2f", resultMovies[indexPath.row].popularity)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
#warning("hardcode Height")
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedViewController = self.storyboard!.instantiateViewController(withIdentifier: "detail") as! DetailedViewController
        detailedViewController.movie = resultMovies[indexPath.row]
        self.navigationController!.pushViewController(detailedViewController, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()
        resultAPI = []
        resultMovies = []
        resultImages = []
        self.myTableView.reloadData()
        //dispatch work because i need search text
        if(searchText != ""){
            let task = DispatchWorkItem { [weak self] in
                self?.search(searchText: searchText)
            }
            self.searchTask = task
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
        }
    }
    @objc func search(searchText:String){
        
        let urlText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
        DispatchQueue.global().async{
            
            self.fetchDataFromIMDb(searchWord: urlText)
            DispatchQueue.main.async{
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.myTableView.reloadData()
            }
        }
    }
    func fetchDataFromIMDb(searchWord: String){
        
        let dataQuery = "https://api.themoviedb.org/3/search/movie?api_key=1a0641d65157900ca431780435771d34&language=en-US&query=\(searchWord)&page=1&include_adult=false"
        let url = URL(string: dataQuery)
        if(url != nil){
            let data = try! Data(contentsOf: url!)
            resultAPI = [try! JSONDecoder().self.decode(APIResults.self, from: data)]
            
            if(resultAPI[0].results.count > 0){
                let baseURL:String = "https://image.tmdb.org/t/p/w500"
                resultMovies = resultAPI[0].results
                for result in resultMovies{
                    if(result.poster_path != nil){
                        let imagePath:String = result.poster_path!
                        let imageQuery:String = baseURL + imagePath
                        let url = URL(string: imageQuery)
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                        resultImages.append(image!)
                    }else{
                        resultImages.append(UIImage(named: "Blank")!)
                    }
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        searchBar.delegate = self
        activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
        
    }
    
    
    
}
