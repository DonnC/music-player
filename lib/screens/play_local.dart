import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player_nf/models/music_track.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:math' as math;

class NowPlaying extends StatefulWidget {
  final MusicTrack track;
  final double screenWitdh;

  NowPlaying({this.track, this.screenWitdh});

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = new Duration();
  Duration _position = new Duration();

  // control buttons
  bool _isPlaying = true;
  bool _onRepeat = false;
  bool _onShuffle = false;

  // control audio slider user gesture
  bool isChanged = false;
  bool isEnd = false;

  AudioCache audioCache = new AudioCache();
  AudioPlayer advancedPlayer = new AudioPlayer();

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.onDurationChanged.listen((Duration d) {
      //print('Max duration: $d');
      setState(() => _duration = d);
    });

    advancedPlayer.onAudioPositionChanged.listen((Duration p) {
      //print('Current position: $p');
      setState(() => _position = p);
    });

    // play incoming audio
    audioCache.play('audio/${widget.track.audio}');
  }

  CircularSliderAppearance _appearance = CircularSliderAppearance(
    customColors: CustomSliderColors(
        trackColor: Colors.grey,
        progressBarColor: Colors.black87,
        dotColor: Colors.white,
        hideShadow: true),
    customWidths: CustomSliderWidths(trackWidth: 5, progressBarWidth: 8),
    startAngle: 180,
    angleRange: 180,
    animationEnabled: true,
  );

  Widget _curveSliderPlayer() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: RotatedBox(
        quarterTurns: 2,
        child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            customColors: CustomSliderColors(
                trackColor: Colors.grey,
                progressBarColor: Colors.black87,
                dotColor: Colors.white,
                hideShadow: true),
            customWidths:
                CustomSliderWidths(trackWidth: 5, progressBarWidth: 8),
            startAngle: 180,
            angleRange: 180,
            animationEnabled: true,
            size: widget.screenWitdh * 0.7,
          ),
          initialValue: _position.inSeconds.toDouble(),
          min: 0.0,
          max: _duration.inSeconds.toDouble(),
          onChange: (double value) {
            if (isChanged && isEnd) {
              setState(() {
                seekToSecond(mapDuration(value).toInt());
              });

              isEnd = false;
              isChanged = false;
            }
          },
          onChangeStart: (double value) {
            isChanged = true;
          },
          onChangeEnd: (double value) {
            isEnd = true;
          },
          innerWidget: (double value) {
            // disable default displayed inner percentage text
            return;
          },
        ),
      ),
    );
  }

  double mapDuration(double s) {
    // map duration
    double a1 = 0.0; // slider initially at 0
    double a2 = 248.0; // max range from slider
    double b1 = 0.0; // audio duration initially at 0
    double b2 = _duration.inSeconds.toDouble(); // total duration of audio
    //double s;                 s in range a1-a2..     >>> slider value
    double t; // ..is linearly mapped to a value t in range b1-b2 >>> duration

    t = b1 + (s - a1) * (b2 - b1) / (a2 - a1);

    return t;
  }

  formatLongTime(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0"); // HH:MM:SS
  formatShortTime(Duration d) => d.toString().substring(2, 7); // MM:SS

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
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
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(120.0),
                          bottomRight: Radius.circular(120.0),
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/${widget.track.playingImage}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80.0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.30,
                        right: MediaQuery.of(context).size.width * 0.30,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.track.trackName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            widget.track.artist,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: _curveSliderPlayer(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                formatShortTime(_position),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Align(
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
                            onPressed: () {
                              setState(() {
                                if (_isPlaying == true) {
                                  _isPlaying = false;
                                  advancedPlayer.pause();
                                } else {
                                  _isPlaying = true;
                                }
                              });
                            },
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
            ),
          ],
        ),
      ),
    );
  }
}
