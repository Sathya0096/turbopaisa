class EarnGameResponses {
  List<Banners>? banners;
  List<Recentplayedgames>? recentplayedgames;
  List<Toprelatedgames>? toprelatedgames;

  EarnGameResponses(
      {this.banners, this.recentplayedgames, this.toprelatedgames});

  EarnGameResponses.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['recentplayedgames'] != null) {
      recentplayedgames = <Recentplayedgames>[];
      json['recentplayedgames'].forEach((v) {
        recentplayedgames!.add(new Recentplayedgames.fromJson(v));
      });
    }
    if (json['toprelatedgames'] != null) {
      toprelatedgames = <Toprelatedgames>[];
      json['toprelatedgames'].forEach((v) {
        toprelatedgames!.add(new Toprelatedgames.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.recentplayedgames != null) {
      data['recentplayedgames'] =
          this.recentplayedgames!.map((v) => v.toJson()).toList();
    }
    if (this.toprelatedgames != null) {
      data['toprelatedgames'] =
          this.toprelatedgames!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  String? bannerId;
  String? bannerTitile;
  String? bannerDesc;
  String? bannerImage;
  String? priority;
  String? url;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? type;

  Banners(
      {this.bannerId,
        this.bannerTitile,
        this.bannerDesc,
        this.bannerImage,
        this.priority,
        this.url,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.type});

  Banners.fromJson(Map<String, dynamic> json) {
    bannerId = json['banner_id'];
    bannerTitile = json['banner_titile'];
    bannerDesc = json['banner_desc'];
    bannerImage = json['banner_image'];
    priority = json['priority'];
    url = json['url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_id'] = this.bannerId;
    data['banner_titile'] = this.bannerTitile;
    data['banner_desc'] = this.bannerDesc;
    data['banner_image'] = this.bannerImage;
    data['priority'] = this.priority;
    data['url'] = this.url;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    return data;
  }
}

class Recentplayedgames {
  String? earnGameId;
  String? earnGameTitle;
  String? earnGameCode;
  String? earnGameDesc;
  String? earnGameAmount;
  String? earnGameButtonTitle;
  String? startDate;
  String? endDate;
  String? earnGameImage;
  String? url;
  int? earnGameStatus;

  Recentplayedgames(
      {this.earnGameId,
        this.earnGameTitle,
        this.earnGameCode,
        this.earnGameDesc,
        this.earnGameAmount,
        this.earnGameButtonTitle,
        this.startDate,
        this.endDate,
        this.earnGameImage,
        this.url,
        this.earnGameStatus});

  Recentplayedgames.fromJson(Map<String, dynamic> json) {
    earnGameId = json['earn_game_id'];
    earnGameTitle = json['earn_game_title'];
    earnGameCode = json['earn_game_code'];
    earnGameDesc = json['earn_game_desc'];
    earnGameAmount = json['earn_game_amount'];
    earnGameButtonTitle = json['earn_game_button_title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    earnGameImage = json['earn_game_image'];
    url = json['url'];
    earnGameStatus = json['earn_game_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['earn_game_id'] = this.earnGameId;
    data['earn_game_title'] = this.earnGameTitle;
    data['earn_game_code'] = this.earnGameCode;
    data['earn_game_desc'] = this.earnGameDesc;
    data['earn_game_amount'] = this.earnGameAmount;
    data['earn_game_button_title'] = this.earnGameButtonTitle;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['earn_game_image'] = this.earnGameImage;
    data['url'] = this.url;
    data['earn_game_status'] = this.earnGameStatus;
    return data;
  }
}

class Toprelatedgames {
  String? earnGameId;
  String? earnGameTitle;
  String? earnGameCode;
  String? earnGameDesc;
  String? earnGameAmount;
  String? earnGameButtonTitle;
  String? startDate;
  String? endDate;
  String? earnGameImage;
  String? url;
  int? earnGameStatus;

  Toprelatedgames(
      {this.earnGameId,
        this.earnGameTitle,
        this.earnGameCode,
        this.earnGameDesc,
        this.earnGameAmount,
        this.earnGameButtonTitle,
        this.startDate,
        this.endDate,
        this.earnGameImage,
        this.url,
        this.earnGameStatus});

  Toprelatedgames.fromJson(Map<String, dynamic> json) {
    earnGameId = json['earn_game_id'];
    earnGameTitle = json['earn_game_title'];
    earnGameCode = json['earn_game_code'];
    earnGameDesc = json['earn_game_desc'];
    earnGameAmount = json['earn_game_amount'];
    earnGameButtonTitle = json['earn_game_button_title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    earnGameImage = json['earn_game_image'];
    url = json['url'];
    earnGameStatus = json['earn_game_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['earn_game_id'] = this.earnGameId;
    data['earn_game_title'] = this.earnGameTitle;
    data['earn_game_code'] = this.earnGameCode;
    data['earn_game_desc'] = this.earnGameDesc;
    data['earn_game_amount'] = this.earnGameAmount;
    data['earn_game_button_title'] = this.earnGameButtonTitle;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['earn_game_image'] = this.earnGameImage;
    data['url'] = this.url;
    data['earn_game_status'] = this.earnGameStatus;
    return data;
  }
}