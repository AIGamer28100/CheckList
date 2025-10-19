// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'linked_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LinkedProvider _$LinkedProviderFromJson(Map<String, dynamic> json) {
  return _LinkedProvider.fromJson(json);
}

/// @nodoc
mixin _$LinkedProvider {
  String get providerId => throw _privateConstructorUsedError;
  AuthProviderType get providerType => throw _privateConstructorUsedError;
  String get providerUserId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  DateTime get linkedAt => throw _privateConstructorUsedError;
  DateTime? get lastUsedAt => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this LinkedProvider to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LinkedProvider
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LinkedProviderCopyWith<LinkedProvider> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkedProviderCopyWith<$Res> {
  factory $LinkedProviderCopyWith(
    LinkedProvider value,
    $Res Function(LinkedProvider) then,
  ) = _$LinkedProviderCopyWithImpl<$Res, LinkedProvider>;
  @useResult
  $Res call({
    String providerId,
    AuthProviderType providerType,
    String providerUserId,
    String email,
    String? displayName,
    String? photoUrl,
    DateTime linkedAt,
    DateTime? lastUsedAt,
    bool isPrimary,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$LinkedProviderCopyWithImpl<$Res, $Val extends LinkedProvider>
    implements $LinkedProviderCopyWith<$Res> {
  _$LinkedProviderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinkedProvider
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providerId = null,
    Object? providerType = null,
    Object? providerUserId = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? linkedAt = null,
    Object? lastUsedAt = freezed,
    Object? isPrimary = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            providerId: null == providerId
                ? _value.providerId
                : providerId // ignore: cast_nullable_to_non_nullable
                      as String,
            providerType: null == providerType
                ? _value.providerType
                : providerType // ignore: cast_nullable_to_non_nullable
                      as AuthProviderType,
            providerUserId: null == providerUserId
                ? _value.providerUserId
                : providerUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            linkedAt: null == linkedAt
                ? _value.linkedAt
                : linkedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastUsedAt: freezed == lastUsedAt
                ? _value.lastUsedAt
                : lastUsedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isPrimary: null == isPrimary
                ? _value.isPrimary
                : isPrimary // ignore: cast_nullable_to_non_nullable
                      as bool,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LinkedProviderImplCopyWith<$Res>
    implements $LinkedProviderCopyWith<$Res> {
  factory _$$LinkedProviderImplCopyWith(
    _$LinkedProviderImpl value,
    $Res Function(_$LinkedProviderImpl) then,
  ) = __$$LinkedProviderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String providerId,
    AuthProviderType providerType,
    String providerUserId,
    String email,
    String? displayName,
    String? photoUrl,
    DateTime linkedAt,
    DateTime? lastUsedAt,
    bool isPrimary,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$LinkedProviderImplCopyWithImpl<$Res>
    extends _$LinkedProviderCopyWithImpl<$Res, _$LinkedProviderImpl>
    implements _$$LinkedProviderImplCopyWith<$Res> {
  __$$LinkedProviderImplCopyWithImpl(
    _$LinkedProviderImpl _value,
    $Res Function(_$LinkedProviderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkedProvider
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? providerId = null,
    Object? providerType = null,
    Object? providerUserId = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? linkedAt = null,
    Object? lastUsedAt = freezed,
    Object? isPrimary = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$LinkedProviderImpl(
        providerId: null == providerId
            ? _value.providerId
            : providerId // ignore: cast_nullable_to_non_nullable
                  as String,
        providerType: null == providerType
            ? _value.providerType
            : providerType // ignore: cast_nullable_to_non_nullable
                  as AuthProviderType,
        providerUserId: null == providerUserId
            ? _value.providerUserId
            : providerUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        linkedAt: null == linkedAt
            ? _value.linkedAt
            : linkedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastUsedAt: freezed == lastUsedAt
            ? _value.lastUsedAt
            : lastUsedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isPrimary: null == isPrimary
            ? _value.isPrimary
            : isPrimary // ignore: cast_nullable_to_non_nullable
                  as bool,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LinkedProviderImpl implements _LinkedProvider {
  const _$LinkedProviderImpl({
    required this.providerId,
    required this.providerType,
    required this.providerUserId,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.linkedAt,
    this.lastUsedAt,
    required this.isPrimary,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$LinkedProviderImpl.fromJson(Map<String, dynamic> json) =>
      _$$LinkedProviderImplFromJson(json);

  @override
  final String providerId;
  @override
  final AuthProviderType providerType;
  @override
  final String providerUserId;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? photoUrl;
  @override
  final DateTime linkedAt;
  @override
  final DateTime? lastUsedAt;
  @override
  final bool isPrimary;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'LinkedProvider(providerId: $providerId, providerType: $providerType, providerUserId: $providerUserId, email: $email, displayName: $displayName, photoUrl: $photoUrl, linkedAt: $linkedAt, lastUsedAt: $lastUsedAt, isPrimary: $isPrimary, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkedProviderImpl &&
            (identical(other.providerId, providerId) ||
                other.providerId == providerId) &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType) &&
            (identical(other.providerUserId, providerUserId) ||
                other.providerUserId == providerUserId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.linkedAt, linkedAt) ||
                other.linkedAt == linkedAt) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    providerId,
    providerType,
    providerUserId,
    email,
    displayName,
    photoUrl,
    linkedAt,
    lastUsedAt,
    isPrimary,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of LinkedProvider
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkedProviderImplCopyWith<_$LinkedProviderImpl> get copyWith =>
      __$$LinkedProviderImplCopyWithImpl<_$LinkedProviderImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LinkedProviderImplToJson(this);
  }
}

abstract class _LinkedProvider implements LinkedProvider {
  const factory _LinkedProvider({
    required final String providerId,
    required final AuthProviderType providerType,
    required final String providerUserId,
    required final String email,
    final String? displayName,
    final String? photoUrl,
    required final DateTime linkedAt,
    final DateTime? lastUsedAt,
    required final bool isPrimary,
    final Map<String, dynamic>? metadata,
  }) = _$LinkedProviderImpl;

  factory _LinkedProvider.fromJson(Map<String, dynamic> json) =
      _$LinkedProviderImpl.fromJson;

  @override
  String get providerId;
  @override
  AuthProviderType get providerType;
  @override
  String get providerUserId;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get photoUrl;
  @override
  DateTime get linkedAt;
  @override
  DateTime? get lastUsedAt;
  @override
  bool get isPrimary;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of LinkedProvider
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkedProviderImplCopyWith<_$LinkedProviderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
