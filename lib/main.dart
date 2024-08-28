import 'package:flutter/material.dart';

List<String> titles = <String>[
  'IMC Calculator',
  'Payments Adjustments',
];

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _peso = TextEditingController();
  TextEditingController _altura = TextEditingController();
  String _result = "";

  @override
  void initState() {
    super.initState();
    limpaCampos();
  }

  void limpaCampos() {
    _peso.text = '';
    _altura.text = '';
    setState(() {
      _result = '';
    });
  }

  Color _resultColor = Colors.transparent;

  void calcularIMC() {
    double _pe = double.parse(_peso.text);
    double _alt = double.parse(_altura.text);
    double _condicao = _pe / (_alt * _alt);

    String mensagem;

    if (_condicao < 18.5) {
      mensagem = "Abaixo do peso";
      _resultColor = Colors.yellow; // Cor amarela
    } else if (_condicao >= 18.5 && _condicao <= 24.9) {
      mensagem = "Peso ideal (parabéns)";
      _resultColor = Colors.green; // Cor verde
    } else if (_condicao >= 25.0 && _condicao <= 29.9) {
      mensagem = "Levemente acima do peso";
      _resultColor = Colors.yellow; // Cor amarela
    } else {
      mensagem = _condicao >= 30.0 && _condicao <= 34.9
          ? "Obesidade grau I"
          : _condicao >= 35.0 && _condicao <= 39.9
              ? "Obesidade grau II (severa)"
              : "Obesidade grau III (mórbida)";
      _resultColor = Colors.red; // Cor vermelha para obesidade
    }

    setState(() {
      _result = "IMC: ${_condicao.toStringAsFixed(2)}\n$mensagem";
    });
  }

  // Calcular Ajustes de pagamento

  TextEditingController _salario = TextEditingController();
  String _reajusteResult = "";

  void calculaReajuste() {
    double salarioAtual = double.parse(_salario.text);
    double aumento;
    double novoSalario;
    String percentual;

    if (salarioAtual <= 280.0) {
      aumento = salarioAtual * 0.20;
      percentual = "20%";
    } else if (salarioAtual > 280.0 && salarioAtual <= 700.0) {
      aumento = salarioAtual * 0.15;
      percentual = "15%";
    } else if (salarioAtual > 700.0 && salarioAtual <= 1500.0) {
      aumento = salarioAtual * 0.10;
      percentual = "10%";
    } else {
      aumento = salarioAtual * 0.05;
      percentual = "5%";
    }

    novoSalario = salarioAtual + aumento;

    setState(() {
      _reajusteResult =
          "Salário atual: R\$ ${salarioAtual.toStringAsFixed(2)}\n"
          "Percentual de aumento: $percentual\n"
          "Valor do aumento: R\$ ${aumento.toStringAsFixed(2)}\n"
          "Novo salário: R\$ ${novoSalario.toStringAsFixed(2)}";
    });
  }

  Widget buildCalcularButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            calcularIMC();
          }
        },
        child: Text('Calcular Condição',
            style: TextStyle(color: const Color.fromARGB(255, 34, 139, 205))),
      ),
    );
  }

  // Buil do ajuste de pagamento

  Widget buildPaymentAdjustments() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Salário atual"),
            controller: _salario,
            validator: (text) {
              return text!.isEmpty ? "Insira o salário" : null;
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_salario.text.isNotEmpty) {
                calculaReajuste();
              }
            },
            child: Text('Calcular Reajuste'),
          ),
          SizedBox(height: 16.0),
          Text(
            _reajusteResult,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildTextResult() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        color: _resultColor, // Define a cor do fundo
        padding: EdgeInsets.all(16.0),
        child: Text(
          _result,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 2;

    return MaterialApp(
      // Adicionando MaterialApp aqui
      home: DefaultTabController(
        initialIndex: 0,
        length: tabsCount,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('App da Joas Interprises'),
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            scrolledUnderElevation: 4.0,
            shadowColor: Theme.of(context).shadowColor,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: const Icon(Icons.monitor_heart),
                  text: titles[0],
                ),
                Tab(
                  icon: const Icon(Icons.payments),
                  text: titles[1],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      buildTextFormField(
                          label: "Peso",
                          error: "Insira o peso (63)",
                          controller: _peso),
                      buildTextFormField(
                          label: "Altura",
                          error: "Insira a altura (1.72)",
                          controller: _altura),
                      buildCalcularButton(),
                      buildTextResult(),
                    ],
                  ),
                ),
              ),
              buildPaymentAdjustments(), // Placeholder for the second tab
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      {required TextEditingController controller,
      required String error,
      required String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text!.isEmpty ? error : null;
      },
    );
  }
}
