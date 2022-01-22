import 'package:flutter/material.dart';

class LoginRight extends StatefulWidget {
  VoidCallback switching;

  LoginRight(this.switching, {Key? key}) : super(key: key);

  @override
  State<LoginRight> createState() => _LoginRightState();
}

class _LoginRightState extends State<LoginRight> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 400,
          child: ListView(
            shrinkWrap: true,
            children: [
              Form(
                key: _form,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      // initialValue: "ashfaq",
                      decoration: const InputDecoration(labelText: 'Email'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        // FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        // if (value.isEmpty) {
                        //   return 'Please provide a value.';
                        // }
                        return null;
                      },
                      onSaved: (value) {
                        // _editedProduct = Product(
                        //     title: value,
                        //     price: _editedProduct.price,
                        //     description: _editedProduct.description,
                        //     imageUrl: _editedProduct.imageUrl,
                        //     id: _editedProduct.id,
                        //     isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      // initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Password'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      // focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {},
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _saveForm,
                child: const SelectableText("Login"),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  const SelectableText('not registered yet? '),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    // onEnter: (_) {
                    //   widget.switching();
                    // },
                    child: GestureDetector(
                      onTap: () {
                        widget.switching();
                      },
                      child: const Text(
                        'sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SelectableText(' here'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    final is_valid =
        _form.currentState != null ? _form.currentState?.validate() : false;
    if (is_valid == false) {
      return;
    }
    _form.currentState?.save();
  }
}
