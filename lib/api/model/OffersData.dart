// class OffersData {
//   String? offerId;
//   String? offerTitle;
//   String? offerTagline;
//   String? offerCode;
//   String? offerDesc;
//   String? offerAmount;
//   String? startDate;
//   String? endDate;
//   String? url;
//   bool? isBanner;
//   List<Tasks>? tasks;
//   List<Images>? images;
//
//   OffersData(
//       {this.offerId,
//       this.offerTitle,
//       this.offerCode,
//       this.offerDesc,
//       this.offerAmount,
//       this.startDate,
//       this.endDate,
//       this.url,
//       this.images,
//       this.offerTagline,
//       this.isBanner = false});
//
//   OffersData.fromJson(Map<String, dynamic> json) {
//     offerId = json['offer_id'];
//     offerTitle = json['offer_title'];
//     offerTagline = json['offer_tagline'];
//     offerCode = json['offer_code'];
//     offerDesc = json['offer_desc'];
//     offerAmount = json['offer_amount'];
//     startDate = json['start_date'];
//     endDate = json['end_date'];
//     url = json['url'];
//     if (json['tasks'] != null) {
//       tasks = <Tasks>[];
//       json['tasks'].forEach((v) {
//         tasks!.add(new Tasks.fromJson(v));
//       });
//     }
//     if (json['images'] != null) {
//       images = <Images>[];
//       json['images'].forEach((v) {
//         images!.add(new Images.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['offer_id'] = this.offerId;
//     data['offer_title'] = this.offerTitle;
//     data['offer_tagline'] = this.offerTagline;
//     data['offer_code'] = this.offerCode;
//     data['offer_desc'] = this.offerDesc;
//     data['offer_amount'] = this.offerAmount;
//     data['start_date'] = this.startDate;
//     data['end_date'] = this.endDate;
//     data['url'] = this.url;
//     if (this.tasks != null) {
//       data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
//     }
//     if (this.images != null) {
//       data['images'] = this.images!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class OffersData {
  String? offerId;
  String? offerTitle;
  String? offerTagline;
  String? offerButtonTitle;
  String? category;
  String? goalName;
  String? goalvalue;
  String? offerCode;
  String? offerDesc;
  String? offerAmount;
  String? url;
  String? state;
  String? city;
  String? pincode;
  String? displayOnTasks;
  String? minOffersAvailToDisplay;
  String? terms_and_conditions;
  int? availedusers;
  List<Tasks>? tasks;
  List<Images>? images;
  bool? isBanner;
  String? offerTutorialLink;

  OffersData(
      {this.offerId,
      this.terms_and_conditions,
      this.offerTitle,
      this.offerTagline,
      this.offerButtonTitle,
      this.category,
      this.goalName,
      this.goalvalue,
      this.offerCode,
      this.offerDesc,
      this.offerAmount,
      this.url,
      this.state,
      this.city,
      this.pincode,
      this.displayOnTasks,
      this.minOffersAvailToDisplay,
      this.availedusers,
      this.tasks,
      this.images,
      this.offerTutorialLink,
      this.isBanner = false});

  OffersData.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    terms_and_conditions = json['terms_and_conditions'];
    offerTitle = json['offer_title'];
    offerTagline = json['offer_tagline'];
    offerButtonTitle = json['offer_button_title'];
    category = json['category'];
    goalName = json['goal_name'];
    goalvalue = json['goalvalue'];
    offerCode = json['offer_code'];
    offerDesc = json['offer_desc'];
    offerAmount = json['offer_amount'];
    url = json['url'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    offerTutorialLink = json['offer_tutorial_link'];
    displayOnTasks = json['display_on_tasks'];
    minOffersAvailToDisplay = json['min_offers_avail_to_display'];
    availedusers = json['availedusers'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(Tasks.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_id'] = this.offerId;
    data['terms_and_conditions'] = this.terms_and_conditions;
    data['offer_title'] = this.offerTitle;
    data['offer_tagline'] = this.offerTagline;
    data['offer_button_title'] = this.offerButtonTitle;
    data['category'] = this.category;
    data['goal_name'] = this.goalName;
    data['goalvalue'] = this.goalvalue;
    data['offer_code'] = this.offerCode;
    data['offer_desc'] = this.offerDesc;
    data['offer_amount'] = this.offerAmount;
    data['url'] = this.url;
    data['state'] = this.state;
    data['offer_tutorial_link'] = this.offerTutorialLink;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['display_on_tasks'] = this.displayOnTasks;
    data['min_offers_avail_to_display'] = this.minOffersAvailToDisplay;
    data['availedusers'] = this.availedusers;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  String? taskId;
  String? taskName;
  String? taskPrice;
  String? description;
  String? offerId;
  String? priority;
  bool? isShow;

  Tasks(
      {this.taskId,
      this.taskName,
      this.taskPrice,
      this.description,
      this.offerId,
      this.priority,
      this.isShow});

  Tasks.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskName = json['task_name'];
    taskPrice = json['task_price'];
    description = json['description'];
    offerId = json['offer_id'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['task_name'] = this.taskName;
    data['task_price'] = this.taskPrice;
    data['description'] = this.description;
    data['offer_id'] = this.offerId;
    data['priority'] = this.priority;
    return data;
  }
}

class Images {
  String? offerId;
  String? image;
  String? icon;

  Images({this.offerId, this.image, this.icon});

  Images.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    image = json['image'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_id'] = this.offerId;
    data['image'] = this.image;
    data['icon'] = this.icon;
    return data;
  }
}
