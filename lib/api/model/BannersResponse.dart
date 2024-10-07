class BannersResponse {
  int? status;
  String? message;
  List<BannerData>? banner;

  BannersResponse({this.status, this.message, this.banner});

  BannersResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['banner'] != null) {
      banner = <BannerData>[];
      json['banner'].forEach((v) {
        banner!.add(new BannerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerData {
  String? bannerId;
  String? bannerTitile;
  String? bannerDesc;
  String? bannerImage;
  String? priority;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? url;
  String? offerId;

  BannerData(
      {this.bannerId,
      this.bannerTitile,
      this.bannerDesc,
      this.bannerImage,
      this.priority,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.url,
      this.offerId,
      });

  BannerData.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    bannerTitile = json['banner_titile'];
    bannerDesc = json['banner_desc'];
    bannerImage = json['banner_image'];
    priority = json['priority'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
    offerId = json['offer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_id'] = this.bannerId;
    data['banner_titile'] = this.bannerTitile;
    data['banner_desc'] = this.bannerDesc;
    data['banner_image'] = this.bannerImage;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    data['offer_id'] = this.offerId;
    return data;
  }
}
