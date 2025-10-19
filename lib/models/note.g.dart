// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteSharingImpl _$$NoteSharingImplFromJson(Map<String, dynamic> json) =>
    _$NoteSharingImpl(
      isPublic: json['isPublic'] as bool? ?? false,
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

Map<String, dynamic> _$$NoteSharingImplToJson(_$NoteSharingImpl instance) =>
    <String, dynamic>{
      'isPublic': instance.isPublic,
      'sharedWithUsers': instance.sharedWithUsers,
      'permission': instance.permission,
      'shareToken': instance.shareToken,
      'shareExpiresAt': instance.shareExpiresAt?.toIso8601String(),
    };

_$NoteRevisionImpl _$$NoteRevisionImplFromJson(Map<String, dynamic> json) =>
    _$NoteRevisionImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['userId'] as String,
      changeDescription: json['changeDescription'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$NoteRevisionImplToJson(_$NoteRevisionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'userId': instance.userId,
      'changeDescription': instance.changeDescription,
      'metadata': instance.metadata,
    };

_$NoteAttachmentImpl _$$NoteAttachmentImplFromJson(Map<String, dynamic> json) =>
    _$NoteAttachmentImpl(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$NoteAttachmentImplToJson(
  _$NoteAttachmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileName': instance.fileName,
  'mimeType': instance.mimeType,
  'fileSize': instance.fileSize,
  'url': instance.url,
  'thumbnailUrl': instance.thumbnailUrl,
  'uploadedAt': instance.uploadedAt.toIso8601String(),
  'metadata': instance.metadata,
};

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  format:
      $enumDecodeNullable(_$NoteFormatEnumMap, json['format']) ??
      NoteFormat.markdown,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  color: json['color'] as String? ?? '',
  isPinned: json['isPinned'] as bool? ?? false,
  isArchived: json['isArchived'] as bool? ?? false,
  isFavorite: json['isFavorite'] as bool? ?? false,
  sharing: json['sharing'] == null
      ? const NoteSharing()
      : NoteSharing.fromJson(json['sharing'] as Map<String, dynamic>),
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => NoteAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  revisions:
      (json['revisions'] as List<dynamic>?)
          ?.map((e) => NoteRevision.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  parentNoteId: json['parentNoteId'] as String?,
  childNoteIds:
      (json['childNoteIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  userId: json['userId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lastViewedAt: json['lastViewedAt'] == null
      ? null
      : DateTime.parse(json['lastViewedAt'] as String),
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'format': _$NoteFormatEnumMap[instance.format]!,
      'tags': instance.tags,
      'color': instance.color,
      'isPinned': instance.isPinned,
      'isArchived': instance.isArchived,
      'isFavorite': instance.isFavorite,
      'sharing': instance.sharing,
      'attachments': instance.attachments,
      'revisions': instance.revisions,
      'parentNoteId': instance.parentNoteId,
      'childNoteIds': instance.childNoteIds,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastViewedAt': instance.lastViewedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$NoteFormatEnumMap = {
  NoteFormat.plain: 'plain',
  NoteFormat.markdown: 'markdown',
  NoteFormat.richText: 'rich_text',
};
