import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  VoidCallback switching;

  SignUpPage(this.switching, {Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
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
                      decoration: const InputDecoration(labelText: 'Name'),
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
                      // initialValue: "ashfaq",
                      decoration: const InputDecoration(labelText: 'Phone'),
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
                    TextFormField(
                      // initialValue: _initValues['price'],
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
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
                child: const SelectableText("sign up"),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(),
              //     ),
              //     const SelectableText('not registered yet? '),
              //     SelectableText(
              //       'sign up',
              //       style: const TextStyle(
              //         color: Colors.blue,
              //         decoration: TextDecoration.underline,
              //       ),
              //       onTap: () {
              //         widget.switching();
              //       },
              //     ),
              //     const SelectableText(' here'),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    widget.switching();
    // final is_valid =
    //     _form.currentState != null ? _form.currentState?.validate() : false;
    // if (is_valid == false) {
    //   return;
    // }
    // _form.currentState?.save();
  }
}
