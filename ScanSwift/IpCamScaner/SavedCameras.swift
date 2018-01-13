
import UIKit
import CoreData

class SavedCameras: UITableViewController, NSFetchedResultsControllerDelegate {


    var fetchResultsController: NSFetchedResultsController<Camera>!
    var cameras:[Camera] = []

    @IBOutlet weak var TableV: UITableView!
    var manageObjectContext: NSManagedObjectContext!
    
    var CamNameField : UITextField?
    var CamIPField : UITextField?
    var CamPortField : UITextField?
    var CamName: String = ""
    var CamIP: String = ""
    var CamPort: String = ""
    var CamPortNumber : Int = 0
    
 
    @IBAction func addCamera(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Add Camera", message: "Add new IP Camera", preferredStyle: .alert)

        ac.addTextField(configurationHandler: CamName)
        ac.addTextField(configurationHandler: CamIP)
        ac.addTextField(configurationHandler: CamPort)
         let save = UIAlertAction(title: "Save", style: .default, handler: self.saveHandler)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        ac.addAction(cancel)
        ac.addAction(save)
        
        present(ac, animated: true, completion: nil)
    }
    func CamName(textField: UITextField!) {
        CamNameField = textField
        CamNameField?.placeholder = "Camera Name"
    }
    func CamIP(textField: UITextField!) {
        CamIPField = textField
        CamIPField?.placeholder = "IP adress"
    }
    func CamPort(textField: UITextField!) {
        CamPortField = textField
        CamPortField?.placeholder = "Port"
    }
    
    func saveHandler(alert: UIAlertAction!) {

        self.saveCamera(Name: (CamNameField?.text)!, IP: (CamIPField?.text)!, Port: (CamPortField?.text)!)
        self.TableV.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Camera> = Camera.fetchRequest()
        
        do {
            cameras = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    func saveCamera(Name: String, IP: String, Port: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let camera = Camera(context: context)
        camera.name = Name
        camera.ip = IP
        camera.port = Port

        do {
            try context.save()
            cameras.append(camera)
            print("Saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var longGesture = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.TableV.reloadData()
 
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        TableV.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        TableV.endUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Camera", in: context)
            let Object = NSManagedObject(entity: entity!, insertInto: context) as! Camera
            
            context.delete(cameras[indexPath.row])
            cameras.remove(at: indexPath.row)
            context.delete(Object)
            do {
                try context.save()
                TableV.deleteRows(at: [indexPath], with: .automatic)
                
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
            
            
        }

    }

    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let ac = UIAlertController(title: "Rename Camera", message: "Rename Camera", preferredStyle: .alert)
            ac.addTextField(configurationHandler: self.CamName)
            let rename = UIAlertAction(title: "Rename", style: .default){ action in
                
 
                let masname = self.cameras[indexPath.row]
                masname.name = (self.CamNameField?.text)!
                self.TableV.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            ac.addAction(cancel)
            ac.addAction(rename)
            
            self.present(ac, animated: true, completion: nil)
            print("OK, marked as Closed")
            success(true)
        })
        editAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [editAction])
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cameras.count//mas_name.count//number
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveCell", for: indexPath) as! CameraCell
        let caminfo = cameras[indexPath.row]

        cell.Name?.text = caminfo.name
        cell.Ip?.text = caminfo.ip
        cell.Port?.text = caminfo.port

        return cell
    }
    
    var ip_adress = ""
    var port = ""
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ip_adress = cameras[indexPath.row].ip!
        port = cameras[indexPath.row].port!
        performSegue(withIdentifier: "goshowcamera" , sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! CameraViewController
        
        destVC.nametodisplay = ip_adress
        if let min = Int(port) {
            print("converting port to int done")
            destVC.minPort = min
            destVC.maxPort = min
        } else {
            print("converting port to int does not done")
            destVC.minPort = 7900
            destVC.maxPort = 8200
        }
        print(destVC.nametodisplay)
        print(destVC.minPort)
        print(destVC.maxPort)
        
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
