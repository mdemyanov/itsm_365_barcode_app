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
      'min-height':'$height$unit',
    };
  }
  List<String> getAdditional(){
    if(additional != null){
      return additional.split(new RegExp(r",\s?"));
    }
    return [];
  }

  PrintTemplate.fromMap(Map<String, Object> data) {
    this.height = data['height'];
    this.width = data['width'];
    this.unit = data['unit'];
    this.barcode = data['barcode'];
    this.barcodeAttr = data['barcodeAttr'];
    this.additional = data['additional'];
  }
}
