// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategorySharing _$CategorySharingFromJson(Map<String, dynamic> json) {
  return _CategorySharing.fromJson(json);
}

/// @nodoc
mixin _$CategorySharing {
  bool get isShared => throw _privateConstructorUsedError;
  List<String> get sharedWithUsers => throw _privateConstructorUsedError;
  String get permission =>
      throw _privateConstructorUsedError; // 'view', 'edit', 'admin'
  String? get shareToken => throw _privateConstructorUsedError;
  DateTime? get shareExpiresAt => throw _privateConstructorUsedError;

  /// Serializes this CategorySharing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategorySharing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySharingCopyWith<CategorySharing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySharingCopyWith<$Res> {
  factory $CategorySharingCopyWith(
    CategorySharing value,
    $Res Function(CategorySharing) then,
  ) = _$CategorySharingCopyWithImpl<$Res, CategorySharing>;
  @useResult
  $Res call({
    bool isShared,
    List<String> sharedWithUsers,
    String permission,
    String? shareToken,
    DateTime? shareExpiresAt,
  });
}

/// @nodoc
class _$CategorySharingCopyWithImpl<$Res, $Val extends CategorySharing>
    implements $CategorySharingCopyWith<$Res> {
  _$CategorySharingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategorySharing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShared = null,
    Object? sharedWithUsers = null,
    Object? permission = null,
    Object? shareToken = freezed,
    Object? shareExpiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            isShared: null == isShared
                ? _value.isShared
                : isShared // ignore: cast_nullable_to_non_nullable
                      as bool,
            sharedWithUsers: null == sharedWithUsers
                ? _value.sharedWithUsers
                : sharedWithUsers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            permission: null == permission
                ? _value.permission
                : permission // ignore: cast_nullable_to_non_nullable
                      as String,
            shareToken: freezed == shareToken
                ? _value.shareToken
                : shareToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            shareExpiresAt: freezed == shareExpiresAt
                ? _value.shareExpiresAt
                : shareExpiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategorySharingImplCopyWith<$Res>
    implements $CategorySharingCopyWith<$Res> {
  factory _$$CategorySharingImplCopyWith(
    _$CategorySharingImpl value,
    $Res Function(_$CategorySharingImpl) then,
  ) = __$$CategorySharingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isShared,
    List<String> sharedWithUsers,
    String permission,
    String? shareToken,
    DateTime? shareExpiresAt,
  });
}

/// @nodoc
class __$$CategorySharingImplCopyWithImpl<$Res>
    extends _$CategorySharingCopyWithImpl<$Res, _$CategorySharingImpl>
    implements _$$CategorySharingImplCopyWith<$Res> {
  __$$CategorySharingImplCopyWithImpl(
    _$CategorySharingImpl _value,
    $Res Function(_$CategorySharingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategorySharing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isShared = null,
    Object? sharedWithUsers = null,
    Object? permission = null,
    Object? shareToken = freezed,
    Object? shareExpiresAt = freezed,
  }) {
    return _then(
      _$CategorySharingImpl(
        isShared: null == isShared
            ? _value.isShared
            : isShared // ignore: cast_nullable_to_non_nullable
                  as bool,
        sharedWithUsers: null == sharedWithUsers
            ? _value._sharedWithUsers
            : sharedWithUsers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        permission: null == permission
            ? _value.permission
            : permission // ignore: cast_nullable_to_non_nullable
                  as String,
        shareToken: freezed == shareToken
            ? _value.shareToken
            : shareToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        shareExpiresAt: freezed == shareExpiresAt
            ? _value.shareExpiresAt
            : shareExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategorySharingImpl implements _CategorySharing {
  const _$CategorySharingImpl({
    this.isShared = false,
    final List<String> sharedWithUsers = const [],
    this.permission = 'view',
    this.shareToken,
    this.shareExpiresAt,
  }) : _sharedWithUsers = sharedWithUsers;

  factory _$CategorySharingImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategorySharingImplFromJson(json);

  @override
  @JsonKey()
  final bool isShared;
  final List<String> _sharedWithUsers;
  @override
  @JsonKey()
  List<String> get sharedWithUsers {
    if (_sharedWithUsers is EqualUnmodifiableListView) return _sharedWithUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedWithUsers);
  }

  @override
  @JsonKey()
  final String permission;
  // 'view', 'edit', 'admin'
  @override
  final String? shareToken;
  @override
  final DateTime? shareExpiresAt;

  @override
  String toString() {
    return 'CategorySharing(isShared: $isShared, sharedWithUsers: $sharedWithUsers, permission: $permission, shareToken: $shareToken, shareExpiresAt: $shareExpiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySharingImpl &&
            (identical(other.isShared, isShared) ||
                other.isShared == isShared) &&
            const DeepCollectionEquality().equals(
              other._sharedWithUsers,
              _sharedWithUsers,
            ) &&
            (identical(other.permission, permission) ||
                other.permission == permission) &&
            (identical(other.shareToken, shareToken) ||
                other.shareToken == shareToken) &&
            (identical(other.shareExpiresAt, shareExpiresAt) ||
                other.shareExpiresAt == shareExpiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isShared,
    const DeepCollectionEquality().hash(_sharedWithUsers),
    permission,
    shareToken,
    shareExpiresAt,
  );

  /// Create a copy of CategorySharing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySharingImplCopyWith<_$CategorySharingImpl> get copyWith =>
      __$$CategorySharingImplCopyWithImpl<_$CategorySharingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorySharingImplToJson(this);
  }
}

abstract class _CategorySharing implements CategorySharing {
  const factory _CategorySharing({
    final bool isShared,
    final List<String> sharedWithUsers,
    final String permission,
    final String? shareToken,
    final DateTime? shareExpiresAt,
  }) = _$CategorySharingImpl;

  factory _CategorySharing.fromJson(Map<String, dynamic> json) =
      _$CategorySharingImpl.fromJson;

  @override
  bool get isShared;
  @override
  List<String> get sharedWithUsers;
  @override
  String get permission; // 'view', 'edit', 'admin'
  @override
  String? get shareToken;
  @override
  DateTime? get shareExpiresAt;

  /// Create a copy of CategorySharing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySharingImplCopyWith<_$CategorySharingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  CategoryColor get color => throw _privateConstructorUsedError;
  CategoryIcon get icon => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  CategorySharing get sharing => throw _privateConstructorUsedError;
  String? get parentCategoryId => throw _privateConstructorUsedError;
  List<String> get childCategoryIds => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    CategoryColor color,
    CategoryIcon icon,
    bool isDefault,
    bool isArchived,
    CategorySharing sharing,
    String? parentCategoryId,
    List<String> childCategoryIds,
    String userId,
    DateTime createdAt,
    DateTime updatedAt,
    int sortOrder,
    Map<String, dynamic> metadata,
  });

  $CategorySharingCopyWith<$Res> get sharing;
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? color = null,
    Object? icon = null,
    Object? isDefault = null,
    Object? isArchived = null,
    Object? sharing = null,
    Object? parentCategoryId = freezed,
    Object? childCategoryIds = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sortOrder = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as CategoryColor,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as CategoryIcon,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            sharing: null == sharing
                ? _value.sharing
                : sharing // ignore: cast_nullable_to_non_nullable
                      as CategorySharing,
            parentCategoryId: freezed == parentCategoryId
                ? _value.parentCategoryId
                : parentCategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            childCategoryIds: null == childCategoryIds
                ? _value.childCategoryIds
                : childCategoryIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategorySharingCopyWith<$Res> get sharing {
    return $CategorySharingCopyWith<$Res>(_value.sharing, (value) {
      return _then(_value.copyWith(sharing: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
    _$CategoryImpl value,
    $Res Function(_$CategoryImpl) then,
  ) = __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    CategoryColor color,
    CategoryIcon icon,
    bool isDefault,
    bool isArchived,
    CategorySharing sharing,
    String? parentCategoryId,
    List<String> childCategoryIds,
    String userId,
    DateTime createdAt,
    DateTime updatedAt,
    int sortOrder,
    Map<String, dynamic> metadata,
  });

  @override
  $CategorySharingCopyWith<$Res> get sharing;
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
    _$CategoryImpl _value,
    $Res Function(_$CategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? color = null,
    Object? icon = null,
    Object? isDefault = null,
    Object? isArchived = null,
    Object? sharing = null,
    Object? parentCategoryId = freezed,
    Object? childCategoryIds = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sortOrder = null,
    Object? metadata = null,
  }) {
    return _then(
      _$CategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as CategoryColor,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as CategoryIcon,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        sharing: null == sharing
            ? _value.sharing
            : sharing // ignore: cast_nullable_to_non_nullable
                  as CategorySharing,
        parentCategoryId: freezed == parentCategoryId
            ? _value.parentCategoryId
            : parentCategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        childCategoryIds: null == childCategoryIds
            ? _value._childCategoryIds
            : childCategoryIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryImpl implements _Category {
  const _$CategoryImpl({
    required this.id,
    required this.name,
    this.description,
    this.color = CategoryColor.blue,
    this.icon = CategoryIcon.defaultIcon,
    this.isDefault = false,
    this.isArchived = false,
    this.sharing = const CategorySharing(),
    this.parentCategoryId,
    final List<String> childCategoryIds = const [],
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.sortOrder = 0,
    final Map<String, dynamic> metadata = const {},
  }) : _childCategoryIds = childCategoryIds,
       _metadata = metadata;

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final CategoryColor color;
  @override
  @JsonKey()
  final CategoryIcon icon;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final CategorySharing sharing;
  @override
  final String? parentCategoryId;
  final List<String> _childCategoryIds;
  @override
  @JsonKey()
  List<String> get childCategoryIds {
    if (_childCategoryIds is EqualUnmodifiableListView)
      return _childCategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childCategoryIds);
  }

  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int sortOrder;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, color: $color, icon: $icon, isDefault: $isDefault, isArchived: $isArchived, sharing: $sharing, parentCategoryId: $parentCategoryId, childCategoryIds: $childCategoryIds, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, sortOrder: $sortOrder, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.sharing, sharing) || other.sharing == sharing) &&
            (identical(other.parentCategoryId, parentCategoryId) ||
                other.parentCategoryId == parentCategoryId) &&
            const DeepCollectionEquality().equals(
              other._childCategoryIds,
              _childCategoryIds,
            ) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    color,
    icon,
    isDefault,
    isArchived,
    sharing,
    parentCategoryId,
    const DeepCollectionEquality().hash(_childCategoryIds),
    userId,
    createdAt,
    updatedAt,
    sortOrder,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(this);
  }
}

abstract class _Category implements Category {
  const factory _Category({
    required final String id,
    required final String name,
    final String? description,
    final CategoryColor color,
    final CategoryIcon icon,
    final bool isDefault,
    final bool isArchived,
    final CategorySharing sharing,
    final String? parentCategoryId,
    final List<String> childCategoryIds,
    required final String userId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final int sortOrder,
    final Map<String, dynamic> metadata,
  }) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  CategoryColor get color;
  @override
  CategoryIcon get icon;
  @override
  bool get isDefault;
  @override
  bool get isArchived;
  @override
  CategorySharing get sharing;
  @override
  String? get parentCategoryId;
  @override
  List<String> get childCategoryIds;
  @override
  String get userId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get sortOrder;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
