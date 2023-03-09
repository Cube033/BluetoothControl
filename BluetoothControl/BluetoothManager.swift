//
//  BluetoothManager.swift
//  BluetoothControl
//
//  Created by Дмитрий Федотов on 28.02.2023.
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    weak var delegate: BluetoothHandler?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("point 1")
        switch central.state {
        case .poweredOn:
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            print("Bluetooth is powered - On.")
        default:
            print("Bluetooth is not available.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print("point 2")
        guard let name = peripheral.name else {return}
        print(name)

        if peripheral.identifier == UUID(uuidString: "3813DAC4-EFC7-6711-BC6C-3C206FD11CEA") {

            print("😁 gotcha!")
            self.peripheral = peripheral
            self.peripheral?.delegate = self
            centralManager?.stopScan()
            centralManager?.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("point 3")
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("point 4")
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
            print(service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("point 5")
        for characteristic in service.characteristics! {
            print(characteristic)
            if characteristic.uuid == CBUUID(string: "FFE1") {
                self.characteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        delegate?.handleBluetoothConnection()
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //print("point 6")
        if characteristic.uuid == CBUUID(string: "FFE1") {
            let data = characteristic.value!
            //print(data)
            let message = String(data: data, encoding: .utf8)
            //print("Received message: \(message ?? "no data")")
            if let intValue = Int(message ?? "") {
                delegate?.setTextLabel(newText: "\(intValue)")
            } else {
                delegate?.printLog(newText: message ?? "no data")
            }
        }
    }

    func sendMessage(_ message: String) {
        print("point 7")
        guard let data = message.data(using: .utf8) else {
            print("🥵")
            return
        }
        guard let characteristicExist = characteristic else {
            print("no characteristic")
            return
        }
        print("Cообщение отправляется")
        if let peripheralExist = peripheral {
            peripheralExist.writeValue(data, for: characteristicExist, type: .withoutResponse)
            print("peripheral+")
        } else {
            print("peripheral Не существует")
        }
        
    }
    
    func sendCode(_ codeMessage: Int) {
        var number: Int = codeMessage
        //let data = withUnsafeBytes(of: number) { Data($0) }
        let data = Data(bytes: &number,
                        count: MemoryLayout.size(ofValue: number))
        guard let characteristicExist = characteristic else {
            print("no characteristic")
            return
        }
        if let peripheralExist = peripheral {
            peripheralExist.writeValue(data, for: characteristicExist, type: .withoutResponse)
            print("codeMessage \(codeMessage)  \(number)   \(data)")
        } else {
            print("peripheral Не существует")
        }
        
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print(characteristic ?? "no data")
    }


}
