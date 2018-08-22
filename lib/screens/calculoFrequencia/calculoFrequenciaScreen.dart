import 'package:flutter/material.dart';
import 'dart:math';

class CalculoFrequenciaScreen extends StatefulWidget {
  @override
  CalculoFrequenciaScreenState createState() => new CalculoFrequenciaScreenState();
}

class CalculoFrequenciaScreenState extends State<CalculoFrequenciaScreen> {
  TextEditingController textFieldController = new TextEditingController();
  var table = new List<List<String>>();
  List<int> arrayNumeros;
  int k = 0;
  int h = 0;

  var demoValue = '27,27,18,18,19,19,20,20,22,22,22,22,22,22,23,23,23,23,23,23,24,24,24,24,25,26,26,27,27,28,28,28,29,30,30,33,34,20,21,21';

  void initTable(){
    table = new List<List<String>>();
    table.add([
      'Classes','FS','FA','FR%','FRA%','Pto.Med'
    ]);
  }

  void reset(){
    setState(() {
      initTable();
      k = 0;
      h = 0;
      textFieldController.clear();
    });
  }

  void demonstration(){
    textFieldController.text = demoValue;
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return int.parse(s) != null;
  }

  _calcular(){
    initTable();
    arrayNumeros = new List<int>();
    var arrayStr = textFieldController.text.split(',');
    //empty or not number
    if(arrayStr.length <= 1 || arrayStr.every((n) => !isNumeric(n))) return;
    //prepare array number
    arrayNumeros = arrayStr.map((n) => int.parse(n)).toList();
    arrayNumeros.sort();
    //calc
    k = (1 + 3.3 * (log(arrayNumeros.length) / log(10))).round();
    h = ((arrayNumeros[arrayNumeros.length -1] - arrayNumeros[0]) / k).round();
    var _class = new List<int>();
    var _frequency = new List<int>();
    var n1 = arrayNumeros[0];
    //class
    for (var i = 0; i < k; i++) {
      _class.add(n1);
      _class.add(n1 + h);
      var nPlus1 = n1 + h;
      if(i == k -1 && nPlus1 == arrayNumeros[arrayNumeros.length-1])
        nPlus1++;
        _frequency.add((arrayNumeros.where((n) => n >= n1 && n < nPlus1).length));
        n1 += h;
    }
    var _cumulativeFrequency = 0;
    var _cumulativeFrequencyTotal = _frequency.fold(0, (curr, next) => curr + next);
    var _accumulatedFrequencyPercentage = 0.0;
    var _accumulatedFrequencyPercentageAccumulated = 0.0;
    //fill table
    for (var i = 0; i < _frequency.length; i++) {
      _cumulativeFrequency += _frequency[i];
      _accumulatedFrequencyPercentage = ((_frequency[i] / _cumulativeFrequencyTotal) * 100);
      _accumulatedFrequencyPercentageAccumulated += _accumulatedFrequencyPercentage;
      var listTmp = [
        _class[i * 2].toString() + '---' + _class[i * 2 + 1].toString(),
        _frequency[i].toString(),
        _cumulativeFrequency.toString(),
        _accumulatedFrequencyPercentage.toStringAsFixed(2) + '%',
        _accumulatedFrequencyPercentageAccumulated.toStringAsFixed(2) + '%',
        ((_class[i * 2] + _class[i * 2 + 1]) / 2).toString()
      ];
      table.add(listTmp);
    }
  }

  void initState() {
    super.initState();
    initTable();
  }

  TextStyle txtStyle = new TextStyle(
    fontSize: 20.0
  );

  @override
  Widget build(BuildContext context) {
    var cellsWidth = MediaQuery.of(context).size.width /3.5 - 20.0;
    return new Scaffold(
      appBar: new AppBar(
        title: new Center(child: new Text('Calculo de frequência')),
      ),
      body: new Column(
        children: [
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.symmetric(horizontal: 15.0),
                child: new TextField(
                  controller: textFieldController,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    hintText: 'Insira numeros separados por virgula (,)'
                  ),
                  maxLines: 7
                ),
              ),
              new Container(
                padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text('Calcular'),
                      onPressed: (){
                        setState(() {
                          _calcular();
                          textFieldController.text = arrayNumeros.join(',');                   
                        });
                      },
                    ),
                    new RaisedButton(
                      child: new Text('Limpar'),
                      onPressed: () => reset() 
                    ),
                    new RaisedButton(
                      child: new Text('Demo'),
                      onPressed: () => demonstration() 
                    )
                  ],
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text('K: ' + k.toString(), style: new TextStyle(fontSize: 24.0)),
                  new Text(' || ', style: new TextStyle(fontSize: 24.0)),
                  new Text(' H: ' + h.toString(), style: new TextStyle(fontSize: 24.0))
                ],
              )
            ]
          ),
          //tabela
          new Expanded(
            flex: 1,
            child: new SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: new SingleChildScrollView(
                child: new Column(
                  children: List.generate(table.length, (int row) =>
                    new Container(
                      decoration: new BoxDecoration(color: row % 2 == 0 ? Colors.blueGrey[100] : Colors.blueAccent[100]),
                      child: new Row(
                        children: List.generate(table[row].length, (int col)=>
                          new Container(
                            width: cellsWidth * (col == 0 ? 1.5 : 1.0),
                            alignment: Alignment.center,
                            child: new Text(table[row][col], style: txtStyle),
                          ),
                        ).toList()
                      )
                    )
                  ).toList(),
                )
              )
            )
          )
        ]
      )
    );
  }
}