import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomValueChooser extends StatefulWidget {
  final List<String> values;
  final Function(String) onSelectedParam;

  CustomValueChooser({this.values, this.onSelectedParam});

  @override
  _CustomValueChooserState createState() => _CustomValueChooserState();
}

class _CustomValueChooserState extends State<CustomValueChooser> {
  int selectedValueIndex = 0;
  String value = "";
  CarouselSlider slider;
  void _previousValue() {
    if (selectedValueIndex > 0) {
      setState(() {
        slider.previousPage(duration: Duration(milliseconds: 200),curve: Curves.bounceIn);
        selectedValueIndex--;
        widget.onSelectedParam(widget.values[selectedValueIndex]);
      });
    }
  }

  void _nextValue() {
    if (selectedValueIndex < widget.values.length - 1) {
      setState(() {
        slider.nextPage(duration: Duration(milliseconds: 200),curve: Curves.bounceIn);
        selectedValueIndex++;
        widget.onSelectedParam(widget.values[selectedValueIndex]);
      });
    }
  }

  String getSelectedValue() {
    return widget.values[selectedValueIndex];
  }
  @override
  void initState() {
    slider = new CarouselSlider(
      onPageChanged: (int index){
        selectedValueIndex = index;
      },
      enableInfiniteScroll: false,
      viewportFraction: 1,
      initialPage: selectedValueIndex,
      items: widget.values.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: 40,
              child: Text(i,textAlign: TextAlign.center,),
            );
          },
        );
      }).toList(),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _previousValue,
          child: Icon(Icons.arrow_back_ios),
        ),
        Container(
          constraints: BoxConstraints(minWidth: 50 ,maxWidth: 50, maxHeight: 20),
          child: slider,
        ),
        GestureDetector(
          onTap: _nextValue,
          child: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }
}
