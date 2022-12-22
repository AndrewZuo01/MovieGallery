//
//  DetailedView.swift
//  MovieGallery
//
//  Created by andrew on 2022/12/18.
//

import UIKit

class DetailedViewController: UIViewController{
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

    func fetchReviews(){
        
    }
    func fetchRecommands(){
        let dataRequest = "https://api.themoviedb.org/3/movie/\(movie.id)/reviews?api_key=1a0641d65157900ca431780435771d34&language=en-US&page=1"
        let url = URL(string: dataRequest)
        if(url != nil){
            let data = try! Data(contentsOf: url)
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        labelTitle.text = movie.title
        lavelVotecount.text = String(format:"%.2f",movie.vote_count)
        labelRelease.text = movie.release_date
        labelVoteAverage.text = String(format:"%.2f",movie.vote_average)
        labelPopularity.text = String(format:"%.2f",movie.popularity)
        movieImage.image = nil
        lastLabel.text = String(movie.id)
        
    }


}
