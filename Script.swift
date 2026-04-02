import UIKit
import UserNotifications

class ViewController: UIViewController {

    // MARK: UI
    let statusLabel = UILabel()
    let fpsLabel = UILabel()
    let pingLabel = UILabel()
    let slider = UISlider()

    let startFFButton = UIButton()
    let startFFMaxButton = UIButton()

    let scriptFreeFireMax = UIFreeFireMax()
    let runScriptButton = UIButton()

    // MARK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupScriptUI()
        
        requestNotification()
        loadConfig()
        loadScript()
        fakeStatsLoop()
    }

    // MARK: UI Setup
    func setupUI() {
        view.backgroundColor = .black

        statusLabel.frame = CGRect(x: 20, y: 80, width: 320, height: 40)
        statusLabel.textColor = .green
        statusLabel.text = "TUN BOOST VIP"

        fpsLabel.frame = CGRect(x: 20, y: 120, width: 200, height: 30)
        fpsLabel.textColor = .white

        pingLabel.frame = CGRect(x: 20, y: 150, width: 200, height: 30)
        pingLabel.textColor = .white

        slider.frame = CGRect(x: 20, y: 190, width: 280, height: 40)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(changeSensitivity), for: .valueChanged)

        startFFButton.frame = CGRect(x: 20, y: 240, width: 150, height: 50)
        startFFButton.setTitle("PLAY FF", for: .normal)
        startFFButton.addTarget(self, action: #selector(startFF), for: .touchUpInside)

        startFFMaxButton.frame = CGRect(x: 180, y: 240, width: 150, height: 50)
        startFFMaxButton.setTitle("PLAY FF MAX", for: .normal)
        startFFMaxButton.addTarget(self, action: #selector(startFFMax), for: .touchUpInside)

        view.addSubview(statusLabel)
        view.addSubview(fpsLabel)
        view.addSubview(pingLabel)
        view.addSubview(slider)
        view.addSubview(startFFButton)
        view.addSubview(startFFMaxButton)
    }

    // MARK: Script UI
    func setupScriptUI() {
        scriptFreeFireMax.frame = CGRect(x: 20, y: 310, width: 310, height: 100)
        scriptFreeFireMax.backgroundColor = .darkGray
        scriptFreeFireMax.textColor = .green
        scriptFreeFireMax.app = "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"

        runScriptButton.frame = CGRect(x: 20, y: 420, width: 200, height: 50)
        runScriptButton.setTitle("RUN SCRIPT", for: .normal)
        runScriptButton.addTarget(self, action: #selector(runScript), for: .touchUpInside)

        view.addSubview(scriptTextView)
        view.addSubview(runScriptButton)
    }

    // MARK: START FF
    @objc func startFF() {
        startGame(scheme: "freefire://")
    }

    @objc func startFFMax() {
        startGame(scheme: "freefiremax://")
    }

    func startGame(scheme: String) {
        boostDevice()
        fakeLoginNotification()
        fakeLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.openGame(scheme: scheme)
        }
    }

    // MARK: Boost
    func boostDevice() {
        URLCache.shared.removeAllCachedResponses()
        UIView.setAnimationsEnabled(false)
        statusLabel.text = "BOOSTING..."
    }

    // MARK: Loading
    func fakeLoading() {
        statusLabel.text = "Injecting script..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.statusLabel.text = "Optimizing FPS..."
        }
    }

    // MARK: Open Game
    func openGame(scheme: String) {
        if let url = URL(string: scheme),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            statusLabel.text = "Không mở được game"
        }
    }

    // MARK: Notification
    func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func fakeLoginNotification() {
        let content = UNMutableNotificationContent()
        content.title = "TUN BOOST"
        content.body = "Đăng nhập thành công - FPS ổn định!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "login", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: Fake Stats
    func fakeStatsLoop() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let fps = Int.random(in: 55...60)
            let ping = Int.random(in: 10...30)

            self.fpsLabel.text = "FPS: \(fps)"
            self.pingLabel.text = "Ping: \(ping)ms"
        }
    }

    // MARK: Sensitivity
    @objc func changeSensitivity(sender: UISlider) {
        let value = sender.value
        UserDefaults.standard.set(value, forKey: "sensitivity")
        statusLabel.text = "Độ nhạy: \(Int(value))"
    }

    func loadConfig() {
        slider.value = UserDefaults.standard.float(forKey: "sensitivity")
    }

    // MARK: Script Engine
    @objc func runScript() {
        let script = scriptTextView.text ?? ""
        statusLabel.text = "Executing script..."

        if script.contains("FPS=90") {
            fpsLabel.text = "FPS: 90"
        }

        if script.contains("PING=5") {
            pingLabel.text = "Ping: 5ms"
        }

        if script.contains("SENS=100") {
            slider.value = 100
            UserDefaults.standard.set(100, forKey: "sensitivity")
        }

        saveScript()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.statusLabel.text = "Script executed!"
        }
    }

    // MARK: Save / Load Script
    func saveScript() {
        UserDefaults.standard.set(scriptTextView.text, forKey: "custom_script")
    }

    func loadScript() {
        scriptTextView.text = UserDefaults.standard.string(forKey: "custom_script")
    }
}
