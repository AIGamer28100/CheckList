import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

/// Note format types
enum NoteFormat {
  @JsonValue('plain')
  plain,
  @JsonValue('markdown')
  markdown,
  @JsonValue('rich_text')
  richText,
}

/// Note sharing settings
@freezed
class NoteSharing with _$NoteSharing {
  const factory NoteSharing({
    @Default(false) bool isPublic,
    @Default([]) List<String> sharedWithUsers,
    @Default('view') String permission, // 'view', 'edit', 'comment'
    String? shareToken,
    DateTime? shareExpiresAt,
  }) = _NoteSharing;

  factory NoteSharing.fromJson(Map<String, dynamic> json) =>
      _$NoteSharingFromJson(json);
}

/// Note revision for version history
@freezed
class NoteRevision with _$NoteRevision {
  const factory NoteRevision({
    required String id,
    required String content,
    required DateTime timestamp,
    required String userId,
    String? changeDescription,
    @Default({}) Map<String, dynamic> metadata,
  }) = _NoteRevision;

  factory NoteRevision.fromJson(Map<String, dynamic> json) =>
      _$NoteRevisionFromJson(json);
}

/// Rich text attachment
@freezed
class NoteAttachment with _$NoteAttachment {
  const factory NoteAttachment({
    required String id,
    required String fileName,
    required String mimeType,
    required int fileSize,
    required String url,
    String? thumbnailUrl,
    required DateTime uploadedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _NoteAttachment;

  factory NoteAttachment.fromJson(Map<String, dynamic> json) =>
      _$NoteAttachmentFromJson(json);
}

/// Note model for rich note-taking functionality
@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String content,
    @Default(NoteFormat.markdown) NoteFormat format,
    @Default([]) List<String> tags,
    @Default('') String color,
    @Default(false) bool isPinned,
    @Default(false) bool isArchived,
    @Default(false) bool isFavorite,
    @Default(NoteSharing()) NoteSharing sharing,
    @Default([]) List<NoteAttachment> attachments,
    @Default([]) List<NoteRevision> revisions,
    String? parentNoteId,
    @Default([]) List<String> childNoteIds,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastViewedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

/// Extension methods for Note
extension NoteExtensions on Note {
  /// Get word count of the note content
  int get wordCount {
    if (content.isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  /// Get character count of the note content
  int get characterCount => content.length;

  /// Get reading time estimate (assuming 200 words per minute)
  Duration get estimatedReadingTime {
    final words = wordCount;
    final minutes = (words / 200).ceil();
    return Duration(minutes: minutes);
  }

  /// Check if note has been modified recently (within last 24 hours)
  bool get isRecentlyModified {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);
    return difference.inHours < 24;
  }

  /// Check if note is shared with others
  bool get isShared => sharing.isPublic || sharing.sharedWithUsers.isNotEmpty;

  /// Check if note has attachments
  bool get hasAttachments => attachments.isNotEmpty;

  /// Check if note has child notes (is a parent note)
  bool get hasChildNotes => childNoteIds.isNotEmpty;

  /// Check if note is a child note
  bool get isChildNote => parentNoteId != null;

  /// Get total attachment size in bytes
  int get totalAttachmentSize {
    return attachments.fold<int>(
      0,
      (total, attachment) => total + attachment.fileSize,
    );
  }

  /// Get formatted attachment size string
  String get formattedAttachmentSize {
    final bytes = totalAttachmentSize;
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// Archive the note
  Note archive() {
    return copyWith(isArchived: true, updatedAt: DateTime.now());
  }

  /// Unarchive the note
  Note unarchive() {
    return copyWith(isArchived: false, updatedAt: DateTime.now());
  }

  /// Pin the note
  Note pin() {
    return copyWith(isPinned: true, updatedAt: DateTime.now());
  }

  /// Unpin the note
  Note unpin() {
    return copyWith(isPinned: false, updatedAt: DateTime.now());
  }

  /// Add to favorites
  Note addToFavorites() {
    return copyWith(isFavorite: true, updatedAt: DateTime.now());
  }

  /// Remove from favorites
  Note removeFromFavorites() {
    return copyWith(isFavorite: false, updatedAt: DateTime.now());
  }

  /// Update content and add revision
  Note updateContent(String newContent, {String? changeDescription}) {
    final revision = NoteRevision(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      userId: userId,
      changeDescription: changeDescription,
    );

    final updatedRevisions = [...revisions];
    updatedRevisions.add(revision);

    // Keep only last 50 revisions
    if (updatedRevisions.length > 50) {
      updatedRevisions.removeAt(0);
    }

    return copyWith(
      content: newContent,
      revisions: updatedRevisions,
      updatedAt: DateTime.now(),
    );
  }

  /// Add tag to note
  Note addTag(String tag) {
    if (tags.contains(tag)) return this;
    final updatedTags = [...tags, tag];
    return copyWith(tags: updatedTags, updatedAt: DateTime.now());
  }

  /// Remove tag from note
  Note removeTag(String tag) {
    final updatedTags = tags.where((t) => t != tag).toList();
    return copyWith(tags: updatedTags, updatedAt: DateTime.now());
  }

  /// Add attachment to note
  Note addAttachment(NoteAttachment attachment) {
    final updatedAttachments = [...attachments, attachment];
    return copyWith(attachments: updatedAttachments, updatedAt: DateTime.now());
  }

  /// Remove attachment from note
  Note removeAttachment(String attachmentId) {
    final updatedAttachments = attachments
        .where((att) => att.id != attachmentId)
        .toList();
    return copyWith(attachments: updatedAttachments, updatedAt: DateTime.now());
  }

  /// Update last viewed timestamp
  Note markAsViewed() {
    return copyWith(lastViewedAt: DateTime.now());
  }

  /// Create a child note
  Note addChildNote(String childNoteId) {
    if (childNoteIds.contains(childNoteId)) return this;
    final updatedChildIds = [...childNoteIds, childNoteId];
    return copyWith(childNoteIds: updatedChildIds, updatedAt: DateTime.now());
  }

  /// Remove a child note
  Note removeChildNote(String childNoteId) {
    final updatedChildIds = childNoteIds
        .where((id) => id != childNoteId)
        .toList();
    return copyWith(childNoteIds: updatedChildIds, updatedAt: DateTime.now());
  }
}
