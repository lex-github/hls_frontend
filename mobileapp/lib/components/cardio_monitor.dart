import 'package:flutter/material.dart' hide Colors, Padding;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/theme/styles.dart';

class CardioMonitor extends GetView<CardioMonitorController> {
  Future _handler() async {
    await controller.scan();
  }

  @override
  Widget build(_) => GetX(
      init: CardioMonitorController(),
      builder: (_) =>
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (!controller.message.isNullOrEmpty) ...[
              TextError(controller.message),
              VerticalSmallSpace()
            ] else if (controller.isConnected) ...[
              TextPrimary(controller.device.name,
                  color: Colors.primary, size: Size.fontTiny),
              VerticalSmallSpace()
            ],
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  height: Size.iconHuge,
                  width: Size.iconHuge,
                  child: Button(
                    padding: Padding.tiny,
                    isLoading: !controller.isReady,
                    //isDisabled: !controller.canConnect,
                    background: controller.isConnected
                        ? Colors.primary
                        : Colors.disabled,
                    color: Colors.white,
                    icon: FontAwesomeIcons.bluetoothB,
                    onPressed: _handler,
                  ))
            ])
          ]));
}

class CardioMonitorController extends Controller {
  static const heartRateService = '0000180d-0000-1000-8000-00805f9b34fb';
  static const heartRateCharacteristic = '00002a37-0000-1000-8000-00805f9b34fb';
  static const locationCharacteristic = '00002a38-0000-1000-8000-00805f9b34fb';

  CardioMonitorController()
      : guidService = Guid(heartRateService),
        guidCharacteristic = Guid('00002a37-0000-1000-8000-00805f9b34fb');

  final guidService;
  final guidCharacteristic;

  final _isAwaiting = false.obs;
  final _canConnect = false.obs;
  final _isConnected = false.obs;
  final _message = ''.obs;
  final _device = Rx<BluetoothDevice>(null);

  FlutterBlue get blue => FlutterBlue.instance;
  bool get isReady => isInit && !_isAwaiting.value;
  bool get canConnect => isReady && _canConnect.value;
  bool get isConnected => canConnect && device != null && _isConnected.value;
  String get message => _message.value;
  BluetoothDevice get device => _device.value;

  @override
  void onInit() {
    scan();

    super.onInit();
  }

  Future scan() async {
    _message.value = null;
    _isConnected.value = false;
    _isAwaiting.value = true;

    // check if available
    if (!await blue.isAvailable) {
      //print('CardioMonitorController.scan NOT AVAILABLE');
      _isAwaiting.value = false;
      _canConnect.value = false;
      _message.value = 'Bluetooth is not available';
      return;
    }

    // check if on
    if (!await blue.isOn) {
      //print('CardioMonitorController.scan NOT ON');
      _isAwaiting.value = false;
      _canConnect.value = false;
      _message.value = 'Bluetooth is not on';
      return;
    }

    _canConnect.value = true;

    // listen to scan results
    blue.scanResults.listen(
        (results) async {
          // print('CardioMonitorController.scan '
          //   '\n\tresult: $results');

          if (results.length > 0) {
            final result = results[0];
            print('CardioMonitorController.scan '
                '\n\tresult: $result');

            if (device != null)
              try {
                await device.disconnect();
              } catch (_) {}

            _device.value = result.device;

            blue.stopScan();
          }

          // for (ScanResult r in results) {
          //   print('CardioMonitorController.scan '
          //     '\n\tresult: $r'
          //     //'\n\tdevice: ${r.device}'
          //     //'\n\tFOUND - name: ${r.device.name}, rssi: ${r.rssi}'
          //   );
          // }
        },
        onError: (e) => print('CardioMonitorController.scan ERROR: $e'),
        onDone: () {
          print('CardioMonitorController.scan DONE');
          _isAwaiting.value = false;
        });

    // start scanning
    await blue.startScan(timeout: timeoutDuration, withServices: [guidService]);

    if (device == null)
      _message.value = 'Device not found';
    else
      await connect();

    _isAwaiting.value = false;
  }

  Future connect() async {
    if (device == null) return _message.value = 'Device not found';

    try {
      await device.connect();
    } catch (_) {}

    print('CardioMonitorController.connect DEVICE: $device');

    final services = await device.discoverServices();
    if (services.isNullOrEmpty) return _message.value = errorGenericText;

    final service = services.firstWhere(
        (service) => service.uuid == guidService,
        orElse: () => null);
    if (service == null) return _message.value = errorGenericText;

    print('CardioMonitorController.connect SERVICE: $service');

    final characteristic = service.characteristics.firstWhere(
        (characteristic) => characteristic.uuid == guidCharacteristic,
        orElse: () => null);
    if (characteristic == null) return _message.value = errorGenericText;

    print('CardioMonitorController.connect CHARACTERISTIC: $characteristic');

    await characteristic.setNotifyValue(true);
    characteristic.value.listen((value) {
      print('CardioMonitorController.connect value: $value');
    });

    _isConnected.value = true;
  }

  @override
  void onClose() async {
    try {
      if (device != null) await device.disconnect();
    } catch (_) {}

    super.onClose();
  }
}
