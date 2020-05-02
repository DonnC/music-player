class MusicTrack{
  int id;
  String artist;
  String trackName;
  String audio;
  String artworkImage;
  String playingImage;

  MusicTrack(this.id, this.artist, this.trackName, this.artworkImage, this.playingImage, this.audio);

  static List<MusicTrack> getTracks()
  {
    return <MusicTrack>[
      MusicTrack(
        0,
        'NF',
        'The Search',
        'nf_art.jpg',
        'nf_main.jpg',
        'nf_paid_my_dues.mp3',
      ),
      MusicTrack(
        1,
        'NF',
        'Outcast',
        'nf_art.jpg',
        'nf_main.jpg',
        'nf_paid_my_dues.mp3',
      ),
      MusicTrack(
        2,
        'NF',
        '15 Feet Down',
        'nf_art.jpg',
        'nf_main.jpg',
        'nf.mp3',
      ),
      MusicTrack(
        3,
        'NF',
        'Notepad',
        'nf_art.jpg',
        'nf_main.jpg',
        'nf.mp3',
      ),
      MusicTrack(
        4,
        'NF',
        'Grindin',
        'nf_art.jpg',
        'nf_main.jpg',
        'nf_paid_my_dues.mp3',
      ),
    ];
  }
}