import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../nsmp/nsmp_objects.dart';
import '../asset/asset_service.dart';
import '../asset/asset_card.dart';

@Component(
  selector: 'printed-card',
  styleUrls: const ['printed_card.css'],
  templateUrl: 'printed_card.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
    AssetCard
  ],
  providers: const [AssetService],
)
class PrintedCard implements OnInit {
  final AssetService assetService;
  PrintedCard(this.assetService);
  Asset asset;
  PrintTemplate printTemplate;
//  AssetCard assetCard;

  @override
  Future<Null> ngOnInit() async {
    asset = await assetService.getCurrentAsset();
    printTemplate = await assetService.getPrintTemplate(asset.getPrintTemplateId());
  }

  void printJs() {
    Element action = querySelector('#printed-action');
    action.style.display = 'none';
    String bodyPadding = document.body.style.padding;
    document.body.style.padding = '0';
    document.body.style.width = printTemplate.width;
    window.print();
    action.style.display = 'block';
    document.body.style.padding = bodyPadding;
  }
}
