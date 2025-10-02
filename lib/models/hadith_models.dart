class HadithNarrator {
  final String slug;
  final String name;
  final String description;

  HadithNarrator({
    required this.slug,
    required this.name,
    required this.description,
  });

  factory HadithNarrator.fromJson(Map<String, dynamic> json) {
    return HadithNarrator(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Hadith {
  final int number;
  final String narrator;
  final String arab;
  final String indonesian;
  final String? grade;
  final String? theme;

  Hadith({
    required this.number,
    required this.narrator,
    required this.arab,
    required this.indonesian,
    this.grade,
    this.theme,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      number: json['number'] ?? 0,
      narrator: json['narrator'] ?? '',
      arab: json['arab'] ?? '',
      indonesian: json['indonesia'] ??
          json['indonesian'] ??
          '', // Try both possible field names
      grade: json['grade'],
      theme: json['theme'],
    );
  }
}

class HadithPagination {
  final int currentPage;
  final int perPage;
  final int totalItems;
  final int totalPages;

  HadithPagination({
    required this.currentPage,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  factory HadithPagination.fromJson(Map<String, dynamic> json) {
    return HadithPagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      totalItems: json['total_items'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

class HadithResponse {
  final String status;
  final String message;
  final List<Hadith> data;
  final HadithPagination? pagination;

  HadithResponse({
    required this.status,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory HadithResponse.fromJson(Map<String, dynamic> json) {
    var hadithList = <Hadith>[];
    if (json['data'] != null) {
      if (json['data'] is List) {
        hadithList = (json['data'] as List)
            .map((item) => Hadith.fromJson(item))
            .toList();
      } else if (json['data'] is Map) {
        hadithList = [Hadith.fromJson(json['data'])];
      }
    }

    return HadithResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: hadithList,
      pagination: json['pagination'] != null
          ? HadithPagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class NarratorsResponse {
  final String status;
  final String message;
  final List<HadithNarrator> data;

  NarratorsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NarratorsResponse.fromJson(Map<String, dynamic> json) {
    var narratorList = <HadithNarrator>[];
    if (json['data'] != null && json['data'] is List) {
      narratorList = (json['data'] as List)
          .map((item) => HadithNarrator.fromJson(item))
          .toList();
    }

    return NarratorsResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: narratorList,
    );
  }
}
