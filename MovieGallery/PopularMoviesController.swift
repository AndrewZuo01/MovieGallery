//
//  PopularMovies.swift
//  MovieGallery
//
//  Created by andrew on 2022/12/18.
//

import UIKit
class populatMovieCells:UICollectionViewCell{
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
}
class myDate:Codable{
    var d:Date;
}
enum MovieType{
    case Action
    case Adventure
    case Horror
    case Sci_fi
    case Comedy
}
class PopularMoviesController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    //all different types movie, update once per day
    var fetchAPIResult:[APIResults] = []
    var AllResultMovies:[[Movie]] = []
    var lastUpdate = Date(timeIntervalSinceReferenceDate: -123456789.0)
    var resultImages:[[UIImage]] = []
    var showMovies:[Movie] = []
    var showImages:[UIImage] = []
    
    @IBOutlet weak var mySegmentedView: UISegmentedControl!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showMovies = AllResultMovies[0]
            showImages = resultImages[0]
            myCollectionView.reloadData()
        case 1:
            showMovies = AllResultMovies[1]
            showImages = resultImages[1]
            myCollectionView.reloadData()
        case 2:
            showMovies = AllResultMovies[2]
            showImages = resultImages[2]
            myCollectionView.reloadData()
        case 3:
            showMovies = AllResultMovies[3]
            showImages = resultImages[3]
            myCollectionView.reloadData()
        default:
            print("default")
            break;
        }
    }
    
    func fetchDataFromIMDb(category:String,resultIndex:Int){
        let apiKey:String = "1a0641d65157900ca431780435771d34"
        var dataQuery:String =
        "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
        switch(resultIndex){
            case 1:
                dataQuery = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
            case 2:
                dataQuery = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)"
            case 3:
                dataQuery = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)"
            case 4:
                dataQuery = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)"
            default:
                dataQuery = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)"
        }
        
        let url = URL(string: dataQuery)
        if(url != nil){
            let data = try! Data(contentsOf: url!)
            fetchAPIResult = [try! JSONDecoder().decode(APIResults.self, from: data)]
#warning("fetch data may failed becuse async")
            var currentResultMovies:[Movie] = self.fetchAPIResult[0].results
            var currentResultImages:[UIImage] = []
            let baseURL:String = "https://image.tmdb.org/t/p/w500"
            for result in currentResultMovies{
                if(result.poster_path != nil){
                    let imagePath:String = result.poster_path!
                    let imageQuery:String = baseURL + imagePath
                    let url = URL(string: imageQuery)
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    currentResultImages.append(image!)
                }else{
                    currentResultImages.append(UIImage(named: "Blank")!)
                }
            }
            self.AllResultMovies.append( currentResultMovies)
            self.resultImages.append(currentResultImages)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(AllResultMovies.count == 0 ){
            return 0
        }
        else if(showMovies.count > 0){
            return showMovies.count
        }
        return AllResultMovies[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! populatMovieCells
        if(showMovies.count == 0){
            cell.movieImage.image = nil
            cell.movieTitle.text = nil
        }else{
            cell.movieImage.image = showImages[indexPath.row]
            cell.movieTitle.text = showMovies[indexPath.row].title
            
        }
        return cell
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellSize = UIScreen.main.bounds.width / 4
        
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.itemSize = CGSize(width: cellSize, height: cellSize + cellSize / 2)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        myCollectionView.collectionViewLayout = layout
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        activityIndicator.isHidden = true
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            while(self.AllResultMovies.count < 5){
                self.fetchDataFromIMDb(category: "action",resultIndex: self.AllResultMovies.count + 1)}
            
            #warning("may deadlock")
            DispatchQueue.main.sync {
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.showMovies = self.AllResultMovies[0]
                self.showImages = self.resultImages[0]
                self.myCollectionView.reloadData()
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
}
