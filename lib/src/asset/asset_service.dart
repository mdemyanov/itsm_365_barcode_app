import 'dart:async';
import 'dart:js';

import 'package:angular/core.dart';

import '../nsmp/nsmp_objects.dart';
import '../nsmp/nsmp_rest.dart';

@Injectable()
class AssetService {
  Future<Asset> getAsset(String uuid) async {
    Map response = await NsmpRest.get(uuid);
    return new Asset(response);
  }

  Future<Asset> getMockAsset() async {
    return new Asset({
      'inventoryNumbe': '000000096',
      'serialNumber': 'SN000000',
      'model': 'EPSON',
      'UUID': 'objectBase',
      'printConfig': {
        'width': '56',
        'height': '58',
        'unit': 'mm',
        'barcode': 'code39',
        'barcodeAttr': 'inventoryNumbe',
        'additional': 'inventoryNumbe,model,serialNumber'
      }
    });
  }

  Future<Asset> getCurrentAsset() async {
    String uuid = getSourceUUID();
    if (uuid != null) {
      Map response = await NsmpRest.get(uuid);
      return new Asset(response);
    }
    return null;
  }

  Future<PrintTemplate> getPrintTemplate(String uuid) async {
    if (uuid != null) {
      Map response = await NsmpRest.get(uuid);
      return PrintTemplate.fromMap(response);
    }
    return null;
  }

  String getSourceUUID() {
    RegExp exp = new RegExp(r"#uuid:(objectBase\$\d+)");
    Match match = exp.firstMatch(context['top']['location']['hash']);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }
}
