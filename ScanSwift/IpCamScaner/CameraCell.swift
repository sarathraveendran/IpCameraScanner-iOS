
import UIKit

class CameraCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Ip: UILabel!
    @IBOutlet weak var Port: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


