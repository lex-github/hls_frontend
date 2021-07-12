import 'dart:async';

import 'package:flutter/material.dart' hide Colors, Padding;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hls/components/buttons.dart';
import 'package:hls/components/generic.dart';
import 'package:hls/constants/strings.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/controllers/_controller.dart';
import 'package:hls/controllers/exercise_catalog_controller.dart';
import 'package:hls/controllers/exercise_form_controller.dart';
import 'package:hls/helpers/null_awareness.dart';
import 'package:hls/screens/video_screen.dart';
import 'package:hls/theme/styles.dart';

class CardioMonitor extends StatefulWidget {
  final List<Duration> rateChecks;
  CardioMonitor({@required this.rateChecks}) {
    //print('CardioMonitor() rateChecks: $rateChecks');
  }

  @override
  _CardioMonitorState createState() => _CardioMonitorState();
}

class _CardioMonitorState extends State<CardioMonitor> {
  List<Duration> get rateChecks => widget.rateChecks;
  CardioMonitorController get controller => Get.find<CardioMonitorController>();

  Future _handler() async {
    await controller.scan();
  }

  @override
  Widget build(_) => GetX(
      init: CardioMonitorController(rateChecks: rateChecks),
      builder: (_) =>
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (!controller.message.isNullOrEmpty) ...[
              TextError(controller.message),
              VerticalSmallSpace()
            ] else if (controller.isConnected) ...[
              TextPrimary(
                  '${controller.device.name} -> ${controller.heartRate}',
                  color: Colors.primary,
                  size: Size.fontTiny),
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

  CardioMonitorController({@required this.rateChecks})
      : guidService = Guid(heartRateService),
        guidCharacteristic = Guid('00002a37-0000-1000-8000-00805f9b34fb') {
    //print('CardioMonitorController() rateChecks: $rateChecks');
  }

  final guidService;
  final guidCharacteristic;
  final List<Duration> rateChecks;
  final List<Duration> rateChecksCopy = [];
  final Map<Duration, int> results = {};

  final _isAwaiting = false.obs;
  final _canConnect = false.obs;
  final _isConnected = false.obs;
  final _message = ''.obs;
  final _device = Rx<BluetoothDevice>(null);
  final _heartRate = 0.obs;

  FlutterBlue get blue => FlutterBlue.instance;
  bool get isReady => isInit && !_isAwaiting.value;
  bool get canConnect => isReady && _canConnect.value;
  bool get isConnected => canConnect && device != null && _isConnected.value;
  String get message => _message.value;
  BluetoothDevice get device => _device.value;
  int get heartRate => _heartRate.value;

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
      int firstByte = value[0];
      int secondByte = value[1];
      int thirdByte = value[2];

      // if first bit of first byte is not set the heart rate is in second byte
      // else heart rate is second and third bytes
      final heartRate = (firstByte & (1 << 0)) == 0
          ? secondByte
          : (secondByte << 8) + thirdByte;

      //print('CardioMonitorController.connect heart rate: $heartRate');

      _heartRate.value = heartRate;
    });

    _isConnected.value = true;
  }

  void onReset() {
    if (rateChecks.isNullOrEmpty) {
      print('CardioMonitorController.onReset rate checks null or empty!');

      return;
    }

    rateChecksCopy.clear();
    rateChecksCopy.addAll(rateChecks);
    results.clear();
  }

  void onPlay(Duration position) {
    //print('=====');
    //print('CardioMonitorController.onPlay position: $position checks: $rateChecksCopy');

    Duration checkToRemove;
    for (final check in rateChecksCopy) {
      //print('CardioMonitor.onPlay check: $check');

      if (check.compareTo(position) <= 0) {
        print('CardioMonitorController.onPlay position reached: $position');
        readResult(check);

        checkToRemove = check;

        break;
      }

      // print('CardioMonitorController.onPlay $check bigger than $position');
      // print('-----');
    }

    if (checkToRemove != null) {
      //print('CardioMonitorController.onPlay checkToRemove: $checkToRemove');

      rateChecksCopy.remove(checkToRemove);
    }
  }

  void readResult(Duration position) async {
    int rate = heartRate;
    if (rate == 0) {
      final videoController = Get.find<VideoScreenController>();
      final formController = Get.find<ExerciseFormController>();

      videoController.pause();

      rate = await formController.requestRate();

      print('CardioMonitorController.readResult rate: $rate');

      videoController.play();
    }

    results[position] = rate;
  }

  @override
  void onClose() async {
    try {
      await blue.stopScan();
      if (device != null) await device.disconnect();
    } catch (_) {}

    super.onClose();
  }
}
