// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NoteSharing _$NoteSharingFromJson(Map<String, dynamic> json) {
  return _NoteSharing.fromJson(json);
}

/// @nodoc
mixin _$NoteSharing {
  bool get isPublic => throw _privateConstructorUsedError;
  List<String> get sharedWithUsers => throw _privateConstructorUsedError;
  String get permission =>
      throw _privateConstructorUsedError; // 'view', 'edit', 'comment'
  String? get shareToken => throw _privateConstructorUsedError;
  DateTime? get shareExpiresAt => throw _privateConstructorUsedError;

  /// Serializes this NoteSharing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteSharing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteSharingCopyWith<NoteSharing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteSharingCopyWith<$Res> {
  factory $NoteSharingCopyWith(
    NoteSharing value,
    $Res Function(NoteSharing) then,
  ) = _$NoteSharingCopyWithImpl<$Res, NoteSharing>;
  @useResult
  $Res call({
    bool isPublic,
    List<String> sharedWithUsers,
    String permission,
    String? shareToken,
    DateTime? shareExpiresAt,
  });
}

/// @nodoc
class _$NoteSharingCopyWithImpl<$Res, $Val extends NoteSharing>
    implements $NoteSharingCopyWith<$Res> {
  _$NoteSharingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteSharing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPublic = null,
    Object? sharedWithUsers = null,
    Object? permission = null,
    Object? shareToken = freezed,
    Object? shareExpiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
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
abstract class _$$NoteSharingImplCopyWith<$Res>
    implements $NoteSharingCopyWith<$Res> {
  factory _$$NoteSharingImplCopyWith(
    _$NoteSharingImpl value,
    $Res Function(_$NoteSharingImpl) then,
  ) = __$$NoteSharingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isPublic,
    List<String> sharedWithUsers,
    String permission,
    String? shareToken,
    DateTime? shareExpiresAt,
  });
}

/// @nodoc
class __$$NoteSharingImplCopyWithImpl<$Res>
    extends _$NoteSharingCopyWithImpl<$Res, _$NoteSharingImpl>
    implements _$$NoteSharingImplCopyWith<$Res> {
  __$$NoteSharingImplCopyWithImpl(
    _$NoteSharingImpl _value,
    $Res Function(_$NoteSharingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoteSharing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPublic = null,
    Object? sharedWithUsers = null,
    Object? permission = null,
    Object? shareToken = freezed,
    Object? shareExpiresAt = freezed,
  }) {
    return _then(
      _$NoteSharingImpl(
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
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
class _$NoteSharingImpl implements _NoteSharing {
  const _$NoteSharingImpl({
    this.isPublic = false,
    final List<String> sharedWithUsers = const [],
    this.permission = 'view',
    this.shareToken,
    this.shareExpiresAt,
  }) : _sharedWithUsers = sharedWithUsers;

  factory _$NoteSharingImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteSharingImplFromJson(json);

  @override
  @JsonKey()
  final bool isPublic;
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
  // 'view', 'edit', 'comment'
  @override
  final String? shareToken;
  @override
  final DateTime? shareExpiresAt;

  @override
  String toString() {
    return 'NoteSharing(isPublic: $isPublic, sharedWithUsers: $sharedWithUsers, permission: $permission, shareToken: $shareToken, shareExpiresAt: $shareExpiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteSharingImpl &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
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
    isPublic,
    const DeepCollectionEquality().hash(_sharedWithUsers),
    permission,
    shareToken,
    shareExpiresAt,
  );

  /// Create a copy of NoteSharing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteSharingImplCopyWith<_$NoteSharingImpl> get copyWith =>
      __$$NoteSharingImplCopyWithImpl<_$NoteSharingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteSharingImplToJson(this);
  }
}

abstract class _NoteSharing implements NoteSharing {
  const factory _NoteSharing({
    final bool isPublic,
    final List<String> sharedWithUsers,
    final String permission,
    final String? shareToken,
    final DateTime? shareExpiresAt,
  }) = _$NoteSharingImpl;

  factory _NoteSharing.fromJson(Map<String, dynamic> json) =
      _$NoteSharingImpl.fromJson;

  @override
  bool get isPublic;
  @override
  List<String> get sharedWithUsers;
  @override
  String get permission; // 'view', 'edit', 'comment'
  @override
  String? get shareToken;
  @override
  DateTime? get shareExpiresAt;

  /// Create a copy of NoteSharing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteSharingImplCopyWith<_$NoteSharingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NoteRevision _$NoteRevisionFromJson(Map<String, dynamic> json) {
  return _NoteRevision.fromJson(json);
}

/// @nodoc
mixin _$NoteRevision {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get changeDescription => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this NoteRevision to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteRevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteRevisionCopyWith<NoteRevision> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteRevisionCopyWith<$Res> {
  factory $NoteRevisionCopyWith(
    NoteRevision value,
    $Res Function(NoteRevision) then,
  ) = _$NoteRevisionCopyWithImpl<$Res, NoteRevision>;
  @useResult
  $Res call({
    String id,
    String content,
    DateTime timestamp,
    String userId,
    String? changeDescription,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$NoteRevisionCopyWithImpl<$Res, $Val extends NoteRevision>
    implements $NoteRevisionCopyWith<$Res> {
  _$NoteRevisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteRevision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? timestamp = null,
    Object? userId = null,
    Object? changeDescription = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            changeDescription: freezed == changeDescription
                ? _value.changeDescription
                : changeDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NoteRevisionImplCopyWith<$Res>
    implements $NoteRevisionCopyWith<$Res> {
  factory _$$NoteRevisionImplCopyWith(
    _$NoteRevisionImpl value,
    $Res Function(_$NoteRevisionImpl) then,
  ) = __$$NoteRevisionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String content,
    DateTime timestamp,
    String userId,
    String? changeDescription,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$NoteRevisionImplCopyWithImpl<$Res>
    extends _$NoteRevisionCopyWithImpl<$Res, _$NoteRevisionImpl>
    implements _$$NoteRevisionImplCopyWith<$Res> {
  __$$NoteRevisionImplCopyWithImpl(
    _$NoteRevisionImpl _value,
    $Res Function(_$NoteRevisionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoteRevision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? timestamp = null,
    Object? userId = null,
    Object? changeDescription = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _$NoteRevisionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        changeDescription: freezed == changeDescription
            ? _value.changeDescription
            : changeDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$NoteRevisionImpl implements _NoteRevision {
  const _$NoteRevisionImpl({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.userId,
    this.changeDescription,
    final Map<String, dynamic> metadata = const {},
  }) : _metadata = metadata;

  factory _$NoteRevisionImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteRevisionImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final DateTime timestamp;
  @override
  final String userId;
  @override
  final String? changeDescription;
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
    return 'NoteRevision(id: $id, content: $content, timestamp: $timestamp, userId: $userId, changeDescription: $changeDescription, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteRevisionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.changeDescription, changeDescription) ||
                other.changeDescription == changeDescription) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    content,
    timestamp,
    userId,
    changeDescription,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of NoteRevision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteRevisionImplCopyWith<_$NoteRevisionImpl> get copyWith =>
      __$$NoteRevisionImplCopyWithImpl<_$NoteRevisionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteRevisionImplToJson(this);
  }
}

abstract class _NoteRevision implements NoteRevision {
  const factory _NoteRevision({
    required final String id,
    required final String content,
    required final DateTime timestamp,
    required final String userId,
    final String? changeDescription,
    final Map<String, dynamic> metadata,
  }) = _$NoteRevisionImpl;

  factory _NoteRevision.fromJson(Map<String, dynamic> json) =
      _$NoteRevisionImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  String get userId;
  @override
  String? get changeDescription;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of NoteRevision
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteRevisionImplCopyWith<_$NoteRevisionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NoteAttachment _$NoteAttachmentFromJson(Map<String, dynamic> json) {
  return _NoteAttachment.fromJson(json);
}

/// @nodoc
mixin _$NoteAttachment {
  String get id => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  DateTime get uploadedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this NoteAttachment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteAttachmentCopyWith<NoteAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteAttachmentCopyWith<$Res> {
  factory $NoteAttachmentCopyWith(
    NoteAttachment value,
    $Res Function(NoteAttachment) then,
  ) = _$NoteAttachmentCopyWithImpl<$Res, NoteAttachment>;
  @useResult
  $Res call({
    String id,
    String fileName,
    String mimeType,
    int fileSize,
    String url,
    String? thumbnailUrl,
    DateTime uploadedAt,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$NoteAttachmentCopyWithImpl<$Res, $Val extends NoteAttachment>
    implements $NoteAttachmentCopyWith<$Res> {
  _$NoteAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? mimeType = null,
    Object? fileSize = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? uploadedAt = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            mimeType: null == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String,
            fileSize: null == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            uploadedAt: null == uploadedAt
                ? _value.uploadedAt
                : uploadedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NoteAttachmentImplCopyWith<$Res>
    implements $NoteAttachmentCopyWith<$Res> {
  factory _$$NoteAttachmentImplCopyWith(
    _$NoteAttachmentImpl value,
    $Res Function(_$NoteAttachmentImpl) then,
  ) = __$$NoteAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fileName,
    String mimeType,
    int fileSize,
    String url,
    String? thumbnailUrl,
    DateTime uploadedAt,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$NoteAttachmentImplCopyWithImpl<$Res>
    extends _$NoteAttachmentCopyWithImpl<$Res, _$NoteAttachmentImpl>
    implements _$$NoteAttachmentImplCopyWith<$Res> {
  __$$NoteAttachmentImplCopyWithImpl(
    _$NoteAttachmentImpl _value,
    $Res Function(_$NoteAttachmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoteAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? mimeType = null,
    Object? fileSize = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? uploadedAt = null,
    Object? metadata = null,
  }) {
    return _then(
      _$NoteAttachmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        mimeType: null == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String,
        fileSize: null == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        uploadedAt: null == uploadedAt
            ? _value.uploadedAt
            : uploadedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$NoteAttachmentImpl implements _NoteAttachment {
  const _$NoteAttachmentImpl({
    required this.id,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
    required this.url,
    this.thumbnailUrl,
    required this.uploadedAt,
    final Map<String, dynamic> metadata = const {},
  }) : _metadata = metadata;

  factory _$NoteAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteAttachmentImplFromJson(json);

  @override
  final String id;
  @override
  final String fileName;
  @override
  final String mimeType;
  @override
  final int fileSize;
  @override
  final String url;
  @override
  final String? thumbnailUrl;
  @override
  final DateTime uploadedAt;
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
    return 'NoteAttachment(id: $id, fileName: $fileName, mimeType: $mimeType, fileSize: $fileSize, url: $url, thumbnailUrl: $thumbnailUrl, uploadedAt: $uploadedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteAttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fileName,
    mimeType,
    fileSize,
    url,
    thumbnailUrl,
    uploadedAt,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of NoteAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteAttachmentImplCopyWith<_$NoteAttachmentImpl> get copyWith =>
      __$$NoteAttachmentImplCopyWithImpl<_$NoteAttachmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteAttachmentImplToJson(this);
  }
}

abstract class _NoteAttachment implements NoteAttachment {
  const factory _NoteAttachment({
    required final String id,
    required final String fileName,
    required final String mimeType,
    required final int fileSize,
    required final String url,
    final String? thumbnailUrl,
    required final DateTime uploadedAt,
    final Map<String, dynamic> metadata,
  }) = _$NoteAttachmentImpl;

  factory _NoteAttachment.fromJson(Map<String, dynamic> json) =
      _$NoteAttachmentImpl.fromJson;

  @override
  String get id;
  @override
  String get fileName;
  @override
  String get mimeType;
  @override
  int get fileSize;
  @override
  String get url;
  @override
  String? get thumbnailUrl;
  @override
  DateTime get uploadedAt;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of NoteAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteAttachmentImplCopyWith<_$NoteAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Note _$NoteFromJson(Map<String, dynamic> json) {
  return _Note.fromJson(json);
}

/// @nodoc
mixin _$Note {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  NoteFormat get format => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  NoteSharing get sharing => throw _privateConstructorUsedError;
  List<NoteAttachment> get attachments => throw _privateConstructorUsedError;
  List<NoteRevision> get revisions => throw _privateConstructorUsedError;
  String? get parentNoteId => throw _privateConstructorUsedError;
  List<String> get childNoteIds => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get lastViewedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this Note to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    NoteFormat format,
    List<String> tags,
    String color,
    bool isPinned,
    bool isArchived,
    bool isFavorite,
    NoteSharing sharing,
    List<NoteAttachment> attachments,
    List<NoteRevision> revisions,
    String? parentNoteId,
    List<String> childNoteIds,
    String userId,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastViewedAt,
    Map<String, dynamic> metadata,
  });

  $NoteSharingCopyWith<$Res> get sharing;
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? format = null,
    Object? tags = null,
    Object? color = null,
    Object? isPinned = null,
    Object? isArchived = null,
    Object? isFavorite = null,
    Object? sharing = null,
    Object? attachments = null,
    Object? revisions = null,
    Object? parentNoteId = freezed,
    Object? childNoteIds = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastViewedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as NoteFormat,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            isPinned: null == isPinned
                ? _value.isPinned
                : isPinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFavorite: null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            sharing: null == sharing
                ? _value.sharing
                : sharing // ignore: cast_nullable_to_non_nullable
                      as NoteSharing,
            attachments: null == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<NoteAttachment>,
            revisions: null == revisions
                ? _value.revisions
                : revisions // ignore: cast_nullable_to_non_nullable
                      as List<NoteRevision>,
            parentNoteId: freezed == parentNoteId
                ? _value.parentNoteId
                : parentNoteId // ignore: cast_nullable_to_non_nullable
                      as String?,
            childNoteIds: null == childNoteIds
                ? _value.childNoteIds
                : childNoteIds // ignore: cast_nullable_to_non_nullable
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
            lastViewedAt: freezed == lastViewedAt
                ? _value.lastViewedAt
                : lastViewedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NoteSharingCopyWith<$Res> get sharing {
    return $NoteSharingCopyWith<$Res>(_value.sharing, (value) {
      return _then(_value.copyWith(sharing: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NoteImplCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$NoteImplCopyWith(
    _$NoteImpl value,
    $Res Function(_$NoteImpl) then,
  ) = __$$NoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    NoteFormat format,
    List<String> tags,
    String color,
    bool isPinned,
    bool isArchived,
    bool isFavorite,
    NoteSharing sharing,
    List<NoteAttachment> attachments,
    List<NoteRevision> revisions,
    String? parentNoteId,
    List<String> childNoteIds,
    String userId,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? lastViewedAt,
    Map<String, dynamic> metadata,
  });

  @override
  $NoteSharingCopyWith<$Res> get sharing;
}

/// @nodoc
class __$$NoteImplCopyWithImpl<$Res>
    extends _$NoteCopyWithImpl<$Res, _$NoteImpl>
    implements _$$NoteImplCopyWith<$Res> {
  __$$NoteImplCopyWithImpl(_$NoteImpl _value, $Res Function(_$NoteImpl) _then)
    : super(_value, _then);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? format = null,
    Object? tags = null,
    Object? color = null,
    Object? isPinned = null,
    Object? isArchived = null,
    Object? isFavorite = null,
    Object? sharing = null,
    Object? attachments = null,
    Object? revisions = null,
    Object? parentNoteId = freezed,
    Object? childNoteIds = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastViewedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _$NoteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as NoteFormat,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        isPinned: null == isPinned
            ? _value.isPinned
            : isPinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFavorite: null == isFavorite
            ? _value.isFavorite
            : isFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        sharing: null == sharing
            ? _value.sharing
            : sharing // ignore: cast_nullable_to_non_nullable
                  as NoteSharing,
        attachments: null == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<NoteAttachment>,
        revisions: null == revisions
            ? _value._revisions
            : revisions // ignore: cast_nullable_to_non_nullable
                  as List<NoteRevision>,
        parentNoteId: freezed == parentNoteId
            ? _value.parentNoteId
            : parentNoteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        childNoteIds: null == childNoteIds
            ? _value._childNoteIds
            : childNoteIds // ignore: cast_nullable_to_non_nullable
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
        lastViewedAt: freezed == lastViewedAt
            ? _value.lastViewedAt
            : lastViewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$NoteImpl implements _Note {
  const _$NoteImpl({
    required this.id,
    required this.title,
    required this.content,
    this.format = NoteFormat.markdown,
    final List<String> tags = const [],
    this.color = '',
    this.isPinned = false,
    this.isArchived = false,
    this.isFavorite = false,
    this.sharing = const NoteSharing(),
    final List<NoteAttachment> attachments = const [],
    final List<NoteRevision> revisions = const [],
    this.parentNoteId,
    final List<String> childNoteIds = const [],
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.lastViewedAt,
    final Map<String, dynamic> metadata = const {},
  }) : _tags = tags,
       _attachments = attachments,
       _revisions = revisions,
       _childNoteIds = childNoteIds,
       _metadata = metadata;

  factory _$NoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  @JsonKey()
  final NoteFormat format;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final String color;
  @override
  @JsonKey()
  final bool isPinned;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final NoteSharing sharing;
  final List<NoteAttachment> _attachments;
  @override
  @JsonKey()
  List<NoteAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final List<NoteRevision> _revisions;
  @override
  @JsonKey()
  List<NoteRevision> get revisions {
    if (_revisions is EqualUnmodifiableListView) return _revisions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_revisions);
  }

  @override
  final String? parentNoteId;
  final List<String> _childNoteIds;
  @override
  @JsonKey()
  List<String> get childNoteIds {
    if (_childNoteIds is EqualUnmodifiableListView) return _childNoteIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childNoteIds);
  }

  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastViewedAt;
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
    return 'Note(id: $id, title: $title, content: $content, format: $format, tags: $tags, color: $color, isPinned: $isPinned, isArchived: $isArchived, isFavorite: $isFavorite, sharing: $sharing, attachments: $attachments, revisions: $revisions, parentNoteId: $parentNoteId, childNoteIds: $childNoteIds, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, lastViewedAt: $lastViewedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.format, format) || other.format == format) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.sharing, sharing) || other.sharing == sharing) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
            const DeepCollectionEquality().equals(
              other._revisions,
              _revisions,
            ) &&
            (identical(other.parentNoteId, parentNoteId) ||
                other.parentNoteId == parentNoteId) &&
            const DeepCollectionEquality().equals(
              other._childNoteIds,
              _childNoteIds,
            ) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastViewedAt, lastViewedAt) ||
                other.lastViewedAt == lastViewedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    content,
    format,
    const DeepCollectionEquality().hash(_tags),
    color,
    isPinned,
    isArchived,
    isFavorite,
    sharing,
    const DeepCollectionEquality().hash(_attachments),
    const DeepCollectionEquality().hash(_revisions),
    parentNoteId,
    const DeepCollectionEquality().hash(_childNoteIds),
    userId,
    createdAt,
    updatedAt,
    lastViewedAt,
    const DeepCollectionEquality().hash(_metadata),
  ]);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      __$$NoteImplCopyWithImpl<_$NoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteImplToJson(this);
  }
}

abstract class _Note implements Note {
  const factory _Note({
    required final String id,
    required final String title,
    required final String content,
    final NoteFormat format,
    final List<String> tags,
    final String color,
    final bool isPinned,
    final bool isArchived,
    final bool isFavorite,
    final NoteSharing sharing,
    final List<NoteAttachment> attachments,
    final List<NoteRevision> revisions,
    final String? parentNoteId,
    final List<String> childNoteIds,
    required final String userId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? lastViewedAt,
    final Map<String, dynamic> metadata,
  }) = _$NoteImpl;

  factory _Note.fromJson(Map<String, dynamic> json) = _$NoteImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  NoteFormat get format;
  @override
  List<String> get tags;
  @override
  String get color;
  @override
  bool get isPinned;
  @override
  bool get isArchived;
  @override
  bool get isFavorite;
  @override
  NoteSharing get sharing;
  @override
  List<NoteAttachment> get attachments;
  @override
  List<NoteRevision> get revisions;
  @override
  String? get parentNoteId;
  @override
  List<String> get childNoteIds;
  @override
  String get userId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get lastViewedAt;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
