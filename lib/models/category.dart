import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Category color theme
enum CategoryColor {
  @JsonValue('blue')
  blue,
  @JsonValue('red')
  red,
  @JsonValue('green')
  green,
  @JsonValue('orange')
  orange,
  @JsonValue('purple')
  purple,
  @JsonValue('pink')
  pink,
  @JsonValue('teal')
  teal,
  @JsonValue('yellow')
  yellow,
  @JsonValue('indigo')
  indigo,
  @JsonValue('gray')
  gray,
}

/// Category icon options
enum CategoryIcon {
  @JsonValue('work')
  work,
  @JsonValue('personal')
  personal,
  @JsonValue('shopping')
  shopping,
  @JsonValue('health')
  health,
  @JsonValue('education')
  education,
  @JsonValue('finance')
  finance,
  @JsonValue('travel')
  travel,
  @JsonValue('home')
  home,
  @JsonValue('hobby')
  hobby,
  @JsonValue('social')
  social,
  @JsonValue('sports')
  sports,
  @JsonValue('food')
  food,
  @JsonValue('car')
  car,
  @JsonValue('tech')
  tech,
  @JsonValue('default')
  defaultIcon,
}

/// Category sharing settings
@freezed
class CategorySharing with _$CategorySharing {
  const factory CategorySharing({
    @Default(false) bool isShared,
    @Default([]) List<String> sharedWithUsers,
    @Default('view') String permission, // 'view', 'edit', 'admin'
    String? shareToken,
    DateTime? shareExpiresAt,
  }) = _CategorySharing;

  factory CategorySharing.fromJson(Map<String, dynamic> json) =>
      _$CategorySharingFromJson(json);
}

/// Category model for organizing tasks and notes
@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    @Default(CategoryColor.blue) CategoryColor color,
    @Default(CategoryIcon.defaultIcon) CategoryIcon icon,
    @Default(false) bool isDefault,
    @Default(false) bool isArchived,
    @Default(CategorySharing()) CategorySharing sharing,
    String? parentCategoryId,
    @Default([]) List<String> childCategoryIds,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(0) int sortOrder,
    @Default({}) Map<String, dynamic> metadata,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

/// Extension methods for Category
extension CategoryExtensions on Category {
  /// Check if category has child categories
  bool get hasChildren => childCategoryIds.isNotEmpty;

  /// Check if category is a child category
  bool get isChild => parentCategoryId != null;

  /// Check if category is shared with others
  bool get isShared => sharing.isShared || sharing.sharedWithUsers.isNotEmpty;

  /// Get category depth level (0 for root, 1 for first level child, etc.)
  int getCategoryDepth(List<Category> allCategories) {
    if (!isChild) return 0;

    final parent = allCategories
        .where((cat) => cat.id == parentCategoryId)
        .firstOrNull;

    if (parent == null) return 0;
    return 1 + parent.getCategoryDepth(allCategories);
  }

  /// Get all ancestor categories
  List<Category> getAncestors(List<Category> allCategories) {
    final ancestors = <Category>[];
    Category? current = this;

    while (current != null && current.isChild) {
      final parent = allCategories
          .where((cat) => cat.id == current!.parentCategoryId)
          .firstOrNull;

      if (parent != null) {
        ancestors.insert(0, parent);
        current = parent;
      } else {
        break;
      }
    }

    return ancestors;
  }

  /// Get all descendant categories
  List<Category> getDescendants(List<Category> allCategories) {
    final descendants = <Category>[];

    void addDescendants(String categoryId) {
      final children = allCategories
          .where((cat) => cat.parentCategoryId == categoryId)
          .toList();

      for (final child in children) {
        descendants.add(child);
        addDescendants(child.id);
      }
    }

    addDescendants(id);
    return descendants;
  }

  /// Get breadcrumb path (e.g., "Work > Projects > Mobile App")
  String getBreadcrumbPath(List<Category> allCategories) {
    final ancestors = getAncestors(allCategories);
    final path = [...ancestors.map((cat) => cat.name), name];
    return path.join(' > ');
  }

  /// Archive the category
  Category archive() {
    return copyWith(isArchived: true, updatedAt: DateTime.now());
  }

  /// Unarchive the category
  Category unarchive() {
    return copyWith(isArchived: false, updatedAt: DateTime.now());
  }

  /// Update category details
  Category updateDetails({
    String? newName,
    String? newDescription,
    CategoryColor? newColor,
    CategoryIcon? newIcon,
  }) {
    return copyWith(
      name: newName ?? name,
      description: newDescription ?? description,
      color: newColor ?? color,
      icon: newIcon ?? icon,
      updatedAt: DateTime.now(),
    );
  }

  /// Move category to new parent
  Category moveToParent(String? newParentId) {
    return copyWith(parentCategoryId: newParentId, updatedAt: DateTime.now());
  }

  /// Update sort order
  Category updateSortOrder(int newOrder) {
    return copyWith(sortOrder: newOrder, updatedAt: DateTime.now());
  }

  /// Add child category
  Category addChild(String childId) {
    if (childCategoryIds.contains(childId)) return this;
    final updatedChildren = [...childCategoryIds, childId];
    return copyWith(
      childCategoryIds: updatedChildren,
      updatedAt: DateTime.now(),
    );
  }

  /// Remove child category
  Category removeChild(String childId) {
    final updatedChildren = childCategoryIds
        .where((id) => id != childId)
        .toList();
    return copyWith(
      childCategoryIds: updatedChildren,
      updatedAt: DateTime.now(),
    );
  }

  /// Update sharing settings
  Category updateSharing(CategorySharing newSharing) {
    return copyWith(sharing: newSharing, updatedAt: DateTime.now());
  }

  /// Check if user can perform an action based on sharing permissions
  bool canUserPerform(String userId, String action) {
    // Owner can do everything
    if (this.userId == userId) return true;

    // Check if user is in shared list
    if (!sharing.sharedWithUsers.contains(userId)) return false;

    switch (action) {
      case 'view':
        return true; // All shared users can view
      case 'edit':
        return sharing.permission == 'edit' || sharing.permission == 'admin';
      case 'admin':
        return sharing.permission == 'admin';
      default:
        return false;
    }
  }
}
