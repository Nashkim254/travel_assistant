import 'package:jua_area/ui/detail/model/detail_model.dart';

abstract class IDetailService {
  Future<List<DetailModel>> getImgList();
}
