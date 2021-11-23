import 'package:flutter/material.dart';
import 'package:jua_area/core/base/model/base_model.dart';
import 'package:jua_area/ui/home/model/product_model.dart';

import 'detail_view.dart';

class Detail extends StatefulWidget {
  final BaseModel homeCardModel;

  Detail(this.homeCardModel);

  @override
  DetailView createState() => DetailView(homeCardModel as ProductModel);
}
