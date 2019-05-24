import 'package:json_annotation/json_annotation.dart';

part 'banner_data.g.dart';


@JsonSerializable()
class BannerData extends Object {

  @JsonKey(name: 'data')
  List<BannerItem> data;

  @JsonKey(name: 'errorCode')
  int errorCode;

  @JsonKey(name: 'errorMsg')
  String errorMsg;

  BannerData(this.data,this.errorCode,this.errorMsg,);

  factory BannerData.fromJson(Map<String, dynamic> srcJson) => _$BannerDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BannerDataToJson(this);

}


@JsonSerializable()
class BannerItem extends Object {

  @JsonKey(name: 'desc')
  String desc;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'imagePath')
  String imagePath;

  @JsonKey(name: 'isVisible')
  int isVisible;

  @JsonKey(name: 'order')
  int order;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'url')
  String url;

  BannerItem(this.desc,this.id,this.imagePath,this.isVisible,this.order,this.title,this.type,this.url,);

  factory BannerItem.fromJson(Map<String, dynamic> srcJson) => _$BannerItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BannerItemToJson(this);

}


