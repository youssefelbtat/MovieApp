//
//  ShowItemScreen.swift
//  movie from URL
//
//  Created by Mac on 08/05/2023.
//

import UIKit
import Kingfisher
class ShowItemScreen: UIViewController {

    var itemDatels : Item?
    var isFromFav : Bool = false
    let dataSourceInstance = DataSource.getInstance
    
    @IBOutlet weak var dimage: UIImageView!
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tvId: UILabel!
    @IBOutlet weak var tvRank: UILabel!
    @IBOutlet weak var tvWeeks: UILabel!
    @IBOutlet weak var tvWeekEnd: UILabel!
    @IBOutlet weak var tvGross: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvTitle.text = itemDatels?.header
        tvId.text = itemDatels?.id
        tvRank.text = itemDatels?.rank
        tvWeeks.text = itemDatels?.weeks
        tvGross.text = itemDatels?.gross
        tvWeekEnd.text = itemDatels?.weekend
        
        dimage.kf.setImage(
            with: URL(string: (itemDatels?.image)!),
            placeholder: UIImage(named: "placeholder")
        )
        
        dimage.kf.setImage(
            with: URL(string: (itemDatels?.image)!),
            placeholder: UIImage(named: "placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFromFav{
            deleteButton.isHidden = true

        }
    }
    

    @IBAction func deleteAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Movie !", message: "Are you sure you want to delete this movie ?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] UIAlertAction in
            self?.dataSourceInstance.deleteMovie(id: (self?.itemDatels?.id)!,isFromFav: false)
            
            self?.dataSourceInstance.deleteMovie(id: (self?.itemDatels?.id)!,isFromFav: true)
            
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel ,handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

        
        
    }
    

}
