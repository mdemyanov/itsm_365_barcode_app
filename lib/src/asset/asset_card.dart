import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:dart_barcode/dart_barcode.dart';



import '../nsmp/nsmp_objects.dart';

@Component(
  selector: 'asset-card',
  styleUrls: const ['asset_card.css'],
  templateUrl: 'asset_card.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives
  ]
)
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
      displayValue:false,
      width: 1,
      height: 50,
    );
    print('barcode: $barcode, barcodeAttr: ${asset.getStringProperty(barcodeAttr)}');
    new DartBarcode("#barcode", asset.getStringProperty(barcodeAttr), options);
  }
}