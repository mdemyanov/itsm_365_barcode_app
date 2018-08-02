import 'dart:html';

import 'package:naumen_smp_jsapi/naumen_smp_jsapi.dart';
import 'package:dart_barcode/dart_barcode.dart';

import 'package:nsmp_barcode_app/src/nsmp/nsmp_objects.dart';

String noAssetError =
    'Не удалось получить карточку актива. Обратитесь к администратору сервера.';
String noPrintTemplateError =
    'Не удалось получить настройки печати. Обратитесь к администратору сервера.';

Map<String, String> barcodesInfo = {
  'CODE128': '<h4>Для CODE128 допустимы</h4><p>'
      'Символы пунктуации: !\"#\$%&\'()\*+,-./:;<=>?@[]^_<br/>'
      'Цифры: 0..9<br/>'
      'Заглавные буквы: A..Z</p>',
  'CODE128A': '<h4>Для CODE128A допустимы</h4><p>'
      'Символы пунктуации: !\"#\$%&\'()\*+,-./:;<=>?@[]^_<br/>'
      'Цифры: 0..9<br/>'
      'Заглавные буквы: A..Z<br/>'
      'Управляющие коды ASCII с шестнадцатиричными кодами 0H..20H</p>',
  'CODE128B': '<h4>Для CODE128B допустимы</h4><p>'
      'Символы пунктуации: !\"#\$%&\'()\*+,-./:;<=>?@[]^_<br/>'
      'Дополнительные символы: `{|}~<br/>'
      'Цифры: 0..9<br/>'
      'Заглавные буквы: A..Z<br/>'
      'Малые буквы: a..z</p>',
  'CODE128C': '<h4>Для CODE128C допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'CODE39': '<h4>Для CODE39 допустимы</h4><p>'
      'Цифры: 0..9<br/>'
      'Дополнительные символы: -, ., \$, /, +, %, и пробел</p>',
  'EAN13': '<h4>Для EAN13 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'EAN8': '<h4>Для EAN8 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'EAN5': '<h4>Для EAN5 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'EAN2': '<h4>Для EAN2 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'UPC': '<h4>Для UPC допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'ITF14': '<h4>Для ITF14 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'MSI': '<h4>Для MSI допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'MSI10': '<h4>Для MSI10 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'MSI11': '<h4>Для MSI11 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'MSI1010': '<h4>Для MSI1010 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'MSI1110': '<h4>Для MSI1110 допустимы</h4><p>'
      'Цифры: 0..9</p>',
  'CODABAR': '<h4>Для CODABAR допустимы</h4><p>'
      'Цифры: 0..9</p>'
      'Специальные символы: –, \$, :, /, +, .</p>',
  'PHARMACODE': '<h4>Для pharmacode допустимы</h4><p>'
      'Цифры: от 3 до 131070</p>',
};

void main() async {
  Asset asset;
  PrintTemplate printTemplate;
  String currentUid = SmpAPI.currentUUID;
  DivElement container = querySelector('#barcodeContainer');
  ImageElement imageElement = querySelector('#loading');
  try {
    asset = Asset(await SmpAPI.get(currentUid));
  } catch (e) {
    imageElement.style.display = 'none';
    container.appendText(noAssetError);
    return;
  }
  try {
    printTemplate =
        PrintTemplate.fromMap(await SmpAPI.get(asset.getPrintTemplateId()));
  } catch (e) {
    imageElement.style.display = 'none';
    container.appendText(noPrintTemplateError);
    return;
  }
  container.style.width = printTemplate.getWidth();
  container.style.height = printTemplate.getHeight();
  Element svg = querySelector('#barcode');
  Options options = new Options(
    format: printTemplate.barcode,
    displayValue: false,
    width: 1,
    height: 50,
  );
  String barcodeValue = asset.getStringProperty(printTemplate.barcodeAttr);
  imageElement.style.display = 'none';
  try {
    new DartBarcode("#barcode", barcodeValue, options);
    svg.style.removeProperty('display');
    for (String item in asset.getProperties(printTemplate.getAdditional())) {
      container.appendHtml('<div>$item</div>');
    }
    Element printAction = querySelector('#print');
    printAction.style.removeProperty('display');
    printAction.onClick.listen((_) => printJs(printTemplate, printAction));
  } catch (e) {
    DivElement barcodeInfo = new DivElement();
    HeadingElement errorTitle = new HeadingElement.h4();
    errorTitle.text = 'Ошибка подготовки штрихкода для \"$barcodeValue\"';
    String barcodeInfoText = barcodesInfo[printTemplate.barcode.toUpperCase()];
    if (barcodeInfoText == null) {
      barcodeInfoText =
          'Выбранный  метод кодирования <b>${printTemplate.barcode.toUpperCase()}</b> не поддерживается';
    }
    barcodeInfo.appendHtml(barcodeInfoText);
    container.append(errorTitle);
    container.append(barcodeInfo);
  }
}

void printJs(PrintTemplate printTemplate, Element action) {
  action.style.display = 'none';
  String bodyPadding = document.body.style.padding;
  document.body.style.padding = '0';
  document.body.style.width = printTemplate.width;
  window.print();
  action.style.removeProperty('display');
  document.body.style.padding = bodyPadding;
}
