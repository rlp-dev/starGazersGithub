//
//  repoUserTableViewCell.swift
//  starGazersGithub
//
//  Created by riccardo palumbo on 10/06/22.
//

import UIKit
import SDWebImage

class repoUserTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfilo       : UIImageView!
    @IBOutlet weak var lblName          : UILabel!
    @IBOutlet weak var lblUnderName     : UILabel!
    
    static let identifier = "repoUserCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.imgProfilo.clipsToBounds = true
        self.imgProfilo.layer.borderWidth = 0.5
        self.imgProfilo.layer.borderColor = UIColor.darkGray.cgColor
        self.imgProfilo.layer.cornerRadius = 40
        
    }
    
    func bindData(item: repoUser) {
        if let imageUrl = URL(string: item.avatar_url) {
            let roundTrasformer = SDImageRoundCornerTransformer(radius: 30, corners: .allCorners, borderWidth: 0, borderColor: nil)
            imgProfilo.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "defaultUser"), options: [.progressiveLoad], context: [.imageTransformer:roundTrasformer])
        }
        lblName.text = item.login
        lblUnderName.text = String(item.html_url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


