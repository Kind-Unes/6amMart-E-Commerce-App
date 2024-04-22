class PromotionalBanner {
  String? promotionalBannerUrl;
  String? basicSectionNearby;
  String? bottomSectionBanner;

  PromotionalBanner({
    this.promotionalBannerUrl,
    this.basicSectionNearby,
    this.bottomSectionBanner,
  });

  PromotionalBanner.fromJson(Map<String, dynamic> json) {
    promotionalBannerUrl = json['promotional_banner_url'];
    basicSectionNearby = json['basic_section_nearby'];
    bottomSectionBanner = json['bottom_section_banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotional_banner_url'] = promotionalBannerUrl;
    data['basic_section_nearby'] = basicSectionNearby;
    data['bottom_section_banner'] = bottomSectionBanner;
    return data;
  }
}