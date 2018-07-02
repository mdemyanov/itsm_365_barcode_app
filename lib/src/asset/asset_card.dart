import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:dart_barcode/dart_barcode.dart';

import '../nsmp/nsmp_objects.dart';

Map<String, String> barcodesInfo = {
  'CODE128': '<h3>Для CODE128 допустимы</h3><ol>'
      '<li>Символы пунктуации: !\"#\$%&\'()\*+,-./:;<=>?@[]^_</li>'
      '<li>Цифры: 0..9</li>'
      '<li>Заглавные буквы: A..Z</li>'
      '</ol>',
  'CODE128A': '<h3>Для CODE128A допустимы</h3><ol>'
      '<li>Символы пунктуации: !\"#\$%&\'()\*+,-./:;<=>?@[]^_</li>'
      '<li>Цифры: 0..9</li>'
      '<li>Заглавные буквы: A..Z</li>'
      '<li>Управляющие коды ASCII с шестнадцатиричными кодами 0H..20H</li>'
      '</ol>',
  'CODE128B': '<h3>Для CODE128B допустимы</h3><ol>'
      '<li>Символы пунктуации: !\"#\$%&\'()\*+,-./:;<=>?@[]^_</li>'
      '<li>Дополнительные символы: `{|}~</li>'
      '<li>Цифры: 0..9</li>'
      '<li>Заглавные буквы: A..Z</li>'
      '<li>Малые буквы: a..z</li>'
      '</ol>',
  'CODE128C': '<h3>Для CODE128C допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'CODE39': '<h3>Для CODE39 допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '<li>Дополнительные символы: -, ., \$, /, +, %, и пробел</li>'
      '</ol>',
  'EAN13': '<h3>Для EAN13 допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'EAN8': '<h3>Для EAN8 допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'EAN5': '<h3>Для EAN5 допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'UPC': '<h3>Для UPC допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'MSI': '<h3>Для MSI допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'MSI10': '<h3>Для MSI10 допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'MSI11': '<h3>Для MSI11 допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'MSI1010': '<h3>Для MSI1010 допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'MSI1110': '<h3>Для MSI1110 допустимы</h3><ol>'
      '<li>Цифры: 0..9</li>'
      '</ol>',
  'pharmacode': '<h3>Для pharmacode допустимы</h3><ol>'
      '<li>Цифры: от 3 до 131070</li>'
      '</ol>',

};

@Component(
    selector: 'asset-card',
    styleUrls: const ['asset_card.css'],
    templateUrl: 'asset_card.html',
    directives: const [CORE_DIRECTIVES, materialDirectives])
class AssetCard implements OnInit {
  @Input('asset')
  Asset asset;

  @Input('barcodeAttr')
  String barcodeAttr;

  @Input('barcode')
  String barcode;

  @Input('additional')
  List<String> additional;

  @override
  void ngOnInit() {
    Options options = new Options(
      format: barcode,
      displayValue: false,
      width: 1,
      height: 50,
    );
    String barcodeValue = asset.getStringProperty(barcodeAttr);
    try {
      new DartBarcode(
          "#barcode", barcodeValue, options);
    } catch (e) {
      Element error = querySelector('#error');
      DivElement barcodeInfo = new DivElement();
      HeadingElement errorTitle = new HeadingElement.h2();
      errorTitle.text = 'Ошибка подготовки штрихкода для \"$barcodeValue\"';
      String barcodeInfoText = barcodesInfo[barcode.toUpperCase()];
      if(barcodeInfoText == null) {
        barcodeInfoText = 'Выбранный  метод кодирования <b>${barcode.toUpperCase()}</b> не поддерживается';
      }
      barcodeInfo.appendHtml(barcodeInfoText);
      error.append(errorTitle);
      error.append(barcodeInfo);
      error.style.display = 'block';
      querySelector('#success').style.display = 'none';
    }
  }
}
