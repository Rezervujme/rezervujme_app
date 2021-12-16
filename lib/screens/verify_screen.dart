import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void _verifyPin() {
    print(_textEditingController.text);
    context.vRouter.to('/tabs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potvrdenie'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 8),
                child: Text(
                  'Potvrdenie',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const Text(
                'Zadajte pin, ktorý sme zaslali na vaše telefónne číslo.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: TextField(
                  autofocus: true,
                  controller: _textEditingController,
                  onSubmitted: (_) => _verifyPin(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: '0000'),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 32),
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: _textEditingController.text.isEmpty
                          ? null
                          : _verifyPin,
                      child: const Text(
                        'Potvrdiť',
                        style: TextStyle(fontSize: 16),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
