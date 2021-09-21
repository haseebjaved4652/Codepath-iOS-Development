//
//  MoviesViewController.swift
//  flickster
//
//  Created by HaseebJaved on 9/13/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //variable created here are called properties
    var movies = [[String:Any]] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        print("Hello")
        // url is the important part, few of the others, we can ignore - "TIM"
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try!
                        JSONSerialization.jsonObject(with: data, options: [])
                        as! [String: Any]

                //hey movies, i want yo to look into that data dictionary and get that result
                self.movies = dataDictionary["results"] as! [[String:Any]]
                //self. is important to fix Reference to property 'movies' in closure `requires explicit use of 'self' to make capture semantics explicit
                
                // reload the data or else the 20 movies that wont show up else
                self.tableView.reloadData()
                
                print(dataDictionary)
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueReusableCell is like facebook, instagram where cell is recycled
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        // ? mark and ! points is important
        // i couldnt get the title on to each textView. I debugged my code and found "row: \(indexPath.row)" in entry for title
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        
        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        // Find the selected cell
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for:cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie

        tableView.deselectRow(at: indexPath, animated: false)
    }


}
