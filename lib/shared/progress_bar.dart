import 'package:flutter/material.dart';
import '../services/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AnimatedProgressbar extends StatelessWidget {
  final double value;
  final double height;

  AnimatedProgressbar({Key key, @required this.value, this.height = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          padding: EdgeInsets.all(10),
          width: box.maxWidth,
          // Remember a stack is just a widget that accepts children which will layer on top of each other. Our first layer is the dark grey background of the progress bar, and on top of it is our colored progress bar which has the exact same dimensions.
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: box.maxWidth * _floor(value),
                decoration: BoxDecoration(
                  color: _colorGen(value),
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Always round negative or NaNs to min value
  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  _colorGen(double value) {
    int rbg = (value * 255).toInt();
    return Colors.deepOrange.withGreen(rbg).withRed(255 - rbg);
  }
}

class QuizBadge extends StatelessWidget {
  final String quizId;

  const QuizBadge({Key key, this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);

    if (report != null) {
      bool completed = report.quizComplete;
      if (completed == true) {
        return Icon(FontAwesomeIcons.checkDouble, color: Colors.green);
      } else {
        return Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
      }
    } else {
      return Icon(FontAwesomeIcons.circle, color: Colors.grey);
    }
  }
}

class QuizProgress extends StatelessWidget {
  const QuizProgress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    return Row(
      children: [
        _progressCount(report),
        Expanded(
          child:
              AnimatedProgressbar(value: _calculateProgress(report), height: 8),
        ),
      ],
    );
  }

  Widget _progressCount(Report report) {
    if (report != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          '${report.completedQuizQuestions ?? 0} / ${report.totalQuizQuestions ?? 0}',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      );
    } else {
      return Container();
    }
  }

  double _calculateProgress(Report report) {
    try {
      int totalQuizQuestions = report.totalQuizQuestions;
      int completedQuizQuestions = report.completedQuizQuestions;
      return completedQuizQuestions / totalQuizQuestions;
    } catch (err) {
      return 0.0;
    }
  }
}
