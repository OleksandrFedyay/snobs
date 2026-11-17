enum ArtistSubgenresStatus {
  newStatus,
  done,
  skipped;

  static String toJson(ArtistSubgenresStatus status) {
    return status.name;
  }

  static ArtistSubgenresStatus fromJson(String? json) {
    if (json == null) return ArtistSubgenresStatus.newStatus;

    return ArtistSubgenresStatus.values.byName(json);
  }
}
