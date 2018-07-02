//import 'package:dartson/dartson.dart';
import 'package:dartson/type_transformer.dart';
import 'package:intl/intl.dart';

class Asset {
  Map<String, Object> _properties;

  String getProperty(String code) => _properties[code];

  String getStringProperty(String code) => _properties[code].toString();

  List<String> getProperties(List<String> codes) =>
      codes.map(getProperty).toList();

  List<String> getStringProperties(List<String> codes) =>
      codes.map(getStringProperty).toList();

  String getPrintTemplateId({String printTemplate = 'printConfig'}) {
    Map templateParams = _properties[printTemplate];
    if(templateParams != null) {
      return templateParams['UUID'];
    }
    return null;
  }

  Asset(this._properties);

}

class PrintTemplate {
  String height;
  String width;
  String unit;
  String barcode;
  String barcodeAttr;
  String additional;
  Map<String,String> styles;

  String getHeight() => '$height$unit';
  String getWidth() => '$width$unit';
  Map<String,String> getStyles() {
    return <String,String>{
      'max-width':'$width$unit',
      'width':'$width$unit',
      'max-height':'$height$unit',
      'height':'$height$unit',
      'min-height':'$height$unit',
    };
  }
  List<String> getAdditional(){
    if(additional != null){
      return additional.split(new RegExp(r",\s?"));
    }
    return [];
  }

//  static PrintTemplate fromMap(Map data) {
//    print(data);
//    Dartson dartson = new Dartson.JSON();
//    dartson.addTransformer(new DateTimeParser(), DateTime);
//    return dartson.map(data, new PrintTemplate());
//  }
  PrintTemplate.fromMap(Map<String, Object> data) {
    this.height = data['height'];
    this.width = data['width'];
    this.unit = data['unit'];
    this.barcode = data['barcode'];
    this.barcodeAttr = data['barcodeAttr'];
    this.additional = data['additional'];
  }
}

//class DateTimeParser extends TypeTransformer<DateTime> {
//  final DateFormat formatter = new DateFormat('yyyy.MM.dd HH:mm:ss');
//  DateTime decode(dynamic value) => formatter.parse(value);
//  dynamic encode(DateTime value) => value.toUtc().toIso8601String();
//}