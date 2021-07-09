import 'package:feh_viewer_demo/generated/json/base/json_convert_content.dart';

class HomeEntity with JsonConvert<HomeEntity> {
	int? albumId;
	int? id;
	String? title;
	String? url;
	String? thumbnailUrl;
}
