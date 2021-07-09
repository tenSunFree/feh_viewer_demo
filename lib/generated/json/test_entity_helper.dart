import 'package:feh_viewer_demo/home/model/home_entity.dart';

testEntityFromJson(HomeEntity data, Map<String, dynamic> json) {
	if (json['albumId'] != null) {
		data.albumId = json['albumId'] is String
				? int.tryParse(json['albumId'])
				: json['albumId'].toInt();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? int.tryParse(json['id'])
				: json['id'].toInt();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['url'] != null) {
		data.url = json['url'].toString();
	}
	if (json['thumbnailUrl'] != null) {
		data.thumbnailUrl = json['thumbnailUrl'].toString();
	}
	return data;
}

Map<String, dynamic> testEntityToJson(HomeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['albumId'] = entity.albumId;
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['url'] = entity.url;
	data['thumbnailUrl'] = entity.thumbnailUrl;
	return data;
}