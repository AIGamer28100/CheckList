// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LinkedProviderImpl _$$LinkedProviderImplFromJson(Map<String, dynamic> json) =>
    _$LinkedProviderImpl(
      providerId: json['providerId'] as String,
      providerType: $enumDecode(
        _$AuthProviderTypeEnumMap,
        json['providerType'],
      ),
      providerUserId: json['providerUserId'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      linkedAt: DateTime.parse(json['linkedAt'] as String),
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.parse(json['lastUsedAt'] as String),
      isPrimary: json['isPrimary'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LinkedProviderImplToJson(
  _$LinkedProviderImpl instance,
) => <String, dynamic>{
  'providerId': instance.providerId,
  'providerType': _$AuthProviderTypeEnumMap[instance.providerType]!,
  'providerUserId': instance.providerUserId,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoUrl': instance.photoUrl,
  'linkedAt': instance.linkedAt.toIso8601String(),
  'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
  'isPrimary': instance.isPrimary,
  'metadata': instance.metadata,
};

const _$AuthProviderTypeEnumMap = {
  AuthProviderType.google: 'google',
  AuthProviderType.github: 'github',
  AuthProviderType.email: 'email',
  AuthProviderType.apple: 'apple',
  AuthProviderType.microsoft: 'microsoft',
  AuthProviderType.anonymous: 'anonymous',
};
