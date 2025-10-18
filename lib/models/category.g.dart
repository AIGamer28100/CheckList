// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategorySharingImpl _$$CategorySharingImplFromJson(
  Map<String, dynamic> json,
) => _$CategorySharingImpl(
  isShared: json['isShared'] as bool? ?? false,
  sharedWithUsers:
      (json['sharedWithUsers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  permission: json['permission'] as String? ?? 'view',
  shareToken: json['shareToken'] as String?,
  shareExpiresAt: json['shareExpiresAt'] == null
      ? null
      : DateTime.parse(json['shareExpiresAt'] as String),
);

Map<String, dynamic> _$$CategorySharingImplToJson(
  _$CategorySharingImpl instance,
) => <String, dynamic>{
  'isShared': instance.isShared,
  'sharedWithUsers': instance.sharedWithUsers,
  'permission': instance.permission,
  'shareToken': instance.shareToken,
  'shareExpiresAt': instance.shareExpiresAt?.toIso8601String(),
};

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      color:
          $enumDecodeNullable(_$CategoryColorEnumMap, json['color']) ??
          CategoryColor.blue,
      icon:
          $enumDecodeNullable(_$CategoryIconEnumMap, json['icon']) ??
          CategoryIcon.defaultIcon,
      isDefault: json['isDefault'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      sharing: json['sharing'] == null
          ? const CategorySharing()
          : CategorySharing.fromJson(json['sharing'] as Map<String, dynamic>),
      parentCategoryId: json['parentCategoryId'] as String?,
      childCategoryIds:
          (json['childCategoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': _$CategoryColorEnumMap[instance.color]!,
      'icon': _$CategoryIconEnumMap[instance.icon]!,
      'isDefault': instance.isDefault,
      'isArchived': instance.isArchived,
      'sharing': instance.sharing,
      'parentCategoryId': instance.parentCategoryId,
      'childCategoryIds': instance.childCategoryIds,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'sortOrder': instance.sortOrder,
      'metadata': instance.metadata,
    };

const _$CategoryColorEnumMap = {
  CategoryColor.blue: 'blue',
  CategoryColor.red: 'red',
  CategoryColor.green: 'green',
  CategoryColor.orange: 'orange',
  CategoryColor.purple: 'purple',
  CategoryColor.pink: 'pink',
  CategoryColor.teal: 'teal',
  CategoryColor.yellow: 'yellow',
  CategoryColor.indigo: 'indigo',
  CategoryColor.gray: 'gray',
};

const _$CategoryIconEnumMap = {
  CategoryIcon.work: 'work',
  CategoryIcon.personal: 'personal',
  CategoryIcon.shopping: 'shopping',
  CategoryIcon.health: 'health',
  CategoryIcon.education: 'education',
  CategoryIcon.finance: 'finance',
  CategoryIcon.travel: 'travel',
  CategoryIcon.home: 'home',
  CategoryIcon.hobby: 'hobby',
  CategoryIcon.social: 'social',
  CategoryIcon.sports: 'sports',
  CategoryIcon.food: 'food',
  CategoryIcon.car: 'car',
  CategoryIcon.tech: 'tech',
  CategoryIcon.defaultIcon: 'default',
};
