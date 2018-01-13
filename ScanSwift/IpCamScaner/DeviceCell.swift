
import UIKit

class DeviceCell: UITableViewCell {

    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var macAddressLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var hostnameLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
