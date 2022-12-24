//
//  DetailedView.swift
//  MovieGallery
//
//  Created by andrew on 2022/12/18.
//

import UIKit
class recommandCollectionCell:UICollectionViewCell{
    @IBOutlet weak var recommandImage: UIImageView!
    @IBOutlet weak var recommandTitle: UILabel!
    
}
class recommandTableCell:UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{
    
    var insideCollectionMovie:[Movie] = []
    var insideCollectionImage:[UIImage] = []
    
    
    
    @IBOutlet weak var insideCollectionView: UICollectionView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        insideCollectionView.delegate = self
        insideCollectionView.dataSource = self
        
        let cellSize = UIScreen.main.bounds.width / 6
        
        let layout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.itemSize = CGSize(width: cellSize, height: cellSize + cellSize / 2)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        insideCollectionView.collectionViewLayout = layout
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        insideCollectionView.reloadData()
        return insideCollectionMovie.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = insideCollectionView.dequeueReusableCell(withReuseIdentifier: "insideCollectionCell", for: indexPath) as! recommandCollectionCell
        cell.recommandImage.image = insideCollectionImage[indexPath.row]
        cell.recommandTitle.text = insideCollectionMovie[indexPath.row].title
        return cell
    }
    
}
class reviewTableCell:UITableViewCell{
    @IBOutlet weak var review: UITextView!
    
}

class DetailedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === middleTableview {
            return resultReviews.count
        } else if tableView === bottomTableView {
            return 1
        } else {
            fatalError("Invalid table")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === middleTableview {
            let cell = middleTableview.dequeueReusableCell(withIdentifier: "middleTableCell", for: indexPath) as! reviewTableCell
            cell.review.text = resultReviews[indexPath.row].content
            return cell
        } else if tableView === bottomTableView {
            let cell = bottomTableView.dequeueReusableCell(withIdentifier: "bottomTableCell", for: indexPath) as! recommandTableCell
            cell.insideCollectionImage = resultImages
            cell.insideCollectionMovie = resultMovies
            return cell
        } else {
            fatalError("Invalid table")
        }
       
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
#warning("hardcode Height")
        if tableView === middleTableview {
            return 200
        } else if tableView === bottomTableView {
            return 110
        } else {
            fatalError("Invalid table")
        }
       
    }
    //varibales from last controller
    var movie:Movie!
    
    //top
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var lavelVotecount: UILabel!
    @IBOutlet weak var labelRelease: UILabel!
    @IBOutlet weak var labelVoteAverage: UILabel!
    @IBOutlet weak var labelPopularity: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    
    @IBOutlet weak var textSummary: UITextView!
    //middle

    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var middleTableview: UITableView!
    
    //bottom
    
    @IBOutlet weak var recommend: UILabel!
    @IBOutlet weak var bottomTableView: UITableView!


    
    var resultMovies:[Movie] = []
    var resultImages:[UIImage] = []
    var resultReviews:[Review] = []
    
    func fetchReviews(){
        let dataRequest = "https://api.themoviedb.org/3/movie/\(movie.id!)/reviews?api_key=1a0641d65157900ca431780435771d34&language=en-US&page=1"
        let url = URL(string: dataRequest)
        if(url != nil){
            let data = try! Data(contentsOf: url!)
            let resultAPI = [try! JSONDecoder().self.decode(ReviewAPIResults.self, from: data)]
            if(resultAPI[0].results.count > 0){
                resultReviews = resultAPI[0].results
            }
        }
    }
    func fetchRecommands(){
        let dataRequest = "https://api.themoviedb.org/3/movie/\(movie.id!)/recommendations?api_key=1a0641d65157900ca431780435771d34&language=en-US&page=1"
        let url = URL(string: dataRequest)
        if(url != nil){
            let data = try! Data(contentsOf: url!)
            let resultAPI = [try! JSONDecoder().self.decode(APIResults.self, from: data)]
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
        // Do any additional setup after loading the view.
        middleTableview.delegate = self
        middleTableview.dataSource = self
        bottomTableView.delegate = self
        bottomTableView.dataSource = self
        
        labelTitle.text = movie.title
        lavelVotecount.text = String(format:"%.2f",movie.vote_count)
        labelRelease.text = movie.release_date
        labelVoteAverage.text = String(format:"%.2f",movie.vote_average)
        labelPopularity.text = String(format:"%.2f",movie.popularity)
        movieImage.image = nil
        lastLabel.text = String(movie.id)
        fetchReviews()
        fetchRecommands()
        middleTableview.reloadData()
        bottomTableView.reloadData()
        
    }


}
