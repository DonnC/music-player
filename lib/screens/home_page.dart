import 'package:flutter/material.dart';
import 'package:music_player_nf/models/music_track.dart';
import 'package:music_player_nf/screens/play_local.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MusicTrack> _tracks = MusicTrack.getTracks();
  MusicTrack _nowPlaying;
  String _artistName = '';
  String _trackName = '';

  // control buttons
  bool _isPlaying = true;
  bool _onRepeat = false;
  bool _onShuffle = false;

  @override
  void initState() {
    setState(() {
      _nowPlaying = _tracks[0];
      _artistName = _nowPlaying.artist;
      _trackName = _nowPlaying.trackName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double witdh = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                    ),
                    onPressed: () => print('back button pressed'),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.grey,
                    ),
                    onPressed: () => print('menu button pressed'),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.85,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(120.0),
                        bottomRight: Radius.circular(120.0),
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/${_nowPlaying.artworkImage}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15.0,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.35,
                      right: MediaQuery.of(context).size.width * 0.35,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          _trackName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          _artistName,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: _tracks.length,
                  itemBuilder: (BuildContext context, int index) {
                    MusicTrack track = _tracks[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlaying(
                              track: track,
                              screenWitdh: witdh,
                            ),
                          ),
                        );
                      },
                      selected: true,
                      leading: Text(
                        track.trackName,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        //'${track.duration}',
                        '5:26',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: _onShuffle ? Colors.black : Colors.grey,
                        size: 20.0,
                      ),
                      onPressed: () => _onShuffle != _onShuffle,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.fast_rewind,
                            color: Colors.black54,
                            size: 20.0,
                          ),
                          onPressed: () => print('rewind pressed'),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        IconButton(
                          icon: Icon(
                            _isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.black54,
                            size: 40.0,
                          ),
                          onPressed: () => _isPlaying != _isPlaying,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.fast_forward,
                            color: Colors.black54,
                            size: 20.0,
                          ),
                          onPressed: () => print('forward pressed'),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        _onRepeat ? Icons.repeat_one : Icons.repeat,
                        color: Colors.black,
                        size: 20.0,
                      ),
                      onPressed: () => _onRepeat != _onRepeat,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
