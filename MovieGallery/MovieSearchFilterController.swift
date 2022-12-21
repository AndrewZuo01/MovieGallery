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
    
}

class MovieSearchController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    var resultAPI:[APIResults] = []
    var resultMovies:[Movie] = []
    var resultImages:[UIImage] = []
    
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
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        #warning("hardcode Height")
        return 200
    }
    //TODO: search
    func fetchDataFromIMDb(searchWord: String){
        
        let dataQuery = "https://api.themoviedb.org/3/search/movie?api_key=1a0641d65157900ca431780435771d34&language=en-US&query=a&page=1&include_adult=false"
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
        DispatchQueue.global().async{
            self.fetchDataFromIMDb(searchWord: "A")
            DispatchQueue.main.sync{
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.myTableView.reloadData()
            }
        }
    }
    


}
